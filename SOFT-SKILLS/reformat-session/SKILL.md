---
name: reformat-session
description: >-
  Write a session up as a log the person can read back: his words in order, broken into chunks,
  each followed by a plain reading of what he asked or said; then what was done (files, commits,
  checks); then what was told him, verbatim. Built from the session's own transcript by a script,
  never from memory; his words are checked verbatim and for full coverage. Says what was done and
  why only as far as ties the work to his words, and never narrates how conclusions were reached.
  Use when asked to "write up the session", "log tonight's prompts", "reformat-session", "play my
  thinking back to me", before rebuilding a comic or a drift page from a session, or at a session
  close. A sibling of reformat-prompt (one prompt) for a whole session.
---

# reformat-session

The sibling of reformat-prompt, for a whole session.  His request, verbatim: "Walk over the prompts
tonight and do your best to see you have a good written log of the conversation as unsmoothed long
form, interposing your rewrites of what you saw between your documentation of your responses."
And later: "it can be mostly what I said broken up ... my own thinking ABSOLUTELY MUST be fair to ask
you to play back to me."

Why a sibling and not a change to reformat-prompt: reformat-prompt lands one prompt in C4's form;
this one walks a whole transcript and can be run by sub-agents in parallel.

## Steps

1. **Extract.**  `scripts/extract.py SESSION.jsonl OUTDIR` reads the harness transcript and writes
   only what was visible: his prompts and mid-turn messages, your text, your tool calls (short
   form), short tool-result excerpts.  It drops thinking blocks.  It splits into turns at each prompt
   of his.  Turns before a context compaction are only in the summary; take his words for those
   from where they were saved verbatim on disk (q/ folders, continuity files).
2. **Draft, in parallel.**  Give each sub-agent a turn or two.  It writes `TURN-NN.json`:
   `chunks` (his words as exact substrings of a source, covering everything he said, in order,
   each with a one- or two-sentence `reading`), `did` (facts: what changed, where, which check and
   its result), `said` (a summary).  Tell it: no account of how anyone reasoned.
3. **Check.**  `scripts/check.py DRAFTDIR`: every chunk is found verbatim in its source, and his
   words are fully covered.  Exit 1 on a break.  You decide which parts of each draft to keep (for
   example, drop a chunk set that only repeats an earlier message).
4. **Assemble.**  One `TURN-NN.md` per turn: his words quoted, each followed by its reading; what
   you did; what you told him, verbatim from the transcript (mid-turn messages and the final reply).
   A reply stopped by the platform is recorded as stopped, not reproduced.
   `scripts/assemble-example-2026-10-04.py` is the first run's assembler, kept as the example.
5. **Land it** where the person keeps intake (a project's `.house/session/DATE/`), with the raw
   extract beside it, so a later session can rebuild from it.

## Accommodations, downstream

The log is a verbatim record: his words stay exactly as sent.  In anything produced from it (a
comic, a model, a skill that quotes him), spelling is corrected as an accommodation, his rule of
2026-10-04, so everyone can read the work more easily: list each correction beside the quote, keep
the words he mints, and when an error turns out to be load-bearing, tell that part of the story with
the error intact.  Replaying his typos back at him reads as mockery.  The field comic's
data/ACCOMMODATIONS.org and its checks are the worked example.

## What it is not

Not a summary: it keeps everything he said.  Not an account of the model's inner workings: readings
say what he asked; "did" says what changed.

<!-- footer: minted by bin/ft1mt from conventions/house.env and conventions/FOOTERS.org; edit those, not this -->
*Version 1.0.1: edition revised from 1.0.0 on 2026-10-04; spine: 2026-10-04.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4: https://creativecommons.org/licenses/by-sa/4.0/ (scripts GPL-3.0-or-later); Mentat (for Corwin; claude-opus-5-5)
<!-- /footer -->
