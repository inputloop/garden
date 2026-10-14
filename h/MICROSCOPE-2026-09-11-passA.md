# MICROSCOPE over pass A — 2026-09-11

Rule enforced (his words, 2026-09-07, `memory/lens-microscope-bubble-chamber.md:23-24`):
*"MICROSCOPE — one mind is no longer enough magnification. Strip the assumptions, keep only what
survives with no trust in the scorer. Keep-the-WINNERS."* The six pass-A builders scored their own
work; nothing below is taken on that score. Every row was re-derived from the staged sources or
re-run here. No skill was edited.

What was run in this pass, and what it returned:

- `python3 scan_candidates.py --selftest` (pass A's new script) → `TOTAL pass=11 fail=0`, exit 0.
- `dash -n` on both `eclipse_pass.sh` (original and new) and on `bin/landcheck.sh` → exit 0 each.
- Both scan scripts, old and new, over the staged `memory/` + `skills/` — used to check the
  builder's counts.
- `mawk -v s=42 'BEGIN{srand(s)} {print rand()}'` ×3 — to check pass A's own [PLATFORM] concern.
- `grep` of every quoted receipt against the staged path:line it names.

Verdict counts: **survives 34 · drift 4 · unverifiable 4 · wrong 7** (49 rows).

## Findings

```tsv
ID	SKILL	HUNK-OR-CLAIM	ASK-LINE	VERDICT	RECEIPT
M01	seatkeeper	move 1 (a): explicit-path request is refused, refusal text quoted	queue:18-19 "(a) an explicit-path request for the auto-memory folder is refused"	survives	SEATDIFF-2026-09-04b.md:12 carries the string verbatim; corroborated h/MODEL-2026-09-05-memory-situation.md:12
M02	seatkeeper	move 1 (b): picker names no reason, returns whatever was clicked	queue:20 "(b) the picker shows the keeper no purpose and returns whatever he clicked"	survives	SEATDIFF-2026-09-04b.md:13 (returned F:\claude\AS4CE\AS4CE0002\New folder); the say-first rule at b:71
M03	seatkeeper	move 1 (c): fallback works, cannot hash source, word is "copied, re-read"	queue:20-22 "(c) the file-tool fallback works but cannot hash the source"	survives	b:14 (103 notes enumerated), b:16 (NOT ATTEMPTED, 96 pairs), b:130-131 (the two words)
M04	seatkeeper	move 1 (d): session-close trigger must be a hook, reported "unwired" until wired	queue:22 "(d) the trigger (session-close) must be a hook, not a memory"	survives	skills/skilltank/SKILL.md:27 and skills/ethicsminions/SKILL.md:39 both say it, at the cited lines
M05	seatkeeper	skill text cites SEATDIFF-2026-09-04.md for the quote "mounted via request, read-only"	queue:24 (Q1 receipts line)	unverifiable	that phrase is not in SEATDIFF-2026-09-04.md; it is at SEATDIFF-2026-09-04b.md:20 as a report ABOUT the morning; the morning file says only "A is mounted read-only" (:59). CHANGES.md cites b:21-24 correctly; the skill text does not
M06	seatkeeper	"Still attempt it once per session before calling it closed"	queue:25 Q1 receipts name memory verify-mount-access-fresh-per-session	survives	memory/verify-mount-access-fresh-per-session.md is inside Q1's own receipt list, so this is not an unasked addition
M07	seatkeeper	claim: no staged skill has a falsifier section, so this is new not a duplicate	preamble o32 rule	survives	grep -rni "falsifier" /mnt/user-data/uploads/AS4CE0001/skills/ returns nothing
M08	seatkeeper	claim: only two hunks; everything else byte-identical	-	survives	diff original vs new = exactly 2 hunks (move 1, appended section)
M09	posix	gotchas-ledger entry for grep -c PATTERN FILE || echo 0	queue:68-70 "prints 0 AND 0 ... use n=$(grep -c ...); n=${n:-0}"	survives	bin/landcheck.sh:28 carries the rule as an inline comment, quoted correctly
M10	posix	claim: the queue's landcheck.sh:29 is off by one; the comment is at :28	queue:72 "AS4CE0001/bin/landcheck.sh:29 (the comment carries the rule)"	survives	sed -n '28p' = the comment; 29p = the if [ "$u" -eq 0 ] that consumes it. The builder corrected the ask and said so
M11	posix	dash -n added to review-loop step 3	queue:70-71 "dash -n as the parse check before running"	survives	dash present here; dash -n exit 0 on both eclipse_pass.sh and landcheck.sh
M12	posix	--prove-red shape added to review-loop step 3	queue:71 "a scorer's --prove-red shape (corrupt a copy of the good fixture, expect the named FAIL)"	survives	bin/landcheck.sh:7-8 and :61-67 implement exactly that shape, including the named FAIL (B13)
M13	posix	claim: no "ledger"/"gotcha" anywhere in the source skill	-	survives	grep -ni "gotcha\|ledger" on the staged posix/SKILL.md returns nothing
M14	posix	falsifier 1 "Fired on the wrong trigger — re-read the request"	preamble o32	survives	weakest of the three: it names an observable (no .sh file or explicit review ask in play) but no command. Still checkable by a person
M15	verify-say	"Copied, verified" / "Copied, re-read" added as a named pair	queue:77-78 "one more state for a copy: copied, re-read ... beside copied, verified"	survives	SEATDIFF-2026-09-04b.md:130-131 names the pair AND names verify-say as its owner; morning table :16-49 is the "verified" case
M16	verify-say	NOT ATTEMPTED rule amended in place to name the unhashable-source case	queue:78-79 "a report prints NOT ATTEMPTED with the command for any check the reader could not run"	survives	amended, not duplicated, as the preamble asks; the token was in the source once (state 2) and is now in the print-the-attempt section too
M17	verify-say	its own falsifier: "grep the landed file for NOT ATTEMPTED - it should appear twice"	-	wrong	5 occurrences in the landed file: lines 62, 81, 89, 140, 141. The builder's own check fails against the builder's own output
M18	verify-say	JUDGED 2 tagged [HIS] on the phrase "this skill OWNS the words, so wording is the deliverable"	queue:82 gate line "(verify-say owns words)"	wrong	the only cited carrier is brief-2-posix-verify-say.md. The nearest real source line is the queue, written by Fable, not by Corwin. [HIS] asserts a provenance the sources do not support
M19	sandboxer	new section "Memory stores - what a session can and cannot reach", six fingerprints	tree:93-94 Q14 "a memory-stores section ... Six fingerprints, each receipted tonight, in h/MODEL-2026-09-05-memory-situation.md 6"	survives	all six trace to MODEL:105-117; the receipts behind them at MODEL:12, :13, :14, :30-35, :55, :112 all read as quoted
M20	sandboxer	claim: "98 of 156" seat notes refuse a 0-byte append	tree:93-94 (Q14)	survives	MODEL:30 says "98 of 156"; memory/memory-situation-2026-09-05.md:34 repeats it
M21	sandboxer	claim: mv onto an existing file fails, "unable to remove target"; cp overwrites	tree:46 "New fingerprint tonight, for Q4: mv onto an existing file fails on the mount"	survives	MODEL:112 and tree:46 both carry it
M22	sandboxer	7th bullet: 2026-09-11 host read-only / saveBackBlocked	none	drift	answers no line of Q4 or Q14; MODEL 6 names six fingerprints and this is a seventh. Kept-or-not is the keeper's call; only named here
M23	sandboxer	claim: "eleven notes ... the bridge reports saveBackBlocked: read_only"	none	unverifiable	grep -rn "saveBackBlocked" over the whole staged tree returns nothing. Sole cited source is brief-3-sandboxer-skilltank.md:40-44, which is not in the staged sources either
M24	sandboxer	description: extended with one clause and three new triggers	preamble "extend description only if the ask changes when the skill applies"	survives	Q14 puts memory-store reach in scope, so "why can't I write this memory note" is a newly-covered trigger, not a restyle
M25	sandboxer	Q4's three fingerprints (rm refused, host-side lock, redirect before glob)	queue:56-61	survives	all three were ALREADY in the staged original at :362-374. Pass A added none of them and did not claim to - Q4 was satisfied before this pass
M26	skilltank	ENHANCE row now names the mapped skill	queue:44-46 "(a) the ENHANCE label must name the skill it maps to"	survives	re-run here: old script prints 18 bare [ENHANCE] rows of 25; new prints 19 named, 0 bare
M27	skilltank	--drop-generic and --stopwords FILE	queue:46-47 "(b) generic words ... a stopword list or a min-length/IDF weight"	survives	both work, both OFF by default, so the plain command still tops out at 'session', 'corwin', 'first'. The ask is answered; the complaint is only cured behind a flag
M28	skilltank	--since YYYY-MM-DD	queue:47-48 "(c) --since DATE so a session retro scans today's notes"	survives	header prints "since DATE: N older notes excluded"; selftest covers include, exclude and the count
M29	skilltank	hub weighting fixed by counting tokens inside each wikilink target	queue:48-49 "(d) ... wikilink-hub weighting is 0 for every row (hub 0 x30)"	survives	old script here: 24 of 25 rows hub 0, the one exception 'sandboxer' at hub 2. New script: 15 of 25 rows hub > 0
M30	skilltank	claim: "49 distinct wikilink targets, 46 of them hyphenated"	queue:48-49	wrong	same staged memory dir measures 54 targets, 51 hyphenated. The 3 single-word targets (sandboxer, seams, seatkeeper) do match, so the mechanism holds and only the numbers are off
M31	skilltank	claim: the staged seat is "18 notes" (stated twice)	-	wrong	ls memory/*.md = 20; the scan's own header line prints "memory notes: 20"
M32	skilltank	claim: "20 of 25 printed rows are [ENHANCE]" on the unmodified script	queue:44-46	wrong	18 of 25 on the staged corpus
M33	skilltank	claim: "rows with hub > 0 go from 1 of 25 to 12 of 25"	queue:48-49	wrong	"1 of 25" confirmed; the new figure measures 15 of 25 here, not 12
M34	skilltank	claim: "--drop-generic drops the theme count from 138 to 119"	queue:46-47	unverifiable	measured 165 -> 145 here. The delta is the same shape (about 20), the base is not - consistent with the builder having scanned a different snapshot than the one staged for me
M35	skilltank	claim: plain rerun is 120 lines before and after	brief-3 byte-stability constraint	survives	wc -l on both outputs = 120
M36	skilltank	claim: selftest has eleven checks and exits 0	brief-3	survives	re-run from the shipped path: 11 ok, 0 fail, exit 0
M37	skilltank	claim: 24,576 B, 510 lines, sha256 af8e02cb63c0e76c...	-	survives	sha256sum = af8e02cb63c0e76c7a7897a72a991dd3465985742431a4d517cfb050dec8daa1; wc -c -l = 24576 / 510
M38	skilltank	claim: "the .pyc inside was removed, but the empty directory refuses rm -rf and rmdir"	-	wrong	scripts/__pycache__/scan_candidates.cpython-311.pyc is present, 39,616 B, mtime 13:10:26 - later than the builder's own writes (13:01-13:03) and before this pass (13:17). Either the removal did not happen or a later step regenerated it; either way the shipped output carries a .pyc
M39	skilltank	--selftest itself	none	drift	Q3 asks (a)-(d); neither queue nor tree asks for a selftest. Requested only by brief-3. Useful drift - it is what let this pass check the work - but drift
M40	skilltank	new term "workbench words"	plain-words rule	drift	not in the original skill, not in Q3 (which says "generic words"), not common use. One-word fix: say "generic words"
M41	eclipse-pass	new section naming LENS / MICROSCOPE / BUBBLE CHAMBER / ECLIPSE	memory/reflection-family-drift.md:13 "Enhance eclipse/microscope to mention the LENS and be clear that reflection is a family"	survives	quoted verbatim; the four rungs match lens-microscope-bubble-chamber.md:21-34, including "that gap is real and owed" at :34
M42	eclipse-pass	claim: the rung rule sits OUTSIDE his quote block, so it is his rule as recorded, not a verbatim quote	lens-microscope-bubble-chamber.md:19	survives	line 19 is outside the > block; the skill says "His rule for choosing" and the builder flagged the distinction
M43	eclipse-pass	the four-step LENS reading kept as unconfirmed, in one parenthetical	lens-microscope-bubble-chamber.md:44-47 STANDING CAUTION	survives	lens-discipline.md:11 is marked CANDIDATE; the four steps are not restated in the skill
M44	eclipse-pass	"Drift, eventual" paragraph, coupling named not wired	reflection-family-drift.md:14 "Couple to Drift - eventual, so far ... the drift guard is currently SKIPPED"	survives	skills/ethicsminions/scripts/check_principles.py:74-75 returns ("SKIP", "no --expect attestations file given") exactly as described
M45	eclipse-pass	claim: an attestations file DOES exist, so the blocker is the flag, not the file	-	survives	skills/ethicsminions/references/attestations.txt exists and its line 1 says it is the --expect file. The skill's wording is true under both readings
M46	eclipse-pass	[PLATFORM] claim: mawk ignores srand(seed), so the seeded pick is not reproducible	-	survives	reproduced: awk here is mawk 1.3.4 20240123, no gawk or busybox; three runs of mawk -v s=42 'BEGIN{srand(s)}{print rand()}' gave three different sequences. The skill's description ("so nothing is cherry-picked") and :79 both rest on this
M47	eclipse-pass	one echo line added to scripts/eclipse_pass.sh:61	none in the memory notes	drift	the memory sources ask for a skill edit, not a script edit; the licence came from brief-4 item 4 ("you may add one line"). dash -n clean; behaviour unchanged
M48	eclipse-pass	claim: 58 lines added, 0 removed; the existing losers bullet unmoved	-	survives	diff counts 58 additions and 0 deletions; the bullet is at :126 in the new file, :94 in the original, text identical
M49	eclipse-pass	falsifier 4 "If one person could hold every claim and every project in one head"	preamble o32 "a concrete check"	unverifiable	names no command and no observable - it restates the rung rule as a judgement. The other three falsifiers each name a file section or a rerun
```

## Per skill

**seatkeeper.** All four parts of Q1 landed and each one is anchored in a line of
`SEATDIFF-2026-09-04b.md` that reads as quoted. The edit is genuinely two hunks; nothing else moved.
The one soft spot is inside the skill text, not the CHANGES: the "mounted via request, read-only"
quote is attributed to the morning file, and that phrase lives in the evening file's account of the
morning (M05). The CHANGES.md cites it correctly, which tells you the slip happened on the way into
the prose. Independence is good — the builder found its first falsifier already written at
`b:128-130` and said so rather than claiming it. The falsifier section is the strongest of the six:
four checks, three of them a command you can paste.

**posix.** Three asks, three landings, all verifiable: the `grep -c` gotcha, `dash -n`, and the
`--prove-red` shape, which `bin/landcheck.sh:61-67` really does implement including the named FAIL.
The builder caught the queue's own off-by-one on the receipt line and corrected it in the open
(M10) — that is the pass's cleanest independent act. Against it: the ask was quoted from the brief
first and the queue second, and the `tool.py` instruction it obeys exists only in the brief. Falsifier
1 is a re-read of the request rather than a command, the weakest of the twenty-two falsifier checks
in this pass, though still something a person can look at.

**verify-say.** The vocabulary is exactly what Q6 asked for and it is amended rather than duplicated,
which is the harder and better move. Two failures, both small and both the builder's own words. Its
falsifier says `NOT ATTEMPTED` should appear twice in the landed file; it appears five times (M17).
And a judgement about the deliverable is tagged `[HIS]` on the strength of a phrase whose only
carrier is the brief — the nearest real source is the queue's gate line, which is Fable's, not
Corwin's (M18). Nothing was verified into existence here that was not there; the words are right.

**sandboxer.** Q14's six fingerprints all trace to `MODEL-2026-09-05-memory-situation.md` §6 and each
receipt under them reads as quoted, including the "98 of 156" split. The builder correctly declined
to re-add Q4's three fingerprints, which were already in the file (M25). The seventh bullet is the
problem: the 2026-09-11 host read-only / `saveBackBlocked` claim answers no ask line and its only
cited source is the brief, and `saveBackBlocked` appears nowhere in the staged tree (M22, M23). The
builder was candid that it could not re-run any of the six receipts from the sandbox; that honesty is
why the section reads as transcription rather than measurement, which is the right register.

**skilltank.** The code is the best-tested thing in the pass and the four asks all work when re-run
here: the ENHANCE row names its skill, `--since` filters, the stopword flags bite, and the hub bug is
genuinely a key-space mismatch fixed by counting tokens inside each link target. The prose around it
is the least reliable in the pass: five numeric claims about the corpus and its own output are wrong
or do not reproduce (M30–M34), and the shipped tree still contains the `.pyc` the CHANGES says was
removed (M38). Two structural notes: both stopword levers default off, so Q3's actual complaint
survives a plain rerun; and the builder's own best concern — that naming the skill exposes how thin
the word-overlap mapping is (`'session'` → seatkeeper, `'corwin'` → eclipse-pass) — is confirmed here
and is the honest headline of the change.

**eclipse-pass.** The most independent of the six. It opens by grepping for the o-numbers its brief
cites, finding none in the tree, and naming the brief as their carrier rather than as their authority
— which is what every builder should have done. Every rung, quote and caution traces to
`lens-microscope-bubble-chamber.md` or `reflection-family-drift.md` at the line given, and the
quote's original spelling was preserved rather than silently fixed. Its `[PLATFORM]` concern
reproduces exactly: under mawk, `srand(seed)` does not steer `rand()`, so the skill's own
"seeded and reproducible, so nothing is cherry-picked" claim — which is also in the frontmatter
description — is false wherever mawk is `/bin/awk` (M46). That is the single most useful finding pass A
produced, and it was produced by a builder auditing its own skill rather than by the scorer. One
falsifier line is a judgement, not a check (M49), and the script `echo` is drift (M47).

## What would not survive without the scorer

These are the claims for which the only evidence is that a pass-A builder said so. They are not
refuted; they are unbacked from here, and each names the one check that would settle it.

1. **sandboxer, the eleven read-only seat notes.** `saveBackBlocked: read_only`, eleven notes dated
   2026-09-01..04, host mode bit not a harness fence. Cited to the brief alone; the string appears
   nowhere in the staged tree. Check: run `attrib` (Windows) on `AS4CE0001/memory/*.md`, or CARD 7's
   host run, and count the read-only files.
2. **sandboxer, the whole memory-stores section as *current* fact.** Every bullet is a transcription
   of one reader's measurements on one night, as the builder itself flagged. Check: re-run the four
   receipts named in the section's first falsifier (`rm`, `mv` onto an existing file, `( : >> note )`
   on a 09-01 note, `ls /mnt/.claude`) and re-date whichever line has moved.
3. **skilltank's ranking claims.** "`--drop-generic` clears the workbench words out of the top rows",
   "138 to 119 themes", "12 of 25 rows gain a hub", "18 notes". None reproduce on the corpus staged
   for this pass. Check: run both scripts on the real 141-note seat and keep the two outputs.
4. **skilltank's `__pycache__` housekeeping.** The claim that the `.pyc` was removed. Check: `ls
   skilltank/scripts/__pycache__/` in the runner's own copy before it ships.
5. **seatkeeper's "attempt once per session" being worth the attempt.** The only evidence that the
   fence might not be permanent is the morning/evening disagreement of a single day, and the phrase
   that carries it is quoted from a file that reports it second-hand. Check: one explicit-path
   `request_cowork_directory` in a fresh session, result pasted and dated.
6. **verify-say's placement judgement.** That "copied, re-read" belongs inside the numbered
   vocabulary rather than as its own state. That is the builder's reading of the ask, tagged
   `[SKILL]`, and no source settles it. Check: the keeper reads the landed section and says which.
7. **Every "this is new, not a duplicate" claim.** Six builders each asserted their skill had no
   equivalent falsifier section. That one *is* checkable and it holds — `grep -rni "falsifier"` over
   the staged skills returns nothing — so it survives, and is listed here only because six separate
   builders made the same self-report and none of them checked each other's.

---
*Microscope pass, brief 4, 2026-09-11. No skill file was edited. The staged originals under
`/mnt/user-data/uploads/AS4CE0001/` were read only.*
