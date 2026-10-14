#!/bin/sh
# ms1dg-tests.sh — fixtures + expected verdicts for bin/ms1dg (memory-store gauge).
# usage: sh tests/ms1dg-tests.sh             (run from the AS4CE0001 root)
#        sh tests/ms1dg-tests.sh --prove-red (plant a wrong expectation; harness must go red)
# Copyright 2026 Corwin Brust <corwin@bru.st> — GPLv3-or-later. Authored by Fable 2026-09-05.
#
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
set -u
here=$(cd "$(dirname "$0")/.." && pwd); M="$here/bin/ms1dg"
t=${TMPDIR:-/tmp}/ms1dg-tests.$$; mkdir -p "$t"; pass=0; fail=0
expect() { # expect NAME EXIT-CODE GREP-PATTERN args...
  name=$1; want=$2; pat=$3; shift 3
  out=$(sh "$M" "$@" 2>&1); code=$?
  if [ "$code" -eq "$want" ] && printf '%s\n' "$out" | grep -q -- "$pat"; then pass=$((pass+1)); echo "ok   $name"
  else fail=$((fail+1)); echo "FAIL $name (exit=$code want $want; pattern '$pat')"; printf '%s\n' "$out" | sed 's/^/     /'; fi
}
note() { printf -- '---\nname: %s\ndescription: d\nmetadata:\n  type: user\n---\nbody of %s\n' "$1" "$1" > "$2/$1.md"; }
seat() { rm -rf "$t/$1"; mkdir -p "$t/$1"; note alpha "$t/$1"; note beta "$t/$1"
         printf '# MEMORY\n- [alpha](alpha.md) — a\n- [beta](beta.md) — b\n' > "$t/$1/MEMORY.md"; }

seat good;                                                        expect clean-seat-exit-0 0 'FAULT 0' --seat "$t/good"
seat good2;                                                       expect clean-seat-every-note-indexed 0 'every note on disk has an index line' --seat "$t/good2"
seat dangle;  printf -- '- [ghost](ghost.md) — x\n' >> "$t/dangle/MEMORY.md";  expect dangling-index-line-faults 1 'FAULT \] *G3 *1 index line' --seat "$t/dangle"
seat strand;  note gamma "$t/strand";                             expect unindexed-note-warns 0 'STRANDED-IN-SEAT.*gamma.md' --seat "$t/strand"
seat big;     awk 'BEGIN{for(i=0;i<201;i++)print "- [alpha](alpha.md) — pad"}' >> "$t/big/MEMORY.md"; expect index-over-200-lines-faults 1 'EXCEEDS the 200-line' --seat "$t/big"

# --- the index SET (added 2026-09-13): a store may carry continuation pages beside MEMORY.md.
# Before this, the single-index assumption reported every page-2 note as STRANDED and every
# page-2 line as an A-vs-seat desync -- 162 lines of hand-work the keeper did not owe.
seat set1;    note gamma "$t/set1"; note delta "$t/set1"
              printf '# page 2\n- [gamma](gamma.md) — g\n- [delta](delta.md) — d\n' > "$t/set1/memory-index-page2.md"
              printf -- '- [page 2](memory-index-page2.md) — the rest\n' >> "$t/set1/MEMORY.md"
              expect continuation-page-covers-notes 0 'every note on disk has an index line' --seat "$t/set1"
seat set2;    note gamma "$t/set2"
              printf '# page 2\n- [gamma](gamma.md) — g\n' > "$t/set2/memory-index-page2.md"
              expect continuation-page-unlinked-faults 1 'G2b.*never links' --seat "$t/set2"
seat set3;    printf -- '- [page 2](memory-index-page2.md) — the rest\n' >> "$t/set3/MEMORY.md"
              printf '# page 2\n- [MEMORY.md](MEMORY.md) — home\n' > "$t/set3/memory-index-page2.md"
              expect page-linking-home-is-not-dangling 0 '0 dangling index lines' --seat "$t/set3"
seat set4;    mkdir -p "$t/set4a"; note gamma "$t/set4"; note gamma "$t/set4a"
              printf '# page 2\n- [gamma](gamma.md) — g\n' > "$t/set4/memory-index-page2.md"
              printf -- '- [page 2](memory-index-page2.md) — the rest\n' >> "$t/set4/MEMORY.md"
              printf '# MEMORY\n- [alpha](alpha.md) — a\n- [beta](beta.md) — b\n- [gamma](gamma.md) — g\n' > "$t/set4a/MEMORY.md"
              note alpha "$t/set4a"; note beta "$t/set4a"
              expect A-desync-counts-every-seat-page 0 'A.s index set has no line the seat index set lacks' --seat "$t/set4" --auto "$t/set4a"
seat asc;     printf 'sig\n' > "$t/asc/alpha.md.asc";             expect asc-is-furniture-not-stray 0 'no stray files' --seat "$t/asc"
seat stray;   printf '' > "$t/stray/.probe-1";                    expect probe-is-stray 0 'non-note files in the seat: .probe-1' --seat "$t/stray"
seat nofm;    printf 'no frontmatter\n' > "$t/nofm/delta.md"; printf -- '- [delta](delta.md) — d\n' >> "$t/nofm/MEMORY.md"; expect frontmatter-missing-warns 0 '1 note(s) without frontmatter' --seat "$t/nofm"
seat nonl;    printf -- '---\nname: e\n---\nno newline' > "$t/nonl/eps.md"; printf -- '- [eps](eps.md) — e\n' >> "$t/nonl/MEMORY.md"; expect trailing-newline-warns 0 '1 note(s) lack a trailing newline' --seat "$t/nonl"
seat wl;      printf 'see [[nowhere]]\n' >> "$t/wl/alpha.md";     expect dangling-wikilink-warns 0 'wikilink target(s) with no note yet (marks worth writing, not errors): nowhere' --seat "$t/wl"
seat noa;                                                         expect a-not-given-is-notvisible 0 'NOTVISIBLE \] *G8' --seat "$t/noa"
# store A staged: index diff + ORPHAN / SAME-NAME-DIFF / TRACED, then --heal --dry, --heal, idempotence
seat b; rm -rf "$t/a"; mkdir "$t/a"; cp "$t/b/alpha.md" "$t/a/alpha.md"; note zeta "$t/a"
printf -- '---\nname: beta\n---\nDIFFERENT beta\n' > "$t/a/beta.md"
printf '# MEMORY\n- [alpha](alpha.md) — a\n- [beta](beta.md) — b\n- [zeta](zeta.md) — z\n' > "$t/a/MEMORY.md"
expect a-index-desync-counted 0 'index desync: 1 line(s).*zeta.md' --seat "$t/b" --auto "$t/a"
expect a-manifest-classes 0 'TRACED 1 · ORPHAN 1 · SAME-NAME-DIFF 1' --seat "$t/b" --auto "$t/a"
expect heal-dry-prints-only 0 'would   cp .*zeta.md' --seat "$t/b" --auto "$t/a" --heal --dry
[ -e "$t/b/zeta.md" ] && { fail=$((fail+1)); echo "FAIL heal-dry-wrote-a-file"; } || { pass=$((pass+1)); echo "ok   heal-dry-wrote-nothing"; }
expect heal-copies-and-verifies 0 'copied, verified .*zeta.md' --seat "$t/b" --auto "$t/a" --heal
[ -e "$t/b/zeta.md" ] && ls "$t/b"/beta.auto-*.md >/dev/null 2>&1 && { pass=$((pass+1)); echo "ok   heal-orphan-seated-and-diff-preserved-beside"; } || { fail=$((fail+1)); echo "FAIL heal-files"; }
expect heal-never-touches-index 0 '2 note(s) on disk named by no page of the index set' --seat "$t/b" --auto "$t/a"
expect heal-idempotent 0 'TRACED 3 · ORPHAN 0 · SAME-NAME-DIFF 0' --seat "$t/b" --auto "$t/a"
seat il;      note gamma "$t/il";                                 expect index-lines-paste-ready 0 '^- \[gamma\](gamma.md) — d$' --seat "$t/il" --index-lines
expect index-lines-never-writes 0 'STRANDED-IN-SEAT.*gamma.md' --seat "$t/il"
seat fence;                                                       expect fence-gauge-present 0 'G4b' --seat "$t/fence"
seat man;                                                         expect manifest-is-a-receipt 0 'manifest written: .*(3 rows) -- a receipt, never signed' --seat "$t/man" --manifest "$t/man.tsv"
[ "$(wc -l < "$t/man.tsv")" = 4 ] && grep -q "^sha256	bytes	name" "$t/man.tsv" && { pass=$((pass+1)); echo "ok   manifest-rows-and-header"; } || { fail=$((fail+1)); echo "FAIL manifest-rows-and-header"; }
seat c0;   printf "no frontmatter\n" > "$t/c0/z.md"; printf -- "- [z](z.md) — z\n" >> "$t/c0/MEMORY.md"; expect ceremony-0-skips-words 0 'ceremony 1 (HASH): frontmatter and wikilinks not judged' --seat "$t/c0" --ceremony 1
expect ceremony-2-judges-words 0 '1 note(s) without frontmatter' --seat "$t/c0" --ceremony 2
seat c2; mkdir -p "$t/c2/../mainmem" 2>/dev/null; expect ceremony-4-writes-manifest 0 'G9 *manifest written' --seat "$t/c2" --ceremony 4
seat c3;   expect ceremony-9-signatures-word 0 'G10' --seat "$t/c3" --ceremony 9
expect ceremony-17-wants-a-gate 0 'G11 *ceremony 17' --seat "$t/c3" --ceremony 17
expect ceremony-off-ladder-warns 0 'not on the ladder 1 2 4 9 17' --seat "$t/c3" --ceremony 3
expect auto-none-is-notvisible 0 'NOTVISIBLE \] *G8' --seat "$t/good" --auto none
expect usage-exit-2 2 'seat DIR required'
expect self-prove-red 0 'red as expected' --prove-red

if [ "${1:-}" = "--prove-red" ]; then
  echo "== prove-red: planting a wrong expectation (clean seat must FAULT) =="
  before=$fail; expect PLANTED-wrong-expectation 1 'FAULT 0' --seat "$t/good"
  rm -rf "$t"
  if [ "$fail" -eq $((before+1)) ]; then echo "PASS: harness correctly went red under a planted bad expectation"; exit 0; else echo "FAIL: harness did not go red"; exit 1; fi
fi
rm -rf "$t"
echo "TOTAL pass=$pass fail=$fail"; [ "$fail" -eq 0 ]
