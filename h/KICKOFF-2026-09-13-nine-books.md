<!-- A kick-off prompt for a NEW session. Paste the section marked PROMPT. -->
<!-- Written by Mentat (for Corwin) 2026-09-13, in h/ at Corwin's express instruction. -->

# Kick-off: the first nine books

**What this is.** A mutated successor to `h/KICKOFF-2026-09-12-persona-kits.md`. It is meant to be
pasted into a fresh session. Everything above the PROMPT line is for Corwin; everything below it is for
the session.

**Status 2026-09-13, after Corwin's pass:** the three open choices are **ruled** (Chess · C4 ·
Traveller); the six tools moved from `h/` to `bin/` and every suite is repointed and green; draft 2 was
recovered from the keeper's own shelf zip and all three drafts are parked side by side. **This file is
ready to run.**

**What mutated, and why.** The 09-12 kick-off named four deliverables and the session that ran it built
none of them, because a generative prompt beat an obligating plan and nothing made the session say the
plan out loud. So this one opens with a disposition rule (E12) rather than a wish list. The 09-13 round
then found three more things the hard way: a reader's rubric we did not have when we wrote to it, an
editor persona that inherited its builder's blind spot, and a warning the tool had already printed that
the session read as reassurance. All three are folded in below.

**The one big change.** The first four books were written without knowing what a human reader would
measure. We know now — Bridget grades **Voice / Clarity / Potential** — so this session writes *to* the
rubric and is graded blind against it afterwards. That is the experiment getting sharper, not easier.

**The three choices are RULED. Corwin blessed all three on 2026-09-13; they are settled, not
recommendations, and the session does not reopen them.**

1. **Category 1 — Chess.** Public domain, universally known, bottomless, and it lets a book be about a
   thing everyone can already picture. Anything under live trademark would have been the wrong pick.
2. **Category 2 — C4.** Corwin's own, copiously described, and a book about it feeds back into it.
   Hard boundary: no case facts, no family, no third parties, so the Savannah forensics work is not
   source material for any of this.
3. **Category 3 — classic Traveller's lifepath.** It *is* a persona engine: rolled terms of service,
   acquired skills, and the notorious property that the character can die before play begins.

---

## PROMPT

You are opening a build session in `F:\claude\AS4CE\AS4CE0001` (`/mnt/AS4CE0001` from bash). Read
`INDEX.md` first; it is the layout map and `sh bin/hb1ck --layout .` checks it. `h/` is Corwin's
scratch-pad and is never an output shelf — this file living there is the exception that proves it, not
a precedent.

**SCOPE: GRAND.** Nine books. This is a long session and it is meant to be.

### STEP ZERO — disposition, before anything else

This kick-off is a prior plan, so dispose of it before you start work. Write
`advice/<stamp>-plan-disposition.md` with one row per item below, each marked **CARRIED**,
**SUPERSEDED** (say by what) or **DEFERRED** (with a blocker token: `[BLOCKED: why]`, `[KEEPER: what]`,
`[BUDGET: N]`, `[TOOL: what]`). Say the list out loud in chat. A plan you did not say out loud is a plan
the next generative idea will quietly beat.

Carried in from the 09-12 kick-off, still undone:

- `pg1rl --kit main|simple|hench|classic` — the four persona kits as selectable generators
- `PERSONA-TRAITS-GRID.md` v1.1
- `cs1gk` G11 / G12
- `h/CONTRACT-watcher.stub.md`
- `cs1gk --since BOOK.md` — FAULT when a book changed after its author sheet's last generation (E11,
  blessed 2026-09-13, still unbuilt)

Then, in the first ten minutes, open `advice/<stamp>-claims-ledger.md` with every confident claim your
opening makes, and resolve every row HELD / BROKEN / CHANGED before the handback.
`sh bin/hb1ck --claims` refuses an open row.

### The materials, and the help

Everything current is on the shelf. Use it; do not re-derive it.

| Where | What |
|---|---|
| `book/` | five gauged character sheets: SOLBERG-MAAS, VANTH, PELL, ROUX-ABARA, ILUNGA, each with a `.tsv` |
| `book/games/` | the four finished books (draft 3), the editorial, and `GRADES-2026-09-13-bridget.md` |
| `.eclipse-increments/2026-09-13-books-draft-1/` | **draft 1** — what Bridget graded. Corwin's twelve signatures live here |
| `.eclipse-increments/2026-09-13-books-draft-2/` | **draft 2** — the mutated-voice pass, plus the editorial that produced it |
| `.eclipse-increments/2026-09-13-books-draft-3/` | **draft 3** — Bridget's corrections applied; identical to the live shelf |
| `book/*.zip` · `book/*.7z` | Corwin's own full-shelf snapshots, one per round. The `.7z` also carries `h/.arc/`. All three drafts above were verified byte-identical to these |
| `bin/rf1bm` · `bin/pg1rl` | roll a persona: bias fold, trait grid, seeded |
| `bin/cs1gk` | gauge a sheet — target **16 OK / 0 WARN / 0 FAULT** |
| `bin/dc1sv` · `bin/pk1tv` · `bin/sh1ck` | diagram render · kits usage table · POSIX-sh footguns |
| `bin/gb1md` | render, lint, `--render`, `--thread`, `--voices`, `--prove-red` |
| `bin/mt1pl` | which persona this shop declares |
| `bin/hb1ck` | `--layout` `--claims` `--defer` `--park` `--prove-red` |
| `H:\arc\from\CCC4_G401\dungeon` | the real Dungeon corpus: 2d6, the pattern grammar, the 19-rung ladder, 4/9/17 |

**All tools are in `bin/`.** Six of them (`cs1gk`, `dc1sv`, `pg1rl`, `pk1tv`, `rf1bm`, `sh1ck`) lived in
`h/` until 2026-09-13 and Corwin moved them; every suite was repointed and all ten are green. Dated
notes that say `h/cs1gk` are true about their date and were deliberately left alone — a note is not
edited by a later session. Data still in `h/` on purpose: `h/traits/`, `h/KITS-2026-09-12-usage.tsv`,
the `h/DIAGRAM-*.json` fixtures.

**The three drafts are byte-distinct across all four books**, and the table proving it is in draft 2's
README. That is the lineage you inherit: draft 1 graded by a human, draft 2 cut by a constructed editor,
draft 3 cut by the human's grades. Diff any two of them before you write a word — the deltas are the
most concentrated teaching material in this tree.

**Personas are help, not decoration.** Every author is rolled, not chosen; every sheet is gauged before
that author writes a word; every author's §9 mutation log pins a named sentence from their own previous
draft against what replaced it, and every mutation is that author's own rolled trait turning on them.
That last rule is the finding from 09-13 worth keeping above all the others.

### The rubric — write to it, then be graded blind against it

Bridget's human-readers scale, now known in advance:

- **Voice** /5 — does it sound like AI? is the voice consistent across the whole book?
- **Clarity** /5 — are the instructions clear, or do they leave more questions?
- **Potential** /5 — does it stoke further ideas in the reader?

What the 09-13 round learned about each, with receipts in `book/games/GRADES-2026-09-13-bridget.md`:

- **Voice is consistency, not polish.** The book she scored 5/5 was described as *"a loner who knows
  they are... no human talks like that."* The book she scored 2/5 was the smoother one. Peculiar and
  consistent beats fluent and various. Do not sand an author down.
- **A "broken narrative vibe" is usually a pocketed one.** Her 2/5 book promised a thread and delivered
  it once, near the end: its only named person first appeared at line 430 of 552. Run
  `gb1md --thread BOOK.md` on every draft; a POCKETED protagonist in a book whose framing promised one
  is a defect you can see before a reader does.
- **Clarity dies in tables before it dies in prose.** Her 1/5 was a table-driven book with four
  seven-column grids in a 130-line stretch. Run `gb1md --render BOOK.md`. It reports width and runs and
  deliberately passes no verdict; you read it.
- **Potential is answered by giving the reader the next thing they asked for.** She gave one book 5/5
  and named what she wanted next. Build that into the book.

After the ninth book is done, grade all nine yourself against the rubric **before** Corwin sends them
out, and file your grades. Then when the human grades come back, the gap between your grades and theirs
is the measurement — the same way the eclipse pass treats the difference as the result.

### The eight books: four authors, two rounds

Roll **four new authors**. Not the 09-13 four. Each writes one book in round one and one in round two.
The categories are a *pattern*, and here is the pattern with its instantiation:

| # | The pattern | This time — **all four ruled, do not reopen** |
|---|---|---|
| 1 | something well known and broadly accessible, **a specific title named** | **Chess** — commons, bottomless, everyone can picture it |
| 2 | something of Corwin's own, well described, with copious detail already written | **C4** — no case facts, no family, no third parties |
| 3 | something obscure but not ours, with real mechanical depth and synergy to the persona engine | **classic Traveller's lifepath** — rolled terms, acquired skills, and you can die in chargen |
| 4 | something very unpinned | **how to use these techniques for computer game development** — procedural characters, emergent narrative, QA personas, playtest cohorts |

**Category 4 is the hinge and you should treat it as one.** It flips the framing: books 1–3 are things
you play at a table, book 4 is a manual for people who ship software. That flip decides what kind of
editor this session has to recruit, which is the next section. Do not soften the flip to make the set
tidy; the set being untidy is the experiment.

**Round two** is the same four authors with an **additional book ask** — a second brief that arrives
after their first book has been read. What the second ask is should come out of what round one found,
not out of this file, and you should say in chat what you chose and why before you write it.

### The new editor — not Henriette

Recruit **one new editor**, rolled and gauged like anyone else. Henriette Solberg-Maas stays on the
shelf and stays in the story; she does not review the new eight.

Her successor has a harder brief than she had, because of category 4: this editor has to review a
tabletop book and a software-practice manual in the same pass and hold both to one standard. Roll
someone whose sheet can carry that — a technical editor with game-industry time on it, or a
documentation lead who has shipped, or whatever the dice hand you, provided the sheet can honestly bear
the work.

**And build in the correction for what went wrong with the last editor.** Solberg-Maas graded design —
coverage, thesis, ambition. Bridget graded encounter — could I hear one person, could I follow it, did
it give me an idea. On two books of four they disagreed and the human was right both times. A persona I
build to review inherits my blind spot. So the new editor's sheet must carry, in §9 or wherever it
fits, an explicit charge to review **encounter before design**, and the first read of every book must
answer Bridget's three questions in her words before it says anything about structure.

### The A/B bounce

This is the cross-pollination and it runs in both directions.

1. The new editor reads **one** of the four existing Solberg-Maas books — you pick which, say why.
2. They send suggestions **back to that book's original author** (Vanth, Pell, Roux-Abara or Ilunga).
3. That suggestion is then reviewed **with both the new editor and the original author present** —
   which in practice means you write the exchange, in both voices, and neither voice gets to be right
   by default.
4. What survives the exchange lands in the book as draft 4. What does not survive is parked in
   `.eclipse-increments/` with a line saying who declined it and why.

A disagreement that resolves too neatly is a sign you wrote one person twice. `gb1md --voices` already
refuses a set of authors who all make the same closing move; there is no tool for this one, so it is on
you.

### The ninth book — the anthology

All eight authors and **both** editors, collaborating on a **single story**.

- **Thematically**, it is about the complexities of creating persona-rich experience — what it costs to
  make a thing that behaves like someone, and what goes wrong when it behaves like everyone.
- **Practically**, it is about how learning games in the company of other people leads, iteratively, to
  more interesting *and* more practical developments. It should demonstrate that rather than assert it:
  the story's own development should be the evidence.
- **QA is the build-style loop, and both editors must sign off.** Run corrections until both are happy.
  If you have run **three** full correction loops and they are still not both happy, **exit with the
  red pen still showing** — publish it with the disagreement visible and marked, and say in the book
  which editor is still objecting to what. A book that shows its unresolved edit is more honest than a
  book that quietly took one editor's side.

### The rules of the house, short form

- **Where things go.** Read `INDEX.md`. Say in chat where each artifact class is landing **before the
  first deliverable lands**. Close with `sh bin/hb1ck --layout . --since <list>`.
- **Claims.** Ledger in the first ten minutes; every row resolved before the handback.
- **Deferrals.** Every one carries a blocker token, and `[BUDGET: N]` must print the number. If the
  work is in reach and nothing bars it, do it. Budget anxiety is not a scope decision, and Corwin
  arbitrates scope, not you.
- **Park before you overwrite.** `sh bin/hb1ck --park book/games .eclipse-increments` at close. The
  09-13 session edited the shelf in place and could not find draft 2 afterwards; it was in one of
  Corwin's zips, but a draft that lives only in an ad-hoc snapshot is recoverable and not findable, and
  that is most of the harm. A signature travels with the bytes it signs — never move a file away from
  its `.sig`.
- **Don't claim what you cannot test.** Whatever formats you support, ship the tooling for them. Both
  `.md` and `.txt` for every book; `--txt` at 76 columns, pure ASCII, verified.
- **A finding a reader had to make by hand is a check that has not been written yet.** When a cold read
  turns up a defect, ask once — could this have been caught mechanically? If yes, write the check in
  the same pass as the fix. If no, say why in one line.
- **And read the warnings you already have.** Every one of Book 3's unreadable grids had been flagged by
  `gb1md --lint` before it shipped. The session read the warning, decided it was about a different file
  format, and moved on. A warning you have learned to skim is worse than no warning, because it is
  evidence you were told.
- **Report absence only after an attempt, with the receipt.** *"I cannot see X in `<place>`"* — never
  *"X is gone."* The 09-13 session declared draft 2 destroyed after checking the one directory where a
  parked draft belongs. It was in `book/book-20260913-1217.zip` the whole time, because **Corwin takes
  full-shelf snapshots and does not necessarily mention them.** Before you call anything missing, check
  `book/*.zip`, `book/*.7z`, `.arc/`, `archive/`, `Inbox/`.

### What you are inheriting, and it is worth knowing

This is the fourth session in one lineage, and the tree is in good order: ten test suites green
(**270 pass, 0 fail**), every harness shipping `--prove-red` and passing it, four books linting FAULT 0
with four distinct back-matter kinds, five character sheets at 16/0/0, three byte-distinct drafts parked
side by side, a resolved claims ledger, and a human reader's rubric in hand *before* you write instead
of after.

None of that is a reason to go gently. It is the reason you can go hard: the checks will catch you, and
the two worst findings of the last round were both cases of a session being told something by its own
tooling or its own rules and not listening. Use the instruments.

### Handbacks

1. Nine books, `.md` and `.txt`, lint FAULT 0, and your own grades against the rubric.
2. The plan disposition, the claims ledger, and the three `hb1ck` checks green.
3. One paragraph on what the new editor saw that Solberg-Maas did not — and what she saw that the new
   one missed, because that will happen too.

---

*Author: Mentat (for Corwin). Mentat is witness here, not co-author: it carries the byline for this
file because it wrote this file, and takes no byline on any of the nine books.*
