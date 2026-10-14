#!/bin/sh
# fp1gk-tests.sh -- the first-person gauge counts each device once, and a mention never.  | --prove-red
# SPEC (turn 2, lane T, 2026-10-10, before the code):
#   F1 "A bare [MINE] is one tag; one in backticks or inside a code fence is none."
#   F2 "'The instrument' (any case) is one; 'the instrument-panel' is none."
#   F3 "'Mentat (for Corwin' or 'Authored by Mentat' more than 8 lines before the end counts once
#       each; in the last 8 lines (a footer and its licence notice), or inside double quotes, none."
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
set -u
here=$(cd "$(dirname "$0")/.." && pwd); G="sh $here/bin/fp1gk"
t=$(mktemp -d); trap 'rm -rf "$t"' EXIT
pass=0; fail=0
ok()  { pass=$((pass+1)); echo "ok   $1"; }
bad() { fail=$((fail+1)); echo "FAIL $1 -- $2"; }
{ echo '# f'; echo 'A reading [MINE] stands.'; echo 'The tag `[MINE]` is retired.'; echo '```'; echo '[HIS] in a fence'; echo '```'
  echo 'The instrument reads it; see the instrument-panel skill.'; echo 'Written by Mentat (for Corwin) mid-page.'
  echo 'The form is "Authored by Mentat (for Corwin)".'; for i in 1 2 3 4 5 6 7 8 9; do echo "line $i"; done
  echo 'Authored by Mentat (for Corwin; claude-opus-5-5).'; echo 'SPDX-License-Identifier: CC-BY-SA-4.0'; } > "$t/a.md"
$G "$t/a.md" > "$t/o"
want="TOTAL tags 1|TOTAL instrument 1|TOTAL third 1|TOTAL byline 1"
got=$(grep '^TOTAL' "$t/o" | paste -sd'|' -)
[ "$got" = "$want" ] && ok "F1-F3 each device once; mentions, fences and the footer not at all" || bad counts "got '$got' want '$want'"
if [ "${1:-}" = --prove-red ]; then
  sed 's/`\[MINE\]`/[MINE]/' "$t/a.md" > "$t/b.md"; got=$($G "$t/b.md" | grep '^TOTAL tags')
  [ "$got" = "TOTAL tags 2" ] && ok "prove-red: the backticks taken off a mention make it count (red against F1's 1)" || bad prove-red "$got"
fi
echo "TOTAL pass=$pass fail=$fail"; [ $fail -eq 0 ]
