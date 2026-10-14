#!/bin/sh
# spans-reset-tests.sh -- run the Tcl spec for the span reset (S-R1), and with --prove-red plant
# the old subtraction, once in the server (Python) and once in bin/sp1rp (awk): each plant must
# turn the spec red. Spec: tests/spans-reset-spec.tcl (read that first).
# tier: smoke
# usage: sh tests/spans-reset-tests.sh [--prove-red]      (from the AS4CE0001 root, or anywhere)
# Exit 0 green, 1 red, 2 kit broken.
#
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
set -u
here=$(cd "$(dirname "$0")/.." && pwd) || exit 2
command -v tclsh >/dev/null 2>&1 || { echo "spans-reset tests: NOT CHECKED (no tclsh here; install Tcl to check it)"; exit 77; }  # F1-7
spec="$here/tests/spans-reset-spec.tcl"

if [ "${1:-}" != --prove-red ]; then
  tclsh "$spec" "$here"; exit $?
fi

t=$(mktemp -d 2>/dev/null) || { t=${TMPDIR:-/tmp}/spans-reset.$$; mkdir -p "$t"; }
trap 'rm -rf "$t"' EXIT INT TERM
tclsh "$spec" "$here" >/dev/null 2>&1 || { echo "FAIL: the spec is not green on the real tree; prove-red means nothing"; exit 1; }

plant() {   # NAME FILE-IN-TREE OLD NEW -> a copied tree with one line planted; spec must go red
  name=$1 rel=$2 old=$3 new=$4 d="$t/$1"
  mkdir -p "$d/bin" && cp -R "$here/polygram" "$d/" && cp "$here/bin/sp1rp" "$d/bin/" || { echo "kit broken: copy"; exit 2; }
  python3 - "$d/$rel" "$old" "$new" <<'PY' || { echo "kit broken: plant $name did not match"; exit 2; }
import sys
p, old, new = sys.argv[1:4]
s = open(p, encoding="utf-8").read()
if s.count(old) != 1:
    sys.exit(1)
open(p, "w", encoding="utf-8", newline="\n").write(s.replace(old, new))
PY
  if tclsh "$spec" "$d" > "$t/$name.out" 2>&1; then
    echo "FAIL: plant '$name' left the spec green"; return 1
  fi
  echo "red  plant '$name': $(grep -c '^FAIL' "$t/$name.out") check(s) failed, e.g. $(grep -m1 '^FAIL' "$t/$name.out" | cut -c1-90)"
}
r=0
plant python-subtracts polygram/mcp/spans.py \
  'return prev is not None and now is not None and now > prev' 'return False' || r=1
plant awk-subtracts bin/sp1rp \
  'if (last[id]!="" && f+0 > last[id]+0) resets[id]++' 'if (0) resets[id]++' || r=1
[ $r -eq 0 ] && { echo "PASS: both plants of the old subtraction turned the spec red"; exit 0; }
exit 1
