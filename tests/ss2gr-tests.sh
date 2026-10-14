#!/bin/sh
# ss2gr-tests -- harness for bin/ss2gr: the tool's own --prove-red, then one check against this tree.
# usage: sh tests/ss2gr-tests.sh [--prove-red]
# Copyright (C) 2026 Corwin Brust <corwin@bru.st>.  Authored by Mentat (for Corwin).
# SPDX-License-Identifier: GPL-3.0-or-later
# This program is free software: you can redistribute it and/or modify it under the terms
# of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or (at your option) any later version.
# This file is part of vibrobeast.  It is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software Foundation, either
# version 3 of the License, or (at your option) any later version.  WITHOUT ANY WARRANTY; <https://www.gnu.org/licenses/>.
set -u
here=$(cd "$(dirname "$0")/.." && pwd); tool=$here/bin/ss2gr; pass=0; fail=0
ok() { pass=$((pass+1)); echo "ok   $1"; }; no() { fail=$((fail+1)); echo "FAIL $1: $2"; }
t=$(mktemp -d) || exit 2; trap 'rm -rf "$t"' EXIT HUP INT TERM
sh "$tool" --prove-red > "$t/o" 2>&1 && ok "ss2gr --prove-red" || no "ss2gr --prove-red" "$(tail -2 "$t/o")"
sh "$tool" --usage "$t/none.tsv" > "$t/o" 2>&1 && grep -q '^nongnu-steward ' "$t/o" && grep -q 'absent: no soft_skill_read' "$t/o" && ok "the report lists this tree's soft skills and names an absent ledger" || no "report" "$(cat "$t/o")"
sh "$tool" --graduate nongnu-steward --root "$t" > "$t/o" 2>&1; [ $? -eq 1 ] && ok "graduating into an empty root refuses (no soft skill there)" || no "refuse" "$(cat "$t/o")"
if [ "${1:-}" = --prove-red ]; then
  # plant: two recorded reads; the "zero reads" expectation above must now FAIL, or the harness sees nothing
  printf 'ts\tname\troot\tfile\n2026-09-24T00:00:00Z\tnongnu-steward\tr\tSKILL.md\n2026-09-25T00:00:00Z\tnongnu-steward\tr\tSKILL.md\n' > "$t/u.tsv"
  sh "$tool" --usage "$t/u.tsv" > "$t/o" 2>&1; grep -q '^nongnu-steward  *0  *0' "$t/o" && { echo "FAIL: harness did not go red (two planted reads still read as zero)"; exit 1; }
  grep -q '^nongnu-steward  *2  *2' "$t/o" || { echo "FAIL: planted reads not counted: $(grep nongnu "$t/o")"; exit 1; }
  echo "PASS: harness goes red under a planted fault (two planted reads break the zero-reads expectation)"; exit 0; fi
echo "TOTAL pass=$pass fail=$fail"; [ $fail -eq 0 ]
