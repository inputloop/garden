#!/bin/sh
# ck1sk-tests -- bin/ck1sk keeps its header's promises (its own self-test, which plants a key blind to edits).
# usage: sh tests/ck1sk-tests.sh [--prove-red]     Copyright (C) 2026 Corwin Brust.  SPDX-License-Identifier: GPL-3.0-or-later.
set -u
here=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd) || exit 2
out=$(sh "$here/bin/ck1sk" --prove-red 2>&1); rc=$?
printf '%s\n' "$out"
[ $rc -eq 0 ] && echo "TOTAL pass=1 fail=0" || echo "TOTAL pass=0 fail=1"
exit $rc
