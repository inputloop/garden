---
name: question-economy
description: >-
  How many questions to put to a person at once, and how to log them. Ask one question, read the
  answer, then decide whether a second is needed; ask two together only when the confidence that
  the second can be skipped is 17% or less. When usage.capture is on, log each question with
  question_log (a likelihood and confidence pair) and, after the answer, its second_needed. Use
  before asking the user anything, before an AskUserQuestion-style prompt with more than one
  question, when about to "check two things with them", or when a question uses the shop's own
  words. Reads and logs only; never installed, served live by the mentcached dynaloader.
---

# question-economy -- one question, then decide

*The rule is Corwin's, from his rulings of 2026-10-09 for the extension edition
(`c4/spells/extension/SPELL.md`, chapter 1, and its A3: "Ask one question, read the answer, then
decide whether a second is needed"; Q573 and Q574, "always guessing in pairs"). This soft skill is
the line that tells Claude to follow it and to call the writer that counts it.*

## The rule

1. **Ask one question. Read the answer. Then decide** whether a second question is needed at all.
   The first answer often settles the second, or lets you infer what the person wants.
2. **Ask two together only when your confidence that the second can be skipped is 17% or less.**
   That is the same rule as "at least 83% likely that the second is needed". Above 17%, ask the
   first alone and wait. Write the number as a percent (`17%`) or a fraction (`0.17`); a bare `17`
   is refused by the writer, which says "write 17% or 0.17".
3. **Every guess is a pair:** a likelihood (low, medium, high, or a number) that the second question
   is needed, and your confidence that it could be skipped.
4. **Keep shop words out of questions to users.** A question to a person uses common words, broken
   down in context. A tool code, a project nickname or a term of art from this garden goes in only
   with its plain meaning beside it (GRAMMARY.md has them), or not at all.

## Logging it (only when usage.capture is on)

The question gauge (`bin/qg1ck`, in the author's tree) counts the questions logged in the usage
record. Nothing is logged unless the person has turned `usage.capture` on; it is off by default.

- **Before asking:** call `question_log` with `question_id` (a short id you make up), `frame`
  (`one`, or `two` when a second question rides with it), `question` (its words, one line),
  `likelihood` and `confidence` -- always the pair, even for a one-question frame.
- **After the answer:** call `question_log` again with the same `question_id` and `second_needed`
  (`yes`, `no`, or `unasked` when you asked one and never needed the other). An id that was never
  logged is refused, so log the question first.
- **Capture off:** the tool says "usage.capture is off: no frame row written". That is the expected
  answer; do not ask the person to turn capture on just to log a question. If they ask how, it is
  one sentence to Claude ("turn on usage capture"), and PRIVACY.md says what the record keeps.

## What this skill does not do

It does not ask questions for you, choose the questions, or rewrite what the person said. It
writes nothing itself; `question_log` writes one row, and only with capture on. It is a soft skill:
read live with `soft_skill_read question-economy`, never installed, and it graduates into the
garden only by Corwin's hand when the usage ledger shows it is used (`bin/ss2gr`).

<!-- footer: minted by bin/ft1mt from conventions/house.env and conventions/FOOTERS.org; edit those, not this -->
*Version 1.1.1: edition revised from 1.0.5 on 2026-10-10; spine: 2026-10-09.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4: https://creativecommons.org/licenses/by-sa/4.0/ (scripts GPL-3.0-or-later); Mentat (for Corwin; claude-opus-5-5)
<!-- /footer -->
