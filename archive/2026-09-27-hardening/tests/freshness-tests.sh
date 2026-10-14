#!/bin/sh
# freshness-tests.sh -- the plugin_freshness command from the shell, on the REAL shelf.
# tier: smoke
# usage: sh tests/freshness-tests.sh | --prove-red      (run from the AS4CE0001 root)
# If VIBROBEAST_INSTALLED names the installed plugin tree on this host, the real comparison is
# printed too (informational: BEHIND is not a failure here; a wrong answer would be).
# Copyright 2026 Corwin Brust <corwin@bru.st> -- GPLv3-or-later. Authored by Mentat (for Corwin).
#
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
set -u
here=$(cd "$(dirname "$0")/.." && pwd); cd "$here" || exit 2
F() { PYTHONDONTWRITEBYTECODE=1 python3 -m polygram.mcp.freshness "$@"; }
t=$(mktemp -d 2>/dev/null) || { t=${TMPDIR:-/tmp}/freshness-tests.$$; mkdir -p "$t"; }
trap 'rm -rf "$t"' EXIT INT TERM
pass=0; fail=0
ok()  { pass=$((pass+1)); echo "ok   $1"; }
bad() { fail=$((fail+1)); echo "FAIL $1 -- $2"; }
has() { if grep -q -e "$2" "$3"; then ok "$1"; else bad "$1" "no /$2/ in: $(head -2 "$3" | tr '\n' '|')"; fi; }

[ -f dist/vibrobeast/MANIFEST ] || { echo "no dist/vibrobeast/MANIFEST here; nothing to compare"; exit 1; }
F --shelf dist/vibrobeast --installed dist/vibrobeast > "$t/o" 2>&1; rc=$?
[ $rc -eq 0 ] && ok "shelf vs itself: exit 0" || bad "self rc" "$rc"
has "shelf vs itself: CURRENT in words" 'identical manifests' "$t/o"
# a copy with one skill line altered must read BEHIND, name the skill, and not demand a reinstall
cp -r dist/vibrobeast "$t/old"
awk 'BEGIN{d=0} /  \.\/skills\/posix\/SKILL\.md$/ && !d { sub(/^[0-9a-f]{64}/, "0000000000000000000000000000000000000000000000000000000000000000"); d=1 } {print}' dist/vibrobeast/MANIFEST > "$t/old/MANIFEST"
F --shelf dist/vibrobeast --installed "$t/old" > "$t/o" 2>&1; rc=$?
[ $rc -eq 1 ] && ok "one skill differs: exit 1 (BEHIND)" || bad "behind rc" "$rc: $(cat "$t/o")"
has "it names the skill" 'posix changed' "$t/o"
has "it says a reinstall buys only that text" 'only if you want that skill text live' "$t/o"
has "it lists the file" 'changed *skills/posix/SKILL.md' "$t/o"
# a server line altered must say reinstall YES
cp -r dist/vibrobeast "$t/srv"
awk 'BEGIN{d=0} /  \.\/servers\/polygram\/mcp\/rpc\.py$/ && !d { sub(/^[0-9a-f]{64}/, "1111111111111111111111111111111111111111111111111111111111111111"); d=1 } {print}' dist/vibrobeast/MANIFEST > "$t/srv/MANIFEST"
F --shelf dist/vibrobeast --installed "$t/srv" > "$t/o" 2>&1
has "a server difference says reinstall YES" 'Reinstall: yes: 1 server file' "$t/o"
F --shelf "$t" --installed dist/vibrobeast > "$t/o" 2>&1; [ $? -eq 2 ] && ok "a non-plugin shelf: exit 2 (UNKNOWN)" || bad "unknown rc" "$?"
# no --shelf: the freshness.shelf preference must be read by the command itself (2026-09-24)
printf 'ts\tkey\tvalue\tby\twhy\n2026-09-24T00:00:00Z\tfreshness.shelf\t%s\ttest\t\n' "$here/dist/vibrobeast" > "$t/prefs.tsv"
MENTCACHED_PREFS="$t/prefs.tsv" POLYGRAM_DIST= F --installed dist/vibrobeast > "$t/o" 2>&1
has "no --shelf: the freshness.shelf pref is read" 'identical manifests' "$t/o"
if [ -n "${VIBROBEAST_INSTALLED:-}" ]; then
  echo "-- real comparison (VIBROBEAST_INSTALLED=$VIBROBEAST_INSTALLED):"; F --shelf dist/vibrobeast --installed "$VIBROBEAST_INSTALLED" | sed 's/^/   /'
fi

if [ "${1:-}" = --prove-red ]; then
  before=$fail; has "PLANTED (must FAIL)" 'this text is not there' "$t/o" >/dev/null
  if [ $fail -gt $before ]; then echo "PASS: harness correctly went red under a planted bad expectation"; exit 0; fi
  echo "FAIL: harness could not go red"; exit 1
fi
echo "TOTAL pass=$pass fail=$fail"; [ $fail -eq 0 ]
