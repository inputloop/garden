---
candidate: posix
decision: VERIFIED
recorded: 2026-09-01T11:14:44
supersedes-thread: .eclipse-increments/20260704-CONTRAST2 (signing sub-thread only)
---

# posix signing-thread CLOSED — pinned-verify + key-identity bind

Receipt for the CONTRAST2 reminder discussion (2026-09-01). The *signing*
sub-thread is closed clean; the *substantive* method/lexicon discussion
(below) remains open and was carried to the live session.

## Two legs, both green

**Leg 1 — content matches signature (sandbox, hash floor).**
`skills/posix/.skill-manifest` records `SKILL.md` at sha `3f7d4f09…23f68`,
which matches the live file. Manifest covers `SKILL.md`, `tool.py`, and the
legacy per-file `SKILL.md.asc` (the older `.asc` is signed *over*, not a
competitor). Layered-assurance L1 — count-the-cards.

**Leg 2 — signature valid against pinned key (host keyring, Corwin ran it).**
`skill-sign.sh verify skills/posix` →
`skills/posix: signature valid (pinned ECE77CF417C76C1ACFCE7C2B5B6135511580F007)`
Detached signature (`.signature.asc`) over the canonical manifest. Per
verify-say: state = **DETACH, pinned-verified**. Canary held — the pinned
fingerprint equals the issuer fingerprint decoded by hand from the armor
(`…W2E1URWA…` → `5B61 3551 1580`, tail `F007`).

## The pinned key is publicly, verifiably Corwin's

Verified `ECE7 7CF4 17C7 6C1A CFCE 7C2B 5B61 3551 1580 F007` by public
trusted means, independent of Corwin's own tooling:

- `rsa3072`, created 2020-12-14, re-certified 2026-04-07, UIDs valid to
  2030-04-06. Held on keys.openpgp.org AND keyserver.ubuntu.com.
- Three self-signed UIDs, all "Corwin Brust": `corwin@gnu.org`,
  `corwin@bru.st`, `mplscorwin@gmail.com` (last matches the platform's
  on-file address).
- **Control proof:** keys.openpgp.org serves email results only after a
  challenge; `corwin@bru.st` (Corwin's own domain) resolves there to
  `ECE7…F007`. This is the poisoning-resistant leg.
- Identity real + matching: "Corwin Brust", Savannah admin, user `carlc`,
  active on GNU lists.

**Honest limits.** Only `corwin@bru.st` is challenge-verified on
keys.openpgp.org; `gnu.org` / `gmail` UIDs are self-signed but not
independently confirmed there. bru.st WKD not fetched (optional
"published-from-web-root" leg). No keyserver proves private-key possession
by the session hand — inherent. What's proven: fingerprint ↔ the public
person who controls bru.st and administers Savannah.

Chain closes end to end: skill → detached sig → pinned `ECE7…F007` → Corwin.

## Still open (NOT closed by this receipt)

The CONTRAST2 *method* reconciliation, carried to the live session:

1. **A3-generalization.** The reduction (§A) held; only the skilltank-triage
   call (§C) was superseded by the 2026-07-08 authoring. Proposed amendment:
   triage may return LEAVE/lexicon only at *authored* granularity, else
   HOLD (worth-UNPROVEN) — this is §A3's own "correct verdict on an unproven
   premise" lesson applied to the worth-judgment. Accept/reject: Corwin.
2. **pmo #114 complement.** Skill owns the procedure; #114 owns the term.
   Clean complement *iff* #114 is written term+gloss+pointer, never a
   procedure copy (else SEAMS drift). Same fork as CONTRAST2 §B
   (code-fix vs desk-discipline).

## Provenance

`.asc` clearsign is the keeper's pen (never the instrument's) — this receipt
awaits Corwin's signature like its siblings in advice/.

Sources: keys.openpgp.org (corwin@bru.st → ECE7…F007), keyserver.ubuntu.com
(0xECE77CF417C76C1ACFCE7C2B5B6135511580F007), savannah.gnu.org/users/carlc.
