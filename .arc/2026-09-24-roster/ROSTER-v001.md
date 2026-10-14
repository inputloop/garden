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
  lapse is unresolved.
- **Two copies of every tool exist** (`AS4CE0001/bin/` and `c4/h/`) and they
  differ. Which is master is unresolved.

## What is NOT here

No real person's facts. The signed standing grant
(`GRANT-persona-drive-2026-09-01.md`) names the boundary — case facts, family,
third parties, secrets, credentials — and this roster and the source book were
both checked against it by command. These sheets describe an instrument, a
place and a bakery.

sentinel: PERSONA-ROSTER-2026-09-16-v001
