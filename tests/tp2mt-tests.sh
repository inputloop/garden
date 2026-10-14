#!/bin/sh
# tp2mt-tests.sh -- the Terms and Privacy pair is minted per build, from claims that must hold. | --prove-red
# Copyright (C) 2026 Corwin Brust <corwin@bru.st>. Authored by Mentat (for Corwin).
# This program is free software: you can redistribute it and/or modify it under the terms of the
# GNU General Public License as published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.  SPDX-License-Identifier: GPL-3.0-or-later
set -u
here=$(cd "$(dirname "$0")/.." && pwd)
t=$(mktemp -d 2>/dev/null) || { t=${TMPDIR:-/tmp}/tp2mt-tests.$$; mkdir -p "$t"; }
trap 'rm -rf "$t"' EXIT INT TERM
pass=0; fail=0
ok()  { pass=$((pass+1)); echo "ok   $1"; }
bad() { fail=$((fail+1)); echo "FAIL $1 -- $2"; }
F="$t/seat"; mkdir -p "$F/bin" "$F/polygram/mcp" "$t/also"
cp "$here/bin/tp2mt" "$F/bin/"; cp "$here/polygram/__init__.py" "$F/polygram/"; cp "$here"/polygram/mcp/*.py "$F/polygram/mcp/"
M="sh $F/bin/tp2mt --out $t/out"
$M --check > "$t/o" 2>&1; [ $? -eq 0 ] && [ ! -d "$t/out" ] && ok "--check: every claim holds on the real source, and nothing is written" || bad check "$(cat "$t/o")"
$M --also "$t/also" > "$t/o" 2>&1; rc=$?
v=$(sed -n 's/^__version__ = "\([0-9.]*\)".*/\1/p' "$F/polygram/__init__.py")
[ $rc -eq 0 ] && head -1 "$t/out/TERMS-OF-SERVICE.md" | grep -q "vibrobeast $v\$" && head -1 "$t/out/PRIVACY.md" | grep -q "vibrobeast $v\$" && ok "both documents are stamped with this build's version" || bad stamp "rc=$rc $(head -1 "$t/out/PRIVACY.md")"
grep -q "Minted $(date -u +%Y-%m-%d)" "$t/out/PRIVACY.md" && ok "...and today's date" || bad date x
awk '/^## Words we use/,/^- \*\*you\*\*/' "$t/out/TERMS-OF-SERVICE.md" > "$t/w1"; awk '/^## Words we use/,/^- \*\*you\*\*/' "$t/out/PRIVACY.md" > "$t/w2"
[ -s "$t/w1" ] && cmp -s "$t/w1" "$t/w2" && ok "the Words block is identical in both" || bad words differ
grep -q '^## Filters -- every one, by name' "$t/out/PRIVACY.md" && grep -q 'SECRET' "$t/out/PRIVACY.md" && grep -q 'No other filter' "$t/out/PRIVACY.md" && ok "every filter is named, and the list says it is complete" || bad filters x
grep -q 'either version 3 of the License, or (at your option) any later version' "$t/out/TERMS-OF-SERVICE.md" && ok "the Terms state the GPL in its standard words" || bad gpl x
cmp -s "$t/out/PRIVACY.md" "$t/also/PRIVACY.md" && ok "--also: the shelf gets the same pair" || bad also x
# 2026-09-27 (audit F10): word_register writes under the words root; the policy must say where
grep -q 'g/<word>/<leaf>' "$t/out/PRIVACY.md" && grep -q '^- word_register writes' "$t/out/PRIVACY.md" && ok "the words root that word_register writes is listed, as a checked claim" || bad words-root "$(grep -n word "$t/out/PRIVACY.md" | head -3)"
# 2026-09-26: the pair must reach the tree's MANIFEST and the installable .plugin (it reached neither)
P="$t/plug/vibrobeast"; mkdir -p "$P"; printf 'x\n' > "$P/README.md"
( cd "$P" && printf '%s  ./README.md\n' "$(sha256sum < README.md | cut -d' ' -f1)" > MANIFEST )
python3 -c 'import sys,zipfile; z=zipfile.ZipFile(sys.argv[1],"w"); z.write(sys.argv[2]+"/README.md","README.md"); z.write(sys.argv[2]+"/MANIFEST","MANIFEST"); z.close()' "$P.plugin" "$P"
sh "$F/bin/tp2mt" --out "$P" > "$t/o" 2>&1; sh "$F/bin/tp2mt" --out "$P" > "$t/o" 2>&1
n=$(grep -c -e '  ./PRIVACY.md$' -e '  ./TERMS-OF-SERVICE.md$' "$P/MANIFEST")
good=$( cd "$P" && while read -r h f; do [ "$(sha256sum < "$f" | cut -d' ' -f1)" = "$h" ] || echo bad; done < MANIFEST )
inzip=$(python3 -c 'import sys,zipfile; n=zipfile.ZipFile(sys.argv[1]).namelist(); print(sum(x in n for x in ("PRIVACY.md","TERMS-OF-SERVICE.md","MANIFEST","README.md")), len(n))' "$P.plugin")
[ "$n" = 2 ] && [ -z "$good" ] && [ "$inzip" = "4 4" ] && ok "the pair is entered in the tree's MANIFEST once (twice run) and carried in the .plugin" || bad carry "n=$n good=$good inzip=$inzip $(cat "$t/o")"
modes=$(python3 -c 'import sys,zipfile; z=zipfile.ZipFile(sys.argv[1]); print(" ".join("%s:%d:%o" % (f, z.getinfo(f).create_system, (z.getinfo(f).external_attr >> 16) & 0o777) for f in ("MANIFEST","PRIVACY.md","TERMS-OF-SERVICE.md")))' "$P.plugin")
[ "$modes" = "MANIFEST:3:644 PRIVACY.md:3:644 TERMS-OF-SERVICE.md:3:644" ] && ok "...as Unix entries, mode 0644, like the rest of the mint" || bad zipmode "$modes"
printf 'import urllib.request\n' >> "$F/polygram/mcp/persona.py"; $M > "$t/o" 2>&1; rc=$?
[ $rc -eq 1 ] && grep -q 'BROKEN no server but llamabridge and tavernface opens a network connection' "$t/o" && grep -q REFUSED "$t/o" && ok "a network import breaks the claim and refuses the mint" || bad net "rc=$rc $(cat "$t/o")"
cp "$here/polygram/mcp/persona.py" "$F/polygram/mcp/"; sed -i 's/"prefs\.tsv"/"settings.tsv"/' "$F/polygram/mcp/prefs.py"; $M > "$t/o" 2>&1
[ $? -eq 1 ] && grep -q 'BROKEN preferences are kept' "$t/o" && ok "a moved store breaks its claim: the policy is never minted around a false sentence" || bad store "$(cat "$t/o")"
cp "$here/polygram/mcp/prefs.py" "$F/polygram/mcp/"; sed -i 's#g = c4 / "g"#g = c4 / "words"#' "$F/polygram/mcp/words.py"; $M > "$t/o" 2>&1
[ $? -eq 1 ] && grep -q 'BROKEN word_register writes' "$t/o" && ok "a moved words root breaks its claim too" || bad words-moved "$(cat "$t/o")"
cp "$here/polygram/mcp/words.py" "$F/polygram/mcp/"; sed -i 's/_pref("tavern\.on")/_pref("tavern.always")/' "$F/polygram/mcp/tavernface.py"; $M > "$t/o" 2>&1
[ $? -eq 1 ] && grep -q 'BROKEN tavernface (Bryant.s Tavern) is off until' "$t/o" && ok "tavernface losing its off switch breaks its claim (2026-10-08)" || bad tavern-switch "$(cat "$t/o")"
cp "$here/polygram/mcp/tavernface.py" "$F/polygram/mcp/"
sed -i 's/^ALLOW_MODULES = frozenset({"readline", "path"/ALLOW_MODULES = frozenset({"fs", "readline", "path"/' "$F/polygram/mcp/c4face.py"; $M > "$t/o" 2>&1
[ $? -eq 1 ] && grep -q 'BROKEN when on, c4face runs C4' "$t/o" && ok "c4face's allow-list widened (fs) breaks its claim (2026-10-08, QA1 row 14)" || bad c4face-guard "$(cat "$t/o")"
cp "$here/polygram/mcp/c4face.py" "$F/polygram/mcp/"; sed -i 's/_pref("c4\.on")/_pref("c4.always")/' "$F/polygram/mcp/c4face.py"; $M > "$t/o" 2>&1
[ $? -eq 1 ] && grep -q "BROKEN c4face (C4's own server) is off until" "$t/o" && ok "c4face losing its off switch breaks its claim (2026-10-08, QA1 row 14)" || bad c4face-switch "$(cat "$t/o")"
cp "$here/polygram/mcp/c4face.py" "$F/polygram/mcp/"; printf '\nopen("x", "w")\n' >> "$F/polygram/mcp/c4face.py"; $M > "$t/o" 2>&1
[ $? -eq 1 ] && grep -q 'BROKEN c4face writes no file' "$t/o" && ok "c4face opening a file for writing breaks its claim (2026-10-08)" || bad c4face-write "$(cat "$t/o")"
cp "$here/polygram/mcp/c4face.py" "$F/polygram/mcp/"
# 2026-10-10 (F3, pass 3, C5b J1): the opt-in usage record (the frame) is in PRIVACY.md -- its file, its
# column-names file, the variable that moves it, the switch, off by default, and how to remove it --
# as checked claims and a table row; and the Terms' Licenses bullet says CC BY-SA 4.0 for writing (C5b J2).
$M > "$t/o" 2>&1
grep -q '^- the usage record' "$t/out/PRIVACY.md" && grep -q 'stats/fr' "$t/out/PRIVACY.md" && grep -q 'stats/d/fr' "$t/out/PRIVACY.md" \
  && grep -q 'MENTCACHED_FRAME' "$t/out/PRIVACY.md" && grep -q 'usage.capture' "$t/out/PRIVACY.md" && grep -qi 'off by default' "$t/out/PRIVACY.md" \
  && grep -q '^| usage record' "$t/out/PRIVACY.md" && grep -qi 'to remove it' "$t/out/PRIVACY.md" \
  && ok "the opt-in usage record is named in PRIVACY.md: file, names file, variable, switch, default off, removal" || bad frame-privacy "$(grep -n -i 'frame\|usage' "$t/out/PRIVACY.md" | head -5)"
sed -n '/^## Licenses/,/^## Changing/p' "$t/out/TERMS-OF-SERVICE.md" > "$t/lic"
grep -q 'Writing (books, sheets, notes): Creative Commons Attribution-ShareAlike 4.0 (CC BY-SA 4.0)' "$t/lic" && ! grep -qE 'Attribution 4\.0|CC BY 4\.0' "$t/lic" \
  && ok "the Terms' Licenses bullet says CC BY-SA 4.0 for writing, and no CC BY 4.0" || bad licence-bullet "$(grep -n Writing "$t/lic")"
sed -i 's#"\.mentcached" / "stats" / "fr"#".mentcached" / "stats" / "frame"#' "$F/polygram/mcp/spans.py"; $M > "$t/o" 2>&1
[ $? -eq 1 ] && grep -q 'BROKEN the usage record' "$t/o" && ok "a moved usage record breaks its claim (2026-10-10)" || bad frame-moved "$(cat "$t/o")"
cp "$here/polygram/mcp/spans.py" "$F/polygram/mcp/"; sed -i 's#"usage\.capture": ("off"#"usage.capture": ("on"#' "$F/polygram/mcp/prefs.py"; $M > "$t/o" 2>&1
[ $? -eq 1 ] && grep -q 'BROKEN the usage record is off by default' "$t/o" && ok "usage.capture defaulting on breaks its claim (2026-10-10)" || bad frame-default "$(cat "$t/o")"
cp "$here/polygram/mcp/prefs.py" "$F/polygram/mcp/"
# 2026-10-10 (turn 2, lane T). SPEC, before the code:
#   T5 "The Terms read as two partners and one collection: tests/terms-v2-spec.awk passes on the
#       minted Terms (V1-V6), when the canonical TERMS block can be reached."
#   T6 "The Privacy Policy says Llama Bridge and Tavern are Bryant's, and calls itself part of our
#       shared writing; the old line 'This policy is writing, under' is gone."
#   T7 "--also DIR gives each copy one PROVENANCE row in DIR/.c4/PROVENANCE.tsv: five tab-separated
#       columns, a tree-relative origin (the tree's own name first, never a leading / or drive),
#       the sha256's first 16 hex of the copy; a second run with the same bytes adds nothing."
#   T8 "New bytes re-lift the row: one row still, the new hash, and the note keeps the old one."
#   T9 "--row DIR writes the rows for a pair already in DIR without minting, and refuses a DIR whose
#       pair is not the one in --out."
C4M=""; for c in "$here/../c4" "$here/../../c4"; do [ -f "$c/man/licensing-defaults.md" ] && { C4M=$c; break; }; done
if [ -n "$C4M" ]; then
  mkdir -p "$t/c4/man"; cp "$C4M/man/licensing-defaults.md" "$t/c4/man/"
  $M > "$t/o" 2>&1
  awk -f "$here/tests/terms-v2-spec.awk" "$t/out/TERMS-OF-SERVICE.md" > "$t/v" 2>&1 && ok "T5 the Terms read as two partners and one collection ($(grep -c '^ok' "$t/v") spec rows)" || bad T5 "$(grep FAIL "$t/v")"
else echo "NOT CHECKED T5: no c4/man/licensing-defaults.md beside this tree"; fi
grep -q "Bryant's Llama" "$t/out/PRIVACY.md" && grep -q 'part of our shared writing' "$t/out/PRIVACY.md" && ! grep -q 'This policy is writing, under' "$t/out/PRIVACY.md" \
  && ok "T6 the Privacy Policy names Bryant's servers and is part of our shared writing" || bad T6 "$(tail -3 "$t/out/PRIVACY.md")"
O="$F/dist/vibrobeast"; A="$t/shelf"; mkdir -p "$O" "$A"
sh "$F/bin/tp2mt" --out "$O" --also "$A" > "$t/o" 2>&1; sh "$F/bin/tp2mt" --out "$O" --also "$A" > "$t/o2" 2>&1
PV="$A/.c4/PROVENANCE.tsv"
rows=$(grep -v '^#' "$PV" 2>/dev/null | awk -F'\t' 'NF==5' | wc -l | tr -d ' ')
h=$(sha256sum < "$A/TERMS-OF-SERVICE.md" | cut -c1-16)
row=$(awk -F'\t' '$1=="TERMS-OF-SERVICE.md"' "$PV" 2>/dev/null)
o=$(printf '%s' "$row" | cut -f2); rh=$(printf '%s' "$row" | cut -f3)
[ "$rows" = 2 ] && [ "$rh" = "$h" ] && [ "$o" = "seat/dist/vibrobeast/TERMS-OF-SERVICE.md" ] && grep -q 'row unchanged' "$t/o2" \
  && ok "T7 --also writes one PROVENANCE row per copy, tree-relative, hashed; a second run adds nothing" || bad T7 "rows=$rows o=$o rh=$rh h=$h $(cat "$PV" 2>/dev/null)"
printf '\n<!-- a changed build -->\n' >> "$O/TERMS-OF-SERVICE.md"; cp "$O/TERMS-OF-SERVICE.md" "$A/"
sh "$F/bin/tp2mt" --out "$O" --row "$A" > "$t/o" 2>&1
n=$(awk -F'\t' '$1=="TERMS-OF-SERVICE.md"' "$PV" | wc -l | tr -d ' '); nh=$(awk -F'\t' '$1=="TERMS-OF-SERVICE.md"{print $3}' "$PV")
[ "$n" = 1 ] && [ "$nh" != "$h" ] && awk -F'\t' '$1=="TERMS-OF-SERVICE.md"' "$PV" | grep -q "re-lifted, was $h" \
  && ok "T8 new bytes re-lift the row, and its note keeps the old hash (the observable tear)" || bad T8 "n=$n nh=$nh $(cat "$t/o")"
printf 'x\n' >> "$A/PRIVACY.md"; sh "$F/bin/tp2mt" --out "$O" --row "$A" > "$t/o" 2>&1; rc=$?
[ $rc -eq 2 ] && grep -q 'is not the pair in' "$t/o" && ok "T9 --row refuses a copy that is not the pair in --out" || bad T9 "rc=$rc $(cat "$t/o")"
if [ "${1:-}" = --prove-red ]; then
  before=$fail; grep -q 'import urllib' "$t/out/PRIVACY.md" && ok PLANTED || bad "PLANTED (must FAIL)" x >/dev/null
  # T5's own red: a one-desk line planted in a copy of the minted Terms must fail the awk spec
  sed 's/^Credit for the collection: .*/Unless a work says otherwise, what Corwin Brust publishes, and what/' "$t/out/TERMS-OF-SERVICE.md" > "$t/red.md"
  if awk -f "$here/tests/terms-v2-spec.awk" "$t/red.md" > "$t/v" 2>&1; then echo "FAIL: terms-v2-spec passed a planted one-desk line"; exit 1
  else echo "ok   prove-red T5: the planted one-desk line goes red ($(grep -c '^FAIL' "$t/v") FAIL rows)"; fi
  [ $fail -gt $before ] && { echo "PASS: harness correctly went red under a planted bad expectation"; exit 0; }
  echo "FAIL: harness could not go red"; exit 1
fi
echo "TOTAL pass=$pass fail=$fail"; [ $fail -eq 0 ]
