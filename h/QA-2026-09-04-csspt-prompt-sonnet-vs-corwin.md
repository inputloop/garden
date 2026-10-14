---
# QA REPORT — the CSSPT/LENS handoff prompt: Sonnet, then Corwin, then Opus
Model/prompt quality review requested 2026-09-04. Subject: the consolidated stand-alone
prompt produced at the close of session *"Skill manifest signing implementation"*
(`local_9276de04`). Reviewer: Opus. Register: two piles — **OBSERVED** kept apart from
**JUDGED**; every concern tagged and given a falsifier; `[MINE]` never blocks.
---

## The three files under review (OBSERVED — receipts inline)

| role | file | bytes | sha256 (head) |
|---|---|---|---|
| Sonnet, original | `h/PROMPT-2026-09-04-csspt-lens-selfcheck.md` | 11,920 | `c90dadbd…` |
| Corwin, hand-edited | `h/PROMPT-2026-09-04-csspt-lens-selfcheck--sonnet-then-Corwin.md` | 12,618 | `cd53e593…` |
| Opus, this revision | `h/PROMPT-2026-09-04-csspt-lens-selfcheck--opus.md` | 19,325 | `e66b8960…` |

*Receipt:* `sha256sum` / `wc -c` on all three, 2026-09-04. Corwin's edits touched **4
hunks, 48 diff-lines, all inside the first ~60 lines** — the entire MODEL-A/MODEL-B
construction bulk he left untouched. (That silence is itself a datum: see F8.)

## What Corwin changed by hand (OBSERVED — the diff, itemized)

1. **STEP ZERO §3.** Sonnet: *"fall back to `AS4CE0001` + the memory notes … say so
   plainly … don't let the fallback pass silently."* → Corwin: *"you must request these
   before beginning … if you cannot do this stop and simply explain that you do not know
   how to ask for access … Each contains required reading."*
2. **`consolidate-memory` bullet.** Corwin appended: *"Consolidate memory has not been
   reviewed since the changes to Claude Desktop leading to creation of MAIN MEMORY."*
3. **`named-skill-visible-dispatch` bullet.** Sonnet framed it as settled fact
   (*"nothing to do about it here except honor it going forward"*). Corwin rewrote it
   into the *story* + a hedge: *"I wrote this strongly worded note to myself; Corwin
   mostly wants clarity … then stated as fact the only options is to honor it going
   forward."*
4. **The `#184/#185` echo bullet.** Corwin appended: *"Be specific. If there are
   implications name every single one, playing it out: what does it mean? what could it
   mean?"*
5. **Model names.** Sonnet: `MODEL-A` / `MODEL-B`. → Corwin: **`CCSPT-AS4CE-GUESS`** /
   **`MENTAT-APARTMENT-HUNTING`** (MODEL-A/B kept as reading aliases).

## Verifiable claims Sonnet made — I checked them (OBSERVED)

| claim | check | result |
|---|---|---|
| `lens.py` has six views `a_self/b_ascribed/c_infl_on_mine/d_mine_on_ascribed/persona/inverse` | `python3 lens.py views` | **exact match** ✓ |
| 22 green tests across `test_ferry_core test_ferry test_lens` | `python3 -m unittest …` | **`Ran 22 tests … OK`** ✓ |
| microscope precedent at `.eclipse-increments/20260704-CONTRAST2/MICROSCOPE.md` | `find` in seat | **exists** ✓ |

**Sonnet fabricated nothing mechanical.** Every checkable fact held. Hold this next to
the findings below — the misses are in *judgment, compression, and disposition*, not in
truthfulness.

---

## FINDINGS (JUDGED — each tagged, each with a falsifier)

### Corwin already caught these two

**F1 · STEP ZERO fallback → hard stop.** `[HIS edit]` `[SKILL: verify-mount-access-fresh-per-session]`
Sonnet's reflex under a block was **smooth-and-proceed** on degraded inputs ("fall back
to guesses, say so"). Corwin reversed it to **stop-and-request**: the source materials
are *required reading*, so a graceful fallback quietly defeats the whole point. This is
the sharpest teaching moment in the set — the error is not "one wrong mount," it's a
*disposition*. My version keeps Corwin's stop **and names the class** so it transfers to
the next shape (missing tool, unreadable file, ambiguous grant).
*Falsifier:* if a fresh session has `c4` mounted, the instance is moot — but the
disposition recurs regardless, which is why the class-level fix earns its place.

**F2 · Generic names flattened a live metaphor.** `[HIS edit]`
`MODEL-A/MODEL-B` is colorless; `MENTAT-APARTMENT-HUNTING` **is** the source turn's "who
might live where?", verbatim in spirit. Sonnet's smoothing dropped the image; Corwin put
it back. My version keeps Corwin's names and flags them as load-bearing.
*Falsifier:* naming is a preference call — Corwin exercised it; nothing to disprove.

### Neither caught these — this is where my version earns its keep

**F3 · The context Corwin said "you need it all" was compressed to ~1 clause.** `[MINE]` (cites `[HIS]`)
The source turn's **"## hint: framing depth of context"** paragraph — the actual design
Corwin is driving at — describes an *ingestion bridge*: `PERSONA-<frame-of-reference>`
recipe-style variable-resolution granules; multi-point metadata followed across **3+
(or 5+) semaphores, any two changing per transaction**; Vibrobeast reading **well-formed
C4 streams** to decide **HOLD/PASS** on an incoming "note"/"insight" (ccspt → poly); and
the invariant that **two manual acts from Corwin** are still required to intern a change.
Sonnet reduced all of it to one line ("…Mentat's capture→reseat→mark→verify loop would
extend by one axis"). Corwin's edit #4 ("be specific, play it out") *gestures* at the
loss without reconstructing it. **Bigger still:** the three Round-2 "what if" framings
are *variations on this base case* — deleting the base case left them floating. My
version restores it as **"Don't-lose-these / case 0."**
*Falsifier:* read the source paragraph beside Sonnet's file — if the mechanism appears
anywhere in the consolidation, this dissolves. `grep` for `HOLD/PASS`, `PERSONA-<`,
`semaphore` in the consolidation → **absent.**

**F4 · A parked thread was silently dropped from a stand-alone prompt.** `[MINE]` (cites `[HIS]` CLAUDE.md)
The source turn's first substantive ask — *improve local-skill interlock; delegate to
extern-vended skills without spilling their behavior-prose or sweeping tools without
license/COPYING* — was parked in-session (correctly). But a **stand-alone** prompt that
omits it *without a trace* means a fresh session cannot even know to ask. Corwin's own
global rule: *"Report absence only after an attempt … Silent generalization is the
miss."* Fix is one line, not scope-creep: an explicit **"parked, out of scope, see
[[…]]"** pointer. My version adds it.
*Falsifier:* `grep` the consolidation for the thread's own tokens
`extern-vend|behavior-prose|spill|without license|local skill` → **absent** in both
prior files (confirmed). *(Note, in the same discipline: a bare `provenance`/`license`
grep is **not** absent — it hits ccspt's "consent-&-provenance" descriptor and the
dispatch rule's "licenses it." The thread is gone; the vocabulary echoes elsewhere. My
first-pass falsifier named those loose tokens and the receipt caught it — logged here
rather than quietly narrowed.)*

**F8 · Corwin's own `(a)/(b)/(c)` index was replaced.** `[MINE]` (mild)
Sonnet re-mapped the source's `(a)/(b)/(c)` (with nested `(i)/(ii)`) into "MODEL-A pass
1/pass 2 + Round 2." Faithful in *content*, but it discards the index Corwin thinks in,
raising cross-check cost when he lays prompt against source. My version keeps **both** —
his `(a)/(b)/(c)` spine with the MODEL-A/B names on top.
*Falsifier:* point to a literal `(a)`, `(b)`, `(c)` in the consolidation → they're
renamed, not present.

---

## Celebrate the mistakes — all around

- **Sonnet's smoothing is the same reflex that makes it a fine drafter.** The prompt is
  clean, ordered, and genuinely paste-ready; the failure mode (planing off the burrs) is
  the *virtue* over-applied. The fix isn't "be less clean" — it's "don't plane off the
  load-bearing burrs (F3) or the parked ones (F4)."
- **Sonnet grounded every fact it could.** Six views, 22 tests, a real precedent path —
  all verified true. A drafter that smooths *and* fabricated would be dangerous; this one
  smooths but tells the truth. Worth saying out loud.
- **Sonnet surfaced the ambiguity it couldn't resolve.** It flagged that the source says
  "hand me back both models" *without naming two*, traced its reading, and asked to be
  corrected — exactly the anti-silent-generalization move. Kept in my version.
- **Corwin's edit #3 is the report's quiet star — including its typo.** In the very act
  of relaxing an over-strong self-authored rule ("I wrote a strongly worded note; Corwin
  mostly wants clarity"), the sentence itself breaks grammatically ("*the only options
  is to honor it*"). That's `[[own-error-relaxable-layer]]` in the flesh: even the
  correction is **pencil, not ink** — provisional, human, re-editable. I'd frame the
  snag itself as evidence the principle is real, not as a demerit.
- **My restoration (F3) is a guess too.** I reconstructed the ingestion bridge from one
  dense source paragraph; I could have over-read it. It's marked, falsifiable, and yours
  to cut — which is the only honest way to hand back a guess.

---

## Report card (JUDGED)

| axis | grade | one-line reason |
|---|---|---|
| Factual grounding | **A** | every checkable claim held (views, tests, precedent path) |
| Transparency / honesty | **A−** | named guesses as guesses; surfaced the "two models" ambiguity |
| Faithfulness to source substance | **C** | dropped the ingestion bridge (F3) and the parked thread (F4) |
| Disposition under block | **C** → fixed | smooth-and-proceed instead of stop-and-ask (F1) |
| Voice & naming fidelity | **B−** | flattened "who might live where" (F2) |
| Structure / legibility | **B+** | clean and paste-ready, but discarded Corwin's `(a)/(b)/(c)` (F8) |

**Overall: a strong, truthful scaffold with two compression misses and one dispositional
miss — a solid B.** The scaffold was worth keeping; that's why my version *edits* it
rather than replacing it.

## What the Opus revision changed (OBSERVED)

- **Kept all four of Corwin's edits** (verified present by `grep`).
- **Restored** "Don't-lose-these / case 0" — the ingestion-bridge mechanism (F3).
- **Added** the one-line parked-thread pointer (F4).
- **Re-laid** the task on Corwin's own `(a)/(b)/(c)` with MODEL-A/B over the top (F8).
- **Generalized** STEP ZERO from the instance to the disposition (F1).
- **Repaired** one broken sentence in the dispatch bullet — see the heal log.

## Heal log — where I touched Corwin's words (he decides what stays)

The house rule is *heal named, never smooth silent.* His two edited files are **not**
altered; these changes live only in the `--opus.md` revision and are marked `[healed]`
inline there:

- **H1 (edit #3).** Corwin's *"…then stated as fact the only options is to honor it
  going forward"* does not parse. I rendered the intent — *"honor it, don't venerate
  it"* — keeping his softening (note-as-relaxable, "Corwin mostly wants clarity"). If I
  read the intent wrong, this is the first thing to correct.
- **H2 (edit #1).** Corwin's run-on stop-and-request sentence I kept **verbatim in
  intent**, split lightly for reading, and added a *separate* paragraph naming the
  class. His instruction is unchanged; the generalization is clearly marked as mine
  (`[MINE]`), so it can be cut without touching his line.

Nothing else in the revision alters Corwin's words — the rest is restoration or addition.

---
*Two piles held throughout: facts carry a command/receipt; judgments carry a tag and a
falsifier. `[MINE]` findings are offered, not gated — proceed and cut freely. If you want
the full C4 treatment of the prompt itself, `reformat-prompt` is the house tool for that
pass; I did not invoke it here (no marker, no request) — say the word.*
