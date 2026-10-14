#!/bin/sh
# interp-77-tests.sh [--prove-red] -- a runner that cannot find its interpreter says NOT CHECKED and
# exits 77, everywhere (SPEC F1-7, pass 2, P6 O3/J2 and idea 1).
#   I1 (static, awk) every tests/*-tests.sh line of the form `command -v tclsh|ruby|perl ... || {`
#      ends in `exit 77`, and every runner that calls tclsh, ruby or perl has such a guard.
#   I2 (behaviour) with tclsh and ruby taken off PATH, each runner that needs one prints
#      NOT CHECKED and exits 77 -- never 0 (the kit would count it green) and never 2.
# --prove-red plants `exit 0` into a scratch copy of qg1ck-tests.sh's guard; I1 must go red.
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
set -u
T=$(cd "$(dirname "$0")" && pwd -P); G=$(dirname "$T")
W=$(mktemp -d "${TMPDIR:-/tmp}/i77.XXXXXX"); trap 'rm -rf "$W"' EXIT INT TERM
static() { # DIR -> prints offending lines; exit 1 when any
  awk '
    FNR == 1 { if (prev != "" && uses[prev] && !guard[prev]) { printf "  FAIL  I1 %s calls tclsh/ruby/perl with no command -v guard\n", prev; bad++ } prev = FILENAME }
    /^[ \t]*#/ || FILENAME ~ /interp-77-tests\.sh$/ { next }   # comments, and this checker itself
    /command -v (tclsh|ruby|perl)/ && /\|\|/ { guard[FILENAME] = 1
      if ($0 !~ /exit 77/) { printf "  FAIL  I1 %s:%d a missing interpreter does not exit 77: %s\n", FILENAME, FNR, $0; bad++ } }
    /if command -v (tclsh|ruby|perl)/ { guard[FILENAME] = 1 }
    /^[^#]*(^|[ ;(|&])(tclsh|ruby|perl)( |$)/ && !/command -v/ { uses[FILENAME] = 1 }
    END { if (prev != "" && uses[prev] && !guard[prev]) { printf "  FAIL  I1 %s calls tclsh/ruby/perl with no command -v guard\n", prev; bad++ }
          exit bad ? 1 : 0 }' "$1"/*-tests.sh
}
if [ "${1:-}" = --prove-red ]; then
  mkdir -p "$W/t"; cp "$T"/*-tests.sh "$W/t/"
  sed '/command -v tclsh/s/exit 77/exit 0/' "$T/qg1ck-tests.sh" > "$W/t/qg1ck-tests.sh"
  cmp -s "$T/qg1ck-tests.sh" "$W/t/qg1ck-tests.sh" && { echo "interp-77 prove-red: MISS (the plant changed nothing)"; exit 1; }
  if static "$W/t" > "$W/out"; then echo "interp-77 prove-red: MISS (exit 0 on a missing tclsh stayed green)"; exit 1; fi
  grep -q 'qg1ck-tests.sh' "$W/out" && { echo "interp-77 prove-red: RED  I1 caught qg1ck-tests exiting 0 with no tclsh -- 0 missed"; exit 0; }
  echo "interp-77 prove-red: MISS"; cat "$W/out"; exit 1
fi
fails=0
if static "$T" > "$W/out"; then echo "  PASS  I1 every interpreter guard in tests/*-tests.sh exits 77"
else cat "$W/out"; fails=$((fails+1)); fi
# I2: a PATH with everything in /usr/bin and /bin except tclsh* and ruby*
mkdir -p "$W/path"
for d in /usr/local/bin /usr/bin /bin; do
  for x in "$d"/*; do n=${x##*/}
    case $n in tclsh*|ruby*|wish*) continue ;; esac
    [ -e "$W/path/$n" ] || ln -s "$x" "$W/path/$n" 2>/dev/null
  done
done
for r in qg1ck rd1ck lc1ck pr1ef prefs-declared spans-reset br1in; do
  [ -f "$T/$r-tests.sh" ] || continue
  out=$(PATH=$W/path sh "$T/$r-tests.sh" 2>&1); rc=$?
  if [ $rc -eq 77 ] && printf '%s' "$out" | grep -q 'NOT CHECKED'; then echo "  PASS  I2 $r-tests with no tclsh/ruby: NOT CHECKED, exit 77"
  else echo "  FAIL  I2 $r-tests with no tclsh/ruby: exit $rc ($(printf '%s' "$out" | tail -1 | cut -c1-80))"; fails=$((fails+1)); fi
done
[ $fails -eq 0 ] && { echo "interp-77 tests: PASS"; exit 0; }
echo "interp-77 tests: FAIL ($fails)"; exit 1
