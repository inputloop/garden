#!/bin/sh
# st1dt-tests.sh [--prove-red] -- tests for bin/st1dt (the seating detector), SPEC ST1-ST6 in
# tests/lane-d-SPEC.txt, on a fixture tree built in scratch. With --prove-red each guard is planted
# out in a scratch copy and the test that watches it must go red.
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
set -u
T=$(cd "$(dirname "$0")" && pwd -P); G=$(dirname "$T")
W=$(mktemp -d "${TMPDIR:-/tmp}/st1dt-t.XXXXXX"); trap 'chmod -R u+rwx "$W" 2>/dev/null; rm -rf "$W"' EXIT INT TERM

suite() { # $1 = the st1dt to test
  ST=$1; X=$W/run.$(date +%s%N); nf=0
  ok() { printf '  PASS  %s\n' "$1"; }
  no() { printf '  FAIL  %s\n' "$1"; nf=$((nf+1)); }
  R=$X/root; mkdir -p "$R/proj/sub/deeper" "$R/bare/.keys" "$R/bare/Z" "$R/bare/.patternwalk" "$R/declined"
  printf -- '-----BEGIN PGP SIGNED MESSAGE-----\nHash: SHA512\n\npolicy: read-only\nreason: fixture\n' > "$R/proj/.gate"
  printf 'x\n' > "$R/proj/sub/deeper/notes.txt"
  printf 'KEY-MARKER\n' > "$R/bare/.keys/x"; printf 'SECRET-MARKER\n' > "$R/bare/a.secret"
  printf 'Z-MARKER\n' > "$R/bare/Z/note"; printf 'TAPE-MARKER\n' > "$R/bare/.patternwalk/t.log"
  printf 'paid\n' > "$R/bare/invoice-2026-10.pdf"; printf 'hello\n' > "$R/bare/README.md"; : > "$R/bare/model.md"
  : > "$R/declined/x.txt"
  h=$(printf '%s' declined | sha256sum | cut -c1-12)
  printf 'ts\tkey\tvalue\tby\twhy\tturn\tconsent\n2026-10-09T10:00:00Z\tskill.seatkeeper.%s\tno: declined\tcorwin\the said no\tcorwin\t\n' "$h" > "$X/prefs.tsv"
  : > "$X/empty-prefs.tsv"

  out=$(sh "$ST" --root "$R" --prefs "$X/empty-prefs.tsv" "$R/proj/sub/deeper" 2>&1)
  if printf '%s\n' "$out" | grep -q 'A .gate governs it: the nearest one is in proj (policy: read-only)'; then ok "ST1 a .gate two levels up is found and named"
  else no "ST1 a .gate two levels up is found and named"; fi

  find "$R" -exec ls -ld --time-style=full-iso {} + | sort > "$X/before"
  out=$(sh "$ST" --root "$R" --prefs "$X/empty-prefs.tsv" --trace "$R/bare" 2>"$X/trace")
  outn=$(sh "$ST" --root "$R" --prefs "$X/empty-prefs.tsv" --names "$R/bare" 2>/dev/null)
  if ! printf '%s\n%s\n' "$out" "$outn" | grep -q '\.keys\|a\.secret\|Z/\|Z/note\|\.patternwalk\|t\.log\|MARKER' \
     && ! grep -q '/\.keys\|a\.secret\|/Z\b\|/Z/\|\.patternwalk' "$X/trace" \
     && printf '%s\n' "$out" | grep -q '^- 5 kept out of view' \
     && ! printf '%s\n' "$out" | grep -q invoice-2026 && printf '%s\n' "$outn" | grep -q 'invoice names: invoice-2026-10.pdf'
  then ok "ST2 .keys/x, a.secret, Z/note, .patternwalk/t.log are never named or touched; a count only (invoices named on ask)"
  else no "ST2 .keys/x, a.secret, Z/note, .patternwalk/t.log are never named or touched; a count only (invoices named on ask)"; fi
  find "$R" -exec ls -ld --time-style=full-iso {} + | sort > "$X/after"
  if cmp -s "$X/before" "$X/after"; then ok "ST3 st1dt writes nothing (the listing, sizes and times are the same)"
  else no "ST3 st1dt writes nothing (the listing, sizes and times are the same)"; fi
  q=$(printf '%s\n' "$out" | grep -c '^Question:'); g=$(printf '%s\n' "$out" | grep -c 'Proposed grain:')
  if [ "$q" -eq 1 ] && [ "$g" -eq 1 ] && printf '%s\n' "$out" | grep -q 'Proposed grain: full, because it carries project markers (model.md)'
  then ok "ST4 exactly one grain is proposed and exactly one question asked"
  else no "ST4 exactly one grain is proposed and exactly one question asked ($g grains, $q questions)"; fi
  out=$(sh "$ST" --root "$R" --prefs "$X/prefs.tsv" "$R/declined" 2>&1)
  if printf '%s\n' "$out" | grep -q 'You said no to seating declined on 2026-10-09T10:00:00Z; I am not asking again' \
     && ! printf '%s\n' "$out" | grep -q '^Question:'
  then ok "ST5 a remembered no is honoured: said, and nothing asked"
  else no "ST5 a remembered no is honoured: said, and nothing asked"; fi
  if printf '%s\n' "$out" | tail -n 1 | grep -q '^What the model was shown:'; then ok "ST6 it ends with a words read-back of what the model was shown"
  else no "ST6 it ends with a words read-back of what the model was shown"; fi
  return $nf
}

if [ "${1:-}" = --prove-red ]; then
  echo "st1dt prove-red: planting each guard out; the named test must go red"
  miss=0
  try() { # name test-id sed
    sed "$3" "$G/bin/st1dt" > "$W/st.$1"
    if cmp -s "$G/bin/st1dt" "$W/st.$1"; then echo "  MISS  $1: the plant did not change the file"; miss=$((miss+1)); return; fi
    suite "$W/st.$1" > "$W/out.$1" 2>&1
    if grep -q "^  FAIL  $2" "$W/out.$1"; then echo "  RED   $1: $2 went red as planned"; else echo "  MISS  $1: $2 stayed green"; miss=$((miss+1)); fi
  }
  try never-off ST2 '/#guard:never-name/s/^/    __off) echo never ;; #/'
  try gate-blind ST1 's#if \[ -f "\$p/.gate" \]; then#if false; then#'
  try writes ST3 '/^# 4. say it in words$/a : > "$F/.st1dt-planted"'
  try two-questions ST4 '/(c) not now/a printf "Question: and another?\\n"'
  try forgets-no ST5 's/no:\*) declined=\${v#no: } ;;/no:*) : ;;/'
  try no-readback ST6 "s/^printf '.nWhat the model was shown: /printf '\\\\nSeen: /"
  echo "st1dt prove-red: $miss missed"; [ "$miss" -eq 0 ]; exit $?
fi
echo "st1dt tests (fixture tree in scratch)"
suite "$G/bin/st1dt"; n=$?
[ $n -eq 0 ] && echo "st1dt tests: PASS" || echo "st1dt tests: $n FAIL"
exit $n
