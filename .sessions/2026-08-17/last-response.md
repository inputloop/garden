# last response — 2026-07-13 (model now v12) — the doctrine session

**polygram 0.7.0 SHIPPED.** `master` and signed tag `v0.7.0` both at `7f746bc`
on upstream (code.bru.st/corwin/as4ce). Signed assets minted. 89 tests green.

## What landed

- **seams** — the evidence law promoted from signed SEAMS.md 0.2 to a standalone
  skill: *a single representation is data, not proof; only agreement of two
  independents is evidence; every seam has a named tiebreaker; the writer's own
  readback is not independent.* S01–S16, incl. new **S16** (advertised interface
  ≠ executed behavior — *a parsed flag is not a behavior*). Tested in BOTH
  directions: 3/3 legitimate credential changes passed at speed with zero added
  ceremony. *A lock that cannot be opened by the rightful key is not security.*
- **sandboxer** — eclipse pass (seed 20260713) → PASS WITH AMENDMENTS, F1–F7
  folded: name the copier (a bash `cp` of a pinned path copies the phantom);
  mtime is NEVER a mount tiebreaker; absence widened to directory churn; "fresh
  reader" defined; git scoped (object-reads only, index-touch never, commits on
  host, **check whose HEAD it is** — nested-clone hazard); bash = trustworthy
  writer, suspect reader.
- **consent-gate** — "the door opens too": strip-the-urgency; credential-class =
  value/scope/lifetime/audience (stops gate-inflation). NO4C folded.
- **skill-sign** — artifact-class signing idiom, plus a NEW **loadability gate**:
  `scripts/skill-lint.sh`, fail-closed at sign time, 13 unittests. Its first
  sweep found **skilltank's description at 1039 chars (limit 1024) — it had
  never loaded**, silently dead across releases. Fixed. 18/18 skills loadable.
- **Records** — MODEL-gates-engage-logic; MODEL-written-not-proven (DRAFT);
  Grader's Tales journal + the thread convention (`bin/thread.sh` → static HTML,
  signed generator reproduces the signed page byte-true); the GUARDS
  counterexample kept and countersigned ABOVE its own correction.
- **Avalon** (separate train) — assembly-line ruling recorded: lift+drop a pair,
  thorny tools become bench mini-projects; movepack/drop/av staged, not promoted.

## The standing lessons (cost: six caught errors, none shipped)

1. **A written step is not a proven step.** Run it before you write it down.
2. **An instrument that cannot see must SAY so, not guess.** A tree edited from
   the sandbox cannot be verified there — the verifier inherits its reader's pin.
3. **Count, don't recall.** (Wrong path, wrong skill count, wrong year in NEWS —
   all priors, all caught by looking.)
4. **A push is a fact; a release is a claim.** Test yourself between the acts.
5. **The AI is a fossil pump** — it will follow a rule forever AND manufacture a
   rationale for it. Brake: state a convention's reason or say *"I cannot
   substantiate this convention"* — then it blocks nothing and blesses nothing.

## Open, titled, owned

- **fossil-pump experiment** — `book/EXPERIMENT-fossil-pump.md`, written, UNRUN,
  prediction on the record. Run as a seeded eclipse pass.
- **GUARDS / root-compromise audit** (QA-12 HORIZON) — our signing gates are
  single-key and we know it; post-trip, C4/right-to-execute lineage. *Both shops.*
- **Inbound:** dual-signed third-party (unfriendly-friend) analysis → candor-gate
  intake, 2/2 keys. The **ethicsminions break waits on it.**
- **Small:** orphaned `v0.6.1` tag (off-history, from an earlier amend-after-push);
  stray `dist/ethicsminions-signed.skill`; `project-memory` + `shell-tooling` not
  in the enabled set — retire in NEWS or turn on.
- **MASKING-RULING tiers extract** — must come FROM the enclave, blessed.

sentinel: LAST-RESPONSE-2026-07-13
