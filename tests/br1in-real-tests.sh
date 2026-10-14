#!/bin/sh
# br1in-real-tests.sh [--prove-red] -- SPEC BR8 (tests/lane-d-SPEC.txt): on the real drops in
# c4/from-bryant, br1in rediscovers the facts study S1 found by hand
# (c4/spells/extension/runs/2026-10-10/study/S1-bryant-modes.md, section 0 and the falsifier of its
# "Ingestion tool sketch"):
#   - 09-17 against 08-05: every shared SKILL.md is byte-identical; the only new garden skill is primer;
#   - 10-05 against 09-17: SKILL.md changed in exactly 11 (aethernet-release alfred color-theory gauntlet
#     mega-voltron omni-tool power-glove primer signet vitrine wire-2fa); 3 new (caterpillar colophon parallax);
#   - 10-05-r2 changes token-optimizer only; 10-05-r3 changes colophon and signet only.
# NOT CHECKED (exit 0, said so) when the drops are not mounted. --prove-red plants the comparison out
# (every skill UNCHANGED) and the facts must go red.
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
set -u
T=$(cd "$(dirname "$0")" && pwd -P); G=$(dirname "$T")
FB=${BR1IN_DROPS:-$HOME/mnt/c4/from-bryant}
W=$(mktemp -d "${TMPDIR:-/tmp}/br1in-real.XXXXXX"); trap 'rm -rf "$W"' EXIT INT TERM
[ -d "$FB/2026-10-05-r3" ] || { echo "br1in real tests: NOT CHECKED (the drops are not mounted at $FB)"; exit 0; }
BR=$G/bin/br1in
if [ "${1:-}" = --prove-red ]; then
  sed '/#guard:compare/s/if cmp -s "\$S\/fo2" "\$S\/fn2"; then/if true; then/; s/if \[ "\$psha" = "\$sha" \]; then mdcmp=same/if true; then mdcmp=same/' "$BR" > "$W/br1in.planted"
  cmp -s "$BR" "$W/br1in.planted" && { echo "plant did not change br1in"; exit 1; }
  BR=$W/br1in.planted
fi
nf=0
ok() { printf '  PASS  %s\n' "$1"; }
no() { printf '  FAIL  %s\n' "$1"; nf=$((nf+1)); }
run() { sh "$BR" --no-also --out "$W/out" "$FB/$1" >/dev/null 2>&1; }
col() { # drop field value -> sorted names
  awk -F'\t' -v f="$2" -v v="$3" 'NR>1 && $f==v {print $2}' "$W/out/$1.tsv" | sort | paste -sd ' ' -; }
run 2026-09-17
d=$(col 2026-09-17 4 differs)
ng=$(awk -F'\t' 'NR>1 && $3=="NEW" && $13 ~ /\/garden\// {print $2}' "$W/out/2026-09-17.tsv" | sort | paste -sd ' ' -)
if [ -z "$d" ] && [ "$ng" = primer ]; then ok "BR8 09-17 = 08-05 SKILL.md bytes, but primer (new)"
else no "BR8 09-17 = 08-05 SKILL.md bytes, but primer (differs: '$d'; new garden: '$ng')"; fi
run 2026-10-05
d=$(col 2026-10-05 4 differs); n=$(col 2026-10-05 3 NEW)
if [ "$d" = "aethernet-release alfred color-theory gauntlet mega-voltron omni-tool power-glove primer signet vitrine wire-2fa" ] \
   && [ "$n" = "caterpillar colophon parallax" ]
then ok "BR8 10-05 against 09-17: 11 SKILL.md changed, 3 new"
else no "BR8 10-05 against 09-17: 11 SKILL.md changed, 3 new (differs: '$d'; new: '$n')"; fi
run 2026-10-05-r2
d=$(col 2026-10-05-r2 4 differs); c=$(col 2026-10-05-r2 3 CHANGED)
if [ "$d" = token-optimizer ] && [ "$c" = token-optimizer ]; then ok "BR8 10-05-r2 changes token-optimizer only"
else no "BR8 10-05-r2 changes token-optimizer only (differs: '$d'; changed: '$c')"; fi
run 2026-10-05-r3
d=$(col 2026-10-05-r3 4 differs); c=$(col 2026-10-05-r3 3 CHANGED)
if [ "$d" = "colophon signet" ] && [ "$c" = "colophon signet" ]; then ok "BR8 10-05-r3 changes colophon and signet only"
else no "BR8 10-05-r3 changes colophon and signet only (differs: '$d'; changed: '$c')"; fi
if [ "${1:-}" = --prove-red ]; then
  if [ "$nf" -gt 0 ]; then echo "br1in real prove-red: $nf fact(s) went red as planned"; exit 0
  else echo "br1in real prove-red: MISS, the facts stayed green with the comparison planted out"; exit 1; fi
fi
if [ "$nf" -eq 0 ]; then echo "br1in real tests: PASS"; else echo "br1in real tests: $nf FAIL"; fi
[ "$nf" -eq 0 ]
