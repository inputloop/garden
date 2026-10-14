#!/bin/sh
# boundary-secrets-tests.sh -- runs tests/test_boundary_secrets.rb (the secrets check at this repo's
# outbound boundaries, specified in Ruby) so the kit (bin/gd1ck) and a plain `sh tests/*-tests.sh`
# loop both reach it.  Item name for gd1ck: boundary-secrets.
# usage: sh tests/boundary-secrets-tests.sh [--prove-red]      (run from anywhere)
# Exit: whatever the Ruby spec exits; 77 (SKIPPED -- not green, not red) when ruby >= 3 is absent
# here, or when the spec finds no C4 tree (C4_ROOT, /f/claude/c4 or ~/mnt/c4) to check against.
# Copyright 2026 Corwin Brust <corwin@bru.st> -- GPLv3-or-later.  Authored by Mentat (for Corwin).
#
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
set -u
here=$(cd "$(dirname "$0")/.." && pwd) || exit 2
command -v ruby >/dev/null 2>&1 || { echo "SKIP: ruby not found (the boundary-secrets spec needs ruby >= 3)"; exit 77; }
ruby -e 'exit(RUBY_VERSION.split(".")[0].to_i >= 3 ? 0 : 1)' 2>/dev/null || {
  echo "SKIP: $(ruby -v 2>/dev/null | cut -c1-40) is older than 3 (the spec uses endless methods)"; exit 77; }
exec ruby "$here/tests/test_boundary_secrets.rb" "$@"
