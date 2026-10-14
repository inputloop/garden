#!/bin/sh
# rd1ck-tests.sh [--prove-red] -- runs the Ruby spec tests/rd1ck-spec.rb on bin/rd1ck; with
# --prove-red, each guard is planted out in a scratch copy and the spec must go red.
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
set -u
T=$(cd "$(dirname "$0")" && pwd -P); G=$(dirname "$T")
# SPEC F1-7: no ruby here is NOT CHECKED and exit 77 (the kit shows LOOK), never a pass.
command -v ruby >/dev/null 2>&1 || { echo "rd1ck tests: NOT CHECKED (no ruby here; install Ruby to check it)"; exit 77; }
W=$(mktemp -d "${TMPDIR:-/tmp}/rd1ck-t.XXXXXX"); trap 'rm -rf "$W"' EXIT INT TERM
if [ "${1:-}" = --prove-red ]; then
  echo "rd1ck prove-red: planting each guard out; the named spec line must go red"
  miss=0
  try() { # name spec-id sed
    sed "$3" "$G/bin/rd1ck" > "$W/rd.$1"
    if cmp -s "$G/bin/rd1ck" "$W/rd.$1"; then echo "  MISS  $1: the plant did not change the file"; miss=$((miss+1)); return; fi
    ruby "$T/rd1ck-spec.rb" "$W/rd.$1" > "$W/out.$1" 2>&1
    if grep -q "^  FAIL  $2" "$W/out.$1"; then echo "  RED   $1: $2 went red as planned"
    else echo "  MISS  $1: $2 stayed green"; miss=$((miss+1)); fi
  }
  try fence-off RD2 '/#guard:fence/s/return 0/return 1/'
  try read-off RD4 '/#guard:read/s/if \[ -r "\$p" \]/if [ -r "$p" ] \&\& false/'
  try say-absent RD1 's/NOT REACHED; seat/absent; seat/'
  try no-parent RD3 's/parent listed: %s; request/request/'
  try exists-is-read 'RD6 a target that gives no line back' '/#guard:readback/s/-gt 0/-ge 0/'
  try reader-blind 'RD6 a reader program' '/#guard:reader/s/return 0 ;;/return 1 ;;/'
  try shared-blind RD7 '/#guard:shared/s/n\[w\] > 1/n[w] > 9/'
  try tsv-source RD5 's/edit the Markdown, never this/generated/'
  echo "rd1ck prove-red: $miss missed"; [ "$miss" -eq 0 ]; exit $?
fi
echo "rd1ck tests (Ruby runner)"
ruby "$T/rd1ck-spec.rb" "$G/bin/rd1ck"; n=$?
[ $n -eq 0 ] && echo "rd1ck tests: PASS" || echo "rd1ck tests: FAIL"
exit $n
