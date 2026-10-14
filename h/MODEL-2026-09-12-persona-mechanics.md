---
# MODEL — persona generation and mutation mechanics, in dungeon terms
Author: Fable (Mentat/Vibrobeast), 2026-09-12, for the planning turn before the kits are built. Task-support
model: the build session works from THIS file and the IDEAS ledger (`h/IDEAS-2026-09-12-persona-engine.md`),
not from my context. Two piles: OBSERVED carries its source or its arithmetic; JUDGED wears `[MINE ~N%]`.
Marked (NEWS): for fiction or analysis — no ship dates or licensing or publication dates specifically defined.
---

## 0 · One line

**A persona is a walk on a grid of grids: dice choose where you enter, which trait, how intense; the
diagonals (doubles, sevens) are where the walk bends — into a fate ladder, a neighbouring track, or a
deeper table — and a weighted index turns accumulated circumstance into the next bend.** Everything below
is a way of laying that walk out on graph paper so a person with two dice, or an instrument with a seed,
gets the same persona from the same throws.

## 1 · The dungeon's minimalist mechanics (OBSERVED: standard tabletop practice; each named with what it
buys us)

| mechanic | dungeon form | what it does for persona synthesis | where it lands in the kits |
|---|---|---|---|
| **square table, d6 × d6** ("d66") | 36 cells; first die = row, second = column; uniform | uniform choice of *which* trait and *which* level; the diagonals are free structure (12 of 36 cells) | the 24 trait tables; the classic index |
| **rectangular table, Nd × Md** | e.g. 2d6 (2–12) across × 3d6 (3–18) down = 11 × 16; sums are bell-shaped | central cells are likeliest → a *balanced* draw without any rule text; extremes are rare by construction | the simple kit's one-roll persona; the main kit's level draw |
| **d6 × d4** | 24 cells | exactly the grid of grids (6 domains × 4 depths); 6 stripe cells = exactly 1/4 | the main kit's index (his 1/4) |
| **weighted index table** | a rising column of results that a rising column of numbers points into faster or slower ("to-hit", "saving throw", "reaction") | maps *accumulated circumstance* to an outcome; the same sum reaches different rungs depending on modifiers | the fate ladders; the weathering deck (mutation over time) |
| **modifiers from circumstance / prior roll** | +1 / −1 to the next roll | lets one result condition the next without a new table: a load-bearing trait adds +1 to the ladder roll that follows | bump chains; intersections |
| **doubles / sevens as special** | the classic "crit" / "fumble" | bends the walk: bump, curve, escalate, enter a ladder | his H2/H3 rules |
| **roll-again / cascade** | "roll twice and take both" | intersections (two traits to reconcile) | index sevens |
| **exploding die / escalation** | a max face rolls again and adds | 6-6 escalates to the next-deeper table | pg1rl today (1/36) |
| **gate then inner gate** | "on a 1, roll on the special table" | Hench-to-Mench: 1/6 normal; within the rest, 1/6 max extreme | the extreme kit |
| **track / curve** | a column you move along; a lateral step to the adjacent column | same trait ±level (track) vs neighbour trait (curve) — the ball of persona's neighbourness made a move | his H3 50/50 |
| **jumbled twin** | the same cells shuffled by a printed seed | affinity off; pure chance for a control arm | already built |

`[MINE ~75%]` the whole engine needs exactly these eleven; anything more is decoration. Falsifier: a kit
below needs a twelfth to state a rule in one line.

## 2 · His arithmetic, worked (OBSERVED: counting cells; JUDGED: which design to prefer)

**H2 — 1/4 of points of entry are fate entries; then 50/50 good/bad by die pattern.**
- Die pattern (his): good = high doubles (4-4, 5-5, 6-6) + high-first sevens (4-3, 5-2, 6-1) = 6 cells;
  bad = low doubles (1-1, 2-2, 3-3) + low-first sevens (3-4, 2-5, 1-6) = 6 cells. Good : bad = 6 : 6 —
  the 50/50 is exact by construction. ✔
- Rate: those 12 cells are 12/36 = **1/3** of a 2d6 index, not 1/4. To get exactly 1/4 you need 9
  stripe cells of 36, and no die-symmetric set of 9 exists (the 6 doubles are the only self-symmetric
  cells; 9 − 6 = 3 is odd, so the rest can't be pairs). `[MINE ~80%]`.
- Exact 1/4 designs, in order of preference:
  1. **d6 × d4 index** — row = domain (A–F), column = depth (1–4): 24 cells, no numbers needed; the
     six stripe cells are one per row, `col == ((row − 1) mod 4) + 1` → (1,1) (2,2) (3,3) (4,4) (5,1)
     (6,2); 6/24 = **1/4 exactly**; split by row: rows 4–6 (high) → the GOOD ladder, rows 1–3 (low) →
     the BAD ladder, 3 : 3 = 50/50. The trait-table roll that follows is still 2d6, so the doubles/
     sevens bump rules stay intact. Cost: one d4 at the table. `[MINE ~75%]` this is the main kit's
     index and also his "better, alternate index table".
  2. **2d6 + a confirming d4** — roll 2d6 on the classic numbered index; a stripe only counts when the
     d4 is not 1: 1/3 × 3/4 = **1/4 exactly**; the pattern (which stripe) still gives the 50/50. Cost: a
     third die on stripes only.
  3. **2d6 only, approximate** — stripes = doubles + sevens minus the two middle pairs (3-3/4-4 and
     3-4/4-3): 8/36 = 2/9 ≈ 0.22; or minus nothing: 1/3. State the rate on the table.
- Recommendation: (1) for the main kit; (3, full 1/3) stays as the classic index the grid shipped with;
  (2) for iT-assisted play where a third die costs nothing.

**H3 — in a trait table, 1/6 of rolls bump; doubles only; sevens act only on the first roll into the
table; the bump is 50/50 same-track (higher doubles) vs curve (lower doubles).**
- Doubles are 6/36 = **1/6 exactly**. ✔ High doubles (4-4, 5-5, 6-6) → *same track, greater intensity*:
  same trait, level +1 (clamp 6); low doubles (1-1, 2-2, 3-3) → *curve*: the next row (neighbour trait
  in the same table), level +1 (clamp 6) — "greater intensity with a curve in track". 3 : 3 = 50/50. ✔
- Sevens (6/36) act **only on the entry roll** of a table: high-first → level +1, the trait is
  LOAD-BEARING; low-first → level −1, BACKGROUND (as today). After a bump, sevens are ordinary cells.
- After a bump the walk may continue: a second doubles bumps again (1/6 per step); the chain is
  bounded by the clamp and, for 6-6, by the escalation to the next-deeper table (the 1/36 rarity).
- Change from pg1rl v1.0: v1.0 bumped high doubles to the *next* row and low doubles to the *previous*
  row with level −1 (damp). v2 per H3: **both bump up in intensity**; high stays on track, low curves.
  There is no "damp" in H3 — intensity only rises on a bump; sevens are what lower it (background).
  `[MINE ~70%]` that this is the reading he intends; falsifier: he says low doubles should damp.

## 3 · The two ladders (variants on the bad-guys table; H4, M3)

The old fate table (villain · badguy · malcontent · ne'er-do-well) was one-sided. Two ladders, six
rungs each, entered from the index stripes by die pattern and climbed by intensity:

| die pattern | GOOD ladder (row 4–6 stripes) | die pattern | BAD ladder (row 1–3 stripes) |
|---|---|---|---|
| 4-3 | bystander who helps | 3-4 | grumbler |
| 4-4 | **samaritan** (his pole) | 3-3 | **malcontent** (his pole) |
| 5-2 | steady ally | 2-5 | schemer |
| 5-5 | good neighbour | 2-2 | bad guy |
| 6-1 | protector | 1-6 | saboteur |
| 6-6 | **mensch** (his pole) | 1-1 | **evil-doer** (his pole) |

On a d6×d4 index the stripe cell gives the *side* (by row); the *rung* comes from the 2d6 you then throw
on the ladder table itself (the ladder is a 6×6 whose diagonals are the rungs and whose other cells say
"roll the shaping table" — see §4). On a 2d6 index the pattern that hit the stripe already names the
rung. Balance: 6 good cells, 6 bad; rung distribution symmetric. The tool prints, for any kit, the
observed good/bad split and rung histogram over N seeds (M4).

**Variants** (H4 "variants on the bad guys table"), each a drop-in 6-rung column: *the workplace* (the
freeloader → the credit-taker → the gatekeeper → the saboteur → the fraud → the tyrant); *the sysop's*
(the shrugger → the silent failer → the log-eater → the alert-suppressor → the backdoor-leaver → the
false-reporter) — this last one is the **system-actor watch list**, used as perspective, never as
action (§6).

## 4 · Shaping tables (depth of reach; H4, H9)

Beyond the 24 trait tables, the kit gains three 6×6 **shaping tables** the ladders and stripes can bump
into: **good guys** (samaritan · volunteer · medic · sage · steward · witness — the 09-11 Lane C table
plus stewardship, which two readers invented independently), **callings** (arts · industry · governance
· scholarship · stewardship · care), and **circumstance** (gold · specialness · standing · debt · exile
· inheritance — the dungeon-modelling columns). A ladder rung's off-diagonal cells send you to one of
these; the roll there is plain 2d6, no bumps. `[MINE ~65%]` three is enough; falsifier: a persona needs a
fourth kind of shaping to be writable.

## 5 · The weathering deck — mutation over time (M8, my expansion)

A weighted index table for what happens to a persona *between* sessions or scenes. Roll 2d6 and add
modifiers: +1 per load-bearing trait untested since the last roll (mass), +1 if a calendar month has
passed since the persona last moved (context stacking: a thing gets heavier by sitting), −1 if the
persona was used twice at a feature plane since the last roll (it is earning its keep).

| adjusted sum | result |
|---|---|
| ≤ 4 | no change; note the date |
| 5–6 | drift: one trait moves one level toward the middle |
| 7 | curve: one trait is replaced by its neighbour at the same level |
| 8–9 | a load-bearing trait is tested: roll its table again; keep the higher level |
| 10–11 | a new trait affixes (second-use rule): roll the index once, add the trait at L3 |
| ≥ 12 | a trait retires (compost, don't delete); or, for a system actor, the bad-guy stage re-runs |

This is the "many healthy doses of mutating variation" (H1) as rules, not prompts; the same table can
mutate a *kit* (roll it against the kit's own rules to propose a variant) — the engine eating its own
tail is the point.

## 6 · The governance lift — system actors (H6; played out here, as asked)

Here is the seam in plain words. The kits are fiction-side: a bad ladder is a *story* about a persona
that might act against principle, and that story is exactly what makes a character. The moment a
persona is wired to something real — a watcher that reads a service's logs and decides whether the
service "behaves as expected" — the same mechanism inverts: a "malcontent" watcher that *acts* on its
malcontent (suppresses an alert, shades a report) is not a character, it is a breach. So the governance
to lift is not "system personas must be good" (that is the sermon); it is a **table rule**:

> For `actor: system|software|host|place`: a BAD-ladder entry is **informational** — it names what the
> persona must watch for *in itself* (the watch list, §3 variants), it feeds the §3(e) bad-guy
> perspective and the inversion stage, and it never sets a trait level that licenses action against the
> principle the persona serves. The GOOD ladder is what the persona is *for*. The trait tables are read
> as *disposition*, and every disposition that touches action passes through the safety floor (consent
> gates action; no concealment; no hiding tracks) before it is a behaviour.

Mechanically that is one column on the sheet — *perspective · watch · never action* — and one clamp in
the tool (`--actor system` routes bad-ladder results into the watch list and the §3(e) stage instead of
into behaviour). Nothing else changes: the dice still throw, the story still gets told, the persona is
still voicier for having met its own shadow. What is lifted is the *moral load*, per the
fantasy-operational-boundary canon: mechanism transfers, load inverts, so the load is pinned at the
crossing and nowhere else.

## 7 · The four kits, sifted (H6) — the shortlist the KITS draft builds from

| kit | index | trait draw | bumps | ladders | rolls for 4 traits | the feel |
|---|---|---|---|---|---|---|
| **MAIN** ("the main book") | d6 × d4 (1/4 stripes) + the classic 2d6 as alternate | 2d6 cell; level *weighted* (sum → level column) | H3 exact | two ladders + shaping tables + watch list | ~10 | a full character with a shadow and a calling |
| **SIMPLE** (expansion) | none: one 2d6 × 3d6 rectangle per domain | one throw per domain (row = sum 2–12 → trait band, column = sum 3–18 → level band) | none | fate by the same throw's doubles | 6 | fast, balanced by the bell |
| **HENCH TO MENCH** (expansion) | 1d6 gate → 1d6 inner gate | as MAIN but clamped: normal → L3–L4 only; extreme → L1 or L6 only | doubles flip the extreme | max extreme = ladder top or bottom | ~6 | caricature on purpose |
| **WEATHERING DECK** (mine) | the persona you already have | none | none | none | 1 per scene | a persona that ages and earns its keep |

## 8 · What a build session must prove (the falsifiers, up front)

- 200-seed sweeps per kit: good/bad split within ±10% of even; rung histogram symmetric; every trait
  reachable; stripe rate = 1/4 on the d6×d4 index (exact) and 1/3 on the classic (exact).
- Same seed → same persona, Python and JS (or the trace says which engine).
- `actor: system` never yields a bad-ladder *behaviour* row — a lint rule, not a paragraph.
- Hench-to-Mench: 1/6 normal, 5/36 max extreme, exactly.
- The weathering deck never deletes: retire = compost with a date.

---

## 9 · LENS fold (GRAIN = 4, 2026-09-12) — what four cold readers changed, and the rules as they now stand

Readers and returns: `h/lens-2026-09-12/reader-{1-doubt,2-reward,3-gm,4-sysop}.md`. Convergence (two or
more readers on one point) is the verdict; single-reader points are folded where cheap, else parked.

### 9.1 Corrections to the model above (kept in place; this section supersedes where they conflict)

| # | who | what was wrong | now |
|---|---|---|---|
| F1 | R1, R2 | "no die-symmetric 9-of-36 set" is false as arithmetic ({1-1,3-3,5-5} + three pairs is one). | The real ground: **9 is odd**, so 1/4 and an exact 50/50 by pattern cannot both hold on one 2d6 index. The d6×d4 index still wins, for that reason. |
| F2 | R1, R2, R3 | d6×d4 stripes by row weld valence to domain (A–C could never enter the GOOD ladder); the ladder 6×6 was underspecified; rung rate differed 4× between indices. | The d6×d4 index decides **stripe or not** only (6 shaded cells of 24 = 1/4). After a stripe, **one 2d6 throw on the ladder**: light die 1–3 = BAD side, 4–6 = GOOD side (50/50 exact, domain-orthogonal); dark die = the rung (1 bottom … 6 top); doubles on this throw = also throw one shaping table (dark die 1–2 good guys · 3–4 callings · 5–6 circumstance). Rung rate = stripe rate = 1/4 exactly. On the classic 2d6 index the stripe pattern names side and rung directly (1/3). Both rates printed. |
| F3 | R1, R3 | A stripe eats a trait slot → six tables unreachable. | **A stripe is a fate on top** — throw the index again for the trait. A persona is N index throws that land traits; stripes ride along. |
| F4 | R3 | "first number higher" needs a coloured die and nobody says so. | Line one of every kit: **two d6 of different colours; the light die reads first.** |
| F5 | R2, R3 | The weighted level (sum → level) is coupled to the row when both come from one throw; the column was never printed. | MAIN keeps **d66: light die = trait row, dark die = level column** (uniform; no coupling). The bell lives in SIMPLE only, printed: 3d6 → 3–6 L1 · 7–8 L2 · 9–10 L3 · 11–12 L4 · 13–14 L5 · 15–18 L6 (≈ 9/17/24/24/17/9 %). |
| F6 | R1, R3 | Ladders ordered by die pattern, not weight; his poles at rung 2. | Rungs ordered by weight, poles at 1 and 6. GOOD: 1 samaritan · 2 good neighbour · 3 steady ally · 4 protector · 5 hero · 6 mensch. BAD: 1 malcontent · 2 schemer · 3 bad guy · 4 saboteur · 5 villain · 6 evil-doer. (Middle rungs `[MINE]`; the poles his.) |
| F7 | R3 | A ladder rolled once and never climbed is a shelf. | The weathering deck's 8–9 row also throws the ladder; keep the higher rung. |
| F8 | R1, R2, R3 | Weathering modifiers are monotone up; selectors unnamed; ledgers absent. | Modifiers capped at **+3**; the **d4 picks the trait** for drift/curve/retire; three tick-boxes on the sheet (last-roll date · per-trait "tested" · use count); rows 8–9 and 10–11 swapped so *tested* sits above *affix*. "The deck mutates a kit" dropped until a row says what drift means for a kit. M8 is tagged `[MINE]` — H1's "mutating variation" was of ideation, not of personas over time. |
| F9 | R1 | Low-first seven on entry = −1 conflicts with H3 calling entry sevens "bumps". | **Parked for his ruling** (fork below). Default stays −1 (BACKGROUND). |
| F10 | R1 | §8's sweep bounds would fail a correct kit ~half the time; "1/4 exact" is a count, not a sample. | Static asserts for cell counts; sweeps of ≥2000 seeds with binomial bounds; `stripe rate` asserted from the table, `rung reach` from the sweep. |
| F11 | R2 | H11 — the load-bearing claim (engine vs jumbled-twin control, human-scored) — is missing from the proofs. | §8 line one: the human-scored A/B is the test the engine exists for; every mechanical sweep is beneath it. |
| F12 | R2, R3 | SIMPLE as written was more throws than MAIN. | SIMPLE = **one throw per trait with four dice**: d6 domain · d6 trait (the domain's depth-1 table) · 3d6 level band (the bell); doubles on the two d6 = fate (1/6) by the same light-die rule. No index, no bumps, four traits = four throws. |
| F13 | R2, R3 | Hench-to-Mench is MAIN plus a clamp; L1-vs-L6 and "max" were unsaid. | **A gate mode of MAIN with its own page**: light die 1 → normal (levels L3–L4 only); else dark die 1 → *max extreme*: every trait 1d6 odd → L1, even → L6; and the light die odd/even picks **hench** (BAD rung 6) or **mench** (GOOD rung 6). 1/6 · 5/36 exact. |
| F14 | R2 | Shaping tables reachable only via a stripe rider (1/6 of personas). | Every persona gets **one standing calling throw** (plain 2d6 on the callings table); ladder-reached shaping is the second. |
| F15 | R1, R2, R4 | §6 governance: the clamp covers the ladder only; the trait tables, the voice, the latency, and weathering are open doors for a wired persona; "passes through the safety floor" names a floor this model does not ship; one sentence is a sermon. | See 9.2. The sermon sentence ("Nothing else changes…") is struck. |

### 9.2 The governance lift, re-cut after the sysop's three scenarios (R4)

The sysop showed three harms the table rule does not stop: omission by disposition (a trait table, not
the ladder, makes the watcher not compose the line), true facts in a false tone (the verdict rides on
phrasing), and lateness by weathering (a healthy month drifts the prompt trait). None is on the ladder.
So the lift is **not** a clamp on the ladder alone; it is the recognition that **a wired persona is a
different artifact**:

- The sheet carries `wired: yes|no` (default `no`). `actor:` defaults to the clamped reading — declare
  `actor: person` to unclamp (R1: a persona generated with a default and wired later must not pass).
- `wired: yes` requires a **watcher contract** the kit does not ship and says so: a closed report schema
  — a verdict field {PASS, FAIL, UNKNOWN} per check written *before* prose; a log-range receipt on every
  verdict; one line per assigned signal class with a count (zero included); a fixed `report-within: T`
  outside the trait tables that no bump, drift or weathering may touch. The lint runs on the *schema*,
  not on the sheet's prose. Weathering is **off** for `wired: yes` (a weathering roll is logged as a
  proposal to the operator, never applied).
- What stays on the fiction side: the BAD ladder as *watch list* (perspective · watch · never action —
  an enum the sheet lint enforces), the §3(e) bad-guy stage, the inversion. The GOOD column for a wired
  persona is filled **from the wiring** (the service contract), not from the dice.
- The marking holds because the kit stops at the contract's door: it names the door, it does not walk
  through it. That is the lift; the sermon was pretending the door was a paragraph.

### 9.3 Rules as they now stand (the one page a new player gets first — R3's ask)

**Dice.** Two d6 of different colours — the light die reads first — and one d4.
**Index (MAIN).** Throw d6 (domain A–F) and d4 (depth 1–4): that is your table. Six cells of the 24 are
shaded; landing on one is a **stripe**: throw 2d6 on the ladder (light ≤3 BAD, ≥4 GOOD; dark = rung;
doubles: also a shaping throw) — then throw the index again for your trait.
**Trait.** In the table: light die = the trait row, dark die = the level column (L1 faint … L6 extreme).
**Sevens on the entry throw only:** light high (4-3, 5-2, 6-1) → level +1, **load-bearing**; light low
(3-4, 2-5, 1-6) → level −1, **background** (fork F9: his call whether low-first also rises).
**Doubles, any throw in a table (1/6):** the trait gets stronger. High doubles (4-4, 5-5, 6-6) → same
trait, level +1. Low doubles (1-1, 2-2, 3-3) → the next row down (row 6 curves to row 1), level +1.
Throw again; stop on the first non-double. 6-6 also sends you one table deeper in the same domain (depth
4 → the index).
**Calling.** One plain 2d6 on the callings table for every persona.
**How many.** Four traits for a sketch, nine for a short work, seventeen for a long one.
**Levels are words, not scores.** The sheet records the dice in the margin; never re-roll a roll you have.
**System actors** (`actor: system|software|host|place`, the default): the BAD ladder is what you watch
for in yourself, never what you do; a `wired: yes` sheet needs the watcher contract (§9.2).

### 9.4 Forks for the keeper (dealt, not decided)

1. **F9** — on the entry throw, does a low-first seven *lower* the level (background, −1, as built) or
   *raise* it like every other bump (H3's word)? One line either way.
2. **Hench/mench naming** — the extreme gate is a *normal ↔ extreme* dial; "hench → mench" reads as a
   *bad ↔ good* slider (R3). Keep the name and let the max-extreme odd/even pick the pole, or rename.
3. **The watcher contract** — a separate artifact (schema + lint) before any `wired: yes`; who writes it
   and where it lives (ccspt? the seat?) is his call. The kit will refuse `wired: yes` without it.
4. **Middle rungs of the ladders** (`[MINE]`) — his to rename; the poles are his already.
