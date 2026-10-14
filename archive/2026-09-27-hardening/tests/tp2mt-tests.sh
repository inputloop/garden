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
# 2026-09-26: the pair must reach the tree's MANIFEST and the installable .plugin (it reached neither)
P="$t/plug/vibrobeast"; mkdir -p "$P"; printf 'x\n' > "$P/README.md"
( cd "$P" && printf '%s  ./README.md\n' "$(sha256sum < README.md | cut -d' ' -f1)" > MANIFEST )
python3 -c 'import sys,zipfile; z=zipfile.ZipFile(sys.argv[1],"w"); z.write(sys.argv[2]+"/README.md","README.md"); z.write(sys.argv[2]+"/MANIFEST","MANIFEST"); z.close()' "$P.plugin" "$P"
sh "$F/bin/tp2mt" --out "$P" > "$t/o" 2>&1; sh "$F/bin/tp2mt" --out "$P" > "$t/o" 2>&1
n=$(grep -c -e '  ./PRIVACY.md$' -e '  ./TERMS-OF-SERVICE.md$' "$P/MANIFEST")
good=$( cd "$P" && while read -r h f; do [ "$(sha256sum < "$f" | cut -d' ' -f1)" = "$h" ] || echo bad; done < MANIFEST )
inzip=$(python3 -c 'import sys,zipfile; n=zipfile.ZipFile(sys.argv[1]).namelist(); print(sum(x in n for x in ("PRIVACY.md","TERMS-OF-SERVICE.md","MANIFEST","README.md")), len(n))' "$P.plugin")
[ "$n" = 2 ] && [ -z "$good" ] && [ "$inzip" = "4 4" ] && ok "the pair is entered in the tree's MANIFEST once (twice run) and carried in the .plugin" || bad carry "n=$n good=$good inzip=$inzip $(cat "$t/o")"
printf 'import urllib.request\n' >> "$F/polygram/mcp/persona.py"; $M > "$t/o" 2>&1; rc=$?
[ $rc -eq 1 ] && grep -q 'BROKEN no server opens a network connection' "$t/o" && grep -q REFUSED "$t/o" && ok "a network import breaks the claim and refuses the mint" || bad net "rc=$rc $(cat "$t/o")"
cp "$here/polygram/mcp/persona.py" "$F/polygram/mcp/"; sed -i 's/"prefs\.tsv"/"settings.tsv"/' "$F/polygram/mcp/prefs.py"; $M > "$t/o" 2>&1
[ $? -eq 1 ] && grep -q 'BROKEN preferences are kept' "$t/o" && ok "a moved store breaks its claim: the policy is never minted around a false sentence" || bad store "$(cat "$t/o")"
if [ "${1:-}" = --prove-red ]; then
  before=$fail; grep -q 'import urllib' "$t/out/PRIVACY.md" && ok PLANTED || bad "PLANTED (must FAIL)" x >/dev/null
  [ $fail -gt $before ] && { echo "PASS: harness correctly went red under a planted bad expectation"; exit 0; }
  echo "FAIL: harness could not go red"; exit 1
fi
echo "TOTAL pass=$pass fail=$fail"; [ $fail -eq 0 ]
