#!/bin/sh
# release-note-tests.sh -- `make dist RELEASE=X.Y.Z NOTE="why"`: the keeper's note reaches the build's
# own record (releases/X.Y.Z) and, when a seat is reachable, Mentat's seat -- never creating one.
#
# Copyright (C) 2026 Corwin Brust <corwin@bru.st>
# Authored by Mentat (for Corwin).
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of vibrobeast.  vibrobeast is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
# usage: sh tests/release-note-tests.sh [--prove-red]
set -u
here=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd) || exit 2
RL=${RL2BP:-$here/bin/rl2bp}
pass=0; fail=0
ok() { if [ "$2" = 0 ]; then pass=$((pass+1)); echo "ok   $1"; else fail=$((fail+1)); echo "FAIL $1${3:+ -- $3}"; fi; }
t=$(mktemp -d) || exit 2; trap 'rm -rf "$t"' EXIT INT TERM
mkdir -p "$t/w/polygram" "$t/w/bin"; cp "$RL" "$t/w/bin/rl2bp"
printf '__version__ = "0.8.58"\n' > "$t/w/polygram/__init__.py"
note='it'"'"'s "quoted" & fine; the $HOME stays literal'
# the recipe line exactly as make hands it to the shell, NOTE from the environment (export NOTE)
( cd "$t/w" && NOTE=$note sh -c 'sh bin/rl2bp start --to 0.8.90 ${NOTE:+--note "$NOTE"}' ) > "$t/o" 2>&1
grep -qxF "note $note" "$t/w/releases/0.8.90"; ok "R1 the note lands in releases/0.8.90 byte for byte (quotes, & and \$ intact)" $? "$(cat "$t/w/releases/0.8.90" 2>/dev/null)"
( cd "$t/w" && sh bin/rl2bp finish >/dev/null 2>&1 && NOTE= sh -c 'sh bin/rl2bp start ${NOTE:+--note "$NOTE"}' ) > "$t/o" 2>&1
! grep -q '^note' "$t/w/releases/0.8.91"; ok "R2 no NOTE: no note line" $?
# the seat: a scratch seat named by MENTCACHED_SEAT, then none at all
PY=${PYTHON:-python3}
seat="$t/seat"
( cd "$here" && "$PY" -c 'import sys; from polygram.mcp import store; store.Store(root=__import__("pathlib").Path(sys.argv[1]), by="t").ensure(create=True, make_parents=True)' "$seat" ) >/dev/null 2>&1
( cd "$here" && MENTCACHED_SEAT="$seat" "$PY" -m polygram.mcp.seatnote --release-note "$note" --root "$t/w" ) > "$t/o" 2>&1; rc=$?
[ "$rc" = 0 ] && grep -rqF "v0.8.91: $note" "$seat"; ok "R3 a reachable seat gets the note, with its version (exit $rc)" $? "$(cat "$t/o")"
( cd "$here" && MENTCACHED_SEAT="$t/nowhere" "$PY" -m polygram.mcp.seatnote --release-note x --root "$t/w" ) > "$t/o" 2>&1; rc=$?
[ "$rc" = 3 ] && [ ! -e "$t/nowhere" ] && grep -q 'releases/ only' "$t/o"; ok "R4 a seat that is not there: exit 3, said, and not created" $? "rc=$rc $(cat "$t/o")"
# the wiring in the real Makefile (read, not run: a real dist mints)
mk=$here/Makefile
grep -q '^export NOTE' "$mk" && grep -q 'rl2bp start .*--note "\$\$NOTE"' "$mk" && grep -q 'seatnote --release-note "\$\$NOTE"' "$mk"
ok "R5 the Makefile exports NOTE, passes it to rl2bp and offers it to the seat" $?
awk '/rl2bp finish/{f=NR} /seatnote --release-note/{s=NR} END{exit !(f && s && s>f)}' "$mk"
ok "R6 the seat is offered the note only after rl2bp finish (a failed build leaves no note in memory)" $?

if [ "${1:-}" = --prove-red ]; then
  sed 's/^note_to() {.*/note_to() { return 0; }  # MUTANT: the note is dropped/' "$RL" > "$t/rl-mut"
  RL2BP="$t/rl-mut" sh "$0" >/dev/null 2>&1 && { echo "FAIL: a rl2bp that drops the note passed"; exit 1; }
  echo "PASS: a rl2bp that drops the note fails R1"; exit 0
fi
echo "TOTAL pass=$pass fail=$fail"; [ "$fail" = 0 ]
