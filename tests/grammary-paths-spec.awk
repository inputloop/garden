# grammary-paths-spec.awk -- every source-tree path GRAMMARY.md names is in the mint, or says it is not.
# The work is a document (GRAMMARY.md, shipped as bytes by polygram/plugin.py, Python); the earlier
# GRAMMARY tests are sh and Tcl (tests/gm1gk-*), so this spec is awk.
# usage: awk -f grammary-paths-spec.awk MINTLIST GRAMMARY.md
#        MINTLIST: one path a line, relative to the minted plugin's root (`find . | sed 's#^\./##'`).
# SPEC (F3, review pass 3, C6 O8/J6 -- candor-gate gate 5, "no dangling routes", on our own mint):
#   P1 "A backticked path in GRAMMARY.md that names a place in the source tree or the author's C4 tree
#       (first part one of: skills polygram bin SOFT-SKILLS conventions tests advice book h memory models
#       records Inbox dist c4 projects persona-ledger canon .door .eclipse-increments) is either in the
#       mint, or is followed later on its own line by the marker."
#   P2 "The marker never directly follows a path that IS in the mint."
#   P3 "Before the first entry, one sentence says what the marker means."
# The marker (turn 2, lane T, 2026-10-10): the glyph †, read by the legend line "A path marked † ...".
#   It replaced the 74 copies of "(in the author's tree, not shipped)": S9 rule 7, "say where things
#   are once".
# Prints ok/FAIL rows and TOTAL; exit 1 on any FAIL.  Reads only.
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
BEGIN { MARK = "†"
        PRE = "^(skills|polygram|bin|SOFT-SKILLS|conventions|tests|advice|book|h|memory|models|records|Inbox|dist|c4|projects|persona-ledger|canon|\\.door|\\.eclipse-increments)/" }
FNR == NR { p = $0; sub(/\/$/, "", p); mint[p] = 1; next }
function inmint(w,   d) {
  sub(/\/$/, "", w)
  if (w in mint) return 1
  if (index(w, "*")) { d = substr(w, 1, index(w, "*") - 1); sub(/\/[^\/]*$/, "", d); return (d in mint) }
  return 0
}
/^[ \t]*(```|~~~)/ { fence = !fence; next }
fence { next }
/^### / && !firstentry { firstentry = FNR }
index($0, "marked " MARK) && !firstentry { told = FNR }
{
  rest = $0; off = 0
  while (match(rest, /`[^`]+`/)) {
    tok = substr(rest, RSTART + 1, RLENGTH - 2); end = off + RSTART + RLENGTH - 1
    after = substr($0, end + 1)
    n = split(tok, w, /[ \t]+/)
    for (i = 1; i <= n; i++) if (w[i] ~ PRE) {
      paths++
      if (inmint(w[i])) {
        if (index(after, " " MARK) == 1) { bad("P2 " FILENAME ":" FNR " `" w[i] "` is in the mint but marked not shipped") }
      } else if (!index(after, MARK)) { bad("P1 " FILENAME ":" FNR " `" w[i] "` is not in the mint and not marked") }
      else marked++
    }
    off = end; rest = substr($0, end + 1)
  }
}
function bad(m) { fail++; print "FAIL " m }
END {
  if (told) { pass++; print "ok   P3 line " told " says what the marker means, before the first entry" }
  else bad("P3 no sentence before the first entry says what " MARK " means")
  if (!fail) { pass++; print "ok   P1/P2 " paths + 0 " source-tree path(s) read; " marked + 0 " marked not shipped; every other one is in the mint" }
  print "TOTAL pass=" pass + 0 " fail=" fail + 0
  exit (fail > 0)
}
