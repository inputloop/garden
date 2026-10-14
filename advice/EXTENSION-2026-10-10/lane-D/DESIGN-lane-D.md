# DESIGN — Lane D: four new tools (st1dt, rd1ck with ROADS.md, qg1ck, br1in)

*Form: DESIGN, written before the build (2026-10-10). Source of the tasks: `../DESIGN-extension-edition.md`
§3 Lane D, the contracts in §2, cards 07, 13, 17, 18, 21, 22, 25, and the study
`c4/spells/extension/runs/2026-10-10/study/S1-bryant-modes.md` §7 for br1in. Who will run the result:
Corwin and any session in the garden, from the device shell (POSIX sh, awk; tests in Ruby and Tcl).*

Guesses I am making (marked as guesses):
- A folder is "seated" when a `.gate` governs it (nearest one walking up, stopping at the mount root) or
  it carries `.polygram`; "unseated" otherwise. Guess, from the T model's seating act step 1.
- Bryant's pinned key is the issuer fingerprint `5D9924DCD4F1FC3F76FECADE6FA7DB9DF84D5DE7` (key id
  `6FA7DB9DF84D5DE7`). Source: `gpg --list-packets c4/from-bryant/2026-08-05/skills/adapt.skill.sig`
  and `AS4CE0001/memory/prior-instruction-and-the-keepers-pen-2026-09-23.md` ("Bryant's key is
  6FA7DB9DF84D5DE7"). The public key is not in this session's keyring, so a signature here reads
  NOT CHECKED (issuer compared to the pin only).
- The frame's `gauge` rows for a question carry the confidence that the next question could be
  skipped in CONFIDENCE, the question text in NOTE, and a pair id in LABEL. The §2 contract fixes the
  columns, not their use inside a `gauge` row, so qg1ck states this reading in its header.

## D1 st1dt (the seating detector)
Reads one folder. Walks up for `.gate` (to the mount root), tests markers (`.polygram`, `.seed`,
`RECIPE.org`, `.git`, `model.md`, `INDEX.md`, a PMO key file), counts secret-class entries without
naming them, says it in words, proposes one grain (none / light / full) with a reason and a falsifier,
prints ONE question, and a words read-back of what was shown. Never writes. A remembered "no"
(`skill.seatkeeper.<hash>=no` read through `bin/pr1ef` or the prefs file) makes it say "declined on
<date>; not asking again". `--names` shows secret-class names only for the non-fenced classes
(invoices) on ask; the never-list (.house, .keys, *.secret, *.key, Z, a, p, SAVANNAH, .patternwalk,
chat bodies) is never listed even then.

## D2 ROADS.md and rd1ck (the roads checker)
`conventions/ROADS.md` is the source: one Markdown table per store, rows in order. Each row has a
road kind (`mount`, `mcp`, `hand`, `drop`, `connector`) and a target. rd1ck walks rows: a `mount`
road is READ when the path exists and is readable, FENCED when under a fenced path (never stat'ed
beyond the string test), NOT REACHED otherwise, naming the seat that looked, the parent folder it
listed and the request it tried ("none open"). `mcp`, `hand`, `drop` and `connector` roads cannot be
walked by a shell: NOT REACHED with "request: ask in chat" (never "absent").

## D3 qg1ck (the question gauge)
awk over the frame: FAIL (exit 1) when any `gauge` row in a two-question frame has CONFIDENCE above
0.17; counts unglossed GRAMMARY words in NOTE (a word from GRAMMARY's headings that appears in a
question with no gloss on the same line, gloss = "(" or " — " or ": " after the word); counts `pref`
rows (mirrors). Prints counts in words.

## D4 br1in (the Bryant drop intake)
Read-only. Checks the transport sums, the inner sums of each archive, the signature issuer against
the pin; unpacks every archive into scratch outside the mounts; hashes every file; finds every skill;
finds each skill's prior copy in earlier dated drops (and notes copies in the other intake places);
says NEW / UNCHANGED / CHANGED / DROPPED with what changed (SKILL.md, files added/removed/changed,
description, headings, new version notes); maps each to our counterpart via
`conventions/bryant-counterparts.tsv` or by name; lists the modes of work extracted from the
description and headings, marked "extracted, not judged"; writes mechanical open questions; writes a
words report, a TSV for tools and an ACK (hashes and a verdict, never content). Refuses an output
folder inside any drop; never reads under a fenced path.

Authored by Mentat (for Corwin; claude-opus-5-5).
Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
SPDX-License-Identifier: CC-BY-SA-4.0
