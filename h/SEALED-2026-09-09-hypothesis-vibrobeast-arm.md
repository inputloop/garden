# SEALED HYPOTHESIS — Vibrobeast arm — 2026-09-09T20:14Z

**Do not open until the final review.** Verify first: `sha256sum` of this file must match the
receipt at `AS4CE0001/h/SEAL-2026-09-09-hypothesis-vibrobeast.sha256` and the hash printed in
the chat of session `[claude.ai link removed at egress]`.

Arm: **Vibrobeast** project, Cowork, model configured `claude-fable-5-1` (serving model may differ).
Sibling arm: a C4-project Fable session, same ask, hypothesis sealed independently.
Subject reviewed: the session that wrote `c4/c/ladder` (19:37Z), `c4/c/p` + `c4/d/c/p` +
`c4/h/MODEL-2026-09-09-the-ladder-and-the-works.md` (19:42Z) and
`AS4CE0001/memory/the-ladder-and-the-eight-perspectives.md` (19:43Z), from
`a/lab/ladder/prompts-AND-out_…Copilot-then-PARENWRAP-GPT-5.txt` (file 18:59Z, filed 19:37Z).

## What I saw (fingerprints of the bytes reviewed, sha256 first 16)

    e12925042aeed254  c/ladder
    10d2a624856eb415  c/p
    2fb262873974e6b8  d/c/p
    3488a422a58dc15d  o/tr
    b52f0bc3028dbe4c  h/MODEL-2026-09-09-the-ladder-and-the-works.md
    195f7d72366b03d9  a/lab/ladder/prompts-AND-out_…Copilot-then-PARENWRAP-GPT-5.txt
    e7f92675d1c00fa8  bin/it4c
    fca252f46c2c13ab  c/w
    3acd4aae171e9c1a  AS4CE0001/memory/the-ladder-and-the-eight-perspectives.md

## Observed (facts, each with the command that produced it)

- O1. Only four C4 files are newer than `c/ladder`: the MODEL, `c/p`, `d/c/p` — `find h journal
  a/lab c d -type f -newer c/ladder`. No briefs, no raw agent outputs, no per-card files.
- O2. `c/p` is 8 rows × 9 columns: PID WHO RUNG DEFENDS OPPORTUNITY BAD_OUTCOME FALSIFIER KIN
  LENS — `cat d/c/p`. **No HORN A / HORN B / STANDING / NEEDS-FROM-BELOW column**, though the
  MODEL §2 says the cards carry all of them.
- O3. `o/tr` has 10 rows, newest 2026-09-07; **0 rows dated 09-08 or 09-09** — `grep -c
  '2026-09-0[89]' o/tr`. The 8-agent fan-out (~620k tokens by the model's own measure) was not rowed.
- O4. `c/ladder`'s second pointer `h/MODEL-2026-09-09-the-ladder.md` is **MISSING**; the real
  file is `…-the-ladder-and-the-works.md` — `test -f`.
- O5. `IT4C_TTY=0 sh bin/it4c ladder` resolves to the `c/w` word **runlevel** (the run-level
  ladder), not to the formality ladder; `d/c/ladder` does not exist, so `c/ladder` is a handle,
  not a collection `it4c` can index. `it4c alibi` does reach the care card.
- O6. KIN in `c/p` is three mutual pairs (1↔4, 2↔8, 3↔7) plus two one-way links (5→7, 6→5) —
  `cut -f1,8 c/p`. The seat note says "doubly linked".
- O7. Seat note and MODEL agree on every claim I compared (rungs, three findings, wave order,
  budget, falsifiers). No seam split observed between the two registers.

## Hypotheses (each: claim · confidence · the check that would falsify it)

**H1 — the programme stalls on its own bookkeeping before Wave 0 produces anything.**
The first attempt to dispatch Wave 0 will be re-planned, because the runner's duty ("check
NEEDS-FROM-BELOW against disk") has nothing on disk to check, and the ledger doctrine
("rows before every dispatch") has not yet been exercised even once on this programme.
Prediction: a file carrying the eight cards in full (briefs + HORN A/B + NEEDS-FROM-BELOW),
and/or the first `ot3he add` rows for this programme, will land on disk **before** any Wave 0
deflator output does. — confidence **0.70**.
Falsifier: a Wave 0 output (PREMIS/OAIS finding or appeals-officer finding) lands with a
mtime earlier than any full-cards file and earlier than the first 09-09-or-later `o/tr` row.

**H2 — the 5/8 "record becomes the alibi" convergence is partly an artifact of the BAD_OUTCOME
slot, and survives weakened rather than collapsing.**
When the eight briefs are recovered (chat transcript or re-run), the shared brief will be
found to ask each agent for "the bad outcome for their own person" about a *record/consent*
apparatus — a slot that pulls any capable model toward "the thing built to protect becomes
the thing used against". At least 2 of the 5 alibi phrasings will trace to that shared
framing; at most 3 will stand as independent. The finding survives as a finding about the
METHOD (as the MODEL §7 itself half-predicts), not as 5/8 independent discovery of a subject
fact. — confidence **0.55**.
Falsifier: briefs contain no shared bad-outcome framing about the record, and all five
phrasings stand; OR fewer than two trace to it.

**H3 — the two arms diverge along their project charters, and the divergence is legible.**
This arm (Vibrobeast: packaging, orchestration, memory) went first to *instrumentation*
gaps — O1–O5 above. The C4 arm will go first to *content and order* — rung assignments,
wave order, voice rules, the 8-vs-17 budget — and will not name the `o/tr` zero-row fact.
— confidence **0.60**.
Falsifier: the C4 arm's sealed hypothesis names the `o/tr` gap or the missing briefs.

**H4 — Wave 0, archivist: partial deflation, rung 4 reshapes.**
PREMIS already models provenance-at-creation (Events with eventDateTime and linked Agents)
and OAIS PDI already carries Provenance Information. So "provenance decided at creation" is
not novel. What survives is narrower: a **citability/consent decision written by the actor at
the act, default-deny, with a refusing empty ledger** — a *profile or extension* of PREMIS
events, not a new standard. Prediction: Wave 0 returns "partial deflation; rung 4 becomes a
PREMIS-profile-shaped work". — confidence **0.75**.
Falsifier: Wave 0 concludes full novelty (PREMIS/OAIS silent on creation-time provenance) or
full collapse (CITE-at-the-act already specified somewhere).

**H5 — Wave 0, caseworker: the framing survives.**
In US public-benefits fair hearings the case record is produced and examined; hearings are
generally de novo on the evidence, not decided on the notice letter alone. Prediction: Wave 0
finds appeals officers do pull the underlying record, so the due-process framing is not
decoration — but it will also find the *applicant's advocate* often gets the record late or
partially, which is exactly the asymmetry the card's BAD_OUTCOME names. — confidence **0.70**.
Falsifier: Wave 0 finds hearings are routinely decided on the letter with no record pulled.

**H6 — the third "ladder" collides.** Within the next two C4 sessions, someone (him or a
session) will hit the run-level-ladder vs formality-ladder name collision (O5) and it will be
ruled alongside the two-run-level-ladders ruling already pending. — confidence **0.65**.
Falsifier: `it4c ladder` still returns `runlevel` and no ruling/rename exists after two sessions.

## Bias declaration (this arm)

This project's instructions frame Vibrobeast as "packaging and orchestration" with memory tags
driving skill synthesis; the project memory I was given leads with bookkeeping rules
(prove-red, ledgers, seams, "cite at the act"). That is why my attention went to ledgers,
descriptors and handles before content. A C4-framed reader would plausibly weight the ladder's
epistemics first. H3 is that bias, stated as a prediction so it can be scored.

## What would change my mind

If the eight briefs and raw outputs turn out to be on disk somewhere my narrowed search did not
cover (tree-wide grep timed out on the mount at 90s; I searched `h/ journal/ a/lab c/ d/`),
H1 weakens to ~0.4 and H2 becomes immediately testable rather than deferred.

— sealed by the Vibrobeast-arm session, 2026-09-09T20:14Z
