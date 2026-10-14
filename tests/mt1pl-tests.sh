#!/bin/sh
# mt1pl-tests.sh — fixtures + expected verdicts for bin/mt1pl (the persona link resolver).
# usage: sh tests/mt1pl-tests.sh | --prove-red        (run from the AS4CE0001 root)
# Copyright 2026 Corwin Brust <corwin@bru.st> — GPLv3-or-later. Authored by Mentat (for Corwin).
#
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
set -u
here=$(cd "$(dirname "$0")/.." && pwd); M="$here/bin/mt1pl"
t=${TMPDIR:-/tmp}/mt1pl-tests.$$; mkdir -p "$t"; pass=0; fail=0
expect() { name=$1; want=$2; pat=$3; shift 3
  out=$(env -u MENTAT_PERSONA sh "$M" "$@" 2>&1); code=$?
  if [ "$code" -eq "$want" ] && printf '%s\n' "$out" | grep -q -- "$pat"; then pass=$((pass+1)); echo "ok   $name"
  else fail=$((fail+1)); echo "FAIL $name (exit=$code want $want; pattern '$pat')"; printf '%s\n' "$out" | sed 's/^/     /'; fi
}
sheet() { # sheet DIR FILE NAME [extra lines...]
  d=$1; f=$2; n=$3; shift 3; mkdir -p "$d/$(dirname "$f")"
  { printf -- '---\nname: %s\nprincipal: Corwin\nactor: person\n' "$n"
    for l in "$@"; do printf '%s\n' "$l"; done
    printf -- '---\n# %s\n\n## Founding journal entry\nHow this persona happened.\n' "$n"; } > "$d/$f"
}

# --- source 6: nothing declared -> Mentat, and that is not a failure
mkdir -p "$t/bare"
expect no-declaration-is-not-a-failure 0 'VOICE  Mentat' --root "$t/bare"
expect no-declaration-still-gives-a-byline 0 'Author: Mentat (for Corwin)' --root "$t/bare"

# --- source 3: the exact-name file
sheet "$t/exact" PERSONA.md "Paarfi of Roundwood"
expect exact-name-file-resolves 0 'LINK   exact-name file' --root "$t/exact"
expect byline-is-name-for-principal 0 'BYLINE Author: Paarfi of Roundwood (for Corwin)' --root "$t/exact"

# --- source 2: the shop door beats the exact-name file
sheet "$t/door" sheets/other.md "The Door Persona"
sheet "$t/door" PERSONA.md "The Exact Persona"
printf '# door\nPersona: sheets/other.md\n' > "$t/door/CLAUDE.md"
expect door-outranks-exact-name 0 'LINK   door .*CLAUDE.md -> .*sheets/other.md' --root "$t/door"
expect door-sheet-name-is-used 0 'NAME   The Door Persona' --root "$t/door"

# --- source 4: the pointer file
sheet "$t/ptr" sheets/p.md "Pointed At"
printf 'sheets/p.md\n' > "$t/ptr/.persona"
expect pointer-file-resolves 0 'LINK   pointer .*\.persona' --root "$t/ptr"

# --- source 5: store level
sheet "$t/store" sheets/s.md "Store Persona"
mkdir -p "$t/store/memory"; printf -- '---\npersona: sheets/s.md\n---\n# MEMORY\n' > "$t/store/memory/MEMORY.md"
expect store-level-resolves 0 'LINK   store .*memory/MEMORY.md' --root "$t/store"

# --- source 1: the session beats every file
sheet "$t/envr" PERSONA.md "File Wins Not"
sheet "$t/envr" sheets/env.md "Session Persona"
out=$(MENTAT_PERSONA="$t/envr/sheets/env.md" sh "$M" --root "$t/envr" 2>&1)
if printf '%s' "$out" | grep -q 'LINK   env MENTAT_PERSONA'; then pass=$((pass+1)); echo "ok   session-outranks-every-file"
else fail=$((fail+1)); echo "FAIL session-outranks-every-file"; printf '%s\n' "$out" | sed 's/^/     /'; fi

# --- the refusal: a declaration pointing at nothing FAULTs and writes nothing
mkdir -p "$t/ghost"; printf 'Persona: ghost.md\n' > "$t/ghost/CLAUDE.md"
expect ghost-declaration-faults 1 'FAULT.*not on disk' --root "$t/ghost"
expect ghost-declaration-refuses-to-write 1 'will not write one' --root "$t/ghost"
env -u MENTAT_PERSONA sh "$M" --root "$t/ghost" >/dev/null 2>&1
if [ -f "$t/ghost/ghost.md" ]; then fail=$((fail+1)); echo "FAIL never-mints (it created the sheet!)"
else pass=$((pass+1)); echo "ok   never-mints-a-sheet"; fi

# --- the labour split, only when the sheet says what the principal owns
sheet "$t/split" PERSONA.md "Formalizer" "owns: rules"
expect split-line-when-owns-declared 0 'SPLIT  Corwin (rules), transcribed & formalized by Formalizer' --root "$t/split"
sheet "$t/nosplit" PERSONA.md "Solo"
expect no-split-line-when-not-declared 0 'RIGHTS copyright vests in Corwin' --root "$t/nosplit"

# --- rights never vest in the persona
expect rights-vest-in-the-principal 0 'never the rights-holder' --root "$t/exact"

# --- the wired interlock (2026-09-12 governance lift)
sheet "$t/wired" PERSONA.md "Watcher" "wired: yes"
expect wired-without-contract-faults 1 'wired: yes with no watcher-contract' --root "$t/wired"
sheet "$t/wired2" PERSONA.md "Watcher" "wired: yes" "watcher-contract: contract.md"
printf 'the contract\n' > "$t/wired2/contract.md"
expect wired-with-contract-turns-weathering-off 0 'weathering is OFF' --root "$t/wired2"
expect unwired-sheet-keeps-weathering 0 'WIRED  no' --root "$t/exact"

# --- the founding journal entry is reported, never drafted
mkdir -p "$t/nofound"; printf -- '---\nname: Unfounded\nprincipal: Corwin\n---\n# Unfounded\n' > "$t/nofound/PERSONA.md"
expect missing-founding-entry-is-a-card 0 'CARD   sheet has no founding journal entry' --root "$t/nofound"
expect founding-entry-detected 0 'FOUND  founding journal entry present' --root "$t/exact"

# --- --byline is paste-ready and alone
b=$(env -u MENTAT_PERSONA sh "$M" --root "$t/exact" --byline 2>&1)
if [ "$b" = "Author: Paarfi of Roundwood (for Corwin)" ]; then pass=$((pass+1)); echo "ok   byline-is-one-paste-ready-line"
else fail=$((fail+1)); echo "FAIL byline-is-one-paste-ready-line (got: $b)"; fi

# --- --explain names every source it tried
expect explain-traces-each-source 0 'tried \$MENTAT_PERSONA' --root "$t/bare" --explain

# --- the tool's own prove-red
if sh "$M" --root "$t/exact" --prove-red 2>&1 | grep -q '^PASS'; then pass=$((pass+1)); echo "ok   self-prove-red"
else fail=$((fail+1)); echo "FAIL self-prove-red"; fi

if [ "${1:-}" = "--prove-red" ]; then
  before=$fail
  expect PLANTED 0 'LINK   none' --root "$t/exact"
  rm -rf "$t"
  [ "$fail" -eq $((before+1)) ] && { echo "PASS: harness correctly went red under a planted bad expectation"; exit 0; }
  echo "FAIL: harness did not go red"; exit 1
fi
rm -rf "$t"; echo "TOTAL pass=$pass fail=$fail"; [ "$fail" -eq 0 ]
