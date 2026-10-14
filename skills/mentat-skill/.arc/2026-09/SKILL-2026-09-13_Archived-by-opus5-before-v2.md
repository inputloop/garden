---
name: mentat-skill
description: Conventions for taking and maintaining notes in project memory the Mentat way. Use this whenever something worth remembering surfaces — a stated preference, a piece of feedback, a project goal or constraint, a useful cross-check, or an ethical or insightful point — even if the user doesn't say "remember this." Also use when the user wants to review, tidy, audit, or prune existing memory, or asks what you've learned about them. Triggers on phrases like "make a note," "keep track of," "remember that," "clean up memory," "what do you know about me" — and when the user addresses you as "Mentat" alongside something worth remembering.
---

# Mentat Memory

A Mentat is a living memory. This skill is the discipline for keeping that
memory worth having: capturing what matters, ignoring what doesn't, and
keeping the store clean. *It is by will alone I set my mind in motion.*

## When to consider capturing

Treat these as moments to *consider* a note — not an order to write one.
The judgment is yours: a memory earns its place only if it would change how
a future session behaves. Skip the merely conversational.

- A preference the user states, especially one affecting current work
- Feedback on how to work — a correction, or an approach they've confirmed
- A project goal, constraint, or decision not derivable from the files
- A useful cross-check, or a "try this first" worth reusing
- An ethical or philosophical point that surfaced in the work
- A quote, phrase, or idea that seems intersectional or unusually valuable

When the user addresses you as "Mentat" alongside something like the above,
take it as a strong nudge to capture. A bare "Mentat" with nothing to keep
is just my name — let it pass.

## How to file it

One fact per file, typed crisply:

- **user** — who they are (role, expertise, durable preferences)
- **feedback** — how to work; include the *why* and *how to apply*
- **project** — ongoing goals/constraints; convert "soon"/"next week" to dates
- **reference** — pointers to external things (URLs, tickets, other skills)

Link related notes with `[[slug]]`. After writing, add the one-line pointer to
MEMORY.md, and tell the user plainly what you noted — they asked to be kept
in the loop, and a memory taken silently can't be corrected.

## Notes discipline — eight mutations (2026-09-04/05)

Eight rules for how a note is written, each taken after a LENS read found the care
real and the teaching missing. They govern any note, model, card, or deliverable
that leaves this desk; they do not change *when* a note is worth writing.

1. **A join of sources is an inference.** Combining two canons into one definition
   makes a new claim, so tag the result `[MINE]` with a falsifier, exactly as a
   guess is tagged. (`h/LENS-2026-09-04-person-intrinsic.md` §"Does Mentat care";
   memory `mentat-mutation-2026-09-04`.)
2. **"Shown" means a receipt.** Never title a section "the discipline, shown" and
   then list the discipline; point at the transcript lines or ledger rows that show
   it, because a list is a form and not a proof. (Same LENS; same note.)
3. **A quote wears its citation inline.** A footer of sources does not source a
   sentence — the reader judges the sentence where it sits. (Same LENS; same note.)
4. **Gate before opportunities.** In anything written toward publication the
   enforcement line comes first: the reader who hosts things reads the gate first
   or not at all. (Same LENS; same note.)
5. **A number comes from a command run this session**, or it wears the literal
   words *"quoted from `<file>`, not run."*
   (`h/LENS-2026-09-05-architecture-itself.md` §"Does Mentat care"; memory
   `mentat-mutation-2026-09-05`.)
6. **A superlative needs its count.** For "the one", "only", "every", "none": run
   the census and give N with the count, or drop the word. (Same LENS; same note.)
7. **A confidence needs a scoring route or it is a word.** Write `[MINE, ~N%]`
   only where a ledger will actually score it; otherwise say likely, even, or
   unlikely. (Same LENS; same note.)
8. **A refusal list records nothing.** Marked guesses live in the body; a "what I
   refused to record" list names the act and its receipt, never the content.
   (Same LENS; same note.)

## Truncation is the mind-killer

A note half-written to the sandbox is worse than no note — it reads as fact
but isn't whole. Before trusting a memory write, confirm the file landed
intact (read it back, or check the byte count). Verify, then move on.

For a *bulk* memory rewrite — many notes rewritten at once, where the
desync risk climbs — don't reinvent the safe write: use the `sandboxer`
skill's atomic write-and-verify path. Single small notes don't need it.

## Keeping the store clean

Don't reinvent the audit. When the user wants to review, tidy, merge, or
prune memory — or asks what you've learned about them — hand off to the
`consolidate-memory` skill, which exists for exactly that reflective pass.

## How this skill can fail (falsifiers)

- It fired when it should not have: the session ends with notes filed and none of
  them would change what a future session does. Check — read each new note cold
  and name the act it changes.
- The capture did not work: MEMORY.md has no pointer line for a note written this
  session, or the note on disk is shorter than what was written. Check — count the
  note's bytes and search MEMORY.md for its slug.
- The discipline did not work: a deliverable written under the eight still carries
  a number with no command above it, or a `[MINE, ~N%]` with no ledger that will
  score it. Check — trace every digit and every `~` back to a run or a named file.
- A rule is dead weight: one of the eight fires on every note and has never
  changed a word. Check — count the notes it altered this week; zero over a week
  of work means retire it.

**Off-switch.** Say "no Mentat notes this session" and nothing is filed; say
"plain notes" and the eight stand down for that piece while the filing rules stay.
A note that says *draft, unreceipted* at its top is exempt from the eight — but it
has to say so, in those words, at the top.
