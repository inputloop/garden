#!/bin/sh
# sb-vendored-tests.sh -- the secrets checkers vendored in bin/ (sb1aw, sb1pl, sb1rn) stay equal to
# C4's, and work on their own in a garden that has no C4 tree.
#
# Copyright (C) 2026 Corwin Brust <corwin@bru.st>
# Authored by Mentat (for Corwin).
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of vibrobeast.  vibrobeast is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
#
#   V1  each bin/sb1* is byte-identical to C4's copy (said as not checked when no C4 is found)
#   V2  the vendored sb1rn reads a clean file as clean, exit 0
#   V3  it finds a planted token (built here, never written whole in this file), exit 1, by kind,
#       and never prints the value
#   V4  an unreadable file is not called clean (exit 2); not checked when running as root
# usage: sh tests/sb-vendored-tests.sh [--prove-red]
set -u
here=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd) || exit 2
BIN=${SB_VENDORED_BIN:-$here/bin}
C4=
for d in "${C4_ROOT:-}" /f/claude/c4 "$HOME/mnt/c4"; do [ -n "$d" ] && [ -f "$d/bin/sb1rn" ] && { C4=$d; break; }; done
pass=0; fail=0
ok() { if [ "$2" = 0 ]; then pass=$((pass+1)); echo "ok   $1"; else fail=$((fail+1)); echo "FAIL $1${3:+ -- $3}"; fi; }
t=$(mktemp -d) || exit 2; trap 'chmod -R u+rwx "$t" 2>/dev/null; rm -rf "$t"' EXIT INT TERM

if [ -n "$C4" ]; then
  for f in sb1aw sb1pl sb1rn; do cmp -s "$BIN/$f" "$C4/bin/$f"; ok "V1 bin/$f equals C4's ($C4/bin/$f)" $?; done
else
  echo "note V1 not checked: no C4 tree here (set C4_ROOT to compare)"
fi
printf 'nothing to see\n' > "$t/clean.txt"
out=$(SB_PICK=both sh "$BIN/sb1rn" "$t/clean.txt" 2>/dev/null); rc=$?
[ "$rc" = 0 ] && printf '%s\n' "$out" | grep -q '^sb: clean; read 1'; ok "V2 a clean file reads clean (exit $rc)" $?
v=$(printf 'aB3dE5fG7hJ9kL1mN3pQ5rS7tU9vW1xY3zA5bC' | cut -c1-36)
printf 'line one\nkey %s\n' "gh""p_$v" > "$t/tok.txt"
out=$(SB_PICK=both sh "$BIN/sb1rn" "$t/tok.txt" 2>&1); rc=$?
[ "$rc" = 1 ] && printf '%s\n' "$out" | grep -q "tok.txt:2 github-token"; ok "V3 a planted token is found by kind (exit $rc)" $?
printf '%s\n' "$out" | grep -q "$v"; [ $? = 1 ]; ok "V3 ...and its value is never printed" $?
if [ "$(id -u)" = 0 ]; then
  echo "note V4 not checked: running as root reads every file"
else
  printf 'x\n' > "$t/locked.txt"; chmod 000 "$t/locked.txt"
  out=$(SB_PICK=both sh "$BIN/sb1rn" "$t/locked.txt" 2>&1); rc=$?
  [ "$rc" = 2 ]; ok "V4 an unreadable file is not called clean (exit $rc)" $?
  chmod 600 "$t/locked.txt"
fi

if [ "${1:-}" = --prove-red ]; then
  bad=0
  m=$t/m1; mkdir -p "$m"; cp "$BIN"/sb1aw "$BIN"/sb1pl "$BIN"/sb1rn "$m/"
  printf '# drift\n' >> "$m/sb1pl"
  if [ -n "$C4" ]; then
    SB_VENDORED_BIN=$m sh "$0" >/dev/null 2>&1 && { echo "FAIL prove-red: a drifted sb1pl passed V1"; bad=1; } || echo "PASS prove-red: a drifted sb1pl fails V1"
  else
    echo "note prove-red V1 leg not run: no C4 tree"
  fi
  m=$t/m2; mkdir -p "$m"; cp "$BIN"/sb1aw "$BIN"/sb1pl "$BIN"/sb1rn "$m/"
  printf '#!/bin/sh\necho "sb: clean; read 1, binary skipped 0, allowed 0"; exit 0\n' > "$m/sb1aw"; cp "$m/sb1aw" "$m/sb1pl"
  SB_VENDORED_BIN=$m C4_ROOT=/nonexistent HOME=/nonexistent sh "$0" >/dev/null 2>&1 && { echo "FAIL prove-red: checkers that always say clean passed"; bad=1; } || echo "PASS prove-red: checkers that always say clean fail V3"
  exit $bad
fi
echo "TOTAL pass=$pass fail=$fail"; [ "$fail" = 0 ]
