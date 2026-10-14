# CCC4_G401 survey (the San Diego backup)

Folder: H:\arc\from\CCC4_G401 (Corwin: /h/arc/from/CCC4_G401). Surveyed 2026-10-06, read-only, device shell.
Paths below are relative to that folder unless they start with `/h/`. Let `G` = `from/GIZA/c/c`.

**What it is (observed).** Root files dated 06-19..07-01, a GIZA mirror stamped 07-25, a zip dated 08-18, whole folder rewritten 08-19. The text never says "San Diego"; the trip shows in the C4 ledger: "long drives along the CA seaside" (2026-07-20, `G/p/c4-forks/C4-BASELINE-2026-07-20-pass1.md`) and "~23h to plane" (F24, 07-22). The pivot is visible: C4/0 is minted 07-20 22:41Z, C401 opens 07-22, and Corwin's unguarded "founding givens" intake (`G/C4/0/INTAKE-2026-07-20.md`) is the first thing in the tree.

**Photos: none here (observed).** I searched every image extension in the folder. Nothing relevant: only Hugo/Emacs/theme icons, 07-05/06 consent-record screenshots, embargo screenshots, one card-map thumbnail. I viewed 0 images. The transcription says the two notebook photos "arrived inline ... not as files this seat can re-save" and `notes-intake/raw/` was never created. Only the signed transcription survives (section 4).

## 1. Inventory of worked things

| Path | What | Maturity | Newest | Tags | Reachable? |
|---|---|---|---|---|---|
| `G/C4/0/` | C4 "generation zero": 24 doctrine files, 12 cards, 3 digest-chained deck HTMLs (gen0, 0.2 signed; 0.3 unsigned), sigs/, f/ six-fragment lift of sign.sh with box scores, BLIND-DOUBLE report, CLOSURES | tested (digests reproduce, per double) | 07-23 | T7 T5 T4 | yes: README first. But its own `A-5` says the captured model is not carried |
| `G/C4/01/` | C401 "runnable generation": secret-scan in four readers (posix/py/node/c99), scrub-drop, blind-seed-check.sh, sign-all.sh, VERSIONS.tsv, TESTRECORD, SPEC/PLAN drafts, notes-intake | tested (cross-reader agreement; seed check goes red then green) | 07-23 | T7 T6 | PLAN and RUNCARD link it |
| `G/p/c4-forks/` | Fork ledger F1..F29 (36 KB) plus blind pass1 and open-book pass2. The experiment's record | shipped (ledger) | 07-23 | T7 T6 | by memory only |
| `G/../cd/Artifacts/c4-known-universe/` | "C4 Known Universe": one offline HTML card-map (89 KB), 6 version snapshots, thumbnail | prototype that runs | 07-23 | T5 T7 | buried under `cd/` |
| `dungeon/` | dungeon-mode: Emacs multiplayer dungeon crawl, 59 .el in src, 22 *-tests files, Makefile test/compile, 495 commits, Mentat cell-UI and sketch editor, test-audit and play-test plans, EmacsConf 2020 blurb | tested | 07-01 | T5 (T3 by lineage) | **buried**: C4 blind double could not find it ("dungeon UNLOCATABLE", pin BB-7). It is here |
| `org/`, `org2/`, `.arc/org-c4-themes.01/.02` | org-c4-themes: Org HTML themes + Emacs HTTP server (org-httpd) + browser API to edit Org in a browser. DESIGN/API/TEST-PLAN, e2e, ERT, dev harness. org: 426 commits; org2 is an earlier snapshot (411, stale `index.lock`) | tested | 06-26 | **T1 (HTML as app shell)** T3 T7 | README yes; four copies |
| `G/AS4CE/AS4CE0001/` | polygram hub: 66 tests, 96 skill files, dist 42, advice/ 358 notes, models 38, book 28, Texinfo manual, accessible site | tested/shipped | 07-23 | T7 T6 | INDEX.md |
| `G/corwin/` | shelf: vibrobeast public home (releases, signed corwin-pub.zip), incubator (epmo, manifests, principle-reconcile, publish, shelf-check), pub, build, AETHER server kits. Inbox/consent-records holds mp3 and png (listed, not opened) | shipped | 07-22 | T7 T4 | README |
| `G/p/` (rest) | ccspt verifier (AGPL), Vibrobeast-Meets-Claudewin (EPMO convention OKGO, wire physics), pmo (projects.tsv, todos.tsv), skzb (Dragaera super-project: rights audit, decision matrix, banter model), AIVB, learn, card-game (1.0.60 src), ldf, paclam, sre, techclass | design to tested | 07-13..25 | T2 T4 T6 T7 | pmo index; skzb not linked |
| `G/modelthisbook/` | book corpus; `materials/time-series-journal-experiment.md` parked "how we record sessions" | idea | 06-29 | **T6** | buried in materials/ |
| `d/Research/aarp.org` | Agent Agnostic Roundtrip Protocol, literate (RFC notes, signature scheme, C reference) | design | 06-21 | T7 | buried |
| `bla/` | Hugo site corwin.bru.st, prose.sh, Blogs/ (essays, haiku) | prototype | 06-24 | T5 | no |
| `G/../Z/Avalon/outbox/projects/` | 2019-2025 archive: orgvm (T3), fosshost policy/org-chart (T4), windows-into-freedom talk and org-tree-slide-pauses (T5), ghostwheel-ux (T3), `skzb-cover-posters.org` and `dragaera-pins.org` (T2), `foss-trading-cards.txt` (2024, a precursor of the C4 cards), ollama-bootstrapping.org, ~10 small repos (meta-express, getopai, signalinator, inputloop, crdt, cell-mode) | mixed | 2025..07 | T2 T3 T4 T5 | **buried**, no index |
| `G/../Z/from/Avalon/ClaudeDesktop-snap-2026-07-13*` | earlier snapshot (+ .tgz, .gpg). Contains `.gnupg`, `.ssh`, `*.ppk` (listed, not opened) | archive | 07-13 | | no |
| `G/../embargo/` | SAVANNAH security deliverable (embargoed; listed, not read) | | 07-17 | | |

## 2. The 2026-08-18 zip (listing only, not unpacked)

`2026-08-18++arc++c4-h.zip`, 617.8 MB, 16 entries, no images: `agent-setup.md~`, `avalon_df-hs_c.log`, `d-projects-org-html-themes.tgz` (44.7 MB), `dungeon-01.tgz`..`dungeon-06.tgz` (about 65 MB each, 06-23), `dungeon-07.zip` (07-01), `dungeon-old-before-cleanup.zip` (06-24), `org-c4-themes.tgz` and `org-c4-themes-07.tgz`, `org-example.org-SAVE`, `runemacs.sh`, `SKILL.md~`. It is a dungeon and org-c4 history, not the C4 trip work. The trip work is in `from/GIZA`.

## 3. Old instructions met

| Where | Instruction | Verdict |
|---|---|---|
| `ccspt.md` | "be frank with each other"; "Success is Adaptability" | good and in use |
| `ccspt.md` 4.4.4 | do not save workproduct unless eight conditions all hold | troublesome: heavier than the shop norm "edit, write it down, tell him"; falsifier: ccspt runs under it without friction |
| `org/.agent-instructions` | "State your reasoning before making any changes." | good and in use |
| `org/next-session-prompt.md` | "There must be one writer at a time" | good and in use (mount desync) |
| same | "the sandbox has no emacs" | stale (sandbox Emacs via he2ma exists) |
| `agent-setup.md` | c4 run-levels design(0)..run(4) | good and in use (C4R0..4) |
| `G/C4/0/README.md` | "Corwin's corrections outrank this tree" | good and in use |
| `PLAN-C401` stage 4 | "version 0 now, do NOT leap-frog the unexecuted blind4" | overtaken by your 10-06 call |
| `modelthisbook/materials/time-series-journal-experiment.md` | session journal experiment, parked | good and lost (T6) |

## 4. The insight trapped inside the experiment

**Where the material is.** `G/C4/01/notes-intake/HCRO-notes-transcription-2026-07-22.md` (clearsigned, VERSIONS row 1.0.22). Four notebook pages, "keeper's hand", read by a Claude seat. By its own stripes: about 15 high, 44 medium, 24 low confidence lines, 2 illegible. Context: ledger F25 and PLAN stage 4 (`G/C4/01/PLAN-C401-turn-the-handle.md`), PRECEPTS PR-1.

**What it says HCE is (observed from the pages; the plain gloss is inferred).** Page 2 is titled "Human Context Engineering [7]". It "presuppos[es] Research, Analysis, and Design (which only I define herein)". It has two products, "Informance Conversation" and "Work Product", moving via counsel consent, tool-free or gated, and "Attestation". The pipeline reads N-score, then arrangement (who, what, where, when, value), then internal adjustments, then "simplement" (marked "safely abstractable"). An attestation ladder runs 0 (affirmations) to 9. Page 1 sets rules of engagement ("small groups decide expressly + together"; "people (inc. person + AI) make partnership"). Page 3 gives a time register and an access ladder: possible, utilized, mutates, each change mutates, bounds. Page 4 gives a SEAM x STRESS x TIMING x REST x ATTITUDE layer and an escalation ladder NOTES, MODEL, RIDER, STRATEGY ("the tools over-claim — log = default"). *Inferred gloss:* HCE engineers the human side of a shared context. The unit is the person's attested, consented, dated statement of intent (PR-2: intent is a fact about the stater), not the prompt text. The aim is a path from talk to something checkable.

**What the experiment was to test (observed setup; the question is inferred).** A fresh no-context project gets the Drive-folder corpus plus the four pages. It runs four passes (error-gap, unconsented, sus-guess, hopeful-future) and returns 17 challenge/opportunity pairs, 9 labs, 4 tests and POSIX stubs. `blind-seed-check.sh` must first prove the seed holds only declared files, no secrets, and none of the hashed "answers" (FORBIDDEN.sha256, not yet built; the card-map lists blind4 as "parked"). Inferred question: can a reader with none of our conversation recover what the notes mean and what to build? That tests PR-1 (what sits in context conditions output) and the "artifacts carry the model" claim. It is the third use of one design: blind, open-book, corrections.

**What it already shows without being run.**
1. *Observed.* The blind step has run twice. The pass1 versus pass2 contrast gave F5 (name oversubscribed) and F6 (F1 dissolves: "both layers were right about different moments"). The blind double on C4/0 scored 8 of 15 rows cold-actionable, 4 gaps BLOCKING, failures clustering "where the tree points off the tree" (no paths, missing F21, captured model not carried). Fable named 8/15 "the ratio to beat".
2. *Observed.* The notebook predates the tree (F25): the notation, the attestation ladder, the T register, and the SEAM x STRESS x TIMING x REST x ATTITUDE layer are in your hand. Page 3's margin asks "Library? Gateway? Tests? Manifests & Models?", which became C401's four install targets before Claude proposed them.
3. *Observed.* Leakage is already countable. "Symphonics" is a scope in `G/C4/0/SCOPES.md` (07-21), before the Sonnet "compass/symphonics" reading. That reading and the recall block sit in the transcription itself, inside the signed tree. 17, 9 and 4 are your house numbers, confessed as "chosen numbers" in card `four-seventeen-nine`.
4. *Inferred.* Terms defined privately ("which only I define herein", N-score, simplement, informance, HCRO) would score BLOCKING for a cold reader, as the double's own rubric would. So the first blind result is a glossary demand, not a verdict on HCE.

**Corrections and feedback for Corwin (inferred; each with a falsifier).**
- [HIS] The photos are not in the backup, so "the hand is the truth" currently rests on a Claude reading. Falsifier: originals exist in the Signal note-to-self, the Drive folder or the phone. Landing them in `notes-intake/raw/` would close it.
- [HIS] With the author and the scorer both knowing the answers, this is at most single-blind (subject blind). The four passes are four lenses, not four blindings. Falsifier: someone who did not write the notes scores it without the answers.
- [HIS] No scoring rubric for blind4 exists in the tree, but the double's READ-2 tags and BLOCKING/DEGRADING/COSMETIC scale are ready to reuse. Falsifier: a rubric sits in the Drive folder.
- [HIS] Treat the 17/9/4 shape as a given, not a result; the interesting signal is a run that returns 14 pairs.
- [DOMAIN] A transcription-as-seed confounds notes quality with reading quality. Falsifier: a pilot with the 24 low lines removed changes nothing.
- Method that already fits a leaked experiment: pass1 quarantines contaminated claims with provenance tags (`[session-artifact] [memory] [name-glimpse] [inference] [trained-prior] [corwin-date]`). Blindness becomes a per-claim tag, so a leaked run is still a legitimate fork-ledger entry. This supports taking the insight now.
- [MINE] I read the transcription, ledger F1..F25, PRECEPTS, the double's report and cards; the rest of INTAKE, NOTATION and DIMENSIONS only by grep. Counts of what the tree "contains" are grep-based.

## 5. Reachability

Buried, worth surfacing: `dungeon/` (closes BB-7), the Avalon `outbox/projects` archive, the T6 journal experiment, `aarp.org`, `c4-known-universe`.
