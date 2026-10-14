#!/bin/sh
# cs1gk-tests.sh — expected verdicts for bin/cs1gk (the character-sheet gauge).
# usage: sh tests/cs1gk-tests.sh | --prove-red      (run from the AS4CE0001 root)
# Copyright 2026 Corwin Brust <corwin@bru.st> — GPLv3-or-later. Authored by Fable 2026-09-06.
#
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
set -u
here=$(cd "$(dirname "$0")/.." && pwd); G="$here/bin/cs1gk"; export PYTHONDONTWRITEBYTECODE=1
t=${TMPDIR:-/tmp}/cs1gk-tests.$$; mkdir -p "$t/h" "$t/twin"; pass=0; fail=0
ok() { pass=$((pass+1)); echo "ok   $1"; }; bad() { fail=$((fail+1)); echo "FAIL $1 — $2"; }
good() { cat > "$1" <<'EOS'
# CHARACTER — test
actor: system
## Fleshing
(1) one (2) two. RADIATION-PROOF.
## Garb
plain words
## The bench — tools & accessories, with usage
| tool | what | how I use it |
|---|---|---|
| x | y | z |
## What I hold
| I hold | where |
|---|---|
| a | b |
## Journal — in my own voice
I opened the sheet today.
## GROW receipt + LENS reflection
hold-four-views elected. Marked: for fiction or analysis — no ship dates or licensing or publication dates specifically defined. rolled the dice.
## Break-character watch
none
## Bad-guy perspective (not re-rolled; roll r.json)
voice here
## Inversion — one more lens stage
inverse here
EOS
}
good "$t/h/T.md"; printf 'table\tkey\tcount\tvalue\ttreatment\tsource\ncs-intrinsics\tgold\t\t0\teconomy\tsrc\ncs-intrinsics\tspecial\t\tline\tspecialness\tsrc\ncs-skills\ts\t1\tv\tattr\tsrc\ncs-posessions\tp\t\tv\ttool\tsrc\n' > "$t/h/T.tsv"
printf '# corpus\n- T.md\n' > "$t/PERSONA-CORPUS.md"; cp "$t/h/T.md" "$t/twin/T.md"
out=$(python3 "$G" "$t/h/T.md" --twin "$t/twin"); rc=$?
[ $rc -eq 0 ] && ok "good-sheet-exit-0" || bad "good-sheet-exit-0" "rc=$rc"
printf '%s\n' "$out" | grep -q 'FAULT 0' && ok "good-sheet-no-fault" || bad "good-sheet-no-fault" "$out"
printf '%s\n' "$out" | grep -q 'G5 *TSV sidecar: tables cs-intrinsics, cs-posessions, cs-skills' && ok "tsv-tables-seen" || bad "tsv-tables" "$out"
printf '%s\n' "$out" | grep -q 'double-entry: 4 of 4' && ok "double-entry-counted" || bad "double-entry" "$out"
printf '%s\n' "$out" | grep -q 'G8 *twin .*SAME' && ok "twin-same" || bad "twin-same" "$out"
printf '%s\n' "$out" | grep -q 'G6 *corpus .* names this sheet' && ok "corpus-registered" || bad "corpus" "$out"
printf '%s\n' "$out" | grep -q 'numbered attributes seen: 2 -- sheet declares RADIATION-PROOF' && ok "attributes-and-radiation" || bad "attributes" "$out"
sed -i '/^## Fleshing/,/^## Garb/{/^## Fleshing/d;/^(1)/d}' "$t/h/T.md"; python3 "$G" "$t/h/T.md" >/dev/null; [ $? -eq 1 ] && ok "missing-fleshing-faults" || bad "missing-fleshing" "rc"
good "$t/h/T.md"; sed -i 's/Marked: for fiction or analysis[^.]*\.//' "$t/h/T.md"; python3 "$G" "$t/h/T.md" | grep -q 'NEWS mark MISSING' && ok "news-mark-missing-warns" || bad "news-mark" "no warn"
good "$t/h/T.md"; printf 'x\n' >> "$t/twin/T.md"; python3 "$G" "$t/h/T.md" --twin "$t/twin" | grep -q 'DIVERGED' && ok "twin-diverged" || bad "twin-diverged" "no"
good "$t/h/T.md"; sed -i 's/^I opened the sheet today\./see the journal pointers./' "$t/h/T.md"; python3 "$G" "$t/h/T.md" | grep -q 'journal section has no first person' && ok "journal-voice-warns" || bad "journal-voice" "no"
good "$t/h/T.md"; printf 'table\tkey\tcount\tvalue\ttreatment\tsource\ncs-intrinsics\tname\t\tT\tid\t\n' > "$t/h/T.tsv"; o=$(python3 "$G" "$t/h/T.md"); printf '%s\n' "$o" | grep -q 'MISSING cs-posessions, cs-skills' && ok "tsv-missing-tables-fault" || bad "tsv-missing" "$o"
printf '%s\n' "$o" | grep -q 'double-entry: 0 of 1' && ok "double-entry-missing-source" || bad "double-entry-missing" "$o"
python3 "$G" --diagram "$t/h/T.tsv" > "$t/d.json" && python3 "$here/bin/dc1sv" --tally "$t/d.json" | grep -q 'groups 3' && ok "diagram-emits-three-frames" || bad "diagram" "no"
# G10 -- the bad-guy stage (HIS rule 2026-09-06)
good "$t/h/T.md"; python3 "$G" "$t/h/T.md" | grep -q 'G10 *system actor: bad-guy perspective present' && ok "g10-system-badguy-present" || bad "g10-present" "no"
good "$t/h/T.md"; sed -i '/^## Bad-guy perspective/,/^## Inversion/{/^## Bad-guy/d;/^voice here/d}' "$t/h/T.md"; python3 "$G" "$t/h/T.md" >/dev/null; [ $? -eq 1 ] && ok "g10-system-missing-badguy-faults" || bad "g10-missing-badguy" "rc"
good "$t/h/T.md"; sed -i 's/^## Inversion.*$/## Something else/' "$t/h/T.md"; python3 "$G" "$t/h/T.md" | grep -q 'inversion lens stage MISSING' && ok "g10-system-missing-inversion-faults" || bad "g10-missing-inversion" "no"
good "$t/h/T.md"; sed -i 's/^actor: system$/actor: fiction/' "$t/h/T.md"; python3 "$G" "$t/h/T.md" | grep -q 'G10 *fiction actor' && ok "g10-fiction-optional" || bad "g10-fiction" "no"
good "$t/h/T.md"; sed -i '/^actor: system$/d' "$t/h/T.md"; python3 "$G" "$t/h/T.md" | grep -q 'actor kind undeclared' && ok "g10-undeclared-warns" || bad "g10-undeclared" "no"
good "$t/h/T.md"; sed -i 's/(not re-rolled; roll r.json)//' "$t/h/T.md"; python3 "$G" "$t/h/T.md" | grep -q 'does not say which roll it reused' && ok "g10-reroll-unnamed-warns" || bad "g10-reroll" "no"
python3 "$G" --prove-red | grep -q '^PASS' && ok "self-prove-red" || bad "self-prove-red" "no"
python3 "$G" "$t/h/T.md" --tsv | grep -q '^G1	' && ok "tsv-output" || bad "tsv-output" "no"
if [ "${1:-}" = "--prove-red" ]; then
  before=$fail; good "$t/h/T.md"; python3 "$G" "$t/h/T.md" | grep -q 'FAULT 3' && ok "PLANTED" || bad "PLANTED-wrong-expectation" "planted"
  rm -rf "$t"; [ "$fail" -eq $((before+1)) ] && { echo "PASS: harness correctly went red under a planted bad expectation"; exit 0; } || { echo "FAIL: harness did not go red"; exit 1; }
fi
rm -rf "$t"; echo "TOTAL pass=$pass fail=$fail"; [ "$fail" -eq 0 ]
