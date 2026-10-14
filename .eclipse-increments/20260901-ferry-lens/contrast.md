# Eclipse increment — kept losers for ferry + lens (2026-09-01)

*Debugger on: the designs that lost are parked here, not discarded, so a framing
that looks wrong today can be folded back tomorrow. Winners shipped to `h/`.*

## Shared spine (the winner)
`ferry_core.py` — sha256 identity + wordwise-format receipts + hash-keyed TSV.
Both tools move a copy across a boundary and prove it landed by hash. This held
under the opposed-bias check (doubt-first: "a receipt isn't a hash" → so we
download-back and re-hash, not trust the reply; reward-first: "the round-trip is
the whole proof" → converged with doubt-first on: verify by fetched-back bytes).

## Task B — ferry, losers kept
- **L1 · a Python script that calls the Drive MCP directly.** Rejected: a sandbox
  has no route to Drive, and it would *hide the consent boundary* inside code.
  Winner makes `DriveBackend` refuse to self-drive; the agent carries bytes under a
  run-card. (If a future runtime lets the tool hold its own Drive creds, revisit —
  but the consent boundary must stay visible, not buried.)
- **L2 · trust the MCP's success reply.** Rejected: a reply is not a hash. Kept as
  the thing the tamper-test exists to forbid.
- **L3 · Google-Docs conversion upload (default).** Rejected for the mirror:
  Docs-conversion mutates bytes → round-trip fails. Octet-stream chosen. L3 stays
  valid for the *human-readable rendering* copy (the existing 5608 B condensation),
  which is a different artifact from the hash-mirror — kept, not collapsed.

## Task A — lens, losers kept
- **L1 · free-form markdown LENS doc.** How it was done before. Rejected: you can't
  compute convergence over prose, and you can't prove two models read the same
  bytes. Kept because a human still wants prose — so `claim` (prose) rides *beside*
  `stance` (token); the doc is a render of the ledger, never the master.
- **L2 · JSON as the master store.** Rejected: house idiom is TSV ledgers
  (wordwise, MANIFEST-MEMORY, pmo) — grep-able, `ls`-able, stdlib csv. JSON kept as
  an **import** format only (Copilot gave JSON; `import-json` eats it).
- **L3 · difflib auto-scoring of convergence.** The tempting loser. Rejected as the
  *verdict*: a similarity ratio pretends an objectivity the readings don't have.
  Kept as a **hint** printed beside each view, explicitly "NOT the verdict" — and
  `test_similarity_is_hint_not_verdict` pins that a 1.00 similarity still DIVERGES
  when the stance tokens differ. The loser is visible but load-bearing on nothing.

## The live contrast datum (Copilot "my words win")
Seeded into `mainmem/lens/lens.tsv` (reconstructed from making-vibrobeast §3/§9;
raw JSON to re-ferry when C4 mounts). First measurement: models CONVERGE on
`a_self` (instrument-node) and `persona` (voice-from-durables), DIVERGE on
`c_infl_on_mine` — Copilot: *user-words-win*; me: *cross-influence-watched*. That
divergence is the reflection target, now measured not asserted.

sentinel: ECLIPSE-FERRY-LENS-2026-09-01
