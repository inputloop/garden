#!/bin/sh
# Copyright (C) 2026 Corwin Brust <corwin@bru.st>
# Authored by Mentat (for Corwin).
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
# makefile-c4root-tests.sh -- expected behaviours for the Makefile's C4_ROOT auto-detect.
# usage: sh tests/makefile-c4root-tests.sh | --prove-red      (run from the AS4CE0001 root)
# Written 2026-09-12 after C4_ROOT's hard-coded host-only default (/f/claude/c4) made every
# sandboxed session's first `make garden` fail with "No such file". C4_ROOT now auto-detects:
# prefer the real host path when present, fall back to a mounted sandbox copy otherwise, and let
# either an environment variable or a command-line override still win over both -- this harness
# proves each of those four cases against the live Makefile, not a reimplementation of its logic.
set -u
here=$(cd "$(dirname "$0")/.." && pwd)
MF="$here/Makefile"
pass=0; fail=0
ok() { pass=$((pass+1)); echo "ok   $1"; }
bad() { fail=$((fail+1)); echo "FAIL $1 -- $2"; }
# The C4 root the garden recipe names: `--c4 X` when X/bin/sg1ck exists, else the skip line's
# "bin/sg1ck at X;" (2026-09-27: without sg1ck the target says so and exits 0).
c4of() { sed -n -e 's/.*--c4 \([^ ]*\).*/\1/p' -e 's/.*bin\/sg1ck at \([^;]*\);.*/\1/p'; }

# 1. no override, host path absent (true in any sandbox): falls back to $HOME/mnt/c4
r=$( (cd "$here" && make -n garden 2>/dev/null) | c4of)
[ "$r" = "$HOME/mnt/c4" ] && ok "sandbox-fallback-used" || bad "sandbox-fallback-used" "got '$r', expected '$HOME/mnt/c4'"

# 2. command-line override still wins over the auto-detect
r=$( (cd "$here" && make -n C4_ROOT=/tmp/mk-c4root-test-cli garden 2>/dev/null) | c4of)
[ "$r" = "/tmp/mk-c4root-test-cli" ] && ok "cli-override-wins" || bad "cli-override-wins" "got '$r'"

# 3. environment-variable override also wins (new: was a plain '=', now '?='; a plain '=' ignores env)
r=$( (cd "$here" && C4_ROOT=/tmp/mk-c4root-test-env make -n garden 2>/dev/null) | c4of)
[ "$r" = "/tmp/mk-c4root-test-env" ] && ok "env-override-wins" || bad "env-override-wins" "got '$r'"

# 4. when the real host path IS present, it is preferred automatically over the sandbox fallback --
# proved against a sed-substituted copy of the live Makefile (a writable stand-in path swapped in
# for /f/claude/c4, same surrounding logic untouched), not a reimplementation of the rule.
t=${TMPDIR:-/tmp}/mk-c4root-tests.$$
mkdir -p "$t/fake-host-c4"
sed "s#/f/claude/c4#$t/fake-host-c4#g" "$MF" > "$t/Makefile.fake-host"
r=$( (cd "$here" && make -n -f "$t/Makefile.fake-host" garden 2>/dev/null) | c4of)
[ "$r" = "$t/fake-host-c4" ] && ok "host-path-preferred-when-present" || bad "host-path-preferred-when-present" "got '$r', expected '$t/fake-host-c4'"

# 5. a C4 root with no bin/sg1ck: the garden target says so and exits 0 (a stranger's first run)
o=$( (cd "$here" && make C4_ROOT="$t/no-c4-here" garden 2>&1) ); rc=$?
[ $rc -eq 0 ] && printf '%s\n' "$o" | grep -q "needs C4's bin/sg1ck at $t/no-c4-here; not found -- skipped" \
  && ok "no-sg1ck-says-skipped-and-exits-0" || bad "no-sg1ck-says-skipped-and-exits-0" "rc=$rc $o"

if [ "${1:-}" = "--prove-red" ]; then
  before=$fail
  [ "1" = "2" ] && ok "PLANTED" || bad "PLANTED-wrong-expectation" "planted failure on purpose"
  rm -rf "$t"
  [ "$fail" -eq $((before+1)) ] && { echo "PASS: harness correctly went red under a planted bad expectation"; exit 0; } || { echo "FAIL: harness did not go red"; exit 1; }
fi

rm -rf "$t"
echo "TOTAL: $pass ok, $fail failed"
[ "$fail" -eq 0 ] && exit 0 || exit 1
