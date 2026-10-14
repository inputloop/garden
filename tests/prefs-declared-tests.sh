#!/bin/sh
# prefs-declared-tests.sh -- run the Ruby spec for declared keys, the prefixes, the person writer
# rule and the seatkeeper "no" (tests/prefs-declared-spec.rb; read that first). With --prove-red,
# plant each fault the spec exists to catch, in a copied tree, and show the spec going red on each.
# tier: smoke
# usage: sh tests/prefs-declared-tests.sh [--prove-red]
# Exit 0 green, 1 red, 2 kit broken.
#
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
set -u
here=$(cd "$(dirname "$0")/.." && pwd) || exit 2
# SPEC F1-7: no ruby here is NOT CHECKED and exit 77 (the kit shows LOOK), not "kit broken".
command -v ruby >/dev/null 2>&1 || { echo "prefs-declared tests: NOT CHECKED (no ruby here; install Ruby to check it)"; exit 77; }
spec="$here/tests/prefs-declared-spec.rb"
export PYTHONDONTWRITEBYTECODE=1

if [ "${1:-}" != --prove-red ]; then
  ruby "$spec" "$here"; exit $?
fi

t=$(mktemp -d 2>/dev/null) || { t=${TMPDIR:-/tmp}/prefs-declared-tests.$$; mkdir -p "$t"; }
trap 'rm -rf "$t"' EXIT INT TERM
ruby "$spec" "$here" >/dev/null 2>&1 || { echo "FAIL: the spec is not green on the real tree; prove-red means nothing"; exit 1; }

plant() {   # NAME FILE-IN-TREE OLD NEW [OLD NEW ...] -> a copied tree with the plant in; spec must go red
  name=$1 rel=$2; shift 2; d="$t/$name"
  mkdir -p "$d/bin" "$d/skills" && cp -R "$here/polygram" "$d/" && cp "$here/bin/pr1ef" "$d/bin/" &&
    cp -R "$here/skills/seatkeeper" "$d/skills/" || { echo "kit broken: copy"; exit 2; }
  python3 - "$d/$rel" "$@" <<'PY' || { echo "kit broken: plant $name did not match"; exit 2; }
import sys
p, pairs = sys.argv[1], sys.argv[2:]
s = open(p, encoding="utf-8").read()
for old, new in zip(pairs[::2], pairs[1::2]):
    if s.count(old) != 1:
        sys.exit(1)
    s = s.replace(old, new)
open(p, "w", encoding="utf-8", newline="\n").write(s)
PY
  if ruby "$spec" "$d" > "$t/$name.out" 2>&1; then
    echo "FAIL: plant '$name' left the spec green"; return 1
  fi
  grep -q '^FAIL' "$t/$name.out" || { echo "FAIL: plant '$name' broke the kit, not a check: $(tail -1 "$t/$name.out")"; return 1; }
  echo "red  plant '$name': $(grep -c '^FAIL' "$t/$name.out") check(s) failed, e.g. $(grep -m1 '^FAIL' "$t/$name.out" | cut -c1-90)"
}
r=0
plant any-key-accepted polygram/mcp/prefs.py \
  '    return None, "no reader: not a known key, and no skill declares it in its preferences: list"' \
  '    return "this server", ""' || r=1
plant no-name-check polygram/mcp/prefs.py '            if name not in nm:' '            if False:' || r=1
plant no-writer-rule polygram/mcp/prefs.py \
  '    if t == name or (t == keeper() and name in nm) or (consent or "").strip():' '    if True:' || r=1
plant readback-without-path polygram/mcp/prefs.py \
  '"path": r["value"][4:].strip(),' '"path": "",' \
  'f"you said no to seating {r['"'"'value'"'"'][4:].strip()} on' 'f"you said no to seating a folder on' || r=1
plant awk-ignores-declarations bin/pr1ef 'if (dp[2] != "") { nd++;' 'if (0) { nd++;' || r=1
plant third-party-in-frame polygram/mcp/prefs.py \
  '    if sp and sp[0] == "person." and sp[1] != keeper():' '    if False:' || r=1
plant no-hash-check polygram/mcp/prefs.py '    if key[len(SEAT_NO):] != h:' '    if False:' || r=1
plant room-anyone-writes polygram/mcp/prefs.py \
  '        if t == keeper() or (t in nm and here == tav): #guard:room' '        if True:' || r=1
plant room-any-room polygram/mcp/prefs.py \
  '        if t == keeper() or (t in nm and here == tav): #guard:room' '        if t == keeper() or t in nm:' || r=1
[ $r -eq 0 ] && { echo "PASS: all nine plants turned the spec red"; exit 0; }
exit 1
