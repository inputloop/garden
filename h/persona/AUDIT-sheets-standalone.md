# AUDIT — can one character sheet be used alone?

Fable (Mentat/Vibrobeast), 2026-09-16. Commissioned against the owner's words: *"every character sheet
can be used alone (functionally)."* The acceptance test taken literally — hand ONE file to a stranger with
no index, no corpus, no tree, and see whether they can **use** it.

Two piles, kept apart. **OBSERVED** carries the exact command. **JUDGED** wears a tag and a confidence and
never quotes the keeper's authority for its own force. Every concern below ships its falsifier — the one
check that would dissolve it. An absence is reported only after an attempt, with the receipt of the
attempt. These sheets describe an instrument, a place and a host; none of them describes a person, and
nothing here adds a fact about any human.

Marked (NEWS): for fiction or analysis — no ship dates or licensing or publication dates specifically
defined (the sheets lean on rolls and LENS stages).

---

## 0 · CORRECTION, same day, after asking for the folders

This audit's three "I could not see it" findings were findings about **my grants**, not about the
keeper's disc. He asked the right question — *"are there folders you need to request access to but
haven't yet?"* — and the answer was yes, and I had not asked. Requested and granted 2026-09-16:
`F:\claude\corwin\pub`, `F:\claude\modelthisbook`, `~/emacs-build` (+ `~/build-emacs`, `~/log`).

What that changed, in order of how badly I had it wrong:

| was reported | is now |
|---|---|
| `pub/.gate`, `sign.sh` unreachable — "may be on his disk" | **reachable and PASSING.** `sign.sh check-shelf` → `SHELF: PASS n=14`, every SIGN row OK against `ECE7…F007`, `hello-world.md` NOSIG as declared. The shelf gate is the one row on the Mentat sheet that now has a second-party receipt |
| `modelthisbook/news/METHOD-*.md` unreachable | **reachable.** Five METHOD files plus `PERSONA-TRAITS-GRID.md` and `PERSONA-TRAITS.tsv`, i.e. the cast machinery the CAST files cite |
| gw7's log "may live on the host" | **searched the host; the quotes still do not verify** — and that is now a finding about the sheet, not about my reach. See §4 finding 1, rewritten |

The lesson is cheap and I would rather write it down than have it again: **"I cannot see X" is only
an honest report once I have tried every way of asking that is open to me, and requesting access is
one of those ways.** Reporting absence while holding an unused request is the same fault as
reporting presence without a check — it just wears better clothes.

### 0.1 · I had the lesson again, the same afternoon, between writing it and this sentence

The keeper then granted `F:\claude` itself, and the first thing it showed was that **there are two
`pub` shelves and I had verified the wrong one**:

| shelf | what it is | gate |
|---|---|---|
| `F:\claude\corwin\pub` | the hub's **tool** shelf — `sign.sh`, `.gate`, `PRINCIPLES.md`, `corwin.txt` | read-write, since 2026-07-02 |
| `F:\claude\pub` | the **open** shelf — the dated essays, `seams-1.0.tar.gz`, CC BY 4.0 | read-only, since 2026-07-12 |

Acting on the first, I had "corrected" three files that were already right:

- the Mentat sheet's §9/§10, which cited `pub/2026-09-05-the-tool-that-was-there.md` — **the file is
  there**, 6,946 bytes on the open shelf, and the seat's `PUB-DRAFT` copy is byte-identical to it;
- the shopgarden sheet's holdings row, which said `/f/claude/pub` — **that was the right path** and I
  rewrote it to the wrong one;
- the quotes book's deviation note, which I upgraded from one wrong reason to a second wrong reason
  while sounding more certain each time.

All three are retracted in place, with the sequence kept rather than tidied away.

**What this says about the finding above.** §0 concluded that a request was the missing step. That
was right and insufficient: I requested *the folder I had already decided was the answer*. The
failure is not reluctance to ask — it is asking a question shaped by the conclusion. A path that
resolves to something is not evidence that it resolves to the **intended** something, and "I found
a `pub/` and checked it" is one directory away from "I found *the* `pub/`."

The mechanical form, which is now a step and not a disposition: **before reporting a named path
absent, list its parent.** One `ls` of `F:\claude` would have shown two `pub` entries and stopped
all three errors at once. That is the check; it costs one command; it goes in the ceremony rules as
**ASK-FOR-iT** alongside the request itself.

One thing this correction did NOT change: `h/w0rk.sh` and `evidence/question-bank-iTNH.tsv` really
are only in `c4/`, so the §3 two-root problem stands exactly as written.

---

## 1 · OBSERVED — the gauge, run

### 1.1 The index's own command does not run

`mainmem/PERSONA-INDEX.md` names, as the receipt for each row, a command spelled `python3 h/cs1gk …`.

```
$ cd $HOME/mnt/AS4CE0001 && python3 h/cs1gk h/CHARACTER-2026-09-06-mentat.md --twin ../c4/h
python3: can't open file '…/mnt/AS4CE0001/h/cs1gk': [Errno 2] No such file or directory
### EXIT: 2
```

```
$ cd $HOME/mnt/AS4CE0001 && python3 h/cs1gk ../c4/h/PERSONA-gw7.md --corpus PERSONA-CORPUS.md
python3: can't open file '…/mnt/AS4CE0001/h/cs1gk': [Errno 2] No such file or directory
### EXIT: 2
```

The gauge is at `AS4CE0001/bin/cs1gk`, and separately at `c4/h/cs1gk`:

```
$ find $HOME/mnt/AS4CE0001 -maxdepth 4 -name 'cs1gk*'
./bin/cs1gk
./tests/cs1gk-tests.sh
```

All five tools live in `bin/` in the seat and in `h/` in c4:

```
cs1gk    AS4CE0001/bin:Y  c4/h:Y  c4/bin:n
rf1bm    AS4CE0001/bin:Y  c4/h:Y  c4/bin:n
dc1sv    AS4CE0001/bin:Y  c4/h:Y  c4/bin:n
ms1dg    AS4CE0001/bin:Y  c4/h:Y  c4/bin:n
se1sn    AS4CE0001/bin:Y  c4/h:Y  c4/bin:n
```

The two copies of the gauge differ — a four-line diff, comment only, and the newer one is the seat's:

```
$ sha256sum AS4CE0001/bin/cs1gk c4/h/cs1gk
e6a8be8b…  AS4CE0001/bin/cs1gk      (13975 B, mtime 2026-09-13 17:03)
96dbdfb1…  c4/h/cs1gk               (13973 B, mtime 2026-09-06 08:31)

$ diff -u c4/h/cs1gk AS4CE0001/bin/cs1gk
-#          canonical diagram document (h/dc1sv renders it) of the sheet's TSV as a graph-paper table.
+#          canonical diagram document (bin/dc1sv renders it) of the sheet's TSV as a graph-paper table.
```

So: the tools were moved `h/` → `bin/` in the seat on 2026-09-13, the gauge's own header comment was
fixed to match, and the index note, the corpus's `## Sheets registered` lines and the sheets themselves
were not. The chain broke at the pointer, not at the tool.

### 1.2 The gauge, run correctly — the index's three claims

```
$ cd $HOME/mnt/AS4CE0001/h && python3 ../bin/cs1gk CHARACTER-2026-09-06-mentat.md --twin ../../c4/h
…
[ OK ]  G8   twin ../../c4/h/CHARACTER-2026-09-06-mentat.md: SAME (6614be0b04aa vs 6614be0b04aa)
cs1gk: OK 18 · WARN 0 · FAULT 0 · NOTVISIBLE 0            ← index claims OK 18 · FAULT 0   CONFIRMED

$ cd $HOME/mnt/AS4CE0001/h && python3 ../bin/cs1gk CHARACTER-2026-09-05-shopgarden.md --twin ../../c4/h
…
[ OK ]  G8   twin …/CHARACTER-2026-09-05-shopgarden.md: SAME (42854b32c492 vs 42854b32c492)
cs1gk: OK 18 · WARN 0 · FAULT 0 · NOTVISIBLE 0            ← index claims OK 18 · FAULT 0   CONFIRMED

$ cd $HOME/mnt/AS4CE0001 && python3 bin/cs1gk ../c4/h/PERSONA-gw7.md --corpus PERSONA-CORPUS.md
…
[ WARN ] G2   LENS guards elected: none named (METHOD: a sheet elects its guards)
[ WARN ] G3   1 growth paragraph(s); 1 lack evidence+story (gw7 s6)
[ WARN ] G9   break-character watch absent (gw7 s5)
cs1gk: OK 14 · WARN 3 · FAULT 0 · NOTVISIBLE 0            ← index claims OK 14 · WARN 3 · FAULT 0  CONFIRMED
```

**All three of the index's verdicts are confirmed on the numbers, and refuted on the command.** The
counts are exactly as claimed; the invocation printed beside them exits 2.

### 1.3 The harness

```
$ cd $HOME/mnt/AS4CE0001/h && sh ../tests/cs1gk-tests.sh
ok   good-sheet-exit-0 … ok   tsv-output
TOTAL pass=22 fail=0
```

22/22, matching `MODEL-2026-09-06-character-sheet-view.md` §3. `--prove-red` is exercised inside the
harness (`self-prove-red` passes).

### 1.4 Other things the commands showed

- **`--twin` relative paths hold only in the Cowork mount view.** The mounts are flat (`mnt/AS4CE0001`,
  `mnt/c4`); the real roots are `F:\claude\AS4CE\AS4CE0001` and `F:\claude\c4` (`get_device_info`
  `connectedFolders`). From `AS4CE0001/h`, `../../c4/h` resolves in the mount and would resolve to
  `F:\claude\AS4CE\c4\h` on disk, which does not exist.
- **The corpus is two versions ahead of the index.** The index says *"`PERSONA-CORPUS.md` (v002, sentinel
  `PERSONA-CORPUS-2026-09-06-v002`)"*. `tail -1 PERSONA-CORPUS.md` → `sentinel:
  PERSONA-CORPUS-2026-09-11-v003`. The corpus also records a harvest of the Mentat sheet on 2026-09-11
  that the index does not mention.
- **A sheet's own count has moved.** Mentat §10 and the TSV both say the seat holds *161 notes*;
  `ls memory/*.md | wc -l` → **209** (2026-09-16).
- **Three things Mentat §3 names are not in Mentat's tree.** `h/w0rk.sh` → only at `c4/h/w0rk.sh`;
  `evidence/question-bank-iTNH.tsv` → only at `c4/evidence/question-bank-iTNH.tsv` — **both still true.**
  `pub/.gate` → **superseded by §0**: the shelf is at `F:\claude\corwin\pub`, a third root again, and
  it verifies. So §3 mixes *three* roots, not two, and still says so nowhere.
- **gw7's strongest receipt has no path — and now the host has been searched too.** The sheet cites
  "the log, line 2003" for the fingerprint install and quotes the `REACH-NORUN` refusal. Over the trees,
  `grep -rl 'emacs.pdmp'` returned only prose. With `~/emacs-build` granted (2026-09-16) there ARE real
  build logs — `ootb.log` (7055 lines), `build-zips.log`, `zip.log`, `git/emacs-29.0.60_1-src.log` — and
  `ootb.log` does mention `emacs.pdmp` at lines 507/643/1066/1073/7053. But **line 2003 of `ootb.log` is
  `ELC+ELN mail/mail-parse.elc`**, and **`REACH-NORUN` occurs in no log anywhere on this machine** —
  only in gw7's own sheet and in `h/DIAGRAM-2026-09-06-sheet-gw7.{json,svg,txt}`, where the label reads
  `refuse a foreign dump · REACH-NORUN: desired`. The diagram said "desired" all along.
- **gw7 has no twin.** `ls h/PERSONA-gw7.*` under the seat → "No such file or directory". Only the
  picture was mirrored (`DIAGRAM-2026-09-06-sheet-gw7.*` exists in both `h/`).
- **gw7 without `--corpus` loses a check.** `cd c4 && python3 h/cs1gk h/PERSONA-gw7.md` →
  `OK 13 · WARN 3 · FAULT 0 · NOTVISIBLE 1`. The corpus lives in the other tree, so the gauge's default
  lookup cannot find it.
- **Only gw7 carries a `sentinel:` line.** `grep -c 'sentinel:'` → gw7 1, mentat 0, shopgarden 0. The two
  seat sheets version themselves with a title `v1.1`/`v1.2` and a `LAST GOOD` HTML comment instead.
- **The rolls check out.** `LENS-2026-09-06-roll-v3-badguy.json`: seed 20260906, fate `ne'er-do-well`,
  `fate_from: h/LENS-2026-09-06-roll-v2.json`, `actor: system`. `LENS-2026-09-06-gw7-roll.json`: seed
  20260903, fate `ne'er-do-well`, `fate_from: None`, `validated: true`. Reuse and first-roll are both as
  the sheets describe them. No re-roll.

---

## 2 · JUDGED — what a reader cannot do with one file in hand

Ranked by what blocks **use**, not by what reads oddly. Each carries its falsifier.

### 2.1 Mentat — `CHARACTER-2026-09-06-mentat.md`

| # | blocks use | why it blocks | falsifier |
|---|---|---|---|
| **1** | **The relative paths have no stated root, and the root is not constant.** `h/`, `bin/`, `memory/`, `tests/` mean the seat; `h/w0rk.sh`, `evidence/…` and `pub/.gate` in the very same §3 table mean two *other* trees. | A reader who opens the file and follows any path is wrong a third of the time with no way to know which third. This is the one that turns the sheet from a document into a guess. | Show that a bare `h/…` in this file resolves from the file's own directory for every row of §3. It does not: `h/w0rk.sh` is only in c4. |
| **2** | **No invocation anywhere.** The sheet names `cs1gk` in §3 and §10 with a test count (`22/22`) but never gives the command, the flags, or the expected verdict. | The sheet's whole claim is "check me." A reader cannot. | Point to a line in the original file containing `cs1gk` followed by an argument. There is none. |
| 3 | Where an invocation *is* implied by the index, it is the stale `h/cs1gk` and exits 2. | The one pointer that exists sends the reader to a missing file. | Run `python3 h/cs1gk …` from the seat and get exit 0. It exits 2. |
| 4 | The TSV sidecar is never named in the sheet. | G5 — a third of the gauge's checks — reads a file the reader does not know exists. | `grep -c 'CHARACTER-2026-09-06-mentat.tsv' <sheet>` → **0**. The only `.tsv` the sheet mentions is `evidence/question-bank-iTNH.tsv`, a different file in a different tree. |
| 5 | Terms used and never defined *in this file*: `se1sn`, `ms1dg`, `landcheck`, `the ceremony dial`, `iTQA`, `GROW`, `LENS`, `the eclipse`, `A + seat`, `Q506/Q507/Q508`, `SK0L`. | Most get a usage sentence (good); `GROW`, `A + seat`, the bank Q-numbers and `iTQA`'s "House iT" do not. | Read §12's "on-ramp = … → pin = … → semaphore = … → copy = … → link = … → reflect =" without `MODEL-memory-grow.md`. The five words are a form the reader has never seen. |
| 6 | A claim whose source has moved: "the seat — 161 notes". | Now 209. A reader quoting the sheet quotes a stale number. | `ls memory/*.md | wc -l`. Returns 209. |

**Worst blocker: #1.** Not the missing command — that is the loudest, but a determined reader can find a
gauge. The un-rooted path is worse because it fails *silently and selectively*: the reader gets a file-not-
found on some rows and a correct file on others, and concludes the sheet is careless rather than
two-rooted.

### 2.2 shopgarden — `CHARACTER-2026-09-05-shopgarden.md`

| # | blocks use | why it blocks | falsifier |
|---|---|---|---|
| **1** | **The master file lives in the tree it does not describe.** The master is `AS4CE0001/h/CHARACTER-2026-09-05-shopgarden.md`; every bench path in it (`h/c4prime.h`, `h/w0rk.sh`, `h/words.sh`, `h/svg-a11y-test.sh`, `evidence/…`, `q/retention/`, `decks/…`) is rooted at `/f/claude/c4`. | A reader who opens the master, stays in that directory and runs the bench gets nothing — *every* row fails, and the failure looks like the bench is fictional. §1 does state the reach is `/f/claude/c4/`, 200 lines above the bench table, and never connects the two. | Run `sh h/c4prime.h` from the master's own directory. `h/c4prime.h` does not exist under the seat. |
| **2** | **No invocation, and the gauge is named only inside an HTML comment.** "Gauge: `h/cs1gk`" appears in the REPAIR comment — the one place a reader is least likely to look, and the path is stale for that tree. | Same as Mentat #2, one degree worse: the pointer is hidden and wrong. | Find a runnable command in the original file. There is none. |
| 3 | The `--corpus` flag is needed and unmentioned; the TSV sidecar is unnamed. | Two of the gauge's checks silently degrade. | As Mentat #4. |
| 4 | The handle is unblessed and the sheet says so twice — but a reader cannot tell whether that is still true. | "the name is the keeper's to give" has no date and no place to check for a ruling. | Point to a bank row or note that records the handle's status. The sheet names none. |
| 5 | Terms used and never defined here: `c4vy`, `SK0L`, `ep1nt`/`he2ma`/`a4ddr` (given as examples of a register, never as things), `iTNH`, `the Wire`, `EM`, `candor-gate`, `SEAM · PIN · FORT`. | `EM` is load-bearing — §9 is a concurrence from an entity a lone reader cannot identify beyond "ethicsminions". | Read §9 and say what EM is authorized to do. The sheet says only "Minions notice; they do not fix." |

**Worst blocker: #1.** A sheet whose every path is rooted somewhere other than where the sheet sits is the
purest form of "cannot be used alone" — the reader has the file and still has nothing.

### 2.3 gw7 — `PERSONA-gw7.md`

| # | blocks use | why it blocks | falsifier |
|---|---|---|---|
| **1** | **Its two strongest receipts do not verify — and the falsifier has now been run properly.** *(Rewritten after §0.)* The original wording made this a reach problem: "name the log file and this dissolves." `~/emacs-build` was then granted and searched. The logs exist; the quotes do not check out. `ootb.log:2003` is `ELC+ELN mail/mail-parse.elc`, not a fingerprint install. `REACH-NORUN` appears in **no log on the machine** — only in gw7's sheet and in its own diagram, which labels it `desired`. | gw7's entire claim on a stranger's trust is *"shown, not claimed."* One of the two showing lines points at the wrong line of a real file; the other quotes a program that has never spoken. That is not a citation gap, it is a rule wearing a receipt's clothes — the exact thing gw7 exists to refuse. | **Fired.** To restore the quote, make a program emit `REACH-NORUN` and cite THAT run. To restore the first, give the line its real number: `ootb.log:7053` is the fingerprint install (`install -c -m 644 src/emacs.pdmp …emacs-\`./src/emacs.exe --fingerprint\`.pdmp`) and reads as the sheet describes. Remaining doubt: this is one build tree of several; a log under `~/build-emacs` (empty) or elsewhere could still carry a line 2003 that fits. |
| **2** | **The gauge cannot check it as written.** The corpus is in the other tree, so the default lookup misses and the run reports `NOTVISIBLE 1`; a reader who then adds `--twin` gets `twin ABSENT`, because gw7's sheet was never mirrored. | The reader gets two scary-looking results that are both artifacts of geography, not of the sheet. | Run `cd c4 && python3 h/cs1gk h/PERSONA-gw7.md`. Prints `NOTVISIBLE 1`. Add `--corpus` pointing into the seat and it prints `OK 14 · WARN 3 · FAULT 0 · NOTVISIBLE 0`. |
| 3 | **Three standing WARNs with no note saying they are known.** G2 (no guards named), G3 (a change claimed without both evidence and story), G9 (no out-of-character watch). | A stranger running the gauge reads three WARNs as decay. `MODEL-…-character-sheet-view.md` §4 calls them "pre-existing"; the sheet does not. | Find, in the original sheet, any acknowledgement of a WARN. There is none. |
| 4 | The bench names `RUNCARD-unpack.org`, `RUNCARD-build-emacs-deb.org` and `he2ma` with no paths. | The run-cards are the sheet's own promise that "a stranger can bake at my bench without me in the room" — and the stranger cannot find them. They are at `derive/emacs-recipe/gw7/` and `bin/he2ma`. | `find c4 -name 'RUNCARD-unpack*'` → `./derive/emacs-recipe/gw7/RUNCARD-unpack.org`. Present, just unnamed. |
| 5 | Terms used and never defined here: `he2ma`, `the ring`, `REACH-NORUN`, `c4check`, `the dial`, `pocket`/`version pockets`, `DESTDIR` (explained well), `LENS`. | `the ring` and `pockets` carry the story; a reader guesses. | — |
| 6 | Host paths and tree paths are typographically identical. `/c4/emacs-cache/` is **on gw7**; `h/MODEL-gw7.md` is **in the file tree**. Both are bare. | A reader tries to `cd /c4/emacs-cache` on their own machine. | The sheet never distinguishes them. |

**Worst blocker: #1.** An oven whose receipt is unreachable is exactly the failure it wrote itself to
prevent.

### 2.4 Common to all three

- **None of the three names its own TSV sidecar**, though the gauge reads it for three of its rows.
  Receipt: `grep -c '<sheet-basename>.tsv' <sheet>` → **0** for all three. shopgarden mentions five
  other `.tsv` files and gw7 one, so the omission is of *its own* inventory specifically.
- None of the three gives the command that proves it. That command existed only in the index — the file
  the acceptance test says the reader does not have — and there it is stale.
- Versioning is inconsistent across the two trees: gw7 carries `sentinel: PERSONA-GW7-2026-09-06-v002`;
  the two seat sheets carry a version in the title and a `LAST GOOD` comment and no sentinel.

---

## 3 · The minimum addition, and why it is minimum

A sheet that inlines its corpus, its roll and its guards is not a sheet any more; it is a corpus with a
name on it, and the gauge's G6/G8 would have nothing left to check. So the addition is **one section per
sheet, before the first required section**, answering exactly five things:

1. **What am I** — in one paragraph, including the disclaimer that carries the fantasy/operational
   boundary (an instrument, a place, a host; no inner life claimed).
2. **What I do** — the acts, not the adjectives.
3. **What I refuse** — the floor, quoted from the sheet's own later sections, so a reader who reads
   nothing else still holds the line.
4. **How you check me** — the exact command with absolute roots, the expected last line, and the
   provenance of that expectation.
5. **What I need that is not in this file** — a table: *what · where it actually is · what you cannot do
   without it.* This is the part that makes an absence a fact rather than a hole.

Plus, per sheet, one paragraph naming the two-root trap, because that was the worst blocker on two of the
three and a silent one on the third.

**The design constraint I set myself: the header must describe the sheet without moving the sheet's own
measurement.** A preamble that quietly satisfies a check is worse than no preamble — it is the gauge
grading its own homework. So the headers avoid, by construction: the five LENS guard names (would change
G2's election list), the words `reorder|refine|mutation|growth|widen` outside a table row (would add a G3
paragraph), parenthesised single digits (would change G7's attribute count), the literal string
`break-character` in gw7 (would flip its G9 WARN to OK without gw7 having written a watch), and any
heading matching a required section's pattern (would shadow the real section and mis-target G1's body
checks).

**Receipt that it worked** — the improved sheets gauge *row-for-row identically* to the originals:

```
$ python3 cs1gk CHARACTER-2026-09-06-mentat.md    --corpus PERSONA-CORPUS.md
cs1gk: OK 17 · WARN 0 · FAULT 0 · NOTVISIBLE 0      (original: OK 17 · WARN 0 · FAULT 0 · NOTVISIBLE 0)
$ python3 cs1gk CHARACTER-2026-09-05-shopgarden.md --corpus PERSONA-CORPUS.md
cs1gk: OK 17 · WARN 0 · FAULT 0 · NOTVISIBLE 0      (original: OK 17 · WARN 0 · FAULT 0 · NOTVISIBLE 0)
$ python3 cs1gk PERSONA-gw7.md                     --corpus PERSONA-CORPUS.md
cs1gk: OK 14 · WARN 3 · FAULT 0 · NOTVISIBLE 0      (original: OK 14 · WARN 3 · FAULT 0 · NOTVISIBLE 0)
```

(17 not 18 because these staging copies are gauged without `--twin`; the G8 row is the eighteenth.)
gw7's three WARNs are **still three**. The header names them as known and does not answer them, because
answering them means electing guards and writing a watch on gw7's behalf — persona changes, his to rule.

**Preservation receipt:**

```
$ diff ORIGINAL IMPROVED | grep -c '^<'
0    (mentat)      0    (shopgarden)      0    (gw7)
```

Zero lines removed or changed in any of the three: every edit is an insertion. Every sentinel, `LAST
GOOD` comment, `actor:` key, `REPAIR`/`GROWN` comment, version marker, frontmatter fence and NEWS mark is
present and unmoved. The three `.tsv` sidecars are byte-identical to the originals (`cmp -s`).

**Files written** (staging only — nothing under his mounts was touched):

```
/home/claude/build/staging/persona/
  CHARACTER-2026-09-06-mentat.md       17971 → 23492 B
  CHARACTER-2026-09-06-mentat.tsv      unchanged
  CHARACTER-2026-09-05-shopgarden.md   16099 → 21993 B
  CHARACTER-2026-09-05-shopgarden.tsv  unchanged
  PERSONA-gw7.md                       15123 → 21330 B
  PERSONA-gw7.tsv                      unchanged
  AUDIT-sheets-standalone.md           this file
```

---

## 4 · Consolidation — what it should mean here

**One index over two homes. Not one home.** The sheets stay where they are; the index becomes the thing
that is single, correct and mechanically checked.

The argument comes from what `PERSONA-INDEX.md` already is and already does:

1. **It already chose the shape.** The index is explicitly *"a link note… Not a ledger: every row names
   the gauge that proves it."* It is already a one-index-over-two-homes instrument. The consolidation
   work is not to change its shape but to make its rows true — today the gauge column is stale in all
   three rows and the corpus version is two behind.
2. **The two trees are not two copies of one thing; they are two different things.** c4 is a place with
   its own floor, its own bank, its own signed door, and gw7's sheet is *about* an object inside c4's
   reach. The seat is an instrument's workspace. shopgarden's own §8 rules that "a place wants to live in
   its own tree" — moving sheets to one home would overrule a persona's recorded discretion to satisfy a
   filing preference. That is a bad trade.
3. **The house's own seam doctrine argues against a single home and for a named tiebreaker.** The pattern
   here is already twin-with-both-shas-printed (`cs1gk --twin`, "mtime is never the tiebreaker"). Two
   homes with a declared master and a mechanical SAME/DIVERGED check *is* the house pattern. Collapsing
   to one home would delete the check rather than satisfy it — and the check is currently the only thing
   that would catch a divergence.
4. **The evidence that one-home would not have helped.** The thing that actually broke was a *pointer*,
   not a location: the tools moved within a single tree (`h/` → `bin/`) and three separate notes went
   stale. One home would have broken in exactly the same way. Conversely, the one real divergence I found
   — the two `cs1gk` copies — is benign and would have been caught immediately by a gauge row over the
   index.

**So, concretely, what "consolidated" should mean — proposed, not done, and none of his files moved:**

- **Masters stay put.** Seat sheets master in `AS4CE0001/h/`, gw7 masters in `c4/h/`, twins as now.
- **The index gets one more column and one more gauge row: does the command in this row actually run?**
  Today it does not, in all three rows. That is a one-line check (`sh -c "<cmd>" >/dev/null; echo $?`)
  and it is the check that would have caught the 09-13 move on the day it happened.
- **Fix the three stale pointers** — the index's three `h/cs1gk` commands, the corpus's two
  `gauge h/cs1gk` mentions, and the index's `PERSONA-CORPUS.md (v002 … 2026-09-06)` line, now v003
  (2026-09-11).
- **Give gw7 a twin, or write down that it deliberately has none.** Right now `--twin` reports ABSENT and
  the reader cannot tell whether that is a decision or a lapse.
- **Pick one versioning form.** Either all three carry a `sentinel:` line or none do. gw7 does; the other
  two do not.
- **Do not fold the sheets into the corpus.** The corpus is the *voice*; the sheets are the *possessions
  as documented*; the TSVs are the inventory. `MODEL-2026-09-06-character-sheet-view.md` §1 keeps those
  three apart on purpose and §5 says the sheet must not be load-bearing. Merging them would make the
  sheet load-bearing, which the model forbids.

*Falsifier for the whole recommendation:* if he intends the seat tree to be disposable — a workspace that
gets rotated or archived — then a master living there is a master living on sand, and everything should
move to c4 with the seat holding copies. I found `.arc/2026-09/` archives in the seat (including an
archived `PERSONA-CORPUS`), which is weak evidence in that direction. `[MINE ~70%]` that two homes is
right; his ruling on the seat's lifetime settles it in one sentence.

---

## 5 · Wants the owner's ruling

1. **The gauge's two homes.** `AS4CE0001/bin/cs1gk` and `c4/h/cs1gk` differ by one comment line, and the
   seat's is newer. Which is master? Same question for `rf1bm`, `dc1sv`, `ms1dg`, `se1sn`. *Falsifier for
   my calling this a concern: if the tools are deliberately per-tree forks, it is a design, not a seam —
   but then the index should say so.*
2. **gw7's three WARNs.** Elect its guards, write its out-of-character watch, and give that one paragraph
   its evidence-and-story? Each is a change to gw7's persona, so I did not make it. The model calls them
   "pre-existing"; that is a description, not a decision.
3. **gw7's build log.** Where is it? Two of gw7's receipts depend on it. If it lives only on the host,
   the sheet should say so; if it is gone, those two quotes should be marked *quoted, not run*.
4. **Vibrobeast: persona or register?** §7 asks this directly and names the alternative (retire the name).
   It has been open since 2026-09-06 and it changes whether there is a fourth sheet.
5. **The handle `shopgarden`.** Offered at ~50% confidence, twice flagged as unblessed, still unblessed.
6. **The stale "161 notes"** (now 209) — the sheet's own rule is that a number comes from a run. Update,
   or replace with the command that produces it? I would replace it with the command, but that is a
   change to his sheet's body, not a header, so I left it.
7. **The corpus harvest, recorded 2026-09-11,** says the Mentat sheet v1.1 has been harvested into the
   corpus (§§2, 5, 7, 8, 11, 13, 14 yielded nodes). If sheets and corpus are now coupled that way, an
   edit to a harvested section has a downstream effect the sheet does not mention.
8. **Whether these headers should be adopted at all.** They are additions to files a persona wrote in its
   own voice. `MODEL-…-character-sheet-view.md` does not forbid a preamble, but it also did not ask for
   one, and I am saying so rather than letting silence read as permission.

---

## 6 · What I did not do

- I did not edit anything under his mounts. Everything above was read; the writes are all in
  `/home/claude/build/staging/persona/`.
- I did not invent a gauge. I ran `bin/cs1gk` and `tests/cs1gk-tests.sh` as they stand.
- I did not answer gw7's three WARNs, mint an attribute, elect a guard, bless the handle, or re-roll
  anything.
- I did not verify the Drive ferry, the signatures, or `PERSONA-CORPUS.md`'s mirror; the index's
  `receipts.log` claim is unchecked by me and I am not reporting on it either way.

sentinel: AUDIT-SHEETS-STANDALONE-2026-09-16-v001
