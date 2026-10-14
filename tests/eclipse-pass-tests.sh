#!/bin/sh
# Copyright (C) 2026 Corwin Brust <corwin@bru.st>
# Authored by Mentat (for Corwin).
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
# eclipse-pass-tests.sh -- expected behaviours for skills/eclipse-pass/scripts/eclipse_pass.sh.
# usage: sh tests/eclipse-pass-tests.sh | --prove-red      (run from the AS4CE0001 root)
# Written 2026-09-12 after the QA-stresstest matrix's Lane A1 found the increment-dir
# collision guard was check-then-act, not atomic. This harness's whole point is the
# concurrent-race test (see "no-clobber-under-real-concurrency" below) -- a single-process
# check would have missed the original bug entirely.
set -u
here=$(cd "$(dirname "$0")/.." && pwd)
S="$here/skills/eclipse-pass/scripts/eclipse_pass.sh"
t=${TMPDIR:-/tmp}/eclipse-pass-tests.$$; mkdir -p "$t/projects/alpha" "$t/projects/beta" "$t/projects/gamma"
pass=0; fail=0
ok() { pass=$((pass+1)); echo "ok   $1"; }
bad() { fail=$((fail+1)); echo "FAIL $1 -- $2"; }

# 1. dry-run works, writes nothing
sh "$S" --target T1 --from "$t/projects" --pick 2 --seed 5 > "$t/dry.out" 2>"$t/dry.err"
[ $? -eq 0 ] && ok "dry-run-exits-0" || bad "dry-run-exits-0" "$(cat "$t/dry.err")"
[ ! -e "$t/.eclipse-increments" ] && ok "dry-run-writes-nothing" || bad "dry-run-writes-nothing" "increments dir exists after dry run"
grep -q "target: T1" "$t/dry.out" && ok "dry-run-names-target" || bad "dry-run-names-target" "no header line"

# 2. --apply scaffolds pass.md + verdict.md, verified present
( cd "$t" && sh "$S" --target T2 --from "$t/projects" --pick 2 --seed 5 --apply ) > "$t/apply.out" 2>"$t/apply.err"
[ $? -eq 0 ] && ok "apply-exits-0" || bad "apply-exits-0" "$(cat "$t/apply.err")"
incdir=$(find "$t/.eclipse-increments" -maxdepth 1 -type d -name "*-T2*" | head -1)
[ -n "$incdir" ] && [ -f "$incdir/pass.md" ] && [ -f "$incdir/verdict.md" ] && ok "apply-scaffolds-both-files" || bad "apply-scaffolds-both-files" "missing pass.md/verdict.md under $incdir"
grep -q "^## 4. Debugger ON" "$incdir/pass.md" 2>/dev/null && ok "pass-md-has-debugger-on-section" || bad "pass-md-debugger-on" "section missing"
grep -q "^RESULT: PASS | FAIL" "$incdir/verdict.md" 2>/dev/null && ok "verdict-md-has-result-line" || bad "verdict-md-result-line" "line missing"

# 3/4. seed reproducible, seed matters
a=$(sh "$S" --target T3 --from "$t/projects" --pick 2 --seed 9 | md5sum)
b=$(sh "$S" --target T3 --from "$t/projects" --pick 2 --seed 9 | md5sum)
[ "$a" = "$b" ] && ok "seed-reproducible" || bad "seed-reproducible" "differs"
c=$(sh "$S" --target T3 --from "$t/projects" --pick 2 --seed 11 | md5sum)
[ "$a" != "$c" ] && ok "seed-matters" || bad "seed-matters" "same pick for two seeds"

# 5. usage errors
sh "$S" --from "$t/projects" >/dev/null 2>&1; [ $? -eq 2 ] && ok "needs-target" || bad "needs-target" "exit not 2"
sh "$S" --target T4 >/dev/null 2>&1; [ $? -eq 2 ] && ok "needs-from" || bad "needs-from" "exit not 2"

# 5b. a roster TSV gives project keys, never whole rows or its header (2026-09-25)
printf 'key\tname\tstatus\n# a comment\nalpha\tAlpha\tactive\nbeta\tBeta\tidle\n' > "$t/roster.tsv"
sh "$S" --target T5 --from "$t/roster.tsv" --pick 5 --seed 3 > "$t/tsv.out" 2>/dev/null
grep -q 'candidates: 2 ' "$t/tsv.out" && ok "tsv-roster-counts-keys-only" || bad "tsv-roster-counts-keys-only" "$(grep candidates "$t/tsv.out")"
grep -q 'vs  alpha$' "$t/tsv.out" && grep -q 'vs  beta$' "$t/tsv.out" && ok "tsv-roster-yields-bare-keys" || bad "tsv-roster-yields-bare-keys" "$(grep ' vs ' "$t/tsv.out" | tr '\n' '|')"
grep -q 'vs  key' "$t/tsv.out" && bad "tsv-header-not-a-project" "header picked" || ok "tsv-header-not-a-project"
printf 'key\tname\thome\ngamma\tGamma\t/f/claude/projects/gamma\ndelta\tDelta\t-\n' > "$t/roster2.tsv"
sh "$S" --target T6 --from "$t/roster2.tsv" --pick 2 --seed 3 > "$t/tsv2.out" 2>/dev/null
grep -q 'vs  gamma    (home: /f/claude/projects/gamma)$' "$t/tsv2.out" && grep -q 'vs  delta    (home: -)$' "$t/tsv2.out" && ok "tsv-roster-says-home" || bad "tsv-roster-says-home" "$(grep ' vs ' "$t/tsv2.out" | tr '\n' '|')"

# 6. THE regression: no-clobber under REAL concurrency (the actual bug, reproduced and fixed)
raceroot="$t/race"; mkdir -p "$raceroot"
N=20
i=0
while [ "$i" -lt "$N" ]; do
  ( cd "$raceroot" && sh "$S" --target RACE --from "$t/projects" --pick 1 --seed 1 --out "$raceroot" --apply >/dev/null 2>&1 ) &
  i=$((i+1))
done
wait
dircount=$(find "$raceroot/.eclipse-increments" -maxdepth 1 -type d -name "*-RACE*" 2>/dev/null | wc -l | tr -d ' ')
filecount=0
for d in "$raceroot"/.eclipse-increments/*-RACE*; do
  [ -f "$d/pass.md" ] && [ -f "$d/verdict.md" ] && filecount=$((filecount+1))
done
[ "$dircount" -eq "$N" ] && ok "no-clobber-under-real-concurrency-N-dirs" || bad "no-clobber-under-real-concurrency-N-dirs" "expected $N distinct dirs, found $dircount"
[ "$filecount" -eq "$N" ] && ok "no-clobber-under-real-concurrency-all-scaffolded" || bad "no-clobber-under-real-concurrency-all-scaffolded" "expected $N fully-scaffolded dirs, found $filecount"

if [ "${1:-}" = "--prove-red" ]; then
  before=$fail
  [ "$dircount" -eq "$((N+1))" ] && ok "PLANTED" || bad "PLANTED-wrong-expectation" "planted N+1 on purpose"
  rm -rf "$t"
  [ "$fail" -eq $((before+1)) ] && { echo "PASS: harness correctly went red under a planted bad expectation"; exit 0; } || { echo "FAIL: harness did not go red"; exit 1; }
fi

rm -rf "$t"
echo "TOTAL: $pass ok, $fail failed"
[ "$fail" -eq 0 ] && exit 0 || exit 1
