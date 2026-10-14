#!/bin/sh
# mcp-tests.sh -- the three MCP servers, started as the desktop starts them.  A thin POSIX wrapper
# around tests/mcp-smoke.pl (the spec, in Perl -- a third language beside the servers' Python and the
# other suites' Python/sh, on purpose).  Item name for gd1ck: mcp.
# tier: smoke
# usage: sh tests/mcp-tests.sh [PLUGIN_DIR] | --prove-red      (run from the AS4CE0001 root)
# Copyright 2026 Corwin Brust <corwin@bru.st> -- GPLv3-or-later.  Authored by Mentat (for Corwin).
#
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
set -u
here=$(cd "$(dirname "$0")/.." && pwd)
command -v perl >/dev/null 2>&1 || { echo "mcp-tests: perl not found; the spec cannot run here"; exit 1; }
if [ "${1:-}" = --prove-red ]; then
  # Two plants, each a failure this spec exists to catch.  Both must turn it red.
  src=${2:-$here/dist/vibrobeast}
  t=$(mktemp -d 2>/dev/null) || { t=${TMPDIR:-/tmp}/mcp-tests.$$; mkdir -p "$t"; }
  trap 'rm -rf "$t"' EXIT INT TERM
  cp -r "$src" "$t/p1"; cp -r "$src" "$t/p2"
  # plant 1: the env block that stopped the real desktop for a week
  perl -0pi -e 's/("mentcached": \{)/$1\n      "env": {"PYTHONPATH": "\${CLAUDE_PLUGIN_ROOT}\/servers"},/' "$t/p1/.mcp.json"
  # plant 2: a launcher the config names but nobody shipped
  perl -0pi -e 's/servers\/launch\.py/servers\/nowhere.py/' "$t/p2/.mcp.json"
  red=0
  perl "$here/tests/mcp-smoke.pl" "$t/p1" > "$t/o1" 2>&1 && { echo "FAIL: planted PYTHONPATH env did not go red"; cat "$t/o1"; exit 1; }
  grep -q 'reserved variable name' "$t/o1" && red=$((red+1)) || { echo "FAIL: env plant went red for the wrong reason"; cat "$t/o1"; exit 1; }
  perl "$here/tests/mcp-smoke.pl" "$t/p2" > "$t/o2" 2>&1 && { echo "FAIL: planted missing launcher did not go red"; cat "$t/o2"; exit 1; }
  red=$((red+1))
  echo "PASS: harness went red under both plants (env PYTHONPATH; missing launcher)  [$red/2]"; exit 0
fi
cd "$here" || exit 2
exec perl tests/mcp-smoke.pl "${1:-dist/vibrobeast}"
