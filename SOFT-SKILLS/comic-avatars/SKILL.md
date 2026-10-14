---
name: comic-avatars
description: >-
  Give the person and the instrument each an avatar in a field comic (or any client that draws
  speakers), and let mood reach a face only through plain hint lines such as "mood: claude glad".
  The person's avatar is sticky: it stays the same until they comment on it; before that, new
  drawings are fine. A set they provide, with instructions for choosing, or compatible art they
  already have, is used instead. Hints are plain text so other clients (a context VM for another
  consumer, a user VM such as egadjit) can read the same lines and render them their own way.
  Use when building or rebuilding a comic from a session, when asked about avatars, faces, mood
  in the drawing, or "mood:" hints.
---

# comic-avatars

His idea, from the session of 2026-10-04 (spelling corrected as an accommodation; verbatim in
field-comic .house/session/2026-10-04/HIS-WORDS.txt): "Is there a skill-shape in that, where we could
build out an avatar for the user and claude (keeping the former sticky if the user comments on it or
otherwise doing new lines until they do, unless they happen to give specific direction like making
a set and providing instruction to pick from it, as we have setup, or if they happen to already have
compatible things we could use that; this could be hooked to mood with syntactic hints, so that other
clients can pick them up and treat with own markdown".

## The avatar

1. **Their direction first.**  If the person gave a set and instructions for picking from it, use
   that.  If they already have compatible art, use that.
2. **Otherwise draw.**  New drawings are fine until the person says something about their avatar.
3. **Then it sticks.**  Once they comment on it, keep that avatar (and what they said about it) and
   stop varying it.  Record the comment where the comic's data lives, so the next build keeps it.
4. **The instrument's avatar** follows the same rules; nobody has to comment for it to stay stable.

## Mood, only by hint

- A hint is one plain line, `mood: WHO WORD`, kept with the panel (in the field comic:
  `p.hints`).  Words: `glad`, `level`, `wow` (more may be added; an unknown word is ignored, never
  guessed at).
- With no hint, the drawing keeps its own deterministic choice (the field comic hashes the text).
- **A person's mood is theirs to hint.**  Write a mood hint for a person only from their own hint or
  their explicit opt-in; never infer it from their words.  Mood data does not leave the house
  without that opt-in and a confirm.  The instrument may hint its own face.
- Because the hint is text, any other client can read it and render it its own way, or ignore it.

## In the field comic (first cut, 2026-10-04)

`tools/cm1bd.py` patches the engine's `poseFor` to read `p.hints`; `data/build-data.py` sets one
hint, on the instrument's panel for the turn that rewrote the stopped prompt
(`mood: claude glad`).  The inline test T-MOOD checks the hint reaches the face, that it changes
what the hash alone would draw (so the test proves something), and that unknown words and
unanchored lines are refused.  Removing the hint, setting it to the hash's own choice, or
undoing the patch each turn T-MOOD red.

## Not yet

A sticky record of the person's avatar choice (step 3) has no store yet: there is no comment on
his avatar to keep.  When there is one, it goes beside `data/vol2-base.json`.

<!-- footer: minted by bin/ft1mt from conventions/house.env and conventions/FOOTERS.org; edit those, not this -->
*Version 1.0.1: edition revised from 1.0.0 on 2026-10-04; spine: 2026-10-04.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4: https://creativecommons.org/licenses/by-sa/4.0/ (scripts GPL-3.0-or-later); Mentat (for Corwin; claude-opus-5-5)
<!-- /footer -->
