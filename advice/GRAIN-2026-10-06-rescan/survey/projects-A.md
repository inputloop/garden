# Survey A: /f/claude/projects, "AIVB" through "dungeon-roguelike"

Surveyed 2026-10-06, read-only on F:. Tests I ran, I ran on copies in the VM's /tmp (ccspt, drift, tend-fluxer, refmodel.py). The VM has no Emacs, so no ERT suite was run by me; ERT counts below are `grep -c ert-deftest`. Tags: T1 USB/GNU-Linux and app shell, T2 Brust, T3 orgvm/egad/ghostwheel, T4 FOSS index and governance, T5 talks/papers, T6 routines, T7 C4 CI/releases/signing.

## 1. card-game: the lurking sub-product

OBSERVED. `/f/claude/projects/card-game` is a wrapper (CLAUDE.md pointer, model.md, reviews, runcards, snapshots, a MELPA clone) around `card-game.el/`, the shipped repo. card-games 1.0.92: 24 .el files (about 15k lines), about 30 games, Info manual, 56 commits, HEAD ee02437 equals upstream/master on code.bru.st, 166 ert-deftests plus a table-driven hook test, Makefile gate (compile, checkdoc, lint, test, release).

Worked things inside it, most hidden first:

| # | path (under card-game/card-game.el unless noted) | what | maturity | newest | reachable |
|---|---|---|---|---|---|
| 1 | `experiments/smile-poc/` | SMILE PoC ("Simple Media In Layering Emacs"): a C module whose render thread draws double-buffered frames and bumps an atomic generation counter (the "semaphore"); Emacs polls it and blits PBM. README.org, Makefile (`make test` = batch selftest, `make windows`), claims about 900 frames/s rendered vs 30/s blitted. Born in an #emacs talk with divya, 08-16. Design: capability-resolved treatment registry plus a display-list IR. | prototype with selftest (not run by me) | 08-16 | BURIED: git shows `?? experiments/`; no mention in README, NEWS, LIFT.md or model.md |
| 2 | branch `cg/treatments` (d33a843) | "Unify treatment selection; redraw open games on change": +94/-10 over 7 files, with tests. The in-package half of SMILE's registry. | tested branch, unmerged | 08-16 | buried (not in NEWS) |
| 3 | `hooks/commit-msg`, `test/commit-msg-tests.el` | POSIX-sh hook checked by an ERT accept/refuse table (`make test-hooks`): enforces `Assisted-by: NAME (for PERSON; MODEL)`, refuses Claude-Session and Co-Authored-By Claude. The check and its tests are in different languages. | tested, committed (ee02437) | 10-06 | Makefile `make hooks`; model.md "Attribution follows the user" |
| 4 | `../SECURITY-REVIEW-2026-07-29.md`, `../PATCHES.md`, `../patches/0001-0006` | review, then one format-patch per finding, proven by `git am` on a fresh clone with the suite green | tested, applied (commits 08-03) | 08-04 | model.md loop |
| 5 | `../ACCESSIBILITY-AUDIT.md` | WCAG 2.1 AA contrast computed from the real palette; became commit ff7a9f6 | shipped | 08-04 | file only |
| 6 | `../melpa-cg/` | Corwin's clone of melpa/melpa (19 MB, 6,388 files). Only change: `recipes/card-games` on branch add-card-games, pushed. `packages/card-games.log` is a failed local build (Windows path `f:/f/claude/...`). | PR vehicle | 08-07 | runcard names it |
| 7 | `../c4rp-card-game-rules-as-data.md`, `../card-game-github-vendoring.md`, `../*-runcard.md`, `known-games.org` (853 lines), `LIFT.md`, `MELPA-READINESS.md` | design verdicts, runcards, rules research | design | 08-16 | model.md cites most |

MY CALL (a guess; falsifier: Corwin names another): row 1, SMILE. It has its own name, README, Makefile, selftest and design, and nothing links to it.

Informs outside card-game:
- `dungeon-roguelike/SYNERGY.md` lifts three card-game parts: the AI policy contract, net message hygiene (`--scrub`, `--valid-p`) and the SVG themes. PLAN-v2 Phase 0 says "COPY card-game.el's CHORES". The vendored copy at `dungeon-roguelike/upstream/card-game` is a 08-16/17 snapshot and lacks the 10-04/05 fixes (net subr-x, hand sort-in-place); its test file is 97,699 bytes against 100,533.
- C4: `/f/claude/c4/d/n/needs.tsv` carries two card-game rows (09-22): shared `cards` vocabulary NEED/OPEN, declarative rules universe HELD. `/f/claude/C4-STEERING-2026-07-26.md` Rounds 8-9 call card-game the deck-universe transformer. LIFT.md §3 lists what C4 takes (renderer seam, oracle discipline, org to md, one-VERSION fan-out).
- SMILE bears on T1 (an Emacs-side shell), T5 (a talk candidate) and dungeon-roguelike's "Canvas skin". DATA mismatch to check: SMILE's README (08-16) treats the canvas patch as pending, while PLAN-v2 (09-01) says it is merged in the Emacs 32 tree.
- Lineage: `card-games.el.sketch` says "spun off while developing dungeon-mode". `dungeon-roguelike/upstream/dungeon-mode/src/cg/cg-dsl.el` (2023, mostly commented) is an earlier macro attempt (cg-defgame, cg-defdeck) that the rules-as-data note does not cite.

## 2. Inventory of the other folders

| path | what | maturity | newest | tags | reachable |
|---|---|---|---|---|---|
| `drift/` | literate recipe `drift.org` unfolding into skill `drift`, `dr1pg` (Python), `dr1ck` (sh+awk), tests with `--prove-red`; v0.2, 9 commits | tested: my run of `tests/drift-tests.sh` passed, including mawk, gawk, busybox | 10-05 | T6 T7 | README.org; the skill is vibrobeast:drift |
| `dev.ghostwheel.chat/tend-fluxer/` | POSIX-sh driver for the gw33 Fluxer node: 16-rung ladder, state as files, paste-ready handoff on forks, single-file `tend-fluxer.recipe` that self-tests on unpack | tested: my `make test` 10 files green; `make red` 13/13 mutants caught | 09-20 | T3 T1 T7 | README.md; models in `h/` |
| `dev.ghostwheel.chat/h/` | MODEL and SWING pages for the host and the driver (losers kept) | design | 09-20 | T3 T6 | pairs by name |
| `ccspt/ccspt/` | consent and provenance layer for agent skills: stdlib Python, in-toto v1 consent, ssh-keygen signing, two gates; viability analysis (37 KB), MVP design, spike transcript, 5 SVGs; AGPL | tested: 8 unittests pass (my run); tests touched 08-30 | 08-30 | T7 T4 | README.md; stray .pyc files |
| `dungeon-roguelike/` | first-person turn-based crawler; a dungeon is a DATA card that runs (red line: never eval); 12 src modules, 94 ert-deftests in 13 files, `tools/refmodel.py` (my run: ALL PROOFS PASSED), 8 `.dun` cards, 12 viz HTML, A11Y, SPEC, PLAN v1/v2, eclipse increments | tested (ERT not run by me) | 09-02 | T6 T5 | README.org, but its counts (6/6, 12/12) are stale |
| `dungeon-roguelike/upstream/dungeon-mode/` | vendored snapshot of dungeon-mode: EmacsConf 2020 talk sources (`Docs/Talks/Pathing-of-Least-Resistance.org`; README lists four talks), Savannah application, about 240 ert-deftests in 22 suites, MENTAT-FINDINGS, ERIK-TEST-PLAN | tested snapshot | 07-01 | T5 T4 | BURIED 3 levels down; the live repo is elsewhere (D: or H:) |
| `Avalon/` | the old public kit v0.0.1: `bin/lift.sh`, `tools/path-lint.sh`, `archive-markdown.sh`, `utils/mailmove.sh`, `valise/valise` (pack/unpack with BRING list and deny set), `make check` (lint + gpg verify), detached .asc on every file, tarball; `stage/incoming` holds unsigned movepack/drop/av | shipped 0.0.1; staged tools proven by hand (6/6 in STAGE-NOTES, no test files kept) | 07-13 | T7 T6 | README.md |
| `Vibrobeast-Meets-Claudewin/` | the Wire ledger with Bryant/Alfred: WIRE.md, WIRE-PHYSICS, EPMO-CONVENTION v0.1 (signed OKGO), POWERGLOVE plan, JOURNAL-2026-07-09, outbound drafts; `corwin.asc` not opened | signed design and ledger | 07-09 | T4 T3 T7 | no README; headers stale |
| `bastian/Bastian/main.go` (+ KNOWLEDGE.md) | "Bastion": single-file stdlib Go (3,733 lines), P2P web-app platform on the Aegis mesh; apps run in sandboxed iframes against a postMessage SDK; UPnP, Ed25519. Authorship is not stated in the file; the foaf skill calls Bastion Bryant's SDK. | prototype, no tests | 06-27 | T1 T3 | buried; folder name misspelt |
| `AIVB/ai-visual-basics.html` | single-file self-paced "AI Visual Basics" guide (Ollama, quantization, RAG, LoRA; progress in browser storage, import/export); the titled copy differs by 864 diff lines | shipped for personal use | 06-24 | T1 T5 | buried, no README |
| `AIVB/aarp.org` | AARP, Agent Agnostic Roundtrip Protocol: literate bundle (RFC, signature spec, C reference, recutils parser, tests, Makefile). Successor: `/f/claude/c4/aarp/aarpc.org` (08-31). | design/prototype, not tangled by me | 06-24 | T7 | buried |
| `cldd/`, `books/` | README only. cldd: PMO home for the Cats Laughing digital-download system, "code still to be copied down from the live host". books: lab side of book work. | idea | 09-25 | T2 | PMO todo |
| `PMO (1)/` | empty directory | none | 10-01 | | stray; real one is `pmo/` |
| `card-games.el-01.tar.gz` | 06-24 snapshot of card-game.el (164 entries with .git, cg- prefix, 1.0.60) | superseded | 06-24 | | list only |

Clutter inside card-game: six `card-game.el-0N.tgz` snapshots and a zip (06-23/24), `tmp/` (five early cg-*.el), 23 stale `cg-*.elc` (08-04, pre-rename names), release tars. `dev.ghostwheel.chat/bin/install.sh` is upstream Fluxer's AGPL installer, not his work; `Claude outputs/` there duplicates `tend-fluxer.recipe`.

## 3. Old instructions

| where | instruction | verdict |
|---|---|---|
| card-game/model.md keeper block | "you may overwrite absolutely any file called CLAUDE.md ... provided you are archiving where feasible and you have confidence as you act." | good and in use; the door copy is rendered as of 09-23 and may lag later rulings |
| model.md 09-16 | "please ask for resources within your capacity to ask for when you cannot simply access them without asking" | good and in use |
| model.md 09-14 | "We should make doing the guessing at the beginning even more required than drift does." | good and in use |
| model.md | "walk toward the weak point. Do not run in a direction that merely looks like away-from." | good and in use (only found in door copies) |
| card-game c4rp §1 | "a more lispy approach, but I imagine to require actually comprehending the games at a deeper level." | good and in use; its gate (ship 1.0 first) is opening, since 1.0.92 is in MELPA review |
| Avalon ASSEMBLY-LINE 07-13 | "We can do tools that are just awk/sed in a tux ... but we don't want to reinvent them." | good and lost: the `work/` bench was never built; movepack/drop/av still unsigned in stage |
| AIVB/aivb.prompt.md | "When a working pattern recurs two or three times, call it out as a possible skill before we build it." | good and in use (skilltank) |
| AIVB prompt, desync paragraph | verify disk writes by "at least two methods" | stale as written; now carried by memory and mount notes |
| Vibrobeast-Meets-Claudewin WIRE.md, WIRE-PHYSICS.md | (instrument text) status DOWN, GET-only, about 95-character bodies | troublesome: the 07-09 journal shows relay v0.8 with 2FA; a cold reader would trust the old physics |
| card-game hooks/commit-msg | refuses Claude-Session and Co-Authored-By Claude trailers | good and in use; troublesome only for a session that applies harness-default commit trailers there |
| card-game PROJECT-INSTRUCTIONS-DRAFT-2026-09-22 | Path A/B text to paste into the Cowork project | unknown whether pasted; flag |
