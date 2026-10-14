#!/bin/sh
# gd1ck-tests.sh -- expected behaviours for bin/gd1ck (the garden kit), on a fixture tree.
# usage: sh tests/gd1ck-tests.sh | --prove-red      (run from the AS4CE0001 root)
# Copyright 2026 Corwin Brust <corwin@bru.st> -- GPLv3-or-later. Authored by Mentat (for Corwin).
#
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
set -u
here=$(cd "$(dirname "$0")/.." && pwd); G="sh $here/bin/gd1ck"
t=$(mktemp -d 2>/dev/null) || { t=${TMPDIR:-/tmp}/gd1ck-tests.$$; mkdir -p "$t"; }
trap 'rm -rf "$t"' EXIT INT TERM
pass=0; fail=0
ok()  { pass=$((pass+1)); echo "ok   $1"; }
bad() { fail=$((fail+1)); echo "FAIL $1 -- $2"; }
has() { if grep -q -e "$2" "$3"; then ok "$1"; else bad "$1" "no /$2/ in output"; fi; }
hasnt() { if grep -q -e "$2" "$3"; then bad "$1" "found /$2/"; else ok "$1"; fi; }

F=$t/tree; mkdir -p "$F/tests" "$F/skills/good" "$F/skills/long" "$F/skills/skill-sign/scripts" "$F/bin"
cp "$here/skills/skill-sign/scripts/skill-lint.sh" "$F/skills/skill-sign/scripts/"
printf '#!/bin/sh\necho TOTAL pass=3 fail=0\n' > "$F/tests/alpha-tests.sh"; printf 'alpha v1\n' > "$F/bin/alpha"
printf '#!/bin/sh\necho TOTAL pass=1 fail=2; exit 1\n' > "$F/tests/beta-tests.sh"
printf '#!/bin/sh\n[ "$1" = --prove-red ] && { echo prove-red PASS; exit 0; }\necho ok; touch "%s/ran"\n' "$t" > "$F/tests/gamma-tests.sh"
printf '#!/bin/sh\n[ "${LC_ALL:-}" = C ] && { echo "breaks under C"; exit 1; }; echo TOTAL pass=1 fail=0\n' > "$F/tests/delta-tests.sh"
printf -- '---\nname: good\ndescription: A fine skill.\n---\n\nbody\n' > "$F/skills/good/SKILL.md"
printf -- '---\nname: long\ndescription: %s\n---\n' "$(awk 'BEGIN{for(i=0;i<1100;i++)printf "x"}')" > "$F/skills/long/SKILL.md"
R="$G --root $F --no-c4"

# --list runs nothing
$R --list > "$t/o" 2>&1; has "list names a tool leg" 'alpha' "$t/o"
[ -f "$t/ran" ] && bad "list ran nothing" "a suite ran" || ok "list ran nothing"
has "list sees --prove-red twin" 'gamma-tests.sh --prove-red' "$t/o"
hasnt "list: a suite without --prove-red gets no twin" 'alpha-tests.sh --prove-red' "$t/o"

# a full run: failures make the verdict RED and exit 1
LC_ALL=en_US.UTF-8 $R > "$t/o" 2>&1; rc=$?
[ $rc -eq 1 ] && ok "a failing suite exits 1" || bad "exit" "rc=$rc"
has "failing suite -> RED item" 'RED       beta' "$t/o"
has "over-long description fails lint" 'FAIL L4' "$t/o"
has "failure shows its last lines" '| TOTAL pass=1 fail=2' "$t/o"
has "summary line is the detail" 'alpha.*TOTAL pass=3 fail=0' "$t/o"
has "benchmark prints size" 'good .*B .*w ~[0-9]*tok(est)' "$t/o"
has "no c4 is UNCHECKED, never GREEN" 'UNCHECKED c4' "$t/o"
hasnt "default runs legs under the caller's locale" 'breaks under C' "$t/o"
has "verdict names the failures" 'verdict: RED' "$t/o"

# --c-locale is a portability probe
$R --c-locale delta > "$t/o" 2>&1; has "--c-locale runs legs under C" 'breaks under C' "$t/o"

# item filter
$R alpha > "$t/o" 2>&1; rc=$?; [ $rc -eq 0 ] && ok "filtered run of a green item exits 0" || bad "filter rc" "$rc"
hasnt "filter runs only that item" 'beta' "$t/o"
$R nosuch > "$t/o" 2>&1; [ $? -eq 2 ] && ok "unknown item exits 2" || bad "unknown item" "rc"

# exit 77 is SKIPPED (the automake convention): shown as such, never GREEN, never RED (2026-09-27)
printf '#!/bin/sh\necho "SKIP: no widget here"; exit 77\n' > "$F/tests/epsilon-tests.sh"
$R epsilon > "$t/o" 2>&1; rc=$?
[ $rc -eq 0 ] && ok "a skipping suite alone does not fail the run" || bad "skip rc" "rc=$rc"
has "exit 77 is shown as SKIPPED" '^SKIPPED  *epsilon' "$t/o"
has "a skipped item is UNCHECKED, never GREEN" 'UNCHECKED epsilon' "$t/o"
has "the verdict counts it as not checked" '1 not checked here' "$t/o"
rm -f "$F/tests/epsilon-tests.sh"
# a C4 tree with no bin/sg1ck: the garden leg is NOT CHECKED and says why (never a quiet PASS)
mkdir -p "$t/c4bare/bin" "$t/c4bare/dist"
$G --root "$F" --c4 "$t/c4bare" garden > "$t/o" 2>&1
has "no sg1ck: the garden is UNCHECKED" 'UNCHECKED garden' "$t/o"
has "...and the reason is named" 'no bin/sg1ck in' "$t/o"

# --record: interesting-only, then heartbeat
M=$t/metrics; export SKILL_METRICS_ROOT=$M
$R --record alpha good > "$t/o" 2>&1; has "record writes new rows" 'recorded to .*: 2 new row' "$t/o"
[ "$(cat "$M/skill-metrics/alpha")" = GREEN ] && ok "item file holds GREEN" || bad "item file" "$(cat "$M/skill-metrics/alpha" 2>&1)"
grep -q '^alpha GREEN archive/alpha/' "$M/log" && ok "tool constituent archived (bin/alpha)" || bad "constituent" "$(cat "$M/log")"
$R --record alpha good > "$t/o" 2>&1; has "second record: nothing new" '0 new row(s), 2 unchanged' "$t/o"
printf 'alpha v2\n' > "$F/bin/alpha"; $R --record alpha > "$t/o" 2>&1; has "changed constituent is interesting" '1 new row' "$t/o"
$R --record --heartbeat alpha > "$t/o" 2>&1; has "heartbeat forces a row" '1 new row' "$t/o"
sh "$here/bin/sk2mt" check > "$t/o" 2>&1 && ok "the store it wrote passes sk2mt check" || bad "store check" "$(cat "$t/o")"
unset SKILL_METRICS_ROOT

# timeout
if command -v timeout >/dev/null 2>&1; then
  printf '#!/bin/sh\nsleep 5\n' > "$F/tests/slow-tests.sh"
  GD1CK_TIMEOUT=1 $R slow > "$t/o" 2>&1; has "a hung suite times out as FAIL" 'timed out after 1s' "$t/o"
fi

# the python leg really runs under the timeout wrapper (a VAR=value prefix once broke it: 2026-09-22)
mkdir -p "$F/polygram"; printf '__version__ = "0.0.1"\n' > "$F/polygram/__init__.py"
printf 'import unittest\nclass T(unittest.TestCase):\n    def test_ok(self): pass\n' > "$F/tests/test_fx.py"
$R polygram > "$t/o" 2>&1; rc=$?
[ $rc -eq 0 ] && ok "python leg runs green on a green fixture" || bad "python leg" "$(grep -a 'polygram' "$t/o" | head -2)"
printf 'import unittest\nclass T(unittest.TestCase):\n    def test_no(self): self.fail("planted")\n' > "$F/tests/test_fx.py"
$R polygram > "$t/o" 2>&1; has "python leg goes RED on a failing test" 'RED       polygram' "$t/o"
rm -rf "$F/polygram" "$F/tests/test_fx.py"

# every self-check a skill carries is a leg, not only tests.sh (2026-09-28): tests-*.sh and
# tests/selftest.sh by sh, tests*.py by python3, 77 is SKIPPED
mkdir -p "$F/skills/extra/tests"
printf -- '---\nname: extra\ndescription: A fine skill with several self-checks.\n---\n\nbody\n' > "$F/skills/extra/SKILL.md"
printf '#!/bin/sh\n[ "${1:-}" = --prove-red ] && { touch "%s/foo-red"; echo prove-red PASS; exit 0; }\ntouch "%s/foo-ran"; echo TOTAL pass=1 fail=0\n' "$t" "$t" > "$F/skills/extra/tests-foo.sh"
printf 'import sys\nopen(%s, "w").close()\nprint("TOTAL pass=1 fail=0 under python", sys.version_info[0])\n' "'$t/bar-ran'" > "$F/skills/extra/tests-bar.py"
printf '#!/bin/sh\ntouch "%s/self-ran"; echo SELFTEST: PASS\n' "$t" > "$F/skills/extra/tests/selftest.sh"
printf '#!/bin/sh\necho "SKIP: no widget here"; exit 77\n' > "$F/skills/extra/tests-skip.sh"
extra_case() { # extra_case GD1CK_COMMAND
  rm -f "$t/foo-ran" "$t/foo-red" "$t/bar-ran" "$t/self-ran"
  $1 --root "$F" --no-c4 --list extra > "$t/o" 2>&1
  has "a skill's tests-foo.sh is a leg" 'skills/extra/tests-foo.sh$' "$t/o"
  has "...with its --prove-red twin when it offers one" 'skills/extra/tests-foo.sh --prove-red$' "$t/o"
  has "a skill's tests-*.py is a leg" 'skills/extra/tests-bar.py$' "$t/o"
  has "a skill's tests/selftest.sh is a leg" 'skills/extra/tests/selftest.sh$' "$t/o"
  hasnt "...and a suite without --prove-red gets no twin" 'tests/selftest.sh --prove-red' "$t/o"
  $1 --root "$F" --no-c4 extra > "$t/o" 2>&1; rc=$?
  if [ $rc -eq 0 ] && [ -f "$t/foo-ran" ] && [ -f "$t/foo-red" ] && [ -f "$t/bar-ran" ] && [ -f "$t/self-ran" ]; then
    ok "each of them runs, the .py under python3"
  else bad "extra legs ran" "rc=$rc foo=$([ -f "$t/foo-ran" ] && echo y) red=$([ -f "$t/foo-red" ] && echo y) py=$([ -f "$t/bar-ran" ] && echo y) self=$([ -f "$t/self-ran" ] && echo y)"; fi
  has "a skill self-check that exits 77 is SKIPPED" '^SKIPPED .*tests-skip.sh' "$t/o"
}
extra_case "$G"

# the kit's own prove-red
$G --prove-red > "$t/o" 2>&1 && ok "gd1ck --prove-red passes" || bad "gd1ck --prove-red" "$(tail -2 "$t/o")"

if [ "${1:-}" = --prove-red ]; then
  [ $fail -eq 0 ] || { echo "FAIL: the real gd1ck is not green; a red here proves nothing"; exit 1; }
  before=$fail; has "PLANTED (must FAIL)" 'this text is not there' "$t/o" >/dev/null
  [ $fail -gt $before ] || { echo "FAIL: harness could not go red"; exit 1; }
  # a mutant kit that finds only tests.sh again (the pre-2026-09-28 discovery) must turn the
  # extra-self-checks case red
  K=$t/mutkit; mkdir -p "$K/bin" "$K/skills/skill-metrics/scripts"
  cp "$here/skills/skill-metrics/scripts/sh1lib.sh" "$K/skills/skill-metrics/scripts/"
  sed 's|for x in "$d"tests-\*.sh "$d"tests\*.py "$d"tests/selftest.sh; do|for x in; do|' "$here/bin/gd1ck" > "$K/bin/gd1ck"
  if cmp -s "$here/bin/gd1ck" "$K/bin/gd1ck"; then echo "FAIL: mutant not planted -- gd1ck changed shape"; exit 1; fi
  before=$fail; extra_case "sh $K/bin/gd1ck" > "$t/mut.log" 2>&1
  if [ $fail -gt $before ]; then
    echo "PASS: harness correctly went red under a planted bad expectation, and CAUGHT the mutant kit that finds only tests.sh -- $(grep '^FAIL' "$t/mut.log" | head -1)"; exit 0
  fi
  echo "FAIL: the mutant kit that finds only tests.sh went unnoticed"; exit 1
fi
echo "TOTAL pass=$pass fail=$fail"; [ $fail -eq 0 ]
