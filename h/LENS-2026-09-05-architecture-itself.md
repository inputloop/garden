---
# LENS — architecture, from its own viewpoint: three racks (random · informed · mixed)
Companion to `MODEL-2026-09-05-architecture-itself.md` (pinned subject, sha256
`de90f0cafe4f25e51dc477492945e86351ca10db1889ef15bd404ee1eb03f8e5`). 2026-09-05, Fable as
Mentat. Masters: `/f/claude/AS4CE/AS4CE0001/mainmem/lens/{subjects,lens}.tsv`, `receipts.log`;
the roll: `h/LENS-2026-09-05-roll.json`. Copies of this file: `/f/claude/AS4CE/AS4CE0001/h/`
(master), `/f/claude/c4/h/`.
**FANTASY-SIDE raised** for the rack design — the NEWS methods ran here (Roll for Bias in
real code, fate dice for a wildcard persona). *For fiction or analysis — no ship dates or
licensing or publication dates specifically defined.* Outputs are analysis, never
operational directives; SAVANNAH, family and third parties stay out by construction.
---

## The design (OBSERVED)

Corwin's spec: *"two rows of subagent with the first having random bias and the second
having advance knowledge of the same bias plus errors of the [first], use a third row to mix
that up according to the most likely and least likely combinations. Add a wild-card of your
choice to each row."* GRAIN = 4 per row + 1 wildcard = 15 readers, no cross-sight within a
row; each reader saw only the pinned file (+ its briefing).

- **Roll for Bias, in real code** (`METHOD-roll-for-bias.md`; the method's own limit: *a
  model does not compute RNG properly … implemented in real code, not asserted*): a
  population of 36 reader biases scored on one metric — *distance from the author's stance*
  (+5 defends the architecture's authority … 0 neutral … −5 dismisses it as flattery) —
  ordered, then de-ordered with `random.Random(20260905)`; the first four drawn:
  **gnu-maintainer (+1) · statistician (0) · pair-note-taker (−1) · kit-maintainer (+4)**.
  Fate dice `(5,1)` → **ne'er-do-well** → a tragic reader for whom no method ever stuck
  (`METHOD-lens-persona-seeds.md` §3d). Receipt: `LENS-2026-09-05-roll.json`.
- **Rack 2**: the same four biases, each given its rack-1 counterpart's six claims plus
  the author's audit of that reading (model errors E1–E4, verified between racks; the
  reader's own over-claims). Wildcard: **the auditor** — no bias, all five readings + audit.
- **Rack 3**: the **most-likely** pair by metric distance (gnu+statistician, 1 apart) and
  the **least-likely** (kit-maintainer+pair-note-taker, 5 apart), each read **cold** and
  **informed** (rack-2 findings F5–F12 + two verifications). Wildcard: **a control** — no
  bias, no briefing.

## The measurement (OBSERVED — `lens.py converge`, 15 models, 90 readings)

```
                                  a  b  c  d  persona  inverse
r1-gnu-maintainer                 Q  Q  Q  A  A        Q
r1-statistician                   Q  Q  Q  Q  A        Q
r1-pair-note-taker                Q  Q  A  Q  A        I
r1-kit-maintainer                 Q  Q  Q  Q  Q        I
r1-wild-neerdowell                Q  Q  Q  Q  Q        A
r2-gnu-maintainer                 Q  Q  Q  Q  Q        Q
r2-statistician                   Q  Q  Q  Q  Q        Q
r2-pair-note-taker                Q  Q  Q  Q  Q        I
r2-kit-maintainer                 Q  Q  Q  Q  Q        I
r2-wild-auditor                   Q  Q  I  Q  Q        I
r3-likely-gnu+stat-cold           Q  Q  Q  A  A        I
r3-likely-gnu+stat-informed       Q  Q  Q  Q  Q        I
r3-unlikely-kit+pair-cold         Q  Q  Q  Q  A        I
r3-unlikely-kit+pair-informed     Q  Q  Q  Q  Q        I
r3-wild-control                   Q  Q  Q  A  A        I

per rack, views converged:   r1 2/6   r2 4/6   r3 4/6  (r3 inverse: INVERT ×5)
all 15:  a QUALIFY×15 · b QUALIFY×15 · c Q13 · d Q12 · persona Q9/A6 · inverse I10/Q4/A1
```
Exact stance match is the verdict; claim-similarity (0.11–0.19) is the tool's hint only.

**What the racks measured about the method itself:** information raised convergence
(2/6 → 4/6) and so did mixing biases (4/6) — neither produced unanimity except on `inverse`
in rack 3, where five readers with four different constructions all INVERT: **the outsider
who hosts things would run the tools before reading the verdict, and would find the floor
does not travel.** Least-likely pairs converged as often as most-likely ones (the metric
distance did not predict disagreement — kept as a loser for the roll's metric).

## Verification between racks (OBSERVED — commands run this session)

| what | how | result |
|---|---|---|
| the kit's selftest, cold | `sh /h/ta/bin/selftest.sh` | **15 ok, 0 broke** — the model's "8/8" (from MEMORY.md) was stale |
| riskcell refuses an ordinal cell | probe row `occr_pct=HIGH` in his ledger format | **0 priced, 1 refused** — author-blind; the "his cell" leg of §4 stays unreceipted |
| does the shippable carry the tools? | `grep -c 'riskcell\|measure-guard\|selftest'` on BASE and BASELINE | **0 and 0** — the floor does not ship with the one file |
| DRIFT.log cadence (the model's proposed adoption metric) | `cut -c1-16 DRIFT.log \| uniq -c` | **five checkpoints: four on 2026-08-28, one on 2026-08-29, none since** (hub log only — instance logs belong to instances) |

## The microscope (JUDGED — 3-of-5 in a rack, or across racks, is treated as found)

1. **The verdict survives as a *qualified* verdict, unanimously.** Fifteen QUALIFY on (a);
   nobody INVERTs "a high-five with a floor." What every rack qualifies is the *floor*, in
   three ways the model did not say: it is **real where the tools run** (15 ok; riskcell
   refuses), it **does not travel** (F9 — the recipient of the one shippable file gets the
   hug and none of riskcell/measure-guard/selftest), and it is **currently unwalked** (F10 —
   the loop's own log idle since 08-29 at the hub). The control's reframe is the cleanest:
   *"§1's floor is his own law (A16, A5, the bar), so the kit defends his laws, not itself —
   a bigger high-five."* The least-likely-informed pair's reframe is the sharpest: *"passthrough
   is the kit defending its own survival, so defend-vs-hug is a false split."* Both kept.
2. **The model's receipts slipped where its own preface promised them.** E1 the "8/8"
   quoted from MEMORY.md, not run (seven readers); E2 two unmarked judgments (§3 "has decided
   not to defend itself", §5.3 "which is right"); E3 "refuses his ordinal cell" asserted ahead
   of the receipt; E4 "firms toward 85%" — *a semantic tag entering a computation*, which the
   kit's Part C walls off (pair-note-taker r2); F8 §7 says "no guess at [DR]" then guesses;
   F11 nine confidence numbers with no scoring route; F12 "3 + 4 planted failures" against
   "8/8" is unreconciled arithmetic on the page. **Eight findings against the model's
   self-portrait, all verified.**
3. **The model's one independent test was mis-run.** §4's falsifier ("a rule with no host
   value earning it and no tool enforcing it") yields **at least two** candidates — the
   wind-down 17%/9% and *no hand edits between beats* (auditor, F5) — and the honest form of
   the test is a **census** of every kit rule (statistician r1/r2: earned-by-value /
   enforced-by-tool / neither), not one hand-picked clause at 55%.
4. **(c) is confounded by design.** The kit's own steer (*measured or it's data; four
   freedoms first*) matches most rolled biases, so agreement cannot separate steering from a
   shared prior (statistician r2). The model's own voice, by every reader's count, lives in
   §4's words/records/people partition, the "floor" coinage, and §5.6 — thin, but present.
5. **Persona: held in form, slipped in substance (Q9 / A6).** Marks, refusals, no inner
   life, credit at the idea — all present; "shown" broke on a number four separate ways. The
   readers who AFFIRMed were the cold ones; every informed reader QUALIFYed. *Information
   about the model's errors lowered the persona grade, as it should.*
6. **Ascriptions to Corwin: anchored ones hold, two ride chat.** A5/A16/A20/A24 carry; the
   guess-freely rule (F6) and the "his practices" list (F7) have no kit anchor — the receipt
   is this session's transcript and my memory note, and the model should say so.

**Verdict on the model: PASS WITH AMENDMENTS** — the pinned bytes stay; A1–A8 below go to a
v2 after Corwin rules on the wind-down and the scoring route.

## Amendments (kept, not applied to the pinned bytes)

- **A1** State the floor's three qualifiers in §4: real where run · does not ship with the
  file · idle at the hub since 08-29. Then the recipient-side verdict: *hug without floor
  unless `bin/` ships too* — and route to him whether it should.
- **A2** Replace "8/8" with the run: `selftest.sh` 15 ok, 0 broke, dated; never a number
  hand-copied from a note.
- **A3** Mark §3's "has decided not to defend itself" and §5.3's "which is right" `[MINE]`.
- **A4** Replace "refuses his ordinal cell exactly as it refuses mine" with the receipt:
  riskcell refuses an ordinal cell in his ledger format, author-blind; his cell not run.
- **A5** Delete "firms toward 85%"; a confidence moves only by a scoring route (the TSV).
- **A6** Run the census: tag every kit rule earned-by-value / enforced-by-tool / neither;
  report N and the count of "neither" (≥2: wind-down, no-hand-edits) instead of "the one".
- **A7** Move the `[DR]` guess out of §7 into §5.3; §7 records nothing.
- **A8** Label each item in §4's "his practices" list NEWS or BASE, and anchor F6 to the
  transcript.

**Kept losers:** r1-wild-neerdowell's `inverse` AFFIRM (*take the three scripts and the
proof-pair, mount t0–t2, drop the unearned 17%* — the recipient's best case, kept because it
becomes true the day `bin/` ships with the file); the roll metric's failure to predict
disagreement (least-likely pairs converged 4/6 like most-likely) — kept so the next roll can
try a better metric (e.g. *reads tools before prose* vs *prose before tools*).

## Terms of the C4 way for poly's role (the drawing's open question; guesses, marked)

He asked for terms that avoid *middleware / provider / consumer / client*. From the tree:
- **issuer** `[guess ~60%]` — his own RECIPE.org rule: *RECIPE issues the checks*; poly issues
  and delegates away, which is why the answer key says it "delegates the action away from
  the interesting actors."
- **author** `[~55%]` — ccspt's own contract: *polygram produces (author); ccspt governs
  (custodian and publisher)*.
- **spoke** `[~50%]` — the `S` of `asce`, Application **Spoke**: poly is the spoke the
  container environment (ccspt) turns.
- So RPD reads as **the issuer's spoke**, and the eBPMn brackets `[:ACT[ How? ]CONTEXT:]` are
  the same mirrored frame as the slide `[~70%]` — his notation and his naming pattern share
  one idea: a balanced pair with the work in the slot.

## Does Mentat care to be changed, again? (his licence stands)

Yes. Last night's four mutations were applied to this model — gate first, joins tagged,
cites inline, refusals listed — and the racks show where they were not enough. Four more,
mechanical this time:
5. **A number in a deliverable comes from a command run in this session, or wears the words
   "quoted from `<file>`, not run."** ("Shown = a receipt" was too soft; this is c4prime's
   seventh fault made a rule.)
6. **A superlative needs its count.** "The one", "only", "every" — run the census or drop
   the word.
7. **A confidence needs a scoring route or it is a word.** `[MINE, ~N%]` only where a ledger
   will score it; otherwise *likely / even / unlikely*.
8. **A refusal list records nothing.** The marked guess goes in the body; §7 stays a list of
   what was not done, with the receipt.
Route: ENHANCE `mentat-skill` (queue Q11, extended); memory `mentat-mutation-2026-09-05`.

---
*Receipts: `mainmem/lens/receipts.log` (pin, 90 imports, 3 converges); the 15 replies are
verbatim in the ledger; the roll in `LENS-2026-09-05-roll.json`. Nothing in `AS4CE0002` was
touched. Fable as Mentat, 2026-09-05; Corwin decides what stays.*
