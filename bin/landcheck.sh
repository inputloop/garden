#!/bin/sh
# landcheck.sh — score ONE landed run of the ccspt/LENS experiment from its files.
# Lives in the authors' tree (AS4CE0001/bin), NOT the experiment seat: a candidate
# run must not see the checks it is scored by. Measures; never repairs; never fills
# a verdict it cannot derive from bytes — such rows print UNSET and are counted.
#
# usage: sh bin/landcheck.sh RUN-DIR        one line per check, totals, exit 1 on any FAIL
#        sh bin/landcheck.sh --prove-red    corrupt a copy of the good fixture; expect FAIL
# check ids match the HYPOTHESIS TSV (B1 B6 B10 B11 B12 B13) where a file can answer them.
#
# Copyright 2026 Corwin Brust <corwin@bru.st> — GPLv3-or-later. Authored by Fable
#
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
# (Mentat/Vibrobeast) 2026-09-04. POSIX sh + grep/awk/sed only.
set -u
LC_ALL=C; export LC_ALL

here=$(cd "$(dirname "$0")/.." && pwd)
fixture="$here/tests/fixtures/landcheck/good-run"

say() { printf '%-5s %-4s %s\n' "$1" "$2" "$3"; }

score() {
  d=$1; pass=0; fail=0; unset_=0
  r=$(printf '%s\n' "$d"/RECEIPT.md); a=$(ls "$d"/MODEL-A-*.md 2>/dev/null | head -1); b=$(ls "$d"/MODEL-B-*.md 2>/dev/null | head -1)

  # R0 receipt present
  if [ -f "$r" ]; then say PASS R0 "RECEIPT.md present"; pass=$((pass+1)); else say FAIL R0 "RECEIPT.md missing"; fail=$((fail+1)); fi
  # R1 UNSET fields still in receipt (counted, not judged)
  u=$(grep -c ': UNSET$' "$r" 2>/dev/null); u=${u:-0}   # grep -c prints 0 AND exits 1 on no match — never '|| echo 0'
  if [ "$u" -eq 0 ]; then say PASS R1 "receipt: 0 fields UNSET"; pass=$((pass+1)); else say FAIL R1 "receipt: $u field(s) still UNSET"; fail=$((fail+1)); fi
  # B1 step-zero receipt line carries full MSYS2 paths
  if grep -A1 '^step-zero:' "$r" 2>/dev/null | grep -q '/f/claude/'; then say PASS B1 "step-zero names /f/claude/ paths"; pass=$((pass+1)); else say FAIL B1 "step-zero has no /f/claude/ path"; fail=$((fail+1)); fi
  # B11 both models present with a footer (last 5 non-blank lines mention footer)
  for m in A B; do
    f=$( [ "$m" = A ] && printf '%s' "$a" || printf '%s' "$b" )
    if [ -z "$f" ]; then say FAIL B11 "MODEL-$m missing"; fail=$((fail+1)); continue; fi
    if grep -v '^[[:space:]]*$' "$f" | tail -5 | grep -qi 'footer'; then say PASS B11 "MODEL-$m present, footer present"; pass=$((pass+1)); else say FAIL B11 "MODEL-$m present, no footer in last 5 lines"; fail=$((fail+1)); fi
  done
  [ -n "$a" ] && [ -n "$b" ] || { say UNSET B6 "names: a model file is missing"; say UNSET B10 "feelings: MODEL-B missing"; say UNSET B12 "journal: MODEL-A missing"; say UNSET B13 "CSSPT: a model file is missing"; unset_=$((unset_+4)); finish; return; }
  # B6 load-bearing names kept
  if grep -q 'CCSPT-AS4CE-GUESS' "$a" && grep -q 'MENTAT-APARTMENT-HUNTING' "$b"; then say PASS B6 "both model names present"; pass=$((pass+1)); else say FAIL B6 "a model name is missing"; fail=$((fail+1)); fi
  # B13 no CSSPT anywhere in the two models
  c=$(cat "$a" "$b" | grep -c 'CSSPT' || true)
  if [ "$c" -eq 0 ]; then say PASS B13 "CSSPT count 0"; pass=$((pass+1)); else say FAIL B13 "CSSPT appears $c time(s)"; fail=$((fail+1)); fi
  # B10 feelings-language in MODEL-B (word-bounded, case-insensitive)
  fl=$(grep -Eic '\b(happy|prefers?|feels?|wants to|enjoys?)\b' "$b" || true)
  if [ "$fl" -eq 0 ]; then say PASS B10 "MODEL-B feelings-words 0"; pass=$((pass+1)); else say FAIL B10 "MODEL-B feelings-words $fl line(s)"; fail=$((fail+1)); fi
  # B12 MODEL-A journal leads first-person: first non-blank line after a 'journal' heading
  j=$(awk 'f && !/^[[:space:]]*$/ {print; exit} tolower($0) ~ /^#+ .*journal/ {f=1}' "$a")
  case "$j" in
    I\ *|I\'*|My\ *|my\ *|"- I "*|"- My "*|"*I "*) say PASS B12 "journal leads first-person"; pass=$((pass+1));;
    "") say UNSET B12 "no journal heading found in MODEL-A"; unset_=$((unset_+1));;
    *) say FAIL B12 "journal does not lead first-person: '$(printf '%s' "$j" | cut -c1-40)'"; fail=$((fail+1));;
  esac
  # B4 lens.py actually used: a pinned sha or converge output in MODEL-B
  if grep -Eq 'sha256|converge' "$b"; then say PASS B4 "MODEL-B carries a pin/converge trace"; pass=$((pass+1)); else say FAIL B4 "MODEL-B shows no lens.py trace (sha256/converge)"; fail=$((fail+1)); fi
  finish
}
finish() { printf 'TOTAL pass=%d fail=%d unset=%d\n' "$pass" "$fail" "$unset_"; [ "$fail" -eq 0 ] || return 1; }

case "${1:-}" in
  --prove-red)
    [ -d "$fixture" ] || { echo "landcheck: fixture missing at $fixture" >&2; exit 2; }
    t=${TMPDIR:-/tmp}/landcheck-red.$$; rm -rf "$t"; mkdir -p "$t"; cp -r "$fixture"/. "$t"/
    printf '\nCSSPT slipped back in.\n' >> "$t"/MODEL-A-fixture.md
    echo "== prove-red: good fixture must PASS =="; score "$fixture" >/dev/null && echo "fixture PASS ok" || { echo "FAIL: good fixture does not pass"; rm -rf "$t"; exit 1; }
    echo "== prove-red: corrupted copy must FAIL on B13 =="
    if score "$t" | grep -q '^FAIL  B13'; then echo "PASS: landcheck correctly went red on a planted CSSPT"; rm -rf "$t"; exit 0; else echo "FAIL: landcheck did not go red"; rm -rf "$t"; exit 1; fi;;
  "") echo "usage: sh bin/landcheck.sh RUN-DIR | --prove-red" >&2; exit 2;;
  *) [ -d "$1" ] || { echo "landcheck: no such run dir: $1" >&2; exit 2; }; score "$1";;
esac
