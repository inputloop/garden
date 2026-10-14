# Survey: /f/claude/projects, "egad" onward (minus org-c4, skzb)

Read-only, 2026-10-06, through the device shell. Method: `find`/`du`/`git` counts and dates, then READMEs, models, headers, test names. Nothing run, nothing written on the computer. Not opened: `egad/.house/data/from-d-projects/mood.org` and `projects.org` (his mood and agenda copies; named only), `.keys`-style paths, chat logs. `field-comic/.house/session/*/HIS-WORDS.txt` is listed, not read.

Maturity: idea, design, prototype, tested, shipped. "Pushed" is judged from the clone's `refs/remotes`, which only shows what this clone last pushed or fetched.

## 1. Worked things, by folder

| path | what it is | maturity | newest | threads | reachable? |
|---|---|---|---|---|---|
| egad | Emacs-rooted design tokens (Modus), 32-pair contrast gate in Python and Elisp, emitters, signed ELPA-style archive node, egadjit, declarative layer, hello-egad. 257 files, 7 commits | tested (`make check`, 7 scripts, `--prove-red`) | 10-04 | T3 T7 T4 T1(light) | README, MODEL.org, proofs.org; NOT on PMO roster |
| egad-0.1.0.tar.gz.extracted | the raw egad 0.1.0 tarball (gzip tar, 48 KB, 70 members) as found | archival | 10-04 | T3 | superseded by git commit 00826d0 "as found" |
| mini-c4-game | Word Garden: browser SPA word-swap game over eight taxonomy files (4 tables x 17 rows), WordNet 3.1 + GCIDE cache (116 MB), shell and JS checkers that must agree. 272 words, 25 full | tested (twin-check, LibreJS check) | 10-05 | T4(collab test for Bryant/Alfred) | README; in proofs.org; NOT on roster |
| hello-taxgnomes | "Gnemonic Word Mines": four-way reading slider built from the game's tables; 192 local-model sentences filed with provenance; literate recipe unfolds to builder, 2nd reader, tests | tested | 10-05 | T3 | README; no git remote; NOT in proofs.org (newer than it) |
| kid-glove | skill + tool `kg1sc` for arriving in someone else's project: finds house rules first, notes conflicts, rechecks at hand-back; one literate Org recipe | tested (13 KB test script) | 10-05 | T6 T7 | README; ships in plugin and parcel |
| persona-engine | skill + gate `pe1gt` (GO/WAIT/HOLD/STOP) in sh, Python, and a Perl third reader written from a fresh spec | tested | 10-05 | T6 | README; ships in plugin and parcel |
| persona-shelf | ten persona sheets with common licence footer, 4 pointers, SEND-MANIFEST, signed SHA256SUMS, tgz | shipped (cleared; handover is his) | 10-04 | T6 T4 | README; `SHA256SUMS.asc` untracked |
| field-comic | "Corwin & Claude" Volume 2: comic built from session words, `qt1ck` finds every quote verbatim, headless runner `hl1rn`, 27 inline tests | tested (27/27 headless 10-05) | 10-05 | T5 T6 | README; in proofs.org |
| for-bryant | the parcel for Bryant/Alfred: `make-bundle.sh`, coversheet, LENS, two zips; `poc/proofs.org` = 58 one-command proofs run 57/0/1; `en1ac` (time from git); `poc1ck` | tested | 10-05 | T4 T7 T5 | README; zips in `out/` untracked |
| ghostwheel-nodes | ROLLOUT.org v0.5: ladder S0-R8 for gw7/gw14/gw26 (WireGuard, he2ma, egad, orgvm containers, knock); `gw33/root-asks/R-01..03`; DRIFT page | design (only S0 done on gw33) | 10-04 | T3 | ROLLOUT only; ChangeLog/ROLLOUT edits uncommitted |
| gw-survey | `gw1as`: read-only host survey in sh and Python, ACT/HOLD per c4 folder; recipe unfolds to tool and 3 checks incl. licence check | tested | 10-05 | T3 T7 | README; in proofs.org |
| pmo | POSIX TSV ledgers (236 todos, 27 projects), `pmo-report` writes README.md and index.html, `pmo-roster` + tests, INTEL, SEMAPHORES v1.0, c4-overlay | tested (roster tests) / in use | 10-01 | T4 T6 T2 | README; roster stale (below) |
| techclass/TechClass Reviewer | FSF-sysadmin review of four SRE tools; patches merged upstream; email drafts; techclass-patches.tgz | shipped (upstream) | 06-27 | T4 | roster row; not in proofs.org |
| sre/misc-hardening | `s-a-d.sh`, `s-a-d2.sh` (UA-based IP block), MODEL and ADVISORY for each | prototype | 06-28 | T4 | BURIED: no link found |
| paclam | single-file PHP Pac-Man roguelike, MySQL, lobby codes (index.php 74 KB) | prototype | 06-24 | none | roster row (idle) |
| ldf/LDF1/we-the-funded | campaign-finance "Sponsor Suit" HTML prototype, FEC fetch script, PROMPT/PLAN/MODEL, spec review | prototype | 06-27 | none | BURIED: no link found |
| giza | SETUP-FROM-METAL v0.1 (Windows, MSYS2, Emacs+LaTeX, verify-only second station), gauges, rc stand-ins | design | 08-01 | T1(adjacent: recipe, not USB/Linux) | roster row (idle) |
| lab | tracing spec (LAB.md) + three old prompts (skill-learning, build-debugger, shellkin skill) | idea | 07-03 | T6 | roster row (idle) |
| learn | jot ledger (`jot.sh`, journal.tsv), `.lckb/` semaphore spec (inert), MANIFEST.expected | prototype | 07-08 | T6 | roster row; `/f/claude/projects/learn-local` is an EMPTY folder |
| medley | README only; working clone is at /h/svh/medley | idea | 09-25 | T4 | roster row |
| extern/NextTime-Dev | a clone of someone else's Nextcloud time-bank app (origin: definitelynotaspren/NextTime-Dev), v0.2.0, PHP+Vue, CI | shipped (theirs) | 07-08 | T4 | BURIED |
| program-analysis.org | portfolio review, 28 projects ranked 50% societal / 40% social / 10% industry, FOSS cluster, consolidation map | design (a document) | 06-27 | T4 T2 | one roster row |
| signing-chain-research.md | "multiplayer Cowork" notes: signing ring, kernel mediation, "Mentcached" | idea | 06-30 | T7 T4 | BURIED; its Mentcached idea now exists as a plugin MCP server |

## 2. Sub-products hidden inside these folders

- `egad/hello/hello-egad.org`: carries **the organiser** (his card 3: AGENDA open by default, MOOD closed until opt-in plus confirm, `epmo`, a TRACKS log that replays every file). `egad/tests/organize-check.sh` holds it, O1-O9, with a mutant that must go red. This is the nearest thing to the mood-rich app (T3). egad's README layout calls hello-egad "the smallest literate application" and does not name the organiser; MODEL.org does.
- `egad/archive/`: ELPA node, `/.well-known/egad`, GPG signing, `check-peers`; `egad/dist/site/elpa/` holds a signed example archive (T7).
- `egad/GOVERNANCE.org`: PAUSE-style package ownership for a multi-user node, "not yet implemented" (T4).
- `egad/decl`, `egad/jit`: declarative layer and egadjit, each with its own check.
- `egad/tax4alf.zip` (untracked): the eight taxonomy files handed to Alfred.
- `field-comic/.house/session/2026-10-04/`: turn-by-turn session record TURN-01..09 with his words checked verbatim (T6 journaling).
- `ghostwheel-nodes/records/DRIFT-2026-10-04.md` plus `.drift/` editions: a generated drift page.
- `for-bryant/out/*.zip`: ship colophon-garden-edition, attribution-ladder.md, DESIGN-2026-10-05-the-track.md, llama-kit, outside-reader. Their sources are outside these folders.
- `pmo/sketch/nextcloud-epmo-incubator.md`: his Nextcloud app incubator plan (see 3).
- `pmo/c4-overlay.tsv`, `INTEL.md`, `SEMAPHORES.md`: signed doctrine drops, untracked.
- `techclass/.../{WebServerWatcher,LogReview,firewallblockgen,logreview-rs}`: four upstream clones, each with own `.git` and patches.

## 3. Old instructions met

| source | his words (or the instruction) | verdict |
|---|---|---|
| kid-glove/.house/q/PROMPT-2 #8 | "Bryant stuffs shares our license... stop asking me this over and over claude." | good and in use (kid-glove ChangeLog treats it as settled) |
| same, #1 | "wait a little on the cutting and pushing until I work with it more" | good and in use: five repos hold unpushed commits |
| same, PROMPT | "TA model... needs to stay CC-BY4 (no SA)"; persona sheets CC-BY-SA | good and in use; two licences kept apart |
| egad/.house/q/PROMPT | "checks that are minimum and necessary (and generally: easy for users to disable)" | good and in use (MODEL.org principle) |
| egad PROMPT-2 | "Make we can consider skipping when literally nothing has changed since we last got called to do the same checks." | good and lost: no Makefile in these folders has an unchanged-skip |
| egad PROMPT-2 | migrate things to "public stages and standalone projects (mostly literate ones...)" | good and in use |
| ghostwheel-nodes/.house/q | "setting up he2ma (outside), egad (containerized) and orgvm (containerized per user..." | good and in use (ROLLOUT ladder) |
| pmo/sketch/nextcloud-epmo-incubator.md | "I want to make several nextcloud apps quickly, so I and friends can try them out." | good and lost: no ncxp folder; nothing links it |
| lab/build-debugger-prompt.txt | "Introspection Procedure (maybe reusable)": output to `debug/YYYY-DD-MM-HH-NN`, MODEL.md | good and lost; day-before-month name sorts wrongly |
| lab/skill-learning.prompt.md | "Please be my 'self-pacing' to decide when to dig deep" | stale (project done); the idea may be worth keeping |
| learn/.lckb/README | an unsigned, single-source entry is DATA, may never gate | good and in use (SEAMS law, SEMAPHORES.md) |
| giza/SETUP-FROM-METAL | GIZA is verify-only, no private keys; "keeper may flip" | good and in use if GIZA is still idle |
| pmo/README risk row (A) | "Never run git on the Windows mount" | troublesome: memory says superseded 10-04, and read-only `git log`/`status` ran fine on the mount tonight |
| pmo/INSTALL, README | edit the TSV ledgers, regenerate | stale: generated 10-01, none of the 10-04 projects on it |

## 4. Observed vs judged

Observed:
- `grep -c` of `pmo/projects.tsv`: 0 rows for egad, mini-c4-game, kid-glove, persona-engine, persona-shelf, field-comic, for-bryant, gw-survey, hello-taxgnomes, ghostwheel-nodes, ldf, extern, sre. The roster ends 09-25.
- `git for-each-ref refs/remotes` vs HEAD: field-comic, gw-survey, kid-glove, mini-c4-game, persona-engine have later local commits (the 10-05 Alfred-findings fixes, also shipped as patches in the reply zip). egad, for-bryant, ghostwheel-nodes, persona-shelf match. hello-taxgnomes has no remote. pmo's remote is `pmo.sh` and 12 files are uncommitted.
- `grep` for guix/kiosk/live usb/bootable/archiso across these folders: one hit, a comic panel about a 58 GB USB stick (field-comic template). T1 has no work here. `gw7`'s ".deb bakery for Emacs (derive/emacs-recipe/gw7/)" is cited in ROLLOUT.org but lives in c4.
- T2: only pmo ledger rows (Dragaera hub, books omnibus, cldd, skzb) and a program-analysis paragraph. No stick or convention material here. The ledger shows a hard 2026-12-31 audiobook-enrolment deadline and a rule that nothing goes wide without his counsel's contract.

Judged, with falsifier:
- [MINE] `for-bryant/poc/proofs.org` is the best existing index of worked things (58 entries, each a runnable command). Falsifier: it omits hello-taxgnomes, techclass, sre, ldf and paclam; run `grep '^\* ' proofs.org` against section 1.
- [HIS] The PMO roster is the shop's front door and no longer shows the newest work. Falsifier: a newer roster elsewhere (the c4 overlay is a sidecar, not a roster).
- [DOMAIN] ldf, sre, extern, signing-chain-research are buried. Falsifier: any link to them from c4 or AS4CE0001, which I did not search.
- [MINE] extern/NextTime-Dev may be the first "app" for his Nextcloud incubator sketch. A guess (confidence low): both are Nextcloud apps, dated within a week of each other (07-01 sketch, 07-05 clone); no document says so.
