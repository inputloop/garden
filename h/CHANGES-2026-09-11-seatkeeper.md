# CHANGES — seatkeeper (pass A, brief 1, queue Q1) · 2026-09-11

Base: `/mnt/user-data/uploads/AS4CE0001/skills/seatkeeper/SKILL.md` (91 lines, read-only staged copy).
Output: `/mnt/user-data/outputs/passA/seatkeeper/SKILL.md` — the full new file.
Two edits only: **move 1 rewritten** (lines 47–52 of the original) and a **falsifier section appended**.
Everything else — frontmatter, STATUS, the stores, the signals, moves 2–7, the two disciplines — is
byte-identical to the staged original (`diff` shows exactly these two hunks).

---

## OBSERVED — what the sources say, quoted, with path:line

1. The ask. `h/ENHANCE-2026-09-04-queue.md:18-22` —
   *"Ask: move 1 must say (a) an explicit-path request for the auto-memory folder is refused (\"Cannot
   mount a folder that is, or is inside, Claude's own application data\"), (b) the picker shows the
   keeper no purpose and returns whatever he clicked, (c) the file-tool fallback works but **cannot
   hash the source** — its receipt word is \"copied, re-read\", never \"verified\" — and (d) the
   trigger (session-close) must be a hook, not a memory."*
   The same entry names the target: `…queue.md:26` — *"seatkeeper `SKILL.md:47-52` (the stale move)."*
2. (a), the refusal. `SEATDIFF-2026-09-04b.md:12` —
   *"| 1 mount A | `request_cowork_directory` with the `…/spaces/<id>/memory` path | **REFUSED** —
   *\"Cannot mount a folder that is, or is inside, Claude's own application data.\"* `[PLATFORM]` |"*
   Corroborated a day later, `h/MODEL-2026-09-05-memory-situation.md:12` — *"`request_cowork_directory`
   refuses the path (\"inside Claude's own application data\")."*
3. (a), the counter-evidence that keeps "attempt once" in. `SEATDIFF-2026-09-04b.md:21-24` — *"The
   morning account (`SEATDIFF-2026-09-04.md`) hashed A \"mounted via request, read-only\". This evening
   the explicit-path request is refused. Either the fence tightened between sessions, or the morning
   used the picker."* And `memory/verify-mount-access-fresh-per-session.md:3` — *"A prior session's
   mount failure is NOT evidence about this session — attempt fresh, then ASK with the tool."*
4. (b), the picker. `SEATDIFF-2026-09-04b.md:13` — *"| 1 mount A, picker | `request_cowork_directory`
   with no path (native picker) | returned `F:\claude\AS4CE\AS4CE0002\New folder` — doesn't exist; not
   A. Not retried (it pops a dialog on you). |"* The rule that follows from it is already written in
   the same file, `:71` — *"before any tool that pops a dialog on him, say **which folder and why** in
   chat first; the dialog shows neither (he picked a blank folder)."*
5. (c), the fallback and what it cannot do. `SEATDIFF-2026-09-04b.md:14` — *"| 1 fallback | file-tool
   `Glob` + `Read` on A (the skill's named fallback) | worked: 103 notes enumerated by name |"*;
   `:16` — *"| 2 manifest | by **content** (sha256 of A) | **NOT ATTEMPTED** — A is unhashable from the
   sandbox; the 96 same-name pairs are uncompared |"*.
6. (c), the receipt word. `SEATDIFF-2026-09-04b.md:130-132` — *"\"copied, verified\" in the morning's
   vocabulary meant sha-on-both-sides — tonight's is \"copied, re-read\" and this file says so rather
   than borrowing the stronger word (`verify-say`)."* The morning table is the "verified" case:
   `SEATDIFF-2026-09-04.md:16-49` (34 rows, each *"copied, verified"*) with A mounted read-only
   (`SEATDIFF-2026-09-04.md:59-60`).
7. (d), hooks. `skills/skilltank/SKILL.md:27` — *"skills have no event hooks, only conversational
   triggers"*; `skills/ethicsminions/SKILL.md:39` — *"It has no event hooks — skills fire on
   conversational triggers."*
8. (d), why it matters here. The skill's own STATUS, `skills/seatkeeper/SKILL.md:14-15` — *"a
   **trigger / cadence** (session-close) so it isn't a hand-run chore that lapses — the lapse is what
   made the mess"*. Move 7 says the same wish, `:80-81`.
8b. Falsifier 1 is not mine — it is already written as a judgement in the evening account,
   `SEATDIFF-2026-09-04b.md:128-130` — *"the `seatkeeper` skill's move 1 is stale against tonight's
   platform — `[PLATFORM]`, falsifier: one more explicit-path request in a fresh session succeeds"*,
   which the brief repeats at `brief-1-seatkeeper.md:44-45`.
9. Falsifier 4's source. `SEATDIFF-2026-09-04b.md:165-170` (CARD 6) — *"if it holds, A *is* the seat
   and the reseat ritual retires"*; ruled Q506 at `:183-199`.
10. House rule for the new section. Brief preamble, `brief-1-seatkeeper.md:18-23` — *"Every skill you
    touch gets, if it lacks one, a short section headed `## How this skill can fail (falsifiers)`"*.
    Checked first: no skill under `/mnt/user-data/uploads/AS4CE0001/skills/` contains the word
    "falsifier" or a section of that kind (`grep -rn "falsifier" skills/` → no hits), so this is an
    addition, not a duplicate — nothing was amended away.

---

## JUDGED — what I did and why

- **Move 1 now carries (a)–(d) as four labelled parts, each with its receipt named in the line.**
  The old move 1 stated the opposite of (a): it told the reader to "Request the auto-memory folder
  (`request_cowork_directory` on the `…/spaces/<id>/memory` path)" and called the failure mode
  fickleness — *"The fence has a workaround; the mount is just fickle"* (original `:47-51`). Against
  OBSERVED 2 that is a policy refusal, so the skill was sending its reader to a closed door and then
  blaming the weather. `[PLATFORM]` — falsifier: one explicit-path request in a fresh session mounts A.
- **"Attempt once per session" is kept inside (a), not dropped.** OBSERVED 3 gives two readings of the
  same day (mounted in the morning, refused in the evening); the memory note makes the per-session
  attempt a standing rule. So the skill states the refusal *and* asks for one dated attempt. `[DOMAIN]`
  — falsifier: the keeper says the fence is permanent and re-testing is noise, in which case the
  attempt line goes and (a) stands alone.
- **Preserved from the old move 1:** the verify command (`ls .auto-memory/*.md | wc -l`), the fact that
  a mount can relocate or drop between shell calls, the file-tool fallback, and the **Fail loud**
  sentence verbatim (the hardening is STATUS `:13-14`, built and tested per `:18-20`, and the ask did
  not touch it). Dropped: the "the fence has a workaround; the mount is just fickle" framing, which OBSERVED
  2 contradicts.
- **(c) names both words and the boundary between them** rather than banning "verified" outright,
  because OBSERVED 6 shows "copied, verified" was correct on the morning run when both sides were
  hashed. `[SKILL]` — falsifier: the keeper wants one word only, in which case "verified" leaves the
  skill entirely.
- **(d) is stated in move 1, and move 7 is untouched**, per the brief's *"Keep every other move as it
  is."* So move 1 tells the reader what the trigger must be and move 7 keeps its wording; the new text
  points at move 7 by number rather than editing it. `[SKILL]` — falsifier: the keeper reads the pair
  as contradictory, in which case move 7 gets the hook sentence and move 1's (d) shrinks to a pointer.
- **(d) claims no hook exists rather than inventing one.** OBSERVED 7 says skills get no event hooks,
  and nothing in the staged sources shows a close-time hook wired in this shop. The skill therefore
  says: wiring lives outside the skill, and until it exists, report the cadence as **unwired**.
  `[PLATFORM]` — falsifier: a session-end hook fires seatkeeper without anyone asking, with a receipt.
- **Falsifier section: four checks plus one off-switch line**, placed at the end after "Two disciplines
  that ride along". The first is the brief's own example (`brief-1-seatkeeper.md:44-45`); the second and
  third are the (c) and fail-loud claims made falsifiable by a command; the fourth is the
  "should not have fired" case from OBSERVED 9. The off-switch is a sentence the keeper can say plus
  the two removals that starve the skill.
- **Frontmatter `name:` unchanged; `description:` unchanged** — the ask changes what move 1 says, not
  when the skill applies (preamble `:16-17`).
- **Nothing installed, nothing signed, nothing edited in the live rack.** There is no `.asc` beside the
  staged `SKILL.md` (`ls -la skills/seatkeeper/` → one file), so no signature was invalidated; the
  preamble's edit-anyway norm did not need to be exercised.

### [MINE] choices (each with its falsifier; none blocks)

- **[MINE] The word "unwired" as the report state for the cadence.** The ask says the trigger must be a
  hook; it does not say what to print while there is none. I chose a plain word over silence.
  Falsifier: the keeper (or `verify-say`, which owns the vocabulary) already has a word for an
  un-fired scheduled step — use his and drop mine.
- **[MINE] Wikilink to `[[dialog-tools-need-visible-line]]` in (b).** That note is named in
  `SEATDIFF-2026-09-04b.md:71` and `:74` but is not in the staged `memory/` folder (18 notes staged),
  so the link may dangle in a seat where the note did not land. Falsifier: `ls
  <seat>/memory/dialog-tools-need-visible-line.md` — absent, so cut the wikilink and keep the plain
  sentence, which stands on the SEATDIFF line alone.
- **[MINE] Falsifier 3 (`ls <seat>/*.md | wc -l` unchanged) as the fail-loud check.** The sources prove
  the silent no-op happened (STATUS `:14-15`) but name no standing check for it. A before/after count is
  the cheapest one I can state in one line. Falsifier: a run legitimately copies 0 notes (nothing was
  stranded) and the count is rightly unchanged — so the check needs "and the run reported copies",
  which the line already says; if that still misfires in practice, replace it with `ms1dg`'s G8.
- **[MINE] Naming `skills/skilltank/SKILL.md:27` and `skills/ethicsminions/SKILL.md:39` inside the skill
  text as the receipt for "no event hooks".** Those are sibling skills, not platform documentation;
  they are the shop's own statement of the fact. Falsifier: platform docs say skills do have an event
  hook, in which case the citation is wrong and (d) gets the doc URL instead.
