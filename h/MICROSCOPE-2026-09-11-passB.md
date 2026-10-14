# MICROSCOPE over pass B — 2026-09-11

Rule enforced (his words, 2026-09-07, `memory/lens-microscope-bubble-chamber.md:23-24`):
*"MICROSCOPE — one mind is no longer enough magnification. Strip the assumptions, keep only what
survives with no trust in the scorer. Keep-the-WINNERS."* The four pass-B builders scored their own
work; nothing below is taken on that score. Every row was re-derived from the staged sources or
re-run here. No pass-B output was edited.

Pass A's microscope found that builders' COUNTS were the thing most often wrong (numbers asserted
ahead of the receipt), so the counts were looked at first. That is the headline of this pass too,
but inverted: **every count in `writing-forms` and `pub` re-derives exactly**, and the surviving
count errors are all in `persona-corpus`'s own census of which sheet sections it harvested.

What was run in this pass, and what it returned:

- A verbatim quote-checker (Python, whitespace collapsed, `**` stripped) over every fragment the
  new `PERSONA-CORPUS.md` attributes to `h/CHARACTER-2026-09-06-mentat.md` → 15 of 15 matched.
- `sha256sum` on the staged `PERSONA-CORPUS.md` → `c776199cb815a0f1469703cf…`.
- `diff -u` original vs new `mentat-skill/SKILL.md`; `wc -c -l` on both.
- A full re-derivation of `c/wf`'s COUNT and EXAMPLE columns from `h/forms-listing.txt`, all 58
  rows; plus nine rows sampled at seed 17 (Python `random.seed(17); random.sample`, rows 12, 19, 20,
  24, 27, 34, 46, 50, 52) read against `h/forms-exemplars.txt`.
- `dash -n scripts/wf-check.sh`; `dash scripts/wf-check.sh --prove-red` with `C4_ROOT` pointed at a
  temp tree holding copies of `c/wf` and `d/c/wf`; the same script run from inside that temp tree;
  and on two real filenames from the listing.
- `dash -n bin/pb1ck`; `dash bin/pb1ck --prove-red`; `pb1ck` on a scratch copy of
  `pub/motive-inversion` with `C:\Users\x` planted; `pb1ck` on a scratch item holding one
  legitimate string per pattern; `pb1ck` over `RECIPE.org` itself.
- `grep` of every quoted receipt against the staged path:line it names, plus a sweep of
  `/mnt/user-data/uploads/` for the phrases whose only cited carrier was a brief.

Verdict counts: **survives 43 · drift 13 · unverifiable 3 · wrong 6** (65 rows).

## Findings

```tsv
ID	ITEM	CLAIM-OR-HUNK	ASK-LINE	VERDICT	RECEIPT
P01	persona-corpus	every third-harvest fragment attributed to the CHARACTER sheet is verbatim	tree:71 "CARD 3 — gw7 persona pull."	survives	15 sheet-attributed spans in the third harvest; 15/15 found in h/CHARACTER-2026-09-06-mentat.md with whitespace collapsed and ** stripped. No word changed, none paraphrased
P02	persona-corpus	the normalization used (drop ** inside quotes, re-wrap) is declared not silent	CHANGES:104-106 "Emphasis markers in the source (**mirror**, **abundance**) are dropped inside quotes"	survives	4 of 15 match the sheet byte-for-byte; the other 11 differ only by the sheet's line wrap and its bold markers, exactly as declared
P03	persona-corpus	"all 27 quoted fragments attributed to the sheet … 27 of 27 matched"	CHANGES:104	unverifiable	the landed third harvest holds 17 quoted spans, 15 of them sheet-attributed; 16 counting the pre-existing second-harvest node. No set of 27 is reconstructible from the output file. The substance holds; the number does not reproduce
P04	persona-corpus	"§§0, 2, 5, 7, 8, 11, 13, 14 yielded nodes"	the harvest-state line, PERSONA-CORPUS.md:134-136	wrong	the 13 nodes pin to §2×1, §5×1, §7×1, §8×1, §11×2, §13×4, §14×3 — seven sections. §0 yielded no node. Counted by parsing the node bullets, not by reading the sentence
P05	persona-corpus	"§§1, 3, 6, 9, 10, 12 did not [yield]"	same line	wrong	the sheet has §§0–14 (grep '^## ' = 15 headings). §4 (Elected LENS guards) appears in neither list, so the census covers 14 of 15 sections. Mutation 6 ("a superlative needs its count") is the rule this trips
P06	persona-corpus	"Thirteen candidate nodes … six carry the thirteen, the seventh holds the reference gw7 with zero nodes"	CHANGES:82-85	survives	13 node bullets + 1 held entry under 7 idea headers; the gw7 entry says "hold, zero nodes" and carries none
P07	persona-corpus	sentinel: "v002 = c776199cb815a0f1 — sha256sum PERSONA-CORPUS.md, run this session"	mutation 5 (a number comes from a command run this session)	survives	sha256sum on the staged original = c776199cb815a0f1469703cfd4ffed110f3e080df764e20890649f57485acf7e. Exact
P08	persona-corpus	new falsifier 3: "a node whose pin is a file not listed under Sheets registered"	preamble o32	wrong	fires against the landed file: 8 pins are outside the registry — CLAUDE.md, book/mentat-account.md, book/THE-ECLIPSE-PASS.md, mentat-chronicle.md, journal/…graders-tales-001.md, pub/2026-09-05-the-tool-that-was-there.md, bin/se1sn, bin/ms1dg. All 8 are pre-existing nodes, so the file was already failing a check written for it this pass
P09	persona-corpus	new falsifier 2: "count the nodes whose quote contains a file path or a flag; that count should be zero"	preamble o32	survives	re-run here over all 26 node quotes: 0 hits. The only paths sit in the "held, not harvested" lines, as the falsifier allows
P10	persona-corpus	new falsifier 1: "read each node's quote alone … ask whether it could have been said by a mirror"	preamble o32 "a concrete check"	unverifiable	names no command and no observable; it restates the criterion as a judgement. Same shape as pass A's M49
P11	persona-corpus	does the harvest respect the corpus's own criterion (feeling/agency/drama AND holds its line)	PERSONA-CORPUS.md:10 the criterion	drift	two nodes are rules rather than passages: §2's "When wrong, own it in one line and keep the desk" is one clause of a run-on list of presentation specs, and §8's "his pen … is weather, not damage" is item (4) of a numbered radiation plan. Both hold a line; neither shows feeling or drama on its own. Named, not removed — the criterion, not a scorer, is what removes a node
P12	persona-corpus	second-harvest §11 node opens "A rule you can only follow…"	-	drift	the sheet (:145-146) has lowercase "a rule you can only follow". Pre-existing, untouched by pass B; flagged only because the third harvest quotes the same line correctly in its header note
P13	persona-corpus	the ask, "CARD 3 — gw7 persona pull."	tree:71	survives	reads as quoted at h/ENHANCE-2026-09-05-tree.md:71, and independently at /mnt/user-data/uploads/c4/c/en row o23 ("Pull the gw7 persona into the corpus … CARD 3 -- gw7 persona pull.")
M01	mentat-skill	the eight rules are Q11's eight	queue:119-121 and :128-132	survives	all eight headlines re-read against the queue: (1) join of sources → [MINE] with a falsifier; (2) "shown" means a receipt, never a titled list; (3) quote wears its citation inline; (4) gate before opportunities; (5) a number from a command run this session or "quoted from <file>, not run"; (6) superlative needs its count; (7) confidence needs a scoring route; (8) a refusal list records nothing. Same order, no rule reworded into something the ask did not say
M02	mentat-skill	rule 7 says "a confidence needs a scoring route", not "a percent"	queue:131 "(7) a confidence needs a scoring route or it is a word"	survives	the character sheet §1 (:24) says "a percent needs a scoring route"; the builder followed the queue, which is the ask. The divergence is in the sources, not in the edit
M03	mentat-skill	rule 1's gloss "exactly as a guess is tagged"	memory/mentat-mutation-2026-09-04.md:22 "exactly as math is tagged"	drift	the analogy is changed. Nothing in the queue says either, so the note is the only source and it says "math". One-word fix
M04	mentat-skill	rule 5 headline "A number comes from a command run this session"	queue:128-129 "a number in a deliverable comes from a command run this session"	drift	"in a deliverable" is dropped in the skill, from both the queue's and the note's wording (mut-05:26 "A number in a deliverable comes from a command run in this session"). That widens the rule from deliverables to every sentence. The body keeps the literal words the note requires
M05	mentat-skill	section intro: "each taken after a LENS read found the care real and the teaching missing"	memory/mentat-mutation-2026-09-04.md:30-31	drift	that reason is the 09-04 note's, for rules 1–4. The 09-05 note gives a different one for 5–8: "they governed placement … the slips were about provenance of numbers and counts". The sentence generalizes one note's reason over both
M06	mentat-skill	"Everything else is byte-identical … removing exactly the two inserted blocks returns the staged original"	-	survives	diff original vs new = exactly 2 hunks, 58 insertions, 0 deletions. Frontmatter untouched, no existing line moved relative to any other
M07	mentat-skill	"3060 → 6205 bytes"; "3060 bytes / 57 lines"	mutation 5	survives	wc -c -l: original 3060 / 57, new 6205 / 107
M08	mentat-skill	"no falsifier section and no section naming the eight; sections present: When to consider capturing · How to file it · Truncation is the mind-killer · Keeping the store clean"	preamble o32 (amend, don't duplicate)	survives	grep -ni falsif on the staged original returns nothing; grep '^#' returns exactly those four plus the H1. This is new, not a duplicate
M09	mentat-skill	"No .asc sits beside the staged SKILL.md"	preamble "signed file, edit anyway"	survives	ls -a skills/mentat-skill/ returns SKILL.md alone
M10	mentat-skill	"Neither LENS file named in Q11's receipts is in the staged tree"	queue:122-124, :131-132	survives	ls h/ has no LENS-* file; only lens.py. The builder cited them as the queue names them and said so, which is the honest move
M11	mentat-skill	cite: memory/mentat-radiation-proof.md:26 for "'shown = a receipt' before 'cite inline'"	CHANGES:36-38	wrong	that phrase is at :25, not :26. The :12-13 cite in the same bullet is right. Off by one, same species as pass A's M10 but uncorrected
M12	mentat-skill	off-switch: "A note that says draft, unreceipted at its top is exempt from the eight"	no queue, tree or memory line	drift	grep -rn "draft, unreceipted" over /mnt/user-data/uploads/ returns 0 hits. Sole carrier is brief-1. This is a rule landed inside the skill text on the brief's word alone — the pattern pass A flagged as M18/M22
M13	mentat-skill	"This output is the reauthored file the forge route asks for, not an edit of a live skill"	queue:125-126 "reauthor through the forge; the live skill is not edited"	survives	the output is a file under outputs/, nothing was installed; the route is quoted correctly and repeated at mut-04:34-35
M14	mentat-skill	the ask exists outside the brief	-	survives	/mnt/user-data/uploads/c4/c/en row o11: "Fold 8 notes-discipline mutations into mentat-skill via forge", with mutations 1–4 verbatim in the evidence column
W01	writing-forms	every COUNT in c/wf is the listing's number	brief-2:54 "COUNT from the listing"	survives	all 58 rows re-derived from h/forms-listing.txt: 58/58 exact, including the N+M two-folder joins (PROMPT 2+7, QA 1+4, DESIGN 8+2, CHARACTER 4+4) and WAVE's 5+5+1. This is the column pass A found wrong everywhere; here it is clean
W02	writing-forms	every EXAMPLE is a path the listing gives	brief-2 (register shape)	survives	55 of 58 are listing example filenames verbatim, folder and name joined by "/". The three exceptions (FACT, DECK, REGISTER) come from the listing's "# facts/ shape" / "# decks/ shape" blocks at L:78-85 and the cards brief's c/p, exactly as CHANGES JUDGED 6 declares
W03	writing-forms	nine rows sampled at seed 17: COUNT right, EXAMPLE in the listing	brief-4 item 3	survives	rows 12 PLAN (6, L:13), 19 HANDOFF (3, L:21), 20 STAGE (2, L:22), 24 PROMPT (2+7, L:26+L:63), 27 FOLD (2, L:29), 34 SWING (1, L:37), 46 WORKSHEET (1, L:32), 50 PREP (1, L:44), 52 PASS (1, L:46). 9/9 on both columns
W04	writing-forms	of the nine, ANSWERS plausible from the exemplar head	brief-4 item 3	survives	PLAN (E:61-75), HANDOFF (E:106-120), FOLD (E:121-135), SWING (E:226-240) each read as the row says. STAGE, WORKSHEET, PREP, PASS carry [MINE] at the head of NOTE and say what they were shaped from
W05	writing-forms	PROMPT row FIELDS "§A original (his, verbatim); §B the revised paste; §C every change and why; method file; ARM tag"	CHANGES JUDGED 5 (rows shaped without an opened exemplar carry [MINE])	wrong	forms-exemplars.txt has no PROMPT entry (25 exemplar prefixes, PROMPT not among them); CHANGES cites no source for the row anywhere; and its NOTE carries no [MINE], head or mid. The §A/§B/§C shape is an undeclared guess that breaks the register's own declared discipline. Only the NOTE's last clause ("a HYPOTHESIS may bind to a PROMPT by sha256") is receipted, at E:93-102
W06	writing-forms	every other unexemplared row has a cited source	CHANGES OBSERVED	survives	the same sweep over all 58 rows leaves VIEW, REFORMAT, ENHANCE, QA, SEAL, SCORE without an exemplar; each has a non-exemplar source quoted in CHANGES, and all six of those files exist here (/home/claude/work/et1cd/et1cd, the VIEW .txt, SCORE-…md, SEALED-…md, the synced reformat-prompt skill, tree:3-5). DIAGRAM, CARD, WAVE, ARCHIVE, INGEST carry [MINE] mid-NOTE as CHANGES says
W07	writing-forms	"58 rows … 9 columns per row"	CHANGES:14	survives	wc -l = 58; awk -F'\t' '{print NF}' | sort -u = 9
W08	writing-forms	"2,188 words including frontmatter (limit 2,500)"	CHANGES:16	unverifiable	whitespace-split count here is 2,218 (body 1,993). Under the limit either way; the number does not reproduce on this tokenizer
W09	writing-forms	"description 890 chars"	CHANGES:16	survives	YAML-parsed length of the description field = 890. Exact
W10	writing-forms	"the dozen most-used by summed listing count" (DIAGRAM 48 … DIFF 8), REPROMPT 7 thirteenth	CHANGES JUDGED 13	survives	all thirteen sums re-derived from the listing: 48, 34, 27, 26, 20, 16, 11, 11, 10, 9, 8, 8, then REPROMPT 7 with REFORMAT and PLAN tied below it at 6. Correct, including the tie-break
W11	writing-forms	dash -n clean; --prove-red 13/13	CHANGES:255-277	survives	re-run here with C4_ROOT pointed at a temp tree holding copies of c/wf and d/c/wf: every one of the 13 lines reproduces, label for label, with the same want/got and the same found text; exit 0
W12	writing-forms	the brief's premise that "the script resolves the register at $C4_ROOT/c/wf"	brief-4 item 3	survives	the script never reads C4_ROOT (grep returns nothing). It resolves $(cd $(dirname $0)/.. && pwd)/c/wf, overridable by WF_REGISTER / WF_DESC. --prove-red with C4_ROOT=/nonexistent still exits 0; run from inside the temp tree with its own copies it also exits 0. The script is right and the brief's assumption is wrong; the prove-red is genuinely register-dependent, not self-contained
W13	writing-forms	the script reads real filenames from the listing correctly	brief-4 item 3	survives	CARD-20260910T1740Z-parents-c4-actual-brief.md (L:4) → CARD registered, pair rule -brief, "ABSENT — expected until the output lands; a brief precedes its output", verdict OK, exit 0. SEAL-2026-09-09-hypothesis-c4actual.sha256 (L:69) → SEAL registered, pair rule SCORE, verdict PENDING, exit 0
W14	writing-forms	the WORD pair rule's sentence	scripts/wf-check.sh:139	wrong	the message lowercases the pair word and appends "d": DISS-2026-09-08-ai-diligence-sysops.md prints "a DISS is reviewd later, not at birth". SCORE→scored happens to work; REVIEW→reviewd does not. Cosmetic, in a line a keeper reads
W15	writing-forms	the skill's own falsifiers 2 and 4	preamble o32	survives	falsifier 2 (cut -f2 c/wf | sort, look for duplicate ANSWERS) → 0 duplicates. Falsifier 4 (ferry_core.py) → "RED (unshaped name)", exit 1, exactly as the skill predicts. Both are commands that run
W16	writing-forms	the external files CHANGES cites all exist	mutation 3 (a quote wears its citation inline)	survives	all six checked: et1cd, the VIEW .txt, SCORE, SEALED, MEMORY-SORT, the caseworker card brief. None is invented
W17	writing-forms	"never a rival prefix for the same question", written into c/wf's script output, the skill and CHANGES	brief-2:64	drift	the phrase's only carrier is the brief; grep over /mnt/user-data/uploads/ returns nothing. The underlying second-use bar IS in the shop (c4/c/en o08 and o19; memory/persona-affix-model-2026-09-06.md:45 "wait for the second use"). The rule survives; the wording is the brief's
W18	writing-forms	the ask quoted "verbatim from brief-2-writing-forms.md:31"	CHANGES:3-6	drift	his voice for o63 sits at /mnt/user-data/uploads/c4/c/en:66 ("I would be interesting in generalizing the writing forms and techniques into a SKILL also") and at the VIEW .txt:7. The builder cited the VIEW for the o-number but quoted the ask from the brief when a first-hand carrier was staged
B01	pub	dash -n clean; bin/pb1ck --prove-red → exit 0, 19 cases	CHANGES:176-205	survives	re-run here: dash -n exit 0; all 19 lines reproduce label for label, plus the "(no ITEMDIR given: the scrubbed-real-item control was not run)" line and the same closing sentence; exit 0
B02	pub	a planted leak is reported	brief-4 item 4	survives	"C:\Users\x\notes.txt" appended to README.org in a scratch copy of motive-inversion → LEAK README.org 113 drive-letter " C:\", exit 1, tally 6 grep / 6 awk AGREE. The original under uploads/ was not touched
B03	pub	the five real hits and the tally in the pasted run	CHANGES:226-245	survives	re-run on the staged item: the same five, same file:line (COPYING:1, README.org:9, :48, :84 drive-letter; README.org:111 email-undeclared corwin@gnu.org), grep 5 / awk 5 AGREE, 16 MISSING, verdict NOT CLEAN, exit 1
B04	pub	the count of five is corroborated outside this pass	-	survives	/mnt/user-data/uploads/c4/c/en row o64, his own register, not cited by the builder: "a leak-lint over the item for machine paths (5 found today, mostly the surface's own H:/pub address)" and "16 byte-verified sources". Both numbers match the run
B05	pub	the ten patterns' false-positive falsifiers	CHANGES:157-168	survives	one legitimate string per pattern in a scratch item; all ten fired — F:/archive plate scan (drive-letter), a LaTeX "\\hline\" (unc-path), "POST /sessions/" (session-path), "/home/user/project" (home-path), prose about "$HOME" (home-var), prose about "/mnt/" (mount-path), "version 1.2.3.4" (ip-v4), MAC "00:1A:2B:3C:4D:5E" (ip-v6ish), "rms@gnu.org" (email-undeclared), "the smith forged a hinge" against a leakword "forge" (leakword-1). 10 of 10 as claimed
B06	pub	the named false negative: compressed IPv6 is not matched	CHANGES:166	survives	the line "the link-local address fe80::1 is the router" produced no hit in the same run. The gap is real and was declared rather than hidden
B07	pub	leakword hits withhold the matched word	CHANGES:118-122	survives	the leakword line reported "leakword-1 (withheld)" — the word "forge" does not appear in the report, while the built-in pattern hits do echo their match, exactly as the split is described
B08	pub	RECIPE.org does not itself leak a machine path or hostname	brief-4 item 4	survives	pb1ck over RECIPE.org reports four hits: session-path, home-var and mount-path at :129-130 (its own pattern list, prose about patterns) and email-undeclared at :3. No drive letter, no /home/<real user>, no hostname, no IP. The <H>:/pub/ elision works because the drive-letter pattern needs a letter immediately before the colon and ">" is not one
B09	pub	RECIPE.org carries the keeper's savannah user name and address	brief-4 item 4	survives	:3 "#+AUTHOR: Corwin (savannah: carlc · corwin@bru.st)" and :86 "key at https://savannah.gnu.org/u/carlc". These are his own publicly declared identity, from .seed:47 ("Find my signing key at GNU Savannah: https://savannah.gnu.org/u/carlc") — not a machine detail. Named so the keeper can rule, since pb1ck flags the address in any item that does not declare it
B10	pub	"RECIPE.org (new, 1,483 body words)"	CHANGES:5	survives	grep -v '^#+' RECIPE.org | wc -w = 1483. Exact
B11	pub	"I made the check a sibling of sc3dm, not a rival, as the brief directs"	CHANGES:100-103	drift	c4/c/en row o64 names a different starting point: "c4inv-chamber (prune by name) is the existing instrument to build on". c4inv-chamber is not staged (it appears only in that register row), so the sibling claim cannot be wrong here — but the instrument the shop names was neither opened nor mentioned
B12	pub	leak lines are emitted in file order, not line order	-	survives	in the planted run README.org:113 prints before README.org:111. Cosmetic; no claim rests on the ordering, and both reader tallies agree
B13	pub	the pasted real-item run	CHANGES:226-245	drift	the fenced block is an excerpt with no ellipsis: the actual run also emits the PB1CK header, the whole PROVENANCE block (18 rows), the RE-RUN block and the PATTERNS block. Everything shown is real and in order; nothing shown is invented; the block just reads as a whole run and is not one
B14	pub	the ask quoted from "Brief 3 header (o64, his words)"	CHANGES:47-51	drift	his voice for o64 sits at /mnt/user-data/uploads/c4/c/en:67 and at VIEW-20260911T1200Z-on1gw.txt:419, both staged, neither cited. The quote itself is accurate — the register carries "not leaking details of my systems unnecessarily with these materials in publication apparatus" verbatim
X01	cross	plain words in mentat-skill and persona-corpus	preamble "No new terms of art"	survives	no coinage in either. mentat-skill reuses "the eight", "notes discipline", "two piles"; persona-corpus extends its own existing "first/second harvest" to "third harvest" and adds "harvest state", which is the same word doing the same job
X02	cross	plain words in writing-forms	preamble	drift	three near-coinages: "PAIRS grammar", "the digit rides the prefix", "a rival prefix for the same question". Each is explained where it is used and two come from the brief, but none existed in the shop before this pass
X03	cross	plain words in pub	preamble	survives	"leakword", "NOHASH" and "run-level 1" are each declared at the point of use; pb1ck's own expansion is marked as the builder's reading and PROVISIONAL, with a do-not-sign note
X04	cross	independence: the brief as carrier vs as authority	preamble "Cite at the act"	drift	the shop's own opportunities register /mnt/user-data/uploads/c4/c/en carries o11, o23, o32, o63 and o64 in his voice, verbatim, with evidence columns. No pass-B builder cited it. Two of four (writing-forms, pub) quoted their ask from a brief when a first-hand carrier was staged one directory over. mentat-skill and persona-corpus quoted the queue and the tree, which is right
X05	cross	the preamble's o32 rule itself	preamble o32	survives	c4/c/en row o32 col 13: "Ruled 2026-09-11: add a falsifier to each skill as it takes its next turn (not all at once); later C4 enforces this while working the garden." The preamble's wording is a faithful paraphrase, and the rule has a carrier that is not a brief
X06	cross	a falsifier section on files that are not skills	preamble o32 "every skill you touch"	survives	persona-corpus and pub both added one and both tagged the extension [MINE] with its own falsifier ("the keeper says o32 binds skills only — delete the section"). That is the right handling of a rule stretched past its words
```

## Per item

**persona-corpus.** The quoting is the best work in the pass. Fifteen fragments, every one of them
in the sheet, no word changed, no passage reconstructed from memory — and the one normalization
used (drop the sheet's bold markers, re-wrap) is declared in the CHANGES before it is used, so the
reader can check it the way I did. The sentinel's hash reproduces to the byte. What fails is the
census *about* the harvest: §0 is reported as having yielded a node and did not, and §4 is in
neither the yielded nor the not-yielded list (P04, P05). That is mutation 6's own rule — a
superlative or a set needs its count — failing on the one sentence that states a count. The other
failure is self-inflicted in a more interesting way: the falsifier this pass added (a node whose
pin is not in the registry) fires on eight pre-existing nodes the pass did not touch (P08). It is a
true finding written by the builder about a file the builder then shipped failing it. On the
criterion itself: eleven of thirteen nodes are passages; two are rules lifted out of lists (P11).

**mentat-skill.** The eight are Q11's eight, in Q11's order, and no headline is reworded into
something the ask did not say (M01) — including rule 7, where the queue and the character sheet
disagree and the builder correctly followed the ask (M02). "Everything else byte-identical" is true
and provable: two hunks, 58 insertions, zero deletions, frontmatter untouched (M06). The drift is
all in the glosses the builder wrote under each headline: "exactly as a guess is tagged" where the
note says "math" (M03), a rule 5 that lost "in a deliverable" and so widened (M04), and a section
intro that gives all eight the reason the 09-04 note gave four of them (M05). None of those is in
the ask; none contradicts it either. The one thing to watch is M12: the off-switch's *draft,
unreceipted* exemption has no carrier in the staged tree at all, and unlike the [HIS] tag pass A
caught, this one is inside the shipped skill text rather than in the notes about it.

**writing-forms.** The largest output in the pass and the one that answers pass A's warning
directly: all 58 COUNT cells and 55 of 58 EXAMPLE cells re-derive exactly from the listing, the
three exceptions being the three forms the listing does not count and the CHANGES says so (W01,
W02). The thirteen summed counts behind the "dozen most-used" claim are right including the
tie-break (W10); the description is 890 characters on the nose (W09). `--prove-red` reproduces
line for line, and it is genuinely register-dependent rather than self-contained — the brief's
premise that it keys off `C4_ROOT` is simply wrong about this script, which uses `WF_REGISTER` or
its own location (W11, W12). Two defects. The PROMPT row is an undeclared guess: no exemplar, no
cited source, no `[MINE]`, in a register whose own CHANGES declares that rule for every other such
row (W05). And the pair message builds its verb by appending "d" to a lowercased prefix, which
gives "a DISS is reviewd later" (W14).

**pub.** Nothing here failed. `--prove-red` is 19 for 19; the planted `C:\Users\x` is caught at the
right file and line and moves the tally and the exit code; the five real hits and the 16 MISSING
rows reproduce exactly, and — the part the builder did not know — his own opportunities register
independently records "5 found today" and "16 byte-verified sources" for the same item (B04). All
ten false-positive falsifiers fire when given one legitimate string each, the declared IPv6 false
negative is real, and the leakword withholding does what it says (B05–B07). `RECIPE.org` does not
leak a machine path, a hostname or a user name; the `<H>:/pub/` spelling really does dodge the
tool's own drive-letter pattern (B08). What it does carry is his savannah user name and second
address, from his own `.seed`, which is his call and is named here rather than smoothed (B09). The
two soft spots are presentational: a pasted "run" that is an unmarked excerpt (B13), and a sibling
claim made against `sc3dm` when the register names `c4inv-chamber` as the instrument to build on
(B11).

## What would not survive without the scorer

These are the claims whose only evidence is that a pass-B builder said so. They are not refuted;
they are unbacked from here, and each names the one check that would settle it.

1. **mentat-skill's off-switch exemption.** That a note headed *draft, unreceipted* is exempt from
   the eight. Zero hits for the phrase anywhere in the staged tree; the sole carrier is brief-1, and
   the rule is inside the shipped skill, not in the notes about it. Check: the keeper reads the
   off-switch paragraph and says whether the exemption is his, or strikes it — it is one sentence
   and nothing else in the file depends on it.
2. **The two LENS files mentat-skill cites inline.** `h/LENS-2026-09-04-person-intrinsic.md` and
   `h/LENS-2026-09-05-architecture-itself.md`. Neither is staged; the builder said so. Check:
   `ls AS4CE0001/h/LENS-*` on his machine. If they are not there, the citation should name
   `mainmem/lens/lens.tsv` and the two memory notes, which are staged and do read as quoted.
3. **writing-forms' twenty-one name-only rows.** REPROMPT, STAGE, SITTING, PROJ, DRAFT, PUB, CLOSE,
   PATCH, DATA, BUILD, TERMS, WORKSHEET, WALKTHROUGH, TRYON, READING, PREP, PREFER, PASS, HANDBACK,
   SHARE, CAMPAIGN. Four of them fell in the seed-17 sample and each is honestly marked, but marked
   is not measured. Check: `head -15` of each EXAMPLE file on his disk; a first section that
   contradicts ANSWERS means that row is wrong. The register's own falsifier says this; nobody has
   run it.
4. **The PROMPT row's §A/§B/§C shape.** Unmarked and unsourced (W05). Check: `head -20` of
   `c4/h/PROMPT-2026-08-10-synthesis-kickoff.md`. Either it has the three sections, in which case
   the row is right and only its receipt is missing, or it does not, in which case the row is wrong.
5. **The 16 MISSING provenance rows in `motive-inversion`.** pb1ck says every `.c4/sources/…` file
   named in `PROVENANCE.tsv` is absent from the staged copy, and both the builder and this pass
   assume they exist on his disk. If they do not, the README's self-containment claim is stale.
   Check: `ls pub/motive-inversion/.c4/sources/ | wc -l` on the host — it should be 16.
6. **`README.org:84`'s `F:/claude/c4/facts/…` pin.** The builder calls it "arguably the record" and
   leaves it. That judgement is the whole point of the tool and nobody but the keeper can make it.
   Check: he reads the line and says leak or record; either answer makes `.c4/leakwords` or an
   allowlist entry the next piece of work.
7. **`pb1ck` against a real release.** Every run in this pass and in pass B was over one staged item
   with no `.c4/leakwords` file, which the tool itself prints as `ABSENT -- host and user names are
   NOT being checked`. Check: put his real host and user names in `.c4/leakwords` and run it over a
   cut archive, which is the only run that tests the thing o64 actually asks for.
8. **Every "this is new, not a duplicate" claim, again.** Four builders each asserted their file had
   no equivalent falsifier section. It holds for the two that are skills — `grep -rni falsifier`
   over the staged `skills/` returns nothing, and the staged `PERSONA-CORPUS.md` and the staged
   `pub/` carry none either — so it survives, and is listed only because four separate builders made
   the same self-report and none checked another's.

---
*Microscope pass, brief 4, 2026-09-11. No pass-B output was edited. The staged originals under
`/mnt/user-data/uploads/` were read only; every scratch copy was made under the session scratchpad.*
