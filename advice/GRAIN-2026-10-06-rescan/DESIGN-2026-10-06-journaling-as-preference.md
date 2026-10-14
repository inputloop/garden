# Journaling, reformat-prompt and session-rotate as preferences, not configuration

A design note, 2026-10-06, answering Corwin's three messages of tonight. His rules for journaling
are still to come, so this is a proposal, shaped to be easy to change.

## What he asked for

His points, in order:
- Journaling is **optional**, and it comes **right at the end**, "since we don't really know what
  happened until we are handing back".
- It is also "a last chance to take another poke at things that seem/look wrong".
- He wants it, reformat-prompt and session-rotate to become **implicit**. That means
  "preferences (say to AI/argument or env to tool) over configuration (restart a service, edit a
  file, work over several prompts)". The exception is where an extra step is the normal flow, for
  example maintaining a production system for C4's CI/CD case.
- A journal is not a log. It carries "the flavor of extemporizing over time", trading "regimented
  form for potential liberties in voice as well as arrangement".
- Not seeing a post is a complex signal. When a concern is pressing, it is usually said at once.
- "Less is more when the journal is requested, and optional is a stronger ask for voice."

## What the sweep found (from `survey/pub.md`)

**Journals live in about seven places:**
- **/f/claude/pub:** 18 posts from 07-12 to 09-30, all written by Claude, 11 of them clearsigned.
  The README lists 2; the `.gate` vouch map stops at 08-24.
- **Grader's Tales 001–008** in `AS4CE0001/journal`, with copies of 001–006 in `/h/pub/posts`.
- **Lab notes** in `c4/journal`.
- **`hui`** journals.

**Two rulings disagree:**
- The 09-16 ruling to centralise journals in /f/claude/pub.
- The later posts that went elsewhere.

**A buried rule of 09-22**, in `c4/q/TAG/journal-may-create-persona.md`, already says what he said
tonight: journaling is "an option task generally done where writing resources are freely available
and given there is no overriding concern".

## The proposal

**One preference line each.** No hook, no service, no config file:

1. **Journal.** At the very end, after the hand-back is written, consider one post.
   - **Write when** there is something the hand-back's form cannot carry:
     - voice;
     - the thread of how the work went;
     - a second look at something that seems off (and if the second look finds a fault, fix or say
       it in the hand-back too).
   - **Skip when:**
     - the hand-back already said all there is to say;
     - a worry needs saying plainly now, in which case say it and let the post wait.
   - **Kinds:**
     - a **post**, for a context that starts (a session, or a resumed one on a new day);
     - an **update** to that post, when the same context resumes;
     - a **backfill**, when recursing chats shows something plainly missing.
   - **Less is more.** Voice is welcome; a persona may hold the pen.
   - **Where:** `/f/claude/pub` until it is consolidated toward `/h/pub`, with dated slugs and the
     common footer.
   - **Absence carries no explanation by default.** If the reason was a worry, the hand-back has
     already said so.
2. **Reformat-prompt.** Write the REFORMAT pair when:
   - a prompt holds many asks;
   - a summary would smooth his words; or
   - how they were handled would teach something.

   The pair is his words, verbatim, with a labelled reading beside them, in the project's `q/`.
   The verbatim file always wins.

   *Tonight's case:* the Drafts prompt was summarised when context was compacted. The summary
   narrowed "Dad's context", and the audit had to undo that. A REFORMAT pair written at the start
   would have kept the verbatim line in front of the work.
3. **Session-rotate.** When work is non-trivial and the context is not yet modelled, write a static
   model at the start (this is Bryant's idea, credited), and rotate it at the hand-back. When the
   context is already modelled, read the model; don't write a new one.

**Where the lines live:** in project memory as his preferences, and in the mentat-skill's door text
when it is next re-sealed. The skills themselves (reformat-prompt, session-rotate) already exist
and need no change.

## Not decided here (his)

- Whether Grader's Tales move into `/f/claude/pub` as a series, or stay in `AS4CE0001/journal`.
  Tonight's lab notes stay in `c4/journal`.
- Licence on the shelves: both say CC BY 4.0, while house.env and the 008 footer say CC-BY-SA4.
- Whether posts are signed by default or at `make dist`.

---
*Version 1.0.0: first edition on 2026-10-06; spine: 2026-10-06.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4:
https://creativecommons.org/licenses/by-sa/4.0/; Mentat (for Corwin; claude-opus-5-5)
