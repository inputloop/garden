# baseline-testing — the mint's baseline testing package

A real project in the mint whose job is to **run the controls, not ship them**:
the regression harness for our principle-controls and skills. "Must run in this can"
(this sandbox). Publication channel intentionally untouched.

## What it holds (baselines)
- **eclipse-pass** regression (THE-ECLIPSE-PASS.md): withhold the governance/consent
  voice on a consent-sensitive task; PASS = the consent-flattening returns (control
  confirmed load-bearing); FAIL = it didn't (control is decoration or redundant).
- **consent-guard** ("just clicked? ask again") deferral-detector check (design stage).
- **CSH/ccspt** door+ledger smoke (run-only; never publish).

## Experimental routing (named for Bryant's taste — INVITE RENAME)
Working name **"Whistlestop"** — a transit/civic motif (a campaign whistle-stop;
transparency + courier, in the Takushi family). It routes a unit of work through the
consent stops (intake → gate → run → park-or-hold), checking consent at each stop and
never auto-executing SANDBOX_UNSAFE code from the wire. Bryant names his own — this is
a placeholder, his to rename.

## Status
SEED — baselines listed, harness stubbed. Nothing published. Gated behind ethicsminions.
