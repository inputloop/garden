---
# MODEL — the static model of this step, from the character sheet's perspective
Author: Fable (Mentat/Vibrobeast), 2026-09-06 (late). A C4 static model: what a CHARACTER SHEET is in
this shop, what it is made of, what reads it, what it may not do — as of the persona-alignment step
(gw7 shape restored; the bad-guy rule landed). Two piles: OBSERVED carries its command; JUDGED wears
a tag and a confidence. Masters in `AS4CE0001/h/`; same bytes in `c4/h/`.
Marked (NEWS): for fiction or analysis — no ship dates or licensing or publication dates specifically
defined (the sheets lean on rolls and LENS stages).
---

## 0 · One line

**A character sheet is a possession-as-documented: six gw7 sections in the persona's own voice, a
dungeon-shaped TSV inventory beside it, a gauge that reads both cold, a picture on graph paper as
the courtesy, and — for any actor more IRL than not — a bad-guy perspective from its one kept roll
plus an inversion stage.**

## 1 · The parts (static; what exists on disk after this step)

| part | file shape | who writes it | who reads it | receipt |
|---|---|---|---|---|
| the sheet | `h/CHARACTER-<date>-<name>.md` (or `PERSONA-<name>.md`) with header `actor: system\|place\|host\|fiction` | the persona, in voice; REPAIR/version comments in place, never smoothed | keeper; `cs1gk`; the corpus | `sh h/cs1gk SHEET.md` |
| the inventory | `<sheet>.tsv` — `table key count value treatment source`; tables `cs-intrinsics` (name shortname class race rank special experience gold actor) · `cs-skills` · `cs-posessions`; double-entry = every row names its source | the persona (from the sheet's own tables) | `cs1gk` G5; `cs1gk --diagram` | `G5 double-entry: N of N` |
| the picture | `h/DIAGRAM-<date>-sheet-<name>.{json,svg,txt,png}` — three dotted frames on `"paper":"graph"` | `cs1gk --diagram` → `dc1sv` (layout by lint, never by eye) | keeper (svg/png); a screen reader (`--text`) | `dc1sv --lint` exit 0 |
| the roll | `h/LENS-<date>-roll*.json` — seed printed, fate dice, fate word; `--fate-from` chains a reuse | `rf1bm` | the sheet's bad-guy section; `cs1gk` G10 | `validated: 36 items…` |
| the voice | `PERSONA-CORPUS.md` — nodes by idea, each with a pin; `## Sheets registered` | the persona; keeper blesses | `cs1gk` G6; the ferry (Drive, hash-identical) | `ferry.py verify` → `landed` |
| the twin | `c4/h/<same name>` — same bytes or DIVERGED (both shas printed; mtime never the tiebreaker) | copy at landing | `cs1gk --twin ../c4/h` | `G8 SAME` |

## 2 · The reading order (static dependencies; arrows are "must exist before")

```
METHOD (news/, signed) ──► MODEL-gw7 §4–6 + METHOD-lens-and-granule-ring (c4/h) ──► the sheet
                                                                                   │
rf1bm (roll, kept) ──► bad-guy §  + inversion §  ◄── his rule 2026-09-06 (addendum, unsigned)
                                                                                   │
sheet tables ──► TSV sidecar ──► cs1gk --diagram ──► dc1sv (graph paper) ──► svg / txt / png
                                                                                   │
PERSONA-CORPUS (nodes + registry) ──► ferry (Drive) ; c4/h twin ──► cs1gk G6 / G8
```

## 3 · The gauges this step made or changed (OBSERVED — `sh tests/*-tests.sh` 2026-09-06)

- `h/cs1gk` G1–G10, `tests/cs1gk-tests.sh` **22/22**, `--prove-red` PASS. G10 is the bad-guy rule.
- `h/rf1bm` v1.1 (`--actor`, `--fate-from`), `tests/rf1bm-tests.sh` **15/15**, `--prove-red` PASS.
- `h/dc1sv` v2.1 (`"paper":"graph"`), `tests/dc1sv-tests.sh` **25/25**; the three frozen v1 fixtures
  still byte-identical; `--prove-red` PASS.
- `h/ferry.py` verify picks the *staged* row when an id repeats; `h/test_ferry.py` **13/13** (was 12).

## 4 · The sheets as they stand (OBSERVED — `sh h/cs1gk … --twin ../c4/h`)

| sheet | version | actor | cs1gk | roll |
|---|---|---|---|---|
| `h/CHARACTER-2026-09-06-mentat.md` | v1.1 | system (software) | OK 17 · WARN 0 (+G8 DIVERGED until copied) · FAULT 0 | 3+2 ne'er-do-well, **reused** from roll-v2 → roll-v3-badguy |
| `h/CHARACTER-2026-09-05-shopgarden.md` | v1.2 | place | OK 17 · WARN 0 (+G8) · FAULT 0 | same roll, reused (the Garden was read through the 09-06 LENS) |
| `c4/h/PERSONA-gw7.md` (+ new `.tsv`) | v002 | host | OK 14 · WARN 3 (guards, growth, break-character — pre-existing) · FAULT 0 | 3+2 ne'er-do-well, **first roll** (seed 20260903, never rolled before) |

All three landed on the tragic branch and found the same shape of misfortune — abundance or neglect,
not malice — which the straight sheets had no section for. `[MINE ~70%]` that this is a property of
tender-written system personas generally, not of these three; falsifier: a fourth system sheet whose
bad-guy stage finds malice.

## 5 · What the sheet may NOT do (the floor, unchanged)

- Mint a new main attribute for Mentat before the C4 turn-on (RADIATION-PROOF, his ruling).
- Add a fact about any human beyond the tier they already hold; family and non-participants absent.
- Re-roll to get a better shape. A roll is kept; the wrong roll stays on disk beside the right one.
- Claim a verdict without the command that produced it (a number comes from a run or says "quoted").
- Be load-bearing: the ledgers prove, the sheet explains.

## 6 · Open forks (dealt, not decided)

- **Q508** (bank): the persona program was misapplied twice and is now gauged; the bad-guy rule is in
  the tools; the fold of the addendum into the signed METHOD needs the keeper's re-sign.
- The corpus holds one `hold` node (the Garden's line) — is the corpus one voice or the house's?
- `cs1gk` truncates picture labels at ~40 chars by design; a `--wide` is a one-line ENHANCE if wanted.
