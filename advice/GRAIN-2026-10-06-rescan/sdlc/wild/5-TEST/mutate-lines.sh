#!/bin/sh
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2026 the Larder software contributors
#
# mutate-lines.sh FILE...    FILE is relative to 4-BUILD.
# Deletes each code line of FILE in turn, in a copy, runs the suite on the copy, and
# prints one line per mutant: SURVIVED, or KILLED with the checks that went red. The
# survivors are the lines no check depends on. This is a measurement, not a pass/fail.
# Jobs run two at a time.
set -u
ROOT=$(cd "$(dirname "$0")/.." && pwd)
SRC=$ROOT/4-BUILD
HERE=$ROOT/5-TEST

if [ "${1:-}" = --one ]; then
    f=$2 l=$3
    d=$(mktemp -d); trap 'rm -rf "$d"' EXIT
    cp -R "$SRC" "$d/t"; rm -rf "$d/t/out"
    text=$(sed -n "${l}p" "$SRC/$f")
    sed -i "${l}d" "$d/t/$f"
    last=$(timeout 180 dash "$HERE/run-tests.sh" --tree "$d/t" 2>&1 | grep '^# [0-9]* checks')
    case $last in
        '') echo "KILLED   $f:$l: HUNG-OR-CRASHED" ;;
        *"0 failed"*) echo "SURVIVED $f:$l: $text" ;;
        *) echo "KILLED   $f:$l:${last##*failed:}" ;;
    esac
    exit 0
fi

for f in "$@"; do
    total=$(wc -l < "$SRC/$f"); l=1
    while [ "$l" -le "$total" ]; do
        sed -n "${l}p" "$SRC/$f" | grep -Eq '^[[:space:]]*(#.*)?$' || echo "$f $l"
        l=$((l + 1))
    done
done | xargs -P 2 -L 1 sh "$0" --one
