# terms-v2-spec.awk -- the minted Terms of Service read as two partners and one collection.
# The work is a document minted by bin/tp2mt (POSIX sh) from c4/man/licensing-defaults.md; its other
# tests are sh (tests/tp2mt-tests.sh), so this spec is awk.
# usage: awk -f terms-v2-spec.awk TERMS-OF-SERVICE.md
# SPEC (turn 2, lane T, 2026-10-10; Corwin, 08:12: "show a really winning model of partnership in
#       all we ship"; 08:10: the old boilerplate "makes me look very proud to be me"):
#   V1 "Before the first '## ' heading after 'Who made this', the opening section names Corwin Brust
#       and Bryant Frankford in one sentence with the word together."
#   V2 "No one-desk phrase appears anywhere: 'what Corwin Brust publishes', 'his tools make for him',
#       'from the copyright holder', 'the person the work is for', 'Where Corwin holds the copyright'."
#   V3 "The collection's credit line names Corwin Brust, then Bryant Frankford, then K Smith, in
#       that order, on the line(s) that begin 'Credit for the collection'."
#   V4 "Code is offered as GPL-3.0-or-later OR LGPL-3.0-or-later, and the FSF sentence 'either
#       version 3 of the License, or (at your option) any later version' stands on one line."
#   V5 "Corwin's own permissions are named as his ('Corwin adds'), never as the collection's."
#   V6 "What the plugin makes for its user is said to be the user's ('is yours')."
# Prints ok/FAIL rows and TOTAL; exit 1 on any FAIL.  Reads only.
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
BEGIN { n = split("what Corwin Brust publishes|his tools make for him|from the copyright holder|the person the work is for|Where Corwin holds the copyright", pride, "|") }
/^## Who made this/ { inwho = 1; next }
/^## / && inwho { inwho = 0; whodone = 1 }
inwho { who = who " " $0 }
{ for (i = 1; i <= n; i++) if (index($0, pride[i])) { bad("V2 line " FNR " carries the one-desk phrase '" pride[i] "'") } }
/^Credit for the collection/ { credit = $0; getline nxt; credit = credit " " nxt }
index($0, "GPL-3.0-or-later OR LGPL-3.0-or-later") { orl = 1 }
index($0, "either version 3 of the License, or (at your option) any later version") { fsf = 1 }
index($0, "Corwin adds") { adds = 1 }
index($0, "is yours") { yours = 1 }
function bad(m) { fail++; print "FAIL " m }
function good(m) { pass++; print "ok   " m }
END {
  if (whodone && index(who, "Corwin Brust") && index(who, "Bryant Frankford") && index(who, "together")) good("V1 the opening names both partners, together")
  else bad("V1 no 'Who made this' section naming Corwin Brust and Bryant Frankford together")
  c = index(credit, "Corwin Brust"); b = index(credit, "Bryant Frankford"); k = index(credit, "K Smith")
  if (c && b && k && c < b && b < k) good("V3 credit order: Corwin Brust, Bryant Frankford, K Smith")
  else bad("V3 credit line missing or out of order: " credit)
  if (orl && fsf) good("V4 code is GPL-3.0-or-later OR LGPL-3.0-or-later, the FSF sentence whole on a line"); else bad("V4 or=" orl + 0 " fsf=" fsf + 0)
  if (adds) good("V5 Corwin's permissions are named as his"); else bad("V5 no 'Corwin adds'")
  if (yours) good("V6 what the plugin makes for you is yours"); else bad("V6 no 'is yours'")
  if (!fail) good("V2 no one-desk phrase anywhere")
  print "TOTAL pass=" pass + 0 " fail=" fail + 0
  exit (fail > 0)
}
