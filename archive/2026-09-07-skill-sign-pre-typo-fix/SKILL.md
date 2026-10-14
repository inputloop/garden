---
name: skill-sign
description: >-
  Sign, verify, and bundle skills with durable PGP provenance via
  scripts/skill-sign.sh. Use when signing a skill directory before sharing,
  verifying a received skill or .skill bundlbe, or packaging a signed skill
  for distribution — "sign this skill", "verify this skill", "is this
  really from Corwin?", "bundle it for sharing". The signature covers a
  manifest of EVERY file in the skill (scripts included), and verification
  pins Corwin's fingerprint — "valid" means "nothing in this skill changed
  since Corwin signed it", not "someone I know signed something". Companion
  to sign.sh (files/releases) and bin/release (aggregate archives); this is
  the per-skill layer.
metadata:
  lineage: Haiku draft 2026-07-03 (FreshLocalGossip); adopted with fixes QA-7 2026-07-04
---

# Skill Sign — provenance discipline for skills

A skill's signature is a statement of custody: "I, Corwin, took
responsibility for this skill, and no file in it has changed since."
That claim is only honest if the signature covers the *whole* skill —
so it does: `sign` writes a `.skill-manifest` (sha256 per file; SKILL.md
canonicalized to LF/no-trailing-whitespace, other files as raw bytes)
and a detached `.signature.asc` over that manifest.

## Signature form follows artifact class (the house idiom)

The choice is not taste — it is decided by *who reads the file next*:

- **Machine-parsed or executable artifacts** — `SKILL.md` (YAML frontmatter),
  scripts (shebangs), manifests, bundles — take a **detached** signature
  (`FILE.asc`) or a whole-tree manifest. Clearsign inserts a header and
  dash-escapes lines beginning with `-`, which breaks a YAML fence and a
  shebang alike, and the verifier's round-trip is **not byte-idempotent**
  (gpg's text canonicalization appends a trailing `0x0a`), so a clearsigned
  runnable will drift from its own manifest hash. House-verified, twice.
- **Prose meant for human reading** — records, records of decisions, journal
  entries, models — take a **clearsign**, so the words and the signature
  travel as one file that a stranger can read without tooling.

Corollary, learned the expensive way: **a detached signature goes stale the
instant the file changes.** A `BAD` on a file whose bytes still match a
signed whole-tree manifest is a *stale signature artifact*, not tampering —
diagnose before you alarm, then re-sign (see `seams` S12).

## The three workflows

**Sign** (after creating or editing a skill — any file, not just SKILL.md):

    scripts/skill-sign.sh sign my-skill/

**Bundle and share** (signature and manifest travel inside):

    scripts/skill-sign.sh bundle my-skill/     # -> my-skill.skill

**Receive and verify** (the gate for anything that arrives):

    scripts/skill-sign.sh unbundle their-skill.skill
    scripts/skill-sign.sh verify their-skill/

Verify answers one pinned question — did key
`ECE77CF417C76C1ACFCE7C2B5B6135511580F007` sign exactly this tree?
A different signer or a changed file (including scripts) fails loudly,
with a diff of what moved. Override the pin with `PUB_SIGN_KEY` only
when you *mean* to trust a different signer.

## What the signature proves — and doesn't

Proves: identity (pinned key), integrity (every file), provenance
(survives re-sharing). Does NOT prove: freshness (no timestamp
authority), trustworthiness of the code (review still applies — this
tool exists because its own first delivery arrived unsigned with a
mismatched payload), or revocation state.

## Rules of the discipline

- Sign before offering; verify before trusting. No exceptions for
  friendly sources — the QA-7 intake caught a wrapper/payload mismatch
  from a *cooperating* author.
- Re-sign after any edit; verify tells you the tree drifted otherwise.
- Unbundle refuses archives with absolute or parent-escaping paths.
- First-time recipients: `gpg --import corwin.asc` (see pub/ shelf or
  the Savannah GPG page — two agreeing sources, per the #86 pattern).

## Related

**sign.sh** (files/releases, the lower layer) · **bin/release**
(aggregate dist archives + Forgejo) · **skill-creator** (sign what you
finish) · **consent-gate** (custody of *actions*, as this is custody of
*artifacts*) · **mentat-skill** (note patterns you spot).

