#!/bin/sh
# git-read-locks-tests -- every git status, diff or describe that the shipped scripts run carries
# --no-optional-locks (or GIT_OPTIONAL_LOCKS=0), so a read never takes .git/index.lock.
#
# Copyright (C) 2026 Corwin Brust <corwin@bru.st>.  Authored by Mentat (for Corwin).
# SPDX-License-Identifier: GPL-3.0-or-later.  This program is free software: you can redistribute it
# and/or modify it under the terms of the GNU General Public License, version 3 or (at your option)
# any later version.  WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
#
# Why (2026-09-29, the sandboxer skill): a plain `git status` opens .git/index.lock to refresh its
# cache and unlinks it when nothing changed; on a mount that refuses deletes the unlink fails and the
# lock stays, and every later add or commit fails until a hand removes it.
#
# usage: sh tests/git-read-locks-tests.sh [--prove-red]
# Scans: bin/*, skills/*/scripts/*, SOFT-SKILLS/*/scripts/*, tests/*.sh (shell lines) and
# polygram/**.py, skills/*/scripts/*.py (a "git" ... "status" argument list).  Comment lines are skipped.
set -u
here=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd) || exit 2
SH_RE='(^|[^A-Za-z_-])git( +-C +[^ ]+| +--?[A-Za-z-]+(=[^ ]+)?)* +(status|diff|describe)( |$|"|\))'
PY_RE='"git"[^]]*"(status|diff|describe)"'
scan() {  # ROOT -> offending lines, one per line
  ( cd "$1" || exit 2
    for f in bin/* skills/*/scripts/* SOFT-SKILLS/*/scripts/* tests/*.sh; do
      [ -f "$f" ] || continue
      grep -n -E "$SH_RE" "$f" 2>/dev/null | grep -v -E '^[0-9]+:[[:space:]]*#' \
        | grep -v -e '--no-optional-locks' -e 'GIT_OPTIONAL_LOCKS=0' | sed "s|^|$f:|"
    done
    find polygram skills -name '*.py' -type f 2>/dev/null | while IFS= read -r f; do
      grep -n -E "$PY_RE" "$f" 2>/dev/null | grep -v -e 'no-optional-locks' -e 'GIT_OPTIONAL_LOCKS' | sed "s|^|$f:|"
    done ) | grep -v '^tests/git-read-locks-tests.sh:'
}
out=$(scan "$here")
if [ -z "$out" ]; then echo "ok   every git status/diff/describe in the shipped scripts reads without the index lock"; rc=0
else printf 'FAIL a git read that takes the index lock:\n%s\n' "$out"; rc=1; fi
if [ "${1:-}" = --prove-red ]; then
  t=$(mktemp -d) || exit 2; mkdir -p "$t/bin" "$t/polygram"
  printf '#!/bin/sh\ngit -C "$x" status --porcelain\n' > "$t/bin/a"
  printf '#!/bin/sh\n# git status in a comment is fine\ngit --no-optional-locks diff --stat\n' > "$t/bin/b"
  printf 'subprocess.run(["git", "-C", r, "status"])\n' > "$t/polygram/c.py"
  red=$(scan "$t"); rm -rf "$t"
  n=$(printf '%s\n' "$red" | grep -c .)
  if [ "$n" = 2 ] && printf '%s' "$red" | grep -q '^bin/a:' && printf '%s' "$red" | grep -q '^polygram/c.py:'; then
    echo "PASS: prove-red caught the two planted reads (sh and python) and let the flagged one and the comment pass"
  else echo "FAIL: prove-red found $n (wanted 2): $red"; rc=1; fi
fi
exit $rc
