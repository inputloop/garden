#!/bin/sh
# nd1ck-tests -- harness for bin/nd1ck (what the garden asks of the door). Tool's own --prove-red, then
# this tree: every skill gets exactly one verdict row, the counts add up, and --tsv agrees with prose.
# usage: sh tests/nd1ck-tests.sh [--prove-red]
# Copyright (C) 2026 Corwin Brust <corwin@bru.st>.  Authored by Mentat (for Corwin).
# SPDX-License-Identifier: GPL-3.0-or-later
# This program is free software: you can redistribute it and/or modify it under the terms
# of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or (at your option) any later version.
# This file is part of vibrobeast.  It is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software Foundation, either
# version 3 of the License, or (at your option) any later version.  WITHOUT ANY WARRANTY; <https://www.gnu.org/licenses/>.
set -u
here=$(cd "$(dirname "$0")/.." && pwd); tool=$here/bin/nd1ck; pass=0; fail=0
ok() { pass=$((pass+1)); echo "ok   $1"; }; no() { fail=$((fail+1)); echo "FAIL $1: $2"; }
t=$(mktemp -d) || exit 2; trap 'rm -rf "$t"' EXIT HUP INT TERM
sh "$tool" --prove-red > "$t/o" 2>&1 && ok "nd1ck --prove-red" || no "nd1ck --prove-red" "$(tail -2 "$t/o")"
sh "$tool" --tsv > "$t/tsv" 2>&1 || true
n=$(ls -d "$here"/skills/*/ "$here"/SOFT-SKILLS/*/ 2>/dev/null | while read -r d; do [ -f "$d/SKILL.md" ] && echo x; done | wc -l)
[ "$(wc -l < "$t/tsv")" -eq "$n" ] && ok "one verdict row per skill with a SKILL.md ($n)" || no "rows" "$(wc -l < "$t/tsv") rows for $n skills"
sh "$tool" > "$t/p" 2>&1 || true
f=$(grep -c '^DOOR-FREE' "$t/tsv"); r=$(grep -c '^DOOR-READS' "$t/tsv"); q=$(grep -c '^DOOR-REQUIRES' "$t/tsv")
grep -q "DOOR-FREE $f · DOOR-READS $r · DOOR-REQUIRES $q" "$t/p" && ok "prose counts agree with --tsv ($f/$r/$q)" || no "counts" "$(tail -1 "$t/p")"
grep -q '^   door \(PRESENT\|absent\)' "$t/p" && ok "the door's presence at the root is reported" || no "door line" "$(head -3 "$t/p")"
if [ "${1:-}" = --prove-red ]; then
  mkdir -p "$t/skills/planted"; printf -- '---\nname: planted\ndescription: x\n---\nYou must read CLAUDE.md first.\n' > "$t/skills/planted/SKILL.md"
  sh "$tool" --root "$t" --strict > /dev/null 2>&1 && { echo "FAIL: harness did not go red (a planted DOOR-REQUIRES passed --strict)"; exit 1; }
  echo "PASS: harness goes red under a planted fault (a skill that must read CLAUDE.md fails --strict)"; exit 0; fi
echo "TOTAL pass=$pass fail=$fail"; [ $fail -eq 0 ]
