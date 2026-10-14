# UPGRADES — a suggestion book for Bryant's software in this garden

*What this is: changes we would like in software Bryant Frankford wrote and we carry byte for byte (Llama
Bridge, Tavern, his soft skills), and, since 2026-10-10, in his software that reads ours (signet, his skill
verifier, and Alfred's map of the house; review pass 3, C6). We never make these changes ourselves in his files: his bytes are pinned
by hash (`tests/test_mcp_llamabridge.py`, `test_vendored_bytes`; `polygram/mcp/NOTICE-llama_bridge`,
`NOTICE-tavern`). Each entry is a suggestion; only Bryant moves it on.*

**The four states.** PROPOSED: we wrote it down and sent or offered it. ACCEPTED: Bryant said yes. DECLINED:
Bryant said no (kept, with his reason if he gave one). SHIPPED: a build of his carries it, and our pinned
copy has been moved to that build. Only Bryant presses ACCEPTED or DECLINED; SHIPPED is written when his
build arrives and the pin moves.

| # | software | state | since | what |
|---|---|---|---|---|
| U1 | Llama Bridge 1.4.0-vb.1 | PROPOSED | 2026-10-10 | Queue fields and start/finish stamps (below) |
| U2 | signet (his skill verifier) | PROPOSED | 2026-10-10 | Read a skill the way skill-sign does, and say "hash only" for an unsigned one (below) |
| U3 | Alfred, "The map of the house" | PROPOSED | 2026-10-10 | Know which of the names it routes are ours, and that ours are listed as `vibrobeast:<name>` (below) |

## U1. Llama Bridge: say where a job sits in the queue when it is handed over

- **What we would like.** `delegate_async` answers today with "Started background job X" only. We would like
  it to also say how many jobs are ahead of it (`queued_behind`, the same count `jobs_ahead()` already makes
  for `delegate_result`), and for `delegate_result` on a finished job to give the start and finish times
  (`started_ts`, `finished_ts`) beside `created_ts`.
- **Why.** The bridge already runs one job at a time and `delegate_result` already names the jobs ahead
  (`llama_bridge.py`, `jobs_ahead()` near line 861, the queued message near line 1426). Several sessions
  share one GPU; a caller that knows it is third in line can wait the right time before its first poll
  instead of guessing. The stamps let a caller tell queue time from run time.
- **Where it came from.** The extension spell, card 16 (llama serialisation), and the builder's review
  (C2 O11, O12, J4), 2026-10-10. Model W (wire-first) asked for the fields; the review found the
  behaviour mostly shipped already, so only the two reporting fields remain.
- **What it would cost on our side.** A new pinned build (vb.2 or his own 1.4.1), a new hash in
  `NOTICE-llama_bridge`, and the diff kept in `skills/llama-bridge/references/`. Nothing in our code changes
  until his build does.
- **State.** PROPOSED, 2026-10-10. Not sent yet: it goes with the next drop to him.

## U2. signet: agree with skill-sign on what a skill's bytes are

- **What we would like.** Two small changes to signet, so that it and our skill-sign give the same answer
  on the same folder. First, read a skill the way skill-sign does: leave out `.arc`, `.git` and
  `__pycache__` folders, and ignore blank lines at the very end of a file. Second, when a skill has a hash
  manifest but no signature file, say "hash only (no signature)" instead of FAIL.
- **Why.** In review pass 3 (C6, items O12 to O14) both tools were run over our 1.1.1 edition with the
  same pinned key. On the 21 signed skills they agree, 21 of 21. But they disagree on bytes that are
  harmless: two blank lines added at the end of a SKILL.md, or a `__pycache__` folder made by running a
  script, leave skill-sign saying "signature valid" and make signet say "FAIL: tree drifted". They agree
  today only because no shipped skill has either. And on our 45 skills that carry a hash manifest but no
  signature, signet prints "FAIL: no .signature.asc (unsigned)", where skill-sign says UNVERIFIED-AUTHOR:
  the bytes are proved, the author is not. A reader on his side sees 45 failures that are not failures.
- **Where it came from.** C6, the peer agent working in Bryant's modes,
  `c4/spells/extension/runs/2026-10-10/review/C6-alfred-mode-peer.md`, items O12 to O14 and new idea 6.
- **What it would cost on our side.** Nothing until his build changes. If he prefers the other way round
  (skill-sign reading as signet does), that is a change in our skill-sign and a re-sign of every signed
  skill; we would write that as its own proposal, not make it here.
- **State.** PROPOSED, 2026-10-10. Not sent yet: it goes with the next drop to him.

## U3. Alfred's map of the house: know which names are ours

- **What we would like.** That Alfred's map say, for each name it routes, whether that skill is in our
  garden too, and know that a session holding our plugin lists ours as `vibrobeast:<name>`. Where both
  gardens carry the same name, the map would say which copy it means.
- **Why.** The map (Alfred v1.9, section "The map of the house") routes to 58 skill names. Only 18 of them
  are in our 1.1.1 edition. Our plugin's skills appear in a session as `vibrobeast:<name>`, and the map
  writes names bare, so it reaches ours only by luck of name. Fifteen names are in both his drop and our
  edition, and all fifteen differ in bytes: the same name leads to two different files. Alfred's own rule
  already says "if this map and a skill disagree about that skill's lane, the skill wins and the map is
  stale"; this asks the map to know the second garden is there.
- **Where it came from.** C6, the same review, items O1 to O3 and judgement J1.
- **What it would cost on our side.** A short table of the shared names (his version, ours, and the start
  of each hash) that we can send with the next drop; nothing in our code.
- **State.** PROPOSED, 2026-10-10. Not sent yet: it goes with the next drop to him.

---
Authored by Mentat (for Corwin; claude-opus-5-5).
Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
SPDX-License-Identifier: CC-BY-SA-4.0
