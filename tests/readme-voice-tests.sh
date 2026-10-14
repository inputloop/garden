#!/bin/sh
# readme-voice-tests.sh -- runs tests/readme-voice-spec.rb on the README polygram/plugin.py mints now,
# and (--prove-red) on that README with a planted distancing line and with the partners cut.
# NOT CHECKED, exit 77, with no ruby or no python3 here.
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
set -u
here=$(cd "$(dirname "$0")/.." && pwd); spec="$here/tests/readme-voice-spec.rb"
command -v ruby >/dev/null 2>&1 && command -v python3 >/dev/null 2>&1 || { echo "readme-voice tests: NOT CHECKED (needs ruby and python3)"; exit 77; }
t=$(mktemp -d); trap 'rm -rf "$t"' EXIT
pass=0; fail=0
ok()  { pass=$((pass+1)); echo "ok   $1"; }
bad() { fail=$((fail+1)); echo "FAIL $1 -- $2"; }
( cd "$here" && PYTHONDONTWRITEBYTECODE=1 python3 -c 'import sys; from polygram import plugin; sys.stdout.write(plugin.readme_text())' ) > "$t/R.md" || { echo "readme-voice tests: could not render the README"; exit 1; }
ruby "$spec" "$t/R.md" > "$t/o" 2>&1 && ok "the README as minted now: $(grep -c '^ok' "$t/o") spec rows" || bad live "$(grep FAIL "$t/o")"
if [ "${1:-}" = --prove-red ]; then
  sed 's/^The keeper is .*//; s/Corwin Brust: this began/Corwin Brust, the author: this began/' "$t/R.md" > "$t/r1"
  ruby "$spec" "$t/r1" > "$t/o" 2>&1 && bad prove-red-1 "a README calling Corwin 'the author' passed" || ok "prove-red: 'the author' planted goes red ($(grep -c '^FAIL' "$t/o") FAIL rows)"
  sed 's/Corwin Brust and Bryant Frankford keep and share together/Corwin Brust keeps/' "$t/R.md" > "$t/r2"
  ruby "$spec" "$t/r2" > "$t/o" 2>&1 && bad prove-red-2 "a README with one partner passed" || ok "prove-red: the partners cut goes red ($(grep -c '^FAIL' "$t/o") FAIL rows)"
  sed 's/^Corwin put the need in one line: /The need in one line: /' "$t/R.md" > "$t/r3"
  ruby "$spec" "$t/r3" > "$t/o" 2>&1 && bad prove-red-3 "an unnamed quotation passed" || ok "prove-red: an unnamed quotation goes red ($(grep -c '^FAIL' "$t/o") FAIL rows)"
fi
echo "TOTAL pass=$pass fail=$fail"; [ $fail -eq 0 ]
