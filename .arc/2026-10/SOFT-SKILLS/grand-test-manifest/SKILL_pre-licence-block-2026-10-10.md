---
name: grand-test-manifest
description: >
  Write, read and trust a TEST MANIFEST, the numbered list of a work's promises keyed by NAME,
  where every check is run twice: on the real work (HELD or BROKE) and on a copy with one planted
  fault (FIRED or SURVIVED). STATE is computed from the receipts, never typed. Levels PKG
  (fast-fail), SMOKE, HARNESS and CARP (a named other reader carps or blesses). Steps GRAIN, GREAT
  and GRAND say which slots a build owes. Most builds owe none: a manifest is owed only when a
  problem class has recurred across two works or tools, a check was caught passing over a real
  fault, or the keeper says so. Use on "test manifest", "grand test manifest", "is this check
  blind", "plant a fault", "what is STATE", "does this build owe a manifest", "raise the testing",
  "ratchet". The repeatable act of raising one is the ratchet spell (c4 spells/ratchet/); the reader
  is c4 bin/as1te. Electable. Provisional until his rulings (banked Q534-Q542).
---

# grand-test-manifest: promises by name, each check shown able to fail

**Status:** PROVISIONAL, landed 2026-09-28 on his asking ("this could be a soft-skill with a SPELL that
works ENHANCE opportunities"). The readings of CARP, 2x, the step names and the slot words are the
design's picks, banked for his ruling as Q534-Q542 in c4 `evidence/question-bank-iTNH.tsv`; where he
rules otherwise, this file changes. Design and LENS: c4 `h/DESIGN-2026-09-28-grand-test-manifest.md`,
`h/LENS-2026-09-28-grand-test-manifest.md`. His card and words: c4 `q/2026-09-28-grand-test-manifest/PROMPT.md`.

**Where it lives:** the reader `bin/as1te` (`as1te state FILE [--owed STEP] [--json]`, `--prove-red`) and
its twin reader in awk, `tests/as1te-spec.sh` (the two must print the same join); the kind and the
form, rows TESTMANIFEST in c4 `c/kinds` and `c/wf` (`sh bin/mf4st TESTMANIFEST` lists them); the spell,
c4 `spells/ratchet/`; the worked example, c4 `showroom/views/spellball/TESTMANIFEST-2026-09-28-spell-ball.md`.

A QA plan says what must hold. A manifest adds how we know each check could have failed. It keys
each promise by NAME rather than by row number, so STATE is an array of named scalars (`keyboard =
OPEN`), a lookup by name is one hop, and the same name in two works is visible as a recurring check.
His words (2026-09-28): "MANIFEST as the ARRAY of SCALAR implied by inverting the INDEX -> NAME list
implicit in having a numbered set."

## Choosing it, and declining it

Choosing it is optional. Once a build owes a manifest, every owed slot is written or declined with
a reason. Most builds owe none. To decline: write `manifest: none owed` in the QA plan.

## When a build owes one (the ratchet)

- **T1:** a problem class has two dated receipts from two different works or tools.
- **T2:** one receipt of a check that passed while the fault was there.
- **T3:** the keeper says so.

The step owed:
- bytes wrong, missing or stale → **GRAIN** (PKG, SMOKE)
- a promise broke in use, or a check was blind → **GREAT** (+ HARNESS; each item owes `logic-1` and `prose-1`)
- only another reader caught it → **GRAND** (+ CARP; each item owes two logic checks written apart and two prose checks)

A third receipt raises it one step. Lowering is never taken, only asked for.

## The file

It lives beside the work as `TESTMANIFEST-<date opened>-<slug>.md`, with its receipts in `receipts/`, and receipts are never overwritten.

- **Header:** `key: value` lines (`as-of`, `work`, `qaplan`, `owed`, `why-owed`, `receipts`).
- **`## Levels` and `## Items`:** numbered lines, `N. name · …`.
- **Slots:** `check:` for a level; `logic-1:`, `logic-2:`, `prose-1:`, `prose-2:` for an item.
- **Under each slot, two lines:**

```
     real: HELD | BROKE | NOT RUN | DECLINED (why) · run | quoted · receipt
     plant: <fault, in a copy> → FIRED | SURVIVED | EQUIVALENT because … | NOT RUN · run | quoted · receipt
```

A plant is always made on a copy in `$TMPDIR`, never on the work.

## STATE

| slot | when | GNU / TAP word |
|---|---|---|
| PROVEN | HELD and FIRED | PASS, mutant killed |
| RED | BROKE | FAIL |
| BLIND | SURVIVED | XPASS |
| OWED | owed and `none` | UNTESTED |
| NOT-RUN | not run, or after a PKG fast-fail | UNRESOLVED, "Bail out!" |
| OPEN | passes, never shown able to fail | PASS, no mutant |
| DECLINED | with a reason | UNSUPPORTED, SKIP (77) |

- **EQUIVALENT** counts as PROVEN only with its reason and a sibling plant that FIRED.
- **Item scalar:** an item's scalar is its worst slot.
- **The join:** the first of RED, BLIND, OWED, NOT-RUN, OPEN that is present; otherwise GREEN. It always carries its counts and how many PROVEN slots were quoted rather than run.
- **Fast-fail:** only PKG stops the run. Every other level runs even after a failure.
- **Missing receipts:** a missing plant receipt makes the slot OPEN, because losing rounds deleted make a result unfalsifiable.

`as1te state FILE [--owed STEP]` prints it; paste it between `<!-- STATE -->` markers.

## With build-loop

The QA plan names the manifest (or `none owed`) and each item's swing-dome rung. Each pass runs
it; RED and BLIND are issues, OWED and OPEN warnings, for `sw1ng qa`. A clean pass needs GREEN.
In the final swing, PROVEN slots are the regression set.

## With the other skills he named

- **build-loop.** Above. The swing-dome rung of each item is the build loop's rung; the landing rules
  (write before show, sources land, evidence kept by pass, hash every commit) are what keep a manifest's
  receipts real.
- **writing-forms.** TESTMANIFEST is a row in `c/wf`, the register writing-forms names as its source of
  truth, so writing-forms finds the form without a change to the skill itself. It pairs with QAPLAN:
  the plan cites the manifest in one line; the manifest cites plan rows by number.
- **skilltank.** A test-shaped recurrence routes as RAISE (the manifests of the works that touch the
  class go up a step), beside NEW / ENHANCE / LEAVE-AS-MEMORY / HOLD. The same check name sitting in two
  works' manifests leans the verdict to a shared tool. skilltank itself is a signed plugin skill and is
  not edited here: the RAISE line is proposed as `AS4CE0001/ERRATA` E14.
- **mentat.** One MEMORY.md line, and only then, when a step is raised, a check is found BLIND, or an
  EQUIVALENT is accepted; every number in it from a command run that day. STATE itself never goes to
  memory: it is derived, and a copy would go stale.

## How this skill can fail (falsifiers)

- **A GREEN over a failing receipt:** `as1te` prints GREEN while a receipt shows a failure. `as1te --prove-red` must end PROVE-RED OK, and a second-language reader must agree.
- **Owed with no trigger:** a manifest is written for a build that met no trigger, and nobody reads it. The QA pass line names no STATE print.
- **A raise that did nothing:** a class raised by T1 recurs while its item reads PROVEN. The plant did not model the failure.
- **Plants on the work:** a plant was made on the work rather than on a copy. The work's sha256 changed during a run.
- **Drift from the QA plan:** a QA plan row is named by no item and not marked "is not an item".

Off-switch: write `manifest: none owed`, or remove this folder.

## LENS (six lines, carried)

```
LENS · grand-test-manifest · 2026-09-28
a  my view:            per-promise proof that a check can fail; the risk is paperwork
b  the view I ascribe: formality rises only where trouble repeats and crosses contexts
c  their pull on mine: toward a skill + spell + form + tool rather than one QAPLAN section
d  my pull on theirs:  the readings of CARP, 2x, GRAND and the state words are mine until ruled
persona / inverse:     PENUMBRA keeps every plant and run / the inverse: most builds owe none; STATE is derived
principles reframe:    plain words anyone reads; a falsifier lets anyone study the check; GNU words
```

---
Copyright (C) 2026 Corwin Brust <corwin@bru.st>.
SPDX-License-Identifier: GPL-3.0-or-later.

<!-- footer: minted by bin/ft1mt from conventions/house.env and conventions/FOOTERS.org; edit those, not this -->
*Version 1.0.1: edition revised from 1.0.0 on 2026-10-04; spine: 2026-09-28.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4: https://creativecommons.org/licenses/by-sa/4.0/ (scripts GPL-3.0-or-later); Mentat (for Corwin; claude-opus-5-5)
<!-- /footer -->
