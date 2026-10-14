#!/bin/sh
# makefile-bytecode-tests.sh -- no recipe of the Makefile leaves __pycache__ behind (QA1 row 16).
# usage: sh tests/makefile-bytecode-tests.sh [--prove-red]        (from anywhere)
# Exit 0 green, 1 red, 2 kit broken.  POSIX sh + make, testing a Makefile.
# Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
# Written by Mentat (for Corwin; claude-opus-5-5), 2026-10-08.
#
# What it checks, in words (the spec):
#  B1  The Makefile exports PYTHONDONTWRITEBYTECODE = 1 (one line, at top level).
#  B2  Behaviour, not text: a recipe run by make with this Makefile sees PYTHONDONTWRITEBYTECODE=1
#      in its environment, even when the caller's environment does not have it.
#  B3  The dist recipe's python lines are $(PYTHON) lines (so B2 covers them): `-m polygram dist`
#      and `-m polygram.mcp.seatnote` both appear in it, and no recipe line starts a bare python3.
#  R   --prove-red: a Makefile copy without the export turns B1 and B2 red.
# Why: the torn 1.0.4 build's own `$(PYTHON) -m polygram dist` wrote polygram/__pycache__ at
# 08:05:18 (one minute after rl2bp start), and the QA plan's WARN fired on it.
set -u
here=$(cd "$(dirname "$0")/.." && pwd) || exit 2
MF=$here/Makefile
[ -f "$MF" ] || { echo "KIT BROKEN: no $MF"; exit 2; }
command -v make >/dev/null 2>&1 || { echo "KIT BROKEN: no make here"; exit 2; }
T=$(mktemp -d 2>/dev/null) || exit 2
trap 'rm -rf "$T"' EXIT INT TERM
printf 'vb-bytecode-probe:\n\t@echo "probe=$$PYTHONDONTWRITEBYTECODE"\n' > "$T/probe.mk"

# checks MAKEFILE -> one "FAIL Bn ..." line per broken rule
checks() {
  mf=$1
  grep -q '^export PYTHONDONTWRITEBYTECODE *= *1 *$' "$mf" || echo "FAIL B1 no top-level 'export PYTHONDONTWRITEBYTECODE = 1'"
  got=$(cd "$here" && env -u PYTHONDONTWRITEBYTECODE make -s -f "$mf" -f "$T/probe.mk" vb-bytecode-probe 2>&1 | grep '^probe=')
  [ "$got" = "probe=1" ] || echo "FAIL B2 a recipe sees [$got], not probe=1"
  d=$(awk '/^dist:/ {d=1; next} d && /^[^\t#]/ {d=0} d' "$mf")
  printf '%s\n' "$d" | grep -q '$(PYTHON) -m polygram dist ' || echo "FAIL B3 the dist recipe does not mint with \$(PYTHON) -m polygram dist"
  printf '%s\n' "$d" | grep -q '$(PYTHON) -m polygram.mcp.seatnote' || echo "FAIL B3 the dist recipe's seatnote is not a \$(PYTHON) line"
  grep -nE '^	[@ -]*python3? ' "$mf" | sed 's/^/FAIL B3 a recipe starts a bare python: /'
}

if [ "${1:-}" = --prove-red ]; then
  grep -v '^export PYTHONDONTWRITEBYTECODE' "$MF" > "$T/Makefile.plant"
  cmp -s "$T/Makefile.plant" "$MF" && { echo "KIT BROKEN: the plant changed nothing"; exit 2; }
  out=$(checks "$T/Makefile.plant")
  if printf '%s\n' "$out" | grep -q '^FAIL B1' && printf '%s\n' "$out" | grep -q '^FAIL B2'; then
    echo "PASS: --prove-red, the export removed turns B1 and B2 red"; exit 0; fi
  echo "FAIL: --prove-red, the plant stayed green: $out"; exit 1
fi
out=$(checks "$MF")
[ -z "$out" ] && { echo "PASS B1-B3 make exports PYTHONDONTWRITEBYTECODE=1 to every recipe, dist's python lines included"; echo "makefile-bytecode-tests: GREEN"; exit 0; }
printf '%s\n' "$out"; echo "makefile-bytecode-tests: RED"; exit 1
