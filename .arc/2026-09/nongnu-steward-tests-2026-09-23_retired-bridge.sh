#!/bin/sh
# nongnu-steward-tests.sh -- the garden kit's bridge to the soft skill SOFT-SKILLS/nongnu-steward:
# gd1ck discovers tests/*-tests.sh, not SOFT-SKILLS/*/, so this leg runs the skill's own suite (sh)
# and its black-box spec (perl), each with --prove-red, from the seat root.
# tier: smoke
# usage: sh tests/nongnu-steward-tests.sh | --prove-red      (run from the AS4CE0001 root)
# Copyright 2026 Corwin Brust <corwin@bru.st> -- GPLv3-or-later. Authored by Mentat (for Corwin).
#
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
set -u
here=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd) || exit 2
SK=$here/SOFT-SKILLS/nongnu-steward
[ -f "$SK/tests.sh" ] || { echo "FAIL: no $SK/tests.sh (soft skill absent)"; exit 1; }
if [ "${1:-}" = --prove-red ]; then
  sh "$SK/tests.sh" --prove-red || exit 1
  perl "$SK/tests/spec.pl" --prove-red || exit 1
  echo "PASS: both suites of nongnu-steward go red on a planted failure"; exit 0
fi
fail=0
sh "$SK/tests.sh" || fail=$((fail+1))
perl "$SK/tests/spec.pl" | tail -2 || fail=$((fail+1))
sh "$here/skills/skill-sign/scripts/skill-lint.sh" "$SK" || fail=$((fail+1))
echo "nongnu-steward-tests: suites failed=$fail"; [ $fail -eq 0 ]
