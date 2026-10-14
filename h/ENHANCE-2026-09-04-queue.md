---
# ENHANCE QUEUE — 2026-09-04 (evening), collected under `skilltank`
Citations style: every entry names its receipts (file:line · memory slug · bank Q · tool
output) and passes the skilltank gate (1 ships a runnable/self-triggering payload? · 2
recurring? · 3 one capability — NEW / ENHANCE / LEAVE-AS-MEMORY / HOLD). The question
Corwin asked rides each row: **did the "use tooling as-is, or improve it and write that
down" formulation warrant this enhance?** (W = yes, it was the direct product of applying
that line; — = it came from elsewhere.)
Scan receipt: `python3 skilltank/scripts/scan_candidates.py --memory AS4CE0001/memory
--skills <skills>` → 141 notes · 1212 themes · 30 rows shown · ambient: `corwin`.
SkillTank stops at recommendation; hand-off is skill-creator (author) → CLAUD_QA_HOLD (desk)
→ keeper (sign, install). Nothing here is installed or signed.
---

## The queue (ranked by receipts, never by fun)

**Q1 · ENHANCE `seatkeeper`** — W
Ask: move 1 must say (a) an explicit-path request for the auto-memory folder is refused
(*"Cannot mount a folder that is, or is inside, Claude's own application data"*), (b) the
picker shows the keeper no purpose and returns whatever he clicked, (c) the file-tool
fallback works but **cannot hash the source** — its receipt word is "copied, re-read", never
"verified" — and (d) the trigger (session-close) must be a hook, not a memory.
Receipts: `SEATDIFF-2026-09-04b.md` §"What the tooling did and didn't do" (7 rows) ·
`SEATDIFF-2026-09-04.md` (morning: "mounted via request, read-only" — so the fence moved
or the picker was used) · memory `verify-mount-access-fresh-per-session` · bank Q503 ·
seatkeeper `SKILL.md:47-52` (the stale move).
Gate: payload = the inline sh + the fallback path ✓ · recurring: twice today ✓ · one
capability ✓ → **ENHANCE**.

**Q2 · ENHANCE `rolls` (+ a generator as its runnable payload) — the QA report card kind** — W
Ask: three QA cards were hand-set today in one shape (files table with sha/bytes · two
piles · findings tagged with falsifiers · celebrate · grade grid · heal log · forks ·
count of UNSET/NOT-ATTEMPTED). That is a report kind `rolls` doesn't list, and
`excurutate.sh:9` already names a "report-card generator" as a bundle candidate beside
BOXSCORE. `boxscore-tsv.sh` can't serve it (bound to the invention ledger's 13 columns).
Receipts: `h/QA-2026-09-04-csspt-prompt-sonnet-vs-corwin.md` · `…-S2-opus-vs-corwin.md` ·
`…-S3-fable-vs-corwin.md` (same skeleton ×3) · `c4/bin/excurutate.sh:9` · S2 card
§"Tooling check" ("Absent: a report-card generator binary").
Gate: payload = a findings-TSV → md+widget generator (to build) ✓ · recurring: 3× in a
day ✓ · one capability: a *kind* inside rolls, not a rival skill ✓ → **ENHANCE rolls**;
the generator homes in C4 per `tool-homing-rule`.

**Q3 · ENHANCE `skilltank`** — W
Ask: (a) the ENHANCE label must **name the skill it maps to** — "maps to a skill you
already have" without the name is the one thing the reader needed; (b) generic words
(`model`, `first`, `session`, `tool`, `read`, `file`) dominate at 141 notes — a stopword
list or a min-length/IDF weight; (c) `--since DATE` so a session retro scans today's notes,
not the whole seat; (d) the `[NEW] 'vibrobeast'` row is the persona corpus, not a
procedure — a hint that wikilink-hub weighting is 0 for every row (hub 0 ×30).
Receipts: the scan output this session (30 rows, 0 mapped skill names, hub 0 on all) ·
`skilltank/SKILL.md` §"The scan".
Gate: payload = `scan_candidates.py` changes ✓ · recurring: every retro ✓ · one
capability ✓ → **ENHANCE**.

**Q4 · ENHANCE `sandboxer` — three new fingerprints** — W
Ask: (a) **`rm` is refused on both AS4CE mounts** (the 07-02 "rm enabled" note is stale) —
never create probe files; `touch`+`mv` work, `rm` doesn't, so a probe becomes a stray;
(b) **file-tool `EPERM` on rename + bash "Permission denied" on append while the mode reads
`rwx`** = a host-side lock (editor), not a mode bit — say "locked", write a card, don't
retry in a loop; (c) **a shell redirect creates its output before the glob runs** — a
`for f in *` manifest hashes itself (twice tonight); write to `/tmp`, then `mv`.
Receipts: `SEATDIFF-2026-09-04b.md` §probe row · this session's bash outputs (three
`EPERM`, `rm: Operation not permitted` ×7) · `AS4CE0002/h/kit/__pycache__/` (the stray) ·
memory `experiment-seat-as4ce0002` §strays.
Gate: payload = fingerprint lines in the skill ✓ · recurring: (b) 3× today ✓ → **ENHANCE**.

**Q5 · ENHANCE `posix` — the gotchas ledger** — —
Ask: `grep -c PATTERN FILE || echo 0` prints `0` **and** `0` (grep -c prints 0 and exits 1
on no match) → "Illegal number"; use `n=$(grep -c …); n=${n:-0}`. Also: `dash -n` as the
parse check before running; a scorer's `--prove-red` shape (corrupt a copy of the good
fixture, expect the named FAIL).
Receipts: `AS4CE0001/bin/landcheck.sh:29` (the comment carries the rule) · first test run
output ("[: Illegal number: 0") · `tests/landcheck-tests.sh`.
Gate: payload = a ledger line + the harness shape ✓ · recurring: classic ✓ → **ENHANCE**.

**Q6 · ENHANCE `verify-say` — the transport case** — —
Ask: one more state for a *copy*: **"copied, re-read"** (destination hashed, source
unhashable) beside "copied, verified" (both sides hashed); and the rule that a report
prints `NOT ATTEMPTED` with the command for any check the reader could not run.
Receipts: `SEATDIFF-2026-09-04b.md` §"Two piles, closed" (2) · morning `SEATDIFF-2026-09-04.md`
("copied, verified") vs evening ("copied, re-read").
Gate: payload = vocabulary ✓ (verify-say owns words) · recurring ✓ → **ENHANCE**.

**Q7 · NEW candidate `boundscheck` — transcript-side out-of-bounds audit** — —
Ask: the seat's one unbuilt guard: prove a candidate run *didn't* read `AS4CE0001` (or any
named out-of-bounds path). No file-side falsifier exists; the evidence is the run's
transcript (`session_info.read_transcript` → grep tool calls for the path). A small script
over a saved transcript, exit 1 on a hit.
Receipts: `h/MODEL-2026-09-04-experiment-seat-contact-sheet.md` §1 ("not built") ·
`AS4CE0002/README.md` §fairness rules · `AS4CE0002/h/runs/.gate`.
Gate: payload = a script ✓ · recurring: once per candidate run ✓ · one capability ✓ →
**NEW** — route to skill-creator via HOLD; needs a transcript export path first.

**Q8 · HOLD — `seatexp`, "seat an experiment"** — —
The pattern (pin a kit by hash · mint run dirs with UNSET receipts · scorer out of bounds ·
`.gate` signposts · one project per run) is runnable today (`land.sh`, `landcheck.sh`,
README) but has run **once**. Gate 2 fails until a second experiment wants a seat.
Receipts: `AS4CE0002/` (the seat) · memory `experiment-seat-as4ce0002`.
→ **HOLD** (reading room, not a penalty box); promote to NEW on the second seat.

**Q9 · LEAVE-AS-MEMORY — `dialog-tools-need-visible-line`, `dont-ship-tension`,
`signing-tension-stagnation`, `hypothesis-is-model`** — —
Conduct rules and a bless; prose is the payload; Mentat holds them (A + seat, both
written). The S4 prompt already encodes the first two where a candidate needs them.
Receipts: the four notes · bank Q503 · S3 card J1/J4.

**Q10 · ENHANCE `c4prime` faults list (C4 tool, keeper's)** — —
Ask: a seventh repeat fault — **"asserted ahead of the receipt"**: a number or an absence
typed before the tool ran (four instances this session: "I checked: none", two widget word
counts, the manifest). Check that catches it: *every number in a deliverable has a command
above it in the transcript.*
Receipts: S2 card §Celebrate (Fable) · S3 card §Celebrate · `c4prime` output this session
(six faults listed; this one absent).
Gate: not a skill — a line in his generated brief → hand to keeper as a bank row if he
wants it (not filed unasked; his brief).

**Q11 · ENHANCE `mentat-skill` — four notes-discipline mutations (his licence: "mutate
mentat if mentat cares")** — —
Ask: (1) a join of sources is an inference — tag `[MINE]` with a falsifier; (2) "shown"
means a receipt — never a titled list; (3) a quote wears its citation inline; (4) gate
before opportunities in anything toward publication.
Receipts: `h/LENS-2026-09-04-person-intrinsic.md` §"Does Mentat care" · four reader claims
in `mainmem/lens/lens.tsv` (subject `person-intrinsic-2026-09-04`) · memory
`mentat-mutation-2026-09-04`.
Gate: payload = the skill's own discipline text ✓ · recurring: every note ✓ → **ENHANCE**
(reauthor through the forge; the live skill is not edited).
*Extended 2026-09-05 after the three-rack LENS on the architecture model (15 readers, all
QUALIFY; eight verified receipt slips despite mutations 1–4):* (5) a number in a deliverable
comes from a command run this session or wears "quoted from `<file>`, not run"; (6) a
superlative needs its count; (7) a confidence needs a scoring route or it is a word; (8) a
refusal list records nothing. Receipts: `h/LENS-2026-09-05-architecture-itself.md` §"Does
Mentat care", memory `mentat-mutation-2026-09-05`.

**Q12 · ENHANCE `lens.py` — verify the reader's declared sha against the pin** — W
Ask: `import-json` stamps `subj["sha256"]` over the JSON's `subject_sha` and never
compares (`lens.py:96-112`, `:125-160`); a reader with a wrong sha went in green. Compare;
refuse or flag `SHA-MISMATCH` and keep the declared value in a column; a `test_lens.py`
case; a `--prove-red` that plants a wrong sha.
Receipts: `reader-teacher`'s reply (`…916d5fd5…` vs pinned `…916d5fb5…`) · the ledger
showing the pinned sha on all 24 rows · `h/README.md` ("every model provably read identical
bytes" — half a promise).
Gate: payload = code + test ✓ · recurring: every LENS ✓ → **ENHANCE** (`prove-a-promise`:
the pin is the universal check; the reader-side compare is the missing second leg).

**Q13 · NEW candidate — a balanced-pair linter for `bin/` names ("define two tests")** — —
Ask: 20 lines of POSIX: for each name in `bin/`, split at the digit, check the letters are
a balanced pair of the declared length and that the digit is a run-level 0–4; print the
pair and its reverse. `ep1nt` documents the pattern in its header; nothing checks it.
Receipts: `bin/ep1nt` header · Corwin's "define two tests" (chat 2026-09-04) · the person
model §5.5 ("a linter waiting to be written" — the reward and host readers both named it as
the one thing they'd run).
Gate: payload = a script ✓ · recurring: every new tool name ✓ · one capability ✓ → **NEW**;
homes in C4 (`tool-homing-rule`); HOLD until the keeper says the run-level digits are 0–4
only.

## Did the formulation warrant an enhance?

Yes — four of the thirteen (Q1, Q2, Q3, Q12) exist *only* because tooling was used as-is first and
the use showed the limit: seatkeeper's move 1 met tonight's platform; `boxscore-tsv.sh`
and `excurutate.sh` were run and the missing third card kind appeared; the skilltank scan
was run and returned rows without the one field a reader needs. Q4 is the same
formulation applied to the mount itself. The rest came from the work, not the line. At this
rate the line yields ~3 warranted enhances per session and costs one paragraph — keep it.

## What routes where (the hand-off, per skilltank)

skill-creator: Q1 Q3 Q4 Q5 Q6 (enhance passes on existing skills — an ENHANCE is a
*reauthor* through the forge per `cannot-edit-live-skills`, not an edit) · Q2 (rolls kind +
generator, generator homes in C4) · Q7 (new, after HOLD). Keeper: Q8 (hold), Q10 (his
brief). Mentat: Q9 (done). Nothing installed, nothing signed, nothing edited in the live rack.

---
*Fable (Mentat/Vibrobeast), 2026-09-04. Companion widget: `enhance_queue_2026_09_04`.*
