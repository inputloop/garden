#!/bin/sh
# notice-version-tests.sh -- a vendored soft skill's NOTICE names the version its SKILL.md carries.
# SPEC (2026-10-10, lane C task C5): "The gauntlet NOTICE names the version its SKILL.md carries."
# The version a NOTICE names is the first "version N.N" in its first five lines; the SKILL.md's is
# the first "vN.N (" line under "## Version note".  Read with awk; the files are Bryant's or ours,
# never edited here.  --prove-red plants "version 1.4" in a scratch copy and must go red.
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
set -u
here=$(cd "$(dirname "$0")/.." && pwd)
pass=0; fail=0
ok()  { pass=$((pass+1)); echo "ok   $1"; }
bad() { fail=$((fail+1)); echo "FAIL $1 -- $2"; }
nv() { awk 'NR<=5 && match($0, /version [0-9]+\.[0-9]+/) { print substr($0, RSTART+8, RLENGTH-8); exit }' "$1"; }
sv() { awk '/^## Version note/ {f=1; next} f && match($0, /^v[0-9]+\.[0-9]+ \(/) { print substr($0, 2, RLENGTH-3); exit }' "$1"; }
check() { # check NOTICE SKILL LABEL -> 0 when they agree
  a=$(nv "$1"); b=$(sv "$2")
  [ -n "$a" ] && [ -n "$b" ] && [ "$a" = "$b" ]; }
n=0
for d in "$here"/SOFT-SKILLS/*/; do
  [ -f "$d/NOTICE.md" ] && [ -f "$d/SKILL.md" ] || continue
  [ -n "$(nv "$d/NOTICE.md")" ] || continue
  n=$((n+1)); nm=${d%/}; nm=${nm##*/}
  if check "$d/NOTICE.md" "$d/SKILL.md"; then ok "$nm: NOTICE says version $(nv "$d/NOTICE.md"), SKILL.md says v$(sv "$d/SKILL.md")"
  else bad "$nm" "NOTICE says version '$(nv "$d/NOTICE.md")', SKILL.md's newest version note says 'v$(sv "$d/SKILL.md")'"; fi
done
[ "$n" -gt 0 ] && ok "rows checked: $n NOTICE file(s) that name a version" || bad rows "no NOTICE names a version: NOT CHECKED"
if [ "${1:-}" = --prove-red ]; then
  t=$(mktemp -d); trap 'rm -rf "$t"' EXIT
  sed '3s/version 1\.[0-9]*/version 1.4/' "$here/SOFT-SKILLS/gauntlet/NOTICE.md" > "$t/NOTICE.md"
  if check "$t/NOTICE.md" "$here/SOFT-SKILLS/gauntlet/SKILL.md"; then bad prove-red "a planted 'version 1.4' passed"
  else ok "prove-red: a planted 'version 1.4' in a scratch NOTICE goes red"; fi
fi
echo "TOTAL pass=$pass fail=$fail"
[ "$fail" -eq 0 ]
