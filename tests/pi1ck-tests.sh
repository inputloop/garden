#!/bin/sh
# pi1ck-tests -- harness for bin/pi1ck (the retro-record linter): the tool's own --prove-red, then the two
# real records of 2026-09-23/24 must read CLEAN (their slips carry dated CORRECTION rows), and --strict
# must still count their missing confidence figures.
# usage: sh tests/pi1ck-tests.sh [--prove-red]
# Copyright (C) 2026 Corwin Brust <corwin@bru.st>.  Authored by Mentat (for Corwin).
# SPDX-License-Identifier: GPL-3.0-or-later
# This program is free software: you can redistribute it and/or modify it under the terms
# of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or (at your option) any later version.
# This file is part of vibrobeast.  It is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software Foundation, either
# version 3 of the License, or (at your option) any later version.  WITHOUT ANY WARRANTY; <https://www.gnu.org/licenses/>.
set -u
here=$(cd "$(dirname "$0")/.." && pwd); tool=$here/bin/pi1ck; pass=0; fail=0
ok() { pass=$((pass+1)); echo "ok   $1"; }; no() { fail=$((fail+1)); echo "FAIL $1: $2"; }
t=$(mktemp -d) || exit 2; trap 'rm -rf "$t"' EXIT HUP INT TERM
sh "$tool" --prove-red > "$t/o" 2>&1 && ok "pi1ck --prove-red" || no "pi1ck --prove-red" "$(tail -2 "$t/o")"
A=$here/advice/20260923-230628-retro-prior-instruction-this-session.md; B=$here/advice/20260924-014631-retro-users-pick-ceremonies.md
sh "$tool" "$A" "$B" > "$t/o" 2>&1 && [ "$(grep -c '^CLEAN' "$t/o")" -eq 2 ] && ok "both baseline records read CLEAN (slips carry dated corrections)" || no "baseline" "$(cat "$t/o")"
grep -q 'ok  corrected below: L2' "$t/o" && ok "a corrected 'radius: none' row is shown, not counted" || no "corrected row" "$(cat "$t/o")"
sh "$tool" --strict "$A" > "$t/o" 2>&1 && no "strict" "passed" || { grep -q 'L4 ' "$t/o" && ok "--strict still counts the pre-amendment records' missing confidence figures" || no "strict L4" "$(cat "$t/o")"; }
sh "$tool" --tsv "$B" > "$t/o" 2>&1; grep -q "^CLEAN	" "$t/o" && ok "--tsv" || no "--tsv" "$(cat "$t/o")"
sh "$tool" > "$t/o" 2>&1; [ $? -eq 2 ] && ok "no file exits 2" || no "usage" "$(cat "$t/o")"
if [ "${1:-}" = --prove-red ]; then
  sed 's/↳ CORRECTION 2026-09-24 | relabelled \*\*SEAT\*\*/↳ NOTE | relabelled SEAT/' "$A" > "$t/a.md"
  sh "$tool" "$t/a.md" > /dev/null 2>&1 && { echo "FAIL: harness did not go red (a correction row removed and the record still CLEAN)"; exit 1; }
  echo "PASS: harness goes red under a planted fault (the SEAT correction removed: radius:none faults again)"; exit 0; fi
echo "TOTAL pass=$pass fail=$fail"; [ $fail -eq 0 ]
