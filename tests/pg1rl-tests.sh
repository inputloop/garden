#!/bin/sh
# pg1rl-tests.sh — expected behaviours for bin/pg1rl (the persona grid: build, lint, roll, html).
# usage: sh tests/pg1rl-tests.sh | --prove-red      (run from the AS4CE0001 root)
# Copyright 2026 Corwin Brust <corwin@bru.st> — GPLv3-or-later. Authored by Fable 2026-09-06.
#
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
set -u
here=$(cd "$(dirname "$0")/.." && pwd); P="$here/bin/pg1rl"; T="$here/h/traits"; export PYTHONDONTWRITEBYTECODE=1
t=${TMPDIR:-/tmp}/pg1rl-tests.$$; mkdir -p "$t"; pass=0; fail=0
ok() { pass=$((pass+1)); echo "ok   $1"; }; bad() { fail=$((fail+1)); echo "FAIL $1 — $2"; }
# a synthetic record: 144 traits, 6 cols x 4 tables x 6 rows, level words distinct per cell
python3 - "$t/traits.tsv" <<'EOF'
import sys
hdr="col\ttable\trow\ttrait\tdefinition\tlow_pole\thigh_pole\tL1\tL2\tL3\tL4\tL5\tL6\tneighbors\ttaxonomy\tformal_1\tformal_2\tformal_3\tflair_1\tflair_2\tverify\tnotes"
rows=[hdr]
for c in "ABCDEF":
    for tb in range(1,5):
        for r in range(1,7):
            name="Trait %s%d.%d"%(c,tb,r)
            rows.append("\t".join([c,str(tb),str(r),name,"def","lo","hi"]+["%s L%d"%(name,i) for i in range(1,7)]+["n","tax","F1 [VERIFIED-2]","F2 [VERIFIED-1]","F3 [VERIFIED-1]","flair [VERIFIED-1]","","pubmed:1","n"]))
open(sys.argv[1],"w",encoding="utf-8").write("\n".join(rows)+"\n")
EOF
python3 - "$t/news.tsv" <<'EOF'
import sys,random
lines=["n\titem\tside"]+["%d\tSource %d\t%s"%(i,i,"biased" if i<=18 else "least-biased") for i in range(1,37)]
nums=list(range(1,37)); random.Random(1).shuffle(nums)
lines.append("# randomized matrix rows (test): "+";".join(" ".join(str(x) for x in nums[r*6:(r+1)*6]) for r in range(6)))
open(sys.argv[1],"w",encoding="utf-8").write("\n".join(lines)+"\n")
EOF
printf '# Test grid\n\n<!-- C4:section id=instructions tab="How to play" -->\n## How\nroll.\n<!-- C4:end -->\n\n<!-- C4:generated -->\n' > "$t/tmpl.md"
python3 "$P" --build "$t/traits.tsv" "$t/news.tsv" "$t/tmpl.md" --seed 7 > "$t/grid.md" 2>"$t/err" && ok "build-runs" || bad "build-runs" "$(cat "$t/err")"
python3 "$P" --lint "$t/grid.md" > "$t/lint" 2>&1 && ok "lint-clean" || bad "lint-clean" "$(cat "$t/lint")"
grep -q '24 table(s), 24 jumbled, 36 news items, index ok, 1 tab(s)' "$t/lint" && ok "lint-counts" || bad "lint-counts" "$(cat "$t/lint")"
# index: 24 numbers once + 12 stripe cells on the two diagonals
python3 - "$t/grid.md" "$P" <<'EOF' && ok "index-24-numbers-12-stripes" || bad "index" "see python"
import sys,subprocess,json
d=json.loads(subprocess.check_output(["python3",sys.argv[2],"--json",sys.argv[1]]))
idx=d["index"]; nums=sorted(int(x) for r in idx for x in r if x.isdigit()); assert nums==list(range(1,25))
assert all(idx[a][a]=="BIAS" for a in range(6)) and all(idx[a][5-a]=="X" for a in range(6))
assert all(len(d["tables"][str(n)]["traits"])==6 for n in range(1,25)) and d["tables"]["1"]["id"]=="A1" and d["tables"]["24"]["id"]=="F4"
EOF
# jumbled is a permutation of the straight table (lint checks it) -- break it and lint must FAULT
sed 's/Trait A1.1 · L1 · Trait A1.1 L1/Trait A1.1 · L1 · TAMPERED/' "$t/grid.md" > "$t/bad.md"; python3 "$P" --lint "$t/bad.md" >/dev/null 2>&1; [ $? -eq 1 ] && ok "lint-faults-tampered-jumbled" || bad "lint-tamper" "exit not 1"
# roll: seeded, reproducible, seed matters, the trace names every die
python3 "$P" --roll "$t/grid.md" --seed 11 --traits 9 > "$t/r1" && python3 "$P" --roll "$t/grid.md" --seed 11 --traits 9 > "$t/r2" && cmp -s "$t/r1" "$t/r2" && ok "roll-seed-reproducible" || bad "roll-seed" "differs"
python3 "$P" --roll "$t/grid.md" --seed 12 --traits 9 > "$t/r3"; cmp -s "$t/r1" "$t/r3" && bad "roll-seed-matters" "same" || ok "roll-seed-matters"
grep -c '^## trait' "$t/r1" | grep -qx 9 && ok "roll-nine-traits" || bad "roll-nine" "$(grep -c '^## trait' "$t/r1")"
grep -q 'Marked: for fiction or analysis' "$t/r1" && ok "roll-news-mark" || bad "roll-mark" "missing"
python3 "$P" --roll "$t/grid.md" --traits 2 >/dev/null 2>&1; [ $? -eq 2 ] && ok "roll-needs-seed" || bad "roll-needs-seed" "exit not 2"
# the rules, mechanically: sweep seeds until each rule fires at least once
python3 - "$t/grid.md" "$P" <<'EOF' && ok "rules-all-fire-over-seeds" || bad "rules" "see python"
import sys,subprocess
seen=set()
for s in range(1,60):
    out=subprocess.check_output(["python3",sys.argv[2],"--roll",sys.argv[1],"--seed",str(s),"--traits","6"]).decode()
    for k in ("high doubles","low doubles","LOAD-BEARING","BACKGROUND","bias stripe","intersection stripe","escalate","numbered cells only"):
        if k in out: seen.add(k)
missing={"high doubles","low doubles","LOAD-BEARING","BACKGROUND","bias stripe","intersection stripe","escalate","numbered cells only"}-seen
assert not missing, missing
EOF
# a bump lands on the neighbouring trait and clamps the level
python3 - "$t/grid.md" "$P" <<'EOF' && ok "bump-arithmetic" || bad "bump-arithmetic" "see python"
import sys,subprocess,json,re
for s in range(1,80):
    out=subprocess.check_output(["python3",sys.argv[2],"--roll",sys.argv[1],"--seed",str(s),"--traits","6"]).decode()
    for m in re.finditer(r"table (\d+) \(\w+\) (\d)\+(\d) -> Trait (\w)(\d)\.(\d) · L(\d) · .*?high doubles", out):
        n,a,b,c,tb,r,l=m.groups(); assert int(r)==(int(a)%6)+1 and int(l)==min(6,int(a)+1),(m.group(0))
    for m in re.finditer(r"table (\d+) \(\w+\) (\d)\+(\d) -> Trait (\w)(\d)\.(\d) · L(\d) · .*?low doubles", out):
        n,a,b,c,tb,r,l=m.groups(); assert int(r)==((int(a)-2)%6)+1 and int(l)==max(1,int(a)-1),(m.group(0))
    for m in re.finditer(r"table (\d+) \(\w+\) (\d)\+(\d) -> Trait (\w)(\d)\.(\d) · L(\d) · .*?(LOAD-BEARING|BACKGROUND)", out):
        n,a,b,c,tb,r,l,w=m.groups(); assert int(r)==int(a) and int(l)==(min(6,int(b)+1) if w=="LOAD-BEARING" else max(1,int(b)-1)),(m.group(0))
EOF
# jumbled mode: no bumps, no stripes
python3 "$P" --roll "$t/grid.md" --seed 5 --traits 9 --jumbled > "$t/j"; grep -q 'JUMBLED' "$t/j" && ! grep -q 'doubles\|stripe\|LOAD-BEARING' "$t/j" && ok "jumbled-no-affinity" || bad "jumbled" "$(head -5 "$t/j")"
# html: tabs for every C4 section plus tables/jumbled/index/news; the JS roller is a port of roll() (same rule words)
python3 "$P" --html "$t/grid.md" > "$t/v.html" && grep -q 'id="tab-instructions"' "$t/v.html" && grep -q 'id="tab-tables"' "$t/v.html" && grep -q 'id="tab-jumbled"' "$t/v.html" && grep -q 'id="tab-index"' "$t/v.html" && grep -q 'id="tab-news"' "$t/v.html" && ok "html-tabs" || bad "html-tabs" "missing"
for k in "high doubles" "low doubles" "LOAD-BEARING" "BACKGROUND" "numbered cells only" "hl-pink" "hl-blue" "hl-green" "hl-yellow" "hl-purple"; do grep -q "$k" "$t/v.html" || bad "html-rule-$k" "absent"; done; ok "html-carries-rules-and-highlighter"
grep -q 'background-size:100px 100px' "$t/v.html" && ok "html-graph-paper" || bad "html-graph-paper" "no grid"
python3 "$P" --sources "$t/traits.tsv" | grep -q '144 traits · formal slots 432 (VERIFIED-2 144 · VERIFIED-1 288 · UNVERIFIED 0)' && ok "sources-counts" || bad "sources-counts" "$(python3 "$P" --sources "$t/traits.tsv" | sed -n 4p)"
python3 "$P" --prove-red | grep -q '^PASS' && ok "self-prove-red" || bad "self-prove-red" "no PASS"
# the live grid, if present, lints clean
if [ -f "$T/PERSONA-TRAITS-GRID.md" ]; then python3 "$P" --lint "$T/PERSONA-TRAITS-GRID.md" >/dev/null 2>&1 && ok "live-grid-lint-clean" || bad "live-grid-lint" "faults"; fi
if [ "${1:-}" = "--prove-red" ]; then
  before=$fail; grep -q '25 table(s)' "$t/lint" && ok "PLANTED" || bad "PLANTED-wrong-expectation" "planted"
  rm -rf "$t"; [ "$fail" -eq $((before+1)) ] && { echo "PASS: harness correctly went red under a planted bad expectation"; exit 0; } || { echo "FAIL: harness did not go red"; exit 1; }
fi
rm -rf "$t"; echo "TOTAL pass=$pass fail=$fail"; [ "$fail" -eq 0 ]
