#!/bin/sh
# release-gate-tests.sh -- runs tests/release-gate-spec.tcl against bin/release.  | --prove-red
# --prove-red: three broken copies of bin/release must each turn the spec red: the NEWS gate that
# always passes, the tag scan that never finds, and the gauge that never counts.
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
set -u
here=$(cd "$(dirname "$0")/.." && pwd)
command -v tclsh >/dev/null 2>&1 || { echo "SKIP: no tclsh (NOT CHECKED; Ruby is the named fall-back, not written yet)"; exit 77; }
RELEASE="$here/bin/release" LC1CK="$here/bin/lc1ck" tclsh "$here/tests/release-gate-spec.tcl"; rc=$?
if [ "${1:-}" = --prove-red ]; then
  t=$(mktemp -d); trap 'rm -rf "$t"' EXIT
  red() { # red LABEL SED-EXPR
    sed "$2" "$here/bin/release" > "$t/release"
    if cmp -s "$t/release" "$here/bin/release"; then echo "FAIL prove-red $1: the plant did not take"; rc=1; return; fi
    if RELEASE="$t/release" LC1CK="$here/bin/lc1ck" tclsh "$here/tests/release-gate-spec.tcl" >"$t/out" 2>&1; then
      echo "FAIL prove-red $1: the spec passed"; rc=1
    else echo "ok   prove-red $1: the spec goes red ($(grep -c '^FAIL' "$t/out") FAIL rows)"; fi
  }
  red "NEWS gate always passes" 's/^  if grep -Eq "^Version /  if true || grep -Eq "^Version /'
  red "tag scan never finds"    's/print+f "%s:%d\\n", FILENAME, FNR }/}/; s/printf "%s:%d\\n", FILENAME, FNR }/}/'
  red "gauge never counts"      's/&& newer="$newer $r"/\&\& :/'
fi
exit $rc
