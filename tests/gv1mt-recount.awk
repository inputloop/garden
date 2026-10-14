# gv1mt-recount.awk -- GV6: recount the garden view from its facts file and its page, and compare with the
# counts the builder claims in data.json.  A second reader, in a language apart from the builder (Python).
# usage: awk -f tests/gv1mt-recount.awk OUT/data.json OUT/garden-view.facts OUT/index.html
# Prints one line per count, "ok" or "MISMATCH", and exits 1 on any mismatch or a count it cannot find.
#
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
FNR == 1 { file++ }
file == 1 && /^ "counts": \{/ { inc = 1; next }
file == 1 && inc && /^ \}/ { inc = 0; next }
file == 1 && inc {
    line = $0; gsub(/[ ",]/, "", line); split(line, kv, ":"); claim[kv[1]] = kv[2] + 0; nclaim++; next
}
file == 2 && $1 == "SOURCE" { got["sources"]++; if ($0 ~ / state=missing/) got["missing"]++ }
file == 2 && $1 == "NODE" { got["nodes"]++; for (i = 2; i <= NF; i++) if ($i ~ /^kind=/) { sub(/^kind=/, "", $i); got["kind." $i]++ } }
file == 2 && $1 == "EDGE" { got["edges"]++; for (i = 2; i <= NF; i++) if ($i ~ /^type=/) { sub(/^type=/, "", $i); got["type." $i]++ } }
file == 2 && $1 == "TENSION" { got["tensions"]++; if ($0 ~ / state=open( |$)/) got["open"]++; if ($0 ~ / state=resolved( |$)/) got["resolved"]++ }
file == 3 { s = $0; story += gsub(/<details data-node="/, "", s) }
END {
    bad = 0
    if (nclaim == 0) { print "MISMATCH no counts block found in data.json"; exit 1 }
    for (k in claim) {
        if (k == "people") continue           # person models are counted, never drawn: no facts line to recount
        g = (k in got) ? got[k] : 0
        if (g == claim[k]) printf "ok        %-18s %d\n", k, g
        else { printf "MISMATCH  %-18s claims %d, recounted %d\n", k, claim[k], g; bad = 1 }
    }
    if (story == claim["nodes"]) printf "ok        %-18s %d\n", "story-entries", story
    else { printf "MISMATCH  %-18s %d story entries for %d nodes\n", "story-entries", story, claim["nodes"]; bad = 1 }
    print (bad ? "gv1mt-recount: RED" : "gv1mt-recount: GREEN")
    exit bad
}
