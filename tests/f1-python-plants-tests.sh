#!/bin/sh
# f1-python-plants-tests.sh [--prove-red] -- the Python-side F1 (pass 2) fixes, each with a plant.
#   Q1 question_log writes the question rows bin/qg1ck reads (tests/test_mcp_spans.py)
#   O1 seat_mode quotes the preferences in force at session open (tests/test_mcp_f1_open.py)
#   O2 a person sees only their own person rows at their first turn (same file)
# Green: the named tests pass. --prove-red: each plant, in a scratch copy of polygram/, turns its
# test red. Runs under a scratch HOME, so nothing touches your own ~/.mentcached.
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
set -u
T=$(cd "$(dirname "$0")" && pwd -P); G=$(dirname "$T")
command -v python3 >/dev/null 2>&1 || { echo "f1-python-plants: NOT CHECKED (no python3)"; exit 77; }
W=$(mktemp -d "${TMPDIR:-/tmp}/f1pp.XXXXXX"); trap 'rm -rf "$W"' EXIT INT TERM
mkdir -p "$W/home"
ut() { # ROOT FILE TEST -> exit of that one test
  ( cd "$1" && HOME=$W/home PYTHONPATH=$1 PYTHONDONTWRITEBYTECODE=1 \
      python3 -m unittest discover -s "$G/tests" -t "$G/tests" -p "$2" -k "$3" ) > "$W/out" 2>&1
}
if [ "${1:-}" != --prove-red ]; then
  f=0
  ut "$G" test_mcp_spans.py test_question_log && echo "  PASS  Q1 question_log writes the rows qg1ck reads" || { echo "  FAIL  Q1"; tail -5 "$W/out"; f=1; }
  ut "$G" test_mcp_f1_open.py test_session_open && echo "  PASS  O1 seat_mode quotes the preferences in force" || { echo "  FAIL  O1"; tail -5 "$W/out"; f=1; }
  ut "$G" test_mcp_f1_open.py test_a_person_sees && echo "  PASS  O2 a person sees only their own rows" || { echo "  FAIL  O2"; tail -5 "$W/out"; f=1; }
  [ $f -eq 0 ] && echo "f1-python-plants: PASS (3/3)"; exit $f
fi
miss=0
plant() { # NAME FILE OLD NEW TESTFILE TEST
  d=$W/p-$1; mkdir -p "$d"; cp -R "$G/polygram" "$d/"
  python3 - "$d/$2" "$3" "$4" <<'PY' || { echo "  MISS  $1: the plant did not match"; miss=$((miss+1)); return; }
import sys
p, old, new = sys.argv[1:4]
s = open(p, encoding="utf-8").read()
if s.count(old) != 1:
    sys.exit(1)
open(p, "w", encoding="utf-8").write(s.replace(old, new))
PY
  if ut "$d" "$5" "$6"; then echo "  MISS  $1: $6 stayed green"; miss=$((miss+1))
  else echo "  RED   $1: $6 went red as planned"; fi
}
plant writer-drops-confidence polygram/mcp/spans.py 'CONFIDENCE=_clean(confidence), NOTE=_clean(note))' 'CONFIDENCE="", NOTE=_clean(note))' test_mcp_spans.py test_question_log
plant no-open-quote polygram/mcp/mentcached.py 'q = _prefs.quote(turn) #guard:quote' 'q = ""' test_mcp_f1_open.py test_session_open
plant third-party-quoted polygram/mcp/prefs.py 'if t and t != keeper() and sp and sp[0] == "person." and sp[1] != t:' 'if False:' test_mcp_f1_open.py test_a_person_sees
echo "f1-python-plants prove-red: $miss missed"; [ $miss -eq 0 ]
