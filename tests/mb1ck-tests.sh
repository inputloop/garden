#!/bin/sh
# mb1ck-tests.sh -- bin/mb1ck against a fresh mint, and against faults planted on purpose.
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.  GPL-3.0-or-later.
cd "$(dirname "$0")/.." || exit 2
PYTHON=${PYTHON:-python3}
t=${TMPDIR:-/tmp}/mb1ck-tests.$$
mkdir -p "$t"; trap 'rm -rf "$t"' EXIT INT TERM
fail=0; n=0
ok()  { n=$((n+1)); echo "  PASS  $1"; }
no()  { n=$((n+1)); fail=$((fail+1)); echo "  FAIL  $1"; }
PYTHONDONTWRITEBYTECODE=1 $PYTHON -m polygram.mcpb --out "$t" >/dev/null || { echo "mint failed"; exit 1; }
sh bin/mb1ck "$t/vibrobeast.mcpb" >/dev/null && ok "a fresh mint is clean" || no "a fresh mint is clean"
PYTHONDONTWRITEBYTECODE=1 $PYTHON -m polygram.mcpb --manifest > "$t/m.json"
sh bin/mb1ck "$t/m.json" >/dev/null && ok "the manifest alone is clean" || no "the manifest alone is clean"
# prove-red: each planted fault must be caught
plant() { # label, sed expression
  sed "$2" "$t/m.json" > "$t/bad.json"
  if cmp -s "$t/m.json" "$t/bad.json"; then no "$1 (the plant changed nothing)"; return; fi
  sh bin/mb1ck "$t/bad.json" >/dev/null && no "$1" || ok "$1"
}
plant "a settings field renamed away from its use goes red" 's/^    "tavern_data": {/    "tavern_folder": {/'
plant "PYTHONPATH in env goes red" 's/^      "env": {/      "env": {\n        "PYTHONPATH": "x",/'
plant "cmd /s goes red" 's|^\( *\)"/d",|\1"/s",|'
plant "a tool listed twice goes red" '0,/"name": "seat_read"/s/"name": "seat_list"/"name": "seat_read"/'
echo "mb1ck-tests: $((n-fail))/$n"
[ "$fail" -eq 0 ]
