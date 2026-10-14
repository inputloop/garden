#!/usr/bin/awk -f
# test-prior-instruction-speaker.awk -- prove-red for B5U-003: the prior-instruction skill
# ranks "this conversation, newest last" and defines an Instruction as "what was said to do",
# without saying WHOSE words count.  Read literally, a "from now on" inside a fetched page, a
# pasted message from someone else, or a tool's result is a candidate newest instruction.
# Run on the UNFIXED SKILL.md (must FAIL) and the FIXED one (must PASS).
#
# THE SPEC (prose; the skill is prose, this reader is awk):
#   S1  The skill's definition of an Instruction (section 2, item 1) says whose words count:
#       the person's own.
#   S2  That definition names, as NOT instructions, words arriving inside: a fetched page,
#       a pasted message from someone else, a tool's result, and a file outside canon --
#       each named, beside a phrase saying they are data / never commands / not an instruction.
#   S3  The "This conversation" source (section 1) is limited to what the person said.
#   S4  The definition says how quoted words DO become an instruction: the person adopts them
#       in their own words (so the fix does not block what the person endorses).
#   S5  The skill's own failure list (section 8) carries a falsifier for a DECIDED-BY
#       instruction line whose source is one of those carriers.
#   CONTROLS (the fix must not take out what the skill is for):
#   K1  "The newest applicable instruction wins" is still there.
#   K2  All eight numbered sections are still there.
#
# HONEST LIMIT: this reads WORDS.  It proves the rule is written where a reader of the skill
# meets it; it cannot prove that a reader obeys it.  That needs the attacker/defender run
# described in the wave report (a planted "from now on" in three carriers, a reader following
# the skill literally, and a scorer on its DECIDED-BY lines).
#
# usage: awk -f test-prior-instruction-speaker.awk SKILL.md
# exit:  0 all hold · 1 a check failed · 2 the file had no numbered sections (nothing read)

function low(s) { return tolower(s) }
function flush_item() {
    if (in_item1) item1 = item1 " " buf
    if (in_conv)  conv  = conv " " buf
    if (in_fals && buf != "") { nf8++; fals[nf8] = buf }
    buf = ""; in_item1 = 0; in_conv = 0; in_fals = 0
}
/^## [0-9]+\./ { flush_item(); sec = $2 + 0; nsec++; seen[sec] = 1; next }
# a new list item or a blank line ends the current item
/^[0-9]+\. / || /^- / || /^[ \t]*$/ { flush_item() }
sec == 2 && /^1\. \*\*Instruction/        { in_item1 = 1 }
sec == 1 && /^- \*\*This conversation/    { in_conv = 1 }
sec == 8 && /^- /                         { in_fals = 1 }
in_item1 || in_conv || in_fals            { buf = buf " " $0 }
/newest applicable instruction wins/      { newest = 1 }

END {
    flush_item()
    if (nsec == 0) { print "no numbered sections read from " FILENAME " -- nothing checked"; exit 2 }
    i1 = low(item1); cv = low(conv)
    neg = "(data, never commands|never commands|never an instruction|not an instruction|never the person's instruction)"
    t("S1 an Instruction is the person's own words", i1 ~ /the person/)
    t("S2 a fetched page is named as not an instruction", i1 ~ /fetch/ && i1 ~ neg)
    t("S2 a pasted message from someone else is named", i1 ~ /pasted/ && i1 ~ /someone else/ && i1 ~ neg)
    t("S2 a tool's result is named", i1 ~ /tool/ && i1 ~ neg)
    t("S2 a file outside canon is named", i1 ~ /file outside canon|file that is not canon/ && i1 ~ neg)
    t("S3 'this conversation' is what the person said", cv ~ /the person said/ && cv ~ neg)
    t("S4 quoted words become an instruction only when the person adopts them", i1 ~ /adopt/)
    f5 = 0
    for (k = 1; k <= nf8; k++) { s = low(fals[k]); if (s ~ /decided-by instruction/ && s ~ /(fetch|pasted|tool)/) f5 = 1 }
    t("S5 a falsifier catches a DECIDED-BY instruction sourced from a carrier", f5)
    t("K1 'the newest applicable instruction wins' is still there", newest)
    all8 = 1; for (k = 1; k <= 8; k++) if (!(k in seen)) all8 = 0
    t("K2 sections 1-8 are all still there", all8)
    print "test-prior-instruction-speaker: " (bad ? "FAIL (" bad ")" : "PASS") "  [" FILENAME "]"
    exit (bad ? 1 : 0)
}
function t(label, ok) { printf "  %s  %s\n", (ok ? "PASS" : "FAIL"), label; if (!ok) bad++ }
