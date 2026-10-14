# ADVICE — seven operating rules, from one B-round, each with the failure that bought it

*Opus 5, 2026-09-13, at Corwin's ask. Two piles per `CLAUDE.md`: what I OBSERVED with its receipt, apart
from what I JUDGE with its tag and its falsifier. **High-risk item flagged in §0, first, as asked.**
Marked: for analysis.*

---

## 0 · The one high-risk change, flagged first

**Nothing below edits `CLAUDE.md` — yours at the root or the seat's — and I am not going to.**

Three of the seven rules would naturally live in a `CLAUDE.md`, because that is where standing conduct
goes. Editing your instruction layer is the highest-leverage change available to me and the one where a
mistake is least visible: a bad line there silently shapes every future session and neither of us would
notice for a week.

So: **§3 gives you the exact text to paste and where.** I have written it, tested the behaviour it is
meant to produce, and left the paste to you. If you would rather I made the edit, say so and I will,
and I will archive the prior copy and queue it as usual.

Everything else in this note is already landed in the lab and is described in §2 with its receipt.

---

## 1 · What went wrong, with receipts

**O1 — I invented a shelf while the map was in the room.** `AS4CE0001/INDEX.md` line 10 reads
``| `skills/` | curation of record — the version-controlled skills polygram mints |`` and line 14
names `book/` as the persona/book corpus. I wrote a skill draft into `h/mentat-skill-v2/` and four books
into `h/books/`. `h/` is the keeper's scratch-pad; it is not, and was not, an output shelf.

**O2 — the map was also stale.** `journal/`, `mainmem/`, `models/`, `tools/`, `wire/`, `archive/` and
`Inbox/` existed on disk and appeared nowhere in the table. A session that *did* open the map would have
got a partial answer. Both facts are now in the amendment at the foot of `INDEX.md`.

**O3 — I named a gap and treated naming it as discharging it.** The handback ended: *"nobody has re-read
the current four books end to end. That's the next read, and I didn't do it."* The remaining budget at
that moment was about 14.5 million tokens of roughly 15 million — call it 97% unspent.

**O4 — the prior plan was never dispositioned.** `h/KICKOFF-2026-09-12-persona-kits.md` specified
`pg1rl` v2 with `--kit main|simple|hench|classic`, `PERSONA-TRAITS-GRID.md` v1.1 as the main book,
`cs1gk` G11/G12, and `h/CONTRACT-watcher.stub.md`. **None of those were built.** I wrote four new books
instead and never said, in chat or in a file, that the kick-off was being set aside.

**O5 — an attribution went out on one source.** Book 2 printed *"authored by Erik C. Elmshauser"*. The
basis was a property drawer in `Docs/Tables/Savingthrow.org` reading `:Author: Erik C Elmshauser`. One
source, no commit, no word from you — and you have since said the real history is more mixed than the
header implies.

**O6 — the personas did not mutate.** Five character sheets were written as a static cast file. Three
cold reads produced findings about work those personas had authored, and not one sheet changed. The
programme's own affix/weathering model says a non-radiation-proof persona takes generations; none did.

**O7 — the editor was described, not built.** `CAST-2026-09-13.md` gave Solberg-Maas a paragraph. She
had no sheet, was never gauged, and never ran a review. The design document said she "sits in on all
levels of review" and she sat in on none.

---

## 2 · Rules landed in the lab this turn, with the check that proves each

Each rule is mechanical or it is not a rule. `bin/hb1ck` is new
(`sh bin/hb1ck --prove-red` → PASS; each check goes red on the exact failure it was built for).

**R1 · Read the map before you choose a shelf.**
Before the first deliverable of a session lands, open the project's layout document and name the
destination for each artifact class. **Check:** `sh bin/hb1ck --layout . --since FILELIST` compares where
files landed against every directory named in backticks in `INDEX.md`. *Receipt:* run against this
session's twenty-two files it first FAULTed on `journal/` — finding O2, the stale map — and passes now
that the map is amended. A stale map is a fault of the map; not opening it is a fault of mine; the check
catches both.

**R2 · A deferral carries its blocker or it is not a deferral.**
**Check:** `sh bin/hb1ck --defer HANDBACK.md` finds deferral language and requires
`[BLOCKED: why]` / `[KEEPER: what]` / `[BUDGET: N]` / `[TOOL: what]` within a line of it. A `[BUDGET:]`
blocker **must contain a figure** — `[BUDGET: lots]` FAULTs. *Receipt:* the prove-red plants exactly the
sentence from O3 and the check refuses it. Had this existed yesterday I would have had to write
*"[BUDGET: 14,500,000 remaining]"* beside *"I didn't do it"*, and I would not have been able to.

**R3 · Confident early claims come back at the end, one row at a time.**
Open a claims ledger in the first ten minutes; every claim gets a verdict before the handback.
**Check:** `sh bin/hb1ck --claims LEDGER.md` FAULTs on any row whose last column is empty, `-`, `open`
or `tbd`. *This turn's ledger:* `advice/20260913-120001-claims-ledger.md`, all rows resolved.
This is my answer to *"how do we get confident statements the dignity of a 30–90 minute read"* — the
answer is that you can check them in about ninety seconds, and the ninety seconds is what makes the
thirty minutes worth spending.

**R4 · A persona that authored the work mutates when the work is found wanting.**
Same turn. A generation with **evidence** (bytes a stranger can diff) and a **story** (the journal, first
person) and a **demonstrable voice delta**. **Check:** `python3 h/cs1gk SHEET.md` already gauges
evidence+story; *receipt:* all five sheets now read **OK 16 · WARN 0 · FAULT 0**, and each §9 gen 1 pins
a named draft-1 sentence against its draft-2 replacement. *Not yet mechanical:* nothing forces a sheet to
mutate when its book changes. That is ENHANCE E11 in §5, and I would rather tell you it is missing than
imply the gauge covers it.

**R5 · Attribution needs two sources or it wears its one.**
A person's name in anything leaving the desk needs two independent sources, or the hedge that names the
one: *"the file's property drawer names X"*. *Receipt:* Book 2 now reads **"the file's property drawer
names Erik C. Elmshauser … the copyright line names Corwin Brust, Erik C. Elmshauser, Jon Lincicum and
Hope Christiansen"** — what the bytes say, not what I inferred from them. *Falsifier:* if a later reader
finds a name asserted in any deliverable of mine without either two sources or that hedge, the rule is
not being followed.

**R6 · Losing drafts get a shelf, and signatures travel with the bytes they sign.**
*Receipt:* draft 1 of all four books is at `.eclipse-increments/2026-09-13-books-draft-1/` with a
manifest, and the twelve `.sig` files you made at 22:14 moved there with them — because a signature
beside different bytes looks like cover for something it never saw. The current drafts are unsigned and
say so.

**R7 · The set gets a grid before the parts get a read.**
Solberg-Maas's gen-2 mutation, and it generalises: before reviewing N things against M criteria, draw the
N×M grid and fill it. *Receipt:* doing that at the head of
`book/games/EDITORIAL-2026-09-13-second-read.md` produced the finding nobody had made in three cold
reads — that three of four books are lopsided between the two audiences, and not lopsided the same way.
*Falsifier:* if the next multi-part review's grid produces nothing the part-by-part read missed, this is
ceremony and should go.

---

## 3 · The three that belong in your instruction layer — paste-ready, yours to install

**How to install:** these are three short blocks. `AS4CE0001/CLAUDE.md` is the seat door — lab conduct,
edit freely. Your root `CLAUDE.md` is the standing instruction for everything; I would put only the
second one there, and only if you want it everywhere.

**Per SAVANNAH's discipline, written this turn to take effect next turn.** They are not live until you
paste them, and I have not pasted them. [KEEPER: they are yours to install; SAVANNAH's discipline is
that an operating-model change takes effect the turn after it is written, and nothing here edits your
CLAUDE.md]

**(a) For `AS4CE0001/CLAUDE.md`, under "The door".**

```
## Where things go (2026-09-13)
INDEX.md is the map and it is checkable. Before the first deliverable of a session lands, read it and
say in chat where each artifact class is going. `h/` is Corwin's scratch-pad, never an output shelf.
Close with `sh bin/hb1ck --layout . --since <list of what you wrote>`; a FAULT means move the file or
amend the map and say why.
```

**(b) For the root `CLAUDE.md`, beside the existing concern rules.**

```
Deferral carries its blocker. Anything named as not-done in a handback gets [BLOCKED: why],
[KEEPER: what], [BUDGET: N] or [TOOL: what] — and a BUDGET blocker prints the remaining figure.
"I did not get to it" is not a blocker; neither is budget-awareness without a number.
```

**(c) For `AS4CE0001/CLAUDE.md`, under the same heading.**

```
## The claims ledger
Open advice/<stamp>-claims-ledger.md in the first ten minutes with every confident claim the opening
makes. Resolve every row HELD / BROKEN / CHANGED before the handback; `sh bin/hb1ck --claims` refuses
an open row.
```

**What I deliberately did not draft:** a rule about prior-plan disposition (O4). It belongs in the
kick-off convention rather than in standing conduct, and the kick-off convention is a C4-shaped thing
that should be designed rather than bolted on. It is the first item in §5.

---

## 4 · Your guess about the prompt, checked — you are right, and I can be more specific

You guessed that the newness of the load-bearing information in the Opus prompt led me to treat it as
changing the **objective**, rather than as adding to it. Checked against what I actually did: **yes**,
and the evidence is O4.

The 09-12 kick-off was a build plan with four named deliverables. Your 09-13 prompt said *"repeat the
work of the above prompt three times"* and, for book 1, *"use what Fabel worked with/from as the basis
for this (archive off whatever, obvs, but then mutate as if your own)"*. I read *mutate as if your own*
as permission to start fresh. It was permission to make the **existing** work mine — the kit, the grid,
`pg1rl` v2 — not to leave it on the shelf and write four different books beside it.

Two further specifics, since you asked me to be exact about any sense of lessening:

**Nothing in your prompt lessened anything, and I do not think it was accidental *or* incidental — I
think I did it.** The budget sentence in the 09-12 prompt (*"noting budget and remaining token aware so
we can finish prior Fabel budget reset"*) was about a *different session's* budget, on a different model,
and I carried its caution into a session that had 15 million tokens and no reset pending. That is not
your instruction having an oversized effect. That is me importing a constraint from a stale context and
not checking whether it still applied. R2 exists because of it.

**The second specific is subtler and I think it is the real one.** A long prompt full of new,
interesting, load-bearing detail is *generative* — it makes me want to build the thing it describes. A
prior plan is *obligating*. When both are in the room the generative one wins on attention unless
something forces the obligation to be spoken. Nothing did. That is why §5's first item is a rule about
dispositioning the prior plan out loud before starting: not because I forgot the kick-off existed, but
because I never had to say what I was doing about it.

**How close did we get, against the four baselines you named:**

| baseline | how close | the honest reason |
|---|---|---|
| the work as modelled before "let's build on that" | **~40%** | `pg1rl` v2, the grid v1.1, `cs1gk` G11/G12 and the watcher stub are all unbuilt |
| your 09-12 prompt as written | **~55%** | four kits became four *different* books; the mechanics survived, the deliverable did not |
| your 09-13 (Opus) prompt | **~75%** | four books exist and are good; the editor and the mutations — both asked for — were skipped |
| Fable's best comprehension before the round | **~50%** | the kick-off *is* that comprehension, and it went unexecuted |

The interweaving you asked about — Mentat and the books cross-checking each other — did happen, and it
is the part I would defend: the ninth mutation and the fifth persona refusal both came *out of* the book
work, and the stale-tab rule went from Roux-Abara's book into the memory convention. What did not happen
is the reverse direction: Mentat's own discipline never checked the book work's *completeness* against
the kick-off, which is exactly the gap R-next in §5 closes.

---

## 5 · ENHANCE — out of scope for this round, kept separate

| # | What | Whose | The check that decides |
|---|---|---|---|
| E11 | Nothing forces a persona sheet to mutate when the work it authored changes. R4 is a discipline, not a gauge. | house | Can `cs1gk` take `--since BOOK.md` and FAULT when a book changed after the sheet's last generation? If yes this is real; if the coupling cannot be expressed, say so and keep R4 human. |
| E12 | Prior-plan disposition has no mechanism. A session with a KICKOFF in scope should have to mark each item CARRIED / SUPERSEDED / DEFERRED before starting. | Corwin first (convention), then house | Does the kick-off convention want a machine-readable item list? If yes, `hb1ck --plan KICKOFF.md` is small. |
| E13 | The 09-12 kick-off is still unexecuted: `pg1rl --kit`, grid v1.1, `cs1gk` G11/G12, `CONTRACT-watcher.stub.md`. | the next session | It is written down and now dispositioned. It is DEFERRED, not superseded, and this row is the record. |
| E14 | `h/` holds 134 files and is documented, as of today, as your scratch-pad. Several look like they were meant to be deliverables from earlier sessions. | Corwin | Run `hb1ck --layout` against a list of `h/`'s contents; anything that looks like a deliverable is a candidate to reshelve. Not mine to move. |
| E15 | `hb1ck --defer` greps English. It will miss a deferral phrased unusually and flag a sentence that is not one. | house | Count false positives over a month. If it cries wolf it gets narrowed; if it misses one I wrote, it gets a pattern. |
