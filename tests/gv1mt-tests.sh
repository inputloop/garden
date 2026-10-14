#!/bin/sh
# gv1mt-tests.sh -- the garden view's tests (tests/gv1mt-SPEC.txt, GV1-GV16).
#   build into a temporary folder; recount it in awk (GV6); check the spec rows in Ruby (GV1-5, 7, 8, 10, 14, 16);
#   audit every colour pair with color-theory (GV11); read the Makefile with make -n (GV15); check the copy for
#   sharing with C4's pb1ck (GV19); and run the page in headless Chromium with axe-core (GV9, GV12, GV13, GV17:
#   tests/gv1mt-browser.py).
# usage: sh tests/gv1mt-tests.sh [--prove-red]
#   --prove-red plants one fault per check in a copy and requires each check to go red.
# Exit 0 green, 1 red, 77 when everything that ran is green but the browser leg was NOT CHECKED.
#
# The command it was run green with (2026-10-10, Cowork VM, from the garden folder):
#   GV_LIBDIR=$HOME/gvkit/root/usr/lib/x86_64-linux-gnu sh tests/gv1mt-tests.sh
# GV_LIBDIR is the folder holding libXdamage.so.1 (not ~/gvkit/deb, which holds only the .deb); without it
# the browser leg looks there by itself.  Setting up that kit in a fresh VM: see tests/gv1mt-browser.py.
#
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
here=$(cd "$(dirname "$0")/.." && pwd)
t=$(mktemp -d "${TMPDIR:-/tmp}/gv1mt.XXXXXX") || exit 1
trap 'rm -rf "$t"' EXIT INT TERM
CT="$here/skills/color-theory/tool.py"
bad=0 nc=0
say() { printf '%s\n' "$*"; }
leg() { # leg NAME EXPECT(0|1) COMMAND...: run, and say whether it gave the expected verdict
  name=$1 want=$2; shift 2
  "$@" >"$t/leg.out" 2>&1; rc=$?
  if [ "$rc" = 77 ]; then say "NOT CHECKED $name: $(tail -1 "$t/leg.out")"; nc=1; return; fi
  [ "$rc" != 0 ] && rc=1
  if [ "$rc" = "$want" ]; then
    if [ "$want" = 0 ]; then say "ok   $name: $(grep -E 'GREEN|^audit:|runs gv1mt|PROVE-RED|^pb1ck:' "$t/leg.out" | tail -1)"; else say "ok   $name goes red: $(grep -m1 -E 'MISMATCH|FAIL|failed|runs gv1mt|^pb1ck:' "$t/leg.out")"; fi
  else
    say "FAIL $name (exit $rc, wanted $want):"; sed 's/^/     /' "$t/leg.out" | tail -12; bad=1
  fi
}
gv15() { # GV15 MAKEFILE: garden-view builds with gv1mt, dist calls it, garden is still one sg1ck command
  mk=$1
  a=$(cd "$here" && make -s -n -f "$mk" garden-view 2>/dev/null | grep -c 'bin/gv1mt build')
  b=$(cd "$here" && make -s -n -f "$mk" dist 2>/dev/null | grep -v '^#' | grep -c 'bin/gv1mt build')
  c=$(cd "$here" && make -s -n -f "$mk" C4_ROOT="$here/tests/fixtures" garden 2>/dev/null | wc -l | tr -d ' ')
  echo "garden-view runs gv1mt: $a; dist runs gv1mt: $b; garden prints $c line(s)"
  [ "$a" -ge 1 ] && [ "$b" -ge 1 ] && [ "$c" -le 1 ]
}

gv19() { # GV19 PUBLIC: pb1ck finds no LEAK of the four masked kinds; counts equal the private copy's
  pub=$1 priv=$2
  PB=""; for c in "${C4_ROOT:-}" /f/claude/c4 "$here/../c4" "$HOME/mnt/c4"; do [ -n "$c" ] && [ -f "$c/bin/pb1ck" ] && { PB="$c/bin/pb1ck"; break; }; done
  [ -n "$PB" ] || { echo "NOT CHECKED: no C4 pb1ck found"; return 77; }
  n=$(sh "$PB" "$pub" 2>&1 | awk -F'\t' '$1=="LEAK" && ($4=="drive-letter"||$4=="msys-path"||$4=="unc-path"||$4=="claude-ai-link")' | wc -l | tr -d ' ')
  c1=$(awk '/^ "counts": \{/,/^ \}/' "$priv/data.json" | grep -E '"(nodes|edges|tensions)"' | tr -d ' ')
  c2=$(awk '/^ "counts": \{/,/^ \}/' "$pub/data.json" | grep -E '"(nodes|edges|tensions)"' | tr -d ' ')
  mk=$(grep -c '^ "masked": {' "$pub/data.json")
  echo "pb1ck: $n LEAK of the masked kinds; counts same as private: $([ "$c1" = "$c2" ] && echo yes || echo NO); data.masked present: $mk"
  [ "$n" = 0 ] && [ "$c1" = "$c2" ] && [ "$mk" = 1 ]
}

say "== gv1mt tests =="
python3 "$here/bin/gv1mt" build --public --root "$here" --out "$t/out" --at 2026-10-10T00:00:00Z >"$t/build.out" 2>&1 \
  || { say "FAIL build:"; cat "$t/build.out"; exit 1; }
say "built: $(sed -n 2p "$t/build.out" | cut -c1-110)"
O="$t/out"
if [ "${1:-}" != "--prove-red" ]; then
  leg "GV6 awk recount" 0 awk -f "$here/tests/gv1mt-recount.awk" "$O/data.json" "$O/garden-view.facts" "$O/index.html"
  leg "GV1-5 GV7 GV8 GV10 GV14 GV16 GV18 Ruby spec rows" 0 ruby "$here/tests/gv1mt-spec.rb" "$O"
  leg "GV11 colour pairs (color-theory audit)" 0 python3 "$CT" audit "$O/pairs.txt"
  leg "GV15 make targets" 0 gv15 "$here/Makefile"
  leg "GV19 the copy for sharing (pb1ck)" 0 gv19 "$O/public" "$O"
  leg "GV6 awk recount, the copy for sharing" 0 awk -f "$here/tests/gv1mt-recount.awk" "$O/public/data.json" "$O/public/garden-view.facts" "$O/public/index.html"
  leg "Ruby spec rows, the copy for sharing" 0 ruby "$here/tests/gv1mt-spec.rb" "$O/public"
  leg "GV9 GV12 GV13 GV17 browser" 0 python3 "$here/tests/gv1mt-browser.py" "$O/index.html"
else
  P="$t/plant"; mkdir -p "$P"
  for f in "$O"/*; do [ -f "$f" ] && cp "$f" "$P"/; done
  # GV6: one NODE line gone from the facts
  awk '/^NODE /&&!d{d=1;next}1' "$O/garden-view.facts" >"$P/garden-view.facts"
  leg "GV6 awk recount (a NODE line removed)" 1 awk -f "$here/tests/gv1mt-recount.awk" "$P/data.json" "$P/garden-view.facts" "$P/index.html"
  cp "$O/garden-view.facts" "$P/"
  # GV6 + GV7: the open count claimed one too high
  awk '/^  "open": /{n=$2+1; sub(/[0-9]+/, n)}1' "$O/data.json" >"$P/data.json"
  leg "GV6 awk recount (counts.open one too high)" 1 awk -f "$here/tests/gv1mt-recount.awk" "$P/data.json" "$P/garden-view.facts" "$P/index.html"
  leg "GV7 seal (counts.open one too high)" 1 ruby "$here/tests/gv1mt-spec.rb" "$P"
  cp "$O/data.json" "$P/"
  # GV8: an outside font
  sed 's#<title>#<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter"><title>#' "$O/index.html" >"$P/index.html"
  leg "GV8 self-contained (an outside font)" 1 ruby "$here/tests/gv1mt-spec.rb" "$P"
  # GV10: tension marks by colour alone
  sed 's# open</text>#</text>#g; s# resolved</text>#</text>#g' "$O/index.html" >"$P/index.html"
  leg "GV10 words on marks (words stripped)" 1 ruby "$here/tests/gv1mt-spec.rb" "$P"
  # GV14: the credit to Bryant's graph removed
  sed "s#Bryant Frankford's <strong>Nexus Skill Tree</strong>#a <strong>skill tree</strong>#" "$O/index.html" >"$P/index.html"
  leg "GV14 credit (Bryant's name removed)" 1 ruby "$here/tests/gv1mt-spec.rb" "$P"
  # GV16: a probe that runs on load
  sed 's#^// seal and self-test#fetch("http://127.0.0.1:8042/api/headings");\n// seal and self-test#' "$O/index.html" >"$P/index.html"
  leg "GV16 no probe until asked (one on load)" 1 ruby "$here/tests/gv1mt-spec.rb" "$P"
  cp "$O/index.html" "$P/"
  # GV11: a pair that fails AA
  { cat "$O/pairs.txt"; echo "#9aa1ad #fbfaf7"; } >"$P/pairs.txt"
  leg "GV11 colour pairs (a faint pair added)" 1 python3 "$CT" audit "$P/pairs.txt"
  # GV15: dist without the garden view
  grep -v 'bin/gv1mt build' "$here/Makefile" >"$P/Makefile"
  leg "GV15 make targets (dist and garden-view without gv1mt)" 1 gv15 "$P/Makefile"
  # GV18: a default shown as this machine's state (the old words)
  sed 's#off by default#off as built#' "$O/index.html" >"$P/index.html"
  leg "GV18 a default shown as state (old words)" 1 ruby "$here/tests/gv1mt-spec.rb" "$P"
  cp "$O/index.html" "$P/"
  # GV19: one unmasked drive path in the copy for sharing
  mkdir -p "$P/public"; cp "$O/public"/* "$P/public/"
  sed 's#<F>:/claude#F:\\claude#' "$O/public/index.html" >"$P/public/index.html"
  leg "GV19 the copy for sharing (an unmasked drive path)" 1 gv19 "$P/public" "$O"
  leg "GV9 GV12 GV13 GV17 browser prove-red" 0 python3 "$here/tests/gv1mt-browser.py" "$O/index.html" --prove-red
fi
if [ "$bad" = 1 ]; then say "gv1mt-tests: RED${1:+ (prove-red: a planted fault was not caught)}"; exit 1; fi
if [ "$nc" = 1 ]; then say "gv1mt-tests: GREEN where checked; NOT CHECKED in part (above)"; exit 77; fi
if [ "${1:-}" = "--prove-red" ]; then say "gv1mt-tests: PROVE-RED OK (every planted fault was caught)"; else say "gv1mt-tests: GREEN"; fi
