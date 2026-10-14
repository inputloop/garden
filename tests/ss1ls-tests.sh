#!/bin/sh
# ss1ls-tests.sh -- the awk lister agrees with the python loader on the same folders.
# tier: smoke
# usage: sh tests/ss1ls-tests.sh | --prove-red      (run from the AS4CE0001 root)
# Copyright 2026 Corwin Brust <corwin@bru.st> -- GPLv3-or-later. Authored by Mentat (for Corwin).
#
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
set -u
here=$(cd "$(dirname "$0")/.." && pwd); S="sh $here/bin/ss1ls"
t=$(mktemp -d 2>/dev/null) || { t=${TMPDIR:-/tmp}/ss1ls-tests.$$; mkdir -p "$t"; }
trap 'rm -rf "$t"' EXIT INT TERM
pass=0; fail=0
ok()  { pass=$((pass+1)); echo "ok   $1"; }
bad() { fail=$((fail+1)); echo "FAIL $1 -- $2"; }
has() { if grep -q -e "$2" "$3"; then ok "$1"; else bad "$1" "no /$2/ in: $(head -3 "$3" | tr '\n' '|')"; fi; }

# the workspace seed must be visible to both readers
$S --tsv "$here/SOFT-SKILLS" > "$t/o" 2>&1; rc=$?
[ $rc -eq 0 ] && ok "lists the workspace SOFT-SKILLS" || bad "list rc" "$rc: $(cat "$t/o")"
has "the seed soft skill is listed" '^soft-skills	' "$t/o"
awk_names=$(cut -f1 "$t/o" | sort | tr '\n' ' ')
py_names=$(cd "$here" && SOFT_SKILLS="$here/SOFT-SKILLS" PYTHONDONTWRITEBYTECODE=1 python3 -c '
import sys; sys.path.insert(0, sys.argv[1])
from polygram.mcp import softskills as s
print(" ".join(sorted(k["name"] for k in s.scan()["skills"])) + " ")' "$here")
[ "$awk_names" = "$py_names" ] && ok "awk and python list the same names ($awk_names)" || bad "cross-check" "awk [$awk_names] vs py [$py_names]"
awk_desc=$(grep '^soft-skills	' "$t/o" | cut -f3)
py_desc=$(cd "$here" && SOFT_SKILLS="$here/SOFT-SKILLS" PYTHONDONTWRITEBYTECODE=1 python3 -c '
import sys; sys.path.insert(0, sys.argv[1])
from polygram.mcp import softskills as s
print(next(k["description"] for k in s.scan()["skills"] if k["name"]=="soft-skills"))' "$here")
[ "$awk_desc" = "$py_desc" ] && ok "awk and python agree on the folded description" || bad "desc" "awk [$awk_desc] vs py [$py_desc]"
$S --cat soft-skills "$here/SOFT-SKILLS" > "$t/o" 2>&1; has "--cat prints the body" '^# soft-skills' "$t/o"
$S "$t/absent" > "$t/o" 2>&1; [ $? -eq 1 ] && ok "an absent root exits 1 and says where it looked" || bad "absent" "rc=$?"
$S --prove-red > "$t/o" 2>&1 && ok "ss1ls --prove-red passes" || bad "ss1ls --prove-red" "$(tail -2 "$t/o")"

if [ "${1:-}" = --prove-red ]; then
  before=$fail; has "PLANTED (must FAIL)" 'this text is not there' "$t/o" >/dev/null
  if [ $fail -gt $before ]; then echo "PASS: harness correctly went red under a planted bad expectation"; exit 0; fi
  echo "FAIL: harness could not go red"; exit 1
fi
echo "TOTAL pass=$pass fail=$fail"; [ $fail -eq 0 ]
