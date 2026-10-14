# DESIGN 2026-10-05: a light shelf for notes

*For Corwin. Mentat (for Corwin; claude-opus-5-5). A direction with a working prototype
(`c4 bin/sh1lf`, prove-red green under every awk on avalon). It answers his ask of today: a taxonomy more
abstract and universal than C4's twenty-six drawers, still prescriptive, a starter structure for a
person's notes, from which tools grow judgment about what words mean in context, and which draws
in compatibly licensed free knowledge with credit given implicitly, by the person's wishes,
without ceremony.*

## 1. What C4 gets right, and what makes it heavy

C4's register (`c4 man/derived/registers.org`) gives every word an address: a letter, and four
roles under it. For example, T is TEMPLATE as a scalar, TAXONOMY as a group, TEST as a command and
TAG as a tag. It is exact, and every hit of `fi1nd` reports its letter. The weight is that a
reader must know the letters before the shelf helps them, and a new person's notes do not start
with twenty-six of anything.

The memory store that this very session writes to is the opposite case: five shelves (profile,
preferences, topics, areas, people). Any person can start there. It is prescriptive, because each
fact has one right file. And it is light. What it lacks is everything his track asks for: words
have no home, ideas have no home, and the meaning of a word in a given context is kept nowhere.

The design takes the light shape and gives words and ideas a home in it.

## 2. What prompt engineering says a notes shelf must respect

From the prompt-engineer skill's context-management reference (Jeffallan's fullstack-dev-skills,
MIT):
- **Context is an attention budget,** and noise costs reasoning. So the shelf is read by need:
  the door first, then the ways, then only the shelf the work needs. The door stays under 40
  lines.
- **Primacy and recency (lost in the middle).** Each note says its claim first and its links last.
  A loader reads one `description:` line before it chooses a note.
- **Four buckets** (always present, immediate, retrieved, archived). These map onto the shelf:
  door and ways are always read; the area in hand is immediate; words and ideas are retrieved by
  the words the work uses; anything superseded is replaced, not stacked.
- **Context poisoning.** Stale lines are replaced in place ("PM on infra (previously search)"),
  never appended beside the new ones.

## 3. The shelf

```
door.md        read first: whose notes, what order (under 40 lines)
ways.md        how the owner wants work done, in their words; which sense wins when two differ
words/
  working.md   the working words: a fixed set (size: 17), rotated, never grown
  settled.md   the glossary: key (word.n), meaning, a source tag when the words are someone else's
  SOURCES      outside sources the glossary may use: tag, licence, where, credit line
  rotation.log every word in and out of the working set, with the rule that moved it
ideas/         one file per idea: a line for each place it matters, with a weight there (1 to 9)
people/ areas/ topics/   one file per subject; the first line says what it is
```

Four kinds of shelf answer four questions:
- door and ways: *how* to read and work;
- words: *what it means here*;
- ideas: *why*;
- subjects: *who* and *what*.

Nothing else sits at the top. A person starts with an empty seed (`sh1lf seed DIR`) and the
checks tell them where a note belongs.

## 4. Words: a fixed set, four prongs, two senses

- **The working set is fixed in size** and moves only by rotation. `sh1lf rotate DIR WORD` brings
  a word in. When the set is full, the least recently used word leaves. `sh1lf used` stamps use,
  and every move is logged. This is his "fixed size set rotated per rigid mechanical means forcing
  slow change". The size, 17, is a house number, invented, and it is declared in the file, not in
  the tool.
- **Four prongs per word.** His track names four prongs of meaning but not what they are. The
  nearest thing in his own work is C4's register, where every letter carries four roles: scalar,
  group, command, tag. So the seed's header reads *as a thing, as a set, as an act, as a label*.
  **This is my candidate, not his naming.** The header is a declaration: rename the four columns,
  and the tools follow without a code change.
- **Two senses, two stores.** Each working word points to a *reading* sense (how it is used when
  following a procedure) and a *writing* sense (how it is used when setting up context). Both are
  keys into the glossary, which is the "normalized reference path".
  - The two are contrasted only when they differ. Then the check raises JUDGMENT and asks for a
    line in `ways.md` ("word shelf: shelf.2"): the owner's own preference decides, and no risk is
    added that the owner has not seen.
  - Where they agree, nothing is said.

## 5. Ideas: weighted, said from each place, linked both ways

An idea's file holds one line per place it matters:

```
- in [[areas/garden]] (weight 9): how the garden names its makers
- in [[people/bryant]] (weight 4): what his bundle owes, and ours
```

Each line is the idea said from that place, with its weight there. Each place names the idea back
(`[[ideas/ladder]]`). The check holds both directions and prints the exact line to add when one is
missing. `sh1lf ring DIR IDEA` walks the places in order, each with its previous and next: his
"doubly linked referents (ring)".

## 6. Free knowledge, credited without ceremony

The glossary may hold meanings drawn from sources whose licences let their words sit in notes
under his terms (CC BY-SA 4.0 for prose):

| tag | source | licence | checked |
|---|---|---|---|
| oewn | Open English WordNet | CC BY 4.0 | its repository's README, 2026-10-05 |
| wikt | Wiktionary | CC BY-SA 4.0 (Wikimedia's move to 4.0, 2023) | Creative Commons' announcement |
| cnet | ConceptNet 5 | CC BY-SA 4.0, with the attribution sentence it asks for | conceptnet.io, 2026-10-05 |

- A borrowed meaning carries a short tag (`[oewn]`), and that is the whole of the ceremony.
- `sh1lf credits` prints the credit lines of only the sources actually used, in each source's own
  words, ready for a credits section or a colophon. The ladder's rung is credit for meanings
  taken in, and attribution for any long run of a source's words.
- The owner's wishes govern which sources are allowed at all: SOURCES is theirs to edit, as the
  parties file is for colophon.
- A tag not declared there is a CREDIT flag.

## 7. The prototype, `c4 bin/sh1lf`

```
sh1lf seed DIR | check DIR | ring DIR IDEA | credits DIR | rotate DIR WORD | used DIR WORD | --prove-red
```

- **Checks:** SHELF, DOOR, DESC, GROWN, UNLOGGED, SENSE, JUDGMENT, CREDIT, RING, WEIGHT. Each one
  is a rule the reader no longer has to remember: the track's "instructions only as
  tool/semaphore". Exit codes: 0 clean, 1 flags, 2 NOT CHECKED, 3 an unplanned stop with a heal
  prompt (`he1al`).
- **Prove-red:**
  - a green control on a small, consistent shelf;
  - eleven planted faults, each caught;
  - a plant that disables the ring rule, to show the rule is what catches the broken ring;
  - a rotation of a full set.
- **Status:** passes under every awk on avalon (gawk, mawk, nawk, busybox awk) and under busybox
  sh (`c4 tests/sh1lf-tests.sh`).
- **Not yet:** an index of words across the shelf (the mentcached word register does part of this
  and should be the reader); importing a gloss from a source file (the owner pastes it, with its
  tag); a second reader.

## 8. How it answers the track, item by item

1. **Instructions as tool or semaphore:** the rules live in `sh1lf check`; the door says only
   "the checks keep these rules".
2. **Ideas:** §5.
3. **Words:** §4. The rotation and the fixed set are mechanical. The prongs are a candidate,
   waiting for his naming.
4. **Reading and writing kept apart:** §4, contrasted only at JUDGMENT, and decided by ways.md.
5. **Operating model:** context stacking (the shelf's read order) against word tensioning (the
   working set). Experiment A below tests whether that spends fewer tokens for the same result.

## 9. How we would know it is wrong (experiments to run, not yet run)

- **A. Recall at a budget.** Seed a shelf from one real area of his. A fresh session gets only
  door.md and the shelf and answers twelve questions whose answers are in the notes. Compare
  tokens read and answers right against the same notes in the five-shelf memory and in C4.
  *Wrong if* the shelf reads more or answers fewer.
- **B. Drift.** Over two weeks of real work, track a working word's senses through rotation.log
  and the glossary. *Wrong if* meanings drift as much as they do for words outside the set.
- **C. Judgment rate.** Count JUDGMENT flags per week. *Wrong if* they are mostly noise (the owner
  answers "either") or never fire.

## 10. Open, for him

- Name the four prongs, or keep the candidate.
- Is 17 right for the working set?
- Should the shelf replace the five memory shelves for his own notes, or sit beside them as the
  home for words and ideas only?
- Seed one real area to run experiment A?

---
*Version 1.0.0: first edition on 2026-10-05; spine: 2026-10-05.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4:
https://creativecommons.org/licenses/by-sa/4.0/; Mentat (for Corwin; claude-opus-5-5)
