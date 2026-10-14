#!/bin/sh
# gb1md-tests.sh — expected behaviours for bin/gb1md (the game-book renderer + claim checker).
# usage: sh tests/gb1md-tests.sh | --prove-red       (run from the AS4CE0001 root)
# Copyright 2026 Corwin Brust <corwin@bru.st> — GPLv3-or-later. Authored by Mentat (for Corwin).
#
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
set -u
here=$(cd "$(dirname "$0")/.." && pwd); G="$here/bin/gb1md"; export PYTHONDONTWRITEBYTECODE=1
t=${TMPDIR:-/tmp}/gb1md-tests.$$; mkdir -p "$t"; pass=0; fail=0
ok()  { pass=$((pass+1)); echo "ok   $1"; }
bad() { fail=$((fail+1)); echo "FAIL $1 — $2"; }

head_ok() { printf '<!-- GB:book title="T" author="A" -->\n\n## A section\n\n<!-- GB:backmatter kind="reflection" -->\n## About the Author\n'; }

# --- the odds checker against Corwin's own saving-throw table (Docs/Tables/Savingthrow.org)
# Level 4 "Avoid Doubles, 7" = 24/36 ; level 9 "Doubles, 7" = 12/36 ; level 17 "BoxCars" = 1/36
{ head_ok; printf '<!-- GB:claim pattern="avd D+7" odds="24/36" -->\n'; } > "$t/a.md"
python3 "$G" --lint "$t/a.md" >/dev/null 2>&1 && ok "avd-D+7-is-24-36 (his level 4)" || bad "avd D+7" "rejected a true claim"
{ head_ok; printf '<!-- GB:claim pattern="D+7" odds="12/36" -->\n'; } > "$t/b.md"
python3 "$G" --lint "$t/b.md" >/dev/null 2>&1 && ok "D+7-is-12-36 (his level 9)" || bad "D+7" "rejected a true claim"
{ head_ok; printf '<!-- GB:claim pattern="BX" odds="1/36" -->\n'; } > "$t/c.md"
python3 "$G" --lint "$t/c.md" >/dev/null 2>&1 && ok "boxcars-is-1-36 (his level 17)" || bad "BX" "rejected a true claim"
{ head_ok; printf '<!-- GB:claim pattern="D" odds="6/36" -->\n<!-- GB:claim pattern="HD" odds="2/36" -->\n<!-- GB:claim pattern="LD" odds="2/36" -->\n<!-- GB:claim pattern="D+7+9+11" odds="18/36" -->\n<!-- GB:claim pattern="even" odds="18/36" -->\n<!-- GB:claim pattern="avd D" odds="30/36" -->\n<!-- GB:claim pattern="avd SE" odds="35/36" -->\n<!-- GB:claim pattern="avd LD" odds="34/36" -->\n<!-- GB:claim pattern="D+9" odds="10/36" -->\n<!-- GB:claim pattern="D+11" odds="8/36" -->\n'; } > "$t/d.md"
python3 "$G" --lint "$t/d.md" >/dev/null 2>&1 && ok "ten-more-rows-of-his-table-agree" || { bad "his table" "a row disagreed"; python3 "$G" --lint "$t/d.md" | grep FAULT | sed 's/^/     /'; }

# 4 and 9 are exact complements — the hinge the book is built on
{ head_ok; printf '<!-- GB:claim pattern="avd D+7" odds="24/36" -->\n<!-- GB:claim pattern="D+7" odds="12/36" -->\n'; } > "$t/e.md"
python3 "$G" --lint "$t/e.md" >/dev/null 2>&1 && ok "4-and-9-are-complements-24+12=36" || bad "complement" "no"

# --- a wrong claim must FAULT
{ head_ok; printf '<!-- GB:claim pattern="D" odds="7/36" -->\n'; } > "$t/w.md"
python3 "$G" --lint "$t/w.md" 2>&1 | grep -q 'is 6/36, the book says 7/36' && ok "wrong-odds-faults-with-the-truth" || bad "wrong odds" "no"
python3 "$G" --lint "$t/w.md" >/dev/null 2>&1; [ $? -eq 1 ] && ok "wrong-odds-exits-1" || bad "exit" "rc"

# --- an unknown atom is a fault, not a silent pass
{ head_ok; printf '<!-- GB:claim pattern="QQ" odds="1/36" -->\n'; } > "$t/u.md"
python3 "$G" --lint "$t/u.md" 2>&1 | grep -q 'unknown atom' && ok "unknown-atom-faults" || bad "unknown atom" "no"

# --- a sequence pattern is reported, never scored
{ head_ok; printf '<!-- GB:claim pattern="avd D&7" odds="1/36" -->\n'; } > "$t/s.md"
python3 "$G" --lint "$t/s.md" 2>&1 | grep -q 'spans two rolls' && ok "sequence-reported-not-scored" || bad "sequence" "no"

# --- square tables
{ head_ok; printf '<!-- GB:table id=t1 dice=2d6 kind=square -->\n'
  printf '|   | 1 | 2 | 3 | 4 | 5 | 6 |\n|---|---|---|---|---|---|---|\n'
  for r in 1 2 3 4 5 6; do printf '| %s | a | b | c | d | e | f |\n' $r; done; } > "$t/sq.md"
python3 "$G" --lint "$t/sq.md" >/dev/null 2>&1 && ok "6x6-declared-square-passes" || { bad "square" "rejected"; python3 "$G" --lint "$t/sq.md" | grep FAULT | sed 's/^/     /'; }
{ head_ok; printf '<!-- GB:table id=t2 dice=2d6 kind=square -->\n'
  printf '|   | 1 | 2 | 3 |\n|---|---|---|---|\n| 1 | a | b | c |\n| 2 | a | b | c |\n| 3 | a | b | c |\n'; } > "$t/nsq.md"
python3 "$G" --lint "$t/nsq.md" 2>&1 | grep -q 'declared square but is 3x3' && ok "non-square-declared-square-faults" || bad "non-square" "no"

# --- boxes must balance
{ head_ok; printf '<!-- GB:box kind=rule -->\nbody\n'; } > "$t/bx.md"
python3 "$G" --lint "$t/bx.md" 2>&1 | grep -q 'never closed' && ok "unclosed-box-faults" || bad "box" "no"

# --- the back-matter rule (the Paarfi turn), and the SET rule a cold reader had to find by hand:
# four authors who all make the same closing move are one author in masks.
printf '<!-- GB:book title="T" author="A" -->\n## s\nbody\n' > "$t/na.md"
python3 "$G" --lint "$t/na.md" 2>&1 | grep -q 'GB:backmatter' && ok "missing-back-matter-faults" || bad "back matter" "no"
printf '<!-- GB:book title="T" author="A" -->\n## s\nb\n<!-- GB:backmatter -->\n## end\n' > "$t/nk.md"
python3 "$G" --lint "$t/nk.md" 2>&1 | grep -q 'missing kind=' && ok "back-matter-without-a-kind-faults" || bad "kind" "no"
mk() { printf '<!-- GB:book title="%s" author="%s" -->\n## s\nb\nmore body to push the marker back past sixty percent of the file so the position warning does not fire here at all\n<!-- GB:backmatter kind="%s" -->\n## end\n' "$1" "$1" "$2" > "$t/$1.md"; }
mk one disclosure; mk two refusal; mk three dismissal; mk four reflection
python3 "$G" --voices "$t/one.md" "$t/two.md" "$t/three.md" "$t/four.md" >/dev/null 2>&1 && ok "four-distinct-kinds-pass" || { bad "voices" "rejected a good set"; python3 "$G" --voices "$t/one.md" "$t/two.md" "$t/three.md" "$t/four.md" | sed 's/^/     /'; }
mk five reflection
python3 "$G" --voices "$t/four.md" "$t/five.md" 2>&1 | grep -q 'one author in masks' && ok "repeated-kind-faults-across-the-set" || bad "voices repeat" "no"
python3 "$G" --voices "$t/four.md" "$t/five.md" >/dev/null 2>&1; [ $? -eq 1 ] && ok "voices-exits-1-on-repeat" || bad "voices exit" "rc"

# --- text rendering
{ head_ok; printf '\n<!-- GB:table id=t dice=2d6 kind=square -->\n|   | 1 | 2 | 3 | 4 | 5 | 6 |\n|---|---|---|---|---|---|---|\n'
  for r in 1 2 3 4 5 6; do printf '| %s | aa | bb | cc | dd | ee | ff |\n' $r; done
  printf '\n<!-- GB:box kind=rule -->\nA rule you must not lose.\n<!-- GB:endbox -->\n'; } > "$t/r.md"
python3 "$G" --txt "$t/r.md" > "$t/r.txt" 2>&1 && ok "txt-renders" || bad "txt" "rc"
grep -q '^+---' "$t/r.txt" && ok "txt-table-has-ascii-rules" || bad "txt table" "no border"
grep -q "^A section$" "$t/r.txt" && grep -q "^---------$" "$t/r.txt" && ok "txt-h2-is-underlined-title" || bad "txt h2" "$(head -5 "$t/r.txt")"
grep -q "RULE" "$t/r.txt" && ok "txt-box-carries-its-label" || bad "txt box" "no"
awk '{ if (length($0) > 76) { print "LONG:" length($0); exit 1 } }' "$t/r.txt" && ok "txt-respects-width-76" || bad "txt width" "a line ran past 76"
LC_ALL=C grep -q '[^[:print:][:space:]]' "$t/r.txt" && bad "txt-is-plain-ascii" "non-printable bytes" || ok "txt-is-plain-ascii-safe"
python3 "$G" --txt "$t/r.md" --width 60 | awk '{ if (length($0) > 60) { print "LONG"; exit 1 } }' && ok "txt-honours---width" || bad "width" "overflow at 60"

# --- other dice: the books also use 3d6 and d20, and the checker must police those too
{ head_ok; printf '<!-- GB:claim dice="3d6" pattern=">=12" odds="81/216" -->\n'; } > "$t/t1.md"
python3 "$G" --lint "$t/t1.md" >/dev/null 2>&1 && ok "3d6->=12-is-81-216" || { bad "3d6" "rejected"; python3 "$G" --lint "$t/t1.md" | grep FAULT | sed 's/^/     /'; }
{ head_ok; printf '<!-- GB:claim dice="3d6" pattern=">=9" odds="160/216" -->\n<!-- GB:claim dice="3d6" pattern=">=15" odds="20/216" -->\n<!-- GB:claim dice="3d6" pattern=">=18" odds="1/216" -->\n<!-- GB:claim dice="3d6" pattern=">=6" odds="206/216" -->\n'; } > "$t/t2.md"
python3 "$G" --lint "$t/t2.md" >/dev/null 2>&1 && ok "3d6-difficulty-ladder-agrees" || { bad "3d6 ladder" "a rung disagreed"; python3 "$G" --lint "$t/t2.md" | grep FAULT | sed 's/^/     /'; }
{ head_ok; printf '<!-- GB:claim dice="d20" pattern="=20" odds="1/20" -->\n<!-- GB:claim dice="d20" pattern=">12" odds="8/20" -->\n'; } > "$t/t3.md"
python3 "$G" --lint "$t/t3.md" >/dev/null 2>&1 && ok "d20-claims-agree" || bad "d20" "rejected"
{ head_ok; printf '<!-- GB:claim dice="3d6" pattern=">=12" odds="80/216" -->\n'; } > "$t/t4.md"
python3 "$G" --lint "$t/t4.md" 2>&1 | grep -q 'is 81/216, the book says 80/216' && ok "wrong-3d6-odds-faults" || bad "wrong 3d6" "no"
{ head_ok; printf '<!-- GB:claim dice="3d6" pattern=">=12" odds="81/36" -->\n'; } > "$t/t5.md"
python3 "$G" --lint "$t/t5.md" 2>&1 | grep -q 'divides by 36' && ok "wrong-denominator-faults" || bad "denominator" "no"
{ head_ok; printf '<!-- GB:claim dice="d7" pattern=">=3" odds="5/7" -->\n'; } > "$t/t6.md"
python3 "$G" --lint "$t/t6.md" >/dev/null 2>&1 && ok "an-odd-die-still-enumerates" || bad "d7" "rejected"

# --- a table too wide for the measure DEGRADES to a keyed list, and never truncates a cell
{ head_ok; printf '\n| k | a very long column header indeed here | another quite long header |\n|---|---|---|\n'
  printf '| 1 | a cell whose full text must survive the rendering no matter what | second cell text |\n'; } > "$t/wide.md"
python3 "$G" --txt "$t/wide.md" > "$t/wide.txt"
tr -s '[:space:]' ' ' < "$t/wide.txt" | grep -q 'a cell whose full text must survive the rendering no matter what' && ok "wide-table-never-truncates-a-cell" || { bad "wide table" "content lost"; sed -n '1,12p' "$t/wide.txt" | sed 's/^/     /'; }
grep -q '~' "$t/wide.txt" && bad "no-tilde-truncation-marker" "a cell was cut" || ok "no-tilde-truncation-marker"
awk '{ if (length($0) > 76) { exit 1 } }' "$t/wide.txt" && ok "degraded-table-still-fits-76" || bad "degraded width" "overflow"

# --- --ascii folds every non-ascii the books actually use
printf '<!-- GB:book title="T" author="A" -->\n## s\nem \342\200\224 en \342\200\223 arrow \342\206\222 dot \302\267 quote \342\200\234x\342\200\235 le \342\211\244\nAbout the Author\n' > "$t/uni.md"
python3 "$G" --txt "$t/uni.md" --ascii > "$t/uni.txt"
LC_ALL=C grep -q '[^ -~\t\f]' "$t/uni.txt" && bad "ascii-fold-is-complete" "non-ascii survived" || ok "ascii-fold-is-complete"
grep -q 'arrow ->' "$t/uni.txt" && ok "ascii-fold-maps-the-arrow" || bad "arrow" "no"
python3 "$G" --txt "$t/uni.md" | LC_ALL=C grep -q '[^ -~\t\f]' && ok "without---ascii-utf8-is-kept" || bad "utf8 kept" "folded without being asked"

# --- a paragraph broken across source lines renders as one paragraph
printf '<!-- GB:book title="T" author="A" -->\n## s\nThis sentence begins on one source line\nand continues on a second one.\n\nAbout the Author\n' > "$t/para.md"
python3 "$G" --txt "$t/para.md" | grep -q 'one source line and continues' && ok "paragraph-joins-across-source-lines" || bad "paragraph" "author line breaks leaked into the text"

# --- a fenced code block full of pipes is NOT a table (this crashed the renderer once)
{ head_ok; printf '\n```\n+--------+  +--------+\n|        |  |        |\n|        |  |        |\n+--------+  +--------+\n```\n'; } > "$t/fence.md"
python3 "$G" --txt "$t/fence.md" > "$t/fence.txt" 2>&1 && ok "fenced-pipe-art-does-not-crash" || { bad "fence" "crash"; tail -3 "$t/fence.txt" | sed 's/^/     /'; }
grep -q '^+--------+  +--------+' "$t/fence.txt" && ok "fenced-block-survives-verbatim" || bad "fence verbatim" "art was mangled"
python3 "$G" --stats "$t/fence.md" | grep -q '^tables       0' && ok "fenced-art-is-not-counted-as-a-table" || bad "fence count" "counted"

# --- flag routing: a from/to header that disagrees with its partner is a stale tab, and a book
# organised by tabs must not have one. (A cold reader caught this by hand once. Once is enough.)
{ head_ok; printf '\n## FLAG 4 \302\267 TABLE 4a \302\267 d6 \302\267 from 3 \302\267 to 5\n\n## FLAG 5 \302\267 TABLE 5a \302\267 d6 \302\267 from 4 \302\267 to 1\n\n## FLAG 3 \302\267 TABLE 3a \302\267 d6 \302\267 from 2 \302\267 to 4\n'; } > "$t/rt.md"
python3 "$G" --lint "$t/rt.md" 2>&1 | grep -q 'every from/to pair agrees' && ok "consistent-flag-routing-passes" || { bad "routing ok" "rejected"; python3 "$G" --lint "$t/rt.md" | grep -i rout | sed 's/^/     /'; }
{ head_ok; printf '\n## FLAG 4 \302\267 TABLE 4a \302\267 d6 \302\267 from 3 \302\267 to 5\n\n## FLAG 5 \302\267 TABLE 5a \302\267 d6 \302\267 from 9 \302\267 to 1\n'; } > "$t/rt2.md"
python3 "$G" --lint "$t/rt2.md" 2>&1 | grep -q 'flag 4 says it goes to 5, but flag 5 does not list 4' && ok "stale-routing-header-faults" || bad "routing stale" "no"
{ head_ok; printf '\n## FLAG 3 \302\267 TABLE 3b \302\267 d6 \302\267 from 3a \302\267 to 4\n\n## FLAG 4 \302\267 TABLE 4a \302\267 d6 \302\267 from 3 \302\267 to 1\n'; } > "$t/rt3.md"
python3 "$G" --lint "$t/rt3.md" 2>&1 | grep -q 'routing:' && bad "sub-table-self-reference-is-not-a-hop" "false positive on 'from 3a'" || ok "sub-table-self-reference-is-not-a-hop"

# --- stats
python3 "$G" --stats "$t/r.md" | grep -q '^tables       1' && ok "stats-counts-tables" || bad "stats" "no"

# --- kind=halved: a 6x6 printed as two 6x3 halves is still one table and must still cover 1-6.
#     Bought 2026-09-13: a human reader graded a book 1/5 for clarity on six-column grids, and the
#     repair was to halve them. Halving must not quietly drop the squareness guarantee.
halved_body() {
  printf '<!-- GB:table id=h1 dice=2d6 kind=halved -->\n\n'
  printf '|  | 1 | 2 | 3 |\n|---|---|---|---|\n'
  for r in 1 2 3 4 5 6; do printf '| **%s** | a | b | c |\n' "$r"; done
  printf '\n'
  printf '|  | %s | %s | %s |\n|---|---|---|---|\n' "$1" "$2" "$3"
  for r in 1 2 3 4 5 6; do printf '| **%s** | d | e | f |\n' "$r"; done
}
{ head_ok; halved_body 4 5 6; } > "$t/h-good.md"
python3 "$G" --lint "$t/h-good.md" 2>&1 | grep -q 'halved into two 6x3 that cover 1-6 exactly once' \
  && ok "halved-pair-that-covers-1-6-is-OK" || bad "halved good" "a correct halved pair was not recognised"

{ head_ok; halved_body 1 2 3; } > "$t/h-dup.md"
python3 "$G" --lint "$t/h-dup.md" 2>&1 | grep -q 'not 1-6 once each' \
  && ok "halved-halves-that-repeat-1-2-3-fault" || bad "halved dup" "repeated columns passed"

{ head_ok; printf '<!-- GB:table id=h2 dice=2d6 kind=halved -->\n\n|  | 1 | 2 | 3 |\n|---|---|---|---|\n| **1** | a | b | c |\n'; } > "$t/h-one.md"
python3 "$G" --lint "$t/h-one.md" 2>&1 | grep -qE 'only 1 table\(s\) follow|not two 6x3' \
  && ok "halved-with-a-missing-half-faults" || bad "halved lone" "a lone half passed"

# --- the width warning must name MARKDOWN, not only the plain-text degrade. The old wording read as
#     reassurance and is why four over-wide grids shipped.
{ head_ok; printf '<!-- GB:table id=w1 dice=2d6 kind=grid -->\n\n'
  printf '|  | 1 | 2 | 3 | 4 | 5 | 6 |\n|---|---|---|---|---|---|---|\n'
  printf '| **1** | %s | %s | %s | %s | %s | %s |\n' \
    "aaaaaaaaaaaaaaaaaaaaaaaa" "bbbbbbbbbbbbbbbbbbbbbbbb" "cccccccccccccccccccccccc" \
    "dddddddddddddddddddddddd" "eeeeeeeeeeeeeeeeeeeeeeee" "ffffffffffffffffffffffff"; } > "$t/wide.md"
python3 "$G" --lint "$t/wide.md" 2>&1 | grep -q 'MARKDOWN DOES NOT' \
  && ok "width-warning-names-the-format-that-breaks" || bad "width wording" "warning still only mentions plain text"

# --- --render sees UNMARKED tables too (the lint's warning never did) and reports runs.
{ head_ok; for n in 1 2 3; do
    printf '\n## S%s\n\n|  | 1 | 2 | 3 | 4 | 5 | 6 |\n|---|---|---|---|---|---|---|\n' "$n"
    printf '| **1** | %s | %s | %s | %s | %s | %s |\n' \
      "aaaaaaaaaaaaaaaaaaaaaa" "bbbbbbbbbbbbbbbbbbbbbb" "cccccccccccccccccccccc" \
      "dddddddddddddddddddddd" "eeeeeeeeeeeeeeeeeeeeee" "ffffffffffffffffffffff"
  done; } > "$t/run.md"
python3 "$G" --render "$t/run.md" 2>&1 | grep -q '3 table(s), 3 over 100 chars' \
  && ok "render-counts-unmarked-tables" || bad "render count" "unmarked wide tables were not counted"
python3 "$G" --render "$t/run.md" 2>&1 | grep -q 'RUN: 3 wide tables across 3 sections' \
  && ok "render-names-a-run-of-wide-tables" || bad "render run" "no run reported"
# two halves of ONE grid live under one heading and are one lookup: not a run.
{ head_ok; printf '\n## One lookup\n\n'
  for h in 1 2; do printf '|  | 1 | 2 | 3 |\n|---|---|---|---|\n'
    printf '| **1** | %s | %s | %s |\n\n' "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" \
      "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb" "cccccccccccccccccccccccccccccccccc"; done; } > "$t/halves.md"
python3 "$G" --render "$t/halves.md" 2>&1 | grep -q 'RUN:' \
  && bad "render halves" "two halves of one grid under one heading were called a run" \
  || ok "render-does-not-call-two-halves-a-run"
python3 "$G" --render "$t/run.md" 2>&1 | grep -qE 'FAULT|exit' && bad "render verdict" "render passed a verdict; it must only count" \
  || ok "render-passes-no-verdict"

# --- --thread: a named person in two sections or fewer is POCKETED. This is the countable form of
#     "narrative vibe feels broken throughout" (Bridget, 2026-09-13, on a book whose only character
#     first appeared at line 430 of 552).
{ head_ok; printf '\n## One\n\nGwen walked in. Gwen sat down.\n\n## Two\n\nNothing here.\n\n## Three\n\nNothing here either.\n'; } > "$t/pocket.md"
python3 "$G" --thread "$t/pocket.md" 2>&1 | grep -q 'Gwen.*POCKETED' \
  && ok "thread-flags-a-pocketed-name" || bad "thread pocket" "did not flag"
{ head_ok; printf '\n## One\n\nGwen walked in.\n\n## Two\n\nGwen paid.\n\n## Three\n\nGwen left.\n'; } > "$t/spread.md"
python3 "$G" --thread "$t/spread.md" 2>&1 | grep -q 'Gwen' && \
  ! python3 "$G" --thread "$t/spread.md" 2>&1 | grep -q 'Gwen.*POCKETED' \
  && ok "thread-does-not-flag-a-name-carried-through" || bad "thread spread" "false positive on a threaded name"
# a bolded game term is vocabulary, not a person
{ head_ok; printf '\n## One\n\nThe **Ground** is set. Ground matters. Ground again.\n'; } > "$t/term.md"
python3 "$G" --thread "$t/term.md" 2>&1 | grep 'mentions  first line' | grep -q 'Ground' \
  && bad "thread term" "a bolded game term was reported as a person" || ok "thread-ignores-a-bolded-game-term"
# ...and it must SAY it set the term aside, rather than silently dropping it
python3 "$G" --thread "$t/term.md" 2>&1 | grep -q 'set aside as book vocabulary.*Ground' \
  && ok "thread-shows-what-it-filtered" || bad "thread filtered" "the filter hid its own work"

# --- flags may sit on either side of the path. "--txt --ascii BOOK.md" used to die with
#     FileNotFoundError: '--ascii', which reads as a missing book; a shell redirect had already
#     truncated four rendered files by the time the traceback printed.
{ head_ok; printf '\nSome prose.\n'; } > "$t/flagorder.md"
a=$(python3 "$G" --txt "$t/flagorder.md" --ascii 2>/dev/null | md5sum)
b=$(python3 "$G" --txt --ascii "$t/flagorder.md" 2>/dev/null | md5sum)
[ -n "$a" ] && [ "$a" = "$b" ] && ok "txt-flags-work-before-or-after-the-path" || bad "flag order" "flag before path still fails"
python3 "$G" --txt --ascii 2>&1 | grep -q 'no book named' && ok "no-book-named-says-so" || bad "no path" "unhelpful error"

# --- the tool's own prove-red
python3 "$G" --prove-red | grep -q '^PASS' && ok "self-prove-red" || bad "self-prove-red" "no"

if [ "${1:-}" = "--prove-red" ]; then
  before=$fail
  python3 "$G" --lint "$t/b.md" 2>&1 | grep -q 'IMPOSSIBLE STRING' && ok "PLANTED" || bad "PLANTED-wrong-expectation" "planted"
  rm -rf "$t"
  [ "$fail" -eq $((before+1)) ] && { echo "PASS: harness correctly went red under a planted bad expectation"; exit 0; }
  echo "FAIL: harness did not go red"; exit 1
fi
rm -rf "$t"; echo "TOTAL pass=$pass fail=$fail"; [ "$fail" -eq 0 ]
