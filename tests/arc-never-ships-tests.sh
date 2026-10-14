#!/bin/sh
# arc-never-ships-tests -- gd1ck leg for tests/arc-never-ships.pl (a third-language spec: the mint
# and the express manifest agree that a skill's .arc/, .git/ and __pycache__/ are not the skill).
# usage: sh tests/arc-never-ships-tests.sh [--prove-red]
# Copyright (C) 2026 Corwin Brust <corwin@bru.st>.  Authored by Mentat (for Corwin).
# SPDX-License-Identifier: GPL-3.0-or-later -- free software, WITHOUT ANY WARRANTY.
# This program is free software: you can redistribute it and/or modify it under the terms
# of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or (at your option) any later version.
set -u
here=$(cd "$(dirname "$0")/.." && pwd)
command -v perl >/dev/null 2>&1 || { echo "arc-never-ships tests: NOT CHECKED (no perl here; the spec is core Perl)"; exit 77; }  # F1-7
exec perl "$here/tests/arc-never-ships.pl" "$@"
