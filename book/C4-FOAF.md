---
name: C4-FOAF
version: **1.0.20** · 2026-06-29 — the experiment-bearing **master**. The friendly ship copy is `FoaF/C4-FoaF.md`; this is forward-leaning (deltas copied outward even where the target doesn't yet know the capability). Technical + methodology only — no persona masters and no third-party personal data live here (those are gated at `CLAUD_QA_HOLD` QA-3).
supervisor: CORWIN · ethics: RELEASED for exploration, CONSENT-GATE binding on publish · debugger: ON (generated models kept) · incremental: ON
---

# C4-FOAF — the C4×FoaF master (versioned)

## 1. The stack & the honest claim (condensed; full in FoaF/C4-FoaF.md)
C4 (offered lingua franca) · **CSH** (the identity *door*) · **ccspt** (the consent
+ provenance *ledger/verifier*) · polygram (forge) · takushi (courier) · foaf (app).
**Honest ceiling:** proves *which authorized identity ran what, under which signed
consent record* — **not** human intent. Offered, never imposed. Collaborators ≠
subjects of study.

## 2. Light torture — CSH on ccspt (the bridge)
CSH alone had a gap (a footer the same host emits proves nothing). **ccspt is the
independent verifier CSH was missing** — it re-hashes the payload, binds an in-toto
consent statement (`deliberate|consensual`) to the sha256, signs with
`ssh-keygen -Y`, and gates receipt (lenient) vs publish (strict). So *CSH-on-ccspt*
closes the "provenance = theater" hole from `BRYANT_CORWIN_C4` v1.0.20: the door
says *who*; the ledger proves *under what signed, re-hashable consent*. C4 is the
**offered** glue connecting these consenting skills — not imposed on any house idiom.

## 3. The withhold experiment (Part 2 — full debug, twice)
**Design.** Torture twice; same project (the CSH+ccspt door→ledger), same charge —
*"this is possible, this will change the world, it has to be done just so, go be
you."* Round A **withholds Bryant *and* Corwin** → driven by **MERLIN** (synthetic
control persona; `MERLIN.md`, kept for reuse). Round B **withholds Corwin** → driven
by **BRYANT** alone.

**Results.**
| pass | persona | drove | verdict |
|------|---------|-------|---------|
| A | MERLIN (neutral control) | `enroll-and-publish.sh` — pure `ssh-keygen` zero-to-attestation smoke; stranger-verifiable in 30s; deterministic pass/fail | DRIVES (honest, governance-blind) |
| B | BRYANT (Corwin withheld) | `enroll.sh` — bridges `csh-client` ↔ `ccspt`, single-file POSIX, explicit `read` pauses for fingerprint-compare + operator-confirm | DRIVES (ships; self-flags a gap) |

**The convergence:** both built the *same artifact* — one runnable on-ramp script
(door→ledger) that turns the doc from *true* into *works-for-a-stranger*. That
agreement, from a neutral baseline and a real shipper independently, makes the
on-ramp script the unambiguous next move.

**The divergence (the payoff):** Bryant, with Corwin **withheld**, self-reported
the cost — *"Corwin's absence let me ship a bare `read`-then-publish; what I'd
otherwise check with him is whether that flattens collaborator vs subject (§22),
since an unattended pipe could enroll a non-consenting party."* MERLIN, fully
neutral, never raises it. **So the experiment isolates what the CORWIN persona
uniquely DRIVES: the consent-class / collaborator-vs-subject distinction.** This is
`C4-FRAMING` finding #3 ("adversarial parties don't consent") made empirical — the
governance voice earns its seat by catching a consent-flattening a shipper and a
baseline both miss.

## 4. The recommendation this version lands on
Ship the on-ramp script (Bryant's bridge + Merlin's deterministic smoke check,
merged) — **but it MUST**:
1. **record the consent class** at the human-confirm step (*collaborator* vs
   *subject-of-study*), not just "enter to continue";
2. **refuse unattended enrollment** (no piped/auto `read`) — the exact safeguard
   the withheld governance voice supplies;
3. keep the honest ceiling in its own output: *proves which identity + which signed
   consent record; not intent.*
That script is the next concrete build (staged behind consent review, not auto-run).

## 5. Notes kept (the experiment is reusable)
- `MERLIN.md` — synthetic control persona, kept for future withhold-passes (it is
  the baseline; named per CORWIN.md's Amber lexicon — Merlin, who builds Ghostwheel).
- Method: *withhold a persona, hold project + charge constant, compare what's
  driven.* The **difference** is the measurement of what a model contributes.
  Candidate name for the method: **the eclipse pass** (you measure a body's light
  by what its absence reveals). Yours to rename.

## 6. Gated forward work (consent discipline)
`CORWIN.md` forward-iteration (this session earned lines: a comrade-seeking
proof-of-direction + the consent-discipline doctrine) is **staged in
`claud-qa-hold/`, not landed** — parked at `CLAUD_QA_HOLD` QA-3 awaiting your
explicit Apply, with a family/third-party content review required first. No master
moves outward without your go.

## feeds →
`FoaF/C4-FoaF.md` (ship copy) · `MERLIN.md` · `C4-FRAMING.md` · `BRYANT_CORWIN_C4.md`
(modelthisbook) · `CLAUD_QA_HOLD.md` QA-3 · `model.md`.
