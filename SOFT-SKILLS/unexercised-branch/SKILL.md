---
name: unexercised-branch
description: >-
  A check that never met the case it guards is not yet a check. Three faces from one day
  (2026-10-11): a hook that rewrites text touched a record because "lines this commit adds" looked
  like "new writing"; a fresh agent that had not seen the work found twelve failures the specs
  passed; a shelf sealer's inverted guard hid behind a fixture whose failing check failed silently,
  so the refusal branch never ran. Use when a spec passes on its first run, when a guard refuses
  (seal, publish, promote) and no test makes it refuse, when a hook or tool rewrites text in commits,
  on "is this branch ever reached", "did the test fail for the right reason", "fresh eyes",
  "mutation-test the spec", or "is this a record". Electable. PROVISIONAL.
---

# unexercised-branch: the check that never met its case

Landed 2026-10-11 at his ask to bring the day's learnings into SOFT-SKILLS. The receipts are in
`/f/claude/c4/MEMORY.md` § 2026-10-11 (late afternoon) and
`/f/claude/c4/h/ENHANCE-2026-10-11-learnings.md`, learnings 4-6.

## The idea in one paragraph

A check proves what it has been seen to do. A guard whose refusal no test reaches, a spec that
passed the first time it ran, and a rewrite rule that has never been shown an old text in a new
place are each a branch nobody has walked. The fault lives there because nobody looked there. The
cure is cheap: make the branch run, once, on purpose, and keep the case.

## The three moves

1. **Records are not new writing.** A tool that rewrites text (spelling, paths, headers) acts only
   on writing, never on records. "Lines this commit adds" is not the test: an archive copy, a
   restored file, a keep, a quoted transcript are new to git and old in words. Before rewriting,
   ask "is this a record?"; if the tool cannot tell, it leaves the file alone and says so.
   OBSERVED: the pa1th hook's first live run changed an archive keep; restored byte for byte
   (bb4417c3), c4 commit 433ec74.
2. **A spec green on its first run gets mutation-tested.** Run it against the old code (or a copy
   with the fix taken out). If it still passes, it does not test the fix. Then hand the work to a
   fresh agent that has not seen it, with the specs but not the story, and ask it to break the
   work. Every repro it finds becomes a case. OBSERVED: twelve failures, c4 commit dcb69ad.
3. **A refusing guard is proven by a planted failure that speaks.** For every guard that refuses,
   one case plants a failure and expects the refusal, and the planted failure must print a named
   line, so a silent fixture cannot stand in for a refusal. OBSERVED: `bin/sh4lf` sealed past a
   failing check; its test's check failed with no output, so the branch never ran. sh4lf's spec
   now holds 17 cases.

## Where it does not apply

- A check with no branch (a pure count, such as `bin/vo1ce`, which gives no verdict).
- A one-off probe that is thrown away. Once it is kept, this applies.

## Falsifiers

- Move 1: a rewrite tool, given only "lines this commit adds", that never touched a record over a
  month of commits.
- Move 2: a first-run-green spec that, mutation-tested, always failed against the old code.
- Move 3: a refusing guard with no planted-failure case that was never found fail-open.

## Neighbours

grand-test-manifest (every promise checked on the real work and on a planted copy) is the general
form of move 3; depth-overlap asks whether two checks see one promise from different places. This
soft skill is the narrower, day-sized lesson; if grand-test-manifest already says it, fold this in
and remove the folder.

Off-switch: say "no branch check on this", or remove this folder.

---

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4: https://creativecommons.org/licenses/by-sa/4.0/; Mentat (for Corwin; claude-opus-5-5)
