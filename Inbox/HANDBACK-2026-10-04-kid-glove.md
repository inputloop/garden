# HANDBACK · 2026-10-04 · the kid glove, drift, and the sweep three ways

Your prompt and its three mid-turn notes are verbatim at F:\claude\projects\kid-glove\.house\q\
(with the card photographed and read line by line beside them).

## What is new, and where

- **kid-glove** (F:\claude\projects\kid-glove; code.bru.st/corwin/kid-glove, private): the other
  hand of power-glove, as one literate recipe that unfolds into the skill, its tool and its tests.
  The house rules come first; the kit fills only the gaps, ours first, then the flagship (the card's
  GNU Coding Standards, Kind Communications, Words to Avoid, LibreJS, ScanCode and REUSE); a conflict
  is written once and never nagged; a re-check before hand-back names any TOUCHED house file, any
  TRAMPLE (a licence id that fights the house's) and any GAP (changes the house ChangeLog lacks), and
  ends with a drift checkpoint line.  It writes nothing inside the house it scans.
- **drift** (F:\claude\projects\drift; code.bru.st/corwin/drift, private): the slot C4's design held
  open, filled.  A page by formula from git, the ChangeLog, ENHANCE notes, DRIFT.log and the kid
  glove's ledger; every sentence cites its sources and every source lists who cites it; editions
  are mutations, the old ones kept; a line for alto's tail and a capsule under the wire's 32 KB cap;
  a second reader in sh and awk checks all of it.  The first real page is
  records/2026-10/DRIFT-2026-09-19-to-10-04.md (six editions; it reads true).
- **sk1in** (bin/sk1in, with tests/test_sk1in.py): Bryant's five skill-integrity checks.  Over our
  71 skills: 0 RED; principles and token-optimizer are CHANGED against their in-tree manifests (their
  dist bundles match); 65 have no dated version note, which your footer form would supply.
- **The sweep** (advice/20261004-ENHANCE-sweep-three-ways.md): 15 items from the last two weeks,
  10 from Bryant's drop, 7 from the card, each DONE, SEED or MULCH, with where it lands.
- **The persona shelf** (F:\claude\projects\persona-shelf, DRAFT, not pushed): 11 sheets copied,
  2 by pointer, sorted by your four uses, with a column for your word on each.
- **Ghostwheel rollout** (F:\claude\projects\ghostwheel-nodes; code.bru.st, private): the next
  rounds as a ladder of nine rungs, each with a check that can fail.  Nothing deployed.
- LibreJS labels on our own pages (the game's two scripts, with a check; egad's hello.js).
- The game: six sentences from gemma4:12b through llama-bridge; the score is 25 of 272.

## Two things the tests caught in my own work

- git's `--since` stops at the first commit older than the window, so a tree with out-of-order dates
  loses commits silently.  drift's tests caught it; both readers now filter by date themselves.
  None of our other tools uses it.
- test_ck1sk.py (from earlier today) and test_sk1in.py opened files without naming an encoding;
  test_bytes_boundary caught both when the full suite ran.  Fixed; I had not run the full suite
  after the first one landed.  Full suite now: 36 Python modules OK; the shell suites green.

## Yours

1. Cut 1.0.1 when you like (NEWS has it): `make dist`, sign, push.  Re-sign principles and
   token-optimizer first if you want sk1in's package check quiet.
2. code.bru.st: egad, mini-c4-game, kid-glove, drift and ghostwheel-nodes were created private by
   the push.  Make public the ones you want people to find, then add the GitHub mirrors.
3. kid-glove and drift: into the plugin, and how (soft skills, or drift in the floor's eighth seat
   as the default-skill-set design said: GRAIN 15)?
4. Footers on the 65 skills with no dated version note, at the next re-sign: yes or no?
5. The persona shelf: your word on each row, and a licence line for each sheet that goes.
6. Ghostwheel R0: which nodes, and how this session reaches them (a key like the forgejo one).
7. The comic-book view of transcripts: where does it live?  I could not find it.
8. Licensing with Bryant; I used -SA for everything new of ours today, CC BY for his words.

Your footer example has corwin@brust.st; I used corwin@bru.st as everywhere else.  Say if the
other is meant.

*Version 1: 2026-10-04.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4: https://creativecommons.org/licenses/by-sa/4.0/; Mentat (for Corwin; claude-opus-5-5)
