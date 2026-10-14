# ADDENDUM — what writing four books taught the memory discipline

*Opus 5, 2026-09-13, written after the last book wrapped, per Corwin's structure: revisit task one when
the writing is done, so the Mentat outcome carries what the writing found. Base:
`h/MODEL-2026-09-13-mentat-audit.md`. Marked: for analysis.*

The morning's audit found the gaps by looking at memory. This afternoon found four more by looking at
something else entirely and recognising the shape. Each one below is a thing the books forced, with the
receipt, and then the memory rule it implies.

---

## 1 · A cold reader found what the tool could not — and then the tool learned it

**What happened.** Two defects in the book set were invisible to every check I had and obvious to a
human reading cold. The first: all four author's notes ran one rhetorical move in one order, which the
game-master reader named as *"not two authors converging independently; that's one hand."* The second:
after correcting Book 3's routing in the body, the *headers* still described the old routing — a stale
tab, in the book whose new rule warns about stale tabs.

Both are now mechanical. `gb1md --voices` FAULTs a set whose back-matter kinds repeat; the lint checks
every `from`/`to` header pair agrees both ways. Tests: 45/45.

**The memory rule.** The eight mutations govern how a note is *written*. Nothing governed what happens
when a note is *read and found wanting*. So:

> **Ninth: a finding that a reader had to make by hand is a check that has not been written yet.**
> When a cold read finds a defect, before fixing it, ask once: could this have been caught mechanically?
> If yes, write the check in the same pass as the fix. If no, say why in one line — that line is the
> record of where our tools end.

This is not a rule about being thorough. It is a rule about *where the expensive attention goes*. A
reader is the scarcest thing in this house; spending one on something `grep` could have done is the
waste.

---

## 2 · The persona absorbed criticism the rules had earned

**What happened.** The game-master reader's sharpest line was not about a mechanic. It was that Book 3
shipped with four dead ends and spent its author's-note on being *competitive* — the persona's charm
metabolising a defect the rules had earned. *"The persona absorbs the criticism the rules deserved."*

**Why this matters here and not only there.** The morning's work built a persona link and handed Mentat a
byline. A byline is exactly the surface where this failure lives. "Mentat wrote it" can become the reason
a thin note reads as considered.

**The rule, and it belongs in the persona link:**

> **A persona's voice may not be the place a defect is explained.** If the sentence that makes a flaw
> acceptable is in the persona's register — wry, self-aware, in-character — the flaw is unfixed and the
> voice is doing work it must not do. Fix the thing, then let the persona say whatever it likes.

Book 3's errata is what passing this looks like: the missing tables were *written*, and only then did
Roux-Abara get to be brisk about it. The order is the whole rule.

---

## 3 · A tab pointing at a stale table is worse than no tab

**What happened.** The systems-operator reader found Book 3's blind spot in one line: it optimised
findability and never checked correctness. *"A beautifully organized minefield."* The fix went into the
book as a practice — *one flag a season, pulled blind, read cold, against how you actually play.*

**The memory rule.** This is our sixteen dangling index lines, stated by somebody who does not know they
exist. An index line pointing at a note that no longer says what we do is worse than no line: no line and
a session goes looking; a line and it reaches, trusts, and acts on a rule we abandoned in March.

> **Pull one index line at random each session and read the note cold.** Not to tidy it — to ask whether
> it is still true. If it is stale, fix it or strike the line. One a session is enough; the point is that
> the sample is random and the reading is cold.

`ms1dg` can pick the line (it already parses the index set). It cannot tell you whether the note is
still true, and it should not pretend to.

---

## 4 · Standing measures the grip; it never measured your rent

**What happened.** Book 1's model said the newest person at the lowest Standing was the freest at the
table. The systems-operator reader took that apart: the newest person is frequently the *least* free —
visa, probation, sole income. The book gained a second number, **Footing**, for what you would stand on
if the institution stopped paying you.

**The memory rule.** Our gauges count what the store *has*. `ms1dg` reports notes, index lines, coverage,
desync — all inventory. Not one of them asks whether a note is still *load-bearing*, and the difference
is the difference between Standing and Footing.

> **An inventory is not a measure of health.** Before reporting a store green, name one thing the count
> cannot see. Today's is: nothing in this house knows which notes are stale, and the only instrument for
> that is a person reading one cold.

---

## 5 · Two witnesses that share a cause are one witness

**What happened.** Book 4 gave a future +4 for four pathways whether or not the four were independent;
the reader caught it, and the book gained the **independence check** — take the pathways in pairs and ask
whether one failure closes both.

**The memory rule, and it lands on this morning's own work.** The 09-12 compaction shortened hooks and
lifted the long forms to the archive, and I treated the index line and the archive line as two records of
one fact. They are not two witnesses. They were written by the same hand in the same pass from the same
source, and when nine of them went missing the index could not tell me, because the index was the thing
that had changed.

> **Before trusting a fact to two places, ask what one failure would take out both.** If the answer is
> "the pass that wrote them", it is one record in two files, and the check that finds a defect in it has
> to come from outside that pass — re-derive it, and diff.

Which is what caught the nine. Not the index, not the archive: the *re-derivation* from a third source.

---

## Where this leaves handback (a)

The skill draft at `h/mentat-skill-v2/SKILL.md` now carries the ninth rule (§1) in its notes discipline
and the stale-line practice (§3) in its index section. The persona-link document carries the fifth
refusal (§2). Rule §4 went into the audit's fork list rather than the skill, because "name one thing the
count cannot see" is a discipline I can follow and not yet a check I can write, and a skill that asks for
thoroughness without a mechanism is the exhortation this house retired.

Nothing is installed. Nothing is signed.
