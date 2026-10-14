#!/bin/sh
# persona-shelf-tests.sh -- the persona "is this file a sheet?" rule, re-implemented in awk and
# held against persona.py's classify(), on fixtures and (when the trees are here) on the real shelf.
# tier: smoke
# usage: sh tests/persona-shelf-tests.sh [DIR ...] | --prove-red      (run from the AS4CE0001 root)
# The rule (persona.py, 2026-09-24): a .md file whose name has no SECRET is a sheet when its first
# 15 lines hold an `actor:` line or a `# CHARACTER SHEET|ITEM SHEET|PERSONA` heading, or YAML front
# matter with `name:` whose status:/description: says persona or model ("Model This Book" is a
# title, not a claim).  Two readers of one rule: agreement is evidence, disagreement is a FAIL.
# Copyright 2026 Corwin Brust <corwin@bru.st> -- GPLv3-or-later. Authored by Mentat (for Corwin).
#
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
set -u
here=$(cd "$(dirname "$0")/.." && pwd); cd "$here" || exit 2
t=$(mktemp -d 2>/dev/null) || { t=${TMPDIR:-/tmp}/persona-shelf.$$; mkdir -p "$t"; }
trap 'rm -rf "$t"' EXIT INT TERM
pass=0; fail=0
ok()  { pass=$((pass+1)); echo "ok   $1"; }
bad() { fail=$((fail+1)); echo "FAIL $1 -- $2"; }

# the rule, in awk: prints the base name of every sheet in DIR, sorted
awk_sheets() {
  for f in "$1"/*.md; do
    [ -f "$f" ] || continue
    case $(basename "$f" | tr '[:lower:]' '[:upper:]') in *SECRET*) continue;; esac
    head -n 15 "$f" | awk -v F="$(basename "$f")" '
      NR==1 && $0 ~ /^---[ \t\r]*$/ { fm=1; next }
      fm && $0 ~ /^---[ \t\r]*$/ { fm=0; next }
      { l=tolower($0) }
      l ~ /^actor:/ || l ~ /^#[ \t]+(character sheet|item sheet|persona)([^a-z0-9_]|$)/ { hit=1 }
      fm && l ~ /^name:/ { nm=1 }
      fm && (l ~ /^status:/ || l ~ /^description:/) {
        gsub(/model[ \t]+this[ \t]+book/, "", l)
        if (l ~ /(^|[^a-z0-9_])(persona|model)([^a-z0-9_]|$)/) md=1 }
      END { if (hit || (nm && md)) print F }'
  done | LC_ALL=C sort
}
py_sheets() {
  PYTHONDONTWRITEBYTECODE=1 python3 -c '
import sys; from pathlib import Path
from polygram.mcp import persona
d = Path(sys.argv[1])
print("\n".join(sorted((f.name for f in d.iterdir() if f.is_file() and persona.classify(f)), key=lambda s: s.encode())))
' "$1" | sed '/^$/d'
}
agree() {   # agree LABEL DIR
  awk_sheets "$2" > "$t/a"; py_sheets "$2" > "$t/p"
  if cmp -s "$t/a" "$t/p"; then ok "$1: awk and python agree ($(wc -l < "$t/a" | tr -d ' ') sheets)"
  else bad "$1" "awk/python disagree: $(diff "$t/a" "$t/p" | grep '^[<>]' | tr '\n' ' ')"; fi
}

# A sheet may say its own name: a `name:` line OUTSIDE front matter, first word, slugified.
# Second reader in awk (the name only; slugify here is lower-case + non-alnum to '-').
awk_name() { head -n 15 "$1" | awk 'NR==1 && /^---[ \t\r]*$/ {fm=1; next} fm && /^---[ \t\r]*$/ {fm=0; next}
  !fm && tolower($0) ~ /^name:/ { sub(/^[^:]*:[ \t]*/, ""); split($0, w, /[ \t]/); n=tolower(w[1]); gsub(/[^a-z0-9]+/, "-", n); print n; exit }'; }
py_name() { PYTHONDONTWRITEBYTECODE=1 python3 -c 'import sys; from pathlib import Path; from polygram.mcp import persona; print(persona.classify(Path(sys.argv[1]))["name"])' "$1"; }
mkdir -p "$t/nm"; printf -- '# PERSONA -- the bakery\nname: gh7 (the host; gw7 is the node)\nactor: host\n' > "$t/nm/PERSONA-gw7.md"
a=$(awk_name "$t/nm/PERSONA-gw7.md"); p=$(py_name "$t/nm/PERSONA-gw7.md")
[ "$a" = gh7 ] && [ "$p" = gh7 ] && ok "a sheet's own name: line names it (awk $a, python $p); the file keeps its address" || bad "name line" "awk=$a python=$p"
f=$t/fx; mkdir -p "$f"
printf -- '---\n# CHARACTER SHEET -- ILUNGA\nactor: fiction\n' > "$f/ILUNGA.md"
printf -- '---\n# ITEM SHEET -- pub\nactor: place\n' > "$f/pub.ITEM.md"
printf -- '# PERSONA -- gw7\nactor: host\n' > "$f/PERSONA-gw7.md"
printf -- '---\nname: MERLIN\nstatus: SYNTHETIC -- a test-persona\n---\n' > "$f/MERLIN.md"
printf -- '---\nname: CORWIN\ndescription: a persona model\n---\n' > "$f/CORWIN.md"
printf -- '---\nname: note\nstatus: NOTE for Model This Book\n---\n' > "$f/NOTE.md"
printf -- '---\nname: CORWIN-SECRET\ndescription: a persona model\n---\n' > "$f/CORWIN-SECRET.md"
printf -- '# The character sheets -- a roster\n' > "$f/ROSTER.md"
printf -- '# PERSONAL notes\n' > "$f/PERSONAL.md"
printf -- 'body first\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nactor: too late\n' > "$f/LATE.md"
agree "fixtures" "$f"
awk_sheets "$f" > "$t/a"
printf 'CORWIN.md\nILUNGA.md\nMERLIN.md\nPERSONA-gw7.md\npub.ITEM.md\n' > "$t/want"
cmp -s "$t/a" "$t/want" && ok "fixtures: exactly the five sheets" || bad "fixture set" "$(tr '\n' ' ' < "$t/a")"

# the real shelf, when it is here (argument dirs, else the guesses beside this seat)
if [ $# -gt 0 ] && [ "$1" != --prove-red ]; then dirs="$*"
else  # AS4CE0001 sits at F:/claude/AS4CE/AS4CE0001 on avalon (the rest two levels up), or beside them
  dirs="h/persona book"
  for r in c4/h/persona c4/h/cast c4/q/words pub/method/h modelthisbook; do
    if [ -d "../../$r" ]; then dirs="$dirs ../../$r"; elif [ -d "../$r" ]; then dirs="$dirs ../$r"; fi
  done
fi
for d in $dirs; do [ -d "$d" ] && agree "real $d" "$d"; done

if [ "${1:-}" = --prove-red ]; then
  before=$fail; printf 'X.md\n' > "$t/want"; cmp -s "$t/a" "$t/want" || bad "PLANTED (must FAIL)" "planted" >/dev/null
  if [ $fail -gt $before ]; then echo "PASS: harness correctly went red under a planted bad expectation"; exit 0; fi
  echo "FAIL: harness could not go red"; exit 1
fi
echo "TOTAL pass=$pass fail=$fail"; [ $fail -eq 0 ]
