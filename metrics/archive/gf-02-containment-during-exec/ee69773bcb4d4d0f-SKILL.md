---
name: gf-02-containment-during-exec
description: C4 canon skill: gf-02-containment-during-exec. each card is a stance on how to bound what transacted, executed code does *while it runs* — the gap `gf-02` names. DRAFT trigger — refine before dist. Use when this canon is in question.
c4_provenance:
  source_deck: decks/gf-02-containment-during-exec.deck.md
  source_sha256: 4d8fb3c19128a4540b56fa51366b06f5c39dcae218f32fbd43f78d54250115ca
  minted_at: 2026-07-27T10:51:25Z
  status: draft-from-canon
---

# gf-02-containment-during-exec — a C4 canon skill (DRAFT)

each card is a stance on how to bound what transacted, executed code does *while it runs* — the gap `gf-02` names. A missing card would be an unbounded reach. This is a **design deck** (possibility space, losers kept), not an enforcement layer; the merge that picks an option is Corwin's roll. It sits UNDER `gf-01` (no fantasy virtue crosses a control boundary) and the compute-consent canon (proofs offered, never demanded).

## Canon (the deck's card faces)

- Tumblers and the XX pair are proof-BEFORE (consent to enter a run-level) and proof-AFTER (roundtrip + attestation). Neither bounds what transacted code DOES mid-run. "However sandboxed" is a concession that the sandbox is not yet the control.
- Every real-world reach the code can make — network, filesystem, a named system interface — is a CAPABILITY, default-denied, and each grant is its own consent-bearing tumbler. The bound is the set of granted capabilities, never a trust in the code's good behavior.
- The run emits a boundary-view of what it TOUCHED — which capabilities it exercised, volumes, which interfaces — never the payload. Guarded visibility (gf-01-honest, not fog) applied to execution itself.
- Distinguish where the sandbox IS the control (a boundary the code cannot escape, enforced below the code — kernel/OS/jail) from where it is theater (a convention the code could ignore). Only the former counts toward the bound; name which one you actually have.
- An irreversible or high-blast reach mid-run — delete, send money, exfiltrate, mutate a production system — requires a during-run consent event at the moment of the reach, never a pre-granted blanket. The two-key handshake, live.
- Rejected: "just require the code to attest what it will do, and verify after." Kept as the contrast that DEFINES gf-02.
- Rejected: "forbid running client code at all." Kept as the boundary condition, per §2.

---
*Minted from `gf-02-containment-during-exec.deck.md` by c4cs v0.1. This is a knowledge-hook draft: its trigger description
and any tool want skill-creator / polygram before `make dist`. C4 promise = source_sha256
4d8fb3c19128 (verifiable by ccspt re-hash of the source deck).*
