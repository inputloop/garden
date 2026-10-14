#!/bin/sh
# landcheck-tests.sh — fixtures + expected verdicts for bin/landcheck.sh.
# usage: sh tests/landcheck-tests.sh            (run from the AS4CE0001 root)
#        sh tests/landcheck-tests.sh --prove-red (plant a wrong expectation; harness must go red)
# Copyright 2026 Corwin Brust <corwin@bru.st> — GPLv3-or-later. Authored by Fable 2026-09-04.
#
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
set -u
here=$(cd "$(dirname "$0")/.." && pwd); L="$here/bin/landcheck.sh"; F="$here/tests/fixtures/landcheck/good-run"
t=${TMPDIR:-/tmp}/landcheck-tests.$$; mkdir -p "$t"; pass=0; fail=0
expect() { # expect NAME EXIT-CODE GREP-PATTERN DIR
  out=$(sh "$L" "$4" 2>&1); code=$?
  if [ "$code" -eq "$2" ] && printf '%s\n' "$out" | grep -q -- "$3"; then pass=$((pass+1)); echo "ok   $1"
  else fail=$((fail+1)); echo "FAIL $1 (exit=$code want $2; pattern '$3')"; printf '%s\n' "$out" | sed 's/^/     /'; fi
}
mk() { rm -rf "$t/$1"; cp -r "$F" "$t/$1"; }

expect good-fixture-passes 0 'TOTAL pass=[0-9]* fail=0' "$F"
mk unset;   sed -i 's/^hot-list: none$/hot-list: UNSET/' "$t/unset/RECEIPT.md";            expect receipt-unset-counted 1 'FAIL  R1 .*1 field' "$t/unset"
mk csspt;   printf 'CSSPT\n' >> "$t/csspt/MODEL-B-fixture.md";                              expect csspt-reappears 1 'FAIL  B13' "$t/csspt"
mk feels;   printf 'Mentat feels at home here.\n' >> "$t/feels/MODEL-B-fixture.md";          expect feelings-language 1 'FAIL  B10' "$t/feels"
mk noname;  sed -i 's/MENTAT-APARTMENT-HUNTING/MODEL-B/' "$t/noname/MODEL-B-fixture.md";     expect name-flattened 1 'FAIL  B6' "$t/noname"
mk journal; sed -i 's/^I revised nothing/The model was revised/' "$t/journal/MODEL-A-fixture.md"; expect journal-not-first-person 1 'FAIL  B12' "$t/journal"
mk nofoot;  sed -i '/Footer/d' "$t/nofoot/MODEL-A-fixture.md";                               expect missing-footer 1 'FAIL  B11 *MODEL-A present, no footer' "$t/nofoot"
mk nob;     rm "$t/nob/MODEL-B-fixture.md";                                                  expect model-b-missing 1 'UNSET B10' "$t/nob"
mk nolens;  sed -i 's/sha256 0000000000000000//; s/`lens.py converge`//; s/converge//g' "$t/nolens/MODEL-B-fixture.md"; expect no-lens-trace 1 'FAIL  B4' "$t/nolens"

if [ "${1:-}" = "--prove-red" ]; then
  echo "== prove-red: planting a wrong expectation (good fixture must FAIL) =="
  expect PLANTED-wrong-expectation 1 'TOTAL pass=[0-9]* fail=0' "$F"
  rm -rf "$t"
  if [ "$fail" -eq 1 ]; then echo "PASS: harness correctly went red under a planted bad expectation"; exit 0; else echo "FAIL: harness did not go red"; exit 1; fi
fi
rm -rf "$t"; printf '%d passed, %d failed\n' "$pass" "$fail"; [ "$fail" -eq 0 ]
