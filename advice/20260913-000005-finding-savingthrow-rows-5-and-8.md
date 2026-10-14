# FINDING — two rows of the dungeon-mode saving-throw table double-count

*Opus 5, 2026-09-13, found while writing Book 2 against the real table. This is a carry-back to
`dungeon`, not a book note. Marked: for analysis.*

**Where.** `H:\arc\from\CCC4_G401\dungeon\Docs\Tables\Savingthrow.org`, "Saving Throws by level",
dated 2020-01-11, GPLv3-or-later. **Attribution, stated as the bytes state it and not further:** the
file's property drawer reads `:Author: Erik C Elmshauser`; the copyright line above it names Corwin
Brust, Erik C. Elmshauser, Jon Lincicum and Hope Christiansen. Those are two different lists. I have one
source for the first and it is a field somebody typed — Corwin's own account is that the work divides
less cleanly than a header suggests, so this note claims nothing beyond what is printed in the file.

**What.** Two of the nineteen rows state odds that do not match their own stated pattern.

| Rung | Pattern as written | Table says | Counted | Δ |
|---|---|---|---|---|
| 5 | Avoid Doubles, 7, 8 | 19/36 | **20/36** | +1 |
| 8 | Avoid Doubles, 6, 7, 8 | 14/36 | **16/36** | +2 |

**Why, exactly.** Both rows sum the sizes of the named sets and subtract from 36, without removing the
outcomes that belong to two sets at once.

- Rung 5: `|D| + |7| + |8| = 6 + 6 + 5 = 17`, so `36 − 17 = 19`. But `(4,4)` is both a double and an
  eight, so the true union is 16 and the answer is 20.
- Rung 8: `|D| + |6| + |7| + |8| = 6 + 5 + 6 + 5 = 22`, so `36 − 22 = 14`. But `(3,3)` is a double and a
  six, and `(4,4)` is a double and an eight, so the true union is 20 and the answer is 16.

**Why only these two.** Every other row that names sums names *odd* ones — 7, 9, 11 — and an odd sum can
never be a double. The slip can only bite where an even sum meets the doubles, and exactly two rows in
nineteen do that. Seventeen of nineteen recompute exactly.

**The consequence, and it is small.** With the counted values the ladder reads
24, 20, 18, 16, **16**, 12 across rungs 4–9 — monotone non-increasing, with one flat step where rungs 7
and 8 now tie. The source's numbers were strictly decreasing, which is presumably why the slip survived:
the wrong numbers looked better.

**How it was found.** `h/gb1md --lint` enumerates all 36 outcomes for every odds claim a book makes.
Book 2 quoted the table verbatim; the tool refused two rows. The receipt is the lint output and the
enumeration script in this session's transcript.

**Does it matter to the code?** `src/dm-save.el` computes probabilities from the pattern grammar rather
than reading this table's odds column, and its own tests enumerate the 36-space — so the *implementation*
is almost certainly right and only the printed prose column is wrong. That is worth confirming before
anyone edits anything: **the check is to run the elisp probability function over the rung-5 and rung-8
patterns and see whether it returns 20/36 and 16/36.** If it does, the fix is two numbers in one `.org`
file and nothing else.

**What Book 2 did about it.** Printed the counted numbers, starred both rows, explained the mechanism in
the author's voice, credited Erik Elmshauser by name for the table, and explicitly declined to break the
new 7/8 tie on the grounds that it is the table-keeper's call and not a guest's.

**Fork for Corwin.** Whether to correct the two rows in `dungeon`, and whether to break the tie at rungs
7 and 8 (rung 8's pattern could drop the six, giving `avd D+7+8` = 20 — no, that collides with rung 5;
or drop the eight, giving `avd D+6+7` = 19, which restores a strict fall). I have not touched the
project. This file is the whole of my involvement.
