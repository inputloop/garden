#!/bin/sh
# se1sn-tests.sh — fixtures + expected verdicts for bin/se1sn (the mechanical open).
# usage: sh tests/se1sn-tests.sh             (run from the AS4CE0001 root)
#        sh tests/se1sn-tests.sh --prove-red (plant a wrong expectation; harness must go red)
# Copyright 2026 Corwin Brust <corwin@bru.st> — GPLv3-or-later. Authored by Fable 2026-09-06.
#
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
set -u
here=$(cd "$(dirname "$0")/.." && pwd); S="$here/bin/se1sn"
t=${TMPDIR:-/tmp}/se1sn-tests.$$; mkdir -p "$t"; pass=0; fail=0
expect() { # expect NAME EXIT-CODE GREP-PATTERN args...
  name=$1; want=$2; pat=$3; shift 3
  out=$(sh "$S" "$@" 2>&1); code=$?
  if [ "$code" -eq "$want" ] && printf '%s\n' "$out" | grep -q -- "$pat"; then pass=$((pass+1)); echo "ok   $name"
  else fail=$((fail+1)); echo "FAIL $name (exit=$code want $want; pattern '$pat')"; printf '%s\n' "$out" | sed 's/^/     /' | head -12; fi
}
note() { printf -- '---\nname: %s\ndescription: d\nmetadata:\n  type: user\n---\nbody of %s\n' "$1" "$1" > "$2/$1.md"; }
proj() { rm -rf "$t/$1"; mkdir -p "$t/$1/memory"; note alpha "$t/$1/memory"; note beta "$t/$1/memory"
         printf '# MEMORY\n- [alpha](alpha.md) — a\n- [beta](beta.md) — b\n' > "$t/$1/memory/MEMORY.md"; }

# cold project: opens, writes one note, sections present, memory/ untouched
proj cold; before=$(cat "$t/cold/memory/"*.md | sha256sum)
expect cold-project-opens-exit-0 0 'note: .*mainmem/OPEN-' --root "$t/cold" --auto none
[ "$(ls "$t/cold/mainmem"/OPEN-*.md | wc -l)" -ge 1 ] && { pass=$((pass+1)); echo "ok   cold-one-note-written"; } || { fail=$((fail+1)); echo "FAIL cold-one-note-written"; }
f=$(ls "$t/cold/mainmem"/OPEN-*.md | tail -1)
for sec in '^## loaded vs seat' '^## gauge' '^## cards' '^## seat index head' '^## gauge report' 'local by construction'; do
  grep -q "$sec" "$f" && { pass=$((pass+1)); echo "ok   note-has-section $sec"; } || { fail=$((fail+1)); echo "FAIL note-has-section $sec"; }
done
after=$(cat "$t/cold/memory/"*.md | sha256sum)
[ "$before" = "$after" ] && { pass=$((pass+1)); echo "ok   fence-safe-memory-untouched"; } || { fail=$((fail+1)); echo "FAIL fence-safe-memory-untouched"; }
expect seat-index-count 0 'seat: .*index lines: 2$' --root "$t/cold" --auto none
expect notvisible-when-auto-none 0 'loaded: NOTVISIBLE' --root "$t/cold" --auto none
expect bad-auto-dir-is-usage 2 'is not a directory' --root "$t/cold" --auto /nonexistent-please
# NOSEAT: no memory/ → 3, nothing created
rm -rf "$t/noseat"; mkdir -p "$t/noseat"; printf 'x\n' > "$t/noseat/README.md"
expect noseat-refuses 3 'NOSEAT -- no memory/' --root "$t/noseat" --auto none
[ ! -d "$t/noseat/mainmem" ] && { pass=$((pass+1)); echo "ok   noseat-creates-nothing"; } || { fail=$((fail+1)); echo "FAIL noseat-creates-nothing"; }
# GATED: policy: none
proj gated; printf 'policy: none\n' > "$t/gated/memory/.gate"
expect gated-refuses 3 'GATED' --root "$t/gated" --auto none
# NOWRITE: unwritable root (skip if running as root, where chmod does not bind)
proj nowrite; chmod a-w "$t/nowrite"
if [ "$(id -u)" != 0 ]; then expect nowrite-refuses 4 'NOWRITE' --root "$t/nowrite" --auto none; else echo "skip nowrite (root)"; fi
chmod u+w "$t/nowrite"
# non-contagion: opening A writes nothing under B
proj pa; proj pb; sh "$S" --root "$t/pa" --auto none >/dev/null 2>&1
[ ! -d "$t/pb/mainmem" ] && [ "$(ls "$t/pb/memory" | wc -l)" = 3 ] && { pass=$((pass+1)); echo "ok   non-contagion-b-untouched"; } || { fail=$((fail+1)); echo "FAIL non-contagion"; }
# --auto with a staged A: desync count appears
proj wa; mkdir -p "$t/a"; note gamma "$t/a"; printf '# MEMORY\n- [alpha](alpha.md) — a\n- [gamma](gamma.md) — g\n' > "$t/a/MEMORY.md"
expect auto-desync-counted 0 'lacks (ms1dg G8): 1$' --root "$t/wa" --auto "$t/a"
expect auto-index-lines 0 'loaded: .*index lines: 2$' --root "$t/wa" --auto "$t/a"
# --head, --format tsv, --quiet, usage
expect head-5 0 'seat index head (5 lines of' --root "$t/cold" --head 5 --auto none
expect tsv-format 0 '^desync	' --root "$t/cold" --format tsv --auto none
expect tsv-gauge-rows 0 '^gauge:G1	OK' --root "$t/cold" --format tsv --auto none
expect quiet-one-line 0 '^se1sn: OPENED loaded=' --root "$t/cold" --quiet --auto none
expect usage-bad-format 2 'format words|tsv' --root "$t/cold" --format xml --auto none
expect usage-bad-root 2 'root not a directory' --root "$t/does-not-exist"
# a FAULT in the seat (dangling index line) → OPENED-WITH-FAULT exit 1
proj fault; printf -- '- [ghost](ghost.md) — x\n' >> "$t/fault/memory/MEMORY.md"
expect fault-exit-1 1 'FAULT 1' --root "$t/fault" --auto none

if [ "${1:-}" = "--prove-red" ]; then
  echo "== prove-red: planting a wrong expectation (cold project must refuse) =="
  before=$fail; expect PLANTED-wrong-expectation 3 'NOSEAT' --root "$t/cold"
  rm -rf "$t"
  if [ "$fail" -eq $((before+1)) ]; then echo "PASS: harness correctly went red under a planted bad expectation"; exit 0; else echo "FAIL: harness did not go red"; exit 1; fi
fi
rm -rf "$t"
echo "TOTAL pass=$pass fail=$fail"; [ "$fail" -eq 0 ]
