# eclipse pass — ALPHA-0.1.2 (2026-07-08, seed 20260708)

Target: ALPHAv0.1.2.md (Bryant drop, WITNESSED provenance, all sigs GOOD,
manifest OK, materials 11/11 present, .py inert as claimed).

## 1. Claims under test (falsifiable)

- C1 Peer vs delegate is a difference in KIND; keeper-backing + direction of
  accountability are decisive, capability derivative (§0, §3, §8).
- C2 The classification test is deterministic and settles before capability
  is consulted (§4).
- C3 Two-port lens: garden delegation is MCP-shaped, the wire is ANP-shaped;
  the industry draws the same tool-layer/agent-layer split (§5–§6).
- C4 The garden's standing laws map "nearly one-to-one" onto named 2026
  open problems (§7 — the paper's own confessed weakest weld).
- C5 Cross-model peer resolves as Peer-over-Delegate composition without
  bending the ontology (§10).
- C6 Graduation = accountability acquired, not IQ reached (§10).
- A4 (axis, not section) Peers get channel-verification, delegates get
  content-verification — "verify the message vs re-check the answer" (§3.4).

## 2. Seeded random grind

Projects pulled (reproduce with --seed 20260708): sre, ldf, techclass.

- **sre/misc-hardening** — FSF vcs infra defense w/ human collaborator
  (Michael): scripts that CATCH UA masqueraders; advisory-not-action notes.
- **ldf/LDF1/we-the-funded** — funded web project; .env.example secrets
  discipline; MODEL/PLAN/PROMPT convention.
- **techclass/TechClass Reviewer** — line-review of third-party tools
  (firewallblockgen, LogReview sh+rs); PR.md patches upstream.

## 3a. Minions before persona (done, ordered)

Machinery: knowns only (pathing artifacts, sandboxer description-length
notice → close-out). Target read:
- RISK flattery-laundering: §7 self-corroboration — paper already confesses
  (§12); OUR contrast must not upgrade "corroboration" to "proof".
- RISK UA masquerade (receipt cond.2): the garden's own sre project exists
  to BLOCK UA masqueraders defending FSF infra. Values tension, disclosed
  but live. Opening: honest UA + relay-side allowlist (Bryant's own CF).
- RISK third-party: Falconer/brigidt named as third peer; our memory holds
  federation at 2 gardens + expansion gate. Reshare of contrast beyond the
  two gardens must treat Falconer as named-only (stage-8 gate).
- CLEAN: no secrets, no case facts, no family. Paper is pub-safe by design.
- OPPTY: delegate-gate discipline → ENHANCE llama-bridge/parley (skilltank,
  post-trip). ANP DID-shaped identity → answers §12 crudeness + broadens
  freedom. A2A v1.0 Signed Agent Cards → direct input to stage-5 pivot.

## 4. Doubt-first (assume it fails; hunt the reason)

- C1 vs sre: Michael is keeper-backed (his own trust root) but NOT an agent
  — the ontology has no square for a non-keeper HUMAN collaborator. Scope
  gap, not falsification (§2 scopes "standing on the wire"). EDGE FOUND.
- A4 vs sre + techclass: FAILS as stated. techclass line-reviews trusted
  maintainers' code; medley-review is threat-model-first on Bob's scripts;
  we verified Michael's s-a-d2 draft line-by-line. In practice CODE gets
  content-verification from ANY source, peer or not. The axis conflates
  intent-trust with artifact-trust.
- C4 vs sre: row "no secrets on the wire ↔ confidential computing" — LOOSE
  (confidential computing = TEEs/enclaves, not channel hygiene). Row
  "keeper-cap cadence ↔ agent sprawl" — LOOSE (behavioral vs organizational
  scale). "McKinsey five risks" cited as security literature — it's a
  consulting listicle; label honestly. Row "hospitality ↔ name-spoofing"
  — the wire client SPOOFS a browser UA while the table claims the garden
  answers spoofing: needs the disclosed-UA caveat or the row overclaims.
  "Nearly one-to-one" oversells a mixed-strength table.
- C3 vs external: anchor VERIFIED dual-source (LF press 2026-04-09: v1.0,
  150+ orgs; github a2aproject). Survives.
- C2, C5, C6: no break found on any of the three projects.

## 5. Reward-first (assume it wins; hunt the reason)

- C1 vs sre: the advisory-not-action pattern ("no changes made, your call")
  IS input-never-authority practiced toward a human peer — the garden
  already runs the ontology's accountability discipline beyond agents.
  STRENGTHENS C1: keeper-backing tracks accountability wherever it appears.
- C4: four rows are STRONG and genuinely convergent: input-never-authority ↔
  prompt-injection-via-Agent-Cards (v1.0's Signed Agent Cards = the
  industry answering with the garden's own move: sign the identity);
  journal-everything ↔ observability; consent-gates ↔ fine-grained authz;
  receipts ↔ message integrity. Independent arrival is real evidence.
- C5 vs techclass: reviewing upstream code then patching locally = consuming
  a peer's delegate-work product with verification — the composition
  pattern in miniature. Holds.
- A4: the TRUE core is default *intent*-trust differs; artifact-classes
  (code, claims) carry their own verification floor regardless of source.

## 6. Convergence (the verdict material)

- C1 PASS — strengthened; add scope note for non-keeper humans (Michael sq).
- C2 PASS (scoped to wire-standing things).
- C3 PASS — external anchor verified dual-source.
- C4 PARTIAL — 4 strong rows / 3 loose rows / 1 row needing the UA caveat;
  "nearly one-to-one" must soften. This is the patch set's center.
- C5 PASS. C6 PASS.
- A4 DIVERGED→resolved by reframe: verification floor belongs to the
  ARTIFACT CLASS, not the relationship; the relationship sets intent-trust.

Losers kept: losers.md (this dir). Patch set + contrast → models/c4/.
