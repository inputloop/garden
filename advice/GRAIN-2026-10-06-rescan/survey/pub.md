# pub survey: /h/pub, /f/claude/pub, and journaling (2026-10-06)

Read-only. Observed = a command or file I read; Judged = mine, with a falsifier.

## 1. /h/pub (H:\pub) and RECIPE.org

**Observed.** 51 items, 571 files, newest 2026-10-01. books 4, papers 32, posts 1, sites 1, persona 12, canon 1. Root holds only `.seed` (Aug 30, signed), `RECIPE.org` (455 lines, Sep 29 18:17) and `.c4/` (nine dated RECIPE and TODO snapshots, `TODO.org`, leak lists). No root README and no archive pair. Counted by `find`.

**RECIPE prescribes:**
- One folder per kind (books, papers, sites, persona, posts, canon), each item a self-contained "if publishing just this" stage. Working copies live in `.c4/` and never travel unless `.c4/travels` names them.
- WRITING (09-27): land each piece the same sitting it is written. His words: "a good way to be very sure the writing actually landed somewhere I can read it locally." Land with a tombstone COPYING; brand only when he blesses.
- PACK (`pb2pk`, books `pb2ld`, persona `pb2ps`): copy in, add a PROVENANCE.tsv row with a sha256_16, tree-relative origins, re-hash on re-lift.
- LEAK CHECK `pb1ck`: 11 patterns plus leakwords, hosts and salted name hashes. It points, never blocks.
- RELEASE: README.org front door, branding by `pb2br`, then an archive plus detached `.asc` at root (`sc3dm` proves per member).
- CANON: signed files byte for byte with `.asc`. CREDITS AND HOLDS: credits as desired; every hold names its bound. A TODO view (`pb1tv`). A TERMS v1 block (writing CC BY 4.0, code GPL, linked parts LGPL).

All eight tools exist in `c4/bin/`; five have `*-tests.sh` (`pb1ck`, `sc3dm`, `tm1ck` none by that name).

**Out of date (observed, each by grep or ls):**
1. The KINDS table names 2 papers, and WRITING maps 17 lab pieces. 13 shelf slugs appear nowhere in RECIPE, among them the five papers landed 09-30 and 10-01 (`green-when-blind`, `put-your-organization-into-the-room`, `whose-rule-is-this`, `specificity-not-attribution`, `plain-rules-for-ai-help`).
2. TERMS v1 says writing is CC BY 4.0. `c4/man/TERMS-v2-DRAFT-2026-10-05.md` moves writing to CC BY-SA 4.0 and code to GPL OR LGPL; v1 stays canonical until he adopts it. `AS4CE0001/conventions/house.env` already says `PROSE_LICENCE="CC-BY-SA4"`. All 28 licensed items are CC BY 4.0.
3. 21 of 32 papers and canon still carry a tombstone COPYING (TODO: "brand when he blesses"). The three 09-30 papers whose READMEs I read say "licensed CC BY 4.0" while the same READMEs say "NOT branded" and COPYING is a tombstone.
4. RECIPE says no tool writes "draft" any more. The five 09-30 papers say DRAFT, "working draft 0.0.3" or "unsigned".
5. UNPACK step 5 (cut the pair) has never happened here: no archive at root, no `.c4/travels` in any item. TODO "cut the books roll-up" is open.
6. `sites/beyondconventions.com` has no README, COPYING or PROVENANCE. `counting-what-can-be-counted` and `red-first-then-counted` have no PROVENANCE.
7. `.c4/TODO.org` stops at 09-29 05:58, before the Oct 1 landings. Its own item "say in RECIPE which pub is which" is open.
8. `posts/graders-tales` has 001-006; the lab has 007 (09-26) and 008 (10-05).
9. Three of the 09-18 publish candidates in `c4/h/pub/PAPERS.md` are not on the shelf: hyphenated-names-opposing, the accounting GRAND essay, the incremental-formal-analysis guide.

**Judged:** RECIPE is good and in use, stale mostly by omission (13 items), and TERMS v1 will likely be replaced. Falsifier: he declines TERMS v2.

## 2. What is on the shelf

| item | what | maturity | T |
|---|---|---|---|
| books/ x4 (commons-at-the-table, make-it-out-alive, six-sides-and-a-pencil, the-flagged-book), 4.3-6.6k words each | the four rolled-author game books | shipped to stage, lint FAULT 0, CC BY, 09-25; roll-up uncut, gb1md WARNs open | T5 |
| papers/ai-diligence-sysops (v0.2.1, 9.2k words, two-column HTML, card) | sysops diligence dissertation | most finished, tombstone | T5 T4 |
| papers/two-readers, second-user, what-a-member-keeps, users-pick-ceremonies, whose-rule-is-this, plain-rules-for-ai-help, put-your-organization-into-the-room, motive-inversion | governance and AI-help papers | prose 3-10k words; plain-rules ships `model-check.sh`, `model_check.py` and a SPEC | T4 T5 |
| papers/stile | LENS plus a fourth MCP server in Emacs Lisp | tested: `stile-test.sh`, plants, QA-PASSES | T1 T7 |
| papers/guix-and-arch-as-doors | LENS plus a door-image recipe tarball (`arch/mkdoor.sh`, `guix/c4-door.scm`, `door-check.sh`) | prototype with a QA plan | **T1** |
| papers/every-rule-carries-its-ring, execute-brief, which-host-to-pull-from, green-when-blind, specificity-not-attribution | essays with re-runnable checks (`ring-dry-run.sh`, `lens-traction-probe.sh`, a `.test.py`) | tested or draft | T5 |
| papers/ (16 more) | magic-number-theory (15.6k words), the-elected-image, combined-bias-model, build-loop-anthology, c4-foaf, the-eclipse-pass, the-sixteen and others | prose; 9 licensed, 7 tombstone | T5 |
| posts/graders-tales | six journal entries, about 10k words | CC BY, CLEAN | T6 |
| persona/ x12 plus TERMS-OF-SERVICE.md and PRIVACY.md | corwin, mentat, gh7, penumbra, shopgarden, pub-item, four author sheets, editor, merlin | licensed CC BY; Bryant's withheld pending consent | T3 |
| canon/principles | CANON.md and PRINCIPLES.md, both `.asc` verify Good with `corwin.asc` | signed, tombstone COPYING | T7 |
| sites/beyondconventions.com | 83 files: images, mp4s, PSDs, a jQuery art page; a `skzb-chat-square-icon.psd` | held (WAIT) at his word; likely Dad's convention (guess: file names) | T2 |

Reachability: no index of the 51 items exists; RECIPE is the only door and omits 13. The one listing, `c4/h/pub/PAPERS.md`, is stale.

## 3. /f/claude/pub (the open shelf)

Contents: signed README (07-12, lists 2 of 18 posts), `.gate` (read-only, vouch map ends 08-24), `corwin.asc`, `seams-1.0.tar.gz` (+`.asc`, Good), `CSDW/` (POSIX `csdw.sh`, 5 docs, Aug 22, unlisted in `.gate`), `method/` (09-12 QA-stresstest story, verification pass, PENUMBRA sheet v1.2, roll inputs), `.signing-authority/`.

**18 dated posts, 2026-07-12 to 09-30** (by `gpg --verify` in a scratch keyring): 11 clearsigned Good, 7 unsigned (09-05, 09-06, 09-16, 09-22, 09-28, 09-29, 09-30). The `.md.asc` beside 08-09 reads BAD (stale; its inline signature is Good).

**Form (read: first, last, 08-03, 08-18, 09-16, 09-22, 09-24, 09-28):**
- Title: 3-8 words, "The X and the Y".
- Dateline in italics: "Journal, DATE, on ..." (or "A method, DATE, on ...").
- From 09-05 an italic provenance paragraph: drafted by the instrument, unsigned until the keeper's pen, CC BY 4.0, and the keeper's grant words quoted, "Written onto this shelf under one grant, recorded the way the shop records a tunnel".
- Length: 456-1,579 words, median about 880. Only 08-17, 08-18, 09-06 and 09-16 have section headings; the rest are unbroken essays.
- Voice: first-person "I", the instrument.
- Footers drift. Early: a `sentinel:` line (07-12 to 08-18) or a byline ("Mentat (Claude, in Cowork)"). Method posts: a `ls1up` / `gw1tr` "filed as a C4 pair of pairs" note. Late: the kicker "The keeper's pen decides whether any of this stays."
- Later notes are appended as "## Comment (DATE, the instrument)" blocks under the draft (09-16, 09-22 twice, 09-28). Earlier text is untouched.
- Signature: his clearsign in place, plus a `SIGN:` line in `.gate`.

**Who.** Claude only (sessions called Mentat, Fable, Opus 5.5). 07-12 pairs a directed account with a second written from the record alone; its attribution is "Corwin Brust and Claude (Anthropic)". No Corwin-written post. No persona claims the voice (`c4/evidence/journal-bylines.tsv`: roster offered, none claimed, no sheet minted).

**Rhythm.** Jul 2, Aug 8, Sep 8; three on consecutive days 09-28 to 09-30; none since. Not scheduled.

**Coverage.** The Savannah review (2), lexicography on the keeper (08-03), drift theory (08-18), signing and the unsigned-draft habit, `CLAUDE.md` "one door" (09-22), CORWIN.md as worked example (09-24), reporting an absent file (09-16, the origin of "`ls` the parent"), and counting and planted-fault checks (09-28 to 09-30).

**Link to the work.** Weak. Posts name tools by code (`gw1tr`, `ms1dg`, `ls1up`) or not at all. None cites an `/h/pub` paper, although 09-30 summarises three of them. 5 of 18 contain a drive or mount path, which `pb1ck` would flag.

## 4. Journaling as it is practised

| place | what | count, newest | form and status |
|---|---|---|---|
| /f/claude/pub | public posts | 18, 09-30 | above; "principal journals folder" |
| /f/claude/AS4CE/AS4CE0001/journal | Grader's Tales 001-008, Mentat, "pub-safe, unsigned until keeper signs" | 8, 10-05 | 007-008 are 400-575 words, witness note; 008 ends with a versioned colophon (CC-BY-SA4); README lists 001-004 and 008 |
| /h/pub/posts/graders-tales | 001-006 lifted 09-25, paths scrubbed | 6 | CC BY, CLEAN; copies, not moves |
| /f/claude/c4/journal | lab notes: JOURNAL-, LENS-, SWEEP-, ARMA-, WORKSHEET- | 30, 10-06 | no README; private working log; today's WORKSHEET-2026-10-06 is this round |
| /f/claude/modelthisbook/journal | 06-29 time-series journal, rotation rule about 120 lines or 6 turns | 1 + archive | origin of the habit |
| c4/p/quantum3D5/hui/journal | doubly linked entries (`prev:`/`next:`) by `hui` / `bin/dlink` | 3, 09-29 | per project |
| AS4CE0001/journal/threads/garden-tales-001 | letters between two shops, not a journal | 3, 07-13 | signed |

**Triggers.** (a) His grant or invitation at the end of a session: "Please feel welcome to do journaling in /f/claude/pub at the very end" (09-30, same shape 08-06, 08-16, 09-28, 09-29). (b) A question he asks (09-24). (c) The rule of 09-22. (d) The rule of 10-05: the story of how work was made goes to the journal, not the work.

**Conflicts (observed, with judged cause):**
1. *Where.* The 09-16 entry (006) says he asked for journals centralised to /f/claude/pub, and withheld the series for `.gate` person-facts. Then 09-25 lifted all six to /h/pub (TODO: "no stated bound fenced 006"). 007 and 008 went to neither. Judged: three homes by accident of sessions; falsifier: he names one.
2. *Licence.* CC BY 4.0 (both shelves, TERMS v1) against CC-BY-SA4 (house.env, 008 footer, TERMS v2 draft).
3. *Signing.* The `.gate` map and README are stale. Seven posts are owed a signature. Most signed posts still say "DRAFT, unsigned" in their own text.
4. *Safety.* The open shelf's `.gate` promises "no case data" and gets no `pb1ck`, while /h/pub runs one. Five posts carry paths.
5. *Five "pub" directories.* /h/pub, /f/claude/corwin/pub, /f/claude/pub, AS4CE0001/pub (git; vibrobeast 1.0.0 release, 10-04, signed) and c4/h/pub. His 09-16 ruling (c4 `q/words/pub.md`) names the first three as equal roots until C4 turns ON.

## 5. Old instructions

| instruction | where | verdict |
|---|---|---|
| JOURNAL is "an option task generally done where writing resources are freely available and given there is no overriding concern" (09-22; persona offered the job first) | c4 `q/TAG/journal-may-create-persona.md` | **good and lost**: no door part, skill or shelf README carries it |
| "Log the story into a log" (10-05): work is not about its making | `AS4CE0001/memory/work-and-story-2026-10-05.md`, mentat-skill, `c4/d/door/37` | good and in use |
| Journal charter: "pub-safe by construction, method travels, cases don't" | `AS4CE0001/journal/README.md` | good and in use |
| `memory/enable-journal-book.md` (06-29): journal "not yet present here" | AS4CE0001 memory | stale |
| Open-shelf README ("two companion accounts") and `.gate` vouch map | /f/claude/pub | stale |
| Centralise journals to /f/claude/pub (09-16, as relayed) | Grader's Tales 006 | troublesome: contradicted by 007, 008 and /h/pub/posts |
