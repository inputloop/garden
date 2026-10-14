# GRAIN, 2026-10-05: four papers, a burn-down, five weaves, a census, and an eclipse

*For Corwin. Each of the four papers was commissioned separately and stands alone; this preface
holds what they share, said once.*

## What is here

| file | what it is |
|---|---|
| `A-human-expectations.md` | Paper A: people getting what they expect (the behavioral sciences) |
| `B-free-software-technical.md` | Paper B: the Free Software release engineer's review, including pu1sh read as code |
| `C-ai-theory-memory.md` | Paper C: AI theory with memory at the centre; science kept apart from news |
| `D-social-skeptical.md` | Paper D: the skeptic's social reading |
| `BURN-DOWN.md` | Tier 2: the papers burned down by models of rising size, with two faults planted in each |
| `weave/` | Tier 3: author (Mentat), editor (Henriette Solberg-Maas), systemic (shopgarden), human (the CORWIN model), and control (no persona) |
| `STEPS.md` | The candidate steps the weaves voted on |
| `CENSUS.md` | The users gate run over the public forge |
| `ethics/` | Your three asks on the ethics redundancy, with the clean-room eclipse |
| `EM-PASS.md` | The ethicsminions pass over all of it |
| `PLAN.md` | The resulting plan, as the map recommends it |
| `two-gardens-map.html` | The map: Bryant's garden, yours, what you make together, and the plan's merge controls |

## What all four papers share, said once

**The gate has changed since the papers reviewed it** (c4 4af7de1). `pu1sh` now:
- **Fails closed.** When git cannot list the commits that would leave, the answer is NOT CHECKED
  (exit 2), never clean.
- **Reads the hook correctly.** It treats an all-zero object name of any length as a new ref. When
  the remote tip was never fetched, it falls back to "not on any remote-tracking ref". It takes the
  level from the URL the push goes to.
- **Checks more widely:**
  - LINK covers other vendors' chat hosts and any `*-Session:` trailer, and matches links rather
    than mentions.
  - AIMED adds `AGENTS.md`, `GEMINI.md`, `.cursor/`, `.aider*` and copilot instructions.
  - A new PATH check finds local absolute paths.
  - MISNAMED checks changed files too, and passes Git LFS pointers.
- **Says what it did not check,** at the end of every run.

Its self-test has 36 checks, and each planted switch is shown to be what catches its fault. It
passes under 20 shell and awk pairs on Avalon.

The levels are unchanged. On private and undeclared remotes only SECRET stops a push, as your rule
has it. Whether privacy findings should stop a push there too is S08, yours.

**Other changes since the papers were written:**
- `public-stage` step 1 no longer asks for the session trailer (garden 8743b5d).
- card-games is declared `users`.
- Your answers of tonight settle several of the papers' questions:
  - the licence form;
  - MELPA's conventions;
  - the vendor as a destination;
  - your copyright posture.

**The papers' bracketed concern tags are gone.** You retired them on 2026-09-24. The LENS skill
still asked for them, and its line is now fixed.

## The method, in one paragraph

1. **Tier 1:** four papers from four lenses. Each answers the same six questions (what is proven,
   held, synergizes, challenges, is an obvious win, and is worth testing), with verified
   references.
2. **Tier 2:** burned down by a local 12B model on a narrow window and by Haiku on whole papers,
   then sorted by Opus, with two planted faults per paper to show each reader works.
3. **Tier 3:** woven by five stand-ins through LENS, each voting on every step.
4. **The ethicsminions pass.**
5. **Your ethics-redundancy asks,** run as an eclipse: our designs were withheld from two
   clean-room designers, one per model family.

Personas were used as skills through LENS, as your rule of tonight asks. None was minted, and no
sheet changed. On rule 8, the editor's note finds only paper D's voice worth noting (concessions
before objections, written in the first person), and nothing to document further.

---
*Version 1.0.0: first edition on 2026-10-05; spine: 2026-10-05.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4:
https://creativecommons.org/licenses/by-sa/4.0/; Mentat (for Corwin; claude-opus-5-5)
