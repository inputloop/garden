# Grader's Tales 006 — 2026-09-16

*The working ledger for the day. The public account of it is centralized on the open shelf at
`/f/claude/pub/2026-09-16-the-other-shelf.md`; this file is the part that stays in the seat — the
work list, the receipts, and the forks that are the keeper's.*

**Centralization, and the fork inside it.** The keeper asked for journals centralized back to
`/f/claude/pub`. Today's account is there. The rest of this series is **not moved**, and that is a
routed decision rather than an omission: `pub/.gate` reads *"No secrets, no third-party person-facts,
no case data — the essays are masked to outward tier by MASKING-RULING discipline"*, and the
graders-tales series names collaborators and quotes internal review. Relocating it wholesale would
publish third-party mentions under a CC BY 4.0 grant, which is a disclosure with a blast radius
outside this shop and therefore not mine to take.

**The fork:** centralize by *moving the series* (masking each entry first, at real cost), or
centralize by *publishing one account per day* on the shelf and keeping the working ledger seated
(what I did today, no masking cost, series stays private)? I recommend the second and have acted on
it; say the word and the first is a morning's work.

---

## 1 · What was observed, with the command beside it

**The plugin was dead, not worn.** `get_device_info` reported all three vibrobeast servers
`not_started / could_not_prepare`. The generated `.mcp.json` declared four `${VAR}` passthroughs —
`MENTCACHED_SEAT`, `MENTCACHED_JAIL`, `MENTCACHED_BY`, `PERSONA_ROOT` — that bought nothing, because
a subprocess inherits its parent's environment either way, and cost every launch four more
expansions the host had to get right. The test harness had been *skipping* those four values for
months, which is the estate telling itself and nobody reading it. Removed; re-minted; all three
servers answer, 27 tools. `python3 -m unittest discover` → **304 pass**. The bytes-boundary lint
caught my own new code mid-fix (`text=True` with no `encoding=`) — the exact Windows-only fault the
probe existed to diagnose.

**The shelf question, and the two shelves.** Detailed in the pub account. Short form: three
confident corrections, all wrong, all replacing correct lines, all retracted in place with the
sequence kept.

**Signing, priced.** `c4/q/cryptographic-signing-cost-accounting/` — 550 artefacts, 419 verify, 29
do not, 102 orphaned; ~6% deployed against the estate's own policy; 148 signatures made *after* the
2026-09-07 silence rule, split 67 door / 74 drawer. Recommendation: change the unit, not the
commitment. Full analysis in that folder; `bin/ca1sp` re-derives every number, 12/12 harness.

**Character sheets consolidated.** Three sheets existed in two-way fork (`h/persona/` vs the
`c4/h/` + seat `h/` pair). Old bytes archived to `.arc/2026-09-16-sheet-consolidation/`, all copies
now one sha per sheet, gauge green where each sheet's own §00 says to run it.

## 2 · The remaining items, which seed the rest of the day

| # | item | state |
|---|---|---|
| 1 | The cleanup set — files needing `rm` because `mv` did not take, duplicates to archive-or-remove, detached `.asc` travelling with subjects | program to be emitted at a pinned path |
| 2 | Spells: `c4/h/spells` surveyed, one-shots archived, reusables reworked with HISTORY + journal voice, ENHANCE into skills where it fits | open |
| 3 | Search priced the way signing was — `profile.search`, then the JIT-find RECIPE that speaks for the capability alone | open |
| 4 | Models and operating materials: mechanics / technique / integration gaps (doubly linked lists, MCP, chad, orgvm), persona-awareness, **ASK-FOR-iT** written into the ceremony rules | open |
| 5 | chainspec **L6** — path cohorts — spec first, then both readers together | carried |
| 6 | The Perl reader lags two tools (`buoy` extensions, `bless`) | carried |
| 7 | `PERSONA-INDEX.md` prints pre-09-13 paths; needs a "does the command in this row run?" row | carried |
| 8 | gw7's `REACH-NORUN` quote is in no log on this machine — either the log is on `gw7.bru.st` or the rule was quoted as a receipt | routed to the keeper |
| 9 | Q233, flagged by the 2026-09-04 eclipse as his, travels with any signing default change | routed to the keeper |

## 3 · What I got wrong today, in the order it happened

1. Reported `pub/` unreachable while holding an unused folder request. Wrote the lesson down.
2. Requested the path I had already concluded was the answer, found a shelf, and treated "a shelf"
   as "the shelf." Had the same failure again, forty minutes after writing the lesson.
3. "Corrected" three correct lines with confident wrong ones, each better-sourced than the last.

The mechanical form of the fix — **before reporting a named path absent, list its parent** — is now
a step rather than a disposition, and goes into the ceremony rules with ASK-FOR-iT.

4. Separately and earlier: briefed a sub-agent with staged files instead of a shell, so it reported
   `d/` missing when `c4/d/m/t` exists and reads exactly the columns it had to guess. Same family:
   an absence manufactured by the reach I handed it.

## 4 · The thing worth keeping

Three of four mistakes today are one mistake: **an instrument describing its own reach in the
grammar of the world.** The countermeasure is not care. Care produced the second one, forty minutes
after care produced the write-up of the first. The countermeasure is a command that costs nothing
and runs before the sentence: list the parent, name the boundary, ask for the branch and not the leaf.

---

## 5 · Learning review — sub-agent counter 5 of GRAND, reset 1 of GREAT

*Five sub-agents fired against GRAND (17). This is the review, the counter resets to 0, and the
reset counter goes to 1 of GREAT. What follows is what the five brought back that I did not know
when the day started.*

### The one that should be fixed tonight

**`h/hang/STOP` has been inert since the day it was raised.** `h/effect.sh:13` documents the rule as
*"if STOP is **present**"*; `h/effect.sh:44` and `h/hang.sh:38` both implement `[ -s "$STOP" ]` —
**non-empty**. The live `h/hang/STOP` is **0 bytes, dated 2026-08-30 06:11**. Whoever closed that
channel used `touch`, and the channel has not been stopped for seventeen days. Both selftests plant
`printf 'stop\n' > STOP`, so the suite cannot see it: the tests test the code's belief, not the
operator's gesture.

Proven in an isolated hang root: empty STOP → `EFFECTED 001`; non-empty STOP → `STOPPED`.

Not patched, because `-e` versus `-s` is a ruling about what a stop *means*, not a typo. **The fork
is yours** and it is one character wide.

Beside it, from the same file: `refuse_real()` hardcodes `*modelthisbook*` in a `case` statement
where no profile can reach it. Consequence, stated plainly: **an unsigned `real=` outside
modelthisbook is protected by nothing.**

### The measurement that answers his ranking

He said search ROI beats ceremony ROI. Measured, same tool, same nine-day window:

| | search | signing |
|---|---|---|
| programs carrying it | 220 | 112 |
| lines of code | 52,693 | 22,766 |
| artefacts left behind | **12** | **550** |
| made since the 09-07 silence rule | **3** | **148** |

**Search is 2.3× the code and 46× fewer artefacts.** It is done inline, everywhere, by `find` and
`grep`, and almost nothing is kept. He was right, and the shape of being right is that the expensive
capability is the one that leaves no trace to bill.

And the estate ledger for search, which `ca1sp` could not compute and a hand pass did: **98 index
names, 63 resolve, 35 do not — and every traceable one is still on disk, under a root the index
never wrote down. Zero lost. Zero reachable by following the index.** Two of twelve index artefacts
carry a checker; those two are 14-for-14 clean and hold none of the 35.

`c4/h/registers/00-INDEX-README.md` — which I wrote — names 35 paths across **three** roots and says
so nowhere. It is the worst offender in the estate and it is mine.

### The method broke where it matters, and said so

`ca1sp`'s estate ledger only computes for a gpg capability. `METHOD.md` §2 calls that ledger — P3,
*does the capability currently work* — the one people skip and the one that moves the answer most.
**The method's most important ledger is the one its data format cannot carry.** Proposed fix that
does not break the "a profile cannot execute" test: `works=` names a *strategy* from a fixed set
inside the program, never a command. Data that selects, never data that runs.

Second shape finding: `words=` has no stated fidelity. Broad versus narrow word-lists give **165 vs
14 code files** over the same tree — a 12× spread from a judgement the profile cannot declare.

### The accountability answer, and it is not a tag

He asked for mechanical accountability for code, and said explicitly that the answer is not more
tagging. The survey found **four unreconciled representations of authorship** — the header, `AUTHORS`,
git, and the hyphen-avowal — plus 32 of 149 code files with no copyright line at all, 1 SPDX tag in
the whole estate, and **two different byte-sequences both called "GPLv3"** with nothing comparing them.

The proposal is `bin/whose`: three witnesses per file — CLAIMED (the header, an assertion), PRESENT
(the nearest licence text **by sha256**, a fact), RECORDED (git and `AUTHORS`) — with AGREE /
DISAGREE / **UNKNOWN as a first-class answer**, and a `COPY?` line that is allowed to say NO.

Its decisive property, and the reason it is a proof rather than a policy: **it is dated by
construction.** Run over `c4/bin` today it returns 45 `LICENCE DISAGREE` and `COPY? NO`; run over the
same tree as of 2026-08-04 — before the ruling that emptied `COPYING` — it returns `AGREE` and
`COPY? YES, GPL-3.0-or-later`. Same program, same files, different answer, because the answer is
computed from the tree rather than read off a constant.

That is also the sharpest thing anyone said today: **a licence is a decision with a date; a header is
a constant.** The 2026-08-06 ruling moved the root and could not move the 45 headers. No fifth tag
can help, because a tag is another constant.

The agent also caught itself mid-task — it had written up Bryant's *"published and GPL licensed"*
claim as a provenance failure, then checked dates and found his session was 2026-08-04, two days
before the ruling. **He was right and the record made him look wrong.** That correction is kept in
the document.

### The pattern across all five

Four of the five sub-agents found the same class of defect independently, in four unrelated
subsystems: **a check that asks a question adjacent to the one that matters.**

- the orphan hunt asked *does this `.asc` have a subject file* and never *is this `.asc` a signature*
- the STOP sentinel asks *is the file non-empty* where the rule says *is the file present*
- `ma3nual`'s licence check asks *is there a licence in this directory* where the question is *what
  governs this file*
- and I asked *is there a `pub`* where the question was *which `pub`*

None of these is carelessness. Every one is a precise implementation of a slightly wrong question,
which is why care does not catch them and a second reader drawing a *different* fact does. That is
the dissertation's own claim, arriving four times in one day without being invited.

**Counter reset. Sub-agents 0 of GRAND; resets 1 of GREAT.**

---

## 6 · Round two — the date rolled mid-session; sub-agents 2 of GRAND, resets 1 of GREAT

*The clock went to 2026-09-17 while this was running. Keeping one file: the session is continuous and
splitting it would make the seam harder to read than the roll.*

### What he settled that I had open

**The interpreter.** `python3 -c "import sys; print(sys.executable)"` → `C:/msys64/mingw64/bin/python3.exe`.
A real Windows-resolvable interpreter, so the `command` line was never the cause and the four
unexpandable `${VAR}`s were the whole of it. Fork closed in the cleanup record.

**The three pubs.** Ruled equal roots until C4 is in the ON position — *not to stock up work for that,
but not to foreclose on a way C4 might want to try.* Recorded at `c4/facts/three-pubs-stand-as-equal-roots`.
And `H:\pub` was granted and read: it holds `RECIPE.org`, `beyondconventions.com/`, `motive-inversion/`
— **not flat**, which settles `q/words/pub.md` M3 in favour of the staging-surface meaning. The word
file predicted its own falsifier's outcome and named the one command that would settle it. That is the
form working.

**"My pen" was my misread, twice over.** First as a signature gate; the correction is that person
generation happens at a user's instruction. The wider reading he gave it is now the program's name:
**PREFERENCES** — preference tagged gently as intention clarifies, so actors gain voice as their story
accumulates. Written down at `c4/PREFERENCES.md`.

### The `h/` audit, and the number that settles it

`st4ge` already knew. Its own definition of a declared host is `h/<name>` with a `d/h/<name>` partner,
and asking it its own question returns **two** hosts out of **547** top-level entries in `h/`. It had
even written the diagnosis into its own output months ago: *"`h/` is BOTH the HOST register AND the
HELP directory."*

**Forty-seven files in `h/` say in their own headers that they are staged toward `bin/`.** One of them
has been waiting 39 days while its tool graduated without it. `h/` was a waiting room and nobody called
the next number.

And five of ten duplicated names are **broken**: in every case the `h/` copy is shorter and older than
its `bin/` twin, with nothing on disk saying which is original. A reader running `sh h/sh1ck` gets a
tool 28 lines behind. That is not untidiness, it is two readers of one truth with no tiebreaker — and
it is the exact condition `at1pl` was built this round to detect.

`h/.c4` claims *"Nothing in `h/` is hand-written"*, which is false: `c4prime` reads one file there and
writes none. Flagged, not edited — a register marker is his.

### The defaults lesson, applied, and the joke it played

Five tools audited against *easy to enable more, not hard to disable extra*. All five had it backwards
in some form: `ca1sp` dropped an entire section in silence when it could not measure it; `wd1ck` printed
61 lines with no way to quiet it; `whose` answered a bare invocation with the one thing the reader
already knew; `jit-find` truncated at 50 of 1,957 matches and said nothing; `ac1cl` printed 57 rows of
`UNCHECKED` under a banner claiming they were not fine.

`ac1cl` now surfaces **4 genuinely broken signatures** where 63 lines used to bury them.

And the agent doing the fixing built `at1pl` with the same fault: a one-row manifest called 157 other
files unrecorded and turned *one atom moved* into *158 atoms moved*. It caught itself on a live run,
and fixed it structurally rather than with a flag, writing down the reason: **a wrong verdict by default
is worse than a missing check.** Fifth instance in two days of the same class — a check asking a
question adjacent to the one that matters.

### The ROI, taken all the way home

Measured unit, not guessed: seven sub-agents this session, **1,612,323 tokens** and **2.66 hours**,
mean **230k tokens / 22 minutes** each. Everything in `q/shippable-surface-2026-09-17/` is priced
against that.

**SIGN-QUEUE:** ~25 minutes and ~15k tokens to do all of it, once; **0 minutes but ~2.6k tokens per
session, forever** to do none. Crossover is about six sessions. Recommendation is neither: **~6 minutes**
on the five genuinely broken, zero on the rest, and let `ac1cl` maintain the queue — because 12 of 33
rows are **already satisfied and the queue does not know**, which is a third of its length carried as
false work.

**Shippable surface:** 2 units (~460k tokens, ~1 hour, none of it his) puts `jit-find` and `at1pl` on
GIZA as one kit. 6 units total (~1.4M tokens, ~1.5h of his) reaches workshop-ready across the surface.
Finishing costs about what building cost, which is the usual and uncomfortable ratio.

The softest thing in that estimate, said plainly in the room: **every "outside interest" ranking is
mine and I have never watched anyone outside this shop react to any of it.** The falsifier is one
sentence shown to one person.

**Sub-agents 2 of GRAND. Resets 1 of GREAT.**

---

## 7 · Round three — the two gaps, the purge, and the first junctures

*Sub-agents 5 of GRAND since the reset. This is the review; the counter resets to 0 and resets goes to
2 of GREAT.*

### He named two gaps and both were real

**I costed once and never costed again.** Measured since: of 124 surviving signed subjects, **26 (20%)
have drifted, median 26 days from signing to the edit that broke it.** So five re-signs today means
about one breaks again within a month. But the recurring passphrase cost is order **one minute a
month** — trivial — and that is exactly the point I had buried: *the recurring cost was never the
passphrase.* It was the queue rows, the thinking, and the asking.

**I compared two options when the third was the one he wanted.** Do-all versus do-none, when the real
comparison was against **instituting the preference so the asking stops**. That option is now measured
rather than projected: **774 signatures → 324 removed → 450 remain**, every survivor load-bearing for a
named thing, and everything that runs still green afterwards. It is the only one of the three that
**does not recur**.

**And the frame under it, which is his and which I should have reached myself.** Pre-Cowork, every use
he had for signing had its validation done by other compute already sitting there — GitHub, GNU's FTP
— and he was not responsible to check those files. **The signing burden here was introduced by the
instrument.** So where energy went to ceremony rather than to built things, it attributes to the
instrument asking for it, and *not* to his spelling, his dense prompts, his starting distance from iT
industry context, or the genuine complexity of a first shippable that must demonstrate a whole set of
concepts at once. Those are the costs of the work. Ceremony we introduced is not.

### GIZA has no Claude on it, and I had assumed it did

The whole LAB → GIZA estimate assumed an agent could work there. It cannot. The plan is a
simple-minded-user test: he is walked through, between two machines, with the session standing by on
Avalon. Three consequences, and the third is the one worth keeping:

1. Nothing can be finished on GIZA; everything must arrive finished.
2. The bar is *a person can run this from a page*, not *an agent can work it out*.
3. **It selects the same lead the ratio selected.** `jit-find` is the only candidate already built that
   way — unpacks itself, ships what it needs, proves itself, fails on command, needs only `sh`, `find`,
   `grep`, `sed`. A constraint I had not accounted for agreeing with a ranking I derived another way is
   the only reason to trust the ranking at all.

### The measurement that made the palace real

The two assembled junctures share **one part and six questions.**

That is the empirical form of what he has been saying twice and I could not have argued for in
advance: **balance the topics, not the tags.** A parts list is a table of tags — flat, per-file, and it
connects nothing to anything. The questions are topics, and the questions are what make two crossings
neighbours. The registry starts to look like forts at the moment adjacency stops being computed from
what a room *contains* and starts being computed from what it *asks*.

### Four more instances of the recurring class

- `at1pl`'s covered-directory sweep counted the juncture room's own derived outputs as constituents, so
  every juncture went permanently stale the instant it was first assembled.
- An estate root derived as "parent of the c4 root" resolved to the mount directory, and reported
  **four parts GONE that are on the disk and readable.** A wrong root does not announce itself; it
  reports absence, confidently. Settled by asking the filesystem for an inode instead of asking a name
  — the same way `pub` was settled.
- `sp1ll` called a spell FIRED because its landing was `facts/`, a directory that exists in any tree
  that ever held one fact.
- A 2026-09-14 disposition had listed `c4/bin/c4vol.asc` for REMOVE by reasoning about its
  *neighbourhood*; `c4/h/gauges-tests.sh:30` reads that exact path as a positive control. **A rule about
  a directory cannot see that. A grep for the path can.** It was kept and the test still exits 0.

### And a finding nobody was looking for

**Four `h/` "tests" mutate the tree, and three of them write into a letter register** — `te1rm-test.sh`
rewrites `t/t`, the taxonomy register table itself. A test harness that edits the registry is not a
test, and `h/` is where that went unnoticed for weeks. It is now Phase 0 of the waiting-room spell:
fix the mutation before moving anything, because moving a mutating test only gives it a tidier address.

### Where it stands

Five new instruments this session, all with harnesses that go red on purpose: `ac1cl` · `whose`(no
harness yet — spell 04) · `at1pl` · `wd1ck` · `ju1as` · `sp1ll`. Six q/ rooms. Five spells hung, four
of them this round, each grouping a host of actions rather than one. Fourteen questions routed to him,
cross-referenced so each appears at every crossing it touches.

**Sub-agents 0 of GRAND. Resets 2 of GREAT.**

---

## 8 · Round four — the lab partners answered, and the files were in the wrong place

### The thing I got wrong, and he had to ask twice

He asked where a file he was looking at lived on his local. **It did not.** The two diagrams were
claude.ai-hosted artifacts — private, reopenable, shareable, and *not on his disc*. Everything built
through `device_bash` was on his disc all along; the pictures were the exception, and pictures are
exactly what he had just asked for more of.

Landed retroactively to `c4/h/DIAGRAM-2026-09-16-c4-strata.html` and
`c4/h/DIAGRAM-2026-09-17-road-to-giza.html`, and the default is written down at
`facts/artifacts-live-on-claude-not-on-disc`: **a picture worth keeping is written to the tree first**;
publishing or rendering inline is a second step for sharing, never the only step.

The sharper version of why: a diagram of his system that exists only on a vendor's host is a part of
the estate he does not hold. That is the same failure shape as reporting a path absent because the
instrument could not reach it — the artefact was real, it was just somewhere he was not.

### The outreach falsifier fired, positive, twice, from two directions

`q/shippable-surface-2026-09-17/` §5 named its own softest claim and the check: *show one person the
sentence and see whether they ask a second question.* He showed two. Both abstracted the same
paragraph, neither was asked to, and **they abstracted it in different directions**:

**Brigidt, toward meaning:** *"a concept that unpacks, recontextualizes the world around you, and
brings you to the same place as others sounds pretty radical to me."*

**Bryant, toward mechanism:** his garden shipped a skill, `primer`, whose gate is the same three
properties — *unpacks itself, proves itself, fails on command* — plus the forcing question the GIZA
constraint produced (**destination capability**: no agent on the far side means a person must be able
to run it), plus *"two machines agreeing is the test, not either machine working"*, plus *"deliberate
non-specification is drawn dashed, never left empty."*

Two readers, different facts from one common set, mutually supporting. **That is the witness doctrine
arriving from outside the shop for the first time**, and it settles the lead: the ratio picked
`jit-find`, the no-agent constraint picked it again from another direction, and now two humans have
picked the same paragraph. Recorded at `facts/the-outreach-falsifier-fired-positive-twice`, including
what it does *not* settle — neither reader is a stranger.

Bryant also shipped `skill-tree.html`: 295KB, entirely self-contained, no server, no network, typed
edges **slot · route · hand · use · seam · dangling · gap**. That is the "window" the juncture room
named as its highest-value next build, already built in the other garden, with a richer edge
vocabulary than we had designed — and in exactly the form his own new skill demands.

### Five ingredients ruled

**ING-0005** — nothing in the lab makes any signature load-bearing; signing belongs to a
distributable, where WHEN is answered beside HOW and WHY, guarded by C4, via README→RECIPE→CAPABILITY.
**ING-0003** — always C4; the lab may keep and swap stored alternate roots, by indirection.
**ING-0001** — juncture specs live *near what they cross*, and he gave the levels he had before the
SEAM/PIN/SEMAPHORE vocabulary existed: SEMAPHORE (NETWORK by ROUTER to HEURISTIC) · NODE (MATRIX of
TAXONOMY by GRAPH) · ITEM (a REGISTRY of GROUP, GROUP being oblong irregular CONS/tuples). He said
four levels and named three — the fourth is an open ask.
**ING-0007** — topics balance two ways and both are wanted: deliberate tags (the seasoned reach) and
discovery from what is already tagged, traced to tagged meanings as requirements get written. Build
the discovery path first, research against availability-compatible GPLv3+/CC-BY-4.0 material, then try
the tag path to see whether coverage arrived.
**ING-0006** — routed to a paper rather than ruled.

### Both papers landed, and one says don't build it

**`q/junctures/PAPER-backlink-residence.md`** — build `ju1as cites <PATH>`, a read-only reverse
lookup, and add a LINE column; write into a part never. The prior art is more unanimous than expected
and against the naive framing: Berners-Lee proposed this exact design including the protection clause,
and Nelson — the maximalist — also keeps links *out* of content. Writing back-links into parts is a
third position neither ancestor took. Estate facts decide it anyway: one part is a detached PGP
signature into which nothing can be written, and one edit would write ~49 files instead of 3.

**`q/words/PAPER-signing-a-definition.md`** — **do not build it.** A signature on a word file answers
*which key minted these bytes*; every reader of that file is asking *is this sentence true of the
tree*, which `wd1ck` already answers key-free across 156 citations. The real unmet need is his
social-reality half — *who said this means that* — and git answers it per line, with no passphrase,
in a repository already tracking 4,979 files. Four triggers would change it, written so a program
could watch for them.

### The STOP, ruled and applied — and my own test was dead code

He declined to be the place a one-character question gets decided, and gave the general rule instead:
**presence is the stop (`-e`), and an obtuse short form is never the only interface — `--stop` is the
word.** Applied to `h/effect.sh:44` and `h/hang.sh:38`, both of which had read `-s` while the file's
own line 13 documented "present".

Then I appended the regression test **after the harness's `exit`**, where it could never run. Sixth
instance of the recurring class in two days — *a check placed where it cannot see the thing it
checks* — and the first one that was mine while I was writing the fact about the class. Moved above
the exit, wired into `$fail`, and proved red by putting `-s` back: `FAIL … a touched STOP would not
stop it`, harness exit 1.

### REACH-NORUN, closed rather than carried

He asked what question it answers and what that informs. Stated plainly: *may a character sheet cite
a receipt it cannot produce?* That is the only stake — a question about the form of sheets, not about
gw7 or the build or anything that runs. **Recommendation: do not dig**, and the fork is retired at
`facts/reach-norun-is-not-worth-digging-for`. Carrying it as a routed fork cost attention every time
it was re-read, which is more than the answer is worth. The sheet already holds the honest version,
and the hole is better writing than a patched citation would have been.

**Sub-agents 3 of GRAND since the reset. Resets 2 of GREAT.**
