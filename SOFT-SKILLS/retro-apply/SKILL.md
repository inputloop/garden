---
name: retro-apply
description: >-
  The spell that applies a skill after the fact: take a skill (new, changed, or one that should
  have fired) and a prompt already answered — one C4 has registered, an advice note, or this
  session's own prompts — and re-run that prompt's decisions under the skill, using whatever other
  skills and MCP calls the re-run needs, first as flexibly as it takes and then as sparingly as
  reproduces the result. It produces a delta: what stands, what changes, what now goes back to the
  person, what was a gap. Use on "apply X retroactively", "re-run this session under the new
  skill", "what would X have changed", "retro-apply", "the test case is this session", "would this
  still come back to me", or right after a new skill lands and an old prompt is the obvious test.
---

# retro-apply — run yesterday's prompt through today's skill

A new skill is a claim about how work should have gone. The cheapest test of the claim is a prompt
that already went: re-run its decisions under the skill and show the difference. Nothing is undone;
the delta is the deliverable.

## The cast

- **The skill** — named by the person, or the one that just landed.
- **The prompt** — in order of preference: a prompt C4 has registered (the rack of spells in the
  registry; `c4/h/PROMPT-*.md` in this shop), an `advice/` note that recorded a session's opening
  prompt and claims, or the current session's own prompts as they stand in the conversation.
- **The faculties** — every other skill and MCP call the re-run needs. Take them **most flexibly
  first** (use what helps, note each one used and why), **then most optimally** (prune to the
  smallest set that reproduces the delta, and record that set as the spell's recipe for next time).

## The run

1. **List the prompt's decisions.** Every place the original answer chose, defaulted, routed a
   fork, kept a tension, or declared a gap. Number them.
2. **Re-decide each under the skill.** For `prior-instruction` that is: search canon → prompts →
   session, newest first; three lookups kept apart; blast radius inward out; retain when told.
   For another skill, its own procedure. Record what each decision becomes.
3. **The delta table.** One row per decision:

       #  decision (original)         under <skill>                 status
       1  routed to the person         DECIDED-BY instruction …      CHANGES → do it
       2  chose default X              DECIDED-BY preference …       STANDS
       3  kept both                    RETAINED, seam recorded at …  STANDS
       4  asked "which?"               ROUTED: <radius sentence>     STANDS, reworded
       5  none found                   GAP: checked …; miss ~P%      FOOTNOTED

4. **Do what CHANGES, when it is in reach and testable** — a re-run that only writes a table has
   applied nothing. Where a change is a build, and the build is small and has a test, build it;
   where it is large, name it as the obvious build and its test, first, before the top-of-mind
   answer.
5. **Record.** `advice/<stamp>-retro-<skill>-<prompt>.md` with the table, the faculties used (the
   flexible list and the pruned recipe), and the gap footnotes. When C4 is reachable, register the
   run against the prompt it re-ran; when a kept tension surfaced, the seam goes to the registry
   (taxonomy · palace by ideation · mountain by context) or, failing that, a memory note.
6. **Correct in place, dated.** When a later run overturns a row of an earlier record, append a
   `CORRECTION <date>` line under that row in the earlier record (what the check was, what it
   found) and leave the original line standing; the record then shows both the claim and its
   overturning. A corrected row never gets rewritten — a reader must be able to see how certain the
   wrong line looked. `bin/pi1ck` lints a record for this and for the §3/§5 shapes.

## What it will not do

Rewrite the original answer in place; undo a delivered artifact; silently drop a decision from the
list (every original decision has a row); treat the skill's own caution as the person's
instruction; or call the run done with an unbuilt CHANGES row that was in reach.

## How this spell can fail (falsifiers)

- A decision of the original prompt with no row.
- A CHANGES row that was cheap and testable and was not done.
- A faculty used but not listed, or a recipe that does not reproduce the delta.
- The person reads the delta and re-routes a row already marked DECIDED-BY — the lookup was wrong.
- **Off-switch.** "no retro" for the session; the spell keeps no state.

<!-- footer: minted by bin/ft1mt from conventions/house.env and conventions/FOOTERS.org; edit those, not this -->
*Version 1.1.0: edition revised from 1.0.1 on 2026-10-10; spine: 2026-10-04.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4: https://creativecommons.org/licenses/by-sa/4.0/ (scripts GPL-3.0-or-later); Mentat (for Corwin; claude-opus-5-5)
<!-- /footer -->
