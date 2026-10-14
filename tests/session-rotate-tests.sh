#!/bin/sh
# session-rotate-tests.sh -- the rotation's version bump, on the header shapes it meets. | --prove-red
# Copyright (C) 2026 Corwin Brust <corwin@bru.st>. Authored by Mentat (for Corwin).
# This program is free software: you can redistribute it and/or modify it under the terms of the
# GNU General Public License as published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.  SPDX-License-Identifier: GPL-3.0-or-later
set -u
here=$(cd "$(dirname "$0")/.." && pwd)
t=$(mktemp -d 2>/dev/null) || { t=${TMPDIR:-/tmp}/srot.$$; mkdir -p "$t"; }
trap 'rm -rf "$t"' EXIT INT TERM
pass=0; fail=0
ok()  { pass=$((pass+1)); echo "ok   $1"; }
bad() { fail=$((fail+1)); echo "FAIL $1 -- $2"; }
R="sh $here/skills/session-rotate/scripts/rotate_session.sh"
today=$(date +%Y-%m-%d)
mk() { rm -rf "$t/p"; mkdir -p "$t/p"; printf '%s\n' "$@" > "$t/p/model.md"; }
# the shape AS4CE0001 carries: a comment line that says "Version" first, the real line later
mk '# model.md' '<!-- Rotation: on change, bump the Version line -->' '' 'Version: v13 · 2026-08-17 (prior v12 rotated to .models/model-2026-08-17.md)' 'body mentions v13 and v130'
$R --project "$t/p" --apply >/dev/null 2>&1
l=$(sed -n 4p "$t/p/model.md")
[ "$l" = "Version: v14 · $today (prior v13 rotated to .models/model-$today.md)" ] && ok "the real version line bumps, and 'prior vN' follows it" || bad prior "$l"
sed -n 2p "$t/p/model.md" | grep -q 'bump the Version line -->' && ok "a comment that only says 'Version' is left alone" || bad comment "$(sed -n 2p "$t/p/model.md")"
[ "$(sed -n 5p "$t/p/model.md")" = 'body mentions v13 and v130' ] && ok "the body is never touched" || bad body "$(sed -n 5p "$t/p/model.md")"
[ -f "$t/p/.models/model-$today.md" ] && ok "the snapshot the header names exists" || bad snap "$(ls -a "$t/p/.models")"
mk '# m' 'version: v1 (see v13 notes)'
$R --project "$t/p" --apply >/dev/null 2>&1
[ "$(sed -n 2p "$t/p/model.md")" = 'version: v2 (see v13 notes)' ] && ok "v1 is bumped as a whole token; v13 beside it is not" || bad token "$(sed -n 2p "$t/p/model.md")"
mk '# m' '<!-- rotate: v3 (2026-06-27) -->'
$R --project "$t/p" --apply >/dev/null 2>&1
[ "$(sed -n 2p "$t/p/model.md")" = "<!-- rotate: v4 ($today) -->" ] && ok "the rotate: comment form bumps, date refreshed" || bad rotatecomment "$(sed -n 2p "$t/p/model.md")"
mk '# m' 'Version: v5 · 2026-01-01 (prior v4 rotated to .models/model-2026-01-01.md)'
mkdir -p "$t/p/.models"; : > "$t/p/.models/model-$today.md"
$R --project "$t/p" --apply >/dev/null 2>&1
snap=$(sed -n 2p "$t/p/model.md" | sed -n 's#.*\.models/\([^ )]*\)).*#\1#p')
[ -f "$t/p/.models/$snap" ] && [ "$snap" != "model-$today.md" ] && ok "when today's snapshot exists, the header names the one actually written ($snap)" || bad snapname "$snap"
# three rolls in a row: each header reads right, each snapshot is its own file
mk '# m' 'Version: v7 · 2026-01-01 (prior v6 rotated to .models/model-2026-01-01.md)'
printf 'p0\n' > "$t/p/.last-prompt.md"; printf 'r0\n' > "$t/p/last-response.md"
for n in 1 2 3; do $R --project "$t/p" --apply >/dev/null 2>&1 || bad "roll $n" "exit $?"; done
l=$(sed -n 2p "$t/p/model.md"); s=$(printf '%s' "$l" | sed -n 's#.*\.models/\([^ )]*\)).*#\1#p')
[ "$(printf '%s' "$l" | cut -d' ' -f1-2)" = "Version: v10" ] && printf '%s' "$l" | grep -q 'prior v9 rotated' && [ -f "$t/p/.models/$s" ] && ok "three rolls in a row: v7 -> v10, prior v9, the named snapshot exists" || bad threerolls "$l"
[ "$(ls "$t/p/.models" | wc -l | tr -d ' ')" = 3 ] && ok "...and three distinct snapshots, none clobbered" || bad snaps "$(ls "$t/p/.models")"
grep -rq "^p0$" "$t/p/.sessions" && ok "...and the first continuity files survive in .sessions/" || bad cont "$(ls -R "$t/p/.sessions")"
# --no-bump: a model that declares no session-close step (c4's header has no vN at all)
mk '# C4 -- model.md' '<!-- model: 0.8.2 (2026-09-23) -->'
printf 'p\n' > "$t/p/.last-prompt.md"
o=$($R --project "$t/p" --apply 2>&1); [ $? -eq 3 ] && echo "$o" | grep -q PARK && ok "no vN and no --no-bump: parks (exit 3), writes nothing" || bad park "$o"
o=$($R --project "$t/p" --no-bump --apply 2>&1); rc=$?
[ $rc -eq 0 ] && [ "$(sed -n 2p "$t/p/model.md")" = '<!-- model: 0.8.2 (2026-09-23) -->' ] && [ -f "$t/p/.models/model-$today.md" ] && [ -f "$t/p/.sessions/$today/.last-prompt.md" ] && echo "$o" | grep -q 'version untouched' && ok "--no-bump: snapshot and continuity rotate, the version line is untouched" || bad nobump "rc=$rc $o"
if [ "${1:-}" = --prove-red ]; then
  before=$fail; grep -q 'prior v12' "$t/p/model.md" && ok PLANTED || bad "PLANTED (must FAIL)" x >/dev/null
  [ $fail -gt $before ] && { echo "PASS: harness correctly went red under a planted bad expectation"; exit 0; }
  echo "FAIL: harness could not go red"; exit 1
fi
echo "TOTAL pass=$pass fail=$fail"; [ $fail -eq 0 ]
