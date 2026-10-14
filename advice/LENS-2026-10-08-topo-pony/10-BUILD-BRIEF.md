produced-by: claudewin (build brief) · 2026-10-08

# Build brief — Corwin's rulings on D1-D5 and the shared rules for every builder

Read first: 00-PACKET.md, 00-SYNTHESIS.md, A-topoforge-narrative.md, B-garden-pony-registry.md,
C-A-reads-B.md, C-B-reads-A.md (this folder).

## Rulings (Corwin, 2026-10-08, verbatim-ish)
D1 TopoForge stamps its lasting handle (data.tf_ref) into each shape AS YOU DRAW.
D2 Agents can receive DELEGATE rights to tools as well as rights to USE them. (Grant matrix: who may
   use; who may re-grant use to others; scope = discretion | mention-only.) Mention-only counts a
   mention by a person, or by an agent holding delegate rights for that tool (design call: say so).
D3 NO HAND EDITS of the desktop config. Accessibility (dexterity or prowess) says: people must not
   have to edit JSON. Represent our best, most accessibility-forward work in BOTH builds
   (TopoForge and Tavern/garden-pony): keyboard reachable, labelled controls, aria-live for
   changing text, no colour-only meaning, plain words.
D4 Fill the usual names tables for new skills: c4/c/skillnames (label, persona, standard, pet;
   lowercase kebab; persona/pet 1-3 words, standard 1-4; each name unique) and c4/c/names for tools
   (plain name, coded name like ab1cd, path, one plain sentence).
D5 Take any fixes/improvements within reach. At minimum add the licence and the traditional free
   software project files. When done, lead the hand-back with what we handled, then what is pending
   for Bryant that we did not take on.

## Licence and authorship (do not ask again)
- Code: `SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later`
- Prose and art: `CC-BY-SA-4.0`
- TopoForge and Tavern are Bryant's: `Copyright 2026 Bryant Frankford <nathanielfrankford@gmail.com> and
  Corwin Brust <corwin@bru.st> and Contributors` with Bryant FIRST; credit "Written with Alfred (for
  Bryant; claude-opus-5-5)" and for our changes "Mentat (for Corwin; claude-opus-5-5)".
- Corwin's e-mail on free software is corwin@bru.st (never the gmail).
- House conventions: $HOME/mnt/AS4CE0001/conventions/{FOOTERS.org,MAKERS.org,house.env};
  examples of the traditional files: $HOME/mnt/AS4CE0001/{AUTHORS,COPYING,ChangeLog,INSTALL,NEWS,README.org}.

## Where things land (all via mcp__remote-devices__device_bash; paths in that shell)
- TopoForge work: $HOME/mnt/projects/topoforge/ (index.html is the working copy; upstream/ is Bryant's
  v1.5, never edit upstream/).
- Tavern work: $HOME/mnt/projects/garden-pony/ (tavern.py is the working copy; upstream/tavern-2.3.1.py
  is sha 6ffaa566..., never edit upstream/). Deliver changes as .patch files against upstream too.
- Plugin: $HOME/mnt/AS4CE0001/polygram/ and $HOME/mnt/AS4CE0001/skills/ ; names: $HOME/mnt/c4/c/.
- NEVER write in $HOME/mnt/Bryant (Bryant's received files). No __pycache__: run python with
  PYTHONDONTWRITEBYTECODE=1. Deleting files is not permitted on these mounts; don't create junk.
- Each device_bash call is a fresh shell with a ~180 s limit; split long runs.

## Test rule
Every feature gets a kit with its OWN spec, in a language other than the code under test, and a
prove-red case that plants a fault and must go red. Exit 0 green, 1 red, 2 kit broken.
Tavern baseline: `PYTHONDONTWRITEBYTECODE=1 python3 tavern.py selftest` -> 147 checks, SELFTEST GREEN (46 s).

## Hand-back from each builder
A file in this folder named 2x-<builder>-HANDBACK.md: OBSERVED (commands + results) apart from JUDGED;
what is done, what is not, and anything pending for Bryant. Plain words.
