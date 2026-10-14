---
# MODEL — PERSON as an intrinsic of C4: a feature working toward publication
Stand-alone static model, 2026-09-04 (late), Fable as Mentat (Vibrobeast, Cowork) for Corwin.
Viewpoint: the *person* intrinsic itself — what C4 already holds about persons, what the
slide's numbers do to persons, and what it would take to publish the feature without
publishing any person. Status: CANDIDATE. Every claim carries its source in the tree; where
a reading is mine it says `[MINE]` and names the check that would dissolve it. Copies:
`/f/claude/AS4CE/AS4CE0001/h/` (master) and `/f/claude/c4/h/` (same bytes at copy). LENS
companion: `LENS-2026-09-04-person-intrinsic.md` (subject pinned by sha; GRAIN = 4 models).
---

## 0. Mentat's preface

*It is by will alone I set my mind in motion.* The ledgers prove; the journal explains; and a
person is the one thing in this shop the ledgers must never try to prove — only protect. So
this model is written the archivist's way: I record what the tree says about persons, I
record what I inferred and mark it, and I list what I **refused to record** (§7), because a
person system that grows by accreting facts about people is the failure it exists to
prevent. Nothing below adds a fact about any named human beyond the tier they already
occupy in `evidence/personas.tsv`.

## 1. What "person" already is in C4 (the intrinsic, as the tree holds it)

**The person system is load-bearing by his word** (`decks/person-system.deck.md`, Corwin
2026-08-03: *"our load-bearing person system. I want to make it impossible, as a next move,
to ship without that."*). It has a baseline file, `evidence/personas.tsv` (19 rows today),
and a definition assembled from two installed canons:

- `magic-words-persona`: a skill's description is a magic word that reaches a **persona**
  via a **trait** (behaviour + fact) — persona and skill are two views of one thing.
- `tool-lifecycle`: guards split into **SAFETY (never electable)** and **persona-electable**;
  enumerate and harden the floor *first*.
- Joined: **a persona is a NAME + a REACH + the guards it may ELECT + a floor it may not
  touch**, and "impossible to ship without it" means *the shipping record must name the
  persona in play.*

**The tiers** (personas.tsv; four by design — "he likes sets of four when they come easy" —
plus a fifth that appeared in the data): **PERSON** (a human with standing; *not ours to
configure*: Corwin, Bryant, Dad, Dee, the Savannah hackers) · **SEAT** (a Claude instance,
distinguished by *reach* not character: the far seat, Claudewin) · **TRAIT** (a
magic-word-reachable bundle that elects guards: Mentat, the minions, the morality guard,
skilltank, skill-creator, the CANDOR face, the judge) · **GATE** (mechanical, never
electable: consent-gate, the GATE face, shelf-check, values-baseline) · **HOST** (gw7 — a
machine that "became a person" in the 2026-09-03 memory, i.e. gained standing in the
network as a place records are held).

**The register:** `bin/ep1nt` declares *E ENTITY — a person is an entity (register E, SCALAR
facet)*, and generates the **shippable baseline person** (`PERSON.md`) *from what is actually
installed*; *"CORWIN.md is the one file that never ships."* That sentence is the publication
rule for the whole feature: the *method* of being a person in C4 ships; the *case* never does.

**The seat distinction** is the one the instrument has been sloppiest about (person-system
deck): *"I have been signing 110 cards `owner: claude` as though there were one of me."* Two
seats with different reach are two actors; a claim from one is not a claim from the other.

## 2. The floor (what a person may never elect away)

`evidence/safety-floor.tsv` — 17 rows: **6 HIS · 5 MINE · 2 MECHANICAL · 4 ELECTABLE.** The
test that keeps it from becoming a wish-list: *a row belongs on the floor only if its
absence would not be felt for a long time* (a consent check announces itself once, years
later). His six, verbatim in the file: no wrong with entrusted systems and authority · no
concealment from investigations, including one surfacing his own mistake · **only Corwin
installs COPYING** · `Z/ a/ p/` fenced · never block a user from overwriting what they feel
they must · **mechanical checks are tooling that may CONTROL AI and may NOT GRANT AI ENTRY
INTO SYSTEMS.** The deck names the third as *"the best-formed rule in the shop"* — one actor,
one file; it makes a class of error impossible rather than detectable. Every floor row
should aspire to that shape.

The **electable** column is short on purpose (four rows: how much I explain before acting;
lead with risk or opportunity; header verbosity; prose genre). A long one would be the
failure.

## 3. Person-facts, consent, and the reader who is a person

- **Third-party person-facts need consent before they persist** — governs *facts about a
  person that we record*; corrected in `decks/empty-copying`: a person *using a service* is
  not a person-fact we record ("paperwork before a person has done anything" is the wrong
  object). Family is off-limits; Dee is a named non-participant
  ([[federation-expansion-gate]]); the Z register carries *embargoed person effects*
  (`decks/orgc4-conceit`).
- **Disclose the possibility, not the instance** (`decks/accountability-first`,
  `decks/disclosure-practice`): publish where *the person bearing the risk* can see it, and
  ask *could they act differently after reading it?*
- **The reader is a person** (`decks/deck-as-return-channel`, `degrade-honestly`,
  `known-impossible`): *"the person who has to peel what we made apart to fix us will not
  thank us for making our tool…"* — his own #1 requirement. Publication is shaped for that
  reader, not for the archive.

## 4. The slide and the numbers, as they bear on persons

The name `AS4CE` is a **slide**: a balanced pair around a run-level digit, the pattern
`bin/ep1nt` declares for itself (*"Five characters, run-level in the middle, AS4CE
pattern"*) and every `he2ma`, `sc3dm`, `a4ddr`, `do0r` in `bin/` repeats. His expansion,
2026-09-04: **`asce` = Application Spoke Command Environment**, read backwards **`ecas` =
Container (Containment) Environment for Application Spoke** — an invertible, taxonomically
linked pair; the "S" is Spoke or Scalar and either serves static analysis. C4's first
question of any slide: *is either side balanced, and how long is it?* Here: balanced, four.
A test frame nests the same way — `WHTV asce … ecas VTHW` — outer pair a test, inner pair
the application; balanced-parentheses checking makes the syntax tree reversible ("define
two tests": walk in from both ends, they must agree).

**Run-level four is the base**: fully operational — restart the service to change what the
literate/ghostwheel-managed package provides. The digit in the slot, as it bears on
*persons*:

| slot | his name | what it means for persons (his material, condensed) |
|---|---|---|
| ≤ 4 | GRAIN (default) | one operator's application, fully operational; inferred from the balanced length, or stated by `$0` if lower and the name matches — walking from either side must give the same value. |
| 5–8 | (set selection) | the number is *revolved* `S → ii ← S` so known-in-advance values S1, S2 map indirectly — a different context (sub-class, fork, branch) enters by swapping **one number** in C4, one string in C4META/C4QL, or one ENV var under `.fn.sh`. |
| 9 | GREAT | **cyclic, multi-participant**: the plan travels until receipts stack. Skills and MCP services see it as preferences/defaults and defaults/settings, so *care is required not to leak bespoke persona indirectly*. **Apps may be a voice within their own domain** if well-behaved in public comms and carrying **a clear journal of their legacy**, so development along that voice can be substantiated — a check *separate* from version and `stat(1)` meta, spotting long-ago versions at a glance. |
| 10–16 | (set selection, +9) | same revolve, selecting for the GREAT treatment: the context is **externalized** (multi-garden). |
| 17 | GRAND | **org-to-org**: delegations, congressing, campaign arcs orthogonal to "plot" for various characters — while preventing opportunism for unsavory conditioning (his words held, not expanded). **Each local viewpoint** — a record as transacted, from/for each cooperating mint or persona bastion on the logical network — **has its own Palace** keeping a careful *floor* grounding the issue in the story of that shop and its participants: a separately-sourced *"where'd you hear that?"*, checkable at least at the bastion (a credible public mint: HTTP/S and DNS in good order, provisionally). Lots of data; a party of equals peering with another Ghostwheel may stand up the **smallest ring set and proxy the rest** through to its physical stores via its own poly/ccspt-shaped tooling. |
| > 17 | palace picker | choose among Palaces. |

**The math, `[MINE]` — one falsifier: his ack-counting units, withheld today, say otherwise.**
4 · 9 · 17 is 2² · 2³+1 · 2⁴+1: each grain adds one bit of reach and **one hub**. At GRAIN the
name is 2+2, balanced, no hub — a single operator needs none. At GREAT, eight spokes and
one hub — the hub is the *domain* whose voice the app may be. At GRAND, sixteen and one —
the one is the **Palace**, the floor-keeper per local viewpoint. The between-values are
selectors of width 3 and 4 bits (8 and 16 contexts), which is exactly what "swap one number
to bring a fork into context" needs. Read this as a picture that fits, not a fact from the
tree; the tree's own ladder stops at run-level four and gf-01 says the interesting entities
*start above it*. GRAIN and GRAM are the same word here; "kinds of measure" is his to open.

## 5. Opportunities — the feature toward publication

1. **`PERSON.md` is already the publication shape.** `ep1nt` generates the baseline person
   from what is installed; CORWIN.md never ships. *Method travels, cases don't* — the
   feature can be published as a generator plus its two TSVs without a single person-fact.
2. **Voice as a provenance check.** GREAT's rule — a voice within its domain, well-behaved in
   public, with a journal of its legacy — gives a **second check beside version and `stat`**:
   consistency of voice across time is legible at a glance and is not forgeable by editing
   a timestamp. The persona corpus (`PERSONA-CORPUS.md`, hash-mirrored to Drive under a
   signed standing grant) is the seed of that journal.
3. **The person system is the interface contract for peering.** At GRAND, two Ghostwheels
   peer by agreeing what a *local viewpoint* is and where its Palace keeps its floor. The
   tiers table is small, sourced, and pub-safe by construction — it is the document a peer
   would read first.
4. **"Where'd you hear that?" becomes answerable across gardens.** Each Palace is a
   separately-sourced floor; a bastion answers at HTTP/S + DNS; ccspt's consent statement
   (`deliberate | consensual`, bound to the payload's sha256) is the receipt shape a
   person-bearing record travels with.
5. **The slide is publishable syntax.** Balanced pairs with the run-level in the slot are a
   naming convention a stranger can check by hand (`ep1nt` explains itself in its header);
   the "define two tests" rule is a linter waiting to be written.
6. **Consent-first is a differentiator, not a cost.** The floor's *one actor, one file*
   rule (COPYING) and the *may control AI, may not grant AI entry* rule are the two
   sentences a publication should lead with; they are what a reader who hosts things will
   test us against.

## 6. Challenges — what publication would meet

1. **Q166: the person system is unenforced** (`decks/person-system-unenforced`, 2026-08-29):
   `h/meme.sh compose` *reads* personas.tsv now, but *a reader is not a gate*. Four buildables
   and they are different systems — ship-gate (`sc3dm` refuses a record naming no persona),
   compose-gate, load-gate, or **reference-only** (retire the obligation; "the one nobody
   proposes"). A published feature must say which it is. Falsifier already on the card: *a
   ship whose record names no persona and no tool refuses it.*
2. **Indirect persona leakage at GREAT.** Skills and MCP services carry defaults/settings;
   a bespoke persona leaks through them without anyone publishing a person-fact. The very
   care C4 exists for: audit the *defaults* a shipped skill ships, not just its prose.
3. **The floor vs. the electable set.** Publication invites others to elect; the floor must
   travel *non-electable* in the artifact itself, not in a README. His floor rows are the
   test cases.
4. **Seat ≠ trait ≠ person.** The instrument's own sloppiness (110 cards as one actor) is
   the confusion a publication would export. Every claim must carry its seat.
5. **Anti-conditioning at GRAND.** His words: prevent *"opportunism for unsavory
   conditioning"* across orgs. Held verbatim; the mechanism is the Palace floor per
   viewpoint — a story that can be checked, not a mood that can be steered. Not expanded
   here; a floor row, not a feature.
6. **Data volume at GRAND** → smallest ring + proxy; the design must say what the smallest
   ring *is* before a peer asks.
7. **The bastion's credibility floor is thin by design** — HTTP/S + DNS "in good order,
   provisionally" is layered-assurance L1: weak, honest, and it must say so on the tin.
8. **The withheld unit.** Anything modelled above four here is provisional until his
   counting units land. This file says so rather than guessing them.

## 7. What Mentat refused to record (the discipline, shown)

- No new fact about Dad, Dee, Bryant, or the Savannah hackers beyond the tier they hold in
  `personas.tsv` — the PERSON tier is *not ours to configure*, and family is the line.
- No expansion of "unsavory conditioning" into examples; his phrase, his floor.
- No guess at the ack-counting units; the phrase "GRAIN/GRAM are the same here" is recorded,
  the rest is marked withheld.
- No claim that the 2ⁿ+1 picture is C4's — it is filed `[MINE]` with its falsifier.
- Both standing attestations held while reading his Z-adjacent material: nothing
  entrusted was touched, and every read is in this session's record.

## 8. LENS

Subject = this file, pinned by sha256 (`LENS-2026-09-04-person-intrinsic.md`); four
independent models (GRAIN = 4, the local default maximum), each giving a stance and a
claim on the six views; convergence by exact stance token. The result and the microscope
summary are in the companion, not here — so this file stays the pinned subject.

---
*Footer — provenance. Sources, all in `/f/claude/c4/`: `decks/person-system.deck.md` ·
`decks/person-system-unenforced.deck.md` (Q166) · `evidence/personas.tsv` (19 rows) ·
`evidence/safety-floor.tsv` (17 rows) · `bin/ep1nt` (header) · `decks/gf-01-the-token`,
`word-load-bearing`, `it-curiosities`, `empty-copying`, `accountability-first`,
`disclosure-practice`, `deck-as-return-channel`, `degrade-honestly`, `known-impossible`,
`orgc4-conceit` · `MEMORY.md` 2026-09-03 (Planning Palace; gw7) · Corwin in chat 2026-09-04
(the slide expansion and the number cases, verbatim where quoted). Fable as Mentat; Corwin
decides what stays.*
