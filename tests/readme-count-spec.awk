# readme-count-spec.awk -- the minted README's facts, checked against the code they come from.
# The work (polygram/plugin.py) and its earlier tests (tests/test_plugin.py) are Python; the server count
# in shipped prose drifted before ("three servers" with six shipped), so this spec is in awk.
# usage: awk -f readme-count-spec.awk FACTS README       FACTS: lines "server NAME", "floor NAME",
#        "key KEY<TAB>DEFAULT", dumped from SERVERS, editions.FLOOR and prefs.KNOWN by the wrapper.
#        awk -v mode=gauge -f readme-count-spec.awk FACTS FILE...  counts, never fails (the prose gauge)
# SPEC (2026-10-10, lane C task C3, written before the code):
#   C1 "Every number and table about servers, the floor and preference keys in the minted README comes
#       from SERVERS, editions.FLOOR and prefs.KNOWN."
#   C2 "A number word next to 'servers' in shipped prose that is not len(SERVERS) is a fault."
#   C3 "The README never tells a person to edit .mcp.json by hand."
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
function ok(m)  { pass++; if (mode != "gauge") print "ok   " m }
function bad(m) { fail++; if (mode != "gauge") print "FAIL " m }
function word(n) { split("one two three four five six seven eight nine ten eleven twelve", W, " "); return (n in W) ? W[n] : n "" }
BEGIN { FS = "\n" }
FNR == NR {
  split($0, f, " ")
  if (f[1] == "server") { ns++; srv[f[2]] = 1; order[ns] = f[2] }
  else if (f[1] == "floor") { nf++; flr[f[2]] = 1 }
  else if (f[1] == "key") { rest = substr($0, 5); t = index(rest, "\t"); k = substr(rest, 1, t - 1); nk++; key[k] = substr(rest, t + 1) }
  next
}
FNR == 1 { fname = FILENAME; files++ }
{ line[fname, FNR] = $0; nl[fname] = FNR; text = tolower($0); gsub(/[ \t]+/, " ", text); sub(/^ /, "", text)
  # C2: any "<number word or digits> ... servers" (at most three words between: "three small MCP servers")
  # the line is read with the last four words of the line before, so a count wrapped across a line
  # break ("three\n small MCP servers") is seen; a match is counted on the line where it ends
  s = (FNR > 1 ? prevtail " " : "") text; off = length(s) - length(text)
  pt = text; gsub(/[^a-z0-9 -]/, " ", pt); np = split(pt, pw, " "); prevtail = ""
  for (q = (np > 4 ? np - 3 : 1); q <= np; q++) prevtail = prevtail (prevtail == "" ? "" : " ") pw[q]
  while (match(s, /(^|[^a-z0-9])(one|two|three|four|five|six|seven|eight|nine|ten|eleven|twelve|[0-9]+)( [a-z0-9-]+)?( [a-z0-9-]+)?( [a-z0-9-]+)? servers/)) {
    m = substr(s, RSTART, RLENGTH); sub(/^[^a-z0-9]/, "", m); split(m, mw, " ")
    if (RSTART + RLENGTH - 1 > off && mw[1] != word(ns) && mw[1] != ns "") { cnt++; where = where sprintf("\n       %s:%d says \"%s\" (there are %s)", fname, FNR, m, word(ns)) }
    off -= RSTART + RLENGTH - 1; s = substr(s, RSTART + RLENGTH)
  }
  if (text ~ /edit .*\.mcp\.json.*by hand|by hand.*\.mcp\.json/) { hand++; handw = handw sprintf("\n       %s:%d", fname, FNR) }
}
END {
  if (mode == "gauge") {
    printf "readme-count gauge: %d file(s) read; %d number word(s) next to \"servers\" that are not %s; %d line(s) telling a person to edit .mcp.json by hand%s%s\n", files, cnt + 0, word(ns), hand + 0, where, handw
    exit 0
  }
  r = fname
  if (ns == 0) { bad("no servers in the facts file: NOT CHECKED"); exit 1 }
  # C1 servers: the opening count, and one table row per server, no more
  first = ""; for (i = 1; i <= nl[r]; i++) if (line[r, i] ~ /^One plugin, /) { first = line[r, i]; break }
  if (first ~ ("^One plugin, " word(ns) " ")) ok("C1 the README opens on \"" word(ns) "\" servers, len(SERVERS) = " ns)
  else bad("C1 opening line \"" first "\" does not say " word(ns))
  rows = 0
  for (i = 1; i <= nl[r]; i++) if (match(line[r, i], /^\| `[a-z0-9_]+` \|/)) {
    n = substr(line[r, i], 4); sub(/`.*/, "", n)
    if (n in srv) { seen[n] = 1; rows++ } else if (intable) { bad("C1 a table row for \"" n "\", which SERVERS does not have") }
    intable = 1
  } else if (line[r, i] !~ /^\|/ && line[r, i] !~ /^  /) intable = 0
  miss = ""; for (n in srv) if (!(n in seen)) miss = miss " " n
  if (miss == "") ok("C1 every server in SERVERS has a table row (" rows ")"); else bad("C1 no table row for:" miss)
  # C1 floor: one line names the floor's count and every floor skill
  fl = ""; for (i = 1; i <= nl[r]; i++) if (line[r, i] ~ /^The floor is /) { fl = line[r, i]; for (j = i + 1; j <= nl[r] && line[r, j] != ""; j++) fl = fl " " line[r, j]; break }
  fmiss = ""; for (n in flr) if (index(fl, "`" n "`") == 0) fmiss = fmiss " " n
  if (fl ~ ("^The floor is " word(nf) " ") && fmiss == "") ok("C1 the floor line says " word(nf) " and names every FLOOR skill")
  else bad("C1 floor line \"" fl "\" (want " word(nf) "; missing:" fmiss ")")
  # C1 keys: one switches-table row per KNOWN key, with its default
  kmiss = ""; nrow = 0
  for (k in key) {
    found = 0
    for (i = 1; i <= nl[r]; i++) if (index(line[r, i], "| `" k "` |") == 1) {
      found = 1; nrow++
      d = key[k]; want = (d == "") ? "(none)" : "`" d "`"
      if (index(line[r, i], "| `" k "` | " want " |") != 1) kmiss = kmiss " " k "(default)"
      break }
    if (!found) kmiss = kmiss " " k
  }
  if (kmiss == "") ok("C1 every KNOWN preference key has a row with its default (" nrow ")"); else bad("C1 switches table, missing or wrong:" kmiss)
  # C2, C3
  if (cnt == 0) ok("C2 no number word next to \"servers\" other than " word(ns)); else bad("C2 stale server counts:" where)
  if (hand == 0) ok("C3 no instruction to edit .mcp.json by hand"); else bad("C3 hand-edit instruction at:" handw)
  printf "TOTAL pass=%d fail=%d\n", pass, fail
  exit (fail > 0)
}
