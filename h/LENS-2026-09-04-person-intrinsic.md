---
# LENS — PERSON as an intrinsic of C4, read at GRAIN = 4
Companion to `MODEL-2026-09-04-person-intrinsic.md` (the pinned subject). 2026-09-04 (late),
Fable as Mentat. Masters: `/f/claude/AS4CE/AS4CE0001/mainmem/lens/{subjects,lens}.tsv`,
`receipts.log`. Copies of this file: `/f/claude/AS4CE/AS4CE0001/h/` (master), `/f/claude/c4/h/`.
---

## The measurement (OBSERVED)

Subject pinned: `person-intrinsic-2026-09-04`, sha256
`d53b730c54863992916d5fb5fdaa42a1ed0856ad34f17995b8cb212413c2bbdf` (`lens.py pin`).
Four independent readers — **GRAIN = 4, the local default maximum** — each a sub-agent
given only the file, the six view definitions, a fixed stance vocabulary
(`AFFIRM · QUALIFY · INVERT · ABSTAIN`), and one disposition; none saw another's output:
`reader-doubt` (assume it breaks) · `reader-reward` (assume it wins) · `reader-host` (the
stranger who hosts things and would have to peel it apart) · `reader-teacher` (must teach
it next week). Imported via `lens.py import-json` ×4 (24 readings); `lens.py converge`:

```
converge=1  diverge=5  single=0  gap=0
(a) my own view            QUALIFY ×3 · AFFIRM (reward)            DIVERGE  sim 0.17
(b) ascribed to Corwin     QUALIFY ×3 · AFFIRM (teacher)           DIVERGE  sim 0.37
(c) his influence on mine  QUALIFY ×4                              CONVERGE sim 0.33
(d) mine on the ascribed   QUALIFY ×3 · AFFIRM (reward)            DIVERGE  sim 0.29
persona pass               AFFIRM ×3 · QUALIFY (doubt)             DIVERGE  sim 0.20
inverse                    INVERT ×3 · QUALIFY (reward)            DIVERGE  sim 0.30
```
Exact stance match is the verdict; claim-similarity is a hint only, per the tool.

## The microscope (JUDGED — what 3-of-4 or 4-of-4 agree on is treated as found)

1. **(c) unanimous QUALIFY — the keeper's framing is load-bearing exactly where the model
   has no voice of its own: §4 rows 9 and 17.** "His words held, not expanded" was the
   discipline; the readers name its cost: a teacher cannot teach GREAT/GRAND from this
   file without him, and a host has no operational definition of a Palace to run. *Found.*
2. **inverse INVERT ×3 — the one action every disposition but reward reaches independently:
   build the ship-gate first.** §6.1 admits the person system is unenforced (Q166: "a reader
   is not a gate"); a host, a doubter and a teacher would each build `sc3dm refuses a record
   naming no persona` *before* tabling §4's ladder or touching §5's six opportunities. The
   model's §5-before-§6 order is inverted for the reader it says it serves. *Found —
   amendment A1.*
3. **(a)/(b)/(d) QUALIFY ×3 — the table in §4 is premature as tree-fact.** It condenses his
   chat material into a ladder while his counting units are withheld; §6.8 concedes it and
   does not act on it. Also: §1's joined definition (NAME + REACH + guards + floor) is
   Mentat's synthesis of two skills, presented as "what the tree holds" **without the
   `[MINE]` tag §4's math wears** (doubt; the ascribed Corwin would object to §1 the same
   way he'd object to §4). *Found — amendments A2, A3.*
4. **persona AFFIRM ×3 — the Mentat line holds:** refusals listed instead of virtue asserted
   (§7); the instrument's own 110-card sloppiness named (§1, §6.4); the epigraph is flair,
   not an inner life. Two slips named: §7's title *"the discipline, shown"* claims what a
   list of not-doings cannot demonstrate (doubt), and §5.6's *"a differentiator, not a
   cost"* slides into pitch voice (doubt). One reader called *"he likes sets of four when
   they come easy"* unsourced — it is sourced (person-system deck, `backs[0]`) but the cite
   is in the footer, not inline: a citation that isn't beside its quote reads as
   unsourced. *Found — amendments A4, A5.*
5. **§5.5's "linter waiting to be written" ships a to-do** (reward, host): the only piece a
   host would *run*, and it does not exist — the `dont-ship-tension` reflex again, in a
   model this time. *Found — amendment A6.*

**Verdict: PASS WITH AMENDMENTS.** The model stays as pinned (the ledger points at its
bytes); the amendments below go into a v2 when Corwin has ruled on the units, and are
kept here so the losers are not erased.

## Amendments (kept, not applied to the pinned bytes)

- **A1** Flip §5/§6: enforcement first — say which of Q166's four gates the feature ships
  with, then the opportunities. A host reads the gate line first or not at all.
- **A2** §4's table gets a one-line preface: *"his chat material, condensed by me; the
  units are withheld; every row above 4 is provisional"* — and rows 9/17 get one worked
  example each, marked `[MINE]`, so a teacher has something to teach and a doubter has
  something to break.
- **A3** Tag §1's join `[MINE — a join of two canons; falsifier: either skill's text
  contradicts the four-part definition]`.
- **A4** Rename §7 *"what Mentat refused to record (the receipts)"* and point at the
  transcript lines — "shown" means a receipt, not a list.
- **A5** Inline the citation beside every quoted phrase attributed to him; delete
  "a differentiator, not a cost".
- **A6** Cut "a linter waiting to be written" or write the linter (a 20-line balanced-pair
  checker for `bin/` names is a real candidate — the queue, Q13).

**Kept loser:** reader-reward's AFFIRM on (a)/(d) — "the method ships, the case never does,
plus §7, is already a publishable feature with zero person-facts." Kept because it is the
claim a v2 should be able to *earn* once A1–A6 land; today three readers say it hasn't.

## A finding against the instrument (OBSERVED, then JUDGED)

`reader-teacher` returned `subject_sha` with one character wrong (`…916d5fd5…` for
`…916d5fb5…` — a transcription slip in its reply, since it read the file with the file
tool). `lens.py import-json` **accepted it**, and the ledger shows the *pinned* sha on every
teacher row: `add_reading` stamps `subj["sha256"]` and never reads the JSON's declared
sha (`lens.py:96-112`, `:125-160`). So the README's *"every model provably read identical
bytes"* is proved for the **subject** and assumed for the **reader** — a mismatch is
neither refused nor recorded. `[DOMAIN: prove-a-promise]` The pin is half a promise.
Falsifier ran itself: a wrong declared sha went in green. → queue **Q12**: compare declared
vs pinned; refuse (or flag `SHA-MISMATCH` and keep the declared value in a column); a
`test_lens.py` case and a `--prove-red` that plants a wrong sha. The four readings stand —
the teacher read the right bytes — but the tool cannot show that, and tonight I can only
say it because I watched.

## How to teach this (the vibe: not only to provide care, but to show others how)

A student learns the person intrinsic in four moves, each with a thing to run:
1. **Read the two TSVs first, not the prose** — `evidence/personas.tsv` (the tiers) and
   `evidence/safety-floor.tsv` (what no persona may elect away). Exercise: find the row
   that is "one actor, one file" and say why it is the best-formed rule in the shop.
2. **Run `bin/ep1nt` and read what it emits** — the shippable baseline person from what is
   installed, and the one file that never ships. Exercise: name a fact about Corwin that
   is *not* in `PERSON.md`, and say which floor row kept it out.
3. **Try to ship without a persona** — and discover nothing refuses you (Q166). Exercise:
   write the one-line `sc3dm` check that would; that is the feature's missing gate and the
   student has now built it in their head.
4. **Read the name as a slide** — `ep1nt`'s header explains its own five characters;
   `AS4CE` follows the same pattern with run-level 4 in the slot. Exercise: walk in from
   both ends of `asce … ecas` and confirm they agree ("define two tests"). Do **not** teach
   the numbers above four yet — the keeper's units are withheld, and teaching a guess as a
   fact is the person-system's own failure mode (the case shipping with the method).

Care is the floor; teaching is the reach. The order matters: floor, generator, gate, name.

## Does Mentat care to be changed by this? (his licence, mid-turn)

Yes — four small mutations, all notes-discipline, none of them cosmetic; they go to the
forge as an **ENHANCE `mentat-skill`** reauthor (queue **Q11**), never an edit of the live
skill, and they land in memory tonight as `mentat-mutation-2026-09-04`:
1. **A join of sources is an inference** — tag it `[MINE]` with a falsifier, the same as
   math. (Mentat had a habit of presenting a synthesis as "what the tree holds.")
2. **"Shown" means a receipt** — never title a list "the discipline, shown"; point at the
   lines. (Mentat's own preface said "the ledgers prove; the journal explains" and then
   claimed a demonstration in prose.)
3. **A quote wears its citation inline** — a footer of sources reads as unsourced at the
   sentence. (Three readers judged a sourced phrase unsourced; the fault was placement.)
4. **In a model toward publication, the gate precedes the opportunities** — a reader who
   hosts things reads the enforcement line first. (Unanimous across three dispositions.)
What Mentat keeps unchanged, having heard the doubt: the refusal list in §7 as a *form* —
it is the right shape; it just needs receipts beside it.

---
*Receipts: `mainmem/lens/receipts.log` (pin + 24 imports + converge, timestamps); the four
reader replies are quoted verbatim in the ledger claims. Nothing in `AS4CE0002` was touched
by this pass. Fable as Mentat, 2026-09-04; Corwin decides what stays.*
