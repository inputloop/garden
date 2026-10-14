#!/bin/sh
# tg1rs-tests.sh -- runs the Ruby spec (tests/tg1rs-spec.rb) against bin/tg1rs.
# tier: smoke
# usage: sh tests/tg1rs-tests.sh | --prove-red      (run from the AS4CE0001 root)
# --prove-red plants two faults in scratch copies of the tool (back links never read; the hop cap
# removed) and each must turn the spec red.
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
set -u
here=$(cd "$(dirname "$0")/.." && pwd)
command -v ruby >/dev/null 2>&1 || { echo "NOT CHECKED: no ruby"; exit 77; }
if [ "${1:-}" != --prove-red ]; then ruby "$here/tests/tg1rs-spec.rb"; exit $?; fi
t=$(mktemp -d 2>/dev/null) || { t=${TMPDIR:-/tmp}/tg1rs-pr.$$; mkdir -p "$t"; }
trap 'rm -rf "$t"' EXIT INT TERM
red=0
plant() { # plant NAME SED-EXPR
  sed "$2" "$here/bin/tg1rs" > "$t/tg1rs"
  if cmp -s "$t/tg1rs" "$here/bin/tg1rs"; then echo "FAIL plant $1 did not change the tool"; red=1; return; fi
  if TG1RS_BIN="$t/tg1rs" timeout 60 ruby "$here/tests/tg1rs-spec.rb" > "$t/o" 2>&1; then
    echo "FAIL prove-red: plant '$1' stayed green"; red=1
  else echo "ok   prove-red: plant '$1' went red ($(grep -c '^FAIL' "$t/o") spec rows)"; fi
}
plant "back links never read" 's/^LEADS=leads-to$/LEADS=leads-nope/'
plant "no hop cap" 's/^MAXHOPS=4$/MAXHOPS=40/'
plant "sweep takes every word" 's/else if (w in known) print/else print/'
[ $red -eq 0 ] && echo "prove-red PASS" || { echo "prove-red FAIL"; exit 1; }
