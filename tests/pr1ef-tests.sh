#!/bin/sh
# pr1ef-tests.sh -- run the Ruby spec for the preferences readers ("a row is reported or applied,
# never dropped"), and with --prove-red plant a dropped row, once in prefs.py (Python) and once in
# bin/pr1ef (awk): each plant must turn the spec red. Spec: tests/pr1ef-spec.rb (read that first).
# tier: smoke
# usage: sh tests/pr1ef-tests.sh [--prove-red]      (from the AS4CE0001 root, or anywhere)
# Exit 0 green, 1 red, 2 kit broken.
#
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
set -u
here=$(cd "$(dirname "$0")/.." && pwd) || exit 2
command -v ruby >/dev/null 2>&1 || { echo "pr1ef tests: NOT CHECKED (no ruby here; install Ruby to check it)"; exit 77; }  # F1-7
spec="$here/tests/pr1ef-spec.rb"

if [ "${1:-}" != --prove-red ]; then
  ruby "$spec" "$here"; exit $?
fi

t=$(mktemp -d 2>/dev/null) || { t=${TMPDIR:-/tmp}/pr1ef-tests.$$; mkdir -p "$t"; }
trap 'rm -rf "$t"' EXIT INT TERM
ruby "$spec" "$here" >/dev/null 2>&1 || { echo "FAIL: the spec is not green on the real tree; prove-red means nothing"; exit 1; }

plant() {   # NAME FILE-IN-TREE OLD NEW -> a copied tree with one line planted; spec must go red
  name=$1 rel=$2 old=$3 new=$4 d="$t/$1"
  mkdir -p "$d/bin" && cp -R "$here/polygram" "$d/" && cp "$here/bin/pr1ef" "$d/bin/" || { echo "kit broken: copy"; exit 2; }
  python3 - "$d/$rel" "$old" "$new" <<'PY' || { echo "kit broken: plant $name did not match"; exit 2; }
import sys
p, old, new = sys.argv[1:4]
s = open(p, encoding="utf-8").read()
if s.count(old) != 1:
    sys.exit(1)
open(p, "w", encoding="utf-8", newline="\n").write(s.replace(old, new))
PY
  if ruby "$spec" "$d" "$here/tests/fixtures/lane-a/prefs-mixed.tsv" > "$t/$name.out" 2>&1; then
    echo "FAIL: plant '$name' left the spec green"; return 1
  fi
  echo "red  plant '$name': $(grep -c '^FAIL' "$t/$name.out") check(s) failed, e.g. $(grep -m1 '^FAIL' "$t/$name.out" | cut -c1-90)"
}
r=0
plant python-drops polygram/mcp/prefs.py \
  '        who, why_not = reader(f[1], decl if decl is not None else {}, names)
' '        who, why_not = reader(f[1], decl if decl is not None else {}, names)
        if who is None:
            continue
' || r=1
plant awk-drops bin/pr1ef \
  'if (reader($2) == "") { st[n] = "ignored"; why[n] = why_not; next }' 'if (reader($2) == "") { n--; next }' || r=1
[ $r -eq 0 ] && { echo "PASS: both planted drops turned the spec red"; exit 0; }
exit 1
