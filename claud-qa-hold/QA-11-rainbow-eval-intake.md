# QA-11 — rainbow-eval intake review (candor-gate + skill-creator pass)

Staged 2026-07-09. Source: extern/rainbow-eval.skill (Bryant, Gauntlet
Nexus, v1.0). Awaiting keeper Apply/Hold/Reject; install is keeper's hand
(Settings → Capabilities), never the instrument's.

## Candor-gate checks (all five)
1. PROVENANCE: detached sig GOOD vs Bryant's pinned key 5D99…5DE7, 2/2
   (Inbox drop + clearsigned pub vouch). Signature notation
   `manu=2,2.5+1.12,2,1` rides all Bryant sigs — question queued to Bryant
   in the P6–P8 patch header; a question, not alarm.
2. OPT-IN: conversational triggers only ("rainbow eval", "what skill am I
   missing") — no silent always-on. PASS.
3. THIRD-PARTY PERSISTENCE: none; the skill persists nothing itself. PASS.
4. EGRESS: none — single SKILL.md, zero code, zero network. PASS.
5. DANGLING ROUTES: references skilltank + skill-creator, both installed;
   it sequences them, never replaces (fold-with-credit honored — INTEL
   confirms skilltank's rainbow pass is credited, not forked). PASS.

## Skill-creator review notes (pre-install, per stub-litter rule)
- Description well-formed, trigger-differentiated, under load limit.
- One overlap to watch: rainbow-eval's "author exactly one skill" ends
  where skilltank's desk etiquette begins — both installed, the desk still
  gates promotion; no conflict, but the eval's output should PARK at the
  desk like any hopeful, not auto-install. Note for first use.
- The encrypted twin (rainbow-eval.skill.gpg) is addressed to Bryant's key
  + keyid 8376ADC92BAEF426 (our ledger's mystery keyid — parked confirm now
  LOAD-BEARING: keeper's `gpg -K --keyid-format long` answers whether we
  can decrypt and whether Bryant's model of our keys is right).

Recommendation: APPLY (install when wanted); run its first rainbow pass
post-trip against the full rack.
