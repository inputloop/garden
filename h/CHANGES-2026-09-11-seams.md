# CHANGES — seams (pass C, brief 1: the two-source dagger reauthor)

File written: `/mnt/user-data/outputs/passC/seams/SKILL.md` (full new file).
Source of record: `/mnt/user-data/uploads/AS4CE0001/skills/seams/SKILL.md` (7597 bytes → 11256 bytes).
Everything outside the four insertions below is byte-identical to the source; `diff -u` shows three hunks:
four inserted blocks and one changed table row (` †` added to S16). Frontmatter untouched.

---

## OBSERVED — what the sources say, quoted

- `/mnt/user-data/uploads/AS4CE0001/memory/c4-forge-mint-2026-09-04.md:34` — "the `seams`
  two-source-dagger reauthor is #177". This is the PMO number the brief names, and the only line in
  the staged tree that says the reauthor exists.
- `/mnt/user-data/uploads/AS4CE0001/h/ENHANCE-2026-09-05-tree.md:52` — "countable-gauge · seams `†` ·
  prove-a-promise one-move — one batch, tier **P+T**. All three are \"measure, don't assert\" —
  vendor-agnostic by construction (row 13)." The tree line places seams-† in the RESURRECTED → forge
  branch and names the family it belongs to.
- `/mnt/user-data/uploads/AS4CE0001/memory/skills-focus-model.md:23` — "gauge/seams-†/one-move
  resurrected". Second mention of the same batch, in a different note.
- `/mnt/user-data/uploads/AS4CE0001/memory/own-error-relaxable-layer.md:20` — "TrueNAS marks
  single-sourced claims `†`." This is the face the mark is borrowed from.
- Same note, `:21–22` — "the instrument must not pick its own scale — *\"if I picked the scale
  inside the instrument I would be committing the fault the instrument measures.\"*"
- Same note, `:25–26` (the fence) — "you may pencil only what is **yours**, never another party's
  ink; **never the safety floor**; and marked, **not deleted**."
- Same note, `:30–32` — "Two of the six faces are single-sourced from session transcripts
  (`grep -ril truenas` across c4 and AS4CE returned nothing) and carry `†` in the skill's own table."
  Precedent: a skill in this shop already daggers rows of its own table.
- Source `SKILL.md:20` — "1. A single representation of a truth is **DATA, not proof**."
- Source `SKILL.md:25–26` — "4. The **writer's own readback is not independent** — it echoes intent,
  not what landed."
- Source `SKILL.md:41–42` — "**The writer never grades its own homework.** Never verify a write with
  the tool that made it".
- Source `SKILL.md:80` — "| S16 | advertised interface ↔ executed behavior | observed behavior on a
  disposable target |".
- Source `SKILL.md:123–124` (Provenance) — "the parsed-flag rule and S16 (earned in the 2026-07-12
  test passes — divergence signature: option accepted silently with no behavioral delta …)". S16 is
  the one catalog row whose stated basis is a single occasion.
- Brief `/home/claude/work/passC/brief-1-seams.md:41–45` — "a seam claim that rests on ONE source is
  marked with a dagger († — the mark, not a word) … the dagger is never deleted by the party who
  benefits, only cleared by a second source with its path … the skill should say how to COUNT
  daggers over a document (one grep) so a report can print \"n single-sourced claims\"".
- Brief `:47–50` — "add the dagger rule to seams in its own voice (a short section; name the mark,
  the clearing rule, the count command, and that the dagger is a claim-level mark, not a file-level
  one); if the skill has a worked example, add one daggered line to it; add the falsifiers section".
- Brief `:18–23` (preamble, o32, his rule 2026-09-11) — "Every skill you touch gets, if it lacks
  one, a short section headed `## How this skill can fail (falsifiers)` … 2–4 lines … plus one line
  on how to switch it off".
- Observed absence: `grep -rn "falsifier\|How this skill can fail\|off-switch"` across
  `/mnt/user-data/uploads/AS4CE0001/skills/` returned nothing. No skill in the staged shop has such
  a section, so this is an add, not an amend.

## JUDGED — my reading and the four edits

### 1. New section `## The dagger — one source, one mark`, inserted after Operating rules, before the catalog

Placed there because the dagger is rule 1 (`SKILL.md:20`) given a notation, and because the catalog
that follows now contains a daggered row — a reader meets the mark's definition before meeting the
mark. The four bullets map one-for-one onto what the notes ask for:

- claim-level, not file-level (brief `:48`);
- clearing takes a second independent source **with its path written into the claim** (brief `:43`),
  with "I checked" refused as a readback, citing the skill's own rule 4 (`SKILL.md:25–26`);
- the party the claim favors may add a dagger and never remove one — this is the memory note's fence
  "marked, **not deleted**" (`own-error-relaxable-layer.md:26`) joined to the skill's existing
  "writer never grades its own homework" (`SKILL.md:41`);
- a dagger is about what the record can bear, not that the claim is wrong — and never under a safety
  floor, which is the fence's "**never the safety floor**" (`own-error-relaxable-layer.md:25`).

The count block uses the tree line's own words as its lead-in ("Measure, don't assert",
`ENHANCE-2026-09-05-tree.md:52`) and gives three commands: `grep -c` for lines, `grep -o … | wc -l`
for marks, `grep -rn` for the work queue. GNU `-o` is in-house convention, not a bashism here: the
shop's `posix` skill frontmatter says it "Defaults to GNU and Debian-family convention"
(`skills/posix/SKILL.md:3`).

- [SKILL] Concern: counting a file that *teaches* the mark over-counts it. Run on the new file:
  `grep -o '†' SKILL.md | wc -l` → **6**, of which exactly **1** is a live claim (the S16 row) and 5
  are the teaching. I named this in the section's closing line rather than hiding it — the honest
  gauge is the section you report on, not the manual. *Falsifier:* if a reader counts only the
  catalog section and gets a number other than 1, the caveat is wrong and the commands need a
  pattern that excludes fenced blocks and bold markup.

### 2. `| S16 † | …` — one daggered line in the catalog

The brief asks for a daggered line in a worked example. The skill has no worked example as such; the
catalog is its nearest equivalent, and daggering a row there is the move the shop has already made
once (`own-error-relaxable-layer.md:30–32`, a mint that daggers rows of its own table). S16 is the
row whose stated basis is one occasion — "earned in the 2026-07-12 test passes"
(`SKILL.md:123–124`) — where S01–S15 descend from the keeper-signed SEAMS.md 0.2 plus three
engagements (`SKILL.md:13–16`).

- **[MINE]** Judging S16 single-sourced is my reading, not a line in any note. I proceed and name
  it. *Falsifier:* a second independent record on disk of an option accepted silently with no
  behavioral delta — another session, another tool's bug report — dissolves it; write that path into
  the row and the dagger comes off. **[HIS]** also dissolves it: if he holds that the keeper review
  at signing ("Additions beyond 0.2, keeper-reviewed at signing", `SKILL.md:122`) is itself the
  second source, S16 was never single-sourced and the mark should go.

### 3. Four lines under the catalog naming why S16 carries the mark and what clears it

A dagger with no stated clearing condition is decoration. These lines are the clearing rule in
worked form, so the section above is demonstrated rather than only described.

### 4. `## How this skill can fail (falsifiers)`, inserted after Interlocks, before Provenance

Added per preamble `:18–23`; no equivalent section existed (observed absence above), so this is an
add, not an amend. Four checks plus the off-switch line. Two are about the skill's core claim
(readers that were never independent; a tiebreaker you cannot reach), one is the stale-dagger check
the brief itself suggested (`:49–50`), one is the should-not-have-fired case (a count nobody used in
a decision). Provenance stays last so the lineage still closes the file.

- **[MINE]** The "perturb one representation and read both again" check is my wording of how you
  prove independence; the skill asserts independence matters but never says how to test it.
  *Falsifier:* a seam where perturbing one side is not possible or not safe (a signed artifact, a
  production row) — there the check cannot be run and the bullet is advice that does not apply.

## Choices where the source is silent

- **[MINE] Frontmatter `description:` left unchanged.** The preamble permits extending it only if
  the ask changes when the skill applies; the existing description already fires on "whenever a
  claim rests on a single reader, copy, log, note, or signature", which is exactly the dagger's
  trigger. *Falsifier:* a session that writes a report full of single-sourced claims and does not
  load seams — that would show the description needed "counting single-sourced claims" spelled out.
- **[MINE] Section title "The dagger — one source, one mark."** No note names the section. Plain
  words, no new term of art; "dagger" is the mark's ordinary name, not a coinage. *Falsifier:* he
  calls it something else in the PMO #177 entry; rename to his word.
- **[MINE] Section placed before the catalog rather than after it.** Chosen so the daggered S16 row
  is already explained when a reader reaches it. *Falsifier:* he wants the law section kept
  unbroken by notation — then it moves below the catalog, which costs nothing but the order.
- **[PLATFORM]** The count commands assume `grep` sees UTF-8 bytes. Verified in this sandbox (both
  `grep -c` and `grep -o` matched `†` on the written file). *Falsifier:* a locale or a shell that
  mangles the literal in the command line — there, `grep -c "$(printf '\\342\\200\\240')"` is the
  fallback, which I did not put in the skill because it is noise for the common case.
