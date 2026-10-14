---
name: intern
description: >-
  Ingest a text so that the taxonomy deepens: find its essential words (keyness, not frequency), seat
  each one or decide it with a reason, and keep going until none is left. Use when bringing a text,
  chat topic, paper or transcript into C4's registry; when asked to "intern these words", "ingest this",
  "what words don't we hold yet", "place these in the taxonomy"; or when an ingestion's words need
  checking before hand-back. Fires chapter 16 of the C4 spell `spells/ingest-writing/`.
---

# intern — every word makes code

His rule, from his chat (c/i `every-word-makes-code`): a build stops at any word it cannot handle, and
you use other words, or define the ones you have, until every word makes code. For ingestion it reads:
**a text is not ingested while one of its essential words is neither held nor decided.**

## The check

    c4 intern --text TEXT [--top N] [--reasons DECISIONS]    # exit 0 = done; exit 1 prints the queue

Each word reads as one of four states:

| state | meaning |
|---|---|
| SEATED | m/t, c/w, or a form of either holds it |
| MEANT | a g/ leaf or a term of art says what it means |
| DECIDED | a row in the firing's decisions.tsv |
| NEW | none of these, with its measured reach, or "below the floor" |

## The wave, short

1. **Pick the essential words** with `c4 intern --text`. Split the text so that two readers see
   different parts.
2. **Run two lanes, equal:**
   - IDEATION proposes `c/i` rows (intent, his sentence and its id, TENSION);
   - TAXONOMY decides each word (ACCEPT, HAND, REFUSE, BANK, HELD) and proposes g/ leaves and terms
     of art.
   Proposals only.
3. **Audit** an odd reach with `c4 intern --why WORD TERM`. Homographs show themselves there.
4. **One writer merges.** Registers are written whole. † marks one lane; a split seats nothing and is
   banked. Measured seats go through `c4 intern --write`, whose screen-name gate is on by default.
5. **Use tension.**
   - Mechanical tension becomes links: TENSION, ALSO.
   - Tension on a weak point becomes an opening in `writing/<subject>/`. Keep every opening.
6. **Review with a LENS** over a pinned subject; one reader reruns. Then run the check again, and
   record before and after.

## Labels

A code-shaped word (C1, Q528) is a label. `c4 intern C1` reads it:

- by construction (register C, facet 1);
- by every place the shop's canon defines it, each as a MARKER (path, first line, last line) with its
  words;
- by its interned leaf, through that leaf's MARKER datafile (`c4 marker`).

Say which sense you mean, or hand over the reading. A pseudonym is never resolved.

## Hooks

- **Required:** the C1 screen-name gate. It is on by default; `IN_GATE=off` is said aloud.
- **Opportunistic:** `wd2nn`, `lens.py`, and mentcached `word_register`. Use them when they are
  present, name them when absent, and go on.

## What it is not

- Not a licence to quote others. The chat rules (chapter 15: C1, C2, C6) hold for every source.
- Not a stop rule. Exit 1 is the next wave's queue, not a failure.

Referents, both ways: `c4/spells/ingest-writing/chapters/16-intern-every-word.md` (names this skill) ·
`c4/bin/in2rn` (`c4 intern`) · `c4/chat-topics/c4-ghostwheel/` (the first firing) · `c4/a/actors/`
(the actors and their hooks).

<!-- footer: minted by bin/ft1mt from conventions/house.env and conventions/FOOTERS.org; edit those, not this -->
*Version 1.0.1: edition revised from 1.0.0 on 2026-10-04; spine: 2026-10-04.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4: https://creativecommons.org/licenses/by-sa/4.0/ (scripts GPL-3.0-or-later); Mentat (for Corwin; claude-opus-5-5)
<!-- /footer -->
