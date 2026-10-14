#!/bin/sh
# tests.sh -- the outside-reader key (scripts/or1ky) on five made-up repositories: true answers come
# quoted (Q5's own answer says NOT CHECKED); the key's gaps say KEY-NOT-CHECKED and name the
# repository that is missing; Q6 reads licence marks (REUSE.toml, .reuse/dep5, SPDX lines, the
# house's copyright lines), never COPYING, and splits the code from the prose; every awk on hand
# prints the same key; FROM says where the skill comes from.  --prove-red plants eight faults and
# requires each to turn the suite red.
# tier: smoke
# usage: sh tests.sh [--prove-red]     OR1KY_CHECKOUTS=DIR also runs the key on real checkouts
# Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; GPL-3.0-or-later.
# Mentat (for Corwin; claude-opus-5-5)
set -u
LC_ALL=C; export LC_ALL
here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd) || exit 2
w=$(mktemp -d 2>/dev/null) || { w=${TMPDIR:-/tmp}/or-tests.$$; mkdir -p "$w"; }
trap 'rm -rf "$w"' EXIT INT TERM

fixtures() { # DIR -> the five made-up repositories under DIR
  F=$1
  # gw-survey: a stand-in gw1as.py whose answer holds double quotes; copyright-line marks, two
  # code licences, a .reuse/dep5 for the facts, a deep string that is not a header, and a COPYING
  mkdir -p "$F/gw-survey/bin" "$F/gw-survey/tests/facts" "$F/gw-survey/.reuse"
  { echo '#!/usr/bin/env python3'; echo '# Copyright 2026 A. Person and Contributors; GPL-3.0-or-later.'
    i=0; while [ $i -lt 25 ]; do echo '# ...'; i=$((i + 1)); done
    echo 'FOOT = "<p>Copyright 2026 A. Person and Contributors; Apache-2.0. </p>"'
    echo 'print("STATE TANGLED: 2 \"holds\"")'; } > "$F/gw-survey/bin/gw1as.py"
  printf 'tangled\n' > "$F/gw-survey/tests/facts/tangled.facts"
  printf '# Copyright 2026 A. Person and Contributors; MIT.\nall:\n' > "$F/gw-survey/Makefile"
  printf '* gw-survey\n\nCopyright 2026 A. Person <a@b.c> and Contributors; CC-BY-SA4: https://creativecommons.org/licenses/by-sa/4.0/ (code GPL-3.0-or-later)\n' > "$F/gw-survey/README.org"
  printf 'Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/\nUpstream-Name: gw-survey\n\nFiles: tests/facts/*.facts\nCopyright: 2026 A. Person\nLicense: CC0-1.0\n' > "$F/gw-survey/.reuse/dep5"
  printf '                    GNU GENERAL PUBLIC LICENSE\n                       Version 3, 29 June 2007\n' > "$F/gw-survey/COPYING"
  # persona-engine: SPDX-License-Identifier lines only
  mkdir -p "$F/persona-engine/skill/persona-engine/scripts"
  printf '#!/bin/sh\n# SPDX-License-Identifier: LGPL-3.0-or-later\necho "STOP: gw7 is asked for twice"\necho "then: more"\n' > "$F/persona-engine/skill/persona-engine/scripts/pe1gt"
  printf -- '---\nname: persona-engine\n---\n\n<!-- SPDX-License-Identifier: CC-BY-SA-4.0 -->\n' > "$F/persona-engine/skill/persona-engine/SKILL.md"
  cp "$F/gw-survey/COPYING" "$F/persona-engine/COPYING"
  # field-comic: three panels, two bubbles that list fixes; an HTML page whose <script> is code
  mkdir -p "$F/field-comic/data" "$F/field-comic/build"
  printf '{"panels": [{"bubbles": [{"text": "a", "fixes": [["x", "y"]]}, {"text": "b"}]}, {"bubbles": [{"text": "c", "fixes": []}]}, {"bubbles": []}]}\n' > "$F/field-comic/data/vol2.json"
  printf '<html><body>\n<p>Copyright 2026 A. Person &lt;a@b.c&gt; and Contributors; CC-BY4: https://creativecommons.org/licenses/by/4.0/</p>\n<script>\n/* Copyright 2026 A. Person and Contributors; AGPL-3.0-or-later. */\nvar x = 1;\n</script>\n</body></html>\n' > "$F/field-comic/build/page.html"
  # kid-glove: three topics; REUSE.toml only, a path list across lines
  mkdir -p "$F/kid-glove/skill/kid-glove/kit"
  printf '| topic       | why | where |\n|-------------+-----+-------|\n| licence     | x   | y     |\n| attribution | x   | y     |\n| tests       | x   | y     |\n' > "$F/kid-glove/skill/kid-glove/kit/topics.org-table"
  printf 'version = 1\n\n[[annotations]]\npath = ["skill/**", "Makefile"]\nSPDX-License-Identifier = "GPL-3.0-or-later"\n\n[[annotations]]\npath = [\n  "**/*.md",\n  "README.org",\n]\nSPDX-License-Identifier = "CC0-1.0"\n' > "$F/kid-glove/REUSE.toml"
  # drift: a dr1pg whose true answer says NOT CHECKED; a literate recipe whose markdown block is prose
  mkdir -p "$F/drift/skill/drift/scripts"
  printf '#!/usr/bin/env python3\n# Copyright 2026 A. Person and Contributors; GPL-3.0-only.\nprint("# drift")\nprint("- kid glove ledger: NOT CHECKED (not present)")\n' > "$F/drift/skill/drift/scripts/dr1pg"
  printf '#+TITLE: drift\n* The skill\n#+begin_src markdown :tangle skill/drift/SKILL.md\n# drift\nCopyright 2026 A. Person and Contributors; CC-BY-SA4: https://creativecommons.org/licenses/by-sa/4.0/\n#+end_src\n* A script\n#+begin_src sh :tangle skill/drift/scripts/dr1ck\n#!/bin/sh\n# Copyright 2026 A. Person and Contributors; GPL-3.0-only.\n#+end_src\n' > "$F/drift/drift.org"
}

cat > "$w/expect" <<'EOF'
Q1 "TANGLED: 2 \"holds\""
Q2 "STOP"
Q3 "3 panels; 2 bubbles with fixes"
Q4 "3 topics"
Q5 "NOT CHECKED (not present)"
Q6 gw-survey: "CC0-1.0, GPL-3.0-or-later, MIT (code); CC-BY-SA-4.0 (prose)" [read: .reuse/dep5, copyright lines]
Q6 persona-engine: "LGPL-3.0-or-later (code); CC-BY-SA-4.0 (prose)" [read: SPDX-License-Identifier lines]
Q6 field-comic: "AGPL-3.0-or-later (code); CC-BY-4.0 (prose)" [read: copyright lines]
Q6 kid-glove: "GPL-3.0-or-later (code); CC0-1.0 (prose)" [read: REUSE.toml]
Q6 drift: "GPL-3.0-only (code); CC-BY-SA-4.0 (prose)" [read: copyright lines]
EOF

F=$w/repos; fixtures "$F"
awks=""
for a in awk mawk gawk original-awk nawk; do command -v "$a" >/dev/null 2>&1 && awks="$awks $a"; done
command -v busybox >/dev/null 2>&1 && busybox awk 'BEGIN{}' 2>/dev/null && awks="$awks busybox_awk"
printf '#!/bin/sh\nexec busybox awk "$@"\n' > "$w/bbawk"; chmod +x "$w/bbawk"

suite() { # OR1KY FROM -> one line per check; returns 1 when any check fails
  KEY=$1 FROMF=$2 pass=0 fail=0 s=$w/s; rm -rf "$s"; mkdir -p "$s"
  ok()  { pass=$((pass + 1)); echo "ok   $1"; }
  bad() { fail=$((fail + 1)); echo "FAIL $1 -- $2"; }
  # 1. the whole key on the five made-up repositories, under every awk on hand
  for a in $awks; do
    aw=$a; [ "$a" = busybox_awk ] && aw=$w/bbawk
    OR1KY_AWK=$aw sh "$KEY" "$F" > "$s/key.$a" 2>"$s/err.$a"
    if cmp -s "$s/key.$a" "$w/expect"; then ok "the key, under $a: every answer as expected"
    else bad "the key, under $a" "$(diff "$w/expect" "$s/key.$a" | grep '^[<>]' | head -4 | tr '\n' '|')"; fi
  done
  sh "$KEY" "$F" > "$s/key" 2>/dev/null
  # 2. Q5's true answer is quoted, and the key's own sentinel appears nowhere in a full key
  grep -qx 'Q5 "NOT CHECKED (not present)"' "$s/key" && ok "Q5's answer that says NOT CHECKED comes quoted" || bad "Q5 quoted" "$(grep '^Q5' "$s/key")"
  grep -q 'KEY-NOT-CHECKED' "$s/key" && bad "no KEY-NOT-CHECKED in a full key" "$(grep KEY-NOT-CHECKED "$s/key" | head -2)" || ok "a full key has no KEY-NOT-CHECKED line"
  # 3. Q6 never reads COPYING
  grep -q 'GNU GENERAL PUBLIC LICENSE' "$s/key" && bad "COPYING not read" "the key quotes COPYING" || ok "Q6 does not read COPYING"
  # 4. a missing repository: Q3 and Q6 say KEY-NOT-CHECKED and name it
  cp -R "$F" "$s/nofc"; rm -rf "$s/nofc/field-comic"; sh "$KEY" "$s/nofc" > "$s/key.nofc" 2>/dev/null
  grep -qxF "Q3 KEY-NOT-CHECKED (field-comic is not in $s/nofc; the key reads field-comic/data/vol2.json)" "$s/key.nofc" &&
    ok "no field-comic: Q3 KEY-NOT-CHECKED names field-comic and the file" || bad "Q3, no field-comic" "$(grep '^Q3' "$s/key.nofc")"
  grep -qxF "Q6 field-comic: KEY-NOT-CHECKED (field-comic is not in $s/nofc)" "$s/key.nofc" &&
    ok "no field-comic: Q6 says KEY-NOT-CHECKED for it" || bad "Q6, no field-comic" "$(grep '^Q6 field-comic' "$s/key.nofc")"
  [ "$(grep -c '"' "$s/key.nofc")" -eq 8 ] && ok "no field-comic: the other eight lines still answer" || bad "other answers" "$(grep -vc '"' "$s/key.nofc") unquoted"
  # 5. a repository without the file the key reads
  rm -f "$s/nofc/kid-glove/skill/kid-glove/kit/topics.org-table"; sh "$KEY" "$s/nofc" > "$s/key.nokit" 2>/dev/null
  grep -qxF "Q4 KEY-NOT-CHECKED (kid-glove is in $s/nofc but has no skill/kid-glove/kit/topics.org-table)" "$s/key.nokit" &&
    ok "kid-glove without its kit: Q4 names the file" || bad "Q4, no kit" "$(grep '^Q4' "$s/key.nokit")"
  # 6. a tool that prints nothing is the key's gap, not an empty answer
  cp -R "$F" "$s/mute"; printf 'print("no state here")\n' > "$s/mute/gw-survey/bin/gw1as.py"; sh "$KEY" "$s/mute" > "$s/key.mute" 2>/dev/null
  grep -qxF "Q1 KEY-NOT-CHECKED (gw-survey's bin/gw1as.py printed no STATE line)" "$s/key.mute" &&
    ok "a mute tool: Q1 KEY-NOT-CHECKED, not an empty answer" || bad "Q1, mute" "$(grep '^Q1' "$s/key.mute")"
  # 7. code marked, prose not (the mute gw1as.py has no header, so GPL-3.0-or-later goes too);
  #    and nothing marked but COPYING
  rm -f "$s/mute/gw-survey/README.org"; rm -f "$s/mute/persona-engine/skill/persona-engine/SKILL.md" "$s/mute/persona-engine/skill/persona-engine/scripts/pe1gt"
  sh "$KEY" "$s/mute" > "$s/key.mute" 2>/dev/null
  grep -qxF 'Q6 gw-survey: "CC0-1.0, MIT (code)", prose KEY-NOT-CHECKED (no licence mark on any prose file in gw-survey) [read: .reuse/dep5, copyright lines]' "$s/key.mute" &&
    ok "prose unmarked: the code answer is quoted, the prose is KEY-NOT-CHECKED" || bad "prose unmarked" "$(grep '^Q6 gw' "$s/key.mute")"
  grep -qF 'Q6 persona-engine: KEY-NOT-CHECKED (no licence mark in persona-engine' "$s/key.mute" && grep -q 'COPYING is not read)$' "$s/key.mute" &&
    ok "only a COPYING: KEY-NOT-CHECKED, and says COPYING is not read" || bad "only COPYING" "$(grep '^Q6 persona' "$s/key.mute")"
  # 8. in a git checkout only tracked files count
  if command -v git >/dev/null 2>&1; then
    cp -R "$F" "$s/git"; (cd "$s/git/persona-engine" && git init -q && git add . && git -c user.name=t -c user.email=t@t commit -q -m t) >/dev/null 2>&1
    printf '#!/bin/sh\n# SPDX-License-Identifier: MIT\n' > "$s/git/persona-engine/stray.sh"; sh "$KEY" "$s/git" > "$s/key.git" 2>/dev/null
    grep -qxF 'Q6 persona-engine: "LGPL-3.0-or-later (code); CC-BY-SA-4.0 (prose)" [read: SPDX-License-Identifier lines]' "$s/key.git" &&
      ok "a git checkout: an untracked file's mark is not read" || bad "git checkout" "$(grep '^Q6 persona' "$s/key.git")"
  else echo "NOT CHECKED: the git-checkout case (no git)"; fi
  # 9. FROM says where the skill comes from, and that there is no recipe yet
  if [ -f "$FROMF" ] && grep -q 'SOFT-SKILLS.outside-reader' "$FROMF" && grep -q 'no literate recipe' "$FROMF"; then ok "FROM names the source folder and says there is no literate recipe"
  else bad "FROM" "missing, or silent about its source or the recipe"; fi
  echo "outside-reader: $pass passed, $fail failed (awk:$awks)"
  [ $fail = 0 ]
}

if [ "${1:-}" = --prove-red ]; then
  r=0 orig=$here/scripts/or1ky
  plant() { # NAME WHAT SED-SCRIPT -> the suite must fail on or1ky with that fault planted
    sed "$3" "$orig" > "$w/$1"
    if cmp -s "$w/$1" "$orig"; then echo "prove-red: $2: the fault did not apply (fix the planting)"; r=1; return; fi
    if suite "$w/$1" "$here/FROM" > "$w/out.$1"; then echo "prove-red: $2 was NOT caught"; r=1
    else echo "prove-red: $2 was caught ($(grep -c '^FAIL' "$w/out.$1") checks red)"; fi
  }
  plant sentinel "the old sentinel, NOT CHECKED, for the key's own gaps" 's/KEY-NOT-CHECKED/NOT CHECKED/g'
  plant unquoted "true answers not quoted" "s/^q() {.*/q() { printf '%s' \"\$1\"; }/"
  plant copying "Q6 read from COPYING, as before" 's|^for r in gw-survey persona-engine field-comic kid-glove drift; do echo "Q6 $r: $(q6one "$r")"; done|for r in gw-survey persona-engine field-comic kid-glove drift; do echo "Q6 $r: $(head -c 400 "$d/$r/COPYING" 2>/dev/null \| tr -s " \\n" "  " \| grep -o "GNU [A-Z ]*LICENSE Version [0-9]*" \| head -1)"; done|'
  plant noname "Q3 not naming the missing repository" 's/knc Q3 "$(gone field-comic $f)"/knc Q3 "no checkout"/'
  plant blocks "every Org block counted as code" 's/return kind(w\[i + 1\])/return "code"/'
  plant deep "marks deep in code counted, not only headers" 's/if (k == "code" \&\& n > 20) continue//'
  plant script "an HTML <script> counted as prose" 's/if (sc) k = "code"//'
  sed '/no literate recipe/d' "$here/FROM" > "$w/FROM.bad"
  if suite "$orig" "$w/FROM.bad" > "$w/out.from"; then echo "prove-red: a FROM silent about the recipe was NOT caught"; r=1
  else echo "prove-red: a FROM silent about the recipe was caught"; fi
  [ $r = 0 ] && echo "PROVE-RED OK" || echo "PROVE-RED FAILED"
  exit $r
fi

rc=0
lint=$here/../../skills/skill-sign/scripts/skill-lint.sh
if [ -f "$lint" ]; then sh "$lint" -q "$here" > "$w/lint" 2>&1 && echo "ok   skill-lint: description within 1024 chars, name matches" || { echo "FAIL skill-lint -- $(cat "$w/lint")"; rc=1; }
else echo "NOT CHECKED: skill-lint (no $lint)"; fi
suite "$here/scripts/or1ky" "$here/FROM" || rc=1
if [ -n "${OR1KY_CHECKOUTS:-}" ]; then
  sh "$here/scripts/or1ky" "$OR1KY_CHECKOUTS" > "$w/live" 2>&1
  n=$(grep -cE '^Q[1-5] ("|KEY-NOT-CHECKED \()|^Q6 [a-z-]+: ("|KEY-NOT-CHECKED \()' "$w/live")
  if [ "$n" -eq 10 ]; then echo "ok   live key on $OR1KY_CHECKOUTS: 10 lines, each an answer or KEY-NOT-CHECKED"; sed 's/^/     /' "$w/live"
  else echo "FAIL live key on $OR1KY_CHECKOUTS -- $n well-formed lines of 10"; cat "$w/live"; rc=1; fi
else echo "NOT CHECKED: the key on real checkouts (set OR1KY_CHECKOUTS=DIR)"; fi
exit $rc
