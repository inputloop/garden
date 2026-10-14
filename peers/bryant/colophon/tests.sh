#!/bin/sh
# tests.sh -- colophon, garden edition: the attribution ladder and no one's terms in the code.
#
# Spec, written fresh for these tests (POSIX sh driving the CLI; colophon is Python): colophon
# says NOT CHECKED, never a guess, when no parties file names a keeper.  A file that holds more than
# 15 lines first seen in another party's own sources names that party as a maker and narrows its
# terms to what both offer; 4 to 15 such lines credit them instead, and the check wants the credits
# to name them.  Nothing is fetched unless --fetch is given.  A check with only one reader is NOT
# CHECKED unless --one-reader says the keeper accepts one.  Bryant's own selftest still passes.
#
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later
# usage: sh tests.sh [--prove-red]
here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
COL=${COLOPHON:-$here/scripts/colophon.py}
PY=${PYTHON:-python3}
T=$(mktemp -d "${TMPDIR:-/tmp}/colophon-garden.XXXXXX"); trap 'rm -rf "$T"' EXIT INT TERM
pass=0; fail=0
ok() { pass=$((pass + 1)); [ -z "${VERBOSE:-}" ] || echo "ok    $1"; }   # always returns 0
no() { fail=$((fail + 1)); echo "FAIL  $1"; }
run() { "$PY" "$COL" "$@" > "$T/out" 2>&1; echo $?; }

fixture() { # a tree, Corwin's dated sources, and the parties file
  rm -rf "$T/w" "$T/corwin" "$T/bryant"; mkdir -p "$T/w/skills/k" "$T/w/skills/q" "$T/corwin" "$T/bryant"
  i=1; while [ $i -le 20 ]; do
    printf 'Corwin wrote this distinctive line of his, number %s.\n' $i >> "$T/corwin/k.md"
    printf 'Bryant wrote this distinctive line of his, number %s.\n' $i >> "$T/bryant/b.md"
    i=$((i + 1)); done
  { printf -- '---\nname: k\ndescription: d\n---\n# K\n'; cat "$T/corwin/k.md"; } > "$T/w/skills/k/SKILL.md"
  { printf -- '---\nname: q\ndescription: d\n---\n# Q\n'; head -8 "$T/corwin/k.md"; cat "$T/bryant/b.md"; } > "$T/w/skills/q/SKILL.md"
  printf '# Fixture\n\nMade by Bryant.\n' > "$T/w/README.md"
  cp "$here/references/parties.example.json" "$T/w/.colophon-parties.json"
}
SRC="--sources corwin=$T/corwin@2026-06-27 --sources bryant=$T/bryant@2026-09-17"

suite() {
  fixture; rm "$T/w/.colophon-parties.json"
  rc=$(run check "$T/w" --one-reader)
  [ "$rc" = 2 ] && grep -q "NOT CHECKED: no .colophon-parties.json" "$T/out" && ok "no parties file: NOT CHECKED" || no "no parties file: want NOT CHECKED, exit 2 (got $rc)"

  fixture; sed 's/"_keeper": "bryant",//' "$T/w/.colophon-parties.json" > "$T/p" && mv "$T/p" "$T/w/.colophon-parties.json"
  rc=$(run plan "$T/w")
  [ "$rc" = 2 ] && grep -q "no keeper" "$T/out" && ok "no keeper named: NOT CHECKED" || no "no keeper: want NOT CHECKED (got $rc)"

  fixture
  rc=$(run who "$T/w" $SRC --no-git)
  grep -q "MAKERS   skills/k/SKILL.md  Bryant Frankford, Corwin Brust" "$T/out" && ok "more than 15 of his lines: Corwin is a maker" || no "20 lines from Corwin's sources did not make him a maker"
  grep -q "lines, 20 lines" "$T/out" && ok "the evidence says how many lines" || no "no line count in the evidence"
  grep -q "MAKERS   skills/q/SKILL.md" "$T/out" && no "8 of his lines made Corwin a maker of q" || ok "8 of his lines do not make a maker"
  grep -q "CREDIT   Corwin Brust shaped 1 file(s): q" "$T/out" && ok "8 of his lines credit him" || no "8 lines did not credit Corwin"

  rc=$(run plan "$T/w" $SRC --no-git)
  grep -q "skills/k/SKILL.md  \[CC-BY-SA-4.0\]" "$T/out" && grep -q "makers: Bryant Frankford, Corwin Brust" "$T/out" && ok "plan names both makers, prose terms both offer" || no "plan does not name both makers on k"

  "$PY" "$COL" apply "$T/w" $SRC --no-git > "$T/out" 2>&1
  rc=$(run check "$T/w" $SRC --no-git --one-reader)
  grep -q "UNCREDITED Corwin Brust" "$T/out" && [ "$rc" = 1 ] && ok "credit owed and not given: a finding" || no "an uncredited influence passed (rc $rc)"
  printf '\nCredits: the quoted lines in q are Corwin Brust'"'"'s.\n' >> "$T/w/README.md"
  rc=$(run check "$T/w" $SRC --no-git --one-reader)
  [ "$rc" = 0 ] && ok "once the credits name him, the check is clean" || { no "credited tree not clean (rc $rc)"; sed 's/^/      /' "$T/out" | head -8; }
  if command -v reuse >/dev/null 2>&1; then ok "reuse is installed: the two-reader rule is read in the selftest"
  else rc=$(run check "$T/w" $SRC --no-git)
    [ "$rc" = 2 ] && grep -q "NOT CHECKED as a whole" "$T/out" && ok "one reader alone: NOT CHECKED" || no "one reader alone passed (rc $rc)"
  fi

  fixture; mkdir -p "$T/w/skills/n/scripts"
  printf -- '---\nname: n\ndescription: d\n---\n# N\n\nCopyright 2026 Corwin Brust <corwin@bru.st> and Bryant Frankford\n' > "$T/w/skills/n/SKILL.md"
  printf '#!/bin/sh\necho made by the keeper alone\n' > "$T/w/skills/n/scripts/n.sh"
  "$PY" "$COL" who "$T/w" --no-git > "$T/out" 2>&1
  grep -q "skills/n/scripts/n.sh" "$T/out" && no "a notice in SKILL.md made Corwin a maker of the skill's other files" || ok "a notice speaks for its own file only"

  fixture; mkdir -p "$T/w/skills/c"
  printf -- '---\nname: c\ndescription: d\n---\n# C\n\n## Credits\n\nAlfred (for Bryant): the findings behind this fix.\n' > "$T/w/skills/c/SKILL.md"
  "$PY" "$COL" who "$T/w" --no-git > "$T/out" 2>&1
  sed 's/"_keeper": "bryant"/"_keeper": "corwin"/' "$T/w/.colophon-parties.json" > "$T/p" && mv "$T/p" "$T/w/.colophon-parties.json"
  "$PY" "$COL" who "$T/w" --no-git > "$T/out" 2>&1
  grep -q "MAKERS   skills/c/SKILL.md" "$T/out" && no "a line in a Credits section made its subject a maker" || ok "a Credits section credits; it does not make a maker"

  mkdir -p "$T/bare"; cp "$COL" "$T/bare/colophon.py"
  rc=$("$PY" "$T/bare/colophon.py" texts "$T/dest" GPL-3.0-or-later > "$T/out" 2>&1; echo $?)
  [ "$rc" = 2 ] && grep -q "\-\-fetch was not given" "$T/out" && ok "no pinned copy and no --fetch: nothing fetched" || no "texts reached for the network without --fetch (rc $rc)"

  rc=$("$PY" "$COL" --selftest > "$T/out" 2>&1; echo $?)
  [ "$rc" = 0 ] && ok "Bryant's selftest still passes ($(grep -o '[0-9]* checks pass' "$T/out"))" || no "Bryant's selftest fails on the garden edition"
}

if [ "${1:-}" = --prove-red ]; then
  bad=0
  # the control: the unplanted suite must be green, or a red plant proves nothing
  if sh "$0" > "$T/control" 2>&1; then echo "green control: the suite passes unplanted"
  else echo "FAIL control: the suite is red before any plant"; sed 's/^/      /' "$T/control" | tail -5; exit 1; fi
  plant() { # NAME OLD NEW
    sed "s|$2|$3|" "$here/scripts/colophon.py" > "$T/planted.py"
    cmp -s "$T/planted.py" "$here/scripts/colophon.py" && { echo "FAIL plant $1: its target is not in the source"; bad=1; return; }
    mkdir -p "$T/pl/scripts" "$T/pl/references"; cp "$T/planted.py" "$T/pl/scripts/colophon.py"
    cp "$here/scripts/at1ld.py" "$T/pl/scripts/"; cp -r "$here/scripts/LICENSES" "$T/pl/scripts/" 2>/dev/null
    cp "$here/references/parties.example.json" "$T/pl/references/"
    if COLOPHON="$T/pl/scripts/colophon.py" sh "$0" > "$T/plout" 2>&1; then echo "FAIL plant $1: the suite stayed green"; bad=1
    else echo "red  $1: caught"; fi
  }
  plant "ideas owned again" '"idea": "credit", "lineage": "credit"' '"idea": "owner", "lineage": "owner"'
  plant "a keeper baked in" '^KEEPER = None' 'KEEPER = "bryant"'
  plant "lines ignored" 'if n > LADDER_LINES:' 'if False:'
  plant "fetch by default" 'FETCH = "--fetch" in flags' 'FETCH = True'
  plant "one reader is enough" 'and not one_reader:' 'and False:'
  plant "notices spread to the whole skill" 'if e\[1\] != "notice"\]' ']'
  plant "credits read as bylines" '"credited" if no in credits_at and how != "notice" else how' 'how'
  [ $bad = 0 ] && echo "colophon garden tests --prove-red: every planted fault caught" || echo "colophon garden tests --prove-red: FAILED"
  exit $bad
fi
suite
echo "colophon garden tests: $pass passed, $fail failed"
[ $fail = 0 ]
