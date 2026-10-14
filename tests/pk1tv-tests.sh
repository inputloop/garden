#!/bin/sh
# pk1tv-tests.sh — expected behaviours for bin/pk1tv (the persona-kits usage table).
# usage: sh tests/pk1tv-tests.sh | --prove-red      (run from the AS4CE0001 root)
# Copyright 2026 Corwin Brust <corwin@bru.st> — GPLv3-or-later. Authored by Fable 2026-09-12.
#
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
set -u
here=$(cd "$(dirname "$0")/.." && pwd); P="$here/bin/pk1tv"; K="$here/h/KITS-2026-09-12-usage.tsv"; export PYTHONDONTWRITEBYTECODE=1
t=${TMPDIR:-/tmp}/pk1tv-tests.$$; mkdir -p "$t"; pass=0; fail=0
ok() { pass=$((pass+1)); echo "ok   $1"; }; bad() { fail=$((fail+1)); echo "FAIL $1 — $2"; }
printf 'kit\tstep\ttabletop\titassisted\tinsight_tabletop\tinsight_it\nA\t1\tx\ty\ti1 · i2\t\nA\t2\tx\ty\t\tj\nA\t3\tx\ty\t\t\nB\t1\tx\ty\t\t\nB\t2\tx\ty\t\t\nB\t3\tx\ty\t\t\n' > "$t/ok.tsv"
python3 "$P" --lint "$t/ok.tsv" >/dev/null && ok "lint-clean" || bad "lint-clean" "faulted"
python3 "$P" --html "$t/ok.tsv" > "$t/v.html" && ok "html-runs" || bad "html-runs" "rc"
[ "$(grep -o '<tbody><tr class="grp">' "$t/v.html" | wc -l)" -eq 2 ] && ok "html-two-row-groups" || bad "html-groups" "$(grep -c 'class="grp"' "$t/v.html")"
[ "$(grep -o '<details class="ins"><summary>insight</summary>' "$t/v.html" | wc -l)" -eq 2 ] && ok "html-disclosure-triangles-where-insight" || bad "html-details" "count"
grep -q '<li>i1</li><li>i2</li>' "$t/v.html" && ok "html-insight-items-split" || bad "html-items" "no"
grep -q 'scope="col"' "$t/v.html" && grep -q 'scope="rowgroup"' "$t/v.html" && grep -q '<caption>' "$t/v.html" && ok "html-accessible-table" || bad "html-a11y" "missing scope/caption"
grep -q 'summary:focus-visible' "$t/v.html" && ok "html-keyboard-focus-state" || bad "html-focus" "no"
python3 "$P" --html "$t/ok.tsv" --body | grep -q '<!doctype' && bad "body-only" "has doctype" || ok "body-only-fragment"
python3 "$P" --text "$t/ok.tsv" | grep -q '^== A ==' && python3 "$P" --text "$t/ok.tsv" | grep -q 'insight: i1 · i2' && ok "text-view" || bad "text-view" "no"
printf 'kit\tstep\ttabletop\titassisted\nA\t1\t\ty\nA\t2\tx\ty\nA\t3\tx\ty\n' > "$t/empty.tsv"; python3 "$P" --lint "$t/empty.tsv" >/dev/null 2>&1; [ $? -eq 1 ] && ok "lint-empty-cell-faults" || bad "lint-empty" "rc"
printf 'kit\tstep\ttabletop\titassisted\nA\t1\tx\ty\nB\t1\tx\ty\nA\t2\tx\ty\nA\t3\tx\ty\nB\t2\tx\ty\nB\t3\tx\ty\n' > "$t/order.tsv"; python3 "$P" --lint "$t/order.tsv" | grep -q 'out of its group' && ok "lint-group-order" || bad "lint-order" "no"
printf 'kit\tstep\ttabletop\titassisted\nA\t1\tx\ty\nA\t2\tx\ty\n' > "$t/few.tsv"; python3 "$P" --lint "$t/few.tsv" | grep -q 'need >= 3' && ok "lint-min-steps" || bad "lint-min" "no"
python3 "$P" --html "$t/empty.tsv" >/dev/null 2>&1; [ $? -eq 1 ] && ok "html-refuses-faulty-record" || bad "html-refuse" "rc"
printf 'kit\tstep\ttabletop\titassisted\tinsight_tabletop\tinsight_it\nA\t1\tx\ty\tGOOD: one \302\267 two \302\267 three, a long enough item here.\t\nA\t2\tx\ty\t\t\nA\t3\tx\ty\t\t\n' > "$t/frag.tsv"; python3 "$P" --lint "$t/frag.tsv" | grep -q 'fragment' && ok "lint-insight-fragment-collision" || bad "lint-fragment" "no"
python3 "$P" --prove-red | grep -q '^PASS' && ok "self-prove-red" || bad "self-prove-red" "no"
if [ -f "$K" ]; then python3 "$P" --lint "$K" > "$t/kl" 2>&1 && ok "live-record-lint-clean" || bad "live-record" "$(cat "$t/kl")"; python3 "$P" --lint "$K" | grep -q '4 kit(s)' && ok "live-record-four-kits" || bad "live-four" "$(tail -1 "$t/kl")"; fi
if [ "${1:-}" = "--prove-red" ]; then
  before=$fail; [ "$(grep -o '<tbody><tr class="grp">' "$t/v.html" | wc -l)" -eq 3 ] && ok "PLANTED" || bad "PLANTED-wrong-expectation" "planted"
  rm -rf "$t"; [ "$fail" -eq $((before+1)) ] && { echo "PASS: harness correctly went red under a planted bad expectation"; exit 0; } || { echo "FAIL: harness did not go red"; exit 1; }
fi
rm -rf "$t"; echo "TOTAL pass=$pass fail=$fail"; [ "$fail" -eq 0 ]
