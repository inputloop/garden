# SPDX-License-Identifier: GPL-3.0-or-later
#
# lr1tg.awk -- LaRder 1 TanGle: tangle an Org file without Emacs (reader one).
#
#   awk -v BASE=DIR -f lr1tg.awk FILE.org
#
# Reader two is Emacs' own org-babel-tangle; the test compares the two.
# This is a STRICT SUBSET of Org tangling. Anything outside the subset is an
# error (exit 1, nothing written), never a silent guess:
#   - blocks:   "#+begin_src LANG :tangle PATH|no :noweb yes|no :padline no :mkdirp yes"
#               markers at column 0, any case; no other header arguments
#   - defaults: "#+property: header-args ..." (plain header-args only)
#   - names:    "#+name: X" directly above a block; each name used once
#   - noweb:    a line that is exactly <<X>> at column 0, in a block with
#               :noweb yes; the referenced block is inserted whole; no nesting,
#               no inline references, no blank first/last line in the target
#   - several blocks tangled to one path are joined by one newline
# Org itself turns an undefined <<X>> into an empty line without complaint
# (observed, Org 9.6.15); this tangler refuses it.
# POSIX awk only (tested with mawk 1.3.4).

function die(msg) {
    printf "lr1tg: %s:%d: %s\n", FILENAME, FNR, msg | "cat 1>&2"
    close("cat 1>&2")
    failed = 1
    exit 1
}
function trim(s) { sub(/^[ \t]+/, "", s); sub(/[ \t]+$/, "", s); return s }

# Parse ":key value" pairs from tokens tok[from..n] into array A.
function pairs(from, n, A,    i, k) {
    for (i = from; i <= n; i++) {
        if (substr(tok[i], 1, 1) != ":") die("unsupported token '" tok[i] "' (expected :key value)")
        k = substr(tok[i], 2)
        if (i + 1 > n || substr(tok[i + 1], 1, 1) == ":") die("header argument :" k " has no value")
        if (k != "tangle" && k != "noweb" && k != "padline" && k != "mkdirp")
            die("unsupported header argument :" k)
        if (tok[i + 1] ~ /["']/) die("quotes in header arguments are unsupported")
        A[k] = tok[i + 1]
        i++
    }
}

BEGIN {
    if (BASE == "" || BASE ~ /'/) { print "lr1tg: BASE must be set and contain no quote" | "cat 1>&2"; failed = 1; exit 1 }
    state = "text"; nblk = 0
}

{
    if ($0 ~ /\r/) die("carriage return found; convert the file to LF line ends")
    low = tolower($0)
}

state == "src" {
    if (low ~ /^#\+end_src[ \t]*$/) {
        nblk++
        body[nblk] = cbody; nl[nblk] = cn; blkline[nblk] = srcline
        tangle[nblk] = H["tangle"]; noweb[nblk] = H["noweb"]
        if (curname != "") {
            if (curname in byname) die("duplicate block name '" curname "'")
            byname[curname] = nblk
        }
        state = "text"; curname = ""
        next
    }
    if ($0 ~ /^,(\*|#\+)/) die("comma-escaped lines are unsupported")
    if (low ~ /^[ \t]+#\+(begin|end)_src/) die("indented block marker inside a block")
    cn++; cline[nblk + 1, cn] = $0; cbody = (cn == 1) ? $0 : cbody "\n" $0
    next
}

state == "other" {
    if (low ~ ("^#\\+end_" kind "[ \t]*$")) state = "text"
    next
}

# state == "text"
{
    if (low ~ /^[ \t]+#\+(begin|end)_/) die("indented block marker; Org strips indentation, this tangler does not")
    if (low ~ /^#\+property:/) {
        rest = trim(substr($0, 12)); n = split(rest, tok, /[ \t]+/)
        if (tok[1] ~ /^header-args:/) die("language-specific header-args are unsupported")
        if (tok[1] == "header-args") pairs(2, n, D)
        curname = ""; next
    }
    if (low ~ /^#\+name:/) {
        curname = trim(substr($0, 8))
        if (curname !~ /^[A-Za-z0-9_.-]+$/) die("block name must be letters, digits, _ . -")
        next
    }
    if (low ~ /^#\+begin_src/) {
        rest = trim(substr($0, 12)); n = split(rest, tok, /[ \t]+/)
        if (rest == "") die("block has no language")
        delete H
        H["tangle"] = D["tangle"]; H["noweb"] = D["noweb"]; H["padline"] = D["padline"]; H["mkdirp"] = D["mkdirp"]
        pairs(2, n, H)
        if (H["tangle"] != "" && H["tangle"] != "no") {
            if (H["padline"] != "no") die(":padline no is required on tangled blocks (Org pads by default)")
            if (H["tangle"] !~ /^[A-Za-z0-9._-]+(\/[A-Za-z0-9._-]+)*$/ || H["tangle"] ~ /(^|\/)\.\.(\/|$)/)
                die("tangle path must be relative, plain characters, no '..': " H["tangle"])
            if (H["tangle"] ~ /\// && H["mkdirp"] != "yes") die(":mkdirp yes is required for a path with a directory")
        }
        if (H["noweb"] != "" && H["noweb"] != "yes" && H["noweb"] != "no") die(":noweb must be yes or no")
        state = "src"; cbody = ""; cn = 0; srcline = FNR
        next
    }
    if (low ~ /^#\+begin_[a-z]+/) {
        kind = low; sub(/^#\+begin_/, "", kind); sub(/[^a-z].*$/, "", kind)
        state = "other"; curname = ""; next
    }
    curname = ""
}

END {
    if (failed) exit 1
    if (state != "text") { print "lr1tg: unterminated block" | "cat 1>&2"; exit 1 }
    # resolve and expand, writing nothing until every block is good
    nout = 0
    for (b = 1; b <= nblk; b++) {
        if (tangle[b] == "" || tangle[b] == "no") continue
        if (nl[b] == 0) { printf "lr1tg: %s:%d: block is empty\n", FILENAME, blkline[b] | "cat 1>&2"; exit 1 }
        text = ""
        for (i = 1; i <= nl[b]; i++) {
            ln = cline[b, i]
            if (noweb[b] == "yes") {
                if (ln ~ /^<<[A-Za-z0-9_.-]+>>$/) {
                    ref = substr(ln, 3, length(ln) - 4)
                    if (!(ref in byname)) { printf "lr1tg: %s:%d: undefined reference <<%s>>\n", FILENAME, blkline[b] + i, ref | "cat 1>&2"; exit 1 }
                    t = byname[ref]
                    if (t == b) { printf "lr1tg: %s:%d: block refers to itself\n", FILENAME, blkline[b] + i | "cat 1>&2"; exit 1 }
                    if (nl[t] == 0 || cline[t, 1] ~ /^[ \t]*$/ || cline[t, nl[t]] ~ /^[ \t]*$/) {
                        printf "lr1tg: <<%s>> has a blank first or last line; Org's handling differs, so it is refused\n", ref | "cat 1>&2"; exit 1 }
                    for (j = 1; j <= nl[t]; j++)
                        if (cline[t, j] ~ /<<|>>/) { printf "lr1tg: <<%s>> contains a noweb marker (nesting is unsupported)\n", ref | "cat 1>&2"; exit 1 }
                    ln = body[t]
                } else if (ln ~ /<<|>>/) {
                    printf "lr1tg: %s:%d: noweb reference must be alone at column 0\n", FILENAME, blkline[b] + i | "cat 1>&2"; exit 1
                }
            }
            text = (i == 1) ? ln : text "\n" ln
        }
        p = tangle[b]
        if (p in OUT) OUT[p] = OUT[p] "\n" text
        else { OUT[p] = text; order[++nout] = p }
    }
    for (k = 1; k <= nout; k++) {
        p = order[k]; path = BASE "/" p
        d = path; if (sub(/\/[^\/]*$/, "", d) && d != "") system("mkdir -p '" d "'")
        printf "%s\n", OUT[p] > path
        close(path)
        print p
    }
    exit 0
}
