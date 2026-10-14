#!/bin/sh
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2026 the Larder software contributors
#
# run-tests.sh              run every check against ../4-BUILD
# run-tests.sh --self-test  run a green baseline, then plant each known fault in a COPY of
#                           4-BUILD and demand the suite goes red on the check named for it
# run-tests.sh --plant NAME run the suite on a copy carrying one fault
# run-tests.sh --faults     list the faults
# run-tests.sh --tree DIR   run the suite on any copy of 4-BUILD (mutate-lines.sh uses this)
# Exit 0 only if everything asked for passed. A check that needs a tool this machine
# lacks prints SKIP; the summary counts skips so they cannot hide.
set -u
LC_ALL=C
export LC_ALL

ROOT=$(cd "$(dirname "$0")/.." && pwd)
SRC=$ROOT/4-BUILD
SH=${SH:-dash}
command -v "$SH" >/dev/null 2>&1 || SH=sh
SHP=$(command -v "$SH")
W=$(mktemp -d) || exit 70
trap 'rm -rf "$W"' EXIT INT TERM
PROFILES="minimal desktop homelab hardened fullsink"
TAB=$(printf '\t')
REQUIRED="live-boot live-config cryptsetup cryptsetup-initramfs wireguard-tools network-manager larder-tools"

# ---------------------------------------------------------------- helpers
n=0 nfail=0 nskip=0 FAILED=
check() {   # check ID "what it shows" command...   (c_ names: the checks use plain names like id)
    c_id=$1 c_desc=$2; shift 2
    n=$((n + 1))
    if "$@" > "$S/last.out" 2>&1; then
        echo "ok $n - $c_id $c_desc"
    else
        echo "not ok $n - $c_id $c_desc"
        head -n 8 "$S/last.out" | sed 's/^/#   /'
        nfail=$((nfail + 1)); FAILED="$FAILED $c_id"
    fi
}
skip() { n=$((n + 1)); nskip=$((nskip + 1)); echo "ok $n - $1 # SKIP $2"; }

pkgs() { grep -v '^#' "$1"; }                       # a generated list without its comment header
choice_rows() { awk -F'|' '/^choice/ { split($1, h, " "); a = $4; r = $5; gsub(/^ +| +$/, "", a); gsub(/^ +| +$/, "", r); print h[2] "\t" a "\t" r }' "$B/recipes.conf"; }
choice_text() { awk -F'|' '/^choice/ { split($1, h, " "); l = $2; e = $3; gsub(/^ +| +$/, "", l); gsub(/^ +| +$/, "", e); if (!(h[2] in s)) { s[h[2]] = 1; print h[2] "\t" l "\t" e } }' "$B/recipes.conf"; }
unesc() { sed 's/&quot;/"/g; s/&lt;/</g; s/&gt;/>/g; s/&amp;/\&/g'; }
choice_ids() { choice_rows | awk -F'\t' '!s[$1]++ { print $1 }'; }
page_ids() {
    case $1 in
        *.html) sed -n 's/.*href="larder:\/\/\([a-z0-9-]*\)".*/\1/p' "$1" ;;
        *.el) sed -n 's/^("\([a-z0-9-]*\)" .*/\1/p' "$1" ;;
    esac
}
has_need() {   # has_need PROFILE NEED : does the profile carry that package
    case $2 in
        -) return 0 ;;
        pip:*) pkgs "$OUT/$1.pip" | grep -qxF "${2#pip:}" ;;
        *) pkgs "$OUT/$1.packages" | grep -qxF "$2" ;;
    esac
}
visible_ids() {   # the buttons a profile must show, worked out here and not by gen.awk
    choice_rows | while IFS="$TAB" read -r id need run; do
        if has_need "$1" "$need"; then echo "$id"; fi
    done | awk '!s[$0]++'
}
missing_from() { sort -u "$1" > "$S/a.s"; sort -u "$2" > "$S/b.s"; comm -23 "$S/a.s" "$S/b.s"; }

# ---------------------------------------------------------------- generator checks
t_G01() {
    $SH "$B/gen.sh" -o "$OUT" || return 1
    [ -x "$OUT/larder-open" ] || { echo "no executable larder-open in $OUT"; return 1; }
    $SH "$B/gen.sh" -o "$S/slash/" > /dev/null 2>&1 && [ -x "$S/slash/larder-open" ] || { echo "-o with a trailing slash failed"; return 1; }
    cp -R "$B" "$S/tree"; rm -rf "$S/tree/out"
    $SH "$S/tree/gen.sh" > /dev/null 2>&1 && [ -x "$S/tree/out/larder-open" ] || { echo "gen.sh with no -o did not write out/ beside itself"; return 1; }
}
t_G02() {
    got=$(awk '/^profile/ { print $2 }' "$B/recipes.conf" | sort | tr '\n' ' ')
    [ "$got" = "desktop fullsink hardened homelab minimal " ] || { echo "profiles are: $got"; return 1; }
    for p in $PROFILES; do for e in packages pip areas preferences; do
        [ -f "$OUT/$p.$e" ] || { echo "missing $p.$e"; return 1; }
    done; done
    for p in $PROFILES; do [ "$(pkgs "$OUT/$p.packages" | wc -l)" -ge 10 ] || { echo "$p.packages is nearly empty"; return 1; }; done
}
t_G03() {
    for p in $PROFILES; do
        pkgs "$OUT/$p.packages" | grep -v -E '^[a-z0-9][a-z0-9+.-]+$'
        pkgs "$OUT/$p.pip" | grep -v -E '^[a-z0-9][a-z0-9._-]*$'
    done > "$S/bad"
    [ ! -s "$S/bad" ] || { echo "not valid names:"; cat "$S/bad"; return 1; }
}
t_G04() {
    for f in "$OUT"/*.packages "$OUT"/*.pip; do
        pkgs "$f" > "$S/a"; sort -u "$S/a" > "$S/b"
        cmp -s "$S/a" "$S/b" || { echo "$f is not sorted and unique"; return 1; }
    done
}
t_G05() {
    for p in $PROFILES; do
        for k in $REQUIRED; do pkgs "$OUT/$p.packages" | grep -qxF "$k" || { echo "$p lacks $k"; return 1; }; done
        for k in rns lxmf; do pkgs "$OUT/$p.pip" | grep -qxF "$k" || { echo "$p lacks pip $k"; return 1; }; done
    done
}
t_G06() {
    rc=0
    for p in $PROFILES; do
        pkgs "$OUT/$p.packages" > "$S/$p.l"
    done
    for p in $PROFILES; do
        [ -z "$(missing_from "$S/$p.l" "$S/fullsink.l")" ] || { echo "fullsink lacks: $(missing_from "$S/$p.l" "$S/fullsink.l" | tr '\n' ' ')(from $p)"; rc=1; }
        [ "$(wc -l < "$S/minimal.l")" -le "$(wc -l < "$S/$p.l")" ] || { echo "minimal is bigger than $p"; rc=1; }
    done
    [ -z "$(missing_from "$S/desktop.l" "$S/hardened.l")" ] || { echo "hardened lacks something desktop has"; rc=1; }
    return $rc
}
t_G07() {
    rc=0
    for p in $PROFILES; do
        sed -n 's/^Package: //p' "$OUT/$p.preferences" > "$S/deny"
        pkgs "$OUT/$p.packages" | grep -xF -f "$S/deny" > "$S/clash" 2>/dev/null
        [ ! -s "$S/clash" ] || { echo "$p installs what it denies: $(tr '\n' ' ' < "$S/clash")"; rc=1; }
        [ "$(grep -c '^Package:' "$OUT/$p.preferences")" = "$(grep -c '^Pin-Priority: -1$' "$OUT/$p.preferences")" ] || { echo "$p.preferences: a stanza is not -1"; rc=1; }
    done
    for k in bluez avahi-daemon; do grep -qx "Package: $k" "$OUT/hardened.preferences" || { echo "hardened does not deny $k"; rc=1; }; done
    return $rc
}
t_G08() {
    nff=$(awk '/^(group|profile|surface|choice)[ \t]/ { next } /^[ \t]*(#|$)/ { next } $2 == "nff" { print $1 }' "$B/recipes.conf" | sort -u)
    [ -n "$nff" ] || { echo "recipes flag no nff package"; return 1; }
    for p in $PROFILES; do
        [ "$(pkgs "$OUT/$p.areas")" = "main non-free-firmware" ] || { echo "$p.areas is not main non-free-firmware"; return 1; }
        for k in $nff; do pkgs "$OUT/$p.packages" | grep -qxF "$k" || { echo "$p lacks $k"; return 1; }; done
    done
    FREE_ONLY=1 $SH "$B/gen.sh" -o "$S/free" > /dev/null 2>&1 || { echo "FREE_ONLY=1 gen.sh failed"; return 1; }
    for p in $PROFILES; do
        [ "$(pkgs "$S/free/$p.areas")" = main ] || { echo "FREE_ONLY $p.areas is not main"; return 1; }
        for k in $nff; do
            if pkgs "$S/free/$p.packages" | grep -qxF "$k"; then echo "FREE_ONLY $p still has $k"; return 1; fi
        done
    done
}
spdx_ok() { head -n 6 "$1" | grep -q "SPDX-License-Identifier: $2"; }
t_G09() {
    rc=0
    for f in "$B"/* "$B"/bin/* "$B"/author/*; do
        [ -f "$f" ] || continue
        case $f in *.md.in) id=CC-BY-SA-4.0 ;; *) id=GPL-3.0-or-later ;; esac
        spdx_ok "$f" "$id" || { echo "no SPDX $id line in $f"; rc=1; }
    done
    for f in "$OUT"/*; do spdx_ok "$f" GPL-3.0-or-later || { echo "no SPDX line in generated $f"; rc=1; }; done
    return $rc
}
bad() {   # bad "reason it must give" TEXT : a recipe with TEXT appended must be refused, for that reason
    cp "$B/recipes.conf" "$S/bad.conf"; printf '%s\n' "$2" >> "$S/bad.conf"; badrun "$1"
}
bad_whole() { printf '%s\n' "$2" > "$S/bad.conf"; badrun "$1"; }   # TEXT is the whole recipe
badrun() {
    rm -rf "$S/bad-out"
    if $SH "$B/gen.sh" -r "$S/bad.conf" -o "$S/bad-out" > "$S/bad.log" 2>&1; then echo "accepted: $1"; rc=1; return; fi
    if [ -e "$S/bad-out" ]; then echo "left output behind: $1"; rc=1; fi
    grep -q "$1" "$S/bad.log" || { echo "refused, but not for '$1': $(head -n 1 "$S/bad.log")"; rc=1; }
}
badcall() {   # badcall WANT_EXIT_STATUS gen.sh-args... : a bad command line
    w=$1; shift; $SH "$B/gen.sh" "$@" > /dev/null 2>&1; r=$?
    [ "$r" = "$w" ] || { echo "gen.sh $* exited $r, want $w"; rc=1; }
}
t_G10() {
    rc=0
    bad "unknown group nosuchgroup" 'profile badone | nosuchgroup | html | -'
    bad "bad package name" 'group zz
Bad_Name'
    bad "which no group provides" 'choice zz | L | H | not-a-package | larder-zz'
    bad "character outside" 'choice zz | L | H | - | larder-zz; id'
    bad "surface html needs firefox-esr" 'group tiny
live-boot
profile tiny | tiny | html | -'
    bad "denies xterm" 'profile leaky | core,mesh,xlite | el | xterm'
    bad "flagged differently" 'group zz
firmware-linux'
    bad "must repeat the same label" 'choice network | Another label | Wifi or a cable. | xterm | xterm -e nmtui'
    bad "no surface record for web" 'profile weird | core,mesh,xlite | web | -'
    bad "bad group name" 'group Bad'
    bad "duplicate group core" 'group core'
    bad "profile needs 4 fields" 'profile three | core | html'
    bad "bad profile name" 'profile Bad9 | core | html | -'
    bad "duplicate profile minimal" 'profile minimal | core | html | -'
    bad "surface needs 2 fields" 'surface html'
    bad "surface must be html or el" 'surface pdf | firefox-esr'
    bad "choice needs 5 fields" 'choice zz | L | H | -'
    bad "bad choice id" 'choice Zz | L | H | - | larder-zz'
    bad "needs a label" 'choice zz |  | H | - | larder-zz'
    bad "bad needs" 'choice zz | L | H | Bad Pkg | larder-zz'
    bad "outside any group" 'zzz-orphan'
    bad "unknown flag" 'group zz
foo-bar weird'
    bad "trailing text" 'group zz
foo-bar nff extra'
    bad "bad deny name" 'profile denyx | core,mesh,xlite | el | Bad_Name'
    bad_whole "no profile defined" 'group a
foo'
    bad_whole "no choice defined" 'group core
live-boot
profile p | core | html | -'
    mkdir -p "$S/tpl"; cp "$B"/*.in "$S/tpl/"; rm -f "$S/tpl/firstrun.el.in"
    rm -rf "$S/bad-out"; cp "$B/recipes.conf" "$S/bad.conf"
    if $SH "$B/gen.sh" -r "$S/bad.conf" -t "$S/tpl" -o "$S/bad-out" > "$S/bad.log" 2>&1; then echo "-t with a missing template was accepted"; rc=1; fi
    grep -q "cannot read template" "$S/bad.log" || { echo "missing template: wrong message"; rc=1; }
    badcall 66 -r "$S/no-such-file" -o "$S/x"
    badcall 64 -o "$S/it's"
    badcall 64 -z
    set -- "$S"/bad-out.stage.*
    [ ! -e "$1" ] || { echo "a failed run left a staging directory: $1"; rc=1; }
    return $rc
}
t_G11() {   # same bytes twice, and a second run into the same directory replaces it and does not nest
    $SH "$B/gen.sh" -o "$S/out2" > /dev/null 2>&1 && diff -r "$OUT" "$S/out2" || return 1
    $SH "$B/gen.sh" -o "$S/out2" > /dev/null 2>&1 && diff -r "$OUT" "$S/out2"
}
t_G14() {   # no template marker survives into a generated file
    grep -l '@@' "$OUT"/* > "$S/at" 2> /dev/null
    [ ! -s "$S/at" ] || { echo "unreplaced @@ marker in: $(tr '\n' ' ' < "$S/at")"; return 1; }
}
t_G12() {   # the profile table in 3-DESIGN.md says what the generator makes
    rc=0
    for p in $PROFILES; do
        row=$(awk -F'|' -v p="$p" '{ x = $2; gsub(/[ `]/, "", x) } x == p && $6 ~ /^ *[0-9]+ *$/ { d = $6; q = $7; gsub(/ /, "", d); gsub(/ /, "", q); print d, q }' "$ROOT/3-DESIGN.md")
        [ -n "$row" ] || { echo "3-DESIGN.md has no table row for $p"; rc=1; continue; }
        real="$(pkgs "$OUT/$p.packages" | wc -l | tr -d ' ') $(pkgs "$OUT/$p.pip" | wc -l | tr -d ' ')"
        [ "$row" = "$real" ] || { echo "$p: doc says '$row' (deb pip), generator makes '$real'"; rc=1; }
    done
    return $rc
}
t_G13() { diff -r "$B/out" "$OUT"; }

# ---------------------------------------------------------------- first-run shell checks
t_F01() {
    awk -F'|' '/^profile/ { split($1, h, " "); s = $3; gsub(/ /, "", s); print h[2], s }' "$B/recipes.conf" | while read -r p s; do
        want=$(echo "$s" | tr ',' ' ')
        for x in html el; do
            case " $want " in
                *" $x "*) [ -f "$OUT/$p.firstrun.$x" ] || echo "$p lacks its $x page" ;;
                *) [ ! -e "$OUT/$p.firstrun.$x" ] || echo "$p has a stray $x page" ;;
            esac
        done
    done > "$S/f01"
    [ ! -s "$S/f01" ] || { cat "$S/f01"; return 1; }
}
t_F02() {
    awk -F'|' '/^surface/ { split($1, h, " "); n = $2; gsub(/ /, "", n); print h[2], n }' "$B/recipes.conf" > "$S/surf"
    for f in "$OUT"/*.firstrun.*; do
        b=${f##*/}; p=${b%%.*}; x=${b##*.}
        need=$(awk -v x="$x" '$1 == x { print $2 }' "$S/surf")
        has_need "$p" "$need" || { echo "$p ships a $x page but lacks $need"; return 1; }
    done
}
t_F03() {
    rc=0
    for f in "$OUT"/*.firstrun.*; do
        b=${f##*/}; p=${b%%.*}
        visible_ids "$p" > "$S/want"; page_ids "$f" > "$S/got"
        cmp -s "$S/want" "$S/got" || { echo "$b: buttons differ from what the profile can do (want | got)"; diff "$S/want" "$S/got"; rc=1; }
    done
    return $rc
}
t_F04() {
    rc=0
    for f in "$OUT"/*.firstrun.*; do
        c=$(page_ids "$f" | wc -l | tr -d ' ')
        { [ "$c" -ge 3 ] && [ "$c" -le 10 ]; } || { echo "${f##*/}: $c buttons, want 3 to 10"; rc=1; }
        [ "$(page_ids "$f" | head -n 1)" = setup ] || { echo "${f##*/}: first button is not setup"; rc=1; }
    done
    return $rc
}
t_F05() {
    rc=0
    for f in "$OUT"/*.firstrun.html; do
        if grep -Eiq '<script|<form|<input|<iframe|<object|<embed|<link|@import|url\(| on[a-z]+=|https?://' "$f"; then
            echo "${f##*/}: has script, form, remote resource or event handler:"; grep -Ein '<script|<form|<input|<iframe|<object|<embed|<link|@import|url\(| on[a-z]+=|https?://' "$f"; rc=1
        fi
        for must in '<html lang="en">' '<meta charset="utf-8">' 'name="viewport"' '<title>[^<]' '<head>' '<body>' '<h1>[^<]' '<ul>' '</ul>' '</body>' '</html>'; do
            grep -q "$must" "$f" || { echo "${f##*/}: missing $must"; rc=1; }
        done
        [ "$(head -n 1 "$f")" = '<!DOCTYPE html>' ] || { echo "${f##*/}: does not open with the html5 doctype (quirks mode)"; rc=1; }
        b=${f##*/}; grep -q "Profile: ${b%%.*}\\." "$f" || { echo "$b: does not name its profile"; rc=1; }
    done
    return $rc
}
t_F06() {
    rc=0
    for f in "$OUT"/*.firstrun.html; do
        a=$(grep -c '<a ' "$f"); l=$(grep -c '<li>' "$f"); g=$(grep -c '<a class="btn" href="larder://[a-z][a-z0-9-]*">[^<][^<]*</a>' "$f")
        { [ "$a" = "$l" ] && [ "$a" = "$g" ]; } || { echo "${f##*/}: $a links, $l items, $g well-formed buttons"; rc=1; }
        if grep 'larder://' "$f" | sed 's/&amp;//g; s/&lt;//g; s/&gt;//g; s/&quot;//g' | grep -q '&'; then
            echo "${f##*/}: a bare & in the page text"; rc=1
        fi
    done
    return $rc
}
t_F07() {
    awk '
    function hx(c,   i, v) { v = 0; c = tolower(c); for (i = 1; i <= length(c); i++) v = v * 16 + index("0123456789abcdef", substr(c, i, 1)) - 1; return v }
    function lin(x) { x = x / 255; return x <= 0.03928 ? x / 12.92 : ((x + 0.055) / 1.055) ^ 2.4 }
    function lum(h) { return 0.2126 * lin(hx(substr(h, 1, 2))) + 0.7152 * lin(hx(substr(h, 3, 2))) + 0.0722 * lin(hx(substr(h, 5, 2))) }
    function ratio(a, b,   x, y) { x = lum(C[a]); y = lum(C[b]); if (x < y) { t = x; x = y; y = t }; return (x + 0.05) / (y + 0.05) }
    /^--[a-z-]+: #/ { name = substr($1, 3, length($1) - 3); C[name] = substr($2, 2, 6) }
    END {
        split("fg:bg help:bg btn-fg:btn-bg", pairs, " "); bad = 0
        for (i = 1; i <= 3; i++) {
            split(pairs[i], pr, ":")
            if (!(pr[1] in C) || !(pr[2] in C)) { print "missing colour variable in " pairs[i]; bad = 1; continue }
            r = ratio(pr[1], pr[2]); printf "%s on %s = %.1f:1\n", pr[1], pr[2], r
            if (r < 7) { print "below 7:1 (WCAG AAA for normal text)"; bad = 1 }
        }
        exit bad
    }' "$OUT/desktop.firstrun.html"
}
t_F08() { for f in "$OUT"/*.firstrun.html; do xmllint --html --noout "$f" || return 1; done; }
t_F09() {
    rc=0
    printf '#!/bin/sh\necho "$1" >> "%s/log"\n' "$S" > "$S/stub"; chmod +x "$S/stub"
    cat > "$S/click.el" <<'EOF'
(setq larder-open-program (getenv "STUB"))
(defun wait-for-children ()
  (let ((k 100)) (while (and (process-list) (> k 0)) (accept-process-output nil 0.05) (setq k (1- k)))))
(defun count-buttons ()
  (goto-char (point-min))
  (let ((n 0)) (while (forward-button 1 nil nil t) (setq n (1+ n))) n))
(with-temp-buffer
  (larder-render)
  (larder-render)                       ; a second render must not double the buttons
  (goto-char (point-min))
  (let ((n 0))
    (while (forward-button 1 nil nil t)
      (unless (button-get (button-at (point)) 'follow-link) (error "button without follow-link"))
      (push-button) (wait-for-children) (setq n (1+ n)))
    (with-temp-file (getenv "COUNT") (insert (number-to-string n)))))
(unless (commandp 'larder-firstrun) (error "larder-firstrun is not interactive, so emacs -f cannot start it"))
(unless (featurep 'larder-firstrun) (error "the file does not provide larder-firstrun"))
(larder-firstrun)
(unless (eq (frame-parameter nil 'fullscreen) 'fullboth) (error "the frame is not fullscreen"))
(when (and (boundp 'menu-bar-mode) menu-bar-mode) (error "the menu bar is still on"))
(when (and (boundp 'tool-bar-mode) tool-bar-mode) (error "the tool bar is still on"))
(with-current-buffer "*Larder*"
  (unless buffer-read-only (error "the menu buffer is writable"))
  (let ((n (count-buttons)))            ; counted here: with-temp-file runs its body in another buffer
    (with-temp-file (getenv "COUNT2") (insert (number-to-string n)))))
EOF
    for f in "$OUT"/*.firstrun.el; do
        cp "$f" "$S/page.el"; rm -f "$S/page.elc" "$S/log" "$S/n" "$S/n2"
        emacs -Q --batch --eval '(setq byte-compile-error-on-warn t)' -f batch-byte-compile "$S/page.el" > "$S/bc.log" 2>&1 || { echo "${f##*/} does not byte-compile cleanly"; cat "$S/bc.log"; rc=1; continue; }
        STUB=$S/stub COUNT=$S/n COUNT2=$S/n2 emacs -Q --batch -l "$f" -l "$S/click.el" > "$S/em.log" 2>&1 || { echo "${f##*/}: emacs failed"; cat "$S/em.log"; rc=1; continue; }
        want=$(page_ids "$f" | tr '\n' ' '); got=$(sed 's|^larder://||' "$S/log" 2> /dev/null | tr '\n' ' ')
        [ "$(cat "$S/n")" = "$(page_ids "$f" | wc -l | tr -d ' ')" ] || { echo "${f##*/}: $(cat "$S/n") buttons for $(page_ids "$f" | wc -l) choices"; rc=1; }
        [ "$got" = "$want" ] || { echo "${f##*/}: clicks sent [$got] but the choices are [$want]"; rc=1; }
        [ "$(cat "$S/n2")" = "$(page_ids "$f" | wc -l | tr -d ' ')" ] || { echo "${f##*/}: larder-firstrun shows $(cat "$S/n2") buttons"; rc=1; }
    done
    return $rc
}
t_F10() {
    rc=0; mkdir -p "$S/empty"
    for id in $(choice_ids); do
        want="would try: $(choice_rows | awk -F'\t' -v id="$id" '$1 == id { s = (s == "" ? $3 : s " || " $3) } END { print s }')"
        for form in "larder://$id" "$id" "larder://$id/"; do
            got=$(PATH=$S/empty LARDER_DRY_RUN=1 $SHP "$OUT/larder-open" "$form" 2>&1) || { echo "'$form' was refused: $got"; rc=1; continue; }
            [ "$got" = "$want" ] || { echo "'$form' -> '$got', want '$want'"; rc=1; }
        done
    done
    return $rc
}
t_F11() {
    rc=0; mkdir -p "$S/empty"
    while IFS= read -r a; do
        got=$(PATH=$S/empty LARDER_DRY_RUN=1 $SHP "$OUT/larder-open" "$a" 2>&1); r=$?
        case $got in *"would try"*) echo "accepted: '$a'"; rc=1; continue ;; esac
        [ "$r" = 64 ] || { echo "'$a' exited $r, want 64"; rc=1; }
    done <<'EOF'
larder://
larder://nope
larder://setup;id
larder://setup id
larder://../setup
larder://Setup
larder://-setup
larder://1setup
larder://setup//
larder://setup%20x
larder://$(id)
larder://`id`
LARDER://setup
setup;id
/bin/sh
EOF
    for args in "" "larder://setup larder://guide"; do
        PATH=$S/empty LARDER_DRY_RUN=1 $SHP "$OUT/larder-open" $args > /dev/null 2>&1; [ $? = 64 ] || { echo "'$args' (wrong argument count) did not exit 64"; rc=1; }
    done
    PATH=$S/empty LARDER_DRY_RUN=1 $SHP "$OUT/larder-open" "" > /dev/null 2>&1; [ $? = 64 ] || { echo "empty argument did not exit 64"; rc=1; }
    return $rc
}
t_F12() {   # real exec, with stub programs standing in for the apps
    mkdir -p "$S/bin"; rm -f "$S/log" "$S/evil.ran"
    for x in xterm larder-guide; do printf '#!/bin/sh\necho "%s $*" >> "%s"\n' "$x" "$S/log" > "$S/bin/$x"; chmod +x "$S/bin/$x"; done
    printf '#!/bin/sh\necho ran > "%s"\n' "$S/evil.ran" > "$S/bin/evil"; chmod +x "$S/bin/evil"
    PATH=$S/bin $SHP "$OUT/larder-open" larder://network || { echo "network did not fall back to xterm"; return 1; }
    PATH=$S/bin $SHP "$OUT/larder-open" larder://guide || { echo "guide did not run"; return 1; }
    grep -q '^xterm -e nmtui$' "$S/log" || { echo "network ran the wrong command"; cat "$S/log"; return 1; }
    grep -q '^larder-guide' "$S/log" || { echo "guide ran the wrong command"; return 1; }
    PATH=$S/bin $SHP "$OUT/larder-open" larder://evil > /dev/null 2>&1
    [ ! -e "$S/evil.ran" ] || { echo "a link ran a program that is not an action"; return 1; }
    PATH=$S/bin $SHP "$OUT/larder-open" larder://library > "$S/lib.out" 2>&1; r=$?
    [ "$r" = 69 ] || { echo "library with nothing installed exited $r, want 69"; return 1; }
    grep -q "nothing installed can do 'library'" "$S/lib.out" || { echo "no message for a dead button"; return 1; }
}
t_F13() {
    sed -n 's/^\([a-z][a-z0-9-]*\)) try .*/\1/p' "$OUT/larder-open" | sort > "$S/arms"
    choice_ids | sort > "$S/ids"
    cmp "$S/arms" "$S/ids"
}
t_F14() { for f in "$B/gen.sh" "$OUT/larder-open" "$B/bin/fanmark" "$B/author/render-edition.sh" "$0"; do $SH -n "$f" || return 1; done; }
t_F15() {   # button text is the recipe's text, and hostile text comes out right in both page kinds
    rc=0; choice_text > "$S/text.tsv"
    for f in "$OUT"/*.firstrun.html; do
        sed -n 's/^<li><a class="btn" href="larder:\/\/\([a-z0-9-]*\)">\(.*\)<\/a><span class="help">\(.*\)<\/span><\/li>$/\1\t\2\t\3/p' "$f" | unesc > "$S/got.tsv"
        [ -s "$S/got.tsv" ] || { echo "${f##*/}: no buttons parsed"; rc=1; }
        while IFS= read -r line; do
            grep -qxF "$line" "$S/text.tsv" || { echo "${f##*/}: '$line' is not the recipe's text"; rc=1; }
        done < "$S/got.tsv"
    done
    if command -v emacs > /dev/null 2>&1; then
        for f in "$OUT"/*.firstrun.el; do
            emacs -Q --batch -l "$f" --eval '(dolist (c larder-choices) (princ (format "%s\t%s\t%s\n" (nth 0 c) (nth 1 c) (nth 2 c))))' > "$S/got.tsv" 2> /dev/null
            [ -s "$S/got.tsv" ] || { echo "${f##*/}: emacs printed no choices"; rc=1; }
            while IFS= read -r line; do
                grep -qxF "$line" "$S/text.tsv" || { echo "${f##*/}: '$line' is not the recipe's text"; rc=1; }
            done < "$S/got.tsv"
        done
    fi
    cp "$B/recipes.conf" "$S/evil.conf"
    printf '%s\n' "choice evil | Tom & \"Jerry\" <b>x</b> \\ 'q' | 5 > 3 & 2 < 4 | - | larder-evil" >> "$S/evil.conf"
    $SH "$B/gen.sh" -r "$S/evil.conf" -o "$S/evil-out" > /dev/null 2>&1 || { echo "hostile text made gen.sh fail"; return 1; }
    cat > "$S/expect.html" <<'EOF'
<li><a class="btn" href="larder://evil">Tom &amp; &quot;Jerry&quot; &lt;b&gt;x&lt;/b&gt; \ 'q'</a><span class="help">5 &gt; 3 &amp; 2 &lt; 4</span></li>
EOF
    grep -qxF -f "$S/expect.html" "$S/evil-out/desktop.firstrun.html" || { echo "html: hostile label not escaped as expected"; grep 'larder://evil' "$S/evil-out/desktop.firstrun.html"; rc=1; }
    if command -v xmllint > /dev/null 2>&1; then xmllint --html --noout "$S/evil-out/desktop.firstrun.html" || rc=1; fi
    cat > "$S/expect.el" <<'EOF'
("evil" "Tom & \"Jerry\" <b>x</b> \\ 'q'" "5 > 3 & 2 < 4")
EOF
    grep -qxF -f "$S/expect.el" "$S/evil-out/minimal.firstrun.el" || { echo "el: hostile label not escaped as expected"; grep '"evil"' "$S/evil-out/minimal.firstrun.el"; rc=1; }
    if command -v emacs > /dev/null 2>&1; then
        emacs -Q --batch -l "$S/evil-out/minimal.firstrun.el" --eval '(princ (nth 1 (assoc "evil" larder-choices)))' > "$S/evil.label" 2> /dev/null
        printf '%s' "Tom & \"Jerry\" <b>x</b> \\ 'q'" | cmp -s - "$S/evil.label" || { echo "el: Emacs reads the hostile label back differently"; rc=1; }
    fi
    return $rc
}

# ---------------------------------------------------------------- author edition checks
mk_editions() {
    for v in no yes; do
        mkdir -p "$S/conf.$v"; sed "s/^LEGAL_REVIEW=.*/LEGAL_REVIEW=$v/" "$B/author/edition.conf" > "$S/conf.$v/edition.conf"
        $SH "$B/author/render-edition.sh" "$S/conf.$v/edition.conf" "$B/author/PERMISSION.md.in" "$S/ed.$v" > /dev/null 2>&1 || return 1
    done
}
t_A01() {
    mk_editions || { echo "render-edition.sh failed on the sample edition"; return 1; }
    f=$S/ed.yes/PERMISSION.md; rc=0
    ! grep -q '{{' "$f" || { echo "unresolved placeholder"; rc=1; }
    grep -q '{ID}' "$f" || { echo "the mark has no {ID} slot"; rc=1; }
    for h in Grant Mark "Not read" "No money" "Yours and mine" Changes; do grep -q "^## $h\$" "$f" || { echo "missing clause: $h"; rc=1; }; done
    grep -qi 'do not read fan works' "$f" || { echo "the notice does not say the author does not read them"; rc=1; }
    w=$(wc -w < "$f"); { [ "$w" -ge 150 ] && [ "$w" -le 450 ]; } || { echo "$w words; a short notice is 150 to 450"; rc=1; }
    [ "$(grep -c '^> \*\*FAN WORK' "$f")" = 1 ] || { echo "want exactly one mark line"; rc=1; }
    grep '^> \*\*FAN WORK' "$f" | grep -q 'by permission' || { echo "the mark does not say by permission"; rc=1; }
    spdx_ok "$f" CC-BY-SA-4.0 || { echo "rendered notice lost its SPDX line"; rc=1; }
    return $rc
}
t_A02() {
    head -n 1 "$S/ed.no/PERMISSION.md" | grep -q '^> \*\*DRAFT' || { echo "LEGAL_REVIEW=no did not add the DRAFT banner"; return 1; }
    [ -z "$(sed -n 2p "$S/ed.no/PERMISSION.md")" ] || { echo "no blank line under the DRAFT banner, so Markdown would merge it with what follows"; return 1; }
    ! grep -q 'DRAFT' "$S/ed.yes/PERMISSION.md" || { echo "LEGAL_REVIEW=yes still says DRAFT"; return 1; }
}
t_A03() {   # render-edition: each refusal is for the right reason, and leaves nothing behind
    rc=0; r=$B/author/render-edition.sh
    printf 'x {{NOPE}} y\n' > "$S/t.in"; rm -rf "$S/o1"
    $SH "$r" "$B/author/edition.conf" "$S/t.in" "$S/o1" > "$S/a3.log" 2>&1 && { echo "an unresolved placeholder was accepted"; rc=1; }
    grep -q 'unresolved {{placeholder}}' "$S/a3.log" || { echo "placeholder refusal: wrong message: $(head -n 1 "$S/a3.log")"; rc=1; }
    [ -z "$(ls "$S/o1" 2> /dev/null)" ] || { echo "a refused render left files behind: $(ls "$S/o1")"; rc=1; }
    for bad in 'AUTHOR=A | B' 'AUTHOR=A & B' 'AUTHOR=A \ B' 'AUTHOR=A {{B' 'AUTHOR=A }} B'; do
        sed "s/^AUTHOR=.*/$(printf '%s' "$bad" | sed 's/[\\&|/]/\\&/g')/" "$B/author/edition.conf" > "$S/c2"
        $SH "$r" "$S/c2" "$B/author/PERMISSION.md.in" "$S/o2" > "$S/a3.log" 2>&1 && { echo "'$bad' was accepted"; rc=1; }
        grep -q 'contains one of' "$S/a3.log" || { echo "'$bad': wrong message: $(head -n 1 "$S/a3.log")"; rc=1; }
    done
    grep -v '^CONTACT=' "$B/author/edition.conf" > "$S/c3"
    $SH "$r" "$S/c3" "$B/author/PERMISSION.md.in" "$S/o3" > "$S/a3.log" 2>&1 && { echo "a missing CONTACT was accepted"; rc=1; }
    grep -q 'CONTACT is missing or empty' "$S/a3.log" || { echo "missing CONTACT: wrong message"; rc=1; }
    $SH "$r" "$S/no-such" "$B/author/PERMISSION.md.in" "$S/o4" > "$S/a3.log" 2>&1; [ $? = 1 ] && grep -q 'cannot read' "$S/a3.log" || { echo "an unreadable conf was not refused clearly"; rc=1; }
    $SH "$r" "$B/author/edition.conf" "$S/no-such" "$S/o4" > "$S/a3.log" 2>&1; [ $? = 1 ] && grep -q 'cannot read' "$S/a3.log" || { echo "an unreadable template was not refused clearly"; rc=1; }
    $SH "$r" onlyone > /dev/null 2>&1; [ $? = 64 ] || { echo "wrong argument count did not exit 64"; rc=1; }
    return $rc
}
t_A04() {   # fanmark output is compared byte for byte with what the notice says it must be
    rc=0; ed=$S/ed.yes; note=$ed/PERMISSION.md
    id=$(sha256sum < "$note" | cut -c1-12)
    mark=$(grep '^> \*\*FAN WORK' "$note" | sed "s/{ID}/$id/")
    printf 'Chapter 1\nIt was a dark night.\n' > "$S/w1"; printf 'no newline at the end' > "$S/w2"; printf 'no newline at the end\n' > "$S/w2.nl"
    for w in w1 w2; do
        body=$S/$w; [ "$w" = w2 ] && body=$S/w2.nl
        { printf '%s\n\n' "$mark"; cat "$body"; printf '\n%s\n' "$mark"; } > "$S/g.$w"
        $SH "$B/bin/fanmark" -e "$ed" "$S/$w" > "$S/s.$w" || { echo "fanmark failed on $w"; rc=1; continue; }
        cmp -s "$S/s.$w" "$S/g.$w" || { echo "$w: stamped output is not mark, blank, work, blank, mark"; diff "$S/g.$w" "$S/s.$w" | head -n 6; rc=1; }
    done
    case $mark in *"(id $id)"*) ;; *) echo "mark does not carry sha256 prefix $id"; rc=1 ;; esac
    $SH "$B/bin/fanmark" -e "$ed" "$S/s.w1" | cmp -s - "$S/s.w1" || { echo "stamping twice is not the same as once"; rc=1; }
    $SH "$B/bin/fanmark" -e "$ed" < "$S/w1" | cmp -s - "$S/s.w1" || { echo "stdin and file give different output"; rc=1; }
    : | $SH "$B/bin/fanmark" -e "$ed" > /dev/null 2>&1; [ $? = 2 ] || { echo "empty input did not exit 2"; rc=1; }
    $SH "$B/bin/fanmark" -e "$S/ed.no" "$S/w1" > /dev/null 2>&1; [ $? = 3 ] || { echo "a DRAFT notice was not refused (exit 3)"; rc=1; }
    FANMARK_ALLOW_DRAFT=1 $SH "$B/bin/fanmark" -e "$S/ed.no" "$S/w1" > /dev/null 2>&1 || { echo "FANMARK_ALLOW_DRAFT=1 did not allow a draft"; rc=1; }
    mkdir -p "$S/ed.changed"; sed 's/free of charge/for nothing/' "$note" > "$S/ed.changed/PERMISSION.md"
    $SH "$B/bin/fanmark" -e "$S/ed.changed" "$S/w1" | head -n 1 | grep -q "(id $id)" && { echo "editing the notice did not change the id in the mark"; rc=1; }
    return $rc
}
t_A05() {   # the stage documents carry their licence line
    rc=0
    for f in "$ROOT"/[1-6]-*.md; do [ -f "$f" ] || continue; spdx_ok "$f" CC-BY-SA-4.0 || { echo "no CC-BY-SA-4.0 SPDX line in $f"; rc=1; }; done
    return $rc
}

t_A06() {   # fanmark's own refusals and housekeeping
    rc=0; ed=$S/ed.yes; f=$B/bin/fanmark
    printf 'x\n' > "$S/w1"
    $SH "$f" "$S/w1" > "$S/a6.log" 2>&1; [ $? = 64 ] || { echo "no -e did not exit 64"; rc=1; }
    $SH "$f" -e "$S/no-such-dir" "$S/w1" > "$S/a6.log" 2>&1; r=$?
    { [ "$r" = 1 ] && grep -q 'cannot read' "$S/a6.log"; } || { echo "a missing notice was not refused clearly ($r)"; rc=1; }
    mkdir -p "$S/ed.nomark"; grep -v 'FAN WORK' "$ed/PERMISSION.md" > "$S/ed.nomark/PERMISSION.md"
    $SH "$f" -e "$S/ed.nomark" "$S/w1" > "$S/a6.log" 2>&1; r=$?
    { [ "$r" = 1 ] && grep -q 'no mark line' "$S/a6.log"; } || { echo "a notice with no mark line was not refused clearly ($r)"; rc=1; }
    $SH "$f" -e "$ed" "$S/w1" > "$S/marked"
    mkdir -p "$S/ed.other"; sed 's/free of charge/for nothing/' "$ed/PERMISSION.md" > "$S/ed.other/PERMISSION.md"
    $SH "$f" -e "$S/ed.other" "$S/marked" > "$S/o.txt" 2> "$S/e.txt"
    cmp -s "$S/o.txt" "$S/marked" || { echo "a work marked under another notice was changed"; rc=1; }
    grep -q "not with this notice's id" "$S/e.txt" || { echo "no warning when the existing mark has another id"; rc=1; }
    mkdir -p "$S/tmp"; TMPDIR=$S/tmp $SH "$f" -e "$ed" "$S/w1" > /dev/null
    [ -z "$(ls "$S/tmp")" ] || { echo "fanmark left a temporary file behind"; rc=1; }
    return $rc
}

# ---------------------------------------------------------------- the suite
run_suite() {   # run_suite TREE : prints TAP; leaves FAILED and nfail set
    B=$1; S=$(mktemp -d "$W/run.XXXXXX"); OUT=$S/out
    n=0 nfail=0 nskip=0 FAILED=
    echo "# suite on $B (shell: $SH)"
    check G01 "gen.sh runs on the real recipes" t_G01
    if [ -f "$OUT/larder-open" ]; then
        check G02 "five profiles, four lists each" t_G02
        check G03 "every package name is a valid Debian or PyPI name" t_G03
        check G04 "lists are sorted and have no duplicates" t_G04
        check G05 "every profile carries boot, crypto, network and the mesh stack" t_G05
        check G06 "fullsink holds every profile; minimal is the smallest; hardened holds desktop" t_G06
        check G07 "denied packages are pinned -1 and not installed" t_G07
        check G08 "non-free firmware is flagged, and FREE_ONLY=1 removes all of it" t_G08
        check G09 "every file carries the right SPDX line" t_G09
        check G10 "nine kinds of bad recipe are refused, with a message and no output" t_G10
        check G11 "two runs give identical bytes, also into the same directory" t_G11
        check G14 "no template marker (@@) survives into a generated file" t_G14
        check G12 "the profile table in 3-DESIGN.md matches the generator" t_G12
        if [ -d "$B/out" ]; then check G13 "the shipped out/ is what gen.sh makes now" t_G13; else skip G13 "no shipped out/ in this tree"; fi
        check F01 "each profile has exactly the first-run pages it declares" t_F01
        check F02 "a page's surface package is in its profile" t_F02
        check F03 "buttons shown equal the buttons the profile can serve" t_F03
        check F04 "3 to 10 buttons, setup first" t_F04
        check F05 "html: no script, form, remote resource or handler; has lang, title, viewport" t_F05
        check F06 "html: every button is a larder:// link with text; ampersands escaped" t_F06
        check F07 "html: all text and button colours reach 7:1 contrast" t_F07
        if command -v xmllint > /dev/null 2>&1; then check F08 "html parses" t_F08; else skip F08 "xmllint missing"; fi
        if command -v emacs > /dev/null 2>&1; then check F09 "el: byte-compiles clean, one button per choice, each click sends its id" t_F09; else skip F09 "emacs missing"; fi
        check F10 "larder-open names the right commands for every action" t_F10
        check F11 "larder-open refuses 15 hostile or malformed arguments with exit 64" t_F11
        check F12 "larder-open really execs the fallback, and never runs a non-action" t_F12
        check F13 "larder-open and recipes.conf list the same actions" t_F13
        check F14 "scripts parse under $SH -n" t_F14
        check F15 "button text equals the recipe's; <, >, &, quotes and a backslash survive both page kinds" t_F15
    else
        echo "# generator failed: checks that need its output are not run"
    fi
    check A01 "the notice renders, is short, and has every clause" t_A01
    check A02 "no LEGAL_REVIEW=yes, no way to lose the DRAFT banner" t_A02
    check A03 "render-edition refuses placeholders, unsafe values, missing keys" t_A03
    check A04 "fanmark: marks top and bottom, id = notice hash, body untouched, idempotent, fuses" t_A04
    check A05 "stage documents carry SPDX CC-BY-SA-4.0" t_A05
    check A06 "fanmark and render-edition refuse bad calls, for the right reason" t_A06
    echo "1..$n"
    echo "# $n checks, $nfail failed, $nskip skipped${FAILED:+; failed:$FAILED}"
}

# ---------------------------------------------------------------- planted faults
subst() {   # subst FILE OLD NEW : replace the first literal OLD with NEW
    OLD=$2 NEW=$3 awk 'BEGIN { RS = "\001" } { i = index($0, ENVIRON["OLD"]); if (!i) exit 3; printf "%s%s%s", substr($0, 1, i - 1), ENVIRON["NEW"], substr($0, i + length(ENVIRON["OLD"])) }' "$1" > "$1.new" || { rm -f "$1.new"; echo "fault does not apply: '$2' is not in $1" >&2; return 3; }
    mv "$1.new" "$1"
}
dropline() {   # dropline FILE LINE : delete every line equal to LINE
    grep -vxF -- "$2" "$1" > "$1.new"
    if cmp -s "$1" "$1.new"; then rm -f "$1.new"; echo "fault does not apply: no line '$2' in $1" >&2; return 3; fi
    mv "$1.new" "$1"
}
FAULTS="no-escape:F06 no-sort:G04 open-fallthrough:F12 low-contrast:F07 script-tag:F05 remote-font:F05
drop-live-boot:G05 deny-leak:G07 fullsink-explicit:G06 always-visible:F03 free-only-ignored:G08
spdx-missing:G09 notice-no-read:A01 mark-unbound:A04 mark-no-footer:A04 draft-fuse-off:A02
doc-drift:G12 el-wrong-id:F09 nondeterministic:G11 too-many-buttons:F04 weak-validator:G10
el-no-escape:F15 dryrun-execs:F10 no-chmod:G01 no-newline-fix:A04 orphan-ok:G10 midword-id:A04"
apply_fault() {   # apply_fault NAME TREE
    t=$2
    case $1 in
        no-escape) subst "$t/gen.awk" 'r = r "&amp;"' 'r = r "&"' ;;
        no-sort) subst "$t/gen.awk" "LC_ALL=C sort -u >> '\" f1" "cat >> '\" f1" ;;
        open-fallthrough) subst "$t/larder-open.in" '*) echo "larder-open: unknown action' '*) try "$id"; echo "larder-open: unknown action' ;;
        low-contrast) subst "$t/firstrun.html.in" '--btn-bg: #124a2a;' '--btn-bg: #6fae85;' ;;
        script-tag) subst "$t/firstrun.html.in" '</head>' '<script>document.title = "x"</script></head>' ;;
        remote-font) subst "$t/firstrun.html.in" '<title>' '<link rel="stylesheet" href="https://fonts.example/x.css"><title>' ;;
        drop-live-boot) dropline "$t/recipes.conf" 'live-boot' ;;
        deny-leak) subst "$t/recipes.conf" 'group hardening
apparmor
' 'group hardening
bluez
apparmor
' && subst "$t/gen.awk" 'if ((p SUBSEP d) in P) fail("profile " p " denies " d " but also includes it")' ';' ;;
        fullsink-explicit) subst "$t/recipes.conf" 'profile fullsink | *' 'profile fullsink | core,mesh,xlite,xfce,office,library,files,privacy,hardening,extras' ;;
        always-visible) subst "$t/gen.awk" 'else if (n == "-" || ((p SUBSEP n) in P)) { shown = 1; break }' 'else { shown = 1; break }' ;;
        free-only-ignored) subst "$t/gen.awk" 'if (free_only == 1 && flagof[m] == "nff") continue' ';' ;;
        spdx-missing) dropline "$t/firstrun.el.in" ';; SPDX-License-Identifier: GPL-3.0-or-later' ;;
        notice-no-read) subst "$t/author/PERMISSION.md.in" '## Not read' '## Quiet' ;;
        mark-unbound) subst "$t/bin/fanmark" 'id=$(sha256sum < "$notice" | cut -c1-12)' 'id=000000000000' ;;
        mark-no-footer) subst "$t/bin/fanmark" "printf '\\n%s\\n' \"\$mark\"  # footer" ':' ;;
        draft-fuse-off) subst "$t/author/render-edition.sh" 'if [ "$review" != yes ]; then' 'if false; then' ;;
        doc-drift) subst "$t/recipes.conf" 'libreoffice-calc' 'libreoffice-calc
libreoffice-impress' ;;
        el-wrong-id) subst "$t/firstrun.el.in" "'larder-id (nth 0 choice)" "'larder-id (nth 1 choice)" ;;
        nondeterministic) subst "$t/gen.awk" 'function header(file, what) {' 'function header(file, what,   ts) { "date +%s%N" | getline ts; close("date +%s%N")' && subst "$t/gen.awk" 'print "# SPDX-License-Identifier: GPL-3.0-or-later" > file' 'print "# SPDX-License-Identifier: GPL-3.0-or-later " ts > file' ;;
        too-many-buttons) subst "$t/recipes.conf" 'choice shutdown' 'choice x1 | One | h | - | larder-x1
choice x2 | Two | h | - | larder-x2
choice x3 | Three | h | - | larder-x3
choice shutdown' ;;
        weak-validator) subst "$t/gen.awk" 'if (f[5] !~ /^[a-z0-9][a-z0-9 ._=-]*$/) die("run command has a character outside [a-z0-9 ._=-]")' ';' ;;
        el-no-escape) subst "$t/gen.awk" 'if (c == "\\" || c == "\"") r = r "\\"' 'if (c == "\\") r = r "\\"' ;;
        dryrun-execs) subst "$t/larder-open.in" '        exit 0' '        :' ;;
        no-chmod) subst "$t/gen.sh" 'chmod 755 "$stage" "$stage/larder-open"' ':' ;;
        no-newline-fix) subst "$t/bin/fanmark" '[ -z "$(tail -c 1 "$work")" ] || echo' ':' ;;
        orphan-ok) subst "$t/gen.awk" '    cur = ""
    nf = split(line, f, "|")' '    nf = split(line, f, "|")' ;;
        midword-id) subst "$t/bin/fanmark" 'cut -c1-12' 'cut -c1-11' ;;
        *) echo "unknown fault $1" >&2; return 2 ;;
    esac
}
plant() {   # plant NAME : suite on a copy carrying the fault; leaves FAILED set
    pl_tree=$W/tree.$1; rm -rf "$pl_tree"; cp -R "$SRC" "$pl_tree"; rm -rf "$pl_tree/out"
    apply_fault "$1" "$pl_tree" || return 3
    run_suite "$pl_tree"
}
selftest() {   # st_ names: run_suite's checks use plain names like want and name
    st_bad=0
    run_suite "$SRC" > "$W/base.tap"; cat "$W/base.tap"
    [ "$nfail" = 0 ] || { echo "SELF-TEST ABORTED: the baseline is not green"; return 1; }
    echo; echo "# planting faults, one at a time, in copies of 4-BUILD"
    for st_entry in $FAULTS; do
        st_name=${st_entry%%:*}; st_want=${st_entry##*:}
        plant "$st_name" > "$W/tap.$st_name"; st_r=$?
        if [ "$st_r" = 3 ]; then echo "BROKEN  $st_name: the fault did not apply, so nothing was tested"; st_bad=1; continue; fi
        case " $FAILED " in
            *" $st_want "*) echo "CAUGHT  $st_name: red on $st_want (all red:$FAILED)" ;;
            *) echo "MISSED  $st_name: wanted red on $st_want, got:${FAILED:- nothing}"; st_bad=1 ;;
        esac
    done
    st_count=$(echo $FAULTS | wc -w | tr -d ' ')
    if [ "$st_bad" = 0 ]; then echo "# self-test passed: green baseline, $st_count of $st_count planted faults caught"; else echo "# SELF-TEST FAILED"; fi
    return $st_bad
}

case ${1:-} in
    '') run_suite "$SRC"; [ "$nfail" = 0 ] ;;
    --self-test) selftest ;;
    --plant) plant "${2:?name needed}"; [ "$nfail" != 0 ] && echo "# the planted fault made the suite go red, as it should" ;;
    --tree) run_suite "${2:?directory needed}"; [ "$nfail" = 0 ] ;;
    --faults) for e in $FAULTS; do echo "${e%%:*} -> expect ${e##*:}"; done ;;
    *) echo "usage: run-tests.sh [--self-test | --plant NAME | --faults | --tree DIR]" >&2; exit 64 ;;
esac
