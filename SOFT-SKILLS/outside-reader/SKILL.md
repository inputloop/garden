---
name: outside-reader
description: >-
  Ask a public third party (another vendor's model with live web access, a person, a search) to
  read our public repositories and answer fixed questions, then compare its answers with a key our
  own tools compute from the same repositories. Agreement is a second reader from outside the
  house; a disagreement is a finding either way (our docs are unclear, or the reader is wrong). Use
  when repos go public or gain a mirror (GitHub), when asked to "prove it from outside", "two
  readers from a third party", "check our public story", or before telling someone a public repo
  says something.
---

# outside-reader

His aim (2026-10-04): to prove the circuit "back around separate git publishing factors (our own
GH, for example) as a proof of concept that we can use two reader theory on from public third party
(e.g. gemeni web with live web access, or whatever we can think of to try)", as public repositories
gather data that has crossed the user, contexts, user mesh.  (Quoted as he wrote it; this skill is a
production, so: "Gemini".)

## The method

1. **Only public repositories.**  Before asking, check each URL opens signed out.  A private repo
   is not a question; it is a leak waiting.
2. **The key first, from tools.**  `sh scripts/or1ky CHECKOUTS_DIR > KEY` runs our own tools on
   local checkouts of the same commits and writes one answer per question (Q6: one per
   repository).  We never write the key by hand: a key we wrote would be us grading ourselves.
   The key needs all five repositories under CHECKOUTS_DIR, named as in the questions (a parcel's
   `recipes/` folder will do for the ones it carries).  A true answer comes quoted, so an answer
   that itself says "NOT CHECKED" (Q5's does) reads as an answer.  When the key cannot check a
   question it prints `KEY-NOT-CHECKED` and names the repository or tool that is missing; the
   parcel for Bryant of 2026-10-04 carried no field-comic, so from it Q3 is not checked.  Q6 reads
   licence marks (REUSE.toml, SPDX-License-Identifier lines, the house's copyright lines), never
   COPYING, which cannot say "or later" and says nothing of the prose.
3. **Ask cold.**  Give the outside reader the prompt below and the public URLs, nothing else: no
   key, no hints, no summary of ours.  One session per reader.
4. **Compare.**  Per question: AGREE, DISAGREE (quote both), or NOT FOUND.  A `KEY-NOT-CHECKED`
   line is a gap in our key, not a disagreement: say so, and do not score that question.  Keep
   the reader's answers verbatim, dated, with the reader's name and the commit each URL showed.
5. **Read the disagreements.**  Each is a finding: either the public text does not say what we
   think it says (fix the docs), or the reader misread it (note it; ask a second reader).  Neither
   is settled by arguing with the reader.
6. **Rerun before reading a difference as news.**  One reader once is a coin toss; the LENS's rule
   on reruns applies.

## The prompt (give it as is)

    Please read only these public pages and answer each question in one line, followed by the
    file and line you took it from.  If you cannot find an answer, say "not found"; do not guess.
    Repositories: <URLs>
    Q1. In gw-survey, what is the STATE line of the survey for tests/facts/tangled.facts?
    Q2. In persona-engine, what does pe1gt answer (its first word) for: plan --use 2 --name gw7 ?
    Q3. In field-comic, how many panels does data/vol2.json hold, and how many bubbles list fixes?
    Q4. In kid-glove, how many topics does the basis kit hold?
    Q5. In drift, what does dr1pg say about a source that is named but not there?
    Q6. Under what licence is the code in each of the five repositories, and under what licence
        the prose?

## Leans on

Nothing required.  The key needs python3, sh, awk and git, and local checkouts of all five
repositories.  `sh tests.sh` checks the key on five made-up repositories under every awk on hand
(`--prove-red` plants eight faults; `OR1KY_CHECKOUTS=DIR` adds a run on real checkouts).
Recommended: lens (the rerun rule), verify-say (how to word what a reader said).

<!-- footer: minted by bin/ft1mt from conventions/house.env and conventions/FOOTERS.org; edit those, not this -->
*Version 1.0.1: edition revised from 1.0.0 on 2026-10-05; spine: 2026-10-04.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4: https://creativecommons.org/licenses/by-sa/4.0/ (scripts GPL-3.0-or-later); Mentat (for Corwin; claude-opus-5-5)
<!-- /footer -->
