# ENHANCE sweep, three ways, 2026-10-04

His ask (verbatim at F:\claude\projects\kid-glove\.house\q\2026-10-04-PROMPT.md): sweep for enhance
openings from (A) the last two weeks of sessions, worked backward, (B) Bryant's skills drop shared
to the TA project, and (C) the card; say for each whether it should be decomposed (and recomposed as
what), and whether it comes back as a skill, a soft skill, or stays seed or mulch.

How to read the verdicts: DONE means built and tested this turn; SEED means named, with where it
would land, not built; MULCH means kept as context, no action proposed.  OBSERVED rows cite the file
or command; the verdicts are my judgement.

## What came back as skills this turn

| new | from | lands as | where |
|---|---|---|---|
| kid-glove | his vision (the other hand of power-glove), Bryant's map-of-the-house yield rule, the card | skill + tools + recipe (one literate file) | F:\claude\projects\kid-glove (code.bru.st/corwin/kid-glove, private) |
| drift | the slot C4's default-skill-set design held open; TA's DRIFT.log and staged drift.sh; alto; the wire | skill + tools + recipe | F:\claude\projects\drift (code.bru.st/corwin/drift, private) |
| sk1in | Bryant's offer 2.3, the skill-integrity gate | a tool with a second reader | AS4CE0001 bin/sk1in, tests/test_sk1in.py |

Both new skills pass sk1in, prove red, and unfold identically under unfold.awk and Emacs 27.1's
org-babel-tangle.  Neither is in the vibrobeast plugin yet: that is his call (see the hand-back).

## A. The last two weeks, newest first

| # | when | what (OBSERVED, with source) | verdict |
|---|---|---|---|
| A1 | 10-04 | drift's tests found that `git log --since` stops walking at the first commit older than the window (a tree with out-of-order dates loses commits silently) | DONE in drift (both readers filter by date).  Checked: no tool in AS4CE0001 bin/tools/polygram/skills/tests or c4 bin uses `git log --since` (`git grep`). |
| A2 | 10-04 | ck1sk skips a slow check when the tree is unchanged since it passed | SEED: the recipe projects' `make check` could use it; not needed at their size yet |
| A3 | 10-04 | drawers v0.2: a miss is a requirement, answered by a pointer (c4 h/DESIGN-2026-10-04-drawers-second-reader.md) | MULCH for now; it meets the kid glove at "the house first": a drawer is a house rule |
| A4 | 10-01 | TA DRIFT.log (format: on-bearing? / still-arguing? / pushed-back / grader) and drift.sh "staged, waits on his pen" (ta DRIFT.log 2026-08-29T05:30Z) | DONE: recomposed as the drift skill; dr1pg reads that line format; kg1sc recheck writes it |
| A5 | 09-30 | TA's Plain Rules for AI Help, Rule 7: a MEETINGS line where an organisation's rule meets a person's want (org words quoted, forbid/require/prefer/silent, first ask, final word, who decided, date) (ta CARD-2026-09-30) | SEED for kid-glove 0.2: its CONFLICT/ENHANCE line is a MEETINGS line between the house and the kit; give it those parts.  Rule 3 (say who helped) is his footer form; Rule 5 is prove-red |
| A6 | 10-01 | ADVICE local agents, §5 "second witnesses" (ta ADVICE-2026-10-01) | DONE in part: gemma4:12b drafted four game sentences through llama-bridge (two jobs, ~15 minutes each); SEED: a second-witness lane for LENS once a job returns in under a minute |
| A7 | 09-30 | his lingering items: two means of indexing (taxonomy vs context stacking); "a current copy and a template/program that will make our next copy"; forms as "to be followed" ∩ "to be filled" (c4 q/2026-09-30-lingering-before-onward/PROMPT.md) | DONE in spirit: drift pages and the unfolded files are made by a program, never edited.  The kid glove's kit is the "to be followed"; its ledger is the "to be filled" |
| A8 | 09-29 | ERRATA: E23 the plaid as its own skill pends ENHANCE (his word); E25 soft skills ship in no edition (Inbox HANDBACK-2026-09-29) | MULCH (E23 stays his); E25 now matters for kid-glove and drift: where do they ship? (hand-back question) |
| A9 | 09-29 | c4 ENHANCE fold: a findings ledger; a cite resolver; awk named in every test; a lines mode for ngen (c4 h/ENHANCE-2026-09-29-fold.md) | dr1ck answers part of the cite resolver (every [R#] resolves both ways; quote-on-line not yet).  sk1in's prove-red names its four awks.  Others SEED as they were |
| A10 | 09-28 | default skill set: drift has no skill; "mint it on the second use" (c4 h/DESIGN-2026-09-28-default-skill-set.md §3) | DONE: drift is minted.  His call whether the floor becomes eight (GRAIN 15) or drift stays soft |
| A11 | 09-28 | the stile: the GNU ELPA path is long (assignment; GNU's cautious policy on LLM-assisted contributions) (c4 q/2026-09-28-stile/PROMPT-2.md) | SEED for the kid glove's kit: a "contribution policy" topic, the flagship's own rules on AI-assisted work as a house rule we meet at their door.  Needs reading GNU's current text first (NOT CHECKED) |
| A12 | 09-28 | teach the indexer to notice his "mail": questions put to him in chats (c4 q/2026-09-28-erc-hide-group) | SEED for drift: a "questions owed" section, read from the private chat stash, so it stays a local page, never a capsule |
| A13 | 09-27 | hardening: a checker that read nothing says NOT checked, exit 2 (Inbox HANDBACK-2026-09-27-hardening) | DONE throughout: kg1sc, dr1ck, sk1in, librejs-check all exit 2 and say NOT CHECKED when they cannot look |
| A14 | 09-24 | "We need, like lots of 'write some sentences work' ... LIST of MEANING" (c4 q/2026-09-24-users-pick-ceremonies/PROMPT-2.md) | DONE in part: the game's sn1dr asks a model for sentences anchored to dictionary meanings and keeps only what passes; the score moved 23 to 24 of 272 |
| A15 | 09-19 | whose-tests, the as-of gauge, the unread refusal (c4 h/DESIGN-2026-09-19-*) | MULCH: the kid glove's "tests" topic and sk1in's dated-version check are their cousins |

## B. Bryant's drop (BRYANT-INFLUENCER.md public r2, 2026-09-26, in H:\ta imports)

| # | offer | verdict |
|---|---|---|
| B1 | 2.3 skill-integrity gate | DONE: sk1in.  First run over our 71 skills: 0 RED (candor-gate's "sentinel:" ending recognised as closed); principles and token-optimizer read CHANGED against their in-tree .skill-manifest though their dist bundles match; 65 carry no dated version note.  SEED: his footer form ("*Version X: ... on DATE*") satisfies that check, so adding footers at the next re-sign clears it (his call; 65 signed files) |
| B2 | 2.1 the map of the house, with its yield rule | DONE: the kid glove's order quotes it.  SEED: garden-usage could carry the yield line too |
| B3 | 2.6 ground-truth, "honest versions" | SEED: a sk1in check 6, version strings that disagree inside one file |
| B4 | 2.7 consent-gate design inputs ("for every gate to adoption the amount of adoption goes down") | DONE: the kid glove gates only the irreversible; its ledger is the audit trail |
| B5 | 2.2 the sw1ng repro as a pre-build gate | SEED, and it meets an open item of ours: c4's sw1ng-tests.sh is stale against bin/sw1ng.  Run his four probes at Avalon next |
| B6 | 2.5 primer and onefile.sh, share copies that prove themselves | SEED: a recipe already unfolds and checks itself; a primer-style single file of a recipe would travel to TN and prove itself there |
| B7 | 2.4 the wire as T8 transport; Corwin's garden as third witness | into the ghostwheel rollout model (next rounds) |
| B8 | tier 2: wire-reconcile (journal against ledger at boot and session end); local models for the ai-matrix; git-wire; sandboxer v2 | SEED for drift 0.2: `--wire LEDGER` as a fourth cross-check, the page against the wire's journal |
| B9 | tier 3: survivability; no pay-gate; ownership follows authorship | MULCH into principles; already ours in substance |
| B10 | 09-29 drops (particle simulator, quantum chess, tarot): single-file JavaScript apps | SEED to offer back: the LibreJS labels the kid glove now checks for (our own pages got them today) |

## C. The card

| # | line | verdict |
|---|---|---|
| C1 | GNU Coding Standards | DONE as the kit's flagship layer: ChangeLog, NEWS, standard targets, check |
| C2 | Kindness Conventions | DONE as a pointer (GNU Kind Communications Guidelines) beside the considerate-reader soft skill |
| C3 | Convention of Terms | DONE as a pointer (GNU's Words to Avoid) beside GRAMMARY.md.  SEED: a check of our own prose against it (ours only: the kid glove never imposes it on a house) |
| C4 | LibreJS | DONE where it was a gap in our own house: mini-c4-game's page (with tests/librejs-check.sh, prove-red) and egad's hello.js carry licence labels.  Magnet link checked against GNU's page today |
| C5 | ScanCode Toolkit | SEED: not installed here; the kit points at it and at reuse lint.  NOT CHECKED until one runs |
| C6 | OWN: anti-secrets, precedence checks | anti-secrets were ours already (sb1rn, sb1aw, sb1pl); precedence is the kid glove (DONE) |
| C7 | SKILL + tools + RECIPE, unfold style | DONE twice (kid-glove, drift), with egad's egadjit as the elder.  The shared unfold-check takes any recipe.  SEED: move a skill of ours to a recipe whenever it is next touched, one at a time |

## Decompose or not

- Decomposed and recomposed: the kid glove gathers what lived spread across candor-gate (the
  receiver's door), consent-gate (gates for the irreversible), garden-usage (finding what fits) and
  Bryant's map of the house, as one skill whose only job is to come second.
- Recomposed from seeds: drift, from DRIFT.log, drift.sh, the checkpoint line and his "drift report".
- Kept whole: sk1in is Bryant's five checks as he gave them, plus one recognised ending.
- Not decomposed: the persona shelf; it is a staging of what exists (F:\claude\projects\persona-shelf,
  DRAFT, per-row approval).

## Not found

- The comic-book view of transcripts (chapters by prompt, arcs interwoven).  Not in c4/site,
  AS4CE0001/site, book/ or journal/ by name or by "comic"; the only "comic" hits are the comic.chat
  project in the project browser.  Where does it live?

*Version 0.1: 2026-10-04; spine: 2026-10-04.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4: https://creativecommons.org/licenses/by-sa/4.0/; Mentat (for Corwin; claude-opus-5-5)
