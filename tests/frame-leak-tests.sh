#!/bin/sh
# frame-leak-tests.sh [--prove-red] -- the tests must never write into the user's real usage frame.
# SPEC (F1, pass 2, P5 O1/J2): tests/test_mcp_spans.py points the frame at its temp folder BEFORE
# it turns usage.capture on; test_capture_never_touches_the_real_frame compares the real default
# frame's presence, size and mtime before and after. Runs under a scratch HOME, so neither the
# green run nor the plant can touch your own ~/.mentcached/stats/fr.
# --prove-red plants the old order (capture on first, frame moved after) in a scratch copy of the
# test file; the guard test must go red.
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
set -u
T=$(cd "$(dirname "$0")" && pwd -P); G=$(dirname "$T")
command -v python3 >/dev/null 2>&1 || { echo "frame-leak tests: NOT CHECKED (no python3)"; exit 77; }
W=$(mktemp -d "${TMPDIR:-/tmp}/frleak.XXXXXX"); trap 'rm -rf "$W"' EXIT INT TERM
mkdir -p "$W/home" "$W/t"
run() { # dir-with-test -> exit code of the guard test
  ( cd "$G" && HOME=$W/home PYTHONPATH=$G PYTHONDONTWRITEBYTECODE=1 \
      python3 -m unittest discover -s "$1" -p test_mcp_spans.py -k test_capture_never_touches_the_real_frame ) > "$W/out" 2>&1
}
if [ "${1:-}" = --prove-red ]; then
  python3 - "$T/test_mcp_spans.py" "$W/t/test_mcp_spans.py" <<'PY'
import sys
s = open(sys.argv[1], encoding="utf-8").read()
a = s.index("        #frame-first\n"); b = s.index("        #frame-first-end\n") + len("        #frame-first-end\n")
block, s = s[a:b], s[:a] + s[b:]
anchor = '            prefs.set_("usage.capture", value, "test", "")\n'
i = s.index(anchor) + len(anchor)
open(sys.argv[2], "w", encoding="utf-8").write(s[:i] + block + s[i:])
PY
  cmp -s "$T/test_mcp_spans.py" "$W/t/test_mcp_spans.py" && { echo "frame-leak prove-red: MISS (the plant changed nothing)"; exit 1; }
  run "$W/t"; rc=$?
  if [ $rc -ne 0 ] && grep -q "a test wrote into the real frame" "$W/out"; then
    echo "frame-leak prove-red: RED  old order (capture on, then frame moved) wrote into the real frame -- 0 missed"; exit 0
  fi
  echo "frame-leak prove-red: MISS (the old order stayed green; rc=$rc)"; tail -5 "$W/out"; exit 1
fi
run "$T"; rc=$?
if [ $rc -eq 0 ] && [ ! -s "$W/home/.mentcached/stats/fr" ]; then
  echo "frame-leak tests: PASS (1/1; the real frame under HOME stayed untouched)"; exit 0
fi
echo "frame-leak tests: FAIL (rc=$rc)"; tail -8 "$W/out"; exit 1
