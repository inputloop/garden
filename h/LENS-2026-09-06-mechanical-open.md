# LENS 2026-09-06 — the mechanical open (nine columns × two rows × two stances) — the ledger
*Marked (NEWS): for fiction or analysis — no ship dates or licensing or publication dates specifically defined.*
Companion to `h/MODEL-2026-09-06-memory-mechanical-session.md` §5. Readers: `h/lens-2026-09-06/idea-1..9.md`.
Minions ×2 in the session (script + judgment). Eclipse: `.eclipse-increments/2026-09-06-mechanical-open/`.

## The method deviation, named (the reason this ledger exists)

The rack was drawn by **`random.sample(population, 36)` then `random.sample(36, 9)`** and coloured by a
fate table I invented ("tired"). The method (`modelthisbook/news/METHOD-roll-for-bias.md` v1.0.91) says:
fold to 36 as **half extremes + half neutrals of a named metric**, an ordered 6×6, a randomized 6×6 (the
load-bearing de-ordering), an indexed output, a methodology note, and self-validation; and
`METHOD-lens-persona-seeds.md` says fate is **villain / badguy / malcontent / ne'er-do-well** (5+5, a
double, is *badguy*, not "tired"). Neither file carried the NEWS mark. The keeper caught it ("we aren't
quite aligned with gw7 and Mentat regarding work done already that more carefully/correctly applied the
program"). The tool `h/rf1bm` now does the method in code so the deviation cannot recur quietly.

## The corrected roll (rf1bm, same seed 20260906, metric "muss tolerance")

`LENS-2026-09-06-population.tsv` (100 items, scores = the instrument's guess, no research — said in the
methodology note) → `LENS-2026-09-06-roll-v2.json`. Picks in reading order of the randomized matrix:
a-color-blind-reader · a-reader-99 · a-person-who-loves-dashboards · game-designer ·
a-person-with-one-machine · windows-power-user · data-scientist · pair-note-taker ·
a-stranger-with-a-terminal. Fate dice 3+2 → **ne'er-do-well**.

## Drift (measured, not smoothed)

| | wrong roll (as run) | corrected roll |
|---|---|---|
| readers | enthusiast · terminal purist · poet · speed reader · curator · compliance officer · intern · security auditor · color-blind reader | the nine above |
| overlap | — | **1 of 9** (a-color-blind-reader) |
| metric lean | extreme-heavy: scores +5, +4, +2, +2, −1, −1, −2, −3, 0 → mean **+0.7**, 5 of 9 at \|score\| ≥ 2 | neutral-heavy: 8 of 9 at \|score\| ≤ 1, mean **+0.1** |
| fate | "tired" (invented) | ne'er-do-well (the method) |

**What the drift means for the verdict:** the readers who chose `se1sn` (minimum ceremony, dial 2) were
biased *toward* ceremony (compliance, audit, purism), so the design survived readers inclined against
it. That makes the verdict more robust, not less — but it was luck, not method. A rerun with the
corrected rack is a card (below), not a requirement.

## The rack as run (verdicts on the round question)

A1 HOLD · A2 HOLD→door line · A3 PASS · A4 PASS · B1 HOLD · B2 PASS · B3 PASS · B4 PASS narrowed · C1 HOLD.
Persona signal (all nine): reorder, no new trait — five asked for "shown = a receipt" before "cite inline".

## Cards
- **CARD 11 (optional):** rerun the nine columns with the corrected rack (`rf1bm … --pick 9`) and diff the
  verdicts; cost ≈ nine sub-agents. Worth it only if the fence falsifier (CARD 10) reopens the design.

## Addendum 2026-09-06 (late) — the fold ORDER was wrong too (roll v4)
His clarification: the bias table is evenly split, the highly biased at the beginning (low indexes) and the moderate at
the end — with METHOD's "(6,6) is the neutral baseline", one monotone run of |bias| from 1 to 36. `rf1bm` v1.0/1.1 sorted
by SIGNED score, so the extreme negatives sat after the neutrals. Fixed in v1.2 (`tests/rf1bm-tests.sh` 16/16); the roll
re-issued from the same seed as `h/LENS-2026-09-06-roll-v4-foldfix.json`: **dice unchanged (3+2)**, matrices unchanged,
**picks 1/9 overlap with v3** — the nine readers of the mechanical-open LENS were drawn from a mis-ordered fold. The LENS
verdict (se1sn) stands on the eclipse, not on which nine read it; a re-read by the v4 nine is a named fork, not done.
Kept: v1-wrong, v2, v3, v4 — nothing erased.
