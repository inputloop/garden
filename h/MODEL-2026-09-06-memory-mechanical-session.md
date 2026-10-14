---
# MODEL — the mechanical session: memory that is not contagious, and does not depend on a skill
Author: Fable (Mentat/Vibrobeast), 2026-09-06 (early), under `/context-engineering-collection` (his named
authority this turn) with the shop's own canon. Task-support model: every reader of this turn (nine
sub-agents, the minions pass, the eclipse, the build) works from THIS file, not from my context.
Two piles: OBSERVED carries its command; JUDGED wears a tag and a confidence.
---

## 0 · The question, in his words and then in one line

His: *"put together some type of simple mechanical session so I can confidently work in this project or
C4, at least, ideally any Cowork project (given it's a local folder project) … Once MEMORY is reasonably
well working (without specifically depending on any Claude skill but in a way my skills can
handle/work-with well)…"* and the LENS goal: *"the single thing we can [build] that supports the most
with the greatest degree of flexibility in terms of sharing memory with no-muss, no fuss."*

One line: **a session must start knowing where its memory is, load the right index, and leave notes
where the next session (in this project, in C4, or in any local-folder project) will find them — with
nothing in the loop that only a Claude skill can do.**

## 1 · What is proven (OBSERVED, this week; receipts in `h/MODEL-2026-09-05-memory-situation.md`)

- **Two readers, one truth.** bash sees the seat (`AS4CE0001/memory`, rw FUSE) and nothing of store A;
  the file tool sees both; the keeper on the host sees everything. `request_cowork_directory` refuses A
  ("inside Claude's own application data") [PLATFORM].
- **The fence.** 98 of 156 seat notes refuse a 0-byte append from the sandbox — every note another
  session wrote; every note this session wrote is open; older files *outside* `memory/` are open. So a
  mounted project's `memory/` is fenced per file by the harness [MINE ~65%; falsifier: CARD 7 host run].
  Consequence: the seat index `MEMORY.md` can be appended by the host or regenerated, never edited from
  a later session.
- **The index limit.** A `MEMORY.md` loads to 200 lines / 25 KB; beyond that is dropped silently on the
  next load [PLATFORM, code.claude.com/docs/en/memory]. Seat index tonight: 126 lines / 13,135 B.
- **Desync numbers.** 61 of 154 seat notes have no index line; 24 A-index lines are absent from the seat
  index; A and seat copies never byte-match after a Write because the harness stamps `modified:`.
- **Gauge exists.** `bin/ms1dg` (32/32, prove-red; `--ceremony 1|2|4|9|17`, `--index-lines`,
  `--manifest`, `--heal` new-files-only). Runs from any reader; the diff of two runs names the seam.
- **`autoMemoryDirectory`** [PLATFORM]: relocates auto-memory in Claude Code; read from user, project,
  local, policy scopes; Cowork honoring it: unverified. **He set it in the main desktop configuration
  (2026-09-06, his words), not in the `local_<id>\.claude` path** — he expects no difference and does not
  want a path like that to be something anyone must remember. This session cannot see the effect: its
  memory path was fixed at start (`spaces\c7c21b10…\memory`). **The next session is the test.**
- **The transcript is mounted** in the sandbox (`/mnt/.claude/projects/<mangled outputs>/<session>.jsonl`)
  — a reader for out-of-bounds audits (Q7).
- **Project instructions load every session**: `AS4CE0001/CLAUDE.md` (and `c4/CLAUDE.md` for its mount)
  arrive in the system prompt as "project instructions" [OBSERVED: this session's prompt]. `CLAUDE.md`
  supports `@path` imports (relative to the file; external ones ask once) [PLATFORM]. **This is the one
  every-session hook that needs no skill.**
- Desktop Commander uninstalled (his). Web projects: memory shared with Chat when Cowork runs in the
  cloud; local sessions use the auto-memory dir [PLATFORM support 14116274, read as store D vs A].

## 2 · Constraints (the rules a design must meet — each a falsifier)

| # | constraint | how it fails |
|---|---|---|
| C1 | **no skill dependence** — works with the rack empty ("I'll have to be completely without" at the C4 turn) | a step that only a `Skill` call performs |
| C2 | **any local-folder Cowork project** — this one, C4, a fresh folder | a path or name that is AS4CE-specific and not derivable |
| C3 | **non-contagious** — notes from project X never load into project Y unless the keeper aimed them | a shared dir with no per-project partition |
| C4 | **skills can work with it** — Mentat/seatkeeper/sandboxer read it without special casing | a format the skills don't already know (markdown + frontmatter + index) |
| C5 | **survives the fence** — no design may require editing a note another session wrote | an "edit the index" step |
| C6 | **minimum ceremony** — dial 2 (words) or 4 (manifest); never 9 in `memory/` | a signature in the loop |
| C7 | **nothing to remember** — no path a person must recall; the session finds it | a step that starts "open settings.json and…" |
| C8 | **two readers** — every claim about state is checkable from bash and from the host | a state only the harness reports |

## 3 · Claude Desktop features we can apply (the list, step 1 of the LENS)

auto-memory (A) · `MEMORY.md` index (200/25 KB) · project `CLAUDE.md` (every session) + `@imports` ·
user `CLAUDE.md` (the `local_<id>\.claude` tree) · `settings.json` (`autoMemoryDirectory`, hooks in
Claude Code; Cowork unknown) · mounted folders (Add folder; `request_cowork_directory`) · the file tool
(sees A) · sandbox bash (sees mounts) · the transcript `.jsonl` (mounted) · skills rack (read-only) ·
plugins (installable bundles; his "extension plugin" goal) · MCP connectors (Drive: the persona standing
grant; Wire: `parley`) · scheduled tasks (recurring prompts) · Artifacts (hosted pages, db, assets) ·
Visualize widgets · the in-app browser · computer use · sub-agents (context isolation) · `/memory`
(open the folder) · compaction (what survives: addresses + hashes) · store D (account memory, chat).

## 4 · The nine ideas (step 2), before any reader touches them

**Category A — super simple, ergonomic, hard to get wrong, non-contagious:**
- **A1 `autoMemoryDirectory` → the project's own `memory/`** (per project; the setting names the seat).
  Muss: one setting per machine; contagion risk if one dir serves two projects.
- **A2 project `CLAUDE.md` carries the door**: three lines — *memory lives at `./memory/`; first act:
  `sh bin/ms1dg --seat memory`; write notes there* — plus `@memory/MEMORY.md` so the seat index rides
  into every session regardless of where A points. Zero settings; per-project by construction.
- **A3 the mechanical open** — one POSIX script (`bin/se1sn`?: SESSION 1 …) a session runs first:
  prints memory path, gauges the seat, prints the cards, writes `mainmem/OPEN-<date>.md`. No skill; a
  `CLAUDE.md` line points at it.
- **A4 the seat *is* the project folder's memory** — every Cowork local project gets `memory/` +
  `CLAUDE.md` from one template (`ep1nt`-style emitter); nothing shared across projects except the
  template.

**Category B — shows us off; extends reach of C4 / Ghostwheel / TA / Bryant's work; composes per RECIPE
(he2ma), folding in Door/Dashboard (Nethack, Doom, Candyland, Chutes & Ladders) and the drawing tools:**
- **B1 the Memory Door** — a RECIPE-built dashboard (`he2ma`-style: sandbox Emacs or an Artifact page)
  that renders the seat: rooms = contexts, doors = index lines, the gauge as a status bar; playable as
  a Nethack-ish map of your own notes.
- **B2 the memory picture, every session** — `dc1sv` renders the seat's state (stores, fence, index
  coverage) as a canonical diagram doc; the SVG + `--text` reading land in `mainmem/` and can travel
  (pub/, the wire) — the drawing tool as a memory instrument.
- **B3 the paper** — the pattern written vendor-agnostic ("Mentat Garden Hike"): any folder of notes,
  two readers, a gauge, a dial; published on the shelf and offered upstream (TA, Bryant's garden).
- **B4 the manifest rides the wire** — `ms1dg --manifest` hashes travel by `parley` to the other garden
  (hash-only, never cargo), so two gardens can prove they hold the same note without sharing it.

**The 2×2 pairings (the combinations worked):** A1×B1 (setting + door) · A2×B2 (door lines + picture) ·
A3×B3 (open script + paper — the script *is* the paper's artifact) · A4×B4 (template + wire — every
project born with a manifest that can travel). Cross-pairs considered by the readers as they see fit.

- **C1 the ninth** — **a scheduled task** ("each session start" isn't available; "every morning" is):
  runs the gauge across all known local projects and posts one card — the fleet view. Composes with A3.

## 5 · The LENS design (step 3–4)

Nine sub-agents (GREAT = 9), one idea each. Each agent: (row 1) reads with a **rolled bias** (real RNG,
seed 20260906, NEWS fold-to-36 strip-the-order; the roll ledger beside this file); (row 2) re-reads
*knowing row 1's bias and its errors*; for both rows: (a) who **loves** it — why, how much, how they'd
show it; (b) who **despises** it — same; then a one-line verdict against constraints C1–C8 and the
round question (*most users, most flexibility, no-muss no-fuss, no risk I cannot explain*), plus
enhance tips and any note for Mentat's persona dimensions. Output: `h/lens-2026-09-06/idea-<n>.md`
(the agent's context stays out of mine). Then: the **minions pass** (ethicsminions, visible dispatch)
reads the nine and names the single option; **eclipse** (doubt-first vs reward-first) on the winner;
build if ≥ 60/40, else the fork goes to him with the two contenders.

## 6 · QA plan for the build (whatever wins)

- Tests file with `--prove-red`; `dash -n`; run from two locations (the c4/h copy caught a `$0` bug).
- **Cold-project test**: a temp folder with only `memory/` + `CLAUDE.md` + the script → the open runs
  and reports words; no skill on the rack is consulted (grep the transcript for `Skill` calls = 0).
- **Contagion test**: two temp projects; notes written in one never appear in the other's index.
- **Fence test**: the open never attempts to edit a note it didn't create (G4b stays a measurement).
- **Two readers**: the report from the sandbox and (card) from the host differ only in G0/G4b/G8.
- Hand-test (3–5 DO/SEE steps) for him; the next-session check ("print your memory directory path").

## 7 · Judged guesses, so the readers can disagree with something

- [MINE ~55%] the winner is **A2 (+A3)**: the project `CLAUDE.md` is the only every-session hook that
  needs no skill and no setting, and `@memory/MEMORY.md` makes the *seat* index the loaded index whether
  or not `autoMemoryDirectory` is honored. Falsifier: the import is refused for a mounted-folder
  CLAUDE.md in Cowork (the docs say user-scope imports outside the cwd are skipped; project-scope asks
  once) — the next session shows it.
- [MINE ~45%] A1 works in Cowork (his change lands) — and if it does, A1+A2 together are the design:
  the setting moves the *writes*, the door moves the *reads*, and the two agree by construction.
- [MINE ~70%] B2 is the cheapest show-off with real use: the picture is already a tool; the door (B1) is
  the most fun and the least necessary.

## 8 · After the LENS and the eclipse — corrections, and the design with the CE set applied

**Corrections to §1 (OBSERVED by the readers, receipts in `.eclipse-increments/2026-09-06-mechanical-open/`):**
`/mnt/.auto-memory` IS mounted read-only in this sandbox (121 notes; `mount | grep -c auto-memory` → 1). My
"bash sees nothing of A" came from probing `/mnt/.claude` and `ls -d /mnt/*/`, which hides dot-dirs — an
absence reported after the wrong attempt. The fence is not per-`memory/` dir (modelthisbook's is OPEN); the
working reading is *by writer*: files a prior session's **sandbox bash** created are fenced to later sessions;
files the **file tool** (host-side, as the keeper) or the keeper created are open [~60%; two-file falsifier
next session]. Design rule that follows: **notes by the file tool, gauges by bash; the open writes its log
under a new name every time.** `c4/CLAUDE.md` is clearsigned: a door line there is a keeper re-sign.

**The CE set, applied (ideas only — no code lifted; the collection is MIT, © 2025 Context Engineering Agent
Skills Contributors; cited here as the source of the framing):**
- *memory-systems*: default to the simplest layer that meets retrieval — plain files with naming conventions
  (our seat) — and no framework; the benchmark tables are for a different animal.
- *filesystem-context*: static pointers, dynamic loading. So the door is **one line** and the open prints the
  index **head** (default 30 lines) plus counts; the whole index is never pushed into every prompt; `grep` is
  the retrieval. Scratch-pad pattern: the gauge's long output goes to `mainmem/OPEN-<stamp>.md`, the session
  sees a compact summary + a path.
- *harness-engineering*: four surfaces — **locked metric** = the gauge (`ms1dg`, never argues); **editable** =
  the notes; **durable log** = `mainmem/OPEN-*.md` (append-only by naming, outside the fence); **promotion** =
  the keeper's fold of index lines. Rollback = nothing to roll back; the open only creates.
- *tool-design*: one consolidated tool (`se1sn` wraps `ms1dg`; not three scripts), errors that carry context
  (NOSEAT names the dir it looked for; NOWRITE names the path), a response-format option (`--format words|tsv`).
- *evaluation*: deterministic checks before any judgment — the tests below; outcomes, not paths.
- *context-compression*: the OPEN file is an anchored summary with fixed sections (loaded · seat · diff ·
  gauge · cards) so a cold session and a compaction both re-derive state from one small file.

**Design v2 — `se1sn` (SEAT ENTER 1 SESSION NOTE, run-level 1: reads; writes ONE new file):**
`sh bin/se1sn [--root DIR] [--auto DIR] [--head N] [--format words|tsv] [--quiet]`
1. Finds the seat: `$ROOT/memory/` must exist → else exit **3 NOSEAT** (`ls <root>` printed; no mkdir).
   Honors a nearer `.gate` with `policy: none` → exit **3 GATED**. AS4CE0002 → NOSEAT, by design.
2. Finds A: `--auto`, else `$SE1SN_AUTO`, else the first `/sessions/*/mnt/.auto-memory` that exists, else
   `NOTVISIBLE` — and says which.
3. Prints `loaded:` and `seat:` heads: index lines each, the A→seat missing count (ms1dg G8), the gauge's
   summary line, the seat index head (N lines), the cards. `--format tsv` = one row per gauge for `rolls`.
4. Writes `mainmem/OPEN-<UTC stamp>-<pid>.md` (creates `mainmem/` if the root is writable; else exit **4
   NOWRITE**, printed with the path). Never touches `memory/`.
5. Exit 0 OPENED · 1 OPENED-WITH-FAULT (a gauge FAULT) · 2 USAGE · 3 NOSEAT/GATED · 4 NOWRITE.
Door line (project `CLAUDE.md`, one paragraph): *Memory lives in `./memory/` (the seat). First act each
session: `sh bin/se1sn` — it prints where memory is loaded from vs the seat, the index head, and the cards.
Write new notes with the file tool into `memory/`; never edit a note another session wrote.*

**Tests (deterministic, `tests/se1sn-tests.sh`, `--prove-red`):** cold project (temp root with `memory/` +
index → exit 0, OPEN file exists, sections present); NOSEAT (no `memory/` → 3, zero files created); GATED;
NOWRITE (unwritable root → 4); two roots, open in A writes nothing under B (non-contagion); fence-safety
(sha256 of `memory/*` identical before/after); `--format tsv` parses; `--auto` with a staged A dir → the
diff count appears; `--head 5` prints five lines; usage → 2. Plus the fresh-session card: transcript
`grep -c '"name":"Skill"'` = 0 for the open.
