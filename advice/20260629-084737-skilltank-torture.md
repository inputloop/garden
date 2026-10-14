---
candidate: skilltank
decision: ENHANCE (applied)
recorded: 2026-06-29T08:47:37+00:00
operator: Corwin
---

# skilltank — industrialized the torture discipline

- Added `scripts/torture.py` (plan/score; env-override matrix; DRIVES/HALTS pass,
  DESCRIBES/DRIFTS + cross-version regression = FAIL/exit 1).
- Added `scripts/consent_gate.py` (last gate; variable-or-consented identity PASS;
  concrete publisher without consent = BLOCK/exit 1 — "nobody ships unconsented").
- SKILL.md: CORWIN local model stands in as supervisor when unsupervised
  (`{USER^^}` → CORWIN); torture + consent gate baked into skilltank **for now**,
  until/unless factored to its own Persona.
