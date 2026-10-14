#!/bin/sh
# editions-tests.sh -- a sized edition (and the random one) holds what the design says, from the
# outside: the real garden, minted into a scratch folder, read back with ls, grep and cmp.
# The design: c4 h/DESIGN-2026-09-28-default-skill-set.md.  The unit tests (python) are
# tests/test_editions.py; this is the second reader, written from the design, not the code.
#
# Copyright (C) 2026 Corwin Brust <corwin@bru.st>
# Authored by Mentat (for Corwin).
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of vibrobeast.  vibrobeast is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
# usage: sh tests/editions-tests.sh [--prove-red [broad|soft|floor|seed]]   (one mutant, or all four)
#        PKG=DIR runs the polygram package found in DIR instead of this tree's (the mutants use it)
# exit 0 all held · 1 a promise broken · 77 cannot run here (no python3 or sh)
set -u
here=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd) || exit 2
PY=${PYTHON:-python3}
command -v "$PY" >/dev/null 2>&1 || { echo "SKIPPED: no $PY"; exit 77; }
FLOOR="mentat-skill principles skilltank sandboxer lens garden-usage consent-gate drift"
BROAD="altorewired token-optimizer"

prove_red() {
	pr_t=$(mktemp -d) || exit 2
	pr_bad=0
	for m in ${1:-broad soft floor seed}; do
		rm -rf "$pr_t/pkg"; mkdir -p "$pr_t/pkg"; cp -R "$here/polygram" "$pr_t/pkg/"
		case $m in
		broad) f=editions.py; a='        if s.name in broad:'; b='        if False:' ;;
		soft)  f=plugin.py;   a='    for sk in soft or []:'; b='    for sk in []:' ;;
		floor) f=editions.py; a='            fl.append(by_name[n])'; b='            pass' ;;
		seed)  f=editions.py; a='_random.Random(str(seed))'; b='_random.Random()' ;;
		esac
		A=$a B=$b "$PY" - "$pr_t/pkg/polygram/$f" <<'EOF' || { echo "prove-red: could not plant $m"; exit 1; }
import os, sys
p = sys.argv[1]; s = open(p, encoding="utf-8").read(); a, b = os.environ["A"], os.environ["B"]
assert s.count(a) == 1, a
open(p, "w", encoding="utf-8", newline="").write(s.replace(a, b))
EOF
		if PKG="$pr_t/pkg" sh "$0" >"$pr_t/out" 2>&1; then
			echo "prove-red: MISSED the $m mutant"; pr_bad=1
		else
			echo "prove-red: the $m mutant went red ($(grep -c '^FAIL' "$pr_t/out") check(s))"
		fi
	done
	rm -rf "$pr_t"
	[ "$pr_bad" = 0 ] && { echo "prove-red: every mutant went red"; exit 0; }
	exit 1
}
[ "${1:-}" = --prove-red ] && { shift; prove_red "$@"; }

PKG=${PKG:-$here}
pass=0; fail=0
ok() { if [ "$2" = 0 ]; then pass=$((pass+1)); echo "ok   $1"; else fail=$((fail+1)); echo "FAIL $1${3:+ -- $3}"; fi; }
t=$(mktemp -d) || exit 2; trap 'rm -rf "$t"' EXIT INT TERM
mint() { mo=$1; shift; ( cd "$PKG" && PYTHONDONTWRITEBYTECODE=1 "$PY" -m polygram -C "$here" edition --no-advice \
	--no-usage --out "$t/$mo" --at 2026-09-28T04:00:00Z "$@" ) ; }
has() { [ -f "$1/$2/SKILL.md" ]; }

out=$(mint g --size grain 2>&1); rc=$?
E="$t/g/vibrobeast-grain"
[ -d "$E/skills" ]; ok "E1 make a GRAIN edition (vibrobeast-grain)" $? "rc=$rc $out"
nin=$(ls "$E/skills" 2>/dev/null | wc -l | tr -d ' ')
ngarden=$(ls -d "$here"/skills/*/ | wc -l | tr -d ' ')
nsoft=$(ls "$E/SOFT-SKILLS" 2>/dev/null | wc -l | tr -d ' ')
miss=""; for f in $FLOOR; do has "$E/skills" "$f" || miss="$miss $f"; done
[ -z "$miss" ]; ok "E2 every floor skill is installed" $? "missing:$miss"
[ "$nin" -gt 8 ]; ok "E3 GRAIN installs picks on top of the floor of eight ($nin)" $?
bad=""; for b in $BROAD; do has "$E/skills" "$b" && bad="$bad $b"; has "$E/SOFT-SKILLS" "$b" || bad="$bad $b(not soft)"; done
[ -z "$bad" ]; ok "E4 the skills that fire broadly are soft, not installed" $? "$bad"
[ $((nin + nsoft)) = "$ngarden" ]; ok "E5 every garden skill is in the edition exactly once ($nin + $nsoft = $ngarden)" $?
dup=$( (ls "$E/skills"; ls "$E/SOFT-SKILLS") | sort | uniq -d | tr '\n' ' ')
[ -z "$dup" ]; ok "E6 no skill is both installed and soft" $? "$dup"
lost=""; for d in "$here"/skills/*/; do n=$(basename "$d"); has "$E/skills" "$n" || has "$E/SOFT-SKILLS" "$n" || lost="$lost $n"; done
[ -z "$lost" ]; ok "E7 nothing in the garden is lost" $? "$lost"
nm=""; for n in $(ls "$E/SOFT-SKILLS" 2>/dev/null); do grep -qF "\`$n\`" "$E/README.md" || nm="$nm $n"; done
[ -z "$nm" ]; ok "E8 the README names every soft skill and why" $? "$nm"
cmp -s "$here/skills/sandboxer/SKILL.md" "$E/skills/sandboxer/SKILL.md" && \
 { [ ! -f "$here/skills/altorewired/.signature.asc" ] || cmp -s "$here/skills/altorewired/.signature.asc" "$E/SOFT-SKILLS/altorewired/.signature.asc"; }
ok "E9 skills and their signatures travel byte for byte, installed or soft" $?
( cd "$E" && sh check.sh >/dev/null 2>&1 ); ok "E10 the edition's own check.sh passes (its MANIFEST covers SOFT-SKILLS)" $?
grep -q 'SOFT_SKILLS' "$E/servers/launch.py"; ok "E11 the launcher points mentcached at the edition's SOFT-SKILLS" $?
grep -q '"name": "vibrobeast-grain"' "$E/.claude-plugin/plugin.json"; ok "E12 the plugin is named for its size" $?
grep -q 'sandboxer` is held at a receiving door' "$E/README.md"; ok "E13 a floor skill held at a door is installed and said" $?

mint r1 --random --seed 7 >/dev/null 2>&1; mint r2 --random --seed 7 >/dev/null 2>&1
R1="$t/r1/vibrobeast-random"; R2="$t/r2/vibrobeast-random"
[ -d "$R1/skills" ] && [ "$(ls "$R1/skills")" = "$(ls "$R2/skills")" ]; ok "E14 RANDOM alone is vibrobeast-random, and a seed repeats the draw" $?
grep -q 'seed `7`' "$R1/README.md"; ok "E15 the README carries the seed and how to repeat it" $?
mint r3 --random --seed 8 >/dev/null 2>&1; mint r4 --random --seed 9 >/dev/null 2>&1; mint r5 --random --seed 10 >/dev/null 2>&1
d=$( (ls "$t/r1/vibrobeast-random/skills" | tr '\n' ,; echo; ls "$t/r3/vibrobeast-random/skills" | tr '\n' ,; echo; \
      ls "$t/r4/vibrobeast-random/skills" | tr '\n' ,; echo; ls "$t/r5/vibrobeast-random/skills" | tr '\n' ,; echo) | sort -u | wc -l | tr -d ' ')
[ "$d" -gt 1 ]; ok "E16 different seeds draw differently ($d distinct of 4)" $?
mint s --size grain --random great --seed 3 >/dev/null 2>&1; S="$t/s/vibrobeast-grain-random-great"
[ -d "$S" ] && [ "$(ls "$S/skills" | wc -l)" -gt "$nin" ]; ok "E17 a size and RANDOM stack: more installed than GRAIN alone" $?
bad=""; for b in $BROAD; do has "$S/skills" "$b" && bad="$bad $b"; done
[ -z "$bad" ]; ok "E18 the random draw never installs a skill that fires broadly" $? "$bad"
( cd "$PKG" && PYTHONDONTWRITEBYTECODE=1 "$PY" -m polygram -C "$here" edition --no-advice --out "$t/x" ) >/dev/null 2>&1
[ $? = 2 ]; ok "E19 an edition with no size and no --random is a usage error (the full plugin is \`polygram dist\`)" $?

mint a --random all --seed 1 >/dev/null 2>&1; AL="$t/a/vibrobeast-random-all"
bad=""; for b in $BROAD aethernet-relay candor-gate foaf medley-review seatkeeper shelf-check; do has "$AL/skills" "$b" && bad="$bad $b"; done
[ -d "$AL/skills" ] && [ -z "$bad" ]; ok "E20 even RANDOM=all never installs a broad or door-held skill beyond the floor" $? "$bad"

echo "editions-tests: $pass passed, $fail failed"
[ "$fail" = 0 ]
