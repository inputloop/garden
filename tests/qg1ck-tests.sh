#!/bin/sh
# qg1ck-tests.sh [--prove-red] -- runs the Tcl spec tests/qg1ck-spec.tcl on bin/qg1ck; with
# --prove-red, each guard is planted out in a scratch copy and the spec must go red.
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
set -u
T=$(cd "$(dirname "$0")" && pwd -P); G=$(dirname "$T")
# SPEC F1-7 (pass 2, P6 O3/J2): an interpreter that is absent here is NOT CHECKED and exit 77
# (the kit shows LOOK), never exit 0 (the kit would count it green).
command -v tclsh >/dev/null 2>&1 || { echo "qg1ck tests: NOT CHECKED (no tclsh here; install Tcl to check it)"; exit 77; }
W=$(mktemp -d "${TMPDIR:-/tmp}/qg1ck-t.XXXXXX"); trap 'rm -rf "$W"' EXIT INT TERM
if [ "${1:-}" = --prove-red ]; then
  echo "qg1ck prove-red: planting each guard out; the named spec line must go red"
  miss=0
  try() { # name spec-text sed
    sed "$3" "$G/bin/qg1ck" > "$W/qg.$1"
    if cmp -s "$G/bin/qg1ck" "$W/qg.$1"; then echo "  MISS  $1: the plant did not change the file"; miss=$((miss+1)); return; fi
    tclsh "$T/qg1ck-spec.tcl" "$W/qg.$1" > "$W/out.$1" 2>&1
    if grep -q "^  FAIL  $2" "$W/out.$1"; then echo "  RED   $1: $2 went red as planned"
    else echo "  MISS  $1: $2 stayed green"; miss=$((miss+1)); fi
  }
  try bar-off 'QG1 a two-question frame at 0.18' '/#guard:bar/s/c + 0 > bar + 0/c + 0 > bar + 1/'
  try bar-off-by-one 'QG1 a two-question frame at 0.17 passes' '/#guard:bar/s/c + 0 > bar + 0/c + 0 >= bar + 0/'
  try percent-blind 'QG1 a two-question frame at 17% passes' '/#guard:pct/s|if (x ~ /%$/) return substr(x, 1, length(x) - 1) / 100; ||'
  try gloss-blind 'QG2' '/#guard:gloss/s/glossed++; continue/glossed++/'
  try writes-frame 'QG3 the frame is never changed' '/^  }. "\$FRAME"$/a printf "x\\n" >> "$FRAME"'
  echo "qg1ck prove-red: $miss missed"; [ "$miss" -eq 0 ]; exit $?
fi
echo "qg1ck tests (Tcl spec)"
tclsh "$T/qg1ck-spec.tcl" "$G/bin/qg1ck"; n=$?
[ $n -eq 0 ] && echo "qg1ck tests: PASS" || echo "qg1ck tests: FAIL"
exit $n
