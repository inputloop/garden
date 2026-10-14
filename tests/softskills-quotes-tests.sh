#!/bin/sh
# softskills-quotes-tests.sh -- the dynaloader lists YAML-quoted names and descriptions without the
# quotes (spec: tests/softskills-quotes-SPEC.txt).  The judging is awk, not python.
# tier: smoke
# usage: sh tests/softskills-quotes-tests.sh | --prove-red      (run from the AS4CE0001 root)
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
set -u
here=$(cd "$(dirname "$0")/.." && pwd)
plant=0; [ "${1:-}" = "--prove-red" ] && plant=1
t=$(mktemp -d 2>/dev/null) || { t=${TMPDIR:-/tmp}/ssq.$$; mkdir -p "$t"; }
trap 'rm -rf "$t"' EXIT INT TERM
mk() { mkdir -p "$t/root/$1"; printf -- '---\nname: %s\ndescription: %s\n---\n\n# %s\n' "$2" "$3" "$1" > "$t/root/$1/SKILL.md"; }
mk dq '"dq"' '"A \"double\" one."'
mk sq "'sq'" "'It''s single.'"
mk pl 'pl' 'Plain "mid" text.'
mk lone '"lone' 'One quote.'
list() {  # name <TAB> declared_name <TAB> description, one per line, from the python loader
  ( cd "$here" && SOFT_SKILLS="$1" PYTHONDONTWRITEBYTECODE=1 PLANT=$plant python3 -c '
import os, sys; sys.path.insert(0, ".")
from polygram.mcp import softskills as s
s.OWN = None
if os.environ["PLANT"] == "1": s._unquote = lambda v: v
for k in s.scan()["skills"]: print(k["name"], k.get("declared_name",""), k["description"], sep="\t")' )
}
list "$t/root" > "$t/o" 2>"$t/e" || { echo "FAIL loader: $(cat "$t/e")"; exit 1; }
list "$here/SOFT-SKILLS" > "$t/live" 2>>"$t/e"
awk -F'\t' -v plant=$plant '
  FNR==NR { d[$1]=$2; s[$1]=$3; next }
  $1=="parallax" { lp=$2 } $1=="gauntlet" { lg=substr($3,1,1) }
  function ck(n, c) { if (c) { p++; print "ok   " n } else { f++; print "FAIL " n } }
  END {
    ck("Q1 double-quoted name reads dq", d["dq"]=="dq")
    ck("Q2 escaped quotes read as quotes", s["dq"]=="A \"double\" one.")
    ck("Q3 single-quoted name and doubled quote", d["sq"]=="sq" && s["sq"]=="It'"'"'s single.")
    ck("Q4 plain scalar unchanged", d["pl"]=="pl" && s["pl"]=="Plain \"mid\" text.")
    ck("Q5 a lone quote is kept", d["lone"]=="\"lone")
    ck("Q6 live: parallax declared_name is parallax", lp=="parallax")
    ck("Q6 live: gauntlet description has no leading quote", lg!="\"")
    printf "TOTAL pass=%d fail=%d\n", p, f
    exit (f>0)
  }' "$t/o" "$t/live"
rc=$?
if [ $plant -eq 1 ]; then
  if [ $rc -ne 0 ]; then echo "prove-red PASS: the planted loader (no unquote) went red"; exit 0
  else echo "prove-red FAIL: the plant stayed green"; exit 1; fi
fi
exit $rc
