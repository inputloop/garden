# advice: .gate sign-post convention shipped (smallest version)

- when: 2026-07-02
- decision: SHIP (operator design, Corwin's preference stated verbatim)
- scope: polygram first; one dotfile convention, no enforcement layer

## The design (Corwin's words)

> Poly first, smallest version. One dotfile convention at any directory root —
> say `.gate` with three fields: `policy` (read-write / read-only / write-only /
> none), `reason`, `since`. Self-describing, auditable, and ethicsminions can
> grow a guard that checks tool traffic against it. Don't build the cathedral;
> ship the sign-post.

## What shipped

- `polygram/gatefile.py` — stdlib parser + nearest-wins resolution + check.
  Distinct from `gate.py` (candidate PASS/HOLD/REJECT); named apart on purpose.
- `polygram gatefile PATH [read|write]` — CLI check, no workspace required.
  Exit 0 allowed/ungated, 1 denied, 2 unparseable gate.
- `.gate` at the AS4CE0001 root (read-write; first live sign-post).
- `tests/test_gatefile.py` — 11 tests; suite 58 green.

## Semantics locked in

- Nearest `.gate` walking up governs (closer signs override farther).
- Ungated = silence, not consent: `check()` returns `(True, None)` so callers
  can tell "no sign" from "sign says yes".
- Bad/missing policy fails closed (GateError), never guessed.
- Unknown keys preserved, ignored (forward-compatible).

## Context / practice notes

- Mount-request practice: request project paths as needed; avoid `.`-lead
  private folders. A `policy: none` sign is the in-band marker for private.
- Verification of this very change hit the known mount desync (bash served
  stale cli.py at old length); verified via /tmp overlay per sandboxer.

## Regression path (deferred, tricky, only slightly worked)

Proof of concept first; then reseed with SAVANNAH. The guard that checks tool
traffic against `.gate` belongs to ethicsminions and is NOT built here —
that's the next increment, gated on corroborating data that the sign-post
earns its keep.
