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

<!-- C4:pg1rl v1.0 kind=grid tables=24 seed=20260906 -->

<!-- C4:table id=A1 n=1 domain=A depth=1 kind=traits name="Activity & drive" -->
#### Table 1 · A1 — Activity & drive (Temperament & energy)
| trait (row = first die) | L1 faint | L2 low | L3 moderate-low | L4 moderate-high | L5 high | L6 extreme |
|---|---|---|---|---|---|---|
| Activity Level | sedentary, stays put | slow-moving, low-key | steady, moderate doer | busy, likes motion | always on the go | hyperkinetic, cannot sit still |
| Pace/Tempo | glacial, deliberate | leisurely | measured pace | brisk | quick, clipped | frenetic, racing |
| Vigor | drained, running on empty | low energy, flags early | adequate energy | energetic, sustained | high-octane, tireless | relentless, overpowering |
| Boredom Proneness | content with stillness | rarely bored | occasionally restless | needs stimulation | chronically restless | cannot bear stillness |
| Endurance | fades quickly | tires under load | holds a normal shift | keeps going late | outlasts most | inexhaustible |
| Vitality/Zest | listless, flat | going through motions | ordinarily alive | enthusiastic | brimming with life | effervescent, overwhelming |
<!-- C4:end -->

<!-- C4:table id=A2 n=2 domain=A depth=2 kind=traits name="Sociability & expression" -->
#### Table 2 · A2 — Sociability & expression (Temperament & energy)
| trait (row = first die) | L1 faint | L2 low | L3 moderate-low | L4 moderate-high | L5 high | L6 extreme |
|---|---|---|---|---|---|---|
| Gregariousness | seeks solitude | few close companions | enjoys company in doses | sociable, joins in | crowd-seeker | cannot be alone |
| Warmth | cold, formal | reserved, polite | friendly when approached | warm, affectionate | openly loving | effusive, smothering |
| Assertiveness | yielding, silent | hesitant to lead | speaks when asked | states position readily | takes charge | domineering |
| Excitement Seeking | avoids stimulation | prefers quiet | enjoys occasional thrill | seeks excitement | chases intensity | reckless thrill-chaser |
| Expressiveness | poker-faced | restrained | readable | openly expressive | animated, vivid | theatrical, floods the room |
| Social Boldness | shrinks from notice | shy, warms slowly | comfortable once known | approaches readily | relishes the spotlight | brash, no reticence |
<!-- C4:end -->

<!-- C4:table id=A3 n=3 domain=A depth=3 kind=traits name="Emotional reactivity" -->
#### Table 3 · A3 — Emotional reactivity (Temperament & energy)
| trait (row = first die) | L1 faint | L2 low | L3 moderate-low | L4 moderate-high | L5 high | L6 extreme |
|---|---|---|---|---|---|---|
| Anxiety | unflappable | rarely worries | worries about real threats | frequently tense | chronically apprehensive | consumed by dread |
| Anger/Hostility | placid, slow to anger | mild irritation only | angry when provoked | quick-tempered | hot-headed, resentful | explosive, hostile |
| Moodiness | steady as a rock | rare shifts | ordinary ups and downs | noticeable swings | mercurial | volatile, whiplash |
| Stress Reactivity | unshaken | recovers fast | rattled by big stressors | easily overwhelmed | falls apart under load | paralysed by pressure |
| Self-Consciousness | oblivious to audience | rarely self-aware | aware in the spotlight | easily embarrassed | mortified by scrutiny | paralysed by judgment |
| Sentimentality | dry-eyed, unmoved | rarely sentimental | touched by real losses | readily moved | weeps at films | mawkish, awash |
<!-- C4:end -->

<!-- C4:table id=A4 n=4 domain=A depth=4 kind=traits name="Positive affect & resilience" -->
#### Table 4 · A4 — Positive affect & resilience (Temperament & energy)
| trait (row = first die) | L1 faint | L2 low | L3 moderate-low | L4 moderate-high | L5 high | L6 extreme |
|---|---|---|---|---|---|---|
| Positive Emotions | flat, joyless | sober, seldom smiles | cheerful when things go well | usually upbeat | buoyant | giddy, manic cheer |
| Optimism | expects the worst | braces for bad news | realistic, mixed | expects things to work out | confident of good outcomes | blind Pollyanna |
| Gratitude | takes all as due | rarely thanks | grateful for big favours | counts blessings | thanks readily, deeply | gushing, indebted |
| Humor/Playfulness | humourless, grave | serious, rare joke | enjoys a joke | quick to laugh | playful, witty | clownish, never serious |
| Hope | sees no way forward | doubts the path | hopeful with a plan | finds routes around blocks | tenacious, many pathways | undaunted, unrealistic |
| Resilience | shattered by setbacks | slow to recover | recovers with support | bounces back | steadies quickly, learns | unshakeable, serene |
<!-- C4:end -->

<!-- C4:table id=B1 n=5 domain=B depth=1 kind=traits name="Curiosity" -->
#### Table 5 · B1 — Curiosity (Mind & openness)
| trait (row = first die) | L1 faint | L2 low | L3 moderate-low | L4 moderate-high | L5 high | L6 extreme |
|---|---|---|---|---|---|---|
| Intellectual Curiosity | uninterested in ideas | practical, asks little | curious when relevant | enjoys ideas, asks why | reads and probes widely | consumed by questions |
| Joyous Exploration | nothing sparks interest | mildly interested | enjoys an occasional discovery | seeks new things to learn | fascinated, explores daily | rapturous, everything is wondrous |
| Deprivation Sensitivity | shrugs at unknowns | lets puzzles lie | wants answers eventually | bothered until it is solved | cannot let a gap rest | tormented by the unsolved |
| Novelty Seeking | clings to the familiar | prefers the known | tries new things sometimes | drawn to the new | restless for the unfamiliar | abandons anything familiar |
| Aesthetic Sensitivity | blind to beauty | notices little | enjoys beauty when present | seeks out beauty | moved by art and nature | overwhelmed, aesthetic chills |
| Imagination | no daydreams, literal | rarely imagines | daydreams now and then | vivid inner life | elaborate fantasy worlds | fantasy blurs into reality |
<!-- C4:end -->

<!-- C4:table id=B2 n=6 domain=B depth=2 kind=traits name="Cognitive style" -->
#### Table 6 · B2 — Cognitive style (Mind & openness)
| trait (row = first die) | L1 faint | L2 low | L3 moderate-low | L4 moderate-high | L5 high | L6 extreme |
|---|---|---|---|---|---|---|
| Need for Cognition | avoids thinking hard | thinks only when required | thinks when it pays | enjoys a good problem | seeks out hard puzzles | cannot stop analysing |
| Need for Closure | happy to leave things open | comfortable with loose ends | likes an answer in time | wants things settled | seizes the first answer | freezes, cannot revisit |
| Tolerance of Ambiguity | threatened by the unclear | uneasy without rules | copes with some fuzziness | comfortable in grey areas | enjoys ambiguity | seeks chaos, resists any structure |
| Faith in Intuition | trusts only worked analysis | checks every hunch | uses both as fits | leans on gut feel | goes with the hunch | disdains analysis entirely |
| Absorption | never loses self in anything | easily distracted | absorbed by a good book | loses hours in tasks | deep, trance-like focus | lost to the world, unreachable |
| Reflectiveness | acts on first thought | seldom pauses | reflects when stakes are high | habitually thinks it over | examines every thought | paralysed by deliberation |
<!-- C4:end -->

<!-- C4:table id=B3 n=7 domain=B depth=3 kind=traits name="Creativity & unconventionality" -->
#### Table 7 · B3 — Creativity & unconventionality (Mind & openness)
| trait (row = first die) | L1 faint | L2 low | L3 moderate-low | L4 moderate-high | L5 high | L6 extreme |
|---|---|---|---|---|---|---|
| Creative Self-Efficacy | "I am not creative" | doubts own ideas | creative in a niche | confident to try new approaches | sure of own inventiveness | grandiose about own genius |
| Divergent Thinking | one obvious answer | few, conventional ideas | a handful of options | many alternatives | floods of original ideas | idea-storms, never settles |
| Unconventionality | strictly conventional | blends in | a few quirks | openly unusual | eccentric, nonconformist | outlandish, contrarian by reflex |
| Openness to Values | dogmatic, tradition is law | conservative, defers to authority | mixed, questions some | liberal-minded, re-examines | challenges most conventions | rejects every received value |
| Openness to Actions | same routine every day | sticks to the tried | tries new things occasionally | likes to mix it up | always after something different | cannot repeat anything |
| Innovativeness | perfects the rulebook | improves within limits | balances both | reframes problems | breaks rules to solve | discards every frame, chaotic |
<!-- C4:end -->

<!-- C4:table id=B4 n=8 domain=B depth=4 kind=traits name="Wisdom" -->
#### Table 8 · B4 — Wisdom (Mind & openness)
| trait (row = first die) | L1 faint | L2 low | L3 moderate-low | L4 moderate-high | L5 high | L6 extreme |
|---|---|---|---|---|---|---|
| Perspective | one viewpoint only | sees own side | can take another's view | weighs several sides | the one others consult | detached oracle, above it all |
| Actively Open-Minded Thinking | myside, dismisses counter-evidence | defends own view | fair when pressed | seeks the other side | revises readily on evidence | no settled beliefs, endlessly revising |
| Love of Learning | avoids learning anything new | learns only when required | picks up what is useful | enjoys learning | always studying something | perpetual student, never applies |
| Intellectual Humility | never wrong, certain | rarely concedes | admits error when shown | holds views lightly | actively seeks own errors | believes nothing firmly, deferential |
| Critical Thinking Disposition | accepts anything told | rarely questions | checks big claims | habitually asks for evidence | systematically evaluates | cynical, trusts nothing |
| Self-Insight | baffled by own reactions | vague about own motives | understands self in hindsight | usually knows why | clear-eyed about self | hyper-aware, self-analysing |
<!-- C4:end -->

<!-- C4:table id=C1 n=9 domain=C depth=1 kind=traits name="Conscientiousness core" -->
#### Table 9 · C1 — Conscientiousness core (Will & work)
| trait (row = first die) | L1 faint | L2 low | L3 moderate-low | L4 moderate-high | L5 high | L6 extreme |
|---|---|---|---|---|---|---|
| Orderliness | chaotic, loses things | untidy, improvises | tidy enough | organized, systematic | meticulous, everything labelled | rigid, compulsive tidiness |
| Industriousness | idle, avoids work | does the minimum | works when required | productive, gets on with it | driven, long hours | workaholic, never stops |
| Self-Discipline | abandons tasks at once | easily sidetracked | finishes with effort | sticks to the job | iron routine | ascetic, joyless rigor |
| Deliberation | leaps before looking | quick, rough decisions | thinks a moment first | weighs options | careful, slow to commit | paralysed by analysis |
| Achievement Striving | aimless, content to coast | modest aims | wants to do well | sets and chases goals | driven, high standards | obsessed, work is everything |
| Dutifulness | shirks obligations | bends rules when convenient | keeps most promises | reliable, keeps word | scrupulous | rigidly rule-bound, moralistic |
<!-- C4:end -->

<!-- C4:table id=C2 n=10 domain=C depth=2 kind=traits name="Self-regulation" -->
#### Table 10 · C2 — Self-regulation (Will & work)
| trait (row = first die) | L1 faint | L2 low | L3 moderate-low | L4 moderate-high | L5 high | L6 extreme |
|---|---|---|---|---|---|---|
| Impulsivity | never acts on impulse | rarely rash | occasional impulse buys | acts before thinking | rash, regrets often | reckless, out of control |
| Delay of Gratification | grabs what is in reach | hard to wait | waits when it clearly pays | saves and defers readily | patient, long horizons | never enjoys the present |
| Grit/Perseverance | quits at first setback | interests shift often | finishes what matters | persists through setbacks | years-long single focus | cannot quit a lost cause |
| Procrastination | does it now | rarely delays | leaves some things late | habitually last-minute | chronic, misses deadlines | paralysed avoidance |
| Perfectionism | good enough, always | forgiving of flaws | high standards, accepts misses | exacting, self-critical | nothing is ever good enough | paralysed by fear of flaws |
| Planfulness | lives day to day | plans only when forced | rough plans | plans and schedules | detailed long-range plans | over-planned, no room for chance |
<!-- C4:end -->

<!-- C4:table id=C3 n=11 domain=C depth=3 kind=traits name="Agency & drive" -->
#### Table 11 · C3 — Agency & drive (Will & work)
| trait (row = first die) | L1 faint | L2 low | L3 moderate-low | L4 moderate-high | L5 high | L6 extreme |
|---|---|---|---|---|---|---|
| Ambition | no wish to rise | satisfied where they are | would like to advance | aims for the next rung | aims very high | ruthless, nothing is ever enough |
| Need for Achievement | content to get by | meets the bar | likes doing it well | raises the bar | excellence or nothing | cannot stop striving |
| Work Ethic | works to live | does the job | takes pride in work | hard work is right | idle time feels wrong | lives to work |
| Proactivity/Initiative | waits to be told | responds when asked | acts when need is obvious | spots and takes opportunities | initiates change constantly | meddles, cannot leave well alone |
| Autonomy/Self-Determination | does as directed | leans on approval | own views, flexible | self-directed | fiercely independent | refuses all direction |
| Mastery Orientation | only cares how they look | avoids looking incompetent | wants to do well, learn | seeks challenge to grow | learning for its own sake | endless tinkering, never ships |
<!-- C4:end -->

<!-- C4:table id=C4 n=12 domain=C depth=4 kind=traits name="Risk & sensation" -->
#### Table 12 · C4 — Risk & sensation (Will & work)
| trait (row = first die) | L1 faint | L2 low | L3 moderate-low | L4 moderate-high | L5 high | L6 extreme |
|---|---|---|---|---|---|---|
| Sensation Seeking | shuns novelty | prefers the familiar | enjoys mild novelty | seeks new experiences | chases intensity | needs ever-stronger thrills |
| Risk Tolerance | avoids all risk | insures everything | takes calculated risks | comfortable with uncertainty | bets big | gambles recklessly |
| Fear of Failure | shrugs off failure | failure stings briefly | dislikes failing, tries anyway | avoids risky tests of ability | dreads failing, plays safe | paralysed, will not attempt |
| Disinhibition | buttoned-up, abstemious | reserved, keeps limits | lets go on occasion | life of the party | wild, few limits | no brakes at all |
| Caution/Harm Avoidance | fearless, carefree | relaxed, little worry | sensibly careful | cautious, checks twice | wary, pessimistic | inhibited by every possible harm |
| Decisiveness | cannot choose, defers endlessly | agonises, revisits | decides after some deliberation | decides promptly | snap decisions, no looking back | rash, decides without facts |
<!-- C4:end -->

<!-- C4:table id=D1 n=13 domain=D depth=1 kind=traits name="Warmth & compassion" -->
#### Table 13 · D1 — Warmth & compassion (Heart & others)
| trait (row = first die) | L1 faint | L2 low | L3 moderate-low | L4 moderate-high | L5 high | L6 extreme |
|---|---|---|---|---|---|---|
| Compassion | unmoved by suffering | notices, rarely stirred | moved by those close | moved, wants to help | acts to relieve suffering | consumed by others' pain |
| Kindness | withholds, stingy | helps if asked | ordinary courtesies | does favours readily | generous, goes out of way | gives self away, doormat |
| Affective Empathy | cold, others' feelings unregistered | rarely stirred | feels for those near | readily feels with others | absorbs others' moods | overwhelmed, personal distress |
| Perspective Taking | sees only own view | rarely weighs others' views | takes others' view when reminded | routinely imagines others' view | anticipates others' views fluently | loses own standpoint |
| Tender-Mindedness | hard-headed, no mercy | sceptical of appeals to feeling | balances head and heart | leans to sympathy | soft-hearted, swayed by pleas | sentimental, cannot say no |
| Nurturance | leaves others to fend | cares under obligation | looks after own | caretaker by inclination | mothers/fathers everyone | smothering, cannot let go |
<!-- C4:end -->

<!-- C4:table id=D2 n=14 domain=D depth=2 kind=traits name="Trust & cooperation" -->
#### Table 14 · D2 — Trust & cooperation (Heart & others)
| trait (row = first die) | L1 faint | L2 low | L3 moderate-low | L4 moderate-high | L5 high | L6 extreme |
|---|---|---|---|---|---|---|
| Trust | assumes ill intent | wary until proven | trusts when warranted | gives benefit of doubt | trusts readily | gullible |
| Cooperativeness | competes or goes alone | cooperates only when paid | cooperates when reciprocated | pulls with the group | puts joint outcome first | self-effacing, exploited |
| Forgiveness | nurses grudges, seeks revenge | forgives slowly, rarely | forgives when apologised to | lets go readily | forgives without apology | forgives anything, no boundary |
| Compliance | fights every point | argues, concedes late | negotiates, gives and takes | yields to keep peace | gives way almost always | capitulates, cannot say no |
| Tolerance | rejects difference outright | puts up with it grudgingly | lives and lets live | respects difference | appreciates, seeks it out | accepts anything, no standards |
| Straightforwardness | schemes, deceives | flatters, spins | tactful truth | frank, says what it means | blunt, cannot dissemble | brutally blunt, tactless |
<!-- C4:end -->

<!-- C4:table id=D3 n=15 domain=D depth=3 kind=traits name="Social bonding" -->
#### Table 15 · D3 — Social bonding (Heart & others)
| trait (row = first die) | L1 faint | L2 low | L3 moderate-low | L4 moderate-high | L5 high | L6 extreme |
|---|---|---|---|---|---|---|
| Attachment Security | fearful, avoids closeness | anxious: clingy or distant | mostly secure, occasional doubt | secure, comfortable depending | securely bonded, steady base | unshakeably secure, blind to risk |
| Need To Belong | indifferent to inclusion | content on own | wants a few bonds | wants to be included | craves acceptance | desperate to belong, crushed by rejection |
| Loyalty | switches sides freely | loyal while convenient | sticks by own in a pinch | reliably faithful | stands by them against all | blind loyalty, covers wrongdoing |
| Social Intelligence | misses cues | reads obvious cues only | reads most rooms | reads people well | reads and steers situations | manipulator-grade reading |
| Teamwork | shirks, free-rides | does own part only | pulls weight | helps teammates unasked | citizen, carries the team | self-neglecting, cannot refuse group |
| Social Connectedness | isolated, chronically lonely | often lonely | connected enough | feels part of things | richly connected | never alone, cannot bear solitude |
<!-- C4:end -->

<!-- C4:table id=D4 n=16 domain=D depth=4 kind=traits name="Interpersonal stance" -->
#### Table 16 · D4 — Interpersonal stance (Heart & others)
| trait (row = first die) | L1 faint | L2 low | L3 moderate-low | L4 moderate-high | L5 high | L6 extreme |
|---|---|---|---|---|---|---|
| Dominance | submits, follows | defers, rarely leads | leads when asked | takes the lead | commands, controls | domineering, coercive |
| Gentleness | harsh, scathing | critical, quick to judge | fair but firm | mild, gives slack | lenient, soft on faults | lets everything slide |
| Deference | goes own way | hears others out | meets halfway | defers when unsure | yields to keep peace | cannot say no |
| Competitiveness | avoids contests | competes only when pushed | enjoys a fair contest | likes to win | must win | hypercompetitive, wins at any cost |
| Altruism | helps no one | helps when it pays | helps at small cost | helps at real cost | sacrifices for others | martyrs self, pathological altruism |
| Politeness | rude, offends freely | brusque | civil | courteous, tactful | impeccably mannered | obsequious, stifled by form |
<!-- C4:end -->

<!-- C4:table id=E1 n=17 domain=E depth=1 kind=traits name="Identity" -->
#### Table 17 · E1 — Identity (Self & shadow)
| trait (row = first die) | L1 faint | L2 low | L3 moderate-low | L4 moderate-high | L5 high | L6 extreme |
|---|---|---|---|---|---|---|
| Self-Esteem | worthless, self-loathing | doubts own worth | ordinary self-regard | secure self-worth | confidently self-assured | inflated, brittle superiority |
| Self-Efficacy | expects to fail | unsure of own ability | can-do on familiar ground | confident across tasks | tackles anything | overconfident, reckless |
| Self-Concept Clarity | no idea who they are | self-view shifts daily | knows self in broad strokes | clear, consistent self-view | crisply self-defined | rigid, closed self-definition |
| Self-Compassion | brutal self-attack | harsh inner critic | fair to self, mostly | kind to self in failure | warmly self-accepting | indulgent, lets self off |
| Authenticity | stranger to own feelings | bends to please | mostly genuine | acts on own values | transparently themselves | tactlessly, rigidly "real" |
| Identity Commitment | drifting, no anchors | still searching | provisional commitments | settled sense of self | firmly committed | foreclosed, unexamined |
<!-- C4:end -->

<!-- C4:table id=E2 n=18 domain=E depth=2 kind=traits name="Dark traits" -->
#### Table 18 · E2 — Dark traits (Self & shadow)
| trait (row = first die) | L1 faint | L2 low | L3 moderate-low | L4 moderate-high | L5 high | L6 extreme |
|---|---|---|---|---|---|---|
| Machiavellianism | transparent, trusting | dislikes tactics | plays politics when needed | strategic, guarded | calculating manipulator | cold, amoral schemer |
| Grandiose Narcissism | self-effacing | modest about talents | healthy pride | likes the spotlight | entitled, self-promoting | grandiose, exploitative |
| Vulnerable Narcissism | unbothered by slights | shrugs off criticism | stung but recovers | takes things personally | resentful, easily wounded | seething, wounded entitlement |
| Callousness | moved by any suffering | feels for others readily | ordinary concern | detached, unsentimental | cold, unmoved by harm | remorseless, predatory |
| Everyday Sadism | winces at others' pain | dislikes cruelty | enjoys rough humour | relishes others' comeuppance | enjoys inflicting hurt | seeks out cruelty |
| Spitefulness | turns the other cheek | lets grudges go | tit-for-tat when wronged | holds grudges, evens scores | harms self to punish others | self-destructive vendetta |
<!-- C4:end -->

<!-- C4:table id=E3 n=19 domain=E depth=3 kind=traits name="Integrity & honesty" -->
#### Table 19 · E3 — Integrity & honesty (Self & shadow)
| trait (row = first die) | L1 faint | L2 low | L3 moderate-low | L4 moderate-high | L5 high | L6 extreme |
|---|---|---|---|---|---|---|
| Sincerity | flatters and feigns freely | tells people what they want | honest with tact | plainly genuine | blunt, no pretence | tactless, wounding candour |
| Fairness | cheats when unwatched | bends rules for gain | fair when it counts | fair even unobserved | scrupulous to a fault | rigidly, punitively just |
| Greed Avoidance | insatiable for more | status- and money-hungry | likes nice things | content with enough | indifferent to wealth | ascetic, disdains comfort |
| Modesty | demands special treatment | quietly superior | fair estimate of self | unassuming | genuinely humble | self-abasing, self-erasing |
| Moral Identity | morality irrelevant to self | ethics as external rules | wants to be decent | morality central to self | acts on principle at cost | moralizing, self-righteous |
| Truthfulness | lies habitually | lies when convenient | white lies to smooth things | honest, tactful | honest even when costly | brutally honest, no white lies |
<!-- C4:end -->

<!-- C4:table id=E4 n=20 domain=E depth=4 kind=traits name="Regulation of self" -->
#### Table 20 · E4 — Regulation of self (Self & shadow)
| trait (row = first die) | L1 faint | L2 low | L3 moderate-low | L4 moderate-high | L5 high | L6 extreme |
|---|---|---|---|---|---|---|
| Locus of Control | fate decides everything | mostly luck and others | mixed, situational | own effort matters | self-authored outcomes | blames self for everything |
| Self-Monitoring | same in every room | rarely adjusts | adjusts when it matters | reads the room, adapts | polished social performer | all mask, no core |
| Emotion Regulation Style | bottles everything up | masks feelings, stews | copes ad hoc | reframes when stressed | habitually reframes | rationalizes everything away |
| Trait Mindfulness | lost in autopilot | rarely notices the moment | present when it matters | attentive, non-reactive | steadily present, observant | detached, over-observing |
| Regulatory Focus | vigilant, avoids all loss | duty- and safety-first | balanced approach | eager for gains | chases aspirations | reckless for the upside |
| Shame/Guilt Proneness | no remorse whatever | rarely troubled | guilt, then repair | guilt-prone, conscientious | shame-prone, self-condemning | mortified, globally worthless |
<!-- C4:end -->

<!-- C4:table id=F1 n=21 domain=F depth=1 kind=traits name="Personal-focus values" -->
#### Table 21 · F1 — Personal-focus values (Values & world)
| trait (row = first die) | L1 faint | L2 low | L3 moderate-low | L4 moderate-high | L5 high | L6 extreme |
|---|---|---|---|---|---|---|
| Self-Direction | waits to be told | prefers clear direction | decides within given lines | sets own course | insists on own way | answers to no one |
| Stimulation | wants nothing new | tolerates change | enjoys occasional novelty | seeks fresh challenges | restless for the new | burns through novelty |
| Hedonism | denies self pleasure | pleasure as afterthought | enjoys in moderation | makes room for pleasure | pleasure comes first | lives for indulgence |
| Achievement | no wish to excel | content to get by | does a solid job | aims to do well | hungry to win | must be the best |
| Power | shuns influence | uneasy with control | takes charge when needed | enjoys having say | seeks command | must rule |
| Security | courts danger | shrugs at risk | sensible precautions | prefers the safe path | guards against every threat | fortress mentality |
<!-- C4:end -->

<!-- C4:table id=F2 n=22 domain=F depth=2 kind=traits name="Social-focus values" -->
#### Table 22 · F2 — Social-focus values (Values & world)
| trait (row = first die) | L1 faint | L2 low | L3 moderate-low | L4 moderate-high | L5 high | L6 extreme |
|---|---|---|---|---|---|---|
| Conformity | flouts every norm | bends rules freely | follows the sensible ones | keeps to expectations | toes every line | cannot deviate |
| Tradition | rejects the old ways | takes customs lightly | honours some traditions | keeps the customs | devout to inherited ways | nothing may change |
| Benevolence | looks after self only | helps when convenient | helps own people | reliable for kin and friends | gives before asked | gives self away |
| Universalism | own circle only | sympathy stops at border | fair to outsiders | cares beyond own group | all humanity is kin | no boundary at all |
| Spirituality/Transcendence | nothing beyond the material | rarely wonders | open to the numinous | seeks the larger whole | lives by the transcendent | dissolved into the whole |
| Face/Humility | guards face fiercely | quick to defend image | modest but stands ground | downplays own part | deflects all credit | self-erasing |
<!-- C4:end -->

<!-- C4:table id=F3 n=23 domain=F depth=3 kind=traits name="Moral foundations & justice" -->
#### Table 23 · F3 — Moral foundations & justice (Values & world)
| trait (row = first die) | L1 faint | L2 low | L3 moderate-low | L4 moderate-high | L5 high | L6 extreme |
|---|---|---|---|---|---|---|
| Care/Harm | unmoved by suffering | suffering is their problem | protects the obviously hurt | feels for the vulnerable | cannot pass a hurt | consumed by others' pain |
| Fairness/Reciprocity | shrugs at cheating | fairness is nice to have | objects to plain cheating | keeps careful score | cannot let injustice pass | outraged by every slight |
| Loyalty/Ingroup | no group claims them | loyalty is conditional | stands by own when it counts | proud of own side | own side right or wrong | betrayal is unthinkable |
| Authority/Respect | defies all rank | questions every order | respects earned authority | obeys legitimate leaders | rank must be honoured | submits to any authority |
| Sanctity/Purity | nothing is sacred | little is off-limits | some things are just wrong | guards the sacred | purity governs choices | contamination everywhere |
| Liberty | accepts any constraint | tolerates control | resents plain bullying | bristles at being ruled | freedom over all else | no rule is legitimate |
<!-- C4:end -->

<!-- C4:table id=F4 n=24 domain=F depth=4 kind=traits name="Vocation & interests" -->
#### Table 24 · F4 — Vocation & interests (Values & world)
| trait (row = first die) | L1 faint | L2 low | L3 moderate-low | L4 moderate-high | L5 high | L6 extreme |
|---|---|---|---|---|---|---|
| Realistic | avoids anything mechanical | tolerates practical chores | handy when needed | likes making and fixing | happiest with tools in hand | only trusts what can be built |
| Investigative | no taste for puzzles | takes answers as given | likes to understand why | digs into problems | must get to the bottom | lives inside the problem |
| Artistic | no use for art | enjoys as spectator | dabbles for pleasure | makes things regularly | needs to create | lives only to express |
| Social | avoids people-work | helps if asked | comfortable helping | drawn to teaching and care | must be serving people | cannot work without people |
| Enterprising | will not sell or lead | reluctant to persuade | speaks up for a plan | enjoys leading a push | always closing the deal | empire-builder |
| Conventional | chaos suits them | tolerates loose ends | keeps things in order | likes clear procedures | everything filed and checked | rules for the rules' sake |
<!-- C4:end -->

<!-- C4:pg1rl kind=jumbled tables=24 seed=20260906 -->

<!-- C4:table id=JA1 n=1 domain=A depth=1 kind=jumbled -->
#### Jumbled 1 · A1
| row \ col | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---|---|---|---|---|---|
| 1 | Boredom Proneness · L3 · occasionally restless | Endurance · L4 · keeps going late | Boredom Proneness · L4 · needs stimulation | Vigor · L1 · drained, running on empty | Endurance · L2 · tires under load | Pace/Tempo · L6 · frenetic, racing |
| 2 | Vigor · L3 · adequate energy | Pace/Tempo · L5 · quick, clipped | Vigor · L4 · energetic, sustained | Activity Level · L6 · hyperkinetic, cannot sit still | Vitality/Zest · L4 · enthusiastic | Vitality/Zest · L2 · going through motions |
| 3 | Vigor · L2 · low energy, flags early | Boredom Proneness · L5 · chronically restless | Vigor · L6 · relentless, overpowering | Pace/Tempo · L2 · leisurely | Vitality/Zest · L6 · effervescent, overwhelming | Endurance · L3 · holds a normal shift |
| 4 | Activity Level · L4 · busy, likes motion | Activity Level · L5 · always on the go | Pace/Tempo · L4 · brisk | Endurance · L5 · outlasts most | Vitality/Zest · L3 · ordinarily alive | Activity Level · L2 · slow-moving, low-key |
| 5 | Endurance · L1 · fades quickly | Activity Level · L1 · sedentary, stays put | Vitality/Zest · L1 · listless, flat | Vitality/Zest · L5 · brimming with life | Pace/Tempo · L3 · measured pace | Vigor · L5 · high-octane, tireless |
| 6 | Boredom Proneness · L1 · content with stillness | Activity Level · L3 · steady, moderate doer | Pace/Tempo · L1 · glacial, deliberate | Endurance · L6 · inexhaustible | Boredom Proneness · L2 · rarely bored | Boredom Proneness · L6 · cannot bear stillness |
<!-- C4:end -->

<!-- C4:table id=JA2 n=2 domain=A depth=2 kind=jumbled -->
#### Jumbled 2 · A2
| row \ col | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---|---|---|---|---|---|
| 1 | Warmth · L2 · reserved, polite | Excitement Seeking · L1 · avoids stimulation | Gregariousness · L3 · enjoys company in doses | Assertiveness · L3 · speaks when asked | Excitement Seeking · L3 · enjoys occasional thrill | Expressiveness · L2 · restrained |
| 2 | Excitement Seeking · L4 · seeks excitement | Warmth · L5 · openly loving | Gregariousness · L5 · crowd-seeker | Warmth · L3 · friendly when approached | Excitement Seeking · L2 · prefers quiet | Social Boldness · L4 · approaches readily |
| 3 | Expressiveness · L5 · animated, vivid | Social Boldness · L2 · shy, warms slowly | Expressiveness · L4 · openly expressive | Warmth · L1 · cold, formal | Gregariousness · L6 · cannot be alone | Warmth · L4 · warm, affectionate |
| 4 | Social Boldness · L3 · comfortable once known | Social Boldness · L6 · brash, no reticence | Social Boldness · L1 · shrinks from notice | Assertiveness · L5 · takes charge | Social Boldness · L5 · relishes the spotlight | Assertiveness · L1 · yielding, silent |
| 5 | Expressiveness · L1 · poker-faced | Expressiveness · L3 · readable | Assertiveness · L6 · domineering | Gregariousness · L1 · seeks solitude | Expressiveness · L6 · theatrical, floods the room | Excitement Seeking · L6 · reckless thrill-chaser |
| 6 | Gregariousness · L2 · few close companions | Gregariousness · L4 · sociable, joins in | Assertiveness · L2 · hesitant to lead | Warmth · L6 · effusive, smothering | Assertiveness · L4 · states position readily | Excitement Seeking · L5 · chases intensity |
<!-- C4:end -->

<!-- C4:table id=JA3 n=3 domain=A depth=3 kind=jumbled -->
#### Jumbled 3 · A3
| row \ col | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---|---|---|---|---|---|
| 1 | Stress Reactivity · L1 · unshaken | Stress Reactivity · L2 · recovers fast | Self-Consciousness · L5 · mortified by scrutiny | Moodiness · L6 · volatile, whiplash | Sentimentality · L1 · dry-eyed, unmoved | Anxiety · L2 · rarely worries |
| 2 | Stress Reactivity · L6 · paralysed by pressure | Sentimentality · L6 · mawkish, awash | Stress Reactivity · L4 · easily overwhelmed | Anger/Hostility · L5 · hot-headed, resentful | Moodiness · L4 · noticeable swings | Self-Consciousness · L2 · rarely self-aware |
| 3 | Sentimentality · L2 · rarely sentimental | Self-Consciousness · L4 · easily embarrassed | Self-Consciousness · L3 · aware in the spotlight | Stress Reactivity · L5 · falls apart under load | Moodiness · L2 · rare shifts | Anxiety · L5 · chronically apprehensive |
| 4 | Sentimentality · L5 · weeps at films | Anger/Hostility · L6 · explosive, hostile | Moodiness · L1 · steady as a rock | Anger/Hostility · L2 · mild irritation only | Moodiness · L3 · ordinary ups and downs | Stress Reactivity · L3 · rattled by big stressors |
| 5 | Anxiety · L3 · worries about real threats | Self-Consciousness · L1 · oblivious to audience | Anxiety · L1 · unflappable | Anxiety · L6 · consumed by dread | Anger/Hostility · L3 · angry when provoked | Sentimentality · L4 · readily moved |
| 6 | Anxiety · L4 · frequently tense | Moodiness · L5 · mercurial | Anger/Hostility · L1 · placid, slow to anger | Sentimentality · L3 · touched by real losses | Self-Consciousness · L6 · paralysed by judgment | Anger/Hostility · L4 · quick-tempered |
<!-- C4:end -->

<!-- C4:table id=JA4 n=4 domain=A depth=4 kind=jumbled -->
#### Jumbled 4 · A4
| row \ col | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---|---|---|---|---|---|
| 1 | Optimism · L6 · blind Pollyanna | Hope · L4 · finds routes around blocks | Gratitude · L1 · takes all as due | Hope · L2 · doubts the path | Optimism · L4 · expects things to work out | Hope · L1 · sees no way forward |
| 2 | Optimism · L5 · confident of good outcomes | Resilience · L5 · steadies quickly, learns | Humor/Playfulness · L4 · quick to laugh | Resilience · L3 · recovers with support | Optimism · L1 · expects the worst | Gratitude · L4 · counts blessings |
| 3 | Positive Emotions · L1 · flat, joyless | Gratitude · L5 · thanks readily, deeply | Humor/Playfulness · L6 · clownish, never serious | Gratitude · L2 · rarely thanks | Humor/Playfulness · L1 · humourless, grave | Gratitude · L6 · gushing, indebted |
| 4 | Hope · L6 · undaunted, unrealistic | Positive Emotions · L2 · sober, seldom smiles | Positive Emotions · L6 · giddy, manic cheer | Humor/Playfulness · L3 · enjoys a joke | Optimism · L3 · realistic, mixed | Optimism · L2 · braces for bad news |
| 5 | Hope · L3 · hopeful with a plan | Positive Emotions · L3 · cheerful when things go well | Gratitude · L3 · grateful for big favours | Positive Emotions · L4 · usually upbeat | Hope · L5 · tenacious, many pathways | Humor/Playfulness · L2 · serious, rare joke |
| 6 | Resilience · L1 · shattered by setbacks | Positive Emotions · L5 · buoyant | Resilience · L4 · bounces back | Resilience · L6 · unshakeable, serene | Humor/Playfulness · L5 · playful, witty | Resilience · L2 · slow to recover |
<!-- C4:end -->

<!-- C4:table id=JB1 n=5 domain=B depth=1 kind=jumbled -->
#### Jumbled 5 · B1
| row \ col | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---|---|---|---|---|---|
| 1 | Aesthetic Sensitivity · L4 · seeks out beauty | Joyous Exploration · L6 · rapturous, everything is wondrous | Imagination · L3 · daydreams now and then | Imagination · L4 · vivid inner life | Imagination · L1 · no daydreams, literal | Deprivation Sensitivity · L6 · tormented by the unsolved |
| 2 | Aesthetic Sensitivity · L1 · blind to beauty | Joyous Exploration · L1 · nothing sparks interest | Deprivation Sensitivity · L4 · bothered until it is solved | Intellectual Curiosity · L6 · consumed by questions | Aesthetic Sensitivity · L5 · moved by art and nature | Novelty Seeking · L5 · restless for the unfamiliar |
| 3 | Novelty Seeking · L4 · drawn to the new | Novelty Seeking · L6 · abandons anything familiar | Intellectual Curiosity · L1 · uninterested in ideas | Aesthetic Sensitivity · L2 · notices little | Aesthetic Sensitivity · L6 · overwhelmed, aesthetic chills | Intellectual Curiosity · L2 · practical, asks little |
| 4 | Intellectual Curiosity · L3 · curious when relevant | Deprivation Sensitivity · L3 · wants answers eventually | Novelty Seeking · L2 · prefers the known | Novelty Seeking · L3 · tries new things sometimes | Aesthetic Sensitivity · L3 · enjoys beauty when present | Imagination · L5 · elaborate fantasy worlds |
| 5 | Imagination · L6 · fantasy blurs into reality | Joyous Exploration · L4 · seeks new things to learn | Joyous Exploration · L3 · enjoys an occasional discovery | Deprivation Sensitivity · L5 · cannot let a gap rest | Joyous Exploration · L2 · mildly interested | Imagination · L2 · rarely imagines |
| 6 | Intellectual Curiosity · L5 · reads and probes widely | Joyous Exploration · L5 · fascinated, explores daily | Intellectual Curiosity · L4 · enjoys ideas, asks why | Novelty Seeking · L1 · clings to the familiar | Deprivation Sensitivity · L1 · shrugs at unknowns | Deprivation Sensitivity · L2 · lets puzzles lie |
<!-- C4:end -->

<!-- C4:table id=JB2 n=6 domain=B depth=2 kind=jumbled -->
#### Jumbled 6 · B2
| row \ col | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---|---|---|---|---|---|
| 1 | Need for Closure · L1 · happy to leave things open | Need for Closure · L2 · comfortable with loose ends | Need for Cognition · L1 · avoids thinking hard | Need for Cognition · L4 · enjoys a good problem | Faith in Intuition · L4 · leans on gut feel | Reflectiveness · L3 · reflects when stakes are high |
| 2 | Reflectiveness · L4 · habitually thinks it over | Faith in Intuition · L3 · uses both as fits | Faith in Intuition · L5 · goes with the hunch | Reflectiveness · L5 · examines every thought | Tolerance of Ambiguity · L5 · enjoys ambiguity | Faith in Intuition · L6 · disdains analysis entirely |
| 3 | Tolerance of Ambiguity · L2 · uneasy without rules | Absorption · L2 · easily distracted | Need for Closure · L4 · wants things settled | Tolerance of Ambiguity · L6 · seeks chaos, resists any structure | Need for Cognition · L3 · thinks when it pays | Tolerance of Ambiguity · L4 · comfortable in grey areas |
| 4 | Faith in Intuition · L1 · trusts only worked analysis | Need for Cognition · L2 · thinks only when required | Absorption · L3 · absorbed by a good book | Absorption · L4 · loses hours in tasks | Need for Closure · L5 · seizes the first answer | Need for Closure · L6 · freezes, cannot revisit |
| 5 | Absorption · L1 · never loses self in anything | Need for Cognition · L5 · seeks out hard puzzles | Reflectiveness · L6 · paralysed by deliberation | Reflectiveness · L1 · acts on first thought | Tolerance of Ambiguity · L3 · copes with some fuzziness | Faith in Intuition · L2 · checks every hunch |
| 6 | Need for Cognition · L6 · cannot stop analysing | Absorption · L6 · lost to the world, unreachable | Tolerance of Ambiguity · L1 · threatened by the unclear | Need for Closure · L3 · likes an answer in time | Reflectiveness · L2 · seldom pauses | Absorption · L5 · deep, trance-like focus |
<!-- C4:end -->

<!-- C4:table id=JB3 n=7 domain=B depth=3 kind=jumbled -->
#### Jumbled 7 · B3
| row \ col | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---|---|---|---|---|---|
| 1 | Divergent Thinking · L1 · one obvious answer | Openness to Values · L1 · dogmatic, tradition is law | Divergent Thinking · L6 · idea-storms, never settles | Divergent Thinking · L4 · many alternatives | Innovativeness · L2 · improves within limits | Openness to Actions · L4 · likes to mix it up |
| 2 | Creative Self-Efficacy · L3 · creative in a niche | Unconventionality · L1 · strictly conventional | Innovativeness · L3 · balances both | Openness to Actions · L1 · same routine every day | Innovativeness · L1 · perfects the rulebook | Creative Self-Efficacy · L4 · confident to try new approaches |
| 3 | Divergent Thinking · L5 · floods of original ideas | Creative Self-Efficacy · L5 · sure of own inventiveness | Openness to Values · L6 · rejects every received value | Creative Self-Efficacy · L1 · "I am not creative" | Divergent Thinking · L3 · a handful of options | Openness to Values · L3 · mixed, questions some |
| 4 | Openness to Actions · L6 · cannot repeat anything | Openness to Values · L4 · liberal-minded, re-examines | Unconventionality · L6 · outlandish, contrarian by reflex | Openness to Values · L2 · conservative, defers to authority | Innovativeness · L5 · breaks rules to solve | Creative Self-Efficacy · L6 · grandiose about own genius |
| 5 | Openness to Actions · L2 · sticks to the tried | Unconventionality · L4 · openly unusual | Unconventionality · L3 · a few quirks | Openness to Actions · L3 · tries new things occasionally | Unconventionality · L5 · eccentric, nonconformist | Innovativeness · L6 · discards every frame, chaotic |
| 6 | Innovativeness · L4 · reframes problems | Openness to Actions · L5 · always after something different | Divergent Thinking · L2 · few, conventional ideas | Creative Self-Efficacy · L2 · doubts own ideas | Unconventionality · L2 · blends in | Openness to Values · L5 · challenges most conventions |
<!-- C4:end -->

<!-- C4:table id=JB4 n=8 domain=B depth=4 kind=jumbled -->
#### Jumbled 8 · B4
| row \ col | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---|---|---|---|---|---|
| 1 | Love of Learning · L2 · learns only when required | Perspective · L1 · one viewpoint only | Actively Open-Minded Thinking · L4 · seeks the other side | Actively Open-Minded Thinking · L5 · revises readily on evidence | Actively Open-Minded Thinking · L3 · fair when pressed | Critical Thinking Disposition · L4 · habitually asks for evidence |
| 2 | Critical Thinking Disposition · L5 · systematically evaluates | Critical Thinking Disposition · L1 · accepts anything told | Perspective · L4 · weighs several sides | Critical Thinking Disposition · L2 · rarely questions | Actively Open-Minded Thinking · L6 · no settled beliefs, endlessly revising | Intellectual Humility · L5 · actively seeks own errors |
| 3 | Self-Insight · L6 · hyper-aware, self-analysing | Critical Thinking Disposition · L6 · cynical, trusts nothing | Self-Insight · L3 · understands self in hindsight | Perspective · L2 · sees own side | Perspective · L5 · the one others consult | Love of Learning · L3 · picks up what is useful |
| 4 | Self-Insight · L4 · usually knows why | Love of Learning · L5 · always studying something | Actively Open-Minded Thinking · L1 · myside, dismisses counter-evidence | Perspective · L3 · can take another's view | Intellectual Humility · L1 · never wrong, certain | Self-Insight · L5 · clear-eyed about self |
| 5 | Intellectual Humility · L6 · believes nothing firmly, deferential | Actively Open-Minded Thinking · L2 · defends own view | Intellectual Humility · L4 · holds views lightly | Intellectual Humility · L3 · admits error when shown | Love of Learning · L6 · perpetual student, never applies | Perspective · L6 · detached oracle, above it all |
| 6 | Love of Learning · L4 · enjoys learning | Love of Learning · L1 · avoids learning anything new | Self-Insight · L2 · vague about own motives | Intellectual Humility · L2 · rarely concedes | Self-Insight · L1 · baffled by own reactions | Critical Thinking Disposition · L3 · checks big claims |
<!-- C4:end -->

<!-- C4:table id=JC1 n=9 domain=C depth=1 kind=jumbled -->
#### Jumbled 9 · C1
| row \ col | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---|---|---|---|---|---|
| 1 | Orderliness · L6 · rigid, compulsive tidiness | Dutifulness · L5 · scrupulous | Self-Discipline · L6 · ascetic, joyless rigor | Orderliness · L3 · tidy enough | Self-Discipline · L2 · easily sidetracked | Dutifulness · L6 · rigidly rule-bound, moralistic |
| 2 | Dutifulness · L1 · shirks obligations | Dutifulness · L2 · bends rules when convenient | Achievement Striving · L5 · driven, high standards | Industriousness · L3 · works when required | Industriousness · L6 · workaholic, never stops | Deliberation · L6 · paralysed by analysis |
| 3 | Deliberation · L5 · careful, slow to commit | Deliberation · L4 · weighs options | Achievement Striving · L3 · wants to do well | Achievement Striving · L2 · modest aims | Self-Discipline · L3 · finishes with effort | Industriousness · L1 · idle, avoids work |
| 4 | Orderliness · L1 · chaotic, loses things | Achievement Striving · L1 · aimless, content to coast | Industriousness · L4 · productive, gets on with it | Dutifulness · L4 · reliable, keeps word | Orderliness · L5 · meticulous, everything labelled | Achievement Striving · L4 · sets and chases goals |
| 5 | Achievement Striving · L6 · obsessed, work is everything | Industriousness · L5 · driven, long hours | Orderliness · L2 · untidy, improvises | Orderliness · L4 · organized, systematic | Industriousness · L2 · does the minimum | Deliberation · L1 · leaps before looking |
| 6 | Deliberation · L2 · quick, rough decisions | Deliberation · L3 · thinks a moment first | Self-Discipline · L1 · abandons tasks at once | Dutifulness · L3 · keeps most promises | Self-Discipline · L5 · iron routine | Self-Discipline · L4 · sticks to the job |
<!-- C4:end -->

<!-- C4:table id=JC2 n=10 domain=C depth=2 kind=jumbled -->
#### Jumbled 10 · C2
| row \ col | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---|---|---|---|---|---|
| 1 | Impulsivity · L5 · rash, regrets often | Procrastination · L5 · chronic, misses deadlines | Impulsivity · L3 · occasional impulse buys | Procrastination · L3 · leaves some things late | Delay of Gratification · L6 · never enjoys the present | Procrastination · L4 · habitually last-minute |
| 2 | Procrastination · L2 · rarely delays | Delay of Gratification · L2 · hard to wait | Perfectionism · L1 · good enough, always | Delay of Gratification · L1 · grabs what is in reach | Planfulness · L6 · over-planned, no room for chance | Procrastination · L1 · does it now |
| 3 | Impulsivity · L1 · never acts on impulse | Delay of Gratification · L4 · saves and defers readily | Perfectionism · L4 · exacting, self-critical | Perfectionism · L2 · forgiving of flaws | Impulsivity · L6 · reckless, out of control | Procrastination · L6 · paralysed avoidance |
| 4 | Planfulness · L2 · plans only when forced | Grit/Perseverance · L3 · finishes what matters | Perfectionism · L6 · paralysed by fear of flaws | Grit/Perseverance · L2 · interests shift often | Planfulness · L3 · rough plans | Impulsivity · L2 · rarely rash |
| 5 | Planfulness · L4 · plans and schedules | Grit/Perseverance · L5 · years-long single focus | Grit/Perseverance · L1 · quits at first setback | Grit/Perseverance · L6 · cannot quit a lost cause | Perfectionism · L5 · nothing is ever good enough | Planfulness · L5 · detailed long-range plans |
| 6 | Delay of Gratification · L3 · waits when it clearly pays | Planfulness · L1 · lives day to day | Delay of Gratification · L5 · patient, long horizons | Perfectionism · L3 · high standards, accepts misses | Grit/Perseverance · L4 · persists through setbacks | Impulsivity · L4 · acts before thinking |
<!-- C4:end -->

<!-- C4:table id=JC3 n=11 domain=C depth=3 kind=jumbled -->
#### Jumbled 11 · C3
| row \ col | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---|---|---|---|---|---|
| 1 | Autonomy/Self-Determination · L2 · leans on approval | Autonomy/Self-Determination · L5 · fiercely independent | Autonomy/Self-Determination · L4 · self-directed | Mastery Orientation · L5 · learning for its own sake | Ambition · L4 · aims for the next rung | Autonomy/Self-Determination · L1 · does as directed |
| 2 | Autonomy/Self-Determination · L3 · own views, flexible | Proactivity/Initiative · L4 · spots and takes opportunities | Need for Achievement · L2 · meets the bar | Mastery Orientation · L6 · endless tinkering, never ships | Autonomy/Self-Determination · L6 · refuses all direction | Proactivity/Initiative · L1 · waits to be told |
| 3 | Need for Achievement · L4 · raises the bar | Proactivity/Initiative · L3 · acts when need is obvious | Mastery Orientation · L1 · only cares how they look | Need for Achievement · L5 · excellence or nothing | Need for Achievement · L6 · cannot stop striving | Ambition · L3 · would like to advance |
| 4 | Proactivity/Initiative · L5 · initiates change constantly | Ambition · L5 · aims very high | Work Ethic · L5 · idle time feels wrong | Mastery Orientation · L2 · avoids looking incompetent | Work Ethic · L6 · lives to work | Mastery Orientation · L3 · wants to do well, learn |
| 5 | Ambition · L2 · satisfied where they are | Ambition · L1 · no wish to rise | Work Ethic · L1 · works to live | Work Ethic · L2 · does the job | Need for Achievement · L3 · likes doing it well | Work Ethic · L3 · takes pride in work |
| 6 | Ambition · L6 · ruthless, nothing is ever enough | Mastery Orientation · L4 · seeks challenge to grow | Work Ethic · L4 · hard work is right | Proactivity/Initiative · L6 · meddles, cannot leave well alone | Proactivity/Initiative · L2 · responds when asked | Need for Achievement · L1 · content to get by |
<!-- C4:end -->

<!-- C4:table id=JC4 n=12 domain=C depth=4 kind=jumbled -->
#### Jumbled 12 · C4
| row \ col | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---|---|---|---|---|---|
| 1 | Caution/Harm Avoidance · L6 · inhibited by every possible harm | Caution/Harm Avoidance · L5 · wary, pessimistic | Decisiveness · L4 · decides promptly | Disinhibition · L4 · life of the party | Disinhibition · L3 · lets go on occasion | Risk Tolerance · L2 · insures everything |
| 2 | Sensation Seeking · L2 · prefers the familiar | Risk Tolerance · L3 · takes calculated risks | Disinhibition · L5 · wild, few limits | Decisiveness · L3 · decides after some deliberation | Decisiveness · L1 · cannot choose, defers endlessly | Decisiveness · L5 · snap decisions, no looking back |
| 3 | Sensation Seeking · L3 · enjoys mild novelty | Fear of Failure · L2 · failure stings briefly | Risk Tolerance · L1 · avoids all risk | Risk Tolerance · L6 · gambles recklessly | Fear of Failure · L4 · avoids risky tests of ability | Caution/Harm Avoidance · L4 · cautious, checks twice |
| 4 | Decisiveness · L2 · agonises, revisits | Fear of Failure · L5 · dreads failing, plays safe | Caution/Harm Avoidance · L3 · sensibly careful | Sensation Seeking · L4 · seeks new experiences | Disinhibition · L6 · no brakes at all | Risk Tolerance · L4 · comfortable with uncertainty |
| 5 | Fear of Failure · L1 · shrugs off failure | Caution/Harm Avoidance · L1 · fearless, carefree | Decisiveness · L6 · rash, decides without facts | Disinhibition · L1 · buttoned-up, abstemious | Sensation Seeking · L6 · needs ever-stronger thrills | Sensation Seeking · L5 · chases intensity |
| 6 | Risk Tolerance · L5 · bets big | Fear of Failure · L3 · dislikes failing, tries anyway | Caution/Harm Avoidance · L2 · relaxed, little worry | Sensation Seeking · L1 · shuns novelty | Disinhibition · L2 · reserved, keeps limits | Fear of Failure · L6 · paralysed, will not attempt |
<!-- C4:end -->

<!-- C4:table id=JD1 n=13 domain=D depth=1 kind=jumbled -->
#### Jumbled 13 · D1
| row \ col | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---|---|---|---|---|---|
| 1 | Affective Empathy · L4 · readily feels with others | Tender-Mindedness · L6 · sentimental, cannot say no | Affective Empathy · L3 · feels for those near | Kindness · L3 · ordinary courtesies | Compassion · L6 · consumed by others' pain | Nurturance · L6 · smothering, cannot let go |
| 2 | Nurturance · L3 · looks after own | Perspective Taking · L5 · anticipates others' views fluently | Tender-Mindedness · L1 · hard-headed, no mercy | Kindness · L4 · does favours readily | Nurturance · L1 · leaves others to fend | Perspective Taking · L2 · rarely weighs others' views |
| 3 | Tender-Mindedness · L4 · leans to sympathy | Kindness · L1 · withholds, stingy | Kindness · L5 · generous, goes out of way | Perspective Taking · L6 · loses own standpoint | Compassion · L2 · notices, rarely stirred | Tender-Mindedness · L2 · sceptical of appeals to feeling |
| 4 | Perspective Taking · L3 · takes others' view when reminded | Affective Empathy · L6 · overwhelmed, personal distress | Perspective Taking · L4 · routinely imagines others' view | Affective Empathy · L5 · absorbs others' moods | Tender-Mindedness · L3 · balances head and heart | Compassion · L5 · acts to relieve suffering |
| 5 | Affective Empathy · L1 · cold, others' feelings unregistered | Kindness · L6 · gives self away, doormat | Perspective Taking · L1 · sees only own view | Compassion · L4 · moved, wants to help | Compassion · L1 · unmoved by suffering | Affective Empathy · L2 · rarely stirred |
| 6 | Compassion · L3 · moved by those close | Kindness · L2 · helps if asked | Nurturance · L2 · cares under obligation | Nurturance · L4 · caretaker by inclination | Nurturance · L5 · mothers/fathers everyone | Tender-Mindedness · L5 · soft-hearted, swayed by pleas |
<!-- C4:end -->

<!-- C4:table id=JD2 n=14 domain=D depth=2 kind=jumbled -->
#### Jumbled 14 · D2
| row \ col | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---|---|---|---|---|---|
| 1 | Cooperativeness · L2 · cooperates only when paid | Cooperativeness · L1 · competes or goes alone | Compliance · L5 · gives way almost always | Compliance · L1 · fights every point | Straightforwardness · L4 · frank, says what it means | Tolerance · L4 · respects difference |
| 2 | Trust · L4 · gives benefit of doubt | Tolerance · L5 · appreciates, seeks it out | Tolerance · L6 · accepts anything, no standards | Forgiveness · L6 · forgives anything, no boundary | Trust · L3 · trusts when warranted | Cooperativeness · L3 · cooperates when reciprocated |
| 3 | Cooperativeness · L6 · self-effacing, exploited | Straightforwardness · L1 · schemes, deceives | Trust · L2 · wary until proven | Straightforwardness · L5 · blunt, cannot dissemble | Forgiveness · L1 · nurses grudges, seeks revenge | Forgiveness · L4 · lets go readily |
| 4 | Trust · L5 · trusts readily | Cooperativeness · L5 · puts joint outcome first | Tolerance · L1 · rejects difference outright | Compliance · L4 · yields to keep peace | Straightforwardness · L2 · flatters, spins | Forgiveness · L3 · forgives when apologised to |
| 5 | Straightforwardness · L6 · brutally blunt, tactless | Straightforwardness · L3 · tactful truth | Forgiveness · L2 · forgives slowly, rarely | Tolerance · L2 · puts up with it grudgingly | Compliance · L2 · argues, concedes late | Trust · L6 · gullible |
| 6 | Compliance · L6 · capitulates, cannot say no | Tolerance · L3 · lives and lets live | Cooperativeness · L4 · pulls with the group | Compliance · L3 · negotiates, gives and takes | Trust · L1 · assumes ill intent | Forgiveness · L5 · forgives without apology |
<!-- C4:end -->

<!-- C4:table id=JD3 n=15 domain=D depth=3 kind=jumbled -->
#### Jumbled 15 · D3
| row \ col | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---|---|---|---|---|---|
| 1 | Attachment Security · L5 · securely bonded, steady base | Social Intelligence · L3 · reads most rooms | Attachment Security · L1 · fearful, avoids closeness | Loyalty · L5 · stands by them against all | Teamwork · L2 · does own part only | Social Connectedness · L2 · often lonely |
| 2 | Need To Belong · L6 · desperate to belong, crushed by rejection | Need To Belong · L2 · content on own | Social Intelligence · L5 · reads and steers situations | Loyalty · L1 · switches sides freely | Social Intelligence · L2 · reads obvious cues only | Teamwork · L4 · helps teammates unasked |
| 3 | Social Connectedness · L6 · never alone, cannot bear solitude | Social Connectedness · L3 · connected enough | Teamwork · L1 · shirks, free-rides | Attachment Security · L6 · unshakeably secure, blind to risk | Teamwork · L5 · citizen, carries the team | Teamwork · L6 · self-neglecting, cannot refuse group |
| 4 | Social Intelligence · L6 · manipulator-grade reading | Need To Belong · L4 · wants to be included | Need To Belong · L3 · wants a few bonds | Need To Belong · L1 · indifferent to inclusion | Teamwork · L3 · pulls weight | Social Connectedness · L5 · richly connected |
| 5 | Social Intelligence · L1 · misses cues | Need To Belong · L5 · craves acceptance | Social Connectedness · L1 · isolated, chronically lonely | Loyalty · L4 · reliably faithful | Attachment Security · L4 · secure, comfortable depending | Attachment Security · L3 · mostly secure, occasional doubt |
| 6 | Social Connectedness · L4 · feels part of things | Loyalty · L3 · sticks by own in a pinch | Social Intelligence · L4 · reads people well | Loyalty · L6 · blind loyalty, covers wrongdoing | Loyalty · L2 · loyal while convenient | Attachment Security · L2 · anxious: clingy or distant |
<!-- C4:end -->

<!-- C4:table id=JD4 n=16 domain=D depth=4 kind=jumbled -->
#### Jumbled 16 · D4
| row \ col | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---|---|---|---|---|---|
| 1 | Deference · L1 · goes own way | Competitiveness · L6 · hypercompetitive, wins at any cost | Deference · L6 · cannot say no | Altruism · L4 · helps at real cost | Gentleness · L2 · critical, quick to judge | Altruism · L2 · helps when it pays |
| 2 | Dominance · L5 · commands, controls | Gentleness · L5 · lenient, soft on faults | Dominance · L2 · defers, rarely leads | Politeness · L3 · civil | Deference · L5 · yields to keep peace | Competitiveness · L3 · enjoys a fair contest |
| 3 | Altruism · L5 · sacrifices for others | Politeness · L6 · obsequious, stifled by form | Gentleness · L1 · harsh, scathing | Competitiveness · L2 · competes only when pushed | Competitiveness · L4 · likes to win | Politeness · L1 · rude, offends freely |
| 4 | Gentleness · L4 · mild, gives slack | Deference · L2 · hears others out | Altruism · L1 · helps no one | Competitiveness · L1 · avoids contests | Dominance · L1 · submits, follows | Dominance · L4 · takes the lead |
| 5 | Competitiveness · L5 · must win | Gentleness · L3 · fair but firm | Deference · L3 · meets halfway | Deference · L4 · defers when unsure | Gentleness · L6 · lets everything slide | Dominance · L3 · leads when asked |
| 6 | Dominance · L6 · domineering, coercive | Politeness · L4 · courteous, tactful | Altruism · L6 · martyrs self, pathological altruism | Politeness · L2 · brusque | Altruism · L3 · helps at small cost | Politeness · L5 · impeccably mannered |
<!-- C4:end -->

<!-- C4:table id=JE1 n=17 domain=E depth=1 kind=jumbled -->
#### Jumbled 17 · E1
| row \ col | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---|---|---|---|---|---|
| 1 | Authenticity · L4 · acts on own values | Self-Compassion · L2 · harsh inner critic | Authenticity · L3 · mostly genuine | Self-Efficacy · L2 · unsure of own ability | Self-Efficacy · L1 · expects to fail | Self-Esteem · L4 · secure self-worth |
| 2 | Self-Compassion · L5 · warmly self-accepting | Self-Compassion · L6 · indulgent, lets self off | Self-Concept Clarity · L6 · rigid, closed self-definition | Identity Commitment · L2 · still searching | Self-Efficacy · L5 · tackles anything | Self-Efficacy · L3 · can-do on familiar ground |
| 3 | Self-Concept Clarity · L2 · self-view shifts daily | Authenticity · L2 · bends to please | Self-Concept Clarity · L4 · clear, consistent self-view | Identity Commitment · L1 · drifting, no anchors | Self-Efficacy · L6 · overconfident, reckless | Self-Concept Clarity · L1 · no idea who they are |
| 4 | Identity Commitment · L3 · provisional commitments | Identity Commitment · L6 · foreclosed, unexamined | Self-Esteem · L3 · ordinary self-regard | Self-Esteem · L2 · doubts own worth | Self-Concept Clarity · L3 · knows self in broad strokes | Self-Compassion · L3 · fair to self, mostly |
| 5 | Identity Commitment · L4 · settled sense of self | Self-Esteem · L5 · confidently self-assured | Authenticity · L6 · tactlessly, rigidly "real" | Self-Concept Clarity · L5 · crisply self-defined | Identity Commitment · L5 · firmly committed | Self-Efficacy · L4 · confident across tasks |
| 6 | Self-Compassion · L1 · brutal self-attack | Self-Compassion · L4 · kind to self in failure | Authenticity · L5 · transparently themselves | Authenticity · L1 · stranger to own feelings | Self-Esteem · L6 · inflated, brittle superiority | Self-Esteem · L1 · worthless, self-loathing |
<!-- C4:end -->

<!-- C4:table id=JE2 n=18 domain=E depth=2 kind=jumbled -->
#### Jumbled 18 · E2
| row \ col | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---|---|---|---|---|---|
| 1 | Machiavellianism · L4 · strategic, guarded | Vulnerable Narcissism · L6 · seething, wounded entitlement | Callousness · L1 · moved by any suffering | Spitefulness · L5 · harms self to punish others | Everyday Sadism · L2 · dislikes cruelty | Grandiose Narcissism · L5 · entitled, self-promoting |
| 2 | Callousness · L4 · detached, unsentimental | Everyday Sadism · L1 · winces at others' pain | Callousness · L6 · remorseless, predatory | Everyday Sadism · L4 · relishes others' comeuppance | Vulnerable Narcissism · L2 · shrugs off criticism | Everyday Sadism · L6 · seeks out cruelty |
| 3 | Callousness · L3 · ordinary concern | Grandiose Narcissism · L6 · grandiose, exploitative | Spitefulness · L6 · self-destructive vendetta | Machiavellianism · L3 · plays politics when needed | Machiavellianism · L1 · transparent, trusting | Grandiose Narcissism · L3 · healthy pride |
| 4 | Vulnerable Narcissism · L5 · resentful, easily wounded | Vulnerable Narcissism · L4 · takes things personally | Machiavellianism · L6 · cold, amoral schemer | Grandiose Narcissism · L2 · modest about talents | Grandiose Narcissism · L1 · self-effacing | Everyday Sadism · L3 · enjoys rough humour |
| 5 | Machiavellianism · L2 · dislikes tactics | Spitefulness · L2 · lets grudges go | Grandiose Narcissism · L4 · likes the spotlight | Vulnerable Narcissism · L3 · stung but recovers | Callousness · L5 · cold, unmoved by harm | Vulnerable Narcissism · L1 · unbothered by slights |
| 6 | Spitefulness · L3 · tit-for-tat when wronged | Machiavellianism · L5 · calculating manipulator | Everyday Sadism · L5 · enjoys inflicting hurt | Spitefulness · L1 · turns the other cheek | Spitefulness · L4 · holds grudges, evens scores | Callousness · L2 · feels for others readily |
<!-- C4:end -->

<!-- C4:table id=JE3 n=19 domain=E depth=3 kind=jumbled -->
#### Jumbled 19 · E3
| row \ col | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---|---|---|---|---|---|
| 1 | Truthfulness · L3 · white lies to smooth things | Fairness · L1 · cheats when unwatched | Sincerity · L6 · tactless, wounding candour | Greed Avoidance · L3 · likes nice things | Fairness · L6 · rigidly, punitively just | Moral Identity · L1 · morality irrelevant to self |
| 2 | Greed Avoidance · L6 · ascetic, disdains comfort | Fairness · L3 · fair when it counts | Greed Avoidance · L5 · indifferent to wealth | Moral Identity · L6 · moralizing, self-righteous | Truthfulness · L6 · brutally honest, no white lies | Fairness · L4 · fair even unobserved |
| 3 | Greed Avoidance · L1 · insatiable for more | Truthfulness · L5 · honest even when costly | Moral Identity · L4 · morality central to self | Modesty · L5 · genuinely humble | Truthfulness · L1 · lies habitually | Sincerity · L1 · flatters and feigns freely |
| 4 | Fairness · L5 · scrupulous to a fault | Greed Avoidance · L2 · status- and money-hungry | Fairness · L2 · bends rules for gain | Truthfulness · L2 · lies when convenient | Modesty · L1 · demands special treatment | Sincerity · L5 · blunt, no pretence |
| 5 | Greed Avoidance · L4 · content with enough | Sincerity · L2 · tells people what they want | Modesty · L6 · self-abasing, self-erasing | Modesty · L3 · fair estimate of self | Moral Identity · L5 · acts on principle at cost | Moral Identity · L3 · wants to be decent |
| 6 | Moral Identity · L2 · ethics as external rules | Sincerity · L3 · honest with tact | Modesty · L4 · unassuming | Truthfulness · L4 · honest, tactful | Modesty · L2 · quietly superior | Sincerity · L4 · plainly genuine |
<!-- C4:end -->

<!-- C4:table id=JE4 n=20 domain=E depth=4 kind=jumbled -->
#### Jumbled 20 · E4
| row \ col | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---|---|---|---|---|---|
| 1 | Self-Monitoring · L3 · adjusts when it matters | Regulatory Focus · L2 · duty- and safety-first | Locus of Control · L3 · mixed, situational | Trait Mindfulness · L2 · rarely notices the moment | Self-Monitoring · L1 · same in every room | Shame/Guilt Proneness · L3 · guilt, then repair |
| 2 | Emotion Regulation Style · L1 · bottles everything up | Regulatory Focus · L3 · balanced approach | Self-Monitoring · L2 · rarely adjusts | Locus of Control · L6 · blames self for everything | Emotion Regulation Style · L6 · rationalizes everything away | Shame/Guilt Proneness · L6 · mortified, globally worthless |
| 3 | Regulatory Focus · L4 · eager for gains | Trait Mindfulness · L3 · present when it matters | Locus of Control · L2 · mostly luck and others | Trait Mindfulness · L4 · attentive, non-reactive | Shame/Guilt Proneness · L1 · no remorse whatever | Shame/Guilt Proneness · L2 · rarely troubled |
| 4 | Locus of Control · L4 · own effort matters | Locus of Control · L1 · fate decides everything | Shame/Guilt Proneness · L5 · shame-prone, self-condemning | Emotion Regulation Style · L4 · reframes when stressed | Locus of Control · L5 · self-authored outcomes | Emotion Regulation Style · L5 · habitually reframes |
| 5 | Shame/Guilt Proneness · L4 · guilt-prone, conscientious | Trait Mindfulness · L6 · detached, over-observing | Regulatory Focus · L5 · chases aspirations | Trait Mindfulness · L1 · lost in autopilot | Self-Monitoring · L6 · all mask, no core | Trait Mindfulness · L5 · steadily present, observant |
| 6 | Emotion Regulation Style · L3 · copes ad hoc | Self-Monitoring · L5 · polished social performer | Regulatory Focus · L6 · reckless for the upside | Self-Monitoring · L4 · reads the room, adapts | Emotion Regulation Style · L2 · masks feelings, stews | Regulatory Focus · L1 · vigilant, avoids all loss |
<!-- C4:end -->

<!-- C4:table id=JF1 n=21 domain=F depth=1 kind=jumbled -->
#### Jumbled 21 · F1
| row \ col | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---|---|---|---|---|---|
| 1 | Security · L5 · guards against every threat | Security · L4 · prefers the safe path | Hedonism · L2 · pleasure as afterthought | Self-Direction · L4 · sets own course | Security · L3 · sensible precautions | Hedonism · L4 · makes room for pleasure |
| 2 | Hedonism · L6 · lives for indulgence | Hedonism · L3 · enjoys in moderation | Achievement · L3 · does a solid job | Power · L4 · enjoys having say | Power · L3 · takes charge when needed | Stimulation · L1 · wants nothing new |
| 3 | Achievement · L2 · content to get by | Security · L2 · shrugs at risk | Hedonism · L5 · pleasure comes first | Stimulation · L3 · enjoys occasional novelty | Self-Direction · L2 · prefers clear direction | Power · L1 · shuns influence |
| 4 | Stimulation · L2 · tolerates change | Self-Direction · L5 · insists on own way | Achievement · L4 · aims to do well | Self-Direction · L3 · decides within given lines | Security · L6 · fortress mentality | Hedonism · L1 · denies self pleasure |
| 5 | Security · L1 · courts danger | Achievement · L1 · no wish to excel | Self-Direction · L6 · answers to no one | Stimulation · L5 · restless for the new | Stimulation · L4 · seeks fresh challenges | Achievement · L5 · hungry to win |
| 6 | Power · L5 · seeks command | Power · L6 · must rule | Self-Direction · L1 · waits to be told | Achievement · L6 · must be the best | Stimulation · L6 · burns through novelty | Power · L2 · uneasy with control |
<!-- C4:end -->

<!-- C4:table id=JF2 n=22 domain=F depth=2 kind=jumbled -->
#### Jumbled 22 · F2
| row \ col | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---|---|---|---|---|---|
| 1 | Tradition · L3 · honours some traditions | Universalism · L5 · all humanity is kin | Benevolence · L2 · helps when convenient | Conformity · L1 · flouts every norm | Face/Humility · L6 · self-erasing | Face/Humility · L4 · downplays own part |
| 2 | Benevolence · L1 · looks after self only | Tradition · L2 · takes customs lightly | Spirituality/Transcendence · L6 · dissolved into the whole | Tradition · L4 · keeps the customs | Tradition · L5 · devout to inherited ways | Universalism · L4 · cares beyond own group |
| 3 | Benevolence · L4 · reliable for kin and friends | Conformity · L2 · bends rules freely | Face/Humility · L5 · deflects all credit | Tradition · L1 · rejects the old ways | Universalism · L3 · fair to outsiders | Spirituality/Transcendence · L1 · nothing beyond the material |
| 4 | Benevolence · L6 · gives self away | Face/Humility · L2 · quick to defend image | Tradition · L6 · nothing may change | Face/Humility · L3 · modest but stands ground | Spirituality/Transcendence · L3 · open to the numinous | Spirituality/Transcendence · L2 · rarely wonders |
| 5 | Conformity · L4 · keeps to expectations | Benevolence · L5 · gives before asked | Universalism · L1 · own circle only | Benevolence · L3 · helps own people | Conformity · L5 · toes every line | Universalism · L6 · no boundary at all |
| 6 | Spirituality/Transcendence · L4 · seeks the larger whole | Face/Humility · L1 · guards face fiercely | Spirituality/Transcendence · L5 · lives by the transcendent | Conformity · L3 · follows the sensible ones | Universalism · L2 · sympathy stops at border | Conformity · L6 · cannot deviate |
<!-- C4:end -->

<!-- C4:table id=JF3 n=23 domain=F depth=3 kind=jumbled -->
#### Jumbled 23 · F3
| row \ col | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---|---|---|---|---|---|
| 1 | Authority/Respect · L6 · submits to any authority | Liberty · L3 · resents plain bullying | Fairness/Reciprocity · L3 · objects to plain cheating | Sanctity/Purity · L6 · contamination everywhere | Loyalty/Ingroup · L5 · own side right or wrong | Liberty · L2 · tolerates control |
| 2 | Sanctity/Purity · L2 · little is off-limits | Sanctity/Purity · L5 · purity governs choices | Fairness/Reciprocity · L4 · keeps careful score | Authority/Respect · L1 · defies all rank | Authority/Respect · L4 · obeys legitimate leaders | Authority/Respect · L3 · respects earned authority |
| 3 | Sanctity/Purity · L1 · nothing is sacred | Care/Harm · L6 · consumed by others' pain | Liberty · L6 · no rule is legitimate | Authority/Respect · L2 · questions every order | Loyalty/Ingroup · L2 · loyalty is conditional | Loyalty/Ingroup · L3 · stands by own when it counts |
| 4 | Loyalty/Ingroup · L6 · betrayal is unthinkable | Loyalty/Ingroup · L4 · proud of own side | Liberty · L4 · bristles at being ruled | Care/Harm · L4 · feels for the vulnerable | Liberty · L1 · accepts any constraint | Care/Harm · L5 · cannot pass a hurt |
| 5 | Fairness/Reciprocity · L5 · cannot let injustice pass | Care/Harm · L1 · unmoved by suffering | Fairness/Reciprocity · L6 · outraged by every slight | Care/Harm · L3 · protects the obviously hurt | Liberty · L5 · freedom over all else | Fairness/Reciprocity · L1 · shrugs at cheating |
| 6 | Sanctity/Purity · L3 · some things are just wrong | Authority/Respect · L5 · rank must be honoured | Loyalty/Ingroup · L1 · no group claims them | Fairness/Reciprocity · L2 · fairness is nice to have | Sanctity/Purity · L4 · guards the sacred | Care/Harm · L2 · suffering is their problem |
<!-- C4:end -->

<!-- C4:table id=JF4 n=24 domain=F depth=4 kind=jumbled -->
#### Jumbled 24 · F4
| row \ col | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---|---|---|---|---|---|
| 1 | Investigative · L1 · no taste for puzzles | Conventional · L6 · rules for the rules' sake | Social · L5 · must be serving people | Realistic · L5 · happiest with tools in hand | Social · L2 · helps if asked | Investigative · L2 · takes answers as given |
| 2 | Conventional · L3 · keeps things in order | Artistic · L3 · dabbles for pleasure | Enterprising · L6 · empire-builder | Realistic · L6 · only trusts what can be built | Artistic · L5 · needs to create | Realistic · L3 · handy when needed |
| 3 | Conventional · L2 · tolerates loose ends | Artistic · L1 · no use for art | Investigative · L6 · lives inside the problem | Investigative · L4 · digs into problems | Conventional · L5 · everything filed and checked | Conventional · L4 · likes clear procedures |
| 4 | Artistic · L6 · lives only to express | Realistic · L2 · tolerates practical chores | Social · L6 · cannot work without people | Artistic · L2 · enjoys as spectator | Enterprising · L3 · speaks up for a plan | Social · L3 · comfortable helping |
| 5 | Investigative · L3 · likes to understand why | Enterprising · L1 · will not sell or lead | Realistic · L1 · avoids anything mechanical | Artistic · L4 · makes things regularly | Realistic · L4 · likes making and fixing | Enterprising · L4 · enjoys leading a push |
| 6 | Investigative · L5 · must get to the bottom | Enterprising · L5 · always closing the deal | Social · L4 · drawn to teaching and care | Conventional · L1 · chaos suits them | Social · L1 · avoids people-work | Enterprising · L2 · reluctant to persuade |
<!-- C4:end -->

<!-- C4:news kind=items n=36 source='Roll for Bias 1.0.90 (signed)' -->
| n | source | half |
|---|---|---|
| 1 | Breitbart News | biased |
| 2 | AlterNet | biased |
| 3 | One America News Network (OANN) | biased |
| 4 | The Palmer Report | biased |
| 5 | InfoWars | biased |
| 6 | Jacobin | biased |
| 7 | Newsmax | biased |
| 8 | Mother Jones | biased |
| 9 | The Daily Caller | biased |
| 10 | Daily Kos | biased |
| 11 | The Federalist | biased |
| 12 | HuffPost | biased |
| 13 | The Blaze | biased |
| 14 | MSNBC | biased |
| 15 | Fox News | biased |
| 16 | The Nation | biased |
| 17 | New York Post | biased |
| 18 | CNN | biased |
| 19 | The Washington Post | least-biased |
| 20 | The Epoch Times | least-biased |
| 21 | The New York Times | least-biased |
| 22 | The Wall Street Journal (News Division) | least-biased |
| 23 | USA Today | least-biased |
| 24 | The Hill | least-biased |
| 25 | Newsweek | least-biased |
| 26 | Axios | least-biased |
| 27 | Forbes | least-biased |
| 28 | Bloomberg News | least-biased |
| 29 | Financial Times | least-biased |
| 30 | C-SPAN | least-biased |
| 31 | The Christian Science Monitor | least-biased |
| 32 | Straight Arrow News | least-biased |
| 33 | BBC News | least-biased |
| 34 | NPR (News Reporting) | least-biased |
| 35 | Associated Press (AP) | least-biased |
| 36 | Reuters | least-biased |
<!-- C4:end -->

<!-- C4:news kind=ordered -->
| row \ col | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---|---|---|---|---|---|
| 1 | 1 | 2 | 3 | 4 | 5 | 6 |
| 2 | 7 | 8 | 9 | 10 | 11 | 12 |
| 3 | 13 | 14 | 15 | 16 | 17 | 18 |
| 4 | 19 | 20 | 21 | 22 | 23 | 24 |
| 5 | 25 | 26 | 27 | 28 | 29 | 30 |
| 6 | 31 | 32 | 33 | 34 | 35 | 36 |
<!-- C4:end -->

<!-- C4:news kind=randomized -->
| row \ col | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---|---|---|---|---|---|
| 1 | 17 | 3 | 29 | 12 | 34 | 5 |
| 2 | 22 | 11 | 8 | 31 | 2 | 26 |
| 3 | 14 | 25 | 7 | 36 | 19 | 10 |
| 4 | 1 | 33 | 20 | 9 | 27 | 15 |
| 5 | 30 | 4 | 18 | 23 | 13 | 35 |
| 6 | 6 | 28 | 21 | 32 | 24 | 16 |
<!-- C4:end -->

<!-- C4:index kind=index -->
| row \ col | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---|---|---|---|---|---|
| 1 | BIAS | 1 | 2 | 3 | 4 | X |
| 2 | 5 | BIAS | 6 | 7 | X | 8 |
| 3 | 9 | 10 | BIAS | X | 11 | 12 |
| 4 | 13 | 14 | X | BIAS | 15 | 16 |
| 5 | 17 | X | 18 | 19 | BIAS | 20 |
| 6 | X | 21 | 22 | 23 | 24 | BIAS |
<!-- C4:end -->

---

## Sources

The bibliography — every source for every trait, with its verification state and the two readers
that checked it — is `PERSONA-TRAITS-SOURCES.md` beside this file (generated from the record). The
record itself, `PERSONA-TRAITS.tsv`, carries per trait: definition, poles, the six level words,
neighbours, taxonomy, three formal sources, up to two flair sources, the routes run, and notes.

---

*Corwin Brust &lt;corwin@bru.st&gt; · lab partners Bryant Frankford and Bridget · CC-BY4 (or, at the
bearer's option, any later version of that license) · Assisted-by: Claude (Mentat/Vibrobeast), Gemini*
