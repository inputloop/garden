#!/bin/sh
# rl2bp-tests -- harness for bin/rl2bp: the tool's own --prove-red, then one check against this tree.
# usage: sh tests/rl2bp-tests.sh [--prove-red]
# Copyright (C) 2026 Corwin Brust <corwin@bru.st>.  Authored by Mentat (for Corwin).
# SPDX-License-Identifier: GPL-3.0-or-later
# This program is free software: you can redistribute it and/or modify it under the terms
# of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or (at your option) any later version.
# This file is part of vibrobeast.  It is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software Foundation, either
# version 3 of the License, or (at your option) any later version.  WITHOUT ANY WARRANTY; <https://www.gnu.org/licenses/>.
set -u
here=$(cd "$(dirname "$0")/.." && pwd); tool=$here/bin/rl2bp; pass=0; fail=0
ok() { pass=$((pass+1)); echo "ok   $1"; }; no() { fail=$((fail+1)); echo "FAIL $1: $2"; }
t=$(mktemp -d) || exit 2; trap 'rm -rf "$t"' EXIT HUP INT TERM
sh "$tool" --prove-red > "$t/o" 2>&1 && ok "rl2bp --prove-red" || no "rl2bp --prove-red" "$(tail -2 "$t/o")"
sh "$tool" show > "$t/o" 2>&1 && grep -q '^version [0-9]*\.[0-9]*\.[0-9]*$' "$t/o" && ok "show reads the tree's version ($(head -1 "$t/o"))" || no "show" "$(cat "$t/o")"
v=$(sed -n 's/^__version__ = "\(.*\)"/\1/p' "$here/polygram/__init__.py"); j=$(sed -n 's/.*"version": "\(.*\)".*/\1/p' "$here/dist/vibrobeast/.claude-plugin/plugin.json" 2>/dev/null)
[ -z "$j" ] || [ "$j" = "$v" ] || [ -f "$here/releases/$v" ] && ok "the minted plugin.json version ($j) is the tree's ($v), or a release file explains the gap" || no "version drift" "tree $v, mint $j, no releases/$v"
sh "$tool" finish --root "$t" > "$t/o" 2>&1; [ $? -eq 2 ] && ok "finish on a tree with no polygram/__init__.py exits 2" || no "no-version" "$(cat "$t/o")"
if [ "${1:-}" = --prove-red ]; then mkdir -p "$t/polygram"; printf '__version__ = "1.2.3"\n' > "$t/polygram/__init__.py"; sh "$tool" finish --root "$t" >/dev/null 2>&1 && { echo "FAIL: harness did not go red (finish with no start passed)"; exit 1; }; echo "PASS: harness goes red under a planted fault (finish with no start)"; exit 0; fi
echo "TOTAL pass=$pass fail=$fail"; [ $fail -eq 0 ]
