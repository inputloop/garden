# Survey: /f/SAVANNAH (2026-10-06)

## 0. Shape and what I touched
**Observed** (`find`, `du`, `ls`, `git log` with locks off): 2,320 files, 501 dirs, 1.1 GB. Oldest 2026-06-19, newest 2026-10-05. A top-level `.git` (283 MB, 12 commits, last commit 2026-07-26; tree is newer). Heavy parts: `.transcripts` 475 MB, `Inbox` 188 MB, `deliverable-2026-07-svhck` 65 MB, `imported-2026-07-05-from-workspace` 59 MB (1,072 files), `.omni-feed` 29 MB.

**Opened:** CLAUDE.md, INDEX, AGREEMENT, MODEL, .meta.md, PRINCIPLES, CANON, SAVANE (top), SCAN-CHARTER, EXFIL-SURFACE, MASKING-RULING, README-FOR-BOB, COMMITMENT, 00-START-HERE, heads of ~40 other docs, first 9 lines of each `bin/` tool, svhck-forensics README/ChangeLog/tests doc.
**Never opened:** every `.asc`, `.signing-authority/`, all `.eml`, `.saved-coms/`, `Inbox/` logs and tarballs, `.transcripts/`, PDFs, PNG/JPG, `*.sql` outputs, `sv-grep-sw.txt`, `ACCOUNT.md`, CALL-NOTES, FACTS-PENDING, MISSING-EVIDENCE.
**[MINE], named once:** `MASKING-RULING.md` carries a "TIER A ONLY" banner; I read it as a ruling document, saw the banner on opening, and copied no identifiers into this file. Falsifier: grep this file for the account names; none present (file names in §1 use wildcards).

## 1. The two data points to dodge: candidates
Corwin did not name them, so these are guesses [MINE]. Falsifier for all: he names his two in one line. Paths and kinds only; none opened.

| # | Candidate | Path (kind) | Why |
|---|---|---|---|
| 1 | Bystander login lines (the "542" positive control: maintainer usernames plus source IPs) | `/f/SAVANNAH/deliverable-2026-07-svhck/05-evidence/A1-authlog/`, `A1-vcs0-*`, `A1-vcs2-backup-2026-07-12/BK-2-*.txt`; copies in `/f/SAVANNAH/Inbox/` (`BK-2-*`, `svhck-2026-07-11/A1-C-*`, `vcs0-sweep-2026-07-11/VCS0-3-*`) (log sweep text) | MASKING-RULING: "Counts travel; lines never do." |
| 2 | The unconfirmed patch applier and consent capture | `…/05-evidence/A4-*-consent/` (screenshot, README), `…/A2-attribution-2026-07-13/CAPTURE-*.md`, `/f/SAVANNAH/MISSING-EVIDENCE-*-consent-2026-07-16.md`, `/f/SAVANNAH/reviews/joel/2026-07-16-r1/*.png` (chat screenshots) | Ruling: "DO NOT NAME in any tier" until confirmed. The state after 07-16 is unknown to me. |
| 3 | The two suspended accounts' identifiers (names, key fingerprint, email, source IP) | `/f/SAVANNAH/T-seal-*-attachment-CARD.md` (card), the `svhck-finding-*` PDFs and `MASKING-RULING.md` (finding; START-HERE says it names them) | "These are the finding", but the ruling says drop email and IP for anything published. |
| 4 | Private list mail and IRC | `/f/SAVANNAH/archive/hktn--sv-hck-p/` (36 eml), `archive/fsf-consent-correspondence/`, `.saved-coms/`, `Inbox/#savannah-private-corwin-2026-06-13.log` | Mail and chat; folder rules forbid reading. |
| 5 | Terminal tapes | `/f/SAVANNAH/.transcripts/` (PuTTY, WinSCP, `patternwalk/*.log`; one 243 MB file `corwin-gw19-winscp-20260925.log`) | Session logs that handled hosts and users. |
| 6 | Signing pins and backups | `/f/SAVANNAH/.signing-authority/` (2 armored keys), `archive/signing-authority-retired/`, `Inbox/another-jul-13-snap-for-gapchecks/*.tgz` and `*.tgz.gpg` (95 MB each) | Trust anchor; whole-enclave snapshot. |

My best two: **1 and 2**, the only items the folder's own ruling says must never travel. A hazard reading also exists: `T-seal-*-attachment-CARD.md` says never open or execute the attachment; `.meta.md` says never `curl` the probe filename and inspect the tarball only in quarantine. No such attachment is present by name; only the tracker PDF (`Savannah Administration - Tasks_ task #16762 …pdf`) and the card.

## 2. Worked things
Maturity: idea, design, prototype, tested, shipped. "Reach" = linked from INDEX/LABTAIL (yes) or buried.

| Path | What | Maturity | Newest | Threads | Reach |
|---|---|---|---|---|---|
| `imported-2026-07-05-from-workspace/svhck/svhck-forensics/` | SELECT-only IOC scanners for Savane: 10 SQL checks, 11 `bin/` tools, Makefile (lint/check/dist), synthetic fixtures with 14 expected hits | shipped 1.0.93 | 07-03 | T7 | yes, INDEX; also skill `savane-forensics` |
| `deliverable-2026-07-svhck/` | Numbered 00-06 package for Bob then FSF: finding rev4.4, reader edition PDF, evidence, COMMITMENT | shipped (5.1, 07-17) | 07-31 | T4, T5 | yes |
| `bin/` (28) | House tools; see §3 | tested (affinity `--test`, snap, signstack) | 10-04 | T6, T7 | partly |
| `.omni-feed/` | Nightly estate manifest: `estate-fullwalk.tsv` 137,589 rows of `/f/claude` and `/h/arc` (name, size, mtime; chambers pruned), 15 `SHIP-*` notes, `drift-ledger.tsv` | running | 10-05 | T6, T7 | skill and LABTAIL only |
| `skills-draft/` | `instrument-panel` (script plus selftest, now plugin skill), `run-card` (now plugin skill), `instrument-check` (its own VERDICT: do not ship; zero measured effect twice) | tested | 07-26 | T6 | buried |
| `crawlright/` | Polite fetching of public GNU/Savannah data: DESIGN, catalog, script ("crawl locally or communally") | prototype | 07-08 | T4 | not in INDEX; `models/tools/crawlright.md` |
| `models/` (62) | Host, service, tool, source models; THREAT-MODEL; SCAN-CHARTER; EXFIL-SURFACE; state-map HTML | design | 08-16 | T4 | yes |
| `cards/` (39) plus RUNBOOK | Run-card system, TEMPLATE v0.2 | tested in use | 08-16 | T6 | yes |
| MODEL, SEAMS 0.3, SIGNING, SIGN-TYPES, HORIZON, MEMPRESS, UTILITY-DAEMON | Working model, evidence law, signature semantics, `[→TAG]` fold/link markers, memory pressure v0.1, a hook spec | design to tested | 09-01 | T6, T7 | yes |
| `ANALYSIS-2026-09-04-workstreams/` | 46 events, 53 items, timeline/burndown/drift SVG, 3 Python scripts | prototype | 09-04 | T6, T7 | buried |
| `SPEC-…-savannah-books.md`, `bin/savbook.sh`, `MODEL-mentat-savannah.md` | Balancing volumetric (C4) and traditional (AS4CE) counts | design plus script | 09-08 | T6 | MODEL links |
| `BOXSCORE-*`, `COMIC-*` (3), `REPORTCARD-…html`, `DECK-2026-08-16-edrx-little-boards.pptx` (12 slides), SHOW, COURSE, EVENING book | Aug 15-18 presentation and "field comic" work; `boxscore-tsv.sh` renders ledgers | shipped (signed) | 08-18 | T5, T6 | buried (INDEX stops 07-12) |
| `.transcripts/*C4_and_new_practical_use-cases*.jpg` (6) with INTAKE-2026-08-16, PIN-2026-08-15, PERMUTATIONS, LIST-2026-08-28, PLAN-h-move | C4 origin pages (2023 ink), its readings and buildable compositions | design | 08-28 | T7 | buried in a dotfolder |
| `imported/…/bob/Medley/` | Medley host-config models, review, patches | prototype | 07-01 | T4 | INDEX |
| `remediation/`, `deploy/`, `incident/`, `outbox/`, `patches/` | Fix scripts (keeps failures in `tried/`), 1.0.92/1.0.93 tarballs, signed response tarballs | shipped | 07-26 | T7 | INDEX |
| `archive/` (221) | Superseded versions with receipts, recalled polygram-curation-0.5.3 (13 skills), retired key receipt | record | 09-29 | T7 | ARCHIVE.md |
| `daily-omni-point-check.SKILL.md` | The scheduled evening run prompt | in use | 08-31 | T6 | yes |

**T1:** nothing here (only a laptop-migration card). **T2:** only `CALL-NOTES-2026-08-01-dad-bryant.md`, name only, unread. **T3:** `.omni-feed` map only. **T4:** crawlright, `fact-sheets/`, `reviews/joel/` (outside review), plus Corwin on COMMITMENT: "Road-maps are the condition, not a courtesy."

## 3. Reusable outside Savannah versus bespoke
**Reusable (method or form):** SEAMS two-source law; Scan Charter (five lines before any scan); RUNCARD-TEMPLATE and the run loop; masking tiers ("counts travel, lines never do"); fact sheets that declare whose frame they borrow; the remediation locker that keeps failures; "method travels, cases don't"; numbered deliverable plus MANIFEST plus COMMITMENT; `[→TAG]` fold/link markers; the Sweep Rule; the instrument-check eval design.
**Reusable (tools):** the ten `bin/` MOVE-OUT tools per `REPORT-2026-09-14-tidy-and-externalize.md` (markers, path-lint, sig-report, signstack, logslice, snap, archive-markdown, affinity, boxscore-tsv). That report left four unclassified; I read their headers and all are general POSIX sh, read-only: `wordpair.sh`, `weigh.sh`, `w2watch.sh`, `excurutate.sh`. `savmap.py` (rated 0.65 unopened) opens generically: harvests tagged one-liners into one HTML page. `estate-cron.sh` and `estate-rollup.sh` fit any tree. `crawlright` fits any public-data crawl of GNU infra.
**Bespoke, do not lift:** the finding, evidence tree, masking ruling, `models/hosts`, `remediation/` and `deploy/` scripts, `savbook.sh`, Medley patches, `svhck-forensics`' IOC set (tied to one 2026 report; its SELECT-only preflight pattern does transfer), the Savane clone with `frontend/site-specific/{gnu,nongnu}`. `self-destruct.sh` (hardcoded host and scope) must stay gated.

## 4. Old instructions
| Instruction | Judgement |
|---|---|
| `/f/SAVANNAH/CLAUDE.md` is only 🕊🕊🕊 (signed 08-19) | good and in use as a sentinel; a cold session gets no pointer to INDEX or MODEL [MINE]; falsifier: open the folder fresh and see whether MODEL is found unprompted |
| Sweep Rule (09-03): "ship the governance; never plead it." | good and in use (carried in his preferences) |
| "run-cards for everything from here on out." (07-09) | good and in use (plugin `run-card`) |
| "Break seals at will now." (07-11, REV4.md) | good and in use (same direction as the 09-10 norm) |
| MODEL 1.1 §3 "Every prompt gets a reframe" | stale in practice: `.prompt-reframe/` stops 07-12 (observed); the signed rule still stands, so the mismatch is itself a finding |
| `DRAFT-2026-08-20-supersede-run-level-5.md`; his words "the mistakes of iT are the Resume of Corwin" | good and in use; awaiting his pen, 7 weeks, closes pmo #154 |
| `PreVacationShutdown/NEXT-PHASE.md`: "We might not get to everything, no worries." | stale (07-17 passed); the prevention list ("upstream the corrected helper") may be good and lost; check HORIZON.md |
| `PROMPT-2026-08-18-rebuild-vessel-DRAFT.md` (Claude-drafted, not his words) | troublesome: firing it rebuilds the 08-18 comic that DINGER superseded |
| `archive/CLAUDE-2026-09-03_Archived-by-Corwin.md`: "Guide toward ceremony rather than performing it." | good and lost: live copy is doves; only the archive carries it |
| `UTILITY-DAEMON.md` (hook turns "your one-liner is broken" into a `bin/` tool) | good and lost: spec only, no skill listed [MINE] |

## 5. Buried, and pointers by name
INDEX.md (07-12) predates `.omni-feed`, `ANALYSIS-*`, the August material, the C4 pages and `crawlright`. From the estate manifest (names only, not opened): `/f/claude/projects/card-game/melpa-cg` (6,388 files, likely the hidden sub-product), `/f/claude/DAD-VENTURE-cards-2026-07-28.deck.md`, `/f/claude/projects/skzb/pm` (29), `/f/claude/projects/egad/{tests,dist,jit}`, `/f/claude/projects/dev.ghostwheel.chat`, `/f/claude/c4/decks` (93). The manifest omits `/h` other than `/h/arc`, `D:\projects`, `H:\ta`.
