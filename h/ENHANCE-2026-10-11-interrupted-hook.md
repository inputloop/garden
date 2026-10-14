# ENHANCE 2026-10-11: a hook for the interrupted turn, so reformat-session can always rebuild

Corwin, 2026-10-11, verbatim: "makes sense on reformat-session; we need a hook in case something
interrupts us as an ENHANCE opportunity if you see a fit."

## The gap

reformat-session builds its log from the session transcript. Its step 1 already admits the hole:
"Turns before a context compaction are only in the summary; take his words for those from where
they were saved verbatim on disk." Last night this session was compacted, and his words survived
because I had copied them into q/ files and the continuity summary by habit, not because any hook
caught them. The 2026-10-10 turn that ended "Failed to report" is the same hole from the other side:
the work happened, the hand-back did not, and nothing on disk says which turn was cut.

`polygram/hooks.md` has no row for this moment. It does now, as a proposed row: **interrupted**.

## The fit I see, smallest first

1. **Catch his words at the door.** A `UserPromptSubmit` hook in the plugin appends each prompt,
   verbatim, with its time and session id, to `.sessions/<date>/prompts.jsonl` in the seat. Then
   reformat-session's extract takes his words from disk for every turn, compacted or not, and
   `scripts/check.py` already proves verbatim coverage. This one piece closes most of the gap.
2. **Mark the cut.** A `PreCompact` hook writes one line beside it: compacted at T, transcript at
   PATH. And the turn's span (`span_start` with no `span_stop`) is already the shape of "this turn
   never finished"; `span_report` only needs to say so.
3. **Say it at the next open.** `bin/se1sn` (the session-open note) reads the newest prompt line;
   if no hand-back follows it, it says: "turn N was interrupted; reformat-session can rebuild it from
   prompts.jsonl." That is the ENHANCE opportunity in his sense: the interruption becomes a prompt to
   resume, not a silence.

## Where it cannot reach, said plainly

- The desktop extension carries servers, not hooks. In Claude Desktop the capture could only be a
  mentcached tool the model calls, which depends on the model remembering to call it. So the
  extension gets piece 3 (the open note works from whatever is on disk) and the plugin gets all three.
- Whether Cowork runs a plugin's hooks I have not checked. Falsifier: install a plugin with a
  `UserPromptSubmit` hook that touches a file, send one prompt in Cowork, and see whether the file
  appears.

## Tests, when it is built

- A second-language reader (sh + awk) of `prompts.jsonl` against a transcript extract: every
  prompt in the transcript appears verbatim in the file. Prove-red: drop one line, it must fail.
- The main falsifier: after a forced compaction, `check.py` reaches 100% coverage of his words
  from `prompts.jsonl` alone.

## Fences

`prompts.jsonl` is his words on his disk, in the seat. It never ships: it joins the never-ships
list beside `.house/` (tests/arc-never-ships-tests.sh), and the egress soft skill names it.

Not built this turn. When you pick it, piece 1 is a short build with its tests.

Mentat (for Corwin; claude-opus-5-5)
