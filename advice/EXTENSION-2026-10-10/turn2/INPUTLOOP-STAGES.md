# The garden on inputloop: a private stage and a public stage

This page says how the garden (the AS4CE0001 folder: the vibrobeast plugin's source, its skills and
soft skills, its tests and its working notes) would sit in the inputloop organization on GitHub as two
repositories, what goes into each, what each one's README says, and what is checked before each push.
Nothing here has been pushed or created. Every name below is a proposal for Corwin and Bryant to keep
or change.

## Two words first

- **inputloop** is the GitHub organization Corwin and Bryant made as "one spot" for their combined
  works. Either of them has full control; each keeps staging and mirroring in their own places case by
  case. Repositories made from Corwin's end start private; either partner may flip one public, or back,
  and then tells the other. Three are there already: `topoforge`, `tavern` (with garden-pony) and
  `vibrobeast`, which holds the *minted* plugin (1.0.4, the files a person installs), not its source.
- **A stage** is a git repository arranged so that someone else can read it and, later, contribute.
  The house has a standard form for the public kind, the soft skill `public-stage`: one folder, one git
  repository, a private side called `.house/` that git never tracks, three models (one for us, one
  listing what needs care, one public), GPL code with CC BY-SA prose, few checks, each able to show
  itself failing.

Corwin asked for both stages, and for both to start private, with this in mind (08:10): "we must take
extra care to have everything be both clear, and have any unique vibe/voice which may possess the
work clearly forward".

## The shape I propose

| | private stage | public stage |
|---|---|---|
| name (a guess) | `inputloop/garden` | `inputloop/polygram` |
| what it is | the garden as Corwin keeps it, with its whole history | the plugin's source in the public-stage form, with a fresh history |
| who reads it now | Corwin and Bryant | Corwin and Bryant (private to start) |
| who may read it later | stays private | anyone, once either partner flips it |
| its git history | the garden's own (the upstream today is `code.bru.st/corwin/as4ce`) | starts at one commit: the carved material as found, byte for byte |
| its relation to `inputloop/vibrobeast` | the source of every mint | the source of every mint, in the form others can build from |

Why two and not one: the garden's history carries every old byte of every file, including the ones a
family cut holds back today. A public stage can only promise what its history promises, so it starts
fresh; the private stage keeps the full story for the two people who share it. This is the same reason
`fm1ct` (the family-cut tool) sends a written git log and never a git bundle.

## What moves where

The garden had 3254 tracked files at commit `535d010` (`git ls-files | wc -l`). By top-level folder:

| folder (files) | private stage | public stage |
|---|---|---|
| `polygram/` (42), `bin/` (51), `tests/` (170), `conventions/` (7), `Makefile`, `GRAMMARY.md` | yes | yes: this is the program |
| `skills/` (818), `SOFT-SKILLS/` (84) | yes | yes, each with its NOTICE where the words are someone else's (gauntlet, parallax, omni-tool, frugal-offload are Bryant's bytes, kept whole) |
| `README.org`, `NEWS`, `ChangeLog`, `AUTHORS`, `COPYING`, `INSTALL` | yes | yes, rewritten as below |
| `site/` (4), `doc/` (2), `tools/` (9) | yes | yes |
| `peers/bryant/` (12) | yes | yes: his, with his notices |
| `book/` (47) | yes | after the persona and quotation checks (`h/persona/AUDIT-quotes-split.md` is the model) |
| `advice/` (636), `h/`, `records/` (56), `journal/` (19), `Inbox/` (22), `claud-qa-hold/` (20) | yes | no: working material; the public model (`MODEL.org`) says what it taught |
| `metrics/` (186), `.arc/` (251), `archive/` (162), `.eclipse-increments/` (76), `.models/`, `models/` | yes | no: history and gauges; the public stage carries the current state only |
| `memory/` (220), `mainmem/` (42), `MEMORY.md` | **not until Corwin says so** (see below) | no: this is `.house/` material |
| `.sessions/` (26) | yes | no |
| `.house/` (the private side) | not tracked anywhere | not tracked; holds `model.md`, `SENSITIVE.md`, the verbatim prompts |

**The one decision that is not mine.** Corwin's signed grant of 2026-07-05
(`memory/corwin-wheel-sharing-consent.md`) lets his own information go to Bryant "point by point --
each detail released only on his explicit per-item approval". The memory folder is his own information
in bulk, and parts of it are about his family. So today's garden cut for Bryant holds `memory/`,
`mainmem/` and `MEMORY.md` back, each by a written row in `conventions/FAMILY-HOLDS.tsv`, and the
private stage should do the same until he answers. Two ways through, both his: approve the memory
folder for the private stage (one row removed, one push), or name the notes that may go and move the
rest under `.house/` first. Pushing the garden's existing history would carry the memory folder's old
bytes even if the folder were removed in a new commit, so if the answer is "not yet", the private stage
also starts from a fresh history, or from a history rewritten without those paths, and that rewrite is
a step for him to run, not me.

## What each README says

Both READMEs follow the long-document model Corwin set this turn: plain at the top, then voice
arriving "in drops and dabs" as the context narrows, each term of art unpacked where it first earns its
place.

**`inputloop/garden` (private).** First paragraph: what this is (the working garden behind the
vibrobeast plugin, shared between Corwin and Bryant), that it is private, and where the installable
plugin lives (`inputloop/vibrobeast`). Then: how the folders are laid out (`INDEX.md` already does
this, and `bin/hb1ck --layout` checks it); what is held and why (a pointer to `FAMILY-HOLDS.tsv`); the
licences (writing CC-BY-SA-4.0; code GPL-3.0-or-later OR LGPL-3.0-or-later; the TA model alone CC BY
4.0); credit in the order Corwin, Bryant, then Bridgit (K Smith) as editor where she edited.

**`inputloop/polygram` (public stage).** First paragraph: what the program does for someone who has
never heard of us (a packaging layer that turns notes and preferences into Claude skills and MCP
servers, run from POSIX shell and Python's standard library). Then how to build and test it
(`make check`, `make dist`), then the shop's words, each explained once with GRAMMARY.md as the
glossary, then the partnership and the licences. `MODEL.org` is the public model; no person, device,
address or key appears in it.

## The checks before each push

Each is a command that exists today; each prints NOT CHECKED, never a pass, when it cannot run.

Before **either** push:
1. Secrets: `sh bin/sb1rn $(git ls-files)`. Every hit is fixed, or reviewed into a row bound to its
   path, line and line hash (`conventions/SECRET-REVIEWED.tsv` holds the nine read today: all token
   variable names or test fixtures).
2. Embargo words and claude.ai links: `c4/bin/pb1ck` over the unpacked `git archive HEAD` (it now
   reports both); or the family cut's second reading, `c4/bin/fm1ct check`, which tests the same.
3. Licences: `sh bin/lc1ck` over the prose; zero faults.
4. Footers: `sh bin/ft1mt check`; zero breaks.
5. The suite: `python3 -m polygram.mcp --prove-red` and `make check`.

Before the **public** push, also:
6. `git ls-files | grep -c '^\.house/'` prints 0, and `.house/` is a line of `.gitignore` (today it
   is not: that line is the first commit of the carving).
7. The sensitivity file links both ways (egad's `.house/sensitive-links.sh --prove-red` is the
   pattern); every `[S#]` mark in the tree has a row and every row has a mark.
8. No commit carries a link to an AI vendor's session page. Today's commits end with a
   `Claude-Session:` trailer, so the public stage's first commit is written fresh with the attribution
   the keeper asked for (`Assisted-by:`), as `public-stage` says.
9. A leak read over `git archive HEAD` for paths, addresses and IPs: `c4/bin/pb1ck`, with each hit
   either an intended example (listed in `.c4/examples`) or fixed.

The pushes themselves, and the creation of the two repositories in the organization's web page, are
Corwin's.

## How this page could be wrong (falsifiers)

- Corwin or Bryant wants one repository, not two; or wants the garden's history public.
- A file the table sends to the public stage turns out to need care (a pb1ck or sb1rn hit that is not
  an example).
- The memory folder is already cleared for Bryant by a record I have not seen; then the hold row is
  removed and the private stage can take the garden's history as it is.

Mentat (for Corwin; claude-opus-5-5)

---
Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
SPDX-License-Identifier: CC-BY-SA-4.0
