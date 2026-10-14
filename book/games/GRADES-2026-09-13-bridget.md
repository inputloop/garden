# Bridget's grades on draft 1, and what they did to draft 3

*Human readers' group, received 2026-09-13. Her scale: **Voice** (does it sound like AI? is it consistent?),
**Clarity** (are instructions clear?), **Potential** (does it stoke further ideas?), each out of 5, plus a
letter. She graded **draft 1** — the versions parked and signed in
`../../.eclipse-increments/2026-09-13-books-draft-1/`, not the ones that were on the shelf when her
comments arrived.*

## What she said

| Book | Voice | Clarity | Potential | Letter |
|---|---|---|---|---|
| 1 · The Commons at the Table | 2 — *narrative vibe feels broken throughout* | 4 — *took me x2 passes* | 5 — wants the d20/5e mapping | **C** |
| 2 · Six Sides and a Pencil | 5 — *a loner who knows they are... no human talks like that* | 4 — *may actually give this a shot* | 5 — *what a fun solo game dungeon-diver* | **A** |
| 3 · The Flagged Book | 3 — *meh* | **1** — *multiple tables did NOT generate well about mid-document, very hard to follow* | 4 — likes the cut-out flags | **B** |
| 4 · Make It Out Alive | 5 — *clearly channeling someone who has played a LOT of TTRPGs* | 4 | 5 — *probably the most promising to use* | **A** |

## The disagreement, which is the finding

Henriette Solberg-Maas read the same four books and filed
`EDITORIAL-2026-09-13-second-read.md`. On two of four, the two reads do not agree — and where they
part, the human governs, because she is the one who could not follow the book.

| Book | The editor's grid said | Bridget said | Who was right |
|---|---|---|---|
| 1 | serves both readers | the worst of the four (C), voice broken | **Bridget.** The grid measured *coverage* — does it reach the gamer and the operator — and coverage is not readability. A book can address both audiences in a voice that holds neither. |
| 2 | a superb game with an operator footnote | A, best of the set | agreed |
| 3 | the sharpest operator thesis, unrunnable for gamers | B — and Clarity **1/5** | **Bridget, and on a different axis.** The editor judged the argument. The reader could not read the tables the argument is made of. |
| 4 | competent at both, thrilling at neither | A, *most promising to use* | **Bridget.** "Thrilling" was my editor's word and my editor's taste. The reader wanted usable, and said so. |

**The pattern.** My constructed editor graded *design*: coverage, thesis, ambition. The human reader
graded *encounter*: could she hear one person talking, could she follow the instructions, did it give
her an idea. Three of her four letters track the second thing, and my editor's grid was silent about it
on every book. A persona built to review can inherit the blind spot of whoever built it — and the
cheapest correction for that is a reader who is not in the building.

## What draft 3 changed, per book

**Book 1 — the voice.** She said the narrative vibe was broken *throughout*, and it was, in a way that
turned out to be countable rather than atmospheric: in draft 1 the book's only named person first
appeared at **line 430 of 552**, in one section of twenty-four. The narrative was not broken, it was
**pocketed** — promised by the framing, delivered once, near the end. Draft 3 carries Reya through
Parts one to five in five short beats, each using only the figures Part six already publishes (Reach 9,
Craft 14, Read 7, Weight 17, Standing 16, Footing 8, Price 4-3). She now appears in 6 of 26 sections
across 77% of the book. `bin/gb1md --thread` is the check, and it reproduces the original defect on the
draft she read.

Her Potential note asked for the d20 mapping, so draft 3 has a new **Part eight · Bolting this onto a
d20 game you already play** — three added numbers, a faction-mapping procedure, and an explicit
statement that it maps onto *procedure*, not onto anybody's setting content. That last is Vanth's own
argument from the licence essay, now doing work.

**Book 2 — nothing but the width.** Graded A. One 7-column grid split into halves, with three lines in
Pell's voice saying why and telling you to copy it back onto card.

**Book 3 — the tables, and what was hiding under them.** Four seven-column d66 grids, 147 to 193
characters wide, in a 130-line stretch: exactly "mid-document." All four are set in halves now and every
table in the book renders under 100 characters. Fixing the width made me read flag 6 properly, and flag
6 was **broken** — it ran *who* and *what debt* together in one grid, so a second die of 1 returned a
person instead of a debt. Six of thirty-six results were not results. The who is its own d6 list now
and six new debt entries complete the grid. The errata says all of this in Roux-Abara's voice, including
the part where the tooling had been warning about the width and the author decided the warning was
about a different edition.

**Book 4 — nothing but the width.** Graded A, and she called it the most promising. Two 7-column d66
grids halved; three lines from Ilunga saying so. Not one word of the prose was touched.

## What this cost the tools

Three checks, each bought by something a reader found by hand (Mentat's ninth mutation):

- `gb1md --render` — table width and, more to the point, **runs** of wide tables across sections, which
  is the shape Book 3 had and the other three did not. It prints counts and no verdict: with four
  graded books there is no honest way to validate a threshold.
- `gb1md --thread` — where a named person actually lives in a book, and whether they are pocketed.
- `gb1md` `kind=halved` — a 6×6 printed as two 6×3 halves is still one table and must still cover 1–6
  exactly once, so halving does not quietly drop the squareness guarantee.

And one correction to a check that already existed and was ignored: **the width warning had fired on
all four of Book 3's grids before they shipped.** Its wording named what the plain-text renderer does
about over-wide tables — degrade them to a complete keyed list — and said nothing about Markdown, which
is the format Bridget opened. It read as reassurance. It now names the format that breaks.

*The gap was never that no check existed. It was that the check was polite about the wrong file.*

---

*Author: Mentat (for Corwin) — witness to the four authors, not one of them.*
