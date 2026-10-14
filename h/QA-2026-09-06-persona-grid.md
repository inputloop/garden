# QA — the persona traits grid + pg1rl (eclipse-lite: doubt-first, reward-first, converge)
Fable (Mentat/Vibrobeast), 2026-09-06. Two piles: OBSERVED carries its command; JUDGED wears a tag and a
confidence. Marked (NEWS): for fiction or analysis — no ship dates or licensing or publication dates
specifically defined.

## OBSERVED (commands run this session)
- `sh tests/pg1rl-tests.sh` → **19/19**; `--prove-red` → PASS (a planted "25 table(s)" expectation went red).
- `python3 h/pg1rl --lint modelthisbook/news/PERSONA-TRAITS-GRID.md` → 24 tables · 24 jumbled · 36 news ·
  index ok · 5 tabs · **OK**. Jumbled tables are proven permutations of the straight ones (lint checks it;
  a tampered cell FAULTs — tested).
- Record: 144 traits · 432 formal slots (VERIFIED-2 203 · VERIFIED-1 229 · UNVERIFIED 0) · 244 flair
  slots (VERIFIED-1 203 · UNVERIFIED 41) · 326 unique formal sources (`pg1rl --sources`).
- Sweep of 200 seeds × 4 traits (800 asked): bias stripe fired 173×, intersection 166×, escalation 26×,
  amped 84, damped 84, load-bearing 87, background 81; table rolls per persona mean 4.96 (min 4, max 8);
  **all 24 tables and all 144 traits reached**; levels flat (158–173 each).
- The JS roller in the viewer reproduces the rule words of `roll()`; run headless with node on seed
  20260906 it produced a legal trace (bias → news → table; intersection with re-rolls).
- Signed files verified BEFORE my edits (gpg, keeper's pinned key): METHOD-lens-persona-seeds 1.0.90,
  README 1.0.90, journal/README — Good; those three are now edited + archived → SIGN-QUEUE.

## DOUBT-FIRST (what would break it)
1. **The stripes are a third of the index.** A 4-trait persona averages ~1 bias and ~1 intersection
   event; short sketches will feel stripe-heavy. *Falsifier:* players report "too many detours" — the
   remedy is a house rule (stripes count only on the first index roll of a persona) which the tool can
   take as a flag in one line. `[MINE ~60%]` that the rate is right for 9- and 17-trait personas and
   high for 4.
2. **Near-duplicate traits across columns** (Warmth↔Compassion, Excitement↔Sensation Seeking,
   Endurance↔Grit, Sincerity↔Straightforwardness, ~15 pairs named by the readers). A persona can roll
   two near-twins. *Falsifier:* count twins in the 200-seed sweep (not done). *Remedy candidate:* the
   `neighbors` column already names them; a "twin = +1 level on the earlier trait" rule is one line.
3. **Level words are judgements**, not scale anchors; six different readers wrote them in six
   registers. *Falsifier:* read L1/L6 against each cited scale's anchor items (the F reader's own
   suggestion). Not done; named in the spec's Method tab.
4. **Two RNGs.** Python (`random.Random`) and the viewer (mulberry32) roll different dice for the same
   seed. Both print the seed and say which engine. *Falsifier:* someone expects parity — the trace
   header pre-empts it. A Mersenne port in JS is possible; not worth it today.
5. **The news list is 2025 US media, carried as-is** (his ask). It will age; it is signed provenance,
   not a claim about today.
6. **Fantasy/operational boundary.** The dark-traits table and the bad-guy fate are for fiction and
   analysis; if a persona built here is wired to a real system, the moral load inverts (README §The
   semaphore). The mark rides on every artifact; `cs1gk` still wants the bad-guy + inversion sections
   for system actors.

## REWARD-FIRST (what it buys)
- A **sourced** persona generator: every trait traceable to ≥3 formal sources by two readers — the
  first time the house's persona work has citations rather than vibes.
- The rules are **mechanical** and printed with every roll; the same seed re-rolls the same persona.
- The markdown is canonical and the tool reads it by C4 markers, so the spec can be hand-edited (prose)
  and rebuilt (tables) without the two drifting.
- The viewer puts the grid on graph paper with the table's own highlighter convention; a stranger can
  roll a persona without the sandbox.

## CONVERGENCE
Both biases agree on: the stripe rate and the twins are the two real design questions; both have
one-line remedies that should wait for play, not be pre-built. Verdict: **PASS WITH TWO NAMED FORKS**
(stripe rate; twin rule). Losers kept: none discarded — the alternative index designs (stripes as
"roll again" only; sevens as escalation instead of intersection) were not tried and are not claimed.
