---
# QA REPORT S3 — the CCSPT/LENS handoff prompt: Fable S2, then Corwin, then Fable S3
Third pass, 2026-09-04. Subject: Corwin's five hand-edits on the S2 revision, and what they
say about S2. Reviewer: Fable (grading its own prior work — so the verdict rows on S2 are
JUDGED-by-the-author and say so; the keeper's grade, A−, stands above mine). Two piles;
tags; falsifiers; `[MINE]` never blocks. S1 and S2 cards sit beside this one.
---

## The files (OBSERVED)

| role | file (full MSYS2 path under `/f/claude/AS4CE/AS4CE0001/h/`) | bytes | lines | sha256 (head) |
|---|---|---|---|---|
| Fable S2 | `PROMPT-2026-09-04-csspt-lens-selfcheck--fable.md` | 27,515 | 375 | `aac264d71dba` |
| **Corwin pass 3** | `PROMPT-2026-09-04-csspt-lens-selfcheck--fable_then-Corwin.md` | 27,820 | 375 | `e8c75caf13f2` |
| **Fable S3** | `PROMPT-2026-09-04-csspt-lens-selfcheck--fable-S3.md` | 28,594 | 383 | `f02435d08af8` |

S3 was made by `cp` of Corwin's file (identity checked by `cmp`) then seven `Edit`s, so
`diff -u` against his file shows only my changes (7 hunks). Corwin's grade on S2: **A− net**
("since I did make one new version").

## What Corwin changed by hand, pass 3 (OBSERVED — 5 hunks)

| # | where | edit | kind |
|---|---|---|---|
| C1 | Q435 bullet | `[the tensions related to signing tend to play out in stagnation; when we make something worth signing we will refactor if we must to do it]` | steer, kept verbatim |
| C2 | JOURNEY parenthetical | `is a` → `is ` (article dropped, trailing space) | typo |
| C3 | Parked section | on my COPYING datum: `[is this .. shipping the tension? don't reinvent pressure to perform in the deliverables]` | **hit on S2** |
| C4 | Readings, sub-agent count | `[use:AS.CE: GRAIN: (default)4 or GREAT:9, or GRAND:17 CE.AS:esu]` | **the missing number** |
| C5 | Handback | `Present the files` → `Present full MSYS2 file names` | correction (existing memory) |

## FINDINGS (JUDGED)

**J1 · I shipped a tension into a parked section.** `[HIS: C3]` `[HIS: global CLAUDE.md — "never a standing caution that gates use"]`
S2 added, under "Parked, out of scope": *"one datum for it, no action: ccspt's own README
carries 'add canonical COPYING'…"* Labeled no-action, it still reads as a to-do planted
where the next session will trip on it — pressure to perform, dressed as a footnote. The
datum belongs in the QA card (it is there, S2 "primary source" table) and nowhere in the
prompt. **Cut.** The general form: a prompt carries the work and its receipts; observations
that are not the work go to the card. *Falsifier:* `grep -c 'add canonical' S3` → 0.

**J2 · The number existed; it just wasn't written anywhere a grep could reach.** `[HIS: C4]`
S2's Reading ("no house number found in memory or c4") was true and useless — the keeper
held it. GRAIN 4 / GREAT 9 / GRAND 17 is now pinned in (b) step 2, in Readings, and in
memory (`subagent-grain-great-grand`). His bracket `[use:AS.CE: … CE.AS:esu]` is kept
verbatim as the source; its notation is unexpanded — fork 1. *Falsifier:* memory note
present and indexed; `grep -c 'GRAIN' S3` ≥ 2.

**J3 · I broke an existing memory in my own handback.** `[SKILL: prefers-mingw-paths]` `[HIS: C5]`
Memory says print `/f/claude/...`, never DOS, never bare. S2's handback instruction said
"present the files", and my own S2 reply said "both hand-backs are in `h/`". Corwin had to
write the rule a second time, into the prompt. S3 spells the path form out and applies it
to the receipt line; this card and this turn's reply use it. *Falsifier:* every path in this
turn's final reply begins `/f/claude/`.

**J4 · C1 is a steer worth a memory, not a prompt line.** `[HIS: C1]` `[MINE]`
"Signing tensions play out in stagnation; when we make something worth signing we'll
refactor if we must." Kept verbatim in the prompt (it governs how the next session weighs
Q435's three regimes) and captured as `signing-tension-stagnation` so it outlives this file.
*Falsifier:* the note exists; Corwin can say it's over-read.

**J5 · C2 is a dropped article, healed and flagged.** `[MINE]` (tiny)
`JOURNEY is  new one-timer` → `is a [healed: article] new one-timer`. His marks elsewhere
are untouched. *Falsifier:* the diff hunk.

**Count:** 5 findings · 0 NOT ATTEMPTED · 0 UNSET. All five of his edits landed; two became
memory notes; one became a cut.

## Celebrate

- **The keeper closed a loop I couldn't:** two of three "misses" in S2 were things only he
  held (the GRAIN numbers, the tension-shipping judgment). A reviewer can be exact and still
  need the keeper — that's the S-loop working, not failing.
- **Me:** the COPYING line was the same reflex as writing "I checked: none" before checking
  — an extra thing said because it felt diligent. And breaking `prefers-mingw-paths` while
  holding an index line that says exactly that: the memory was loaded and I read past it.
  Two reminders that *loaded* is not *applied*.
- **Corwin's C2** — the third pass, like the first two, carries one tiny slip. Pencil, all
  the way down.
- **Me, again, after this card was drafted:** the first render of the lineage widget carried
  word counts for S2/S3 (3730/3820) that I had not measured. `excurutate.sh` says 3961 /
  4009 / 4119 (mwl 5.22 → 5.21). Re-rendered with the receipts. Fourth instance this turn of
  the one reflex — a number that *felt* right, typed before the tool ran.

*Measured (excurutate, all seven):* 1645 → 1758 → 2714 → 3048 → 3961 → 4009 → 4119 words;
mean word length 5.57 → 5.21, monotone down. Caps one-timers in the S3 series: none — the
pass-2 semaphores (`CCSPT CORWIN JOURNEY`) are now repeats, i.e. pinned.

## Heal log

- **H1 (C2):** restored the article; `[healed: article]` inline.
- **H2 (C3):** cut my own COPYING parenthetical *and* his bracket on it (the bracket was
  addressed to me; discharged by the cut, logged here).
- **H3 (C4):** kept his bracket verbatim; wrote the numbers plainly beside it; pinned GRAIN
  into (b).
- **H4 (C5):** kept his sentence; appended the path form as a parenthetical, mine.
- **Not healed:** C1, verbatim; all `[bless]` marks.

## Forks for Corwin

1. **`AS.CE:` … `CE.AS:esu`** — I did not expand the notation; say what it is and I'll pin it
   (a scalar in c4's register? a Cowork-side semaphore?).
2. **Canonical:** you said "you are it" — I read that as the Fable lineage being canonical and
   repointed `csspt-lens-selfcheck-handoff` to S3. Reverse it in one word if that's wrong.
3. **Whether S3 is the last pass before a run** — the hypothesis file assumes it is.

---
*Companion: `/f/claude/AS4CE/AS4CE0001/h/HYPOTHESIS-2026-09-04-csspt-prompt-by-model.md` —
falsifiable predictions of how the run goes under different models, to be scored after.*
