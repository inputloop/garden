#!/bin/sh
# dc1sv-tests.sh — pins + expected behaviours for bin/dc1sv (canonical diagram document → SVG, v2).
# usage: sh tests/dc1sv-tests.sh             (run from the AS4CE0001 root)
#        sh tests/dc1sv-tests.sh --prove-red (plant a wrong expectation; harness must go red)
# Copyright 2026 Corwin Brust <corwin@bru.st> — GPLv3-or-later. Authored by Fable 2026-09-05.
#
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
set -u
here=$(cd "$(dirname "$0")/.." && pwd); D="$here/bin/dc1sv"; H="$here/h"; A11Y=/f/claude/c4/h/svg-a11y-test.sh
[ -f "$A11Y" ] || A11Y=/sessions/kind-vibrant-heisenberg/mnt/c4/h/svg-a11y-test.sh
export PYTHONDONTWRITEBYTECODE=1
t=${TMPDIR:-/tmp}/dc1sv-tests.$$; mkdir -p "$t"; pass=0; fail=0
ok()   { pass=$((pass+1)); echo "ok   $1"; }
bad()  { fail=$((fail+1)); echo "FAIL $1 — $2"; }
pin()  { # pin NAME DOC SHA12 : a FROZEN v1 fixture (tests/fixtures/dc1sv) must render byte-identical to its 09-05 SVG
  got=$(python3 "$D" "$H/$2.json" | sha256sum | cut -c1-12)
  [ "$got" = "$3" ] && ok "v1-byte-identical $1" || bad "v1-byte-identical $1" "got $got want $3"
}
pin symbiosis ../tests/fixtures/dc1sv/symbiosis-v1 0cde1b5d41a3
pin floors    ../tests/fixtures/dc1sv/floors-v1    fb574de8b932
pin tree      ../tests/fixtures/dc1sv/tree-v1      bd93bb2457c4

# v2 fixture: two dotted coloured groups sharing one shape; a labelled edge; an event node
cat > "$t/v2.json" <<'EOF'
{"v":1,"shapes":[
 {"id":"a","label":"alpha","kind":"box","x":40,"y":60,"group":"g1"},
 {"id":"s","label":"shared","kind":"box","x":300,"y":60,"groups":["g1","g2"]},
 {"id":"b","label":"beta","kind":"node","x":560,"y":60,"group":"g2"}],
 "edges":[{"from":"a","to":"s","label":"knows","color":"#0F6E56"},{"from":"s","to":"b","label":"fires","nib":{"b":"open"},"style":{"dash":true}}],
 "systems":{"g1":{"_label":"ONE","color":"#534AB7","text":"#3C3489","line":"dotted"},"g2":{"_label":"TWO","color":"#0F6E56","line":"dotted"}}}
EOF
python3 "$D" "$t/v2.json" > "$t/v2.svg" 2>"$t/err" && ok "v2-renders" || bad "v2-renders" "$(cat "$t/err")"
python3 - "$t/v2.svg" <<'EOF' && ok "v2-shared-shape-inside-both-group-rects" || bad "v2-shared-shape-inside-both-group-rects" "see python"
import re,sys
s=open(sys.argv[1]).read()
rects={m.group(1):tuple(float(v) for v in m.groups()[1:]) for m in re.finditer(r'<rect class="sys (\w+)" x="([-\d.]+)" y="([-\d.]+)" width="([\d.]+)" height="([\d.]+)"',s)}
m=re.search(r'<rect class="box" x="(\d+)" y="(\d+)" width="(\d+)" height="(\d+)" rx="3"/><text[^>]*>shared<',s)
x,y,w,h=map(float,m.groups())
inside=lambda r: r[0]<=x and r[1]<=y and x+w<=r[0]+r[2] and y+h<=r[1]+r[3]
assert inside(rects["g1"]) and inside(rects["g2"]), (rects,(x,y,w,h))
EOF
grep -q 'stroke-dasharray:2 4' "$t/v2.svg"            && ok "v2-dotted-group-line"     || bad "v2-dotted-group-line" "no 2 4 dash"
grep -q 'stroke:var(--c4-sys-g1,#534AB7)' "$t/v2.svg"  && ok "v2-group-colour-as-var"   || bad "v2-group-colour-as-var" "no var()"
grep -q 'fill:var(--c4-systext-g1,#3C3489)' "$t/v2.svg" && ok "v2-title-text-colour"    || bad "v2-title-text-colour" "no text var"
grep -q 'stroke:var(--c4-edge-a-s,#0F6E56)' "$t/v2.svg" && ok "v2-edge-colour-as-var"   || bad "v2-edge-colour-as-var" "no edge var"
grep -q '<rect class="lbl"' "$t/v2.svg" && grep -q '>knows<' "$t/v2.svg" && ok "v2-edge-label-with-backing" || bad "v2-edge-label-with-backing" "no lbl rect/text"
lastbox=$(grep -n '<rect class="box"' "$t/v2.svg" | tail -1 | cut -d: -f1); firstlbl=$(grep -n '<rect class="lbl"' "$t/v2.svg" | head -1 | cut -d: -f1)
[ "$firstlbl" -gt "$lastbox" ] && ok "v2-labels-drawn-after-shapes" || bad "v2-labels-drawn-after-shapes" "lbl line $firstlbl before box line $lastbox"
grep -q 'rect.lbl{fill:var(--c4-label-bg,#ffffff)' "$t/v2.svg" && ok "v2-label-backing-opaque-var" || bad "v2-label-backing-opaque-var" "no lbl style"
python3 "$D" --lint "$t/v2.json" >/dev/null && ok "v2-lint-clean" || bad "v2-lint-clean" "$(python3 "$D" --lint "$t/v2.json")"
python3 "$D" --tally "$t/v2.json" | grep -q 'shapes 3 edges 2 groups 2' && ok "v2-tally-counts-groups-array" || bad "v2-tally" "$(python3 "$D" --tally "$t/v2.json")"
[ -f "$A11Y" ] && { [ "$(sh "$A11Y" "$t/v2.svg" | grep -c PASS)" = 7 ] && ok "v2-house-a11y-7of7" || bad "v2-house-a11y-7of7" "$(sh "$A11Y" "$t/v2.svg")"; }
# lint must go red on a planted overlap (shape on shape) and on an edge through a third shape
sed 's/"x":300,"y":60,"groups"/"x":60,"y":70,"groups"/' "$t/v2.json" > "$t/bad1.json"
python3 "$D" --lint "$t/bad1.json" | grep -q 'shape a overlaps shape s' && ok "lint-red-shape-overlap" || bad "lint-red-shape-overlap" "not reported"
cat > "$t/bad2.json" <<'EOF'
{"v":1,"shapes":[{"id":"a","label":"a","kind":"box","x":40,"y":60},{"id":"m","label":"middle","kind":"box","x":200,"y":60},{"id":"b","label":"b","kind":"box","x":400,"y":60}],
 "edges":[{"from":"a","to":"b","label":"through"}]}
EOF
python3 "$D" --lint "$t/bad2.json" | grep -q 'edge a->b passes through m' && ok "lint-red-edge-through-shape" || bad "lint-red-edge-through-shape" "not reported"
python3 "$D" --lint "$t/bad2.json" >/dev/null 2>&1; [ $? -eq 1 ] && ok "lint-exit-1-on-fault" || bad "lint-exit-1-on-fault" "exit not 1"
python3 "$D" --text "$t/v2.json" | grep -q "^- alpha -> shared: knows (flow)" && ok "v2-text-reading" || bad "v2-text-reading" "no adjacency line"
python3 "$D" --text "$t/v2.json" | grep -q "shared (store/tool/skill) — also in: TWO" && ok "v2-text-shows-shared-membership" || bad "v2-text-shows-shared-membership" "no also-in"
python3 "$D" --prove-red | grep -q '^PASS' && ok "self-prove-red" || bad "self-prove-red" "no PASS"
# v2.1 -- "paper":"graph" (character sheets on graph paper at the dungeon table)
cat > "$t/paper.json" <<'EOF'
{"v":1,"paper":"graph","shapes":[{"id":"a","label":"a","kind":"box","x":40,"y":60}],"edges":[]}
EOF
python3 "$D" "$t/paper.json" > "$t/paper.svg" && grep -q 'pattern id="graph"' "$t/paper.svg" && grep -q 'class="paper grid"' "$t/paper.svg" && grep -q 'graph paper · 20px squares' "$t/paper.svg" && ok "graph-paper-grid-emitted-and-said" || bad "graph-paper" "no grid/pattern/words"
sed 's/"paper":"graph",//' "$t/paper.json" > "$t/plain.json"; python3 "$D" "$t/plain.json" | grep -q 'pattern id="graph"' && bad "plain-has-no-grid" "grid leaked into a non-paper doc" || ok "plain-has-no-grid"
# the live intersections document stays clean
python3 "$D" --lint "$H/DIAGRAM-2026-09-05-memory-intersections.json" >/dev/null && ok "intersections-doc-lint-clean" || bad "intersections-doc-lint-clean" "faults"
[ "$(python3 "$D" "$H/DIAGRAM-2026-09-05-memory-intersections.json" | sha256sum | cut -c1-12)" = "$(sha256sum "$H/DIAGRAM-2026-09-05-memory-intersections.svg" | cut -c1-12)" ] && ok "intersections-svg-is-current" || bad "intersections-svg-is-current" "regen differs from shipped svg"

if [ "${1:-}" = "--prove-red" ]; then
  echo "== prove-red: planting a wrong pin (symbiosis must mismatch) =="
  before=$fail; pin PLANTED-wrong-pin ../tests/fixtures/dc1sv/symbiosis-v1 000000000000
  rm -rf "$t"
  if [ "$fail" -eq $((before+1)) ]; then echo "PASS: harness correctly went red under a planted bad expectation"; exit 0; else echo "FAIL: harness did not go red"; exit 1; fi
fi
rm -rf "$t"
echo "TOTAL pass=$pass fail=$fail"; [ "$fail" -eq 0 ]
