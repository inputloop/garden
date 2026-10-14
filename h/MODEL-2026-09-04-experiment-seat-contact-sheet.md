---
# MODEL — seating an experiment you can draw before it runs
## (the reading it took · what would have helped more · the contact sheet)
Stand-alone static model, 2026-09-04, Fable (Mentat/Vibrobeast, Cowork) for Corwin.
Written from the **visualization's** side of the problem: to draw a tree "as new files will
appear," you must decide names, states, and boundaries *before* any file exists — so the
picture is a spec check, not decoration. Copies: `/f/claude/AS4CE/AS4CE0001/h/` (this) and
`/f/claude/c4/h/` (the C4 duplicate, same bytes at copy time). Find it later by memory slug
`experiment-seat-as4ce0002`, by c4 `MEMORY.md` dated section 2026-09-04 (evening), and by
bank rows Q503/Q504.
---

## 1. The problem, from the picture's side

A tree drawn before the files exist forces three decisions prose lets you defer:

1. **Names before bytes.** `h/runs/<date>-<model>-<n>/` had to be fixed so the picture could
   show a run dir that doesn't exist yet — which is why `bin/land.sh` exists: the tool *is*
   the naming convention, made mechanical and collision-safe.
2. **States as words.** Every entry in the picture carries one of five words — *seeded ·
   minted · landed · keeper · out of bounds* — never a hue alone (rolls guard 4; contrast
   computed, 8.3–8.9:1 light, 6.3–6.6:1 dark, quoted in the widget's screen-reader line).
   The words are also the lifecycle: seeded (exists, hashed) → minted (land.sh, start of
   run) → landed (run writes at close) → keeper (only a human hand: `rm`, signing).
3. **The boundary, drawn.** What a run may read is a line on the picture: `AS4CE0001` is a
   greyed neighbor marked *out of bounds*; `c4` and `ccspt` are *asked for*. Prose said
   "fair and unspoiled"; the picture made it a place you can point at.

**Degree of the C4 way, honestly:** *plan* (this model + README) ✓ · *plan-quality check*
(the picture caught the missing naming/boundary decisions) ✓ · *build with tests*
(`land.sh`; `landcheck.sh` + 9 fixture tests + `--prove-red` on both harnesses) ✓ · *QA in
the loop* (the first test run went red on a real bug — `grep -c || echo 0` — fixed, re-run
green; the manifest self-hashed twice before I wrote it to `/tmp` first) ✓ · *redesign
planning* — one redesign happened live: the scorer moved from the seat to the authors' tree
so a run can't read its own rubric ✓ · *one-time guard for redesign out of QA* — the
`.gate` files and the "out of bounds" line are that guard; **not** built: a mechanical
check that a run *didn't* read `AS4CE0001` (a transcript-side check, no file-side
falsifier) ✗ · *sign at the door* — nothing signed; `land.sh`/`landcheck.sh` are drawer
tools until Corwin says ship ✗.

## 2. The reading it took (ledger — what each gave, and how much it helped)

| source | address | gave | helped |
|---|---|---|---|
| transcript, origin session | `local_9276de04` (session_info) | the source turn's prose; the "you need it all" paragraph; the first STEP ZERO | HIGH, expensive |
| transcript, S1 session | `local_26d13960` | what Opus did and didn't call (no folder request) | HIGH |
| 7 prompt versions | `AS4CE0001/h/PROMPT-2026-09-04-csspt-lens-selfcheck*.md` | the blessed passages that must stay byte-identical | HIGH |
| QA cards S1–S3 | `AS4CE0001/h/QA-2026-09-04-csspt-prompt-*.md` | the misses already named; not re-derived | MED |
| hypothesis md/tsv | `AS4CE0001/h/HYPOTHESIS-2026-09-04-csspt-prompt-by-model.*` | which checks a file can answer → `landcheck.sh`'s ids | HIGH |
| ccspt README + design §boundary | `/f/claude/projects/ccspt/ccspt/` | the facts that replaced three sessions of guessing | HIGH |
| c4 question bank | `/f/claude/c4/evidence/question-bank-iTNH.tsv` (`grep -i ccspt`; row shape 6 cols) | Q432–Q436; the bank's row format for Q503/Q504 | HIGH |
| c4prime | `sh /f/claude/c4/h/c4prime.h` | repeat faults: *presence-for-content → hash*; *bounded-read → cat it* — both bit me this turn | MED |
| c4 CLAUDE.md | `/f/claude/c4/CLAUDE.md` | mounts-are-authoritative; FILE BY WORDS; drafts in h/; sign at the door | MED |
| seatkeeper SKILL | skills dir | the moves; **stale on platform truth** (A can't be mounted by path tonight) | HIGH for shape, LOW for truth |
| rolls SKILL | skills dir | four guards: UNSET counted, words not hue, contrast quoted | HIGH |
| excurutate.sh, boxscore-tsv.sh | `/f/claude/c4/bin/` | one measured datum (words/mwl per version); the other tool's column binding | HIGH / LOW |
| memory notes (A store) | `csspt-*`, `verify-mount-*`, `named-skill-visible-dispatch`, `dotgate-signpost`, `tool-homing-rule`, `duplication-c4-or-pmo`, `c4-spoilers-capsule`, `prefers-mingw-paths` | the rules this seat obeys | HIGH |
| the screenshot | uploads | what Corwin *saw* when the picker popped: "Asking to access a folder" and nothing else; the **Add folder** label | HIGH — unguessable from my side |
| eclipse verdict | `/f/claude/c4/.eclipse-increments/2026-09-04-signing-in-the-mint-path/verdict.md` | that the origin session's "absent" file was a mount problem, not an absence | MED |

Roughly twenty-five sources; about a third of this turn's tokens were reading. The reading
that paid best per token was the *cheapest*: the screenshot, the bank grep, `c4prime`. The
reading that paid worst was re-deriving lineage from transcripts — which a contact sheet
would have made unnecessary.

## 3. What would have helped more

One page, kept current, that answers "where is it, how do I reach it, who holds it, how do I
know it's fresh" for every thing this work touches — the sheet in §4. Specifically missing
until tonight: a **mount table with who-sees-what** (bash vs file tool vs keeper); the
**house numbers** in a findable place (GRAIN/GREAT/GRAND lived only in Corwin's head);
a **spoiler line** convention (what is out of bounds for whom — now `.gate` + the README);
and a **platform-truth ledger** (what the harness refuses today: app-data mounts, `rm` on
AS4CE mounts, the editor lock on the seat index) so a skill written last week isn't
trusted over tonight's tool result.

## 4. The contact sheet ("all my socials, new fren")

| thing | reach it at | how to reach | held by | freshness check |
|---|---|---|---|---|
| the experiment seat | `/f/claude/AS4CE/AS4CE0002/` | connect the folder; read `README.md` | Corwin (folder) / Fable (seeded) | `sha256sum -c h/kit/MANIFEST.sha256` → 10 OK |
| the prompt to paste (S4) | `/f/claude/AS4CE/AS4CE0002/PROMPT.md` | paste whole into a fresh session | Fable; Corwin edits | sha `e39570297475` at seeding; any edit = new sha, re-bind hypotheses |
| mint a run | `sh bin/land.sh <model-id>` from the seat root | prints `h/runs/<date>-<model>-<n>` | Fable | `dash -n bin/land.sh` |
| score a run | `sh /f/claude/AS4CE/AS4CE0001/bin/landcheck.sh <run-dir>` | one line per check; exit 1 on FAIL | Fable | `sh tests/landcheck-tests.sh` → 9 passed; `--prove-red` on both |
| the hypotheses | `/f/claude/AS4CE/AS4CE0001/h/HYPOTHESIS-2026-09-04-csspt-prompt-by-model.{md,tsv}` | fill `result` after a run | Fable; Corwin scores | bound to S3 sha `f02435d08af8`; S4 is `e39570297475` — re-date if scoring S4 runs |
| the prompt lineage (7) + cards (S1–S3) | `/f/claude/AS4CE/AS4CE0001/h/PROMPT-2026-09-04-csspt-lens-selfcheck*.md`, `QA-2026-09-04-csspt-prompt-*.md` | read; out of bounds for runs | authors | `ls` count = 7 + 3 |
| ccspt (primary) | `/f/claude/projects/ccspt/ccspt/README.md`, `ccspt-mvp-design.org` | request the folder; read; never edit | Corwin + Mentat (authors) | README pipeline line still says Gate 1 / Gate 2 |
| the bank | `/f/claude/c4/evidence/question-bank-iTNH.tsv` | `grep -i ccspt`; deal cards via `sh h/w0rk.sh Qnnn`; never hand-compose a card | Corwin (rulings) | last id ≥ Q504 |
| the door | `sh /f/claude/c4/h/c4prime.h` | run first when working in c4 | c4 | prints today's date |
| the pass behind #184/#185 | `/f/claude/c4/.eclipse-increments/2026-09-04-signing-in-the-mint-path/verdict.md` | read | authors | exists (6,735 B) |
| the confusion gauge | `sh /f/claude/c4/bin/excurutate.sh -s FILE…` | measures words/mwl; never judges | c4 | prints `EXCURUTATION BOX-SCORE` |
| memory, store A | `…/spaces/<id>/memory/` (Cowork's own) | file tools only; **cannot be mounted by path** (refused tonight) | platform | `Glob *.md` count = 103+ |
| memory, the seat (B) | `/f/claude/AS4CE/AS4CE0001/memory/` | file tools + bash; index `MEMORY.md` was **editor-locked** tonight | Corwin | `ls *.md \| wc -l` = 138 |
| the receipts of memory moves | `/f/claude/AS4CE/AS4CE0001/SEATDIFF-2026-09-04b.md` (+ `-04.md`, `-01.md`) | read | Fable | sha `690d3b84e192` |
| skills that govern this | `seatkeeper` · `rolls` · `verify-say` · `sandboxer` · `dotgate-signpost` (memory) · `tool-homing-rule` (memory) | Skill tool / memory slugs | Corwin installs; Fable authors | `seatkeeper` move 1 is stale — see §3 |
| the folder tool | `mcp__cowork__request_cowork_directory` (path → approve dialog; no path → picker) | **say folder + purpose in chat first**; app-data paths refused | platform | tool present in `ToolSearch` |
| the UI map | Cowork composer → **Add folder** | for Corwin when the tool is absent | Corwin | screenshot 2026-09-04 |
| people & agents | Corwin (keeper: approves, signs, rules) · Fable/Mentat/Vibrobeast (instrument) · Alfred ↔ Claudewin over the Wire (`parley`; ≤95-char telegraph) · Bryant (extern skills; `candor-gate`) | as named | — | `wire-claudewin-alfred` memory |

## 5. Being specific about the right things — an appeal to both of us

**To Corwin:** the dialog you see says "Asking to access a folder" and nothing else — so
when I ask, I will name the folder and the purpose in chat first; if a request arrives
bare, treat it as my miss and pick nothing. One fresh Cowork project per candidate run
keeps memory from leaking between runs. ~~Say what `AS.CE:`…`CE.AS:esu` is and I'll pin it.~~
*Pinned 2026-09-04 (late), his answer: the SLIDE — `asce` Application Spoke Command
Environment ↔ `ecas` Container Environment for Application Spoke; the slot holds the
run-level; 4 GRAIN · 9 GREAT · 17 GRAND. Memory `as-ce-slide`; bank Q504 ANSWERED-BY-KEEPER.*
`rm` and the seat index are yours tonight (two cards in the SEATDIFF).

**To me (and whoever wears this next):** hash, don't stat (a `__pycache__` and a self-hashed
manifest both came from trusting presence). Run first, write second (four instances this
session of a number typed before the tool ran). State path + purpose before any call that
pops a dialog. `PYTHONDONTWRITEBYTECODE=1` on a mount that refuses `rm`. Never
`grep -c … || echo 0`. Draw the tree before the prose — it finds the undecided names.

---
*Footer — provenance. Fable (Mentat/Vibrobeast), 2026-09-04 evening, Cowork session
`local_b35451fe`. Bytes here are the master; the c4 copy is a duplicate "the C4 way" (a
draft in `h/`, a dated section in `MEMORY.md`, two rows in the bank). Corwin decides what
stays; a keeper edit on either copy makes that copy the newer, not the truer — reconcile by
hand, never by mtime.*
