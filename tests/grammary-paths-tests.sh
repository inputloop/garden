#!/bin/sh
# grammary-paths-tests.sh -- runs tests/grammary-paths-spec.awk: GRAMMARY.md routes a reader of the
# mint only to places the mint holds, or says the place is in the author's tree.  | --prove-red
# Rows: a fixture (clean, an unmarked plant, a false marker), then the live GRAMMARY.md against the
# live mint (dist/vibrobeast; NOT CHECKED, exit 77, when there is no mint here).
# --prove-red: the live GRAMMARY with one marker cut, and with the header sentence cut, must go red.
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
set -u
here=$(cd "$(dirname "$0")/.." && pwd)
spec="$here/tests/grammary-paths-spec.awk"
t=$(mktemp -d); trap 'rm -rf "$t"' EXIT
pass=0; fail=0
ok()  { pass=$((pass+1)); echo "ok   $1"; }
bad() { fail=$((fail+1)); echo "FAIL $1 -- $2"; }
M="†"   # the marker since turn 2 (2026-10-10); it was "(in the author's tree, not shipped)"
printf 'skills\nskills/seatkeeper\nskills/seatkeeper/SKILL.md\nGRAMMARY.md\n' > "$t/mint"
{ printf '# G\n\nA path marked %s is in the source tree, not this plugin.\n\n### seat\n' "$M"
  printf -- '- **Where:** `skills/seatkeeper/SKILL.md`; `bin/qg1ck`, `polygram/mcp/spans.py` %s.\n' "$M"; } > "$t/G.md"
awk -f "$spec" "$t/mint" "$t/G.md" > "$t/o" 2>&1 && ok "fixture: a shipped path unmarked, two unshipped paths marked once after the run" || bad clean "$(cat "$t/o")"
printf -- '- also `conventions/ROADS.md`.\n' >> "$t/G.md"
awk -f "$spec" "$t/mint" "$t/G.md" > "$t/o" 2>&1; [ $? -eq 1 ] && grep -q 'P1 .*conventions/ROADS.md' "$t/o" && ok "planted: an unshipped path with no marker is a FAIL, by line" || bad plant-p1 "$(cat "$t/o")"
sed -i '$d' "$t/G.md"; printf -- '- `skills/seatkeeper/SKILL.md` %s\n' "$M" >> "$t/G.md"
awk -f "$spec" "$t/mint" "$t/G.md" > "$t/o" 2>&1; [ $? -eq 1 ] && grep -q 'P2 ' "$t/o" && ok "planted: the marker after a path the mint holds is a FAIL" || bad plant-p2 "$(cat "$t/o")"
live() { awk -f "$spec" "$t/live" "$1"; }
skip=0
if [ -d "$here/dist/vibrobeast" ]; then
  ( cd "$here/dist/vibrobeast" && find . | sed 's#^\./##' ) > "$t/live"
  live "$here/GRAMMARY.md" > "$t/o" 2>&1 && ok "live: $(grep 'P1/P2' "$t/o" | cut -c6-)" || bad live "$(grep FAIL "$t/o" | head -5)"
  if [ "${1:-}" = --prove-red ]; then
    awk -v m="$M" 'BEGIN{n=0} !done && index($0, " " m) && !index($0, "marked " m) { i = index($0, " " m); $0 = substr($0, 1, i - 1) substr($0, i + length(m) + 1); done = 1 } { print }' "$here/GRAMMARY.md" > "$t/r1"
    cmp -s "$here/GRAMMARY.md" "$t/r1" && bad prove-red-1 "the marker plant changed nothing"
    if live "$t/r1" > "$t/o" 2>&1; then bad prove-red-1 "a GRAMMARY with one marker cut passed"
    else ok "prove-red: one marker cut goes red ($(grep -c '^FAIL' "$t/o") FAIL rows)"; fi
    grep -v "marked $M" "$here/GRAMMARY.md" > "$t/r2"
    if live "$t/r2" > "$t/o" 2>&1; then bad prove-red-2 "a GRAMMARY with no header sentence passed"
    else ok "prove-red: the header sentence cut goes red ($(grep -c '^FAIL' "$t/o") FAIL rows)"; fi
  fi
else echo "grammary-paths tests: live row NOT CHECKED (no dist/vibrobeast here; mint first)"; skip=1; fi
echo "TOTAL pass=$pass fail=$fail"
[ $fail -eq 0 ] || exit 1
[ $skip -eq 1 ] && exit 77
exit 0
