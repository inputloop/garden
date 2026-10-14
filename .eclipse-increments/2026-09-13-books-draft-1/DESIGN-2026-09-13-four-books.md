# DESIGN + QA PLAN — four game books

*Opus 5, 2026-09-13. Design first, QA plan second, then build; three QA loops per book with
"last try then report" after the third; one redesign may be triggered after QA begins and it resets the
loop count. Cast: `h/books/CAST-2026-09-13.md`. Source archived: `h/books/.arc/2026-09-13-from-fable/`.
Marked: for fiction — no ship dates or licensing or publication dates specifically defined.*

---

## 1 · The programme

Four standalone books, four rules idioms, one subject: **you roll up somebody, and then you live with
what you rolled.** That subject is what makes a single set of books serve two audiences without
pandering to either.

The **game master** reads it as character generation with teeth — a person who arrives with traits they
did not choose and a fate they must play honestly.

The **systems operator** reads the same pages as something they already do badly: give a system a
described character, write down what it is *for* and what it must watch for in itself, and keep a
journal of how it drifted. That reading is never announced in the body. It is in the shape, and in the
back matter, where the authors are allowed to notice it.

Nobody should have to be told which reader they are. A rule that only works if you know it is a metaphor
is a broken rule.

## 2 · What is shared, and it is deliberately little

Three things only, because four books that share a fourth thing start to read as one book in four hats:

1. **The throw is honest and the book proves it.** Every odds claim in every book is checked against the
   enumeration by `h/gb1md --lint`, which knows Corwin's pattern grammar (`D`, `HD`, `LD`, `SE`, `BX`,
   a sum, `odd`/`even`, `+` union, `avd`). A wrong odds column FAULTs the build.
2. **You never re-roll what you got.** Taken from the house rule. Each book expresses it differently —
   Vanth calls it *standing by the deal*, Pell calls it *the pencil does not have an eraser end in this
   book*, Roux-Abara calls it *no take-backs, flag it and move on*, Ilunga does not call it anything
   because in his book the whole future rides on it.
3. **Back matter tells the truth in the author's own voice.** Each ends with the author's section, and
   they disagree. Solberg-Maas declined to make them match.

Everything else — dice, table shapes, page furniture, tone, even what a "character" is — is the
author's.

## 3 · The four designs

### Book 1 — *The Commons at the Table* (Kirra Vanth) — D&D-flavoured, math-led

**Dice.** Polyhedral, freely: d20 for the open throw, 3d6 for anything that should be shaped, d4 for
depth, d6 pairs where the pattern matters. Use whatever the maths wants; balance is the argument.

**Subject.** You roll a **faction** and the people in it, and play out who the rules belong to. Its
mechanical spine is *allegiance*: every character has a Side, and every Side can be left. The author's
own Loyalty trait is L1 — switches sides freely — and the game is built around the honest version of
that: defection is a legal move with a price, not a betrayal the rules punish.

**The maths that leads.** A d20 flat-open throw for allegiance tests (uniform: nothing is safe) against
a 3d6 shaped throw for competence (bell: people are mostly average). The contrast is the design — a
world where what you can do is predictable and where you stand is not. Level bands on 3d6 are
3–6 / 7–8 / 9–10 / 11–12 / 13–14 / 15–18, which is 9 / 17 / 24 / 24 / 17 / 9 percent, and the book prints
those percentages because the author would consider hiding them a small dishonesty.

**Shape.** Rules first and short; then the faction tables; then a worked defection played end to end with
the dice shown; then the licence, printed in full, because for this author the licence is part of the
game and she will say so.

### Book 2 — *Six Sides and a Pencil* (Oscar Pell) — strict dungeon

**Equipment.** Six-sided dice, quad-ruled paper, a pencil, this book. Nothing else, ever, including
colour vision. Two dice are convenient and the text never says you must have two — every rule is written
so that one die thrown twice is the same rule, because somebody at the table brought one die they like.

**The numbers you must remember: 4, 9, 17.** Corwin's own saving-throw ladder, the three anchors:

| you need | pattern | odds | the feel |
|---|---|---|---|
| level 4 | avoid doubles or seven | 24/36 | you usually make it |
| level 9 | doubles or seven | 12/36 | the honest middle |
| level 17 | boxcars | 1/36 | the miracle |

4 and 9 are exact complements — 24 + 12 = 36, the same pattern read from either side. That is the hinge
the whole book turns on, and it is checked by the tool, not asserted.

**Table shape.** Squares. 6×6, always, and blocks of squares that make a city. Reading is *down then
across*: the first die is the significant one. Within a square, intensity climbs from (1,1) toward (6,6),
and the trigger patterns thin as they climb — the wide union `D+7+9+11` down in the easy corner, then
`D+7`, then `D`, then `HD` alone at the top, which is the diminishing Corwin described and which his own
`dm-save.el` progression already implements and tests.

**Colour.** Used to draw the eye and never to say anything. Every colour in the book is redundant with a
mark you can feel or a word you can read. The author will not be moved on this.

**Shape.** Very short rules. Then squares. Then a solo procedure, because he plays alone.

### Book 3 — *The Flagged Book* (Delphine Roux-Abara) — GURPS-inspired

**Premise.** Everything is a table, tables make tables, and a table is whatever shape does its job — 6×6
when the dice are square, a ragged band table when the thing being described is ragged, a two-column
cross-reference when that is honest.

**The invention.** The index is a playable component. The book ships with **flags** — a page of them to
cut out, and a flag discipline — and the flags are numbered by *what you were doing when you needed the
table*, not by chapter. Her thesis: the hard part of a big system is finding the table again.

**The mechanical consequence.** Every table in the book carries a **flag number** and a **return**: where
you were when you came here and where to go next. A table without a return is a bug, and the lint checks
for it.

**Shape.** Front matter is a map of flags. Then the tables, grouped by moment-of-play. Then the tables
that make tables. Then a worked hour at a table with the flags in use.

### Book 4 — *Make It Out Alive* (Teo Ilunga) — SF

**Premise.** You do not roll a character. You roll a **future**, in terms, the way Traveller rolls a
life — and the future takes a survival roll at the end of every term. It can fail. It can die in
generation, before anyone plays in it, and the book teaches you to read the corpse.

**The three borrowed pieces, credited in the text.** The career-term lifepath with a survival roll comes
from Traveller, where character generation was the first RPG minigame and death before play was a real
outcome; the between-sessions **faction turn** that makes a world move without a GM improvising it comes
from *Stars Without Number*; and the escalating-stress dial he admires and deliberately did **not** take
is Mothership's panic engine, and the book says why.

**Hope as a mechanic.** Hope in the technical sense: not optimism, but counting pathways. A future's Hope
score is literally the number of distinct routes still open to its stated goal, recounted each term, and
it is the only stat that can be spent to buy a re-roll of a survival check — once, at the cost of one
pathway. A future with one pathway left cannot spend it.

**Shape.** Terms and the survival roll; the pathway count; the faction turn; three finished futures,
one of which died in generation and is printed anyway, autopsy included.

---

## 4 · Format and the honest limit

Authored in Markdown; rendered to plain text by `h/gb1md --txt` at 76 columns, ASCII only, tables drawn
with `+---+` rules. Both are tested (`tests/gb1md-tests.sh`, 22/22, `--prove-red`).

**I do not claim PDF.** I cannot produce one here and cannot check one, so the books do not promise a
format I have not rendered and read. A keeper with a Markdown-to-PDF path can use it; the books carry
nothing that needs one.

Print-readiness means what it can honestly mean at this stage: every table fits the column measure,
every rule box survives plain text, no rule depends on colour, and nothing on the page needs software
the reader does not have.

---

## 5 · QA PLAN — written before the first word of any book

Each book runs the loop. A loop is: **lint → read → fix**, and it ends when all six gates are green or
when three loops have passed, in which case the book gets one last try and then a report saying plainly
what is still wrong.

**G1 — the tool is green.** `gb1md --lint` FAULT count is zero. Mechanical.

**G2 — the arithmetic is real.** Every odds claim in the book is a `GB:claim` marker, so the enumeration
checks it. A probability stated in prose with no marker above it is a G2 failure even if the number is
right, because next revision it won't be.

**G3 — the two readers.** A game-master read and a systems-operator read, each done cold by a reader who
has not seen the design. GM asks: can four tired people run this at eleven at night from this book alone?
SysOp asks: if I wired what this book generates to something real, what would this book have failed to
warn me about? Both are Solberg-Maas's standing questions and she sits in on both.

**G4 — the equipment promise.** Whatever the book says you need on page one is the complete list, and no
rule anywhere needs more. For Book 2 this is the hard one and includes colour vision.

**G5 — the voice is the author's and is not mine.** Four books, four registers. The check is a cold
read of an unlabelled page from each: if a reader cannot tell them apart, the voices failed.

**G6 — the back matter is honest and is not a disclaimer.** The author's section says something true, in
character, that a disclaimer could not say. If it reads like legal text, it failed.

**Redesign rule.** One redesign may be triggered after QA has begun, and only one, and it resets the
loop count to zero. Triggering it costs nothing but honesty: the log records what broke and why the fix
had to be structural.

**The QA log** is `h/books/QA-2026-09-13-log.md` — one section per book per loop, verdicts before prose,
a receipt per verdict.
