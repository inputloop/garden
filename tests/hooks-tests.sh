#!/bin/sh
# hooks-tests.sh -- polygram/hooks.md: one countable row per hook, each naming a place that exists.
# SPEC (2026-10-10, lane C task C5): "one countable row per hook named; a hook row whose act is not in
# the tree is a fault."  Rows are the table lines under "## The hooks" whose first cell is a hook name.
# SPEC (F3, review pass 3, C6 O6/J2): every row is counted, none skipped.  A row's "where it lives" cell
# either names a backticked path that is in the tree, or says, in those words, "not yet a hook: proposed";
# a row with neither is a fault.  The count line says how many rows have an act and how many are proposed.
# --prove-red: a scratch copy with a row pointing at a missing folder must go red, and so must one whose
# proposed row loses its words (no path, no "not yet a hook").
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
set -u
here=$(cd "$(dirname "$0")/.." && pwd)
pass=0; fail=0
ok()  { pass=$((pass+1)); echo "ok   $1"; }
bad() { fail=$((fail+1)); echo "FAIL $1 -- $2"; }
rows() { awk -F'|' '/^## The hooks/ {f=1; next} /^## / {f=0} f && /^\| [a-z-]+ \|/ && $2 !~ /hook/ {
  h=$2; gsub(/ /,"",h); w=$5; p=""; if (match(w, /`[^`]+`/)) p=substr(w, RSTART+1, RLENGTH-2)
  else if (index(w, "not yet a hook: proposed")) p="PROPOSED"; print h "\t" p }' "$1"; }
check() { # check FILE -> prints faults; returns count
  nf=0
  rows "$1" > "${TMPDIR:-/tmp}/hk.$$"
  while IFS='	' read -r h p; do
    if [ -z "$p" ]; then echo "  row $h names no place and does not say \"not yet a hook: proposed\""; nf=$((nf+1)); continue; fi
    [ "$p" = PROPOSED ] && continue
    [ -e "$here/$p" ] || { echo "  row $h names $p, which is not in the tree"; nf=$((nf+1)); }
  done < "${TMPDIR:-/tmp}/hk.$$"
  rm -f "${TMPDIR:-/tmp}/hk.$$"; return $nf; }
f="$here/polygram/hooks.md"
n=$(rows "$f" | wc -l | tr -d ' ')
# 6 since 2026-10-11: the interrupted row (proposed), h/ENHANCE-2026-10-11-interrupted-hook.md.
[ "$n" -eq 6 ] && ok "hooks.md names 6 hooks: $(rows "$f" | cut -f1 | tr '\n' ' ')" || bad count "expected 6 hook rows, found $n"
np=$(rows "$f" | awk -F'\t' '$2 == "PROPOSED"' | wc -l | tr -d ' ')
ok "count: $((n - np)) hook(s) with an act in the tree, $np proposed (not yet a hook), 0 skipped"
out=$(check "$f") && ok "every hook's act is in the tree" || bad places "$out"
if [ "${1:-}" = --prove-red ]; then
  t=$(mktemp -d); trap 'rm -rf "$t"' EXIT
  sed 's#`skills/session-rotate/`#`skills/no-such-skill/`#' "$f" > "$t/hooks.md"
  if check "$t/hooks.md" >/dev/null; then bad prove-red "a row naming a missing folder passed"
  else ok "prove-red: a row naming a missing folder goes red"; fi
  sed 's#not yet a hook: proposed#a promise#' "$f" > "$t/hooks2.md"
  cmp -s "$f" "$t/hooks2.md" && bad prove-red-2 "the proposed plant changed nothing"
  if check "$t/hooks2.md" >/dev/null; then bad prove-red-2 "a row with no place and no proposed words passed"
  else ok "prove-red: a row with no place and no \"not yet a hook: proposed\" goes red"; fi
fi
echo "TOTAL pass=$pass fail=$fail"
[ "$fail" -eq 0 ]
