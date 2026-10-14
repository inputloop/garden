#!/bin/sh
# br1in-modes-tests.sh -- runs tests/br1in-modes-spec.rb (SPEC BM1-BM4) against bin/br1in.  | --prove-red
# --prove-red: four scratch copies of br1in, each with one of the four fixes planted back out (the
# apostrophe-pairing quote pattern, "the run" inside "the runner", the title read as a heading, and
# the sentence cut at the first dot), must each turn the spec red.
# No ruby, zip or sha256sum here: NOT CHECKED, exit 77, never a pass.
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
set -u
here=$(cd "$(dirname "$0")/.." && pwd)
command -v ruby >/dev/null 2>&1 || { echo "br1in modes tests: NOT CHECKED (no ruby here; install Ruby to check them)"; exit 77; }
for c in zip sha256sum; do
  command -v $c >/dev/null 2>&1 || { echo "br1in modes tests: NOT CHECKED (no $c here; install it to check them)"; exit 77; }
done
spec="$here/tests/br1in-modes-spec.rb"
ruby "$spec" "$here/bin/br1in"; rc=$?
if [ "${1:-}" = --prove-red ]; then
  t=$(mktemp -d); trap 'rm -rf "$t"' EXIT
  plant() { # name sed-expression
    sed "$2" "$here/bin/br1in" > "$t/$1"
    if cmp -s "$here/bin/br1in" "$t/$1"; then echo "FAIL prove-red $1: the plant changed nothing"; rc=1; return; fi
    if ruby "$spec" "$t/$1" > "$t/$1.out" 2>&1; then echo "FAIL prove-red $1: the spec passed with the fix planted out"; rc=1
    else echo "ok   prove-red $1: planted out, the spec goes red ($(grep -c '^FAIL' "$t/$1.out") FAIL rows)"; fi
  }
  plant quote 's/match(s, \/(^|\[^A-Za-z0-9\])(\\047/match(s, \/((\\047/'
  plant therun 's/(^|\[^a-z\])the run(\[^a-z\]|\$)/the run/'
  plant title 's/\/\^#{2,6}\[ \\t\]\//\/^#{1,6}[ \\t]\//'
  plant dot 's/Triggers:)(\[^.\]|\\\.\[^ \])\*\//Triggers:)[^.]*\//'
fi
exit $rc
