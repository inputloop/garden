#!/bin/sh
# hb1ck-tests.sh — expected behaviours for bin/hb1ck (the handback check).
# usage: sh tests/hb1ck-tests.sh | --prove-red      (run from the AS4CE0001 root)
# Copyright 2026 Corwin Brust <corwin@bru.st> — GPLv3-or-later. Authored by Mentat (for Corwin).
#
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
set -u
here=$(cd "$(dirname "$0")/.." && pwd); H="$here/bin/hb1ck"
t=${TMPDIR:-/tmp}/hb1ck-tests.$$; mkdir -p "$t/proj"; pass=0; fail=0
ok()  { pass=$((pass+1)); echo "ok   $1"; }
bad() { fail=$((fail+1)); echo "FAIL $1 — $2"; }
map() { printf '# INDEX\n| where | what |\n| `bin/` | code |\n| `book/` | corpus |\n| `advice/` | trail |\n' > "$t/proj/INDEX.md"; }

# --- layout
map; printf 'bin/tool\nbook/thing.md\nadvice/note.md\n' > "$t/good"
sh "$H" --layout "$t/proj" --since "$t/good" >/dev/null 2>&1 && ok "layout-all-in-documented-homes" || bad "layout ok" "rejected a clean list"
printf 'h/thing.md\n' > "$t/off"
sh "$H" --layout "$t/proj" --since "$t/off" 2>&1 | grep -q 'landed outside' && ok "layout-undocumented-home-faults" || bad "layout off" "no"
printf 'README.md\n' > "$t/root"
sh "$H" --layout "$t/proj" --since "$t/root" >/dev/null 2>&1 && ok "layout-root-file-is-furniture-not-a-shelf" || bad "layout root" "faulted on a root file"
rm -f "$t/proj/INDEX.md"; sh "$H" --layout "$t/proj" 2>&1 | grep -q 'no INDEX.md' && ok "layout-without-a-map-faults" || bad "layout nomap" "no"

# --- claims
printf '| id | claim | how | verdict |\n|---|---|---|---|\n| C1 | a | b | HELD |\n' > "$t/c1"
sh "$H" --claims "$t/c1" >/dev/null 2>&1 && ok "claims-all-resolved-passes" || bad "claims ok" "rejected"
printf '| id | claim | how | verdict |\n|---|---|---|---|\n| C1 | a | b | HELD |\n| C2 | a | b |  |\n' > "$t/c2"
sh "$H" --claims "$t/c2" 2>&1 | grep -q '1 of 2 opening claim' && ok "claims-empty-verdict-faults" || bad "claims empty" "no"
printf '| id | claim | how | verdict |\n|---|---|---|---|\n| C1 | a | b | open |\n' > "$t/c3"
sh "$H" --claims "$t/c3" 2>&1 | grep -q 'never resolved' && ok "claims-open-verdict-faults" || bad "claims open" "no"
printf 'no rows here\n' > "$t/c4"
sh "$H" --claims "$t/c4" 2>&1 | grep -q 'no claim rows' && ok "claims-no-rows-faults" || bad "claims norows" "no"

# --- defer: the exact sentence that ended the 2026-09-13 handback
printf 'One honest gap: nobody has re-read the four books end to end. I did not do it.\n' > "$t/d1"
sh "$H" --defer "$t/d1" 2>&1 | grep -q 'unblocked at line' && ok "defer-the-actual-2026-09-13-sentence-faults" || bad "defer naked" "no"
printf 'Not run this turn. [KEEPER: needs his ruling on the four kits]\n' > "$t/d2"
sh "$H" --defer "$t/d2" >/dev/null 2>&1 && ok "defer-with-a-keeper-blocker-passes" || bad "defer keeper" "rejected"
printf 'I did not run it. [BUDGET: lots remaining]\n' > "$t/d3"
sh "$H" --defer "$t/d3" 2>&1 | grep -q 'BUDGET blocker with no figure' && ok "defer-budget-without-a-figure-faults" || bad "defer budget" "no"
printf 'I did not run it. [BUDGET: 14500000 remaining]\n' > "$t/d4"
sh "$H" --defer "$t/d4" >/dev/null 2>&1 && ok "defer-budget-with-a-figure-passes" || bad "defer budget ok" "rejected"
printf 'Everything asked for was done.\n' > "$t/d5"
sh "$H" --defer "$t/d5" >/dev/null 2>&1 && ok "defer-clean-handback-passes" || bad "defer clean" "rejected"

sh "$H" --prove-red | grep -q '^PASS' && ok "self-prove-red" || bad "self-prove-red" "no"
sh "$H" 2>&1 | grep -q 'usage:' && ok "no-args-prints-usage" || bad "usage" "no"

# a ledger whose ids are not C-prefixed is still a ledger. Found 2026-09-13 by running --claims on
# the D-prefixed ledger of the session that was writing this check.
printf '| id | claim | check | verdict |\n|---|---|---|---|\n| D1 | a | b | HELD |\n' > "$t/dledger.md"
sh "$H" --claims "$t/dledger.md" 2>&1 | grep -q 'all 1 opening claim' && ok "claims-accepts-a-D-prefixed-ledger" || bad "D ledger" "only C-prefixed rows were recognised"
printf '| id | claim | check | verdict |\n|---|---|---|---|\n| D1 | a | b |  |\n' > "$t/dopen.md"
sh "$H" --claims "$t/dopen.md" 2>&1 | grep -q 'never resolved' && ok "claims-still-catches-an-open-D-row" || bad "D open" "an open row passed"

# ---- E15, 2026-09-13: --defer's five false positives and its false negatives, each with a receipt ----
# Every one of these was found by running the check on real files in this tree, not on fixtures.

# FP1 a file that DOCUMENTS the tokens must not fault on its own documentation
printf 'Tokens: `[BLOCKED: why]`, `[KEEPER: what]`, `[BUDGET: N]`, `[TOOL: what]`.\n' > "$t/doc.md"
sh "$H" --defer "$t/doc.md" 2>&1 | grep -q '\[ FAULT' && bad "E15-FP1" "faulted on a backticked token mention" || ok "E15-defer-ignores-a-documented-token"

# FP2 a table cell is data: a game book's random table said "be the one who is owed"
printf '| 10 | be the one who is owed |\n' > "$t/tbl.md"
sh "$H" --defer "$t/tbl.md" 2>&1 | grep -q '\[ FAULT' && bad "E15-FP2" "faulted on a table row" || ok "E15-defer-ignores-a-table-row"

# FP3 a heading labelling a section is structure, not a promise
printf '## 5 - ENHANCE - out of scope for this round, kept separate\n' > "$t/head.md"
sh "$H" --defer "$t/head.md" 2>&1 | grep -q '\[ FAULT' && bad "E15-FP3" "faulted on a heading" || ok "E15-defer-ignores-a-heading"

# FP4 DEFERRED in caps is a verdict label being applied, not a promise being made
printf 'Mark each item CARRIED, SUPERSEDED or DEFERRED before you start.\n' > "$t/verdict.md"
sh "$H" --defer "$t/verdict.md" 2>&1 | grep -q '\[ FAULT' && bad "E15-FP4" "faulted on a caps verdict label" || ok "E15-defer-ignores-a-caps-verdict-label"

# FP5 fenced code is not prose
printf 'Fine.\n\n```\nI did not run the thing.\n```\n' > "$t/fence.md"
sh "$H" --defer "$t/fence.md" 2>&1 | grep -q '\[ FAULT' && bad "E15-FP5" "faulted inside a code fence" || ok "E15-defer-ignores-fenced-code"

# FP5b "a later session" without a handoff preposition is descriptive, not a deferral
printf 'A note is not edited by a later session.\n' > "$t/desc.md"
sh "$H" --defer "$t/desc.md" 2>&1 | grep -q '\[ FAULT' && bad "E15-FP5b" "faulted on a descriptive mention of a later session" || ok "E15-defer-ignores-a-descriptive-later-session"
printf 'I am leaving the watcher contract for a later session.\n' > "$t/handoff.md"
sh "$H" --defer "$t/handoff.md" 2>&1 | grep -q '\[ FAULT' && ok "E15-defer-still-catches-a-real-handoff" || bad "E15-FP5b-under" "missed a genuine handoff"

# BUG grep -c with a fallback produced "0\n0" -> "Illegal number". Any clean file proves it.
printf 'Nothing owed here at all.\n' > "$t/clean.md"
sh "$H" --defer "$t/clean.md" 2>&1 | grep -qi 'illegal number' && bad "E15-BUG" "the grep -c footgun is back" || ok "E15-defer-no-illegal-number-on-a-clean-file"

# FN the phrasings that used to walk straight past it
for phrase in "TODO: the watcher contract." "That is out of scope for this pass." "I punted on the second read." "It remains to be written." "I have not yet built it." "That is for a later session."; do
  printf '%s\n' "$phrase" > "$t/fn.md"
  sh "$H" --defer "$t/fn.md" 2>&1 | grep -q '\[ FAULT' || bad "E15-FN" "missed: $phrase"
done
ok "E15-defer-catches-six-phrasings-it-used-to-miss"

# and the original failure it was built for must still go red, tokenised must still pass
printf 'Nobody has re-read the books end to end. That is the next read, and I did not do it.\n' > "$t/orig.md"
sh "$H" --defer "$t/orig.md" 2>&1 | grep -q 'unblocked at line' && ok "E15-defer-still-catches-the-2026-09-13-failure" || bad "E15-orig" "the failure it exists for now passes"
printf 'I did not run the second read. [BUDGET: 14,500,000 remaining]\n' > "$t/tok.md"
sh "$H" --defer "$t/tok.md" 2>&1 | grep -q 'every one carrying a blocker' && ok "E15-defer-accepts-a-real-figure" || bad "E15-tok" "rejected a properly tokenised deferral"

if [ "${1:-}" = "--prove-red" ]; then
  before=$fail
  sh "$H" --claims "$t/c1" 2>&1 | grep -q 'never resolved' && ok "PLANTED" || bad "PLANTED-wrong-expectation" "planted"
  rm -rf "$t"
  [ "$fail" -eq $((before+1)) ] && { echo "PASS: harness correctly went red under a planted bad expectation"; exit 0; }
  echo "FAIL: harness did not go red"; exit 1
fi
rm -rf "$t"; echo "TOTAL pass=$pass fail=$fail"; [ "$fail" -eq 0 ]
