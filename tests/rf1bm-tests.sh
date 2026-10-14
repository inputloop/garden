#!/bin/sh
# rf1bm-tests.sh — expected behaviours for bin/rf1bm (Roll for Bias, in code, per the method).
# usage: sh tests/rf1bm-tests.sh | --prove-red      (run from the AS4CE0001 root)
# Copyright 2026 Corwin Brust <corwin@bru.st> — GPLv3-or-later. Authored by Fable 2026-09-06.
#
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
set -u
here=$(cd "$(dirname "$0")/.." && pwd); R="$here/bin/rf1bm"; export PYTHONDONTWRITEBYTECODE=1
t=${TMPDIR:-/tmp}/rf1bm-tests.$$; mkdir -p "$t"; pass=0; fail=0
ok() { pass=$((pass+1)); echo "ok   $1"; }; bad() { fail=$((fail+1)); echo "FAIL $1 — $2"; }
awk 'BEGIN{for(i=1;i<=100;i++) printf "item%03d\t%d\n", i, (i%11)-5}' > "$t/pop.tsv"
python3 "$R" "$t/pop.tsv" --metric m --seed 7 --pick 9 --fate --sources guess --json "$t/r.json" > "$t/out.md" 2>"$t/err" && ok "runs" || bad "runs" "$(cat "$t/err")"
grep -q '^validated: 36 items · 6x6 · 6x6 · 1..36 once' "$t/out.md" && ok "self-validated" || bad "self-validated" "no line"
grep -q 'Marked: for fiction or analysis' "$t/out.md" && ok "news-mark-present" || bad "news-mark" "missing"
python3 - "$t/r.json" <<'EOF' && ok "json-shape-and-constraints" || bad "json-shape" "see python"
import json,sys; d=json.load(open(sys.argv[1]))
assert len(d["ordered"])==36 and d["ordered"][0]["score"]>=d["ordered"][-1]["score"]
assert sorted(n for r in d["randomized_matrix"] for n in r)==list(range(1,37))
assert all(len(r)==6 for r in d["ordered_matrix"]) and len(d["picks"])==9
assert d["fate"] in ("villain","badguy","malcontent","ne'er-do-well")
ext=sum(1 for o in d["ordered"] if abs(o["score"])>=4); assert ext>=10, ext   # extremes kept
EOF
a=$(python3 "$R" "$t/pop.tsv" --metric m --seed 7 --pick 9 | grep -A9 '^## Picks' | md5sum); b=$(python3 "$R" "$t/pop.tsv" --metric m --seed 7 --pick 9 | grep -A9 '^## Picks' | md5sum)
[ "$a" = "$b" ] && ok "seed-reproducible" || bad "seed-reproducible" "differs"
c=$(python3 "$R" "$t/pop.tsv" --metric m --seed 8 --pick 9 | grep -A9 '^## Picks' | md5sum)
[ "$a" != "$c" ] && ok "seed-matters" || bad "seed-matters" "same picks for two seeds"
python3 "$R" "$t/pop.tsv" --metric m >/dev/null 2>&1; [ $? -eq 2 ] && ok "usage-needs-seed" || bad "usage-needs-seed" "exit not 2"
head -35 "$t/pop.tsv" > "$t/small.tsv"; python3 "$R" "$t/small.tsv" --metric m --seed 1 >/dev/null 2>&1; [ $? -eq 2 ] && ok "refuses-under-36" || bad "refuses-under-36" "exit not 2"
# v1.2 -- fold ORDER (HIS clarification 2026-09-06 + METHOD '(6,6) is the neutral baseline'): |bias| descending 1..36, either sign
python3 - "$t/r.json" <<'EOF2' && ok "fold-order-biased-first-neutral-last" || bad "fold-order" "see python"
import json,sys; d=json.load(open(sys.argv[1])); o=d["ordered"]
a=[abs(x["score"]) for x in o]
assert a==sorted(a,reverse=True), a            # one monotone run: most biased first, most neutral last
assert min(a[:18])>=max(a[18:]), "an extreme sits after a neutral"
assert abs(o[0]["score"])==max(abs(x["score"]) for x in o) and abs(o[-1]["score"])==min(abs(x["score"]) for x in o)
EOF2
python3 "$R" --prove-red | grep -q '^PASS' && ok "self-prove-red" || bad "self-prove-red" "no PASS"
# v1.1 -- the bad-guy stage (HIS rule 2026-09-06) and "don't re-roll"
python3 "$R" "$t/pop.tsv" --metric m --seed 7 --pick 9 --fate-from "$t/r.json" --actor system --json "$t/r2.json" > "$t/out2.md" 2>"$t/err2" && ok "actor-system-runs" || bad "actor-system-runs" "$(cat "$t/err2")"
grep -q '^## Bad-guy perspective' "$t/out2.md" && grep -q 'One more lens stage' "$t/out2.md" && ok "badguy-stage-emitted" || bad "badguy-stage" "sections missing"
grep -c '^[1-4]\. how does this fate inform my' "$t/out2.md" | grep -qx 4 && ok "grain-of-four-questions" || bad "grain-of-four" "not 4"
python3 - "$t/r.json" "$t/r2.json" <<'EOF' && ok "fate-from-reuses-dice-never-rerolls" || bad "fate-from" "dice differ or badguy shape wrong"
import json,sys; a=json.load(open(sys.argv[1])); b=json.load(open(sys.argv[2]))
assert a["fate_dice"]==b["fate_dice"] and a["fate"]==b["fate"] and b["fate_from"] and b["actor"]=="system"
assert b["badguy"]["reroll"] is False and len(b["badguy"]["grain_questions"])==4 and len(b["badguy"]["inversion_stage"])==4
assert b["badguy"]["parity"] in ("even","odd") and b["badguy"]["branch"].startswith(("tragic","asocial"))
EOF
python3 "$R" "$t/pop.tsv" --metric m --seed 7 --actor system >/dev/null 2>&1; [ $? -eq 2 ] && ok "actor-system-needs-a-fate" || bad "actor-system-needs-a-fate" "exit not 2"
python3 "$R" "$t/pop.tsv" --metric m --seed 7 --fate --actor fiction --json "$t/r3.json" >/dev/null 2>&1 && python3 -c "import json,sys; d=json.load(open('$t/r3.json')); sys.exit(0 if d['badguy'] is None else 1)" && ok "fiction-actor-no-badguy-stage" || bad "fiction-actor" "badguy stage emitted for fiction"
if [ "${1:-}" = "--prove-red" ]; then
  before=$fail; grep -q '^validated: 35 items' "$t/out.md" && ok "PLANTED" || bad "PLANTED-wrong-expectation" "planted"
  rm -rf "$t"; [ "$fail" -eq $((before+1)) ] && { echo "PASS: harness correctly went red under a planted bad expectation"; exit 0; } || { echo "FAIL: harness did not go red"; exit 1; }
fi
rm -rf "$t"; echo "TOTAL pass=$pass fail=$fail"; [ "$fail" -eq 0 ]
