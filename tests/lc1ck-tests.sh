#!/bin/sh
# lc1ck-tests.sh -- runs tests/lc1ck-spec.rb against bin/lc1ck.  | --prove-red
# --prove-red: a copy of lc1ck with its fault counter cut out must make the spec go red.
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
set -u
here=$(cd "$(dirname "$0")/.." && pwd)
command -v ruby >/dev/null 2>&1 || { echo "lc1ck tests: NOT CHECKED (no ruby here; install Ruby to check it)"; exit 77; }
LC1CK="$here/bin/lc1ck" ruby "$here/tests/lc1ck-spec.rb"; rc=$?
if [ "${1:-}" = --prove-red ]; then
  t=$(mktemp -d); trap 'rm -rf "$t"' EXIT
  sed 's/faults++/faults += 0/g' "$here/bin/lc1ck" > "$t/lc1ck"
  if LC1CK="$t/lc1ck" ruby "$here/tests/lc1ck-spec.rb" >"$t/out" 2>&1; then
    echo "FAIL prove-red: the spec passed a lc1ck that never counts a fault"; rc=1
  else echo "ok   prove-red: a lc1ck that never counts a fault turns the spec red ($(grep -c '^FAIL' "$t/out") FAIL rows)"; fi
  sed 's/\[ -s "\$list.b" \] \&\& scan "\$list.b" 1/:/' "$here/bin/lc1ck" > "$t/lc1ck.b"
  if cmp -s "$here/bin/lc1ck" "$t/lc1ck.b"; then echo "FAIL prove-red: the book plant changed nothing"; rc=1
  elif LC1CK="$t/lc1ck.b" ruby "$here/tests/lc1ck-spec.rb" >"$t/out.b" 2>&1; then
    echo "FAIL prove-red: the spec passed a lc1ck that never reads book/"; rc=1
  else echo "ok   prove-red: a lc1ck that never reads book/ turns the spec red ($(grep -c '^FAIL' "$t/out.b") FAIL rows)"; fi
  sed 's/return report ? "OWED " : "FAULT"/return "FAULT"/' "$here/bin/lc1ck" > "$t/lc1ck.c"
  if LC1CK="$t/lc1ck.c" ruby "$here/tests/lc1ck-spec.rb" >"$t/out.c" 2>&1; then
    echo "FAIL prove-red: the spec passed a lc1ck that calls a book line a FAULT"; rc=1
  else echo "ok   prove-red: a lc1ck that calls a book line a FAULT turns the spec red ($(grep -c '^FAIL' "$t/out.c") FAIL rows)"; fi
fi
exit $rc
