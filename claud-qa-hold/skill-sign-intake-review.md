# QA-7 — skill-sign (Haiku, 2026-07-03) intake review :CLAUD_QA_HOLD:

Source: F:\claude\AS4CE\FreshLocalGossip\skill-sign-haiku-2026-07_Jul_03_Fri
Reviewed: 2026-07-04, Mentat. Verdict: **HOLD — adopt after fixes.**
The idea is right and house-shaped; the implementation breaks its own
core promise in two places.

## Findings

**F1 — BREAKING: bundle drops the signature.** `cmd_bundle` stages with
`cp -r "$skilldir"/*`; POSIX glob skips dotfiles, so `.signature.asc`
never enters the zip — while the script prints "(includes
.signature.asc)". Workflow 3 (unbundle → verify) always fails. The one
sentence the whole skill exists for — "the signature travels with them"
— is currently false.

**F2 — BREAKING: verify trusts any key in the keyring.** `gpg --verify`
with no fingerprint check answers "is this signed by anyone I know",
not "is this signed by Corwin". House pattern exists: publish's
verifies_pinned greps VALIDSIG for the pin. $KEY is already in the
script and unused at verify time.

**F3 — OVERCLAIM: only SKILL.md is signed.** Doc says "its contents are
unchanged", but scripts/ and references/ are uncovered — a skill can
verify VALID while carrying a tampered executable payload. Fix shape:
sign a per-file sha256 manifest of the whole dir (= polygram MANIFEST
idiom; converges with #86 tree-verify).

**F4 — DELIVERY: wrapper/payload mismatch.** The folder's top-level
SKILL.md is a *different skill* (`security-digest`, autonomous scheduled
web digests); the signer's real definition sits as
skill-signer-SKILL.md. Installing the folder as-is installs the wrong
skill under a signing label. Assembly slip or seeded test — either way,
F3's manifest is exactly what would have caught it.

**F5 — HYGIENE: temp files inside the skill dir** (`.canonical.$$`,
`.sig.$$`) — a crash leaves strays where bundling sweeps them (the
sedx44W4d lesson). mktemp outside the tree.

Also noted: the delivery is itself unsigned (no .signature.asc present) —
bootstrap provenance = Corwin's attestation of the folder, one source.
And `security-digest` is a reasonable skill on its own merits (fleet-ops
digest + schedule pairing) — separate intake if wanted.

## Proposed Apply

1. Fix F1/F2/F5 in a repo copy (small diffs, keep Haiku's structure).
2. Redesign signing target per F3: manifest-of-tree, signed detached.
3. Repackage: skill-signer-SKILL.md becomes SKILL.md (F4); security-digest
   split out as its own candidate.
4. Adopt into skills/skill-sign; rides the 0.5.5 mint; slots beside
   bin/release (release signs aggregates; skill-sign signs per-skill
   bundles).
