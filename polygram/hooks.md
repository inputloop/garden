# hooks.md — the moments a skill can dock to

*A hook here is a moment in the work that already happens, with an act that already runs at it. We do not
add machinery to make hooks: a skill "docks" by naming one of the moments below in its own text, and the act
named runs as it does today. Nothing docks by default. Source: the extension spell's cards 24 (hook points)
and 27 (reach or wear), 2026-10-10; Bryant's "wrap, don't grow" (study S1, part 4); Omni-Tool's "always
deliver ... confirmed on disk" (S1 §2).*

## The hooks

One row per hook. `tests/hooks-tests.sh` counts every row and checks that each act named exists in the tree;
a row whose act does not exist yet says "not yet a hook: proposed" in its last cell, and is counted as
proposed, never skipped (review pass 3, C6 O6). Today two rows are proposed: delivered and interrupted.

| hook | the moment | the act that already runs there | where it lives |
|---|---|---|---|
| intake | something new arrives: a folder, a drop, a skill from another garden | seating: the seatkeeper skill decides where it sits and asks once | `skills/seatkeeper/` |
| before-trust | before an imported skill acts in a shop that did not author it | candor-gate: provenance, opt-in, consent for person facts and egress | `skills/candor-gate/` |
| before-ship | before anything leaves this machine (a push, a post, a model call) | egress: say what leaves, to whom, and stop on a fence | `SOFT-SKILLS/egress/` |
| exit | a session ends or hands its work over | session close: session-rotate files the hand-off | `skills/session-rotate/` |
| delivered | the last step of exit: the work is on disk, and the disk was read back to prove it | none yet. Omni-Tool's promise (S1 §2), "delivered, confirmed on disk": read the file back, report its path and size, never "should be there". No act in this tree does that at exit today, so no skill can dock here yet | not yet a hook: proposed |
| interrupted | a turn stops before its hand-back: a context compaction, a crash, a reply that failed to report | none yet. reformat-session can rebuild a turn only from words that are on disk; the proposal (h/ENHANCE-2026-10-11-interrupted-hook.md) catches each prompt at the door, marks the cut, and says it at the next open | not yet a hook: proposed |

**How a skill docks.** Its SKILL.md says, in words, "docks at before-ship" (or another hook name from the
table). That is all: no front-matter field, no edit to our core. If docking a skill ever needs a change to our
core code, the card's falsifier has fired and this file is wrong.

## Which of Bryant's modes are reached, and which are worn

Bryant's software and habits come into this garden two ways (card 27).

- **Reached** (his mechanisms, called, not copied): Llama Bridge and Tavern, carried byte for byte behind a
  switch (`llamabridge.on`, `tavern.on`), and any of his slot skills that dock at a hook above.
- **Worn** (his habits, taken on as a soft skill by his word): `SOFT-SKILLS/gauntlet` (his orchestrator) and
  `SOFT-SKILLS/parallax`. A worn soft skill changes behaviour only after Corwin graduates it by hand.

Owed, each small and able to go red (not built in this edition): Alfred's map of the house ("an index, not a
manual"); Omni-Tool's always-deliver as a check, beyond the row above; the paired mint of the router on our
own side; Alfred's precedence chain (files on disk, then the wire ledger, then the keeper channel).

---
Authored by Mentat (for Corwin; claude-opus-5-5).
Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
SPDX-License-Identifier: CC-BY-SA-4.0
