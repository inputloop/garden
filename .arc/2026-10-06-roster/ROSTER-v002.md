# The character sheets — a roster

*Not a manifest. A manifest says which bytes; this says what they ARE, so that
somebody holding only this page knows what exists, what each one is for, and
how to check it. Kept beside `PERSONA-CORPUS.md` on Drive as the readable half
of the same set.*

**Assembled 2026-09-16.** Every "how to check" line below was RUN, and the
result it claims is the result it printed. Where something did not run, the row
says so.

---

## The three

### Mentat — the instrument at the seat
**actor:** `system` · **master:** `AS4CE0001/h/CHARACTER-2026-09-06-mentat.md` v1.1
**inventory:** `…-mentat.tsv` · **picture:** `h/DIAGRAM-2026-09-06-sheet-mentat.{svg,png,txt}`
**journal (after the radiation-proof eight):** chained generations in the seat's persona store,
read with `persona_read mentat` — gen 1, 2026-09-30 (curating fact, one meaning per word, custody of
the lab); gen 2, 2026-10-04 (a guest acts only inside its permit). The master sheet is unchanged.

The one that does the work: counts before it speaks, hands back a card rather
than a request, and holds a line it will say out loud. Eight generations of
mutation are recorded on it as skills, each with the note that produced it —
so the sheet is also a history of what it learned to stop doing.

    cd AS4CE0001/h && python3 ../bin/cs1gk CHARACTER-2026-09-06-mentat.md --twin ../../c4/h
    → cs1gk: OK 18 · WARN 0 · FAULT 0 · NOTVISIBLE 0

### The Garden (shopgarden) — a place
**actor:** `place` · **master:** `AS4CE0001/h/CHARACTER-2026-09-05-shopgarden.md` v1.2

A place, not a person, and the distinction is load-bearing: it has benches and
a reach rather than motives. Its own §8 rules that a place lives in its own
tree, which is why its master sits in one tree and its bench paths point at
another — a fact about the design, and a trap for a reader, both.

    cd AS4CE0001/h && python3 ../bin/cs1gk CHARACTER-2026-09-05-shopgarden.md --twin ../../c4/h
    → cs1gk: OK 18 · WARN 0 · FAULT 0 · NOTVISIBLE 0

### gw7, the bakery — a host
**actor:** `host` · **master:** `c4/h/PERSONA-gw7.md` v002 (the reference instance)

The worked example the other two are measured against. It carries three open
WARNs on purpose — no guards named, one growth paragraph without its evidence,
no break-character watch — and they are open because closing them means
*writing persona*, which is the keeper's pen and not the instrument's.

    cd AS4CE0001 && python3 bin/cs1gk ../c4/h/PERSONA-gw7.md --corpus PERSONA-CORPUS.md
    → cs1gk: OK 14 · WARN 3 · FAULT 0 · NOTVISIBLE 0

---

## How to read a sheet you have never seen

A sheet has an **actor kind** (`system` · `place` · `host` · `fiction`), which
tells you what kind of thing it is before anything else. It has **intrinsics**
(what it is), **skills** (what it can do, each one dated to the note that grew
it), **possessions** (its tools, each with that tool's own test count), and
**prohibitions** — the things it will not do, which are as much the character
as the abilities.

The `.tsv` beside each master is the same content as rows, double-entry: every
row names its own source. A claim on a sheet with no source is data, not
evidence, and the gauge counts that.

## The gauge

`bin/cs1gk` checks a sheet against its own form and, with `--twin`, against its
copy in the other tree. `sh tests/cs1gk-tests.sh` → **22/22**. It has a
`--prove-red`: a gauge that cannot fail is not a gauge.

## Everyone, as of 2026-09-24 — the roster above named three; there are sixteen

The three above were never the whole cast. Every sheet and person model in the
shop, found by ONE rule: a file is a sheet by what its own first lines say — an
`actor:` line, a `# CHARACTER SHEET` / `# ITEM SHEET` / `# PERSONA` heading, or
front matter whose `name:` is described as a persona or a model. The file name
is only an address. The persona MCP server applies that rule (`persona_list`),
and `sh tests/persona-shelf-tests.sh` holds a second, awk reading of the same
rule against it, on fixtures and on these very folders.

**Characters** (on Drive `ComputerPeople/persona/`, byte-for-byte):

| name | what it is | master |
|---|---|---|
| mentat | system — the instrument at the seat | `AS4CE0001/h/persona/CHARACTER-2026-09-06-mentat.md` |
| shopgarden | place — the Garden as C4 sees it | `AS4CE0001/h/persona/CHARACTER-2026-09-05-shopgarden.md` |
| gh7 (was gw7) | host — the bakery on the ring; renamed 2026-09-25 at his word: gw7 is the node, gh7 the host persona (a `name:` line in the sheet; the file keeps its address) | `c4/h/PERSONA-gw7.md` (seat copy in `h/persona/` now agrees) |
| penumbra | system — eclipse-pass's fond archivist | `pub/method/h/PENUMBRA.md` |
| pub | place — an ITEM sheet: a word that is also three rooms | `c4/q/words/pub.ITEM.md` |
| ilunga, pell, roux-abara, vanth | fiction — the four game-book authors | `AS4CE0001/book/` (twins in `c4/h/cast/` agree) |
| solberg-maas | fiction — the four books' editor | `AS4CE0001/book/SOLBERG-MAAS.md` |
| merlin | synthetic — a withhold-experiment stand-in, not a person | `AS4CE0001/book/MERLIN.md` |

**Person models** — models of real people. Served locally by the same rule;
**kept off Drive** under the grant's boundary (case facts, third parties):
`corwin` (`modelthisbook/CORWIN.md`, also `book/`; agree), `bryant` (two
DIFFERENT copies: `book/BRYANT.md` v1.0 and `modelthisbook/BRYANT.md` v0.2 —
Bryant's to reconcile, not ours; **Corwin, 2026-09-25: take the newer, `book/BRYANT.md` v1.0, as the better one** —
the server already serves it first; updated models may join the set before the first publication), `bryant-mtb-stub` and `kelsey-mtb-stub`
(seeds, theirs to fill), `bryant-corwin-c4` (the joint model,
`modelthisbook/BRYANT_CORWIN_C4.md`). `CORWIN-SECRET.md` is never read past its name.

**Named in the registry with no sheet** (`c4/evidence/personas.tsv`): Dad, Dee,
the Savannah hackers (persons); the far seat, Claudewin (seats); the traits and
gates, which are skills. Vibrobeast has an operating model (`vibrobeast.md`),
not a sheet. The steward in `SOFT-SKILLS/nongnu-steward/references/` is a
template, a persona only once filled at someone's word.

## Known, as of 2026-09-16 — said here rather than discovered later

- **The tools moved on 2026-09-13**, `h/` → `bin/`, and the index note still
  prints the old path. Every command in this roster is the corrected one.
- **`PERSONA-CORPUS.md` is at v003**; the index note still says v002.
- **The corpus's fourth harvest (2026-09-13) has never been carried or
  hash-proven**, and three of its attributions do not hold: one quotation is
  not in the tree at all, and two are real sentences from other files
  attributed to sheets that do not contain them. They are quarantined in
  `QUOTES-source-book.md` rather than deleted, because a quietly removed bad
  quote is how the next hand re-adds it.
- **gw7 has no twin in the seat** — only its picture was mirrored. Decision or
  lapse is unresolved. *(2026-09-24: `h/persona/PERSONA-gw7.md` is now a
  byte-identical twin of `c4/h/PERSONA-gw7.md`.)*
- **Two copies of every tool exist** (`AS4CE0001/bin/` and `c4/h/`) and they
  differ. Which is master is unresolved.

## What is NOT here

No real person's facts. The signed standing grant
(`GRANT-persona-drive-2026-09-01.md`) names the boundary — case facts, family,
third parties, secrets, credentials — and this roster and the source book were
both checked against it by command. These sheets describe an instrument, a
place and a bakery.

sentinel: PERSONA-ROSTER-2026-09-24-v002 (v001 kept at .arc/2026-09-24-roster/ROSTER-v001.md)
