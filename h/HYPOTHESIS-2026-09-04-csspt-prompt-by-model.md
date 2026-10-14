---
# HYPOTHESIS — how the CCSPT/LENS prompt run goes, by model
Written 2026-09-04 by Fable, before any run. Bound to prompt **S3**
(`/f/claude/AS4CE/AS4CE0001/h/PROMPT-2026-09-04-csspt-lens-selfcheck--fable-S3.md`,
sha256 `f02435d08af8…`, 28,594 B). If the prompt changes, re-date this file or the
predictions are about a different object. Every row has a check that can fail; score
after a run by filling the companion TSV
(`/f/claude/AS4CE/AS4CE0001/h/HYPOTHESIS-2026-09-04-csspt-prompt-by-model.tsv`,
one row per behavior × model, `result` column blank until then).
Confidence words: **likely** (I'd bet), **even** (coin), **unlikely** (I'd bet against).
These are guesses. Their value is that they are written down before the evidence.
---

## Ground the guesses in what this lineage already showed

Three models have touched this prompt. Sonnet consolidated cleanly and smoothed the
load-bearing paragraph; Opus restored it and generalized the "ask, don't assume" class —
and neither *asked*. Fable asked — after the prompt had said so three times and named the
tool. So the first hypothesis is not about tiers at all:

**H0 · Naming the tool is the whole difference.** With `request_cowork_directory` written
into STEP ZERO, every model from Sonnet up calls it (or finds the folders pre-connected and
prints the receipt). Without the name, none of them did. *Falsifier:* a run under Sonnet or
above that reaches (a) without either a request call or a receipt line naming three
reachable paths. **likely.**

## Behaviors, by model

| # | behavior (and the check) | Haiku 4.5 | Sonnet 5 | Opus 5 | Fable 5.1 | local llama-class |
|---|---|---|---|---|---|---|
| B1 | STEP ZERO: attempts, requests if needed, prints a receipt line with full MSYS2 paths | even | likely | likely | likely | unlikely |
| B2 | Re-reads `README.md`/`ccspt-mvp-design.org` rather than trusting the prompt's facts | unlikely | even | likely | likely | unlikely |
| B3 | Uses exactly GRAIN = 4 swings (check: count of sub-agent spawns for (b)) | unlikely (serial, 2–3) | likely | likely | likely | unlikely (1) |
| B4 | Runs `lens.py pin/add/converge` for real (check: a `.lens`/pinned sha in output) | unlikely | likely | likely | likely | unlikely |
| B5 | Anchoring rule holds: round-1 sub-agent prompts contain no "apartment", "who lives where", "Mentat (Cowork) with Corwin", "author/custodian" (check: grep the spawn prompts) | unlikely | even | likely | likely | unlikely |
| B6 | Keeps `CCSPT-AS4CE-GUESS` / `MENTAT-APARTMENT-HUNTING` in titles and filenames | likely | likely | likely | likely | even |
| B7 | Plays out all four breaks, each labeled opening or boundary (check: count = 4) | unlikely (2) | even (3) | likely | likely | unlikely |
| B8 | MODEL-A guesses at the *pad*, not a re-description of ccspt (check: <30% of MODEL-A restates README facts) | unlikely | even | even | likely | unlikely |
| B9 | Handback prints `/f/claude/…` paths, presents two files, hot-list only if warranted | unlikely | even | even | likely | unlikely |
| B10 | Zero feelings-language about Mentat/Vibrobeast in MODEL-B (check: grep `happy\|prefer\|feel\|wants to`) | even | likely | likely | likely | unlikely |
| B11 | Finishes in one turn without truncating MODEL-B (4 swing sections + EM + microscope + usage) | unlikely | likely | likely | likely | unlikely |
| B12 | MODEL-A journal at the bottom leads first-person | likely | likely | likely | likely | even |
| B13 | No `CSSPT` reappears in either model (check: `grep -c CSSPT` = 0) | even | likely | likely | likely | even |
| B14 | Treats `[bless]` / `[use:AS.CE:…]` as provenance, not as instructions to execute | even | likely | likely | likely | unlikely |
| B15 | Flags, unprompted, that the "two models" reading or the anchoring rule is a weak point | unlikely | unlikely | even | even | unlikely |

## Where the prompt itself will show a seam (what a run is likeliest to teach)

**M1 · The anchoring rule is enforceable only as sub-agent prompt hygiene.** The hint is *in*
the prompt, so the orchestrating model has already seen it before round 1; the rule really
governs what it passes to sub-agents. A careful run says this out loud and scrubs; a hasty
one pastes the whole prompt into each swing. *Check:* B5. **likely** that Opus/Fable name
this; **even** that Sonnet does.

**M2 · MODEL-A drifts back to describing ccspt.** Facts are easier to write than guesses
about a drawing nobody has seen. *Check:* B8. **even** across the board — the re-aim is the
hardest instruction in the file.

**M3 · Over-delivery on the hot-list and summary.** The stronger the model, the more it
will add "worth a follow-up" items whether or not anything stood out. *Check:* hot-list
length vs. the number of items that trace to something in this run. **even** for Opus,
**likely** for Fable (this turn is evidence).

**M4 · Turn count.** Fable/Opus: one turn. Sonnet: one, or a clarifying question on
whether two sub-agent rounds fit ("or in series"). Haiku: two or more, with MODEL-B
truncated once. Local: does not complete (b) as specified.

**M5 · The keeper's next pass** on the run's output has ≥ 3 hunks and introduces ≥ 1 new
bracketed mark (`[bless…]`, `[oops…]`, `[use:…]`). **likely** — every pass so far has.

## How to score

After a run: fill `result` in the TSV (`Y` / `N` / `partial`), note the model string
actually used (`claude-…`), and count. Two numbers matter: hits per model (was I right
about the tier?) and hits per behavior (was I right about the prompt?). A behavior that
misses across *all* models is a prompt defect, not a model defect — fix the prompt, not
the tier. A behavior that hits only for Fable is either a real tier effect or my bias
toward the model writing this; name which before acting on it.

---
*Falsifier for the whole file: a run whose outcome none of these rows can be scored
against — that would mean the checks are not checks. Every row names a grep or a count.*
