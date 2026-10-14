#!/bin/sh
# pub-stage.sh -- stage one polygram release onto the public shelf clone at pub/.
#
# Copyright (C) 2026 Corwin Brust <corwin@bru.st>.  Authored by Mentat (for Corwin).
# SPDX-License-Identifier: GPL-3.0-or-later.  WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
#
# The shelf (code.bru.st/corwin/vibrobeast) is a release shelf: signed artifacts, not source. pub/ is
# a detached clone of it inside this tree (gitignored here). This copies what `make dist` and
# `bin/release VERSION --apply` left in dist/ for VERSION into pub/releases/polygram-curation-VERSION/
# and writes SHA256SUMS beside them. It never signs, commits or pushes: those are the keeper's.
# Run it again after `bin/release --apply` and the .asc files it made are carried too.
#
# usage: sh tools/pub-stage.sh VERSION [PUBDIR]      (PUBDIR default: ./pub)
#        sh tools/pub-stage.sh --check VERSION [PUBDIR]   say what is staged and what is missing; copy nothing
# exit:  0 staged (or, with --check, complete) · 1 something is missing · 2 usage
set -u
check=0; [ "${1:-}" = --check ] && { check=1; shift; }
v=${1:?usage: pub-stage.sh [--check] VERSION [PUBDIR]}
printf '%s' "$v" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$' || { echo "pub-stage: $v is not x.y.z" >&2; exit 2; }
top=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd) || exit 2
pub=${2:-$top/pub}
[ -d "$pub/.git" ] || { echo "pub-stage: no shelf clone at $pub (git clone https://code.bru.st/corwin/vibrobeast pub)" >&2; exit 2; }
d=$top/dist; out=$pub/releases/polygram-curation-$v
want="polygram-curation-$v.tar.gz polygram-curation-$v.zip polygram-curation-$v.MANIFEST vibrobeast.plugin"
miss=0; asc=0
for f in $want; do [ -f "$d/$f" ] || { echo "MISSING  dist/$f (make dist RELEASE=$v first)"; miss=1; }; done
grep -q "\"version\": \"$v\"" "$d/vibrobeast/.claude-plugin/plugin.json" 2>/dev/null \
  || { echo "MISSING  dist/vibrobeast is not version $v"; miss=1; }
for f in $want; do [ -f "$d/$f.asc" ] && asc=$((asc+1)) || echo "UNSIGNED dist/$f.asc absent (bin/release $v --apply makes it)"; done
[ "$miss" = 0 ] || exit 1
if [ "$check" = 0 ]; then
  mkdir -p "$out" || exit 1
  for f in $want; do cp "$d/$f" "$out/"; [ -f "$d/$f.asc" ] && cp "$d/$f.asc" "$out/"; done
  n=0; for s in "$d"/*.skill; do [ -f "$s" ] || continue; cp "$s" "$out/"; n=$((n+1)); done
  ( cd "$out" && ls | grep -v '^SHA256SUMS$' | LC_ALL=C sort | while IFS= read -r f; do sha256sum "$f"; done > SHA256SUMS )
  echo "staged   $out: 4 artifacts, $n .skill bundles, $asc of 4 detached signatures, SHA256SUMS"
else
  [ -d "$out" ] && echo "present  $out ($(ls "$out" | wc -l | tr -d ' ') files)" || echo "absent   $out"
fi
[ "$asc" = 4 ] || { echo "next     sh bin/release $v --apply, then run this again"; exit 1; }
exit 0
