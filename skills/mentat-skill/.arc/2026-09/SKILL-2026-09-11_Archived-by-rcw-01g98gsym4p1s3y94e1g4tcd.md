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

