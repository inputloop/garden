---
name: colophon
description: "Name every maker of a body of work, and carry the terms every maker offers, by the attribution ladder: attribute who made the words and code, credit whose ideas shaped them, acknowledge and thank by hand. Reads notices, bylines, made-and-derived statements, git history, parcel copies and (with --sources) the lines first seen in each party's own sources; reads no one's terms from its own code, only from the keeper's parties file. Use before anything ships or is handed to another garden, on 'who made this', 'license this bundle', 'REUSE', 'attribution', 'credit', 'colophon', or when work crosses between gardens. Garden edition of Bryant Frankford's colophon 1.1."
---

# colophon (garden edition): who made it, who shaped it, and on what terms

*Bryant Frankford's colophon 1.1 (2026-10-05), with the changes below made in Corwin Brust's garden
and handed back to him. His 1.1 SKILL.md is `references/colophon-1.1-SKILL.md`, unchanged; the code
change is `references/colophon-1.1-garden.1.diff`. His selftest still passes on this code (36
checks; 8 planted faults caught), and `tests.sh` checks what changed (14 checks; 7 planted
faults, after a green control).*

## The ladder comes first

Corwin's rule, in his words (2026-10-05): use the left-most rung that applies.

> attribution <- credit <- ack/thank; use the left most that applies, attribute if we have reused
> or made a large quotation more than 15 lines from the sources collected from a given author
> -group or person- over the body of a work in context; credit if we can demonstrate or reasonably
> claim influence touching several areas/concerns of the work or one significantly, acknowledge
> those who we cannot easily thank personally or who we think prefer that, give thanks to those we
> know whom we've received help from and others we feel should appear in the list but don't yet

| rung | when | where it is written | what colophon does |
|---|---|---|---|
| **attribute** | their words or code are in the work: more than 15 lines from their sources, a copy, a derivation, a notice, a byline, their commits | the file's copyright (in-file notice or REUSE.toml), with terms every maker offers | finds it, names them, narrows the terms; `check` says UNNAMED when a file misses one |
| **credit** | their ideas, disciplines, designs or lineage shaped it, or a short quotation (4 to 15 lines) | the work's credits (README, CREDITS, AUTHORS, ACKNOWLEDGEMENTS, THANKS, NOTICE or FROM at the top) | finds it, says CREDIT; `check` says UNCREDITED when the credits do not name them |
| **acknowledge** | people we cannot easily thank, or who would prefer it | the acknowledgements | nothing: the keepers' call |
| **thank** | people who helped, and people who should be on the list and are not yet | the thanks | nothing: the keepers' call |

Why ideas are credited and not owned: copyright covers words and code, not ideas. Naming someone
as a copyright holder of words they did not write says something false about them, however kindly
it is meant; naming them in the credits says the true thing. Where their words are in the work,
the copyright names them, and the terms are the ones every maker offers.

## The parties file: declarations live outside the skill

colophon carries no one's name or terms in its code. They come from `.colophon-parties.json` at
the root of the tree (or `--parties FILE`): every party who may hold a share, the names and
addresses that identify them, the terms each offers for code, prose and art, where they said so,
and `"_keeper"`: whose garden this is. With no parties file, or no keeper, every command says NOT
CHECKED and exits 2. `references/parties.example.json` is a starting point with Bryant's and
Corwin's declarations as each has stated them; a keeper copies it and makes it theirs. So the two
gardens agree on the ladder and on each other's terms without either one's preferences riding
inside the other's tools.

## Commands

    colophon.py who   ROOT [--sources KEY=DIR[@DATE]]... [--parcels DIR]... [--no-git] [--json]
    colophon.py plan  ROOT [the same] [--joint "NAME <EMAIL>"]... [--toml-only] [--art-is-ours]
    colophon.py apply ROOT [the plan flags] [--year YYYY] [--fetch]
    colophon.py check ROOT [the same] [--one-reader]
    colophon.py texts DEST [ID ...] [--fetch]
    colophon.py --selftest [--prove-red]          sh tests.sh [--prove-red]

- `--sources KEY=DIR[@DATE]`: a party's own sources (a checkout, a parcel, a snapshot). Each line
  of the work is credited to the party whose sources hold it first: git's first-add date for a git
  tree, else the DATE given. A line first seen in two parties' sources on the same day counts for
  no one. Give the keeper's own sources too, or a line both hold counts for the other party. This
  is `scripts/at1ld.py`, whose second reader (awk) lives with it in the C4 tree as `bin/at1ld`.
- `check` with only one reader (no `reuse` installed) is NOT CHECKED, exit 2, unless `--one-reader`
  says the keeper accepts one. Install the FSFE's `reuse` for the second reader.
- Nothing is fetched from the network unless `--fetch` is given; the pinned texts beside the skill
  are used first, as in 1.1.

## What 1.1 does that this still does

Every one of these is unchanged and still proven by Bryant's selftest: a shebang, a coding line,
PHP, HTML doctype and batch `@echo off` stay first; SKILL.md bytes are never edited (REUSE.toml
instead); someone else's notice stands; a secret-shaped file is refused and never declared; art
asks whose it is; a hand-written REUSE.toml declaration is respected; apply twice changes nothing;
pinned licence texts are checked by hash; a derived skill names its source's maker on every file;
co-made code carries only the terms every maker offers; a byline names its principal; a quote, a
mention or an agent's byline makes no one a maker; an unknown maker is asked about, never guessed;
an unchanged parcel copy is theirs; an edited one is co-made; git history names its authors and an
AI co-author is no one.

## What changed, and why

| change | 1.1 | garden edition | the principle |
|---|---|---|---|
| whose terms the code carries | Bryant's and Corwin's, written in `PARTIES` | none; the parties file | declarations are agreed between gardens, not stamped into tools |
| an idea, discipline, design or lineage | makes a co-owner | is credited | copyright covers words, not ideas |
| a short quotation (4 to 15 lines) | (not read) | is credited | the ladder's credit rung |
| more than 15 lines from a party's sources | read only for a same-named parcel file at 60% similar | read across the whole work, dated, with `--sources` | the ladder's attribute rung; and Bryant's own direction of the same day: a contributor who can be detected is attributed |
| a copyright notice in SKILL.md | names its makers on every file of the skill | names them on SKILL.md only; a derived-from, byline or lineage statement still reaches every file | a notice speaks for its own file |
| a line in a Credits, Acknowledgements or Thanks section | read like any other line (a credit written "Alfred (for Bryant): ..." reads as a byline, so as a maker) | credit | the credits are where the lower rungs are written |
| a check with one reader | exit 0 | NOT CHECKED, exit 2, unless `--one-reader` | a comparison that never ran is not a pass |
| fetching licence texts | when the pinned copy is missing | only with `--fetch` | no network a person did not ask for |

## Falsifiers

- A file of the work holds more than 15 lines of a party's own, earlier sources, and `who --sources`
  does not name them: rung 1 failed. `tests.sh` plants this.
- A party is credited in `who` and `check` stays clean while the credits do not name them: rung 2
  failed. `tests.sh` plants this.
- `tests.sh --prove-red` first runs the suite unplanted (it must be green), then plants seven
  faults (ideas owned again, a keeper written into the code, line counts ignored, fetching by
  default, one reader accepted silently, notices spread to the whole skill, credits read as
  bylines); each must turn the suite red.

---
*Version 1.1-garden.1: edition revised from Bryant Frankford's 1.1 on 2026-10-05; spine: 2026-10-05.*

Copyright 2026 Bryant Frankford <nathanielfrankford@gmail.com> and Contributors (colophon 1.1) and
Corwin Brust <corwin@bru.st> and Contributors (this edition's changes); CC-BY-SA4:
https://creativecommons.org/licenses/by-sa/4.0/ (scripts GPL-3.0-or-later: co-made, so the terms both
makers offer; Bryant's 1.1 alone is also LGPL-3.0-or-later); Mentat (for Corwin; claude-opus-5-5)
