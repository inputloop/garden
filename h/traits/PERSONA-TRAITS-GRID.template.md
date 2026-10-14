# Persona Traits Grid — a roll-for-persona reference (144 sourced traits, 6×6 tables, dice)

> **Author.** Corwin Brust &lt;corwin@bru.st&gt;, with lab partners **Bryant Frankford** and
> **Bridget** (credits below). **License.** CC BY 4.0 (or any later version at the bearer's
> option). **Version.** 1.0.0 · minted 2026-09-06 · the first deep revision pass of the `news/`
> methods. **Built by** `h/pg1rl --build` from `PERSONA-TRAITS.tsv` (the record) and the Roll for
> Bias 1.0.90 news table (signed); the tables below are generated, the prose is written.
> **Marked:** *for fiction or analysis — no ship dates or licensing or publication dates
> specifically defined.*

<!-- C4:pg1rl-spec v1 canonical=this-file record=PERSONA-TRAITS.tsv sources=PERSONA-TRAITS-SOURCES.md tool=AS4CE0001/h/pg1rl -->

<!-- C4:section id=instructions tab="How to play" -->
## How to play (the short form)

You are at a table with two six-sided dice, this document, and a persona to build — for a story,
or for an AI that will help keep some complicated technology running. The first die is always the
**row**, the second is always the **column**.

1. **Roll on the INDEX.** A numbered cell (1–24) sends you to that trait table. The two diagonal
   stripes are special: **doubles** (1-1 … 6-6) is the **BIAS** stripe — roll the news-bias
   generator once (you get a *source* and a *fate* word: villain · badguy · malcontent ·
   ne'er-do-well) and then roll the index again; **sevens** (1-6 … 6-1) is the **INTERSECTION**
   stripe — roll the index twice more (numbered cells only; a stripe just re-rolls) and take *both*
   traits as a pair the persona has to reconcile. A high-first seven (6-1, 5-2, 4-3) is a high-stakes intersection; a low-first seven
   (1-6, 2-5, 3-4) is low-stakes.
2. **Roll on the trait table you landed in.** The row is the trait; the column is the *level* of
   expression, from L1 (faint) to L6 (extreme). The cell holds the words.
3. **Doubles and sevens bump.** On a trait table, **doubles** move you to a neighbouring trait in
   the same table: high doubles (4-4, 5-5, 6-6) go to the *next* row one level *up* (amp — stakes
   rise); low doubles (1-1, 2-2, 3-3) go to the *previous* row one level *down* (damp). **6-6
   escalates**: after the bump, roll again on the next-deeper table of the same domain (depth 4
   sends you back to the index) — this is the high-intensity intersections idea ("oh, high doubles
   on the enthusiasm table, roll again and watch out for low doubles"). **Sevens** stay on the
   trait but change its weight: high-first (4-3, 5-2, 6-1) → level +1 and the trait is
   **load-bearing** (it will be tested); low-first (3-4, 2-5, 1-6) → level −1 and the trait is
   **background**.
4. **Repeat** for as many traits as the persona needs — **4** for a tiny sketch, **9** for a short
   work, **17** for a long one (the house's own numbers). Write each result as a line on the
   character sheet, keep the dice in the margin, and never re-roll a roll you already have.
5. **Want pure chance instead?** Use the **JUMBLED** twin: the same 36 cells per table, shuffled
   by a printed seed, no stripes, no bumps — a totally randomized selection with none of the
   good-roll / bad-roll affinity above.

**With the tool:** `python3 h/pg1rl --roll PERSONA-TRAITS-GRID.md --seed 20260906 --traits 9`
prints the whole trace (every die, every bump, every colour); `--html` draws the grid of grids on
graph paper with a live roller and highlighter. The seed is always printed so a reader can re-roll
the same persona.

**Highlighter (the table convention):** when we view these tables playing dungeon we mark the
interesting cell with highlighter on graph paper — **pink = scary**, **blue = chill**, **green =
hip**, **yellow = worrisome**, and sometimes **purple = wild**. The tool uses the same five:
pink for amped bumps, villains and escalations; blue for damped bumps; green for a clean hit in
the moderate middle; yellow for sevens and the extreme columns; purple for the index stripes.
<!-- C4:end -->

<!-- C4:section id=design tab="Design" -->
## Design — why the tables look like this

**A grid of grids.** Twenty-four trait tables, arranged **four across and six down**: each of the
six rows of the big grid is a *domain* of human behaviour, and the four tables in that row go
progressively deeper into it. Each small table is 6×6 = **six traits × six levels**, so 24 × 6 =
**144 traits**, which between them are meant to give a good sense of the range of human
behaviour — not a personality test, a **wheel or ball of persona** in which neighbours share
synergy or vocabulary. The `neighbors` column of the record names each trait's nearest
neighbours across the whole ball, which is how you walk from one table to the next by hand.

| domain (row of the big grid) | depth 1 | depth 2 | depth 3 | depth 4 |
|---|---|---|---|---|
| **A · Temperament & energy** — how the engine runs | 1 Activity & drive | 2 Sociability & expression | 3 Emotional reactivity | 4 Positive affect & resilience |
| **B · Mind & openness** — how one thinks | 5 Curiosity | 6 Cognitive style | 7 Creativity & unconventionality | 8 Wisdom |
| **C · Will & work** — how one acts | 9 Conscientiousness core | 10 Self-regulation | 11 Agency & drive | 12 Risk & sensation |
| **D · Heart & others** — how one relates | 13 Warmth & compassion | 14 Trust & cooperation | 15 Social bonding | 16 Interpersonal stance |
| **E · Self & shadow** — how one holds oneself, and the dark side | 17 Identity | 18 Dark traits | 19 Integrity & honesty | 20 Regulation of self |
| **F · Values & world** — what one is for | 21 Personal-focus values | 22 Social-focus values | 23 Moral foundations & justice | 24 Vocation & interests |

**Where the traits come from.** Every trait carries **at least three formal sources** (a
validated instrument, a peer-reviewed study or a meta-analysis — at least one specific to that
trait) plus **one or two flair sources** (a magazine, a popular book, a well-known blog) for
contrast. The taxonomies leaned on: the NEO-PI-R and HEXACO facets, the VIA character strengths,
Cloninger's TCI, Kashdan's five-dimensional curiosity, the interpersonal circumplex, Zuckerman's
sensation seeking, Duckworth's grit, the Dark Triad/Tetrad, HEXACO Honesty-Humility, Schwartz's
refined values, the Moral Foundations Questionnaire, Holland's RIASEC, and the standard scales for
self-esteem, self-efficacy, self-compassion, locus of control, emotion regulation and mindfulness.
Each source was checked by **two readers** — the PubMed index and a second route (a DOI resolver,
a publisher page, or a web search) — and is marked VERIFIED-2, VERIFIED-1 or UNVERIFIED in the
record; nothing was typed from memory. The full bibliography is `PERSONA-TRAITS-SOURCES.md`.

**Levels, not scores.** The six columns are *expressions*, written as words a writer can use,
from the faintest (L1) to the most extreme (L6). L3–L4 are the moderate middle. These words are
judgements (the assembler's and the six research readers'), and they say so in the record's
`notes`; the sources are observations. A level word never claims to be a clinical cut-point, and
the dark-traits table describes dispositions, not diagnoses.

**The stripes.** The index table has 36 cells; the twelve on the two diagonals (doubles, sevens)
are stripes, so exactly 24 numbered cells remain — one per table. The stripes carry the two
things a flat lookup cannot: the **news-bias generator** (variance the plausible middle will not
produce on its own — the fate dice from LENS persona seeds §3(d)) and **intersections** (two traits
that must be reconciled, which is where a persona stops being a list).

**The jumbled twin** exists so that the affinity built into the straight tables (rows ordered by
synergy, columns by intensity, diagonals as bumps) can be switched *off* on purpose — the same
move as Roll for Bias's randomized matrix: the ordered grid encodes the judgement; the shuffled
grid hands you the same items with the ranking stripped.
<!-- C4:end -->

<!-- C4:section id=rules tab="The rules (exact)" -->
## The rules, exactly as the tool applies them

| where | dice | result |
|---|---|---|
| INDEX | numbered cell | go to that table |
| INDEX | doubles (BIAS stripe) | roll the news-bias generator (source + fate), then roll the index again |
| INDEX | seven (X stripe) | roll the index twice more — numbered cells only, a stripe re-rolls — and both results form an intersection; first die ≥4 = high-stakes, ≤3 = low-stakes |
| TABLE | ordinary | trait = row, level = column |
| TABLE | high doubles 4-4 5-5 6-6 | next trait row (wrapping 6→1), level = first die + 1 (max 6); stakes *amped*; **6-6 also rolls again on the next-deeper table of the same domain** (depth 4 → the index) |
| TABLE | low doubles 1-1 2-2 3-3 | previous trait row (wrapping 1→6), level = first die − 1 (min 1); stakes *damped* |
| TABLE | high-first seven 4-3 5-2 6-1 | same trait, level +1 (max 6); *load-bearing* |
| TABLE | low-first seven 3-4 2-5 1-6 | same trait, level −1 (min 1); *background* |
| TABLE | column 1 or 6 (no stripe) | ordinary, marked *worrisome* (an extreme) |
| NEWS | 2d6 on the randomized matrix | a source number → the item list; then 2d6 for fate: double six or double one = villain; other doubles or a 3 = badguy; 7 = malcontent; else ne'er-do-well |
| JUMBLED | 2d6 | the cell, no bumps, no stripes; the tool picks the table with a d24 |

Colours: pink = amped / villain / escalation · blue = damped · green = clean hit · yellow = sevens and
extremes · purple = index stripes and the milder fates. Levels always clamp to 1..6. Nothing here is
asserted by a model: the dice are a seeded RNG and the seed is printed with every roll.
<!-- C4:end -->

<!-- C4:section id=method tab="Method & lineage" -->
## Method and lineage

This grid is the `news/` methods applied to themselves for the first time at depth:

- **Roll for Bias** (`METHOD-roll-for-bias.md`, 1.0.91; the signed 1.0.90 agent artifact) gave the
  shape: fold to the extremes and the baseline, order it, then strip the order. The news-bias
  generator here is its 1.0.90 execution carried forward *as it was* — 36 sources, ordered and
  randomized — with one change to fit forward: the fate dice ride with it, so a bias roll also
  hands the persona a fate. **Clarification of 2026-09-06 (his):** the ordered table is evenly split
  between the highly biased (toward the beginning, low indexes) and the moderate (toward the end,
  the high indexes and the lower right) — one monotone run of |bias| from cell (1,1) to (6,6).
  The reference implementation `h/rf1bm` v1.2 sorts that way.
- **LENS persona seeds** (`METHOD-lens-persona-seeds.md`, 1.0.92) gave the fate table and, in
  §3(e), the bad-guy roll for system actors: an actor that is more IRL than not takes its one
  kept roll as a bad-guy perspective and then one more lens stage that inverts it. A persona built
  from this grid for a system actor still owes that stage.
- **Dungeon modelling** (`METHOD-dungeon-modeling.md`) gave the table itself: characters as
  inventories and attributes; the record is TSV, double-entry (every row names its source); a
  persona rolled here lands on a character sheet with a bench, holdings, gold and specialness.
- **Context stacking** gave the sizes — 4, 9, 17 — and the idea that a load-bearing trait gathers
  mass the longer it sits untested.
- **Persona affixing (his, 2026-09-06):** persona affixes — sometimes, not guaranteed — at a
  *feature plane*, as soon as a feature is used twice; not while building and testing locally.
  Every character sheet that grows from a roll here opens with a **founding journal entry** that
  tells exactly how the persona happened. Two voices in this house (Vibrobeast, the shop's
  internal voice and curator outward; Mentat, the continuity voice that works memory as a fabric)
  grew before this engine existed and are kept as *pre-engine* voices, deliberately, until C4 can
  reintroduce them in context.

**What to revise next** (named, not buried): the level words are judgements and should be read
against each cited scale's anchor items; four traits are flagged contested in the record (Loyalty,
Kindness, Tolerance, Gentleness — value-shaped or thinly scaled); three exact duplicates across
columns were resolved by the assembler (Competitiveness → Need for Achievement in C3; Self-Efficacy
→ Work Ethic in C3; Modesty → Deference in D4) and say so in `notes`; the parity reading of the
fate short-list (even → first option) is the assembler's guess at "even/odd"; the WebSearch budget
ran out mid-pass, so the second reader for later columns was the DOI registry rather than a search.
<!-- C4:end -->

<!-- C4:section id=credits tab="Credits & license" -->
## Credits and license

**Corwin Brust** &lt;corwin@bru.st&gt; — author; the methods, the framing, the rules of the table.
**Bryant Frankford** — lab partner and co-author (confirmed 2026-06-29); ghostwheel provenance.
**Bridget** — lab partner and co-author (confirmed 2026-09-06 by her formal "as for credits"
declaration, relayed by Corwin; credited by first name until she names the rest herself).
**Assisted-by:** Claude (Mentat/Vibrobeast) — assembly, tooling, and six research readers; Gemini
(Roll for Bias 1.0.50–1.0.90).

Credit at the idea, not just the masthead (`AUTHORS.md`). The sources in the bibliography are
credited to their authors and are cited, not reproduced. The grid is **CC BY 4.0** (or, at the
bearer's option, any later version); the tool `h/pg1rl` is **GPLv3-or-later**.

*Marked: for fiction or analysis — no ship dates or licensing or publication dates specifically
defined.*
<!-- C4:end -->

---

## The tables

*Generated by `h/pg1rl --build` from `PERSONA-TRAITS.tsv`. Do not hand-edit between the markers;
edit the record and rebuild. Row = first die (the trait), column = second die (the level).*

<!-- C4:generated -->

---

## Sources

The bibliography — every source for every trait, with its verification state and the two readers
that checked it — is `PERSONA-TRAITS-SOURCES.md` beside this file (generated from the record). The
record itself, `PERSONA-TRAITS.tsv`, carries per trait: definition, poles, the six level words,
neighbours, taxonomy, three formal sources, up to two flair sources, the routes run, and notes.

---

*Corwin Brust &lt;corwin@bru.st&gt; · lab partners Bryant Frankford and Bridget · CC-BY4 (or, at the
bearer's option, any later version of that license) · Assisted-by: Claude (Mentat/Vibrobeast), Gemini*
