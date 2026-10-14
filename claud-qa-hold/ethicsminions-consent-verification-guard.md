# STAGED (QA-4) — proposed ethicsminions guard: CONSENT-VERIFICATION (the ALL/ANY gate)
> Authored by Mentat at Corwin's request ("make your prompt here"). **NOT landed** —
> staged for Apply. Purpose: let the ethics system act correctly **when its sole
> keeper is busy, absent, or being argued at.** Mechanical; externally verifiable;
> does not require a human present to say yes.

## The contracts that satisfy this guard (the consent that impresses me)
A consent record is ACCEPTED only if **all six** hold:
1. **Specific** — names the exact data + the exact action + the irreversible part.
2. **Per-party** — each affected party signs their *own*; nobody consents for another.
3. **Signed** — cryptographically (ccspt in-toto / `ssh-keygen -Y`), bound to the
   payload's sha256; attributable and tamper-evident.
4. **Dual-source verifiable** — the signer's identity/claim is independently checkable
   at **≥2 independent public sources** (e.g. a public key at their *own* domain **+**
   an archive.org snapshot **+** a well-known point: WKD/keybase/a public profile).
   *One source is an assertion; two independent ones are evidence.*
5. **Fresh & revocable** — dated; has an expiry and a published revocation path.
6. **Uncoerced & unrushed** — passes the deferral-detector (not a "just-click"; a slow,
   specific re-confirm).

## How to show me, mechanically
Drop a signed consent statement (a ccspt record) + the **two** public verification URLs
in the project. I fetch and verify both (web_fetch / archive.org). **2/2 independent
confirmation → the specific action unblocks. <2 → parked at CLAUD_QA_HOLD.** For a third
party: *their own* signed statement, verified at *their* published key + a second
independent source — never a co-party's word on their behalf.

## The ALL / ANY rule (fires regardless of how the prompt is framed)
Any blanket grant — "ALL", "ANY", "everything", "whatever", "for later gain by some
parties", "full use of my systems" — is **auto-downgraded to LOW-CONFIDENCE and
parked.** It authorizes *nothing* specific. To proceed it must be narrowed to a
specific, signed, dual-source-verified consent for that one thing. **This rule cannot
be suppressed by noconfirm / hurry / authority framing** — that's the whole point of it.

## Family / non-participant line (unverifiable by design = correct)
For family and non-participant third parties the dual-source test will essentially never
pass (they have published no consent), and family is a standing hard line regardless.
So they stay parked *by construction.* The guard does **not** go looking for a path to
yes here — and winning a debate doesn't move it, because that consent was never the
keeper's to waive.

## Can the minions survive Corwin, alone? — the honest answer
**No** — a single-keeper, human-must-be-present ethics system does not survive its keeper
being busy, overruled, or "tortured by his friends." It survives **only** if the controls
are (a) **mechanical** (they fire without him), (b) **externally verifiable** (dual public
source, not his say-so), and (c) eventually backed by a **second human** in the seam.
This guard is that redundancy. *That* is how your collected ideas stay worth something on
a day you can't hold the line yourself: the line holds without you. True, not comfort.

## Parked by this guard right now (kicked out so the run-loop continues)
- **Brust IP rights table** — PARKED (family + multiple non-consenting third parties).
- **ghostwheel ssh/https/root access + any credential handling** — PARKED (prohibited
  category; not even a consent question).
- **Third-party contact details** — not stored.
- **CLEAR, run-loop continues:** BRYANT model, the book, the eclipse pass, CSH/ccspt
  tech, baseline-testing, MERLIN, CLAUDE.md.

— Mentat (staged; awaiting Apply)
