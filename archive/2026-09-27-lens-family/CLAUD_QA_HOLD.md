# CLAUD_QA_HOLD — the approval desk

**ENABLED as live desk 2026-07-04** (Corwin: "can we enable AI hold?").
Operating mode: prepared changes park in `claud-qa-hold/`, the box pops
(Apply / Hold / Reject via the question widget), decisions date to `advice/`.

A standing category for **changes Claude prepares but will not land without
Corwin's explicit go**. The human-in-the-loop seam: when a chat needs attention to
finish, the item is parked here and a **box pops** (Apply / Hold / Reject).
Watchword: *faster to application*. Every decision is dated to `advice/`.

## How it works
- **Label** `:CLAUD_QA_HOLD:` parks a note/artifact (distinct from the gate's
  skill-`HOLD`: this holds *prepared changes* of any kind).
- **Staging dir** `claud-qa-hold/` keeps the prepared file beside the live one for
  a clean diff before it lands.
- **The box** offers Apply / Hold / Reject; applying copies into place + logs advice.

## Open items
| id | item | status |
|----|------|--------|
| QA-2 | c4-consent-quartet | **ADOPTED AS START** (identity/package/subscription/register); ongoing — ≥6 dim6 refinement rounds; folded into model.md + GRAMMARY/INDEX. |
| QA-3 | Part-2 persona-withhold double-torture (MERLIN vs BRYANT, Corwin withheld) + C4-FOAF.md versioning + CORWIN.md forward-iteration | **PREPARED, GATED** — torture run + notes kept; **awaiting Corwin's explicit GO** before any CORWIN.md master moves outward or any persona/third-party content publishes (family/third-party content review required first). |
| QA-5 | AI_GUARD_PROVENANCE_CLAUDE — demonstration of which ethical guards are Claude's OWN (fired against Corwin's instruction) vs shared vs Corwin-initiated | **APPLIED 2026-07-04** (moved to Resolved) — see below. |
| QA-8 | security-digest (the QA-7 stowaway) | **APPLIED 2026-07-04** — Corwin held to consider, then: "I'm done considering. I agree we should try this version." Staged SKILL.md (w/ "Report, never act") copied to skills/security-digest/. Rides 0.5.5. Scheduling left unwired until asked. |
| QA-6 | *(moved to Resolved 2026-07-05: v1.0 was frozen, blessed, minted 2026-07-02 and is now traveling — hello-principles.md ships it on the public shelf; Corwin's "I have read and consent" 2026-07-05 closes the confirm.)* ~~Blessed statement of principle (2026-07-01)~~ — the consent-gate/ethicsminions/personal-instructions interlock, certified | **CERTIFIED AGAINST CANON** — evidence file archived 2026-07-08 to /f/SAVANNAH/archive/blessed-principle-2026-07-01_2026-07-08_Archived-by-Claude.md (+.asc, Corwin-signed 2026-07-08; was claud-qa-hold/, hold long served); minions pass clean; principle-reconcile MATCH cffeb6e9… across hub PRINCIPLES.md + svhck/CANON.md mirror + seeded hash (3 surfaces); corwin.txt found (F:\claude, 2026-07-01) and consistent. Clauses 1/5/6 are chamber-local extensions outside canon scope (per PLAN.md settled scope) — no drift. Remaining Apply = Corwin's confirm + eventual PRINCIPLES v1.0 freeze for minting. |

## Resolved
| id | item | resolution | date |
|----|------|-----------|------|
| QA-9 | minions notes() layout tolerance | **APPLIED 2026-07-04** — write-lock was on the inode, not the name: rm+recreate landed it (backup taken first; verified both readers, ast-parsed). Armed drift check now PASSes from the workspace root. Staged .patch remains as record. | 2026-07-04 |
| QA-5 | AI_GUARD_PROVENANCE_CLAUDE | **APPLIED** — folded to skills/ethicsminions/references/AI_GUARD_PROVENANCE_CLAUDE.md. Rider satisfied honestly: the fold itself is the substantive, technically-driven EM change (desk live, Corwin present + initiating — "I don't want to lock myself out" — so not folded alone). Minions pass pre-landing: clean (one pathing artifact, one stale-mount artifact, both explained). Rides 0.5.5 EM remint. | 2026-07-04 |
| QA-7 | skill-sign (Haiku) intake | **APPLIED WITH FIXES** — box popped, Corwin chose full apply. F1 bundle-drops-signature, F2 unpinned verify, F5 dir-local temps fixed; F3 redesigned to signed whole-tree manifest; F4 repackaged (security-digest split out, own call pending). Round-trip + tamper + wrong-pin + zip-slip tested 8/8. Adopted at skills/skill-sign; rides 0.5.5. Review: claud-qa-hold/skill-sign-intake-review.md. | 2026-07-04 |
| QA-1 | ethicsminions SKILL.md rework | **APPLIED** 2026-06-29; superseded by the folded-back two-halves evolution 2026-07-01; stale staged draft removed 2026-07-02 (post PRINCIPLES-v1.0 freeze). | 2026-06-29 |
| QA-4 | ethicsminions CONSENT-VERIFICATION guard | **APPLIED (out-of-band, by Corwin)** — mechanized as the `consent-gate` skill and installed (SKILL.md cites the staged guard as lineage; six conditions + ALL/ANY + 2/2 dual-source + verify_consent.sh all present). Observed and recorded by Mentat 2026-07-01; Corwin to confirm. Repo source folded into skills/consent-gate/. | 2026-07-01 |

## feeds →
`advice/` (apply/reject trail) · `model.md` · `GRAMMARY.md` · `skills/`
