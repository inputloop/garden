#!/bin/sh
# sp1rp-tests.sh -- the awk reader agrees with the MCP server on the same bytes, and filters work.
# tier: smoke
# usage: sh tests/sp1rp-tests.sh | --prove-red      (run from the AS4CE0001 root)
# Copyright 2026 Corwin Brust <corwin@bru.st> -- GPLv3-or-later. Authored by Mentat (for Corwin).
#
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
set -u
here=$(cd "$(dirname "$0")/.." && pwd); R="sh $here/bin/sp1rp"
t=$(mktemp -d 2>/dev/null) || { t=${TMPDIR:-/tmp}/sp1rp-tests.$$; mkdir -p "$t"; }
trap 'rm -rf "$t"' EXIT INT TERM
pass=0; fail=0
ok()  { pass=$((pass+1)); echo "ok   $1"; }
bad() { fail=$((fail+1)); echo "FAIL $1 -- $2"; }
has() { if grep -q -e "$2" "$3"; then ok "$1"; else bad "$1" "no /$2/ in output: $(head -3 "$3" | tr '\n' '|')"; fi; }

# The server writes; the awk reader reads the same file. Cross-language agreement is the test.
export MENTCACHED_STATS="$t/spans.tsv"; export MENTCACHED_SEAT="$t/seat"; mkdir -p "$t/seat"
: > "$MENTCACHED_STATS"
# Paths reach python as ARGUMENTS, never inside the -c text: under msys2 a mingw python gets
# argv paths converted (/tmp/x -> C:\msys64\tmp\x) and a path buried in code does not, which is
# how this file's cross-check read a file that "was not there" on avalon (2026-09-23).
py() { PYTHONDONTWRITEBYTECODE=1 python3 -c '
import json,sys
sys.path.insert(0, sys.argv[1])
from polygram.mcp import mentcached
srv=mentcached.build(by="t")
for name,args in json.loads(sys.argv[2]): print(json.dumps(srv.call(name,args)))
' "$here" "$1"; }
py '[["span_start",{"label":"build","tokens_left":5000}],["span_mark",{"tokens_left":4000,"note":"half"}],["span_stop",{"tokens_left":3500,"outcome":"done"}],["span_start",{"label":"think"}]]' > "$t/py.out" 2>&1 || bad "server writes the ledger" "$(tail -2 "$t/py.out")"
[ -s "$MENTCACHED_STATS" ] && ok "server wrote $MENTCACHED_STATS" || bad "ledger" "empty"

$R --tsv > "$t/o" 2>&1; rc=$?
[ $rc -eq 0 ] && ok "reader exits 0" || bad "reader rc" "$rc: $(cat "$t/o")"
has "reader: tokens 5000-3500 = 1500 on the closed span" '	build	.*	1500	0$' "$t/o"
has "reader: the open span is open, time only" '	think	.*		1$' "$t/o"
$R > "$t/o" 2>&1
has "human view names the label and 1500 tokens" 'build .*1500 tokens' "$t/o"
has "human view says time only for the open one" 'OPEN .*think .*time only' "$t/o"
has "human view rolls up by label" '^-- by label:' "$t/o"
has "human view totals" '^-- 2 span(s)' "$t/o"
$R --open --tsv > "$t/o" 2>&1; [ "$(wc -l < "$t/o" | tr -d ' ')" = 1 ] && ok "--open keeps only the open span" || bad "--open" "$(cat "$t/o")"
$R --label build --tsv > "$t/o" 2>&1; has "--label narrows" '^[^	]*	build	' "$t/o"; hasnt=$(grep -c think "$t/o"); [ "$hasnt" = 0 ] && ok "--label excludes the rest" || bad "--label" "think leaked"
$R --since 2999-01-01 > "$t/o" 2>&1; has "--since in the future finds nothing" '^no spans' "$t/o"
# cross-check: the server's own report must agree with awk on seconds and tokens for the closed span
py '[["span_report",{"label":"build"}]]' > "$t/rep.json" 2>&1
srv_tok=$(python3 -c 'import json,sys;print(json.load(open(sys.argv[1]))["tokens"])' "$t/rep.json")
awk_tok=$($R --label build --tsv | awk -F'\t' '{print $6}')
[ "$srv_tok" = "$awk_tok" ] && ok "server and awk agree on tokens ($srv_tok)" || bad "cross-check" "server $srv_tok vs awk $awk_tok"
MENTCACHED_STATS="$t/absent.tsv" $R > "$t/o" 2>&1; [ $? -eq 1 ] && ok "a missing ledger exits 1 and says so" || bad "missing ledger" "$(cat "$t/o")"
$R --prove-red > "$t/o" 2>&1 && ok "sp1rp --prove-red passes" || bad "sp1rp --prove-red" "$(tail -2 "$t/o")"

if [ "${1:-}" = --prove-red ]; then
  before=$fail; has "PLANTED (must FAIL)" 'this text is not there' "$t/o" >/dev/null
  if [ $fail -gt $before ]; then echo "PASS: harness correctly went red under a planted bad expectation"; exit 0; fi
  echo "FAIL: harness could not go red"; exit 1
fi
echo "TOTAL pass=$pass fail=$fail"; [ $fail -eq 0 ]
