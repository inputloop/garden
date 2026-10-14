#!/bin/sh
# safety-2026-10-04-tests -- the two garden fixes from the Technology Architecture review
# (H:\ta turn-2026-09-30, wave P12B), held to the live tree, each in a language other than
# the code it checks:
#   B5U-007  caller text with a line break in the memory store (append, cite, bless) wrote a
#            second front-matter line or log record a reader took for real: a JAILED note read
#            back SEATED, a citer who never called, a blessing under any name.  Checked by
#            tests/store-line-breaks.sh (sh + awk over the bytes; the store is Python).
#   B5U-003  SOFT-SKILLS/prior-instruction never said WHOSE words count as an instruction.
#            Checked by tests/prior-instruction-speaker.awk (awk; the skill is prose).
#
# Copyright (C) 2026 Corwin Brust <corwin@bru.st>.  Authored by Mentat (for Corwin).
# SPDX-License-Identifier: GPL-3.0-or-later.  WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
# The two checkers were written by the P12B wave (Claude, 2026-09-30) and are carried unchanged
# but for the path of fm-dupkeys.sh.
#
# usage: sh tests/safety-2026-10-04-tests.sh [--prove-red]
#   --prove-red  also runs both checkers on the pre-fix copies kept in archive/2026-10-04-safety/
#                and requires each to go RED.
set -u
top=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd) || exit 2
A=$top/archive/2026-10-04-safety
rc=0
copy() {  # DEST [unfixed] -> a COPY_ROOT holding polygram/ and bin/dl2-verify.sh
  mkdir -p "$1/bin" && cp -r "$top/polygram" "$1/" && cp "$top/bin/dl2-verify.sh" "$1/bin/" || exit 2
  find "$1" -name __pycache__ -prune -exec rm -rf {} + 2>/dev/null
  if [ "${2:-}" = unfixed ]; then
    cp "$A/polygram__mcp__store.py" "$1/polygram/mcp/store.py"
    cp "$A/polygram__mcp__dl2.py"   "$1/polygram/mcp/dl2.py"
  fi
}
t=$(mktemp -d) || exit 2; trap 'rm -rf "$t"' EXIT
copy "$t/live"
if sh "$top/tests/store-line-breaks.sh" "$t/live" >"$t/s.out" 2>&1; then echo "ok   B5U-007 store refuses line breaks (live tree)"
else echo "FAIL B5U-007 store line breaks (live tree)"; sed 's/^/     /' "$t/s.out"; rc=1; fi
if awk -f "$top/tests/prior-instruction-speaker.awk" "$top/SOFT-SKILLS/prior-instruction/SKILL.md" >"$t/p.out" 2>&1
then echo "ok   B5U-003 prior-instruction says whose words count (live tree)"
else echo "FAIL B5U-003 prior-instruction speaker (live tree)"; sed 's/^/     /' "$t/p.out"; rc=1; fi
if sh "$top/tests/fm-dupkeys.sh" --prove-red >"$t/f.out" 2>&1; then echo "ok   fm-dupkeys --prove-red"
else echo "FAIL fm-dupkeys --prove-red"; sed 's/^/     /' "$t/f.out"; rc=1; fi
if [ "${1:-}" = --prove-red ]; then
  copy "$t/old" unfixed
  if sh "$top/tests/store-line-breaks.sh" "$t/old" >/dev/null 2>&1; then echo "FAIL prove-red: B5U-007 checker stayed green on the pre-fix store"; rc=1
  else echo "ok   prove-red: B5U-007 checker goes red on the pre-fix store"; fi
  if awk -f "$top/tests/prior-instruction-speaker.awk" "$A/SOFT-SKILLS__prior-instruction__SKILL.md" >/dev/null 2>&1
  then echo "FAIL prove-red: B5U-003 checker stayed green on the pre-fix skill"; rc=1
  else echo "ok   prove-red: B5U-003 checker goes red on the pre-fix skill"; fi
fi
exit "$rc"
