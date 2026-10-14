# QA-8 — security-digest (Haiku, 2026-07-03) intake review :CLAUD_QA_HOLD:

Source: the QA-7 stowaway — arrived as the top-level SKILL.md of the
skill-sign delivery. Content-only skill (no scripts). Reviewed
2026-07-04, Mentat. Verdict: **SOUND — recommend adopt with two
additions.** Staged copy for diff: claud-qa-hold/security-digest-SKILL.md.

## What it is

Daily Ubuntu/Debian security digest for scheduled autonomous runs:
searches LWN → kernel.org → USN → DSA → CVE tracker (trust-ordered),
last-24h window (Monday sweeps the weekend), groups by severity with
RCE/DoS first, refuses to surface a vuln without patch status, and emits
a punch list only for actionable Critical/High. The autonomous-run
discipline is genuinely well written: self-contained runs, no ephemeral
references, "no results is data — don't retry", bounded fetching.

## Findings

**F1 — fitness: real fit exists.** You hold Savannah volunteer duty and
ghostwheel; Debian advisories are directly relevant (medley hosts).
Pairs with the `schedule` skill as designed.

**F2 — autonomy line missing (my one real concern).** The skill runs
unattended and its output *contains commands* (`apt update && apt
install`). Nothing instructs the running agent to never EXECUTE what it
recommends. Unattended + entrusted systems = exactly where the consent
discipline bites. Staged copy adds a "Report, never act" operating
principle: the digest recommends; applying patches is the keeper's act
(or a separately-consented action through the gate).

**F3 — small fixes in staging:** timezone pinned (America/Chicago) for
the 6am cron guidance; lineage metadata (Haiku 2026-07-03, QA-8);
description's "Corwin's own fleet-ops digest" kept — true once adopted.

**F4 — provenance:** same unsigned delivery as QA-7; benign prose, no
executables. If adopted, it gets signed by skill-sign like everything
else going forward — which retroactively gives this delivery the
provenance it arrived without.

## Proposed Apply

Copy staged SKILL.md → skills/security-digest/; rides 0.5.5; optionally
wire the schedule (your call — it can wait until you actually want the
digest arriving).
