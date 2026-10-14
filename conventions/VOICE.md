# VOICE: how what we ship sounds

This page says how the writing we ship should read: READMEs, manuals, the glossary, skills, the
Terms and the Privacy Policy. It is short on purpose. Each rule says what to do, why, and how to
check it.

## The idea in one breath

Corwin Brust and Bryant Frankford pool their tools and writing into one shared collection. The
writing should sound like that: two people, plainly glad to share, who say what a thing does before
they say anything about themselves. Corwin asked for it in these words:

> *"show a really winning model of partnership in all we ship"*

and named what it must not do: make him *"look very proud to be me."*

## The rules

1. **Open general, in plain words.** The first screen says what the thing is and does, for a
   stranger, with no house words. Voice comes later, and gradually: *"in a long multi-context
   document such as a README or manual/info section we can work our voices in gradually and in
   drops and dabs over the body of the work as the context grows less general."*

2. **Name us once, early, as two people.** "Corwin Brust and Bryant Frankford ... together." After
   that, "we" for the two of us, and a person's name where a reader needs to know whose idea it was.
   Credit order is Corwin, then Bryant, then K Smith as editor of the works she edited; a single
   item's own credit line puts first the one whose work it most is (MAKERS.org already does).

3. **First person, signed once, at the end.** *"Work every item to be first person, sign it once
   at the end."* No `the instrument`, no mid-text `Mentat (for Corwin)`, no "not mine to rule": say
   "Corwin decides this", or ask him.

4. **Don't mark your own parts.** *"Stop weighing down things because (you think you might know)
   you wrote the parts except where you quote me."* Who drafted which paragraph lives in git, the
   journal and the ChangeLog. The page only marks other people's words, by quoting them.

5. **Quote to celebrate.** Write a person's words *"into work in a form that celebrates the words,
   and the people reading them"*: in the body where they land, as a pull quote or a lead line, with
   the name beside them. Not in a Provenance box after a paraphrase, and with no "(verbatim)"
   apology. Spelling may be healed for reading; each heal is listed in the ChangeLog or journal,
   where the exact words are kept.

6. **Unpack each term of art where it first earns its place.** Bold the word, one plain sentence of
   what it is, one of why it helps; then use it freely. GRAMMARY holds the long form.

7. **Say where things are once.** One legend line, then a mark. GRAMMARY's marker is † ("A path
   marked † lives in the source tree ..., not in this plugin"), where it used to repeat a
   parenthesis 74 times.

8. **No bracket tags in shipped prose.** Of `[MINE]`-style tags Corwin said: *"I see a missed
   opportunity."* Each one becomes a sentence that says whose reading it is and why ("My reading,
   for Corwin to rule on: ..."). The tags were retired on 2026-09-24; `bin/release` refuses them.

9. **Dates live in the record.** A date goes in a file name or a heading only when the date is the
   subject (a release, a ruling). Corwin called the habit of adding one *"a curious antipattern to
   repeatedly invent"*: a second witness to the time of writing, where the file's own time and
   content already say it.

## How to check it

- `sh bin/fp1gk PATH...` counts the four devices rules 3, 4 and 8 retire: bracket tags, "the
  instrument", a third-person self-name mid-text, and a byline before the end. A gauge: counts,
  never a verdict. Some "instrument" hits are the measuring kind (a run card's instrument, a legal
  instrument) and are meant.
- `sh tests/readme-voice-tests.sh` checks the minted README against rules 1, 2, 3 and 5.
- `awk -f tests/terms-v2-spec.awk TERMS-OF-SERVICE.md` checks the Terms against rule 2 and the
  one-desk phrases they used to carry.

## What would prove this page wrong

Rewrite a README's first two sections by rules 1 to 6, hand both versions cold to a reader who has
not seen the project (Bridgit, or someone outside), and ask which one tells her who made it and what
it does. If the old one wins, these rules are wrong, and this page changes first.

Authored by Mentat (for Corwin; claude-opus-5-5).
Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
SPDX-License-Identifier: CC-BY-SA-4.0
