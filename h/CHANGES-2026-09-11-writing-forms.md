# CHANGES — writing-forms (Brief 2, o63): the register `c/wf`, its descriptor, the skill, the check

Ask, verbatim from `/home/claude/work/passB/brief-2-writing-forms.md:31`: "Brief 2 — the writing
forms, collected into a register, and a skill that carries them (o63; his words 2026-09-11:
'generalizing the writing forms and techniques into a SKILL')". Blocker quoted at `:41-42`: "the
forms need collecting into one register before a skill can carry them — so the register comes
first, then the skill." Nothing here edits an existing file; every output is new, so there is no
`.asc` to note under "signed file, edit anyway".

## Files written

| file | what |
|---|---|
| `/mnt/user-data/outputs/passB/writing-forms/c/wf` | the register: 58 rows, TSV, no header, 9 columns per row (checked: `awk -F'\t' '{print NF}' | sort -u` → `9`) |
| `/mnt/user-data/outputs/passB/writing-forms/d/c/wf` | the descriptor: `FORM ANSWERS FIRST_SECTION SHAPE FIELDS PAIRS COUNT EXAMPLE NOTE`, one per line |
| `/mnt/user-data/outputs/passB/writing-forms/SKILL.md` | the skill draft `writing-forms`, 2,188 words including frontmatter (limit 2,500); description 890 chars |
| `/mnt/user-data/outputs/passB/writing-forms/scripts/wf-check.sh` | POSIX sh check with `--prove-red`; `dash -n` clean, prove-red 13/13 (output pasted below) |
| this file | OBSERVED / JUDGED / not-derived / proof |

## OBSERVED (what the listing, the exemplars and the tree say — quoted)

Sources are the staged listing `L` = `/mnt/user-data/uploads/AS4CE0001/h/forms-listing.txt` and
exemplars `E` = `/mnt/user-data/uploads/AS4CE0001/h/forms-exemplars.txt`, plus the files the brief
named for shape and the synced skills on this box.

- `L:1`: "filename prefixes in c4/h and AS4CE0001/h (count, first/last date, one example path)". Two
  folders, counted separately; 59 prefixes in c4/h (`L:2-60`), 16 in AS4CE0001/h (`L:61-76`).
  Thirty c4/h prefixes have count ≥ 2 (`L:2-31`); AS4CE0001/h adds SEAL 2 and PUB 2 (`L:69-70`) and
  lifts QA to 1+4 (`L:43`, `L:65`).
- `L:14-15`, `L:33`: "WAVE1 5 WAVE1-20260910T1013Z-apprentice-c4-actual-brief.md" / "WAVE0 5 …" /
  "WAVE2 1 " — the wave digit is part of the prefix as listed; WAVE2 has no example path.
- `L:33`, `L:38-39`, `L:49`, `L:53-54`, `L:59-60`, `L:70`, `L:76`: WAVE2, SHOP, SHIP, GRIND, CLOSE,
  CITY, BANK, ACCESSIBILITY, PUB, MEMORY are listed with a count and no example path.
- `L:3` and `L:61`: DIAGRAM is 24 in each folder with the same example
  `DIAGRAM-2026-09-05-enhance-tree.json`; `E:37-38` (MODEL): "Copies: `/f/claude/AS4CE/AS4CE0001/h/`
  (this) and `/f/claude/c4/h/` (the C4 duplicate, same bytes at copy time)"; `E:82-84` (DELTAS):
  "Everything named here already sits in `c4/h/` as same-bytes copies of masters in
  `/f/claude/AS4CE/AS4CE0001/h/`".
- `L:78-85`: "# facts/ shape … a-plural-is-an-affinity-edge-and-the-gauge-catches-the-fakes … # decks/
  shape … accountability-first.deck.md … accountability-first.deck.md.asc". `E:332-338` (facts):
  "One fact per file (or one row per line in a `.tsv`); name it as the question." `E:357-360`
  (decks): "id: two-kinds-of-guard / face: >" after "CANDIDATE until Corwin's detach ceremony"
  (`E:352`).
- `E:2-4` (NOTE): "**His ruling this session (verbatim-adjacent):**"; `E:13-14`: "an observation in
  the longitudinal ledger, never a demand".
- `E:19-20` (LENS): "The keeper's hypothesis, this turn: *"We are not seeing the full MEASURE …"*";
  `E:28-31`: "each measure gets SENSE / CANON … / PROBE (replayable by a stranger) / READING (worked on
  a real case) / STATUS (instrumented · gestured ·".
- `E:33-42` (MODEL): a `---` block holding the H1, subtitle and provenance, then "## 1." — and
  `/mnt/user-data/uploads/AS4CE0001/h/MODEL-2026-09-05-memory-situation.md:5`: "Two piles throughout:
  OBSERVED carries its command; JUDGED wears a tag."; its headings `:78` "## 4 · Try it (hand-test…)",
  `:156` "## 8 · Cards (keeper hands)" with "WHEN … DO … CHECK … TELL-ME" at `:158-161`.
- `E:48-53` (DESIGN): "**Status: MINTED AS A TRAIT, NOT AS A GATE.** … It adds **no enforcement** …
  minting a gate would be the manufactured-rule fault."
- `E:63-66` (PLAN): "the 12h target is the demo, not the deadline"; `E:71` "discount C4's URGENT
  shouting"; `E:73` "No Z/personal data in any of this."
- `E:78-84` (DELTAS): "**Routing:** bank row **Q505** (this file is its receipt) · this file's own
  sha256 is the routing code"; `E:88` "`sha256sum -c DELTAS-2026-09-05-mentat-modeling.sha256`";
  `E:84` "the manifest goes stale and says so".
- `E:93-102` (HYPOTHESIS): "Bound to prompt **S3** (… sha256 `f02435d08af8…`, 28,594 B). If the prompt
  changes, re-date this file … score after a run by filling the companion TSV (…
  HYPOTHESIS-2026-09-04-csspt-prompt-by-model.tsv …) … Confidence words: **likely** … **even** …
  **unlikely**".
- `E:107-109` (HANDOFF): "Paste the block below as the first message of the fresh global session".
- `E:122-124` (FOLD): "Lists what v7 lacks or contradicts; does not resolve anything"; `E:126` "## 1.
  RULES ABSENT FROM v7"; `E:128-135` rows shaped "**slug** — "quote" — why it bears". `E:130`:
  "NOTHING EXPIRES"; "the atom is the unit of EDITING; the table is the unit of READING". `E:135`:
  "The CITE decision is written on the row at the moment the row is written."
- `E:137-149` (REPASS): "The 2026-08-06 original … was not touched — see the receipt at the end of
  this file"; "written in two registers on purpose … neither reconstructable from the other. **§A is
  the practitioner register** … **§D is the analytic register** … the three falsifiers the pass set
  for itself."
- `E:152-165` (RESEARCH): "Corwin's question, verbatim:"; "Scope note: … not a ruling on any open
  question-bank item"; "## 1 · Origins … **Named on its third real instance**, `evidence/error-rates.tsv`
  row 63".
- `E:167-179` (CHARACTER): `---` block with "actor: place"; `E:174-175` "It is not an AI persona, claims
  no inner life, and adds no fact about any human beyond the tier they already hold"; `E:177` "The
  name is the keeper's to give." Also `/mnt/user-data/uploads/AS4CE0001/h/CHARACTER-2026-09-06-mentat.md:7`:
  "Written by the persona; shown, not claimed."
- `E:182-188` (PAPER): H1 "# Inventing computing from three numbers — …" (no PAPER word); "**A working
  paper, v2.** … DRAFT-unsigned. This edition supersedes v1 (…), which is kept unedited as the earlier
  record"; `E:190` "*A note on voice.*".
- `E:197-204` (DIFF): "Findings are tagged [A] … [B] … or [BOTH]"; "NOT an edit to the paper itself";
  "Everything cited below as tree-fact was re-verified directly against the tree during this draft,
  not taken on the readers' word".
- `E:212-225` (READ): "Reader stance: fluent in classical systems assemblers …; no prior contact with
  C4, Corwin Brust, or this tree. Read order: …"; "## VERDICT, up front".
- `E:227-240` (SWING): "planned 2026-09-10, [mine], correctable"; "Four legs, each with a falsifier …
  Nothing here is fired; the spell rack is where legs become sessions"; "Falsifier: … Est: 4 turns."
- `E:242-248` (REVIEW): "**Reader:** … **Standing:** … a conflict worth stating before anything else.
  **Verdict: strong paper, one section that must not ship as written.**"
- `E:257-269` (LEDGER): "*Score, don't fixate.*"; "**Rule of the table.** Every row carries a receipt.
  Where I cannot source a claim … the row says `[MINE]` and you should treat it as a proposal, not a
  finding. Five times in this shop a rule I invented was filed in your voice"; "**You rule the last
  column.**"
- `E:272-282` (CHECKPOINT): "*Self-contained (NOT appended to `h/DRIFT-ledger-2026-08-19.tsv`) to avoid
  a mid-unit parallel-session collision — the ledger's own name+date lesson … The SETTLE row goes to
  the shared ledger at WHEN-DONE.*"; "## The shot, called BEFORE the run".
- `E:287-300` (FIX): "## What was wrong" with the failing `awk -v` line quoted; "Confirmed directly:".
- `E:302-316` (CITATIONS): "Hyphen in the name avows the machine hand"; "each one a tile with two
  doors: **FORWARD →** … Every forward link was opened … Nothing is taken on the README's word.
  **BACKWARD ←**".
- `E:317-330` (DISS): "### A dissertation in two registers"; "> **Provenance.** … **Text below is
  verbatim** … Review and corrections: `REVIEW-2026-09-08-dissertation-pass-1.md` — see it before
  citing §IV."; "## Preface: How to Read This".
- `/home/claude/work/et1cd/et1cd:17-21` (QA): "a files table with sha/bytes, two piles (OBSERVED kept
  apart from JUDGED), findings tagged with a falsifier each, a celebrate section, a grade grid, a heal
  log, forks routed to the keeper, and a count of what is UNSET or was NOT ATTEMPTED"; `:24-29`: "never
  fills its own verdicts"; "silence is counted"; "no falsifier -- a feeling, labelled"; `:44-45`:
  "FINDINGS.tsv columns (resolved by name from d/qa, order free): ID PILE TAG CLAIM RECEIPT FALSIFIER
  GRADE HEAL FORK".
- `/home/claude/work/cards/CARD-20260911T1150Z-caseworker-vibrobeast-brief.md:1-13` (CARD): YAML
  frontmatter `work / arm / wave / stamp / ledger / model / persona / reviewer / corwin-md / method /
  independence`; `:12` "this brief carries the persona and the card shape ONLY … so that agreement
  between this card and the register is a second reading and not an echo"; `:29-40` the fields PID …
  LENS; `:46` "Keep OBSERVED … apart from JUDGED … [MINE] never blocks"; `:50` output path
  `CARD-20260911T1150Z-caseworker-vibrobeast.md` — the brief's stem plus `-brief`; `:52` "Return to the
  runner ONLY".
- `/root/.claude/skills/synced/…/rolls/SKILL.md:108-115`: "## Kinds this seed already covers | kind |
  answers | first section | … | close / roll | what did *we* touch this session? | by register | |
  intake | what *arrived*, what does it claim, what does it ask of us? | by artifact class |"; `:133`
  "Give every positive control a negative twin."
- `/root/.claude/skills/synced/…/reformat-prompt/SKILL.md:25-26`: "`h/REFORMAT-YYYY-MM-DD-slug.md` holds
  the WORKED PAIRS — verbatim + bettered … Same-day later prompts append as §2 unless the prompt opens a
  campaign (own file"; `:31-38` the four parts "VERBATIM (canonical) … THE READING (derived) … HEAL —
  differences named, not smoothed … TAXONOMY CHECK"; `:45` "the worksheet lane (w0sh renders; RULING
  Qnnn in chat), WHERE/TOOL/ACT/RECEIPT-shaped."
- `/root/.claude/skills/synced/…/run-card/SKILL.md:37`: "RUNCARD-<date>-<nn>-<slug>     (supersede,
  never edit)".
- `/mnt/user-data/uploads/AS4CE0001/memory/memory-situation-2026-09-05.md:34-37` (the fence): "98 of 156
  seat notes refuse a 0-byte append from the sandbox — exactly the notes other sessions wrote … The seat
  index can never be *edited* from a later session: regenerate under a fresh name".
- `/mnt/user-data/uploads/AS4CE0001/h/ENHANCE-2026-09-05-tree.md:3-5`: "does **not** replace
  `h/ENHANCE-2026-09-04-queue.md`, which stays untouched as the citations source (… editing it would
  break that receipt)"; `:8-9`: "`h/DIAGRAM-2026-09-05-enhance-tree.json` (canonical diagram doc …) →
  `h/dc1sv` → `h/DIAGRAM-2026-09-05-enhance-tree.svg`"; `:51`: "Second use met (the skills-focus model
  was it)".
- `/mnt/user-data/outputs/VIEW-20260911T1200Z-on1gw.txt:1-3`: "rendered 2026-09-11T1200Z; table age NOT
  CHECKED"; "helps soonest is a HAND CALL by the instrument (2026-09-11), not a measurement"; `:7-8`:
  "o63 ● open Generalize the writing forms and techniques into a skill / o64 ● open README/RECIPE for
  pack and unpack of formed materials into H:/pub". The `.html` of the same stamp sits beside it;
  `VIEW-20260911T1200Z-on1gw-canvas.html` has no `.txt`.
- `/mnt/user-data/outputs/SCORE-2026-09-11-sealed-hypotheses.md:3-8`: "Both seals verified before
  reading: vibrobeast `201fffdf…` … c4-ACTUAL `68f13777…`"; "an uncheckable because the artifact
  never appeared is a miss for the programme, not the prediction. Unit named per check."
- `/mnt/user-data/uploads/AS4CE0001/skills/sandboxer/SKILL.md:383`: "a sealed or withheld file must not
  go through `SendUserFile`".
- `/mnt/user-data/outputs/MEMORY-SORT-2026-09-11.md` exists (the AS4CE0001/h `MEMORY 1` at `L:76`,
  presumably): H1 "# Memory sort — 2026-09-11"; its prefix as the listing counts it is `MEMORY`, and
  the text after the first hyphen is `SORT-2026-09-11`, not a date.
- `/mnt/user-data/outputs/SEALED-2026-09-09-hypothesis-vibrobeast-arm.md:1-5` exists with prefix
  `SEALED`, which is in neither h/ listing; it names its receipt "at
  `AS4CE0001/h/SEAL-2026-09-09-hypothesis-vibrobeast.sha256`".
- Brief `:45-46`: "TSV, NO header row — C4 registers keep columns in a descriptor"; `:53-54`: "PAIRS =
  which other form it is born beside (a CARD has a -brief; a WAVE has a -brief; a VIEW has a .txt twin;
  a SEAL has a SCORE) or -"; `:54` "COUNT from the listing"; `:56` "mark the NOTE `[MINE]`".

## JUDGED (my reading — each with its tag and its falsifier)

1. **[MINE] COUNT is written as the listing's numbers, joined with `+` when a prefix is in both
   folders (`20+14`), not as a sum.** The listing counts the two folders separately and the tree says
   the AS4CE0001/h files are same-bytes copies in c4/h (OBSERVED: `E:37-38`, `E:82-84`, DIAGRAM 24/24
   with one example), so a sum would double-count and a single folder's number would drop the other.
   `N+M` keeps the listing's data and lets a reader sum or not. Falsifier: `sha256sum` the LENS files in
   both folders — if none match, they are distinct files and the column should be the sum; if the
   runner wants an integer regardless, `awk` can fold `+`.
2. **[MINE] WAVE0 / WAVE1 / WAVE2 are one row, `WAVE`, COUNT `5+5+1`, and the check script strips a
   trailing digit before the second lookup.** The brief lists WAVE (not WAVE0/1/2) among the FORMs
   (`:48`), and the three share one shape (the dispatched-arm brief). A rival-prefix reading (three
   forms) would violate the skill's own rule. Falsifier: open a WAVE0 and a WAVE1 brief — if their
   frontmatter keys differ beyond `wave:`, they are different forms and need rows.
3. **[MINE] The WAVE row's FIELDS are copied from the CARD brief's frontmatter.** No WAVE brief was
   staged; the CARD brief (`cards/…-brief.md:1-13`) carries `wave: cards (pre-wave…)` and `arm`,
   `stamp`, `ledger`, the same shape the WAVE1 filename implies. Falsifier: `head -14` of any
   `WAVE1-*-brief.md` — a different key set means the row is wrong.
4. **[SKILL] The CARD row carries two shapes in its NOTE rather than two rows.** The 2026-09-05 CARD
   (`MODEL-2026-09-05-memory-situation.md:156-161`: WHEN / DO / CHECK / TELL-ME, "keeper hands") and
   the 2026-09-1x CARD (the perspective card with -brief) answer the same question at different
   scales, and both are prefixed CARD in the listing. One row, one question, the older shape named in
   NOTE. Falsifier: if the keeper rules the two are different questions, split the row and give the
   hands card its own prefix on its next use.
5. **[MINE] Twenty-one rows were shaped without an opened exemplar** (REPROMPT, STAGE, SITTING,
   PROJ, DRAFT, PUB, CLOSE, PATCH, DATA, BUILD, TERMS, WORKSHEET, WALKTHROUGH, TRYON, READING, PREP,
   PREFER, PASS, HANDBACK, SHARE, CAMPAIGN) — each NOTE begins `[MINE]` and says what it was shaped
   from; FIRST_SECTION and FIELDS are `-` where nothing supported a guess (18 rows). CLOSE and
   WORKSHEET lean on a skill's text (rolls `:112`, reformat-prompt `:45`) rather than the name. Two
   more rows (ARCHIVE, INGEST) carry `[MINE]` mid-note: their first clause has a receipt (FOLD `E:129`;
   rolls `:113`), the shape does not. Falsifier per row: open the EXAMPLE file's first 14 lines; a
   first section that contradicts ANSWERS means the row is wrong and should be amended on that form's
   next use.
6. **[MINE] REGISTER, FACT and DECK rows have COUNT `-`.** The listing counts h/ prefixes only; these
   three carry no prefix (facts are named as the question, decks end `.deck.md`, registers live in
   `c/`). Their EXAMPLEs come from the listing's "facts/ shape" and "decks/ shape" blocks and from the
   cards brief's `c/p`. Falsifier: `ls facts decks c | wc -l` in the tree gives the counts if the
   runner wants them.
7. **[MINE] The check script identifies FACT, DECK and REGISTER by location or suffix, not prefix.**
   `c/<name>` → REGISTER, `facts/<name>` → FACT, `*.deck.md` → DECK; anything else without a
   `PREFIX-date` shape is `RED (unshaped name)`. That makes `ferry_core.py` RED, which is right for a
   deliverable and noise for a tool; the skill's falsifiers section says so. Falsifier: if the keeper
   wants tools ignored, a `bin/` / `*.py` / `*.sh` exemption is one `case` line.
8. **[MINE] Pair rules are a five-shape grammar in the PAIRS column** (`-`, `-brief`, `.EXT`, `WORD`,
   `d/`) so the same column reads for people and for the script. Prefix pairs (SEAL→SCORE,
   DISS→REVIEW) report `PENDING` rather than RED because the second half lands later by design;
   SCORE→SEAL is RED because a score with nothing sealed beside it scored nothing. Falsifier: a SEAL
   sitting in a folder where the SCORE is filed elsewhere by house rule — then PENDING is a false
   alarm and the rule should say where to look.
9. **[SKILL] The `-brief` rule is checked for `.md` only.** `CARD-20260911T1150Z-rows-vibrobeast.tsv`
   is a rows file that legitimately has no brief; a strict rule would call it RED. Falsifier: if a
   non-`.md` CARD ever needs a brief, drop the extension test.
10. **[MINE] Two real files go RED under the new check and I did not repair them.**
    `VIEW-20260911T1200Z-on1gw-canvas.html` has no `.txt` twin (pair absent), and
    `MEMORY-SORT-2026-09-11.md` has a two-word prefix (no date after `MEMORY`). Both are findings for
    the keeper, not edits for this pass. Falsifier: if the canvas view is meant as a one-off with no
    text twin, its row is a one-off and the VIEW rule stands; if `MEMORY-SORT` is a form, it wants
    one word.
11. **[SKILL] SEALED (outputs) vs SEAL (h/) — a candidate rival prefix, not added.** `SEALED-*.md` holds
    the prediction, `SEAL-*.sha256` its receipt; different questions, one word apart. The listing
    covers h/ only, so SEALED has no row; the script reports it UNREGISTERED, which is the right
    signal until its second use. Falsifier: a second `SEALED-*` file in h/ earns the row.
12. **[MINE] Description written to trigger on the brief's phrases** (`:58-59`: "which form is this?",
    "write it up", "land a note/card/model/lens", "what shape does a … take") plus "is there a form for
    this" and "a new PREFIX-date-slug filename is about to be minted", and the boundary to rolls,
    reformat-prompt, run-card and skill-creator named in it. Falsifier: if the description crowds
    rolls (a report is a dated deliverable too), tighten it to "not the report kinds".
13. **[MINE] The skill names the "dozen most-used" by summed listing count** (DIAGRAM 48, LENS 34,
    NOTE 27, CARD 26, MODEL 20, PAPER 16, WAVE 11, VIEW 11, DESIGN 10, PROMPT 9, CHARACTER 8, DIFF 8).
    REPROMPT (7) is the thirteenth. Falsifier: dedupe the two folders (JUDGED 1) and recount.
14. **[MINE] Placement of the falsifier section**: last, after "Who else touches this", per the
    preamble ("near the end"). Four checks plus the off-switch line. No equivalent section existed to
    amend — the skill is new.

## Forms whose ANSWERS could not be derived (absence reported after the attempt)

Each was looked for in the listing (no example path), the exemplars (no entry), the staged h/ and
memory/ folders, and the synced skills (`grep -rn` on the word). Nothing shaped a question, so no
row was written:

- **SHOP** (c4/h, 1), **SHIP** (1), **GRIND** (1), **CITY** (1), **BANK** (1), **ACCESSIBILITY** (1) —
  count only, no example path, no exemplar, no skill text naming the file. (`BANK` is used everywhere
  for the question bank, `evidence/question-bank-iTNH.tsv`, but that is a register, not an h/ form.)
- **WAVE2** — folded into WAVE (JUDGED 2); its one file has no example path.
- **MEMORY** (AS4CE0001/h, 1) — the one file found (`MEMORY-SORT-2026-09-11.md`) is a two-word prefix
  and reads as a one-off; no row until a second use settles the word.

Rows written on a guess and marked `[MINE]` at the head of NOTE (not absent, but thin — 21):
REPROMPT, STAGE, SITTING, PROJ, DRAFT, PUB, CLOSE, PATCH, DATA, BUILD, TERMS, WORKSHEET, WALKTHROUGH,
TRYON, READING, PREP, PREFER, PASS, HANDBACK, SHARE, CAMPAIGN. Rows with `[MINE]` later in NOTE for one
clause only: DIAGRAM, CARD, WAVE, ARCHIVE, INGEST.

## Falsifier section

`SKILL.md` ends with `## How this skill can fail (falsifiers)` — four concrete checks and one
off-switch line — as the preamble asks. The skill is new, so nothing was amended.

## Proof — `dash -n` and `--prove-red`, pasted

```
$ dash -n scripts/wf-check.sh; echo "exit $?"
exit 0

$ dash scripts/wf-check.sh --prove-red; echo "exit $?"
ok   mutant: unregistered prefix                  exit 1 (want 1), text 'UNREGISTERED' found
ok   mutant: CARD without its -brief              exit 1 (want 1), text 'ABSENT' found
ok   control: CARD with its -brief                exit 0 (want 0), text 'PRESENT' found
ok   control: a brief alone (output comes later)  exit 0 (want 0), text 'a brief precedes its output' found
ok   mutant: VIEW without its .txt twin           exit 1 (want 1), text 'ABSENT' found
ok   control: VIEW with its .txt twin             exit 0 (want 0), text 'PRESENT' found
ok   control: WAVE1 resolves to WAVE (digit)      exit 0 (want 0), text 'the digit rides the prefix' found
ok   mutant: prefix with no date                  exit 1 (want 1), text 'no date after the prefix' found
ok   mutant: SCORE with no SEAL beside it         exit 1 (want 1), text 'nothing sealed' found
ok   control: SEAL scored later (pending)         exit 0 (want 0), text 'PENDING' found
ok   control: SEAL with its SCORE beside it       exit 0 (want 0), text 'PRESENT' found
ok   mutant: register without its descriptor      exit 1 (want 1), text 'ABSENT' found
ok   control: register with d/c/ descriptor       exit 0 (want 0), text 'PRESENT' found
prove-red: every mutant went RED and every control stayed green
exit 0
```

`/bin/sh` on this box is dash (`/bin/sh -> dash`); the same run under `sh` gives the same last line.
Real-file spot checks (not pasted in full): the caseworker brief → OK (output absent, "a brief
precedes its output"); `VIEW-20260911T1200Z-on1gw.html` → OK (`.txt` PRESENT); `c/wf` itself → OK
(`d/c/wf` PRESENT); the two REDs named in JUDGED 10.
