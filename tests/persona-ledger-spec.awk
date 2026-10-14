# persona-ledger-spec.awk -- the awk reading of tests/persona-ledger-SPEC.txt (rows L1-L8).
# Reads one generated LEDGER.md and checks it against the fixture it was built from.
# The work is Python (polygram/mcp/persona.py); the earlier persona tests are Python and Perl,
# so this check is awk (DESIGN-extension-edition.md, task B3).
#
# usage: awk -f persona-ledger-spec.awk -v base=DIR -v nsheets=N -v diverged=NAME \
#            -v sha_a=HEX -v sha_b=HEX -v ghost=NAME -v secret=WORD -v pmname=NAME \
#            -v pmword=WORD -v propword=WORD LEDGER.md
# Prints "PASS Ln ..." / "RED Ln ..." per row; exit 0 when every row is green, 1 otherwise.
#
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later

function trim(s) { sub(/^[ \t]+/, "", s); sub(/[ \t]+$/, "", s); return s }
function red(row, why) { print "RED  " row " " why; if (!(row in bad)) nbad++; bad[row] = 1 }
function cells(line, arr,    n, i) {          # "| a | b |" -> arr[1..n]
  sub(/^\|/, "", line); sub(/\|[ \t]*$/, "", line)
  n = split(line, arr, / \| /)
  for (i = 1; i <= n; i++) arr[i] = trim(arr[i])
  return n
}
function isrow(line) { return line ~ /^\| / && line !~ /^\|---/ }
function lineof(path, n,    i, l, got) {        # line n of file base/path, or "" when missing
  got = ""
  for (i = 1; (getline l < path) > 0; i++) if (i == n) { got = l; break }
  close(path)
  return got
}
BEGIN {
  numw[0]="zero"; numw[1]="one"; numw[2]="two"; numw[3]="three"; numw[4]="four"; numw[5]="five"
  numw[6]="six"; numw[7]="seven"; numw[8]="eight"; numw[9]="nine"; numw[10]="ten"
}
{ all = all $0 "\n" }
/^## / { sec = substr($0, 4); hdr = 1; secs[++nsec] = sec; next }
sec == "Read-back in words" { rb = rb $0 " "; if ($0 ~ /^\|/) red("L1", "the read-back holds a table line") }
sec == "Sheets" && isrow($0) {
  if (hdr) { hdr = 0; next }                     # the header row
  n = cells($0, c); rows++
  if (c[1] == pmname) red("L6", "a person model is a row: " c[1])
  if (c[1] == diverged) {
    dv = c[7]
    if (index(dv, "DIVERGED") == 0) red("L4", "the twin that differs is not DIVERGED on " c[1])
    if (index($0, sha_a) == 0 || index($0, sha_b) == 0) red("L4", "both sha256s not shown in full on " c[1])
    seen_div = 1
  }
}
sec == "Edges in the sheets" && isrow($0) {
  if (hdr) { hdr = 0; next }
  n = cells($0, c); nedges++
  if (c[2] == ghost) red("L3", "a name no sheet is was shown as an edge: " c[2])
  if (c[1] == pmname || c[2] == pmname) red("L6", "a person model is named in an edge")
  w = c[4]; k = split(w, wp, ":"); ln = wp[k] + 0; f = substr(w, 1, length(w) - length(wp[k]) - 1)
  src = lineof(base "/" f, ln)
  if (src == "") red("L2", "edge row cites a line that does not exist: " w)
  else if (c[2] != "a person model" && index(tolower(src), tolower(c[2])) == 0)
    red("L2", "the cited line does not name the target " c[2] ": " w)
  else if (c[3] !~ /^\(withheld/ && index(src, c[3]) == 0)
    red("L2", "the cited line does not hold the edge's words: " w)
  if (c[2] == "a person model" && c[3] !~ /^\(withheld/) red("L6", "an edge to a person model shows its words")
}
sec == "Faults" && isrow($0) {
  if (hdr) { hdr = 0; next }
  n = cells($0, c)
  if (c[1] == ghost && c[2] ~ /:[0-9]+$/) fault_ghost = 1
}
sec ~ /^Proposed by review/ { prop = prop $0 "\n"; if (isrow($0) && $0 !~ /^\|[- |]+\|$/ && $0 !~ /^\| carrier /) nprop++ }
END {
  # L1: one row per served sheet, and the same count in words and numerals in the read-back
  if (rows != nsheets) red("L1", "sheet rows " rows ", want " nsheets)
  if (index(rb, numw[nsheets] " (" nsheets ") persona sheets") == 0)
    red("L1", "the read-back does not say " numw[nsheets] " (" nsheets ") persona sheets")
  # L3: the ghost is a fault, by name, file and line
  if (!fault_ghost) red("L3", "no fault row names " ghost " with its file and line")
  # L4
  if (!seen_div) red("L4", "no row for " diverged)
  # L5: a third-party fact elsewhere in a sheet never appears
  if (index(all, secret)) red("L5", "a sheet line outside the head, version and inverse section was printed: " secret)
  # L6: a person model is never named; its edge words are withheld
  if (index(all, pmword)) red("L6", "a person model's edge words were printed")
  if (all ~ ("(^|[^a-z0-9-])" pmname "([^a-z0-9-]|$)")) red("L6", "the person model's name appears: " pmname)
  # L7: proposed edges only in their own section
  t = all; np = 0; while ((i = index(t, propword)) > 0) { np++; t = substr(t, i + 1) }
  if (index(prop, propword) == 0) red("L7", "the proposed edge is missing from its own section")
  if (np != 1) red("L7", "the proposed words appear " np " times; want once, in the proposed section")
  # L9: proposed lines deduped to distinct (from, to, claim); the read-back counts lines, distinct
  # edges, pairs and the proposing hand
  if (nprop != 2) red("L9", "proposed rows " nprop ", want 2 distinct (from, to, claim) edges")
  if (index(rb, "Three (3) proposed edge rows were read (raw, before dedupe); two (2) are distinct (from, to, claim) edges, between one (1) distinct (from, to) pair") == 0)
    red("L9", "the read-back does not count raw lines, distinct edges and pairs")
  if (index(rb, "one model: claude-opus") == 0) red("L9", "the read-back does not name the one proposing hand")
  # L8: the words read-back of what the model was shown is the last section
  if (secs[nsec] != "What the model was shown") red("L8", "the last section is '" secs[nsec] "'")
  split("L1 L2 L3 L4 L5 L6 L7 L8 L9", ids, " ")
  for (i = 1; i <= 9; i++) if (!(ids[i] in bad)) print "PASS " ids[i]
  exit (nbad ? 1 : 0)
}
