# The C4QL tag: a bracket that points at a row

A tag is a short bracketed pointer you can drop into any text:

    [mentat (seam)two-columns-spine]
    [corwin (gloss)m/g:F:1]
    [bryant (counterpart)omni-tool]

It says three things: **who** wrote or shaped something (the persona), **which table** to look in
(the cast, in round brackets), and **which row** (the fact). A small tool, `bin/tg1rs` (tag 1
resolve), reads a tag, finds the row, and checks that the row and the person point at each other.
It writes nothing.

## Why a tag, and not a note in the margin

Corwin put the idea this way:

> the TAG part must be -or resolve into ... a table row identifier in a core context store/source
> when we evaluate the C4QL/TAG, and when we find the table we must find our usual doubly
> dual-linked references, in the entry and in the PERSONA journal

A margin note like "I wrote this part" weighs the page down and can't be checked. A tag is light on
the page and can be checked any time: who-wrote-what lives in the records, and the page only points
at them.

**C4QL** is the C4 Query Language, the C4 form that "looks": it asks the system about itself. Square
brackets are already its fence in C4 (`c4/facts/three-languages-compose-assy-meta-c4ql`), so the tag
is C4QL written small.

## Reading a tag

    [ PERSONA  (CAST)FACT ]
      |         |    `-- the row key: a foo-bar-baz slug, or a table's own key
      |         `------- the cast: which table the key is a row of
      `----------------- who: a persona slug, read case-blind

The **cast table**, `conventions/c4ql-casts.tsv`, says where each cast points:

| cast | table | row key | who column |
|---|---|---|---|
| `seam` | the memory seat's notes (`seat:notes`) | the note's slug | a generation's `came-from:` |
| `gloss` | `c4/m/gloss` | `TABLE:LETTER:COL`, e.g. `m/g:F:1` | `SOURCE` |
| `counterpart` | `conventions/bryant-counterparts.tsv` | his skill's name | `source` |
| `tag` | `c4/m/tags` | the word (read case-blind) | none |
| `memory` | this garden's `memory/` | the file name without `.md` | front matter `by:` |

Two kinds of row help the others: `both` is an **alias** (in `m/gloss`, "both" means Corwin and
Bryant), and `known` lists the people `tg1rs sweep` may pick out of a prose column. A cast may also
be **indirect** (`cast:OTHER`), which lets C4 META weigh, or C4 ASSY walk, which table a word lands
in; `tg1rs` follows at most four hops. Four is a house number I chose, not one measured.

S9 proposed `LETTER` as the key for `tag`; I used the word itself, because
`[bryant (tag)gauntlet]` reads better than `[bryant (tag)G]`. One edit to the cast table changes it.

## The two links

- **Forward** (the entry names the person): the row's who-column names the persona, or a note's
  `came-from:` names `[[persona:NAME]]`.
- **Back** (the person names the entry): a generation in that persona's journal has a `leads-to:`
  line naming `[[FACT]]` or `[[CAST:FACT]]`, or a store note's citation log has a line by that
  persona.

These are the fields the store already writes (`polygram/mcp/dl2.py`, the two-columns skill); the tag
asks nothing new of a note.

## The five answers

Every tag gets exactly one word. Nothing is an error: a gap is an answer.

| answer | means |
|---|---|
| `LINKED` | the row exists and both links hold |
| `FORWARD-ONLY` | the row names the person; the person's journal doesn't name the row |
| `BACK-ONLY` | the journal names the row; the row doesn't name the person |
| `GAP` | the table can't be read here, there is no such row, or the row has no link either way; the reason says which |
| `WORD` | the cast isn't in the table, so the bracket stands for itself, kept exactly as written |

## Cost: why the persona side is cheap

From the persona side, `tg1rs persona NAME` reads one journal once and resolves everything it leads
to: n generations, one pass (Corwin's "n1 time for PERSONA side query"). From the fact side, "who
touched this row" has to check every journal against every row, which grows toward n² as stores
deepen, as he said it would. `tg1rs sweep` is that fact-side walk, and it reports counts, not
verdicts.

## Using it

    sh bin/tg1rs resolve '[bryant (gloss)m/g:A:1]'
    sh bin/tg1rs persona mentat                   # needs the seat, or --journals DIR
    sh bin/tg1rs scan README.md GRAMMARY.md
    sh bin/tg1rs sweep

Each answer is one tab-separated row: answer, persona, cast, fact, reason. `--seat`, `--journals`,
`--c4` and `--casts` point it at other places.

## What it found on 2026-10-10

`sweep` read 234 tags from the gloss and the counterparts table. All 234 answered FORWARD-ONLY:
152 rows of `m/gloss` name Bryant, 68 name Corwin (16 say "both"), 14 counterpart rows name a
person. None answered LINKED, because no journal generation I could read carries a `leads-to:` line.
Three personas have journals (mentat, vibrobeast, penumbra; two generations each). I read four of
those six generations through `persona_read` (both of mentat's and the newest of the other two), and
every one has an empty `leads-to:`. That is the true state, and it is the first useful output: the
back links are the work still to do.

## Dates live in the row

Corwin noticed the date-in-the-name habit: "a second reader for the temporal context of the initial
writing". The store already moved away from it: the generation file name lost its date in spec v3,
and the date lives in the note's `stamp:`. A tag gives that witness a home: the date belongs in the
journal row the tag points at, not in a file name.

## How this can be wrong

- If a real `leads-to:` line naming a row exists and `tg1rs` answers FORWARD-ONLY, the back-link
  reader is broken. Check: `sh tests/tg1rs-tests.sh --prove-red` plants exactly that.
- If people start writing tags whose cast nobody can resolve (many WORD answers in `scan`), the
  cast table is too small, or the tag form is too hard to remember.
- If a whole page of tags reads worse than the bylines it replaced, the tag is the wrong tool for
  that page.

Mentat (for Corwin; claude-opus-5-5)
Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
SPDX-License-Identifier: CC-BY-SA-4.0
