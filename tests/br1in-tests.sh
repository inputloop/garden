#!/bin/sh
# br1in-tests.sh [--prove-red] -- tests for bin/br1in (the Bryant drop intake) against SPEC lines
# BR1-BR7 in tests/lane-d-SPEC.txt, on fixture drops built in scratch by
# tests/fixtures/lane-d/br1in/mkdrops.sh. With --prove-red, each guard in br1in is planted out in a
# scratch copy and the test that watches it must go red.
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
set -u
T=$(cd "$(dirname "$0")" && pwd -P); G=$(dirname "$T")
command -v ruby >/dev/null 2>&1 || { echo "br1in tests: NOT CHECKED (no ruby here for BR1; install Ruby to check it)"; exit 77; }  # F1-7
F=$T/fixtures/lane-d/br1in
W=$(mktemp -d "${TMPDIR:-/tmp}/br1in-t.XXXXXX"); trap 'rm -rf "$W"' EXIT INT TERM

suite() { # $1 = the br1in to test; prints PASS/FAIL lines; returns the FAIL count
  BR=$1; X=$W/run.$$.$(date +%s%N); mkdir -p "$X"
  sh "$F/mkdrops.sh" "$X/fx" >/dev/null 2>&1
  D1=$X/fx/from/2026-01-01; D2=$X/fx/from/2026-01-02
  set -- --no-also --counterparts "$F/counterparts.tsv" --ours "$F/ours/skills" --ours "$F/ours/SOFT-SKILLS"
  nf=0
  ok() { printf '  PASS  %s\n' "$1"; }
  no() { printf '  FAIL  %s\n' "$1"; nf=$((nf+1)); }
  sh "$BR" "$@" --also "$X/fx/fenced/c4/Z/from-bryant" --out "$X/out" "$D2" > "$X/run.log" 2>&1; rc=$?
  TSV=$X/out/2026-01-02.tsv; MD=$X/out/2026-01-02.md; ACK=$X/out/2026-01-02.ACK.txt
  st() { awk -F'\t' -v n="$1" '$2==n{print $3}' "$TSV" 2>/dev/null; }
  if [ $rc -eq 0 ] && [ "$(st alpha)" = CHANGED ] && [ "$(st beta)" = UNCHANGED ] && [ "$(st gamma)" = NEW ] && [ "$(st delta)" = DROPPED ]
  then ok "BR3 alpha CHANGED, beta UNCHANGED, gamma NEW, delta DROPPED"
  else no "BR3 alpha CHANGED, beta UNCHANGED, gamma NEW, delta DROPPED (rc=$rc: $(st alpha)/$(st beta)/$(st gamma)/$(st delta))"; fi
  row=$(awk -F'\t' '$2=="alpha"' "$TSV" 2>/dev/null)
  if printf '%s' "$row" | awk -F'\t' '$5=="v1.1" && $6 ~ /^[0-9a-f]{64}$/ && $10 ~ /v1\.0 to v1\.1/ && $10 ~ /description changed/ && $10 ~ /headings \+1/ {f=1} END{exit !f}' \
     && grep -q '^- \*\*alpha\*\*, version v1.1, SKILL.md sha256 `[0-9a-f]\{64\}`: \*\*CHANGED\*\*' "$MD"
  then ok "BR4 each skill line carries name, version, sha256, status and a change summary"
  else no "BR4 each skill line carries name, version, sha256, status and a change summary"; fi
  if awk -F'\t' '$2=="beta"' "$TSV" | grep -q 'beta-ours' && awk -F'\t' '$2=="gamma"' "$TSV" | grep -q 'ours/SOFT-SKILLS (by name' \
     && awk -F'\t' '$2=="delta"' "$TSV" | grep -q 'none'
  then ok "BR5 counterparts: the table first, then by name, else none"
  else no "BR5 counterparts: the table first, then by name, else none"; fi
  if grep -q "^- extracted, not judged: trigger (quoted in the description): 'run alpha', 'alpha now'" "$MD" \
     && grep -q '^- extracted, not judged: hand-back (headings): What it hands back' "$MD"
  then ok "BR6 modes of work are printed as extracted, not judged"
  else no "BR6 modes of work are printed as extracted, not judged"; fi
  if ! grep -q 'ZETA-FENCED-MARKER\|FENCED-SECRET\|KEYS-MARKER\|SECRET-MARKER\|\.keys\|a\.secret' "$MD" "$TSV" "$ACK" 2>/dev/null \
     && grep -q 'fenced/c4/Z/from-bryant`: not read (fenced)' "$MD"
  then ok "BR7 a fenced place, .keys/ and *.secret are never read, listed or hashed"
  else no "BR7 a fenced place, .keys/ and *.secret are never read, listed or hashed"; fi
  sh "$BR" "$@" --out "$X/out2" "$X/fx/fenced/c4/Z/from-bryant/2026-01-03" >/dev/null 2>&1; rc=$?
  if [ $rc -eq 3 ] && [ ! -e "$X/out2" ]; then ok "BR7 a drop under a fenced path is refused (exit 3)"
  else no "BR7 a drop under a fenced path is refused (exit 3; got $rc)"; fi
  ls -laR "$D2" > "$X/ls.before"
  sh "$BR" "$@" --out "$D2/reports" "$D2" >/dev/null 2>&1; rc=$?
  ls -laR "$D2" > "$X/ls.after"
  if [ $rc -eq 3 ] && cmp -s "$X/ls.before" "$X/ls.after"; then ok "BR1 an --out inside the drop is refused and nothing is made"
  else no "BR1 an --out inside the drop is refused and nothing is made (rc=$rc)"; fi
  if ruby "$T/br1in-noedit-spec.rb" "$BR" "$X/fx" > "$X/rb.log" 2>&1; then ok "BR1 (Ruby) the drop's bytes are unchanged after a run"
  else no "BR1 (Ruby) the drop's bytes are unchanged after a run: $(grep FAIL "$X/rb.log" | head -n 1)"; fi
  if [ -s "$ACK" ] && ! grep -q 'alpha thing\|Body\.' "$ACK" && tail -n +5 "$ACK" | awk '!/^[0-9a-f]{64}  [^ ]/{bad=1} END{exit bad}'
  then ok "BR1 the ACK carries hashes and a verdict, never content"
  else no "BR1 the ACK carries hashes and a verdict, never content"; fi
  mkdir -p "$X/flip"; cp -R "$X/fx/from/2026-01-01" "$X/flip/"; cp -R "$D2" "$X/flip/"
  Z="$X/flip/2026-01-02/pack-2026-01-02.zip"
  sz=$(wc -c < "$Z"); off=$((sz - 30))
  printf 'X' | dd of="$Z" bs=1 seek=$off count=1 conv=notrunc 2>/dev/null
  sh "$BR" "$@" --out "$X/out3" "$X/flip/2026-01-02" >/dev/null 2>&1; rc=$?
  if [ $rc -eq 1 ] && grep -q 'Verdict: \*\*FAIL\*\*' "$X/out3/2026-01-02.md"; then ok "BR2 one flipped byte in a summed file makes the verdict FAIL (exit 1)"
  else no "BR2 one flipped byte in a summed file makes the verdict FAIL (exit 1; got $rc)"; fi
  return $nf
}

plant() { # name sed-expression -> a planted copy of br1in
  sed "$2" "$G/bin/br1in" > "$W/br1in.$1"
  if cmp -s "$G/bin/br1in" "$W/br1in.$1"; then printf 'plant %s did not change the file\n' "$1" >&2; return 1; fi
}

if [ "${1:-}" = --prove-red ]; then
  echo "br1in prove-red: planting each guard out; the named test must go red"
  red=0; miss=0
  try() { # name test-id sed
    plant "$1" "$3" || { miss=$((miss+1)); return; }
    out=$(suite "$W/br1in.$1")
    if printf '%s\n' "$out" | grep -q "^  FAIL  $2"; then printf '  RED   %s: "%s" went red as planned\n' "$1" "$2"; red=$((red+1))
    else printf '  MISS  %s: "%s" stayed green\n' "$1" "$2"; miss=$((miss+1)); fi
  }
  try out-in-drop 'BR1 an --out inside the drop' '/#guard:out-in-drop/s/&& refuse/\&\& :/'
  try write-into-drop 'BR1 (Ruby)' '/^trap .rm -rf "\$S". EXIT INT TERM$/a : > "$DROP/.br1in-planted"'
  try fence-off 'BR7 a fenced place' '/#guard:fence/s/return 0/return 1/; /#guard:prune/s/-prune/-print/'
  try sums-off 'BR2 one flipped byte' '/#guard:sums/s/verdict=FAIL/:/'
  try compare-off 'BR3 alpha CHANGED' '/#guard:compare/s/if cmp -s "\$S\/fo2" "\$S\/fn2"; then/if true; then/'
  printf 'br1in prove-red: %s red as planned, %s missed\n' "$red" "$miss"
  [ "$miss" -eq 0 ]; exit $?
fi

echo "br1in tests (fixture drops in scratch)"
suite "$G/bin/br1in"; n=$?
if [ "$n" -eq 0 ]; then echo "br1in tests: PASS"; else echo "br1in tests: $n FAIL"; fi
[ "$n" -eq 0 ]
