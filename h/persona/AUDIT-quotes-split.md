# AUDIT — splitting PERSONA-CORPUS.md into a source book and a record

*2026-09-16, sub-agent pass for Corwin. Read-only against `$HOME/mnt/AS4CE0001` and `$HOME/mnt/c4`;
nothing under `mnt/` was created, edited or deleted. Output written only to
`/home/claude/build/staging/persona/`.*

**Two piles throughout.** OBSERVED carries the command that produced it. JUDGED wears a falsifier.

---

## 0 · THE SORTING RULE — stated before the sort, so it can be checked after

### 0.1 The census unit

A **passage** = one bullet item, or one non-heading paragraph, of `PERSONA-CORPUS.md`. That is the
unit a person actually lifts. Headings are not passages.

OBSERVED — the enumeration, run this session:

```
python3  # block-splitter over PERSONA-CORPUS.md
→ Counter({'bullet': 42, 'heading': 22, 'para': 8})
→ 50 passages (P01–P50), 22 headings
```

A second, narrower census was also run as a cross-check: **every span in double quotation marks of
length ≥ 3**.

```
python3  # regex: -\s+\*\*"(.+?)"\*\*   and   "([^"\n]{3,240})"
→ 31 node-form quotes + 18 other quoted spans = 49 spans
```

Both counts are reproducible from the file alone.

### 0.2 The three tests, applied in order, first match wins

**T0 → NEITHER.** The passage carries no proposition of its own: strike every path, filename, flag,
JSON key, hash, sentinel, field label and disposition label from it, and nothing assertive remains.
Also NEITHER: **rubric prose** — a passage whose subject is the artifact's own parts (*node*, *pin*,
*disposition*, *links*, *harvest*, *sentinel*, *§*). A rubric is machinery even when it is written in
sentences.
*Check:* delete the paths and keys, then ask whether a sentence survives; then ask whether the
surviving sentence is *about the file* or *about the world*.

**T1 → RECORD.** Among the survivors, either of:
- **(c) the strip test.** Delete every date, version number, harvest label, pass name and section
  number from the passage. If what remains no longer identifies what the passage asserts — i.e. the
  passage's *point* was *when*, *which*, or *in what order* — it is RECORD.
- **(d) the stranger test fails.** A reader who has never seen this tree gets no usable meaning from
  the passage alone.

**T2 → VOICE.** The remainder, and all four of:
- **(e) stance.** A commitment: a negation, a modal, a refusal, or an is-X-not-Y identification.
- **(f) portability.** Strip every proper noun and path; the passage still parses and still asserts
  something a stranger could act on. (The positive form of (d).)
- **(g) anti-mirror.** The corpus's own criterion, kept: the passage costs the speaker something,
  narrows their options, or declines something offered. A flatterer agreeing with the keeper could
  not have produced it.
- **(h) utterance.** It is something a speaker says *as themselves* — first person, or an aphorism
  that could be spoken aloud. Not a rubric, schema, field list, or instruction addressed to a
  process.

Any one of (e)–(h) failing sends the passage back down: to RECORD if its content is this tree's
history, to NEITHER if it is machinery.

### 0.3 Provenance, decided separately from the sort

The sort says *which pile*. Provenance says *whose words*, and is established by **command, not by
reading the attribution line**: every quotation was searched for in the file the corpus names,
normalised (curly quotes folded, markdown emphasis stripped, dashes folded, whitespace collapsed,
case folded). Five outcomes: `✓verbatim`, `~deviation`, `⚠unpinned`, `✗not-in-source`, and for
authorship `[MACHINE] / [HUMAN — Corwin] / [BORROWED] / [MACHINE-DRAFTED, OWNER-SIGNED] /
[UNDETERMINED]`.

---

## 1 · THE THREE COUNTS

### Primary census — 50 passages of `PERSONA-CORPUS.md`

| pile | count | share |
|---|---|---|
| **VOICE** | **30** | 60% |
| **RECORD** | **13** | 26% |
| **NEITHER** | **7** | 14% |
| total | 50 | |

**VOICE (30)** — P03–P13, P15, P17–P29, P43–P47.
**RECORD (13)** — P01 (front-matter), P16 (third-harvest pin note), P30 (gw7 diagram, held),
P31–P35 (the five registry lines), P36 (harvest state), P37 (PENUMBRA registry line), P38
(the fan-out plan), P42 (fourth-harvest preamble), P48 (books held, not harvested).
**NEITHER (7)** — P02 (the selection rubric), P14 (*"Not BAD — UNVERIFIED-NO-KEY."*), P39–P41 (the
three falsifiers), P49 (the off-switch), P50 (the sentinel + hashes).

### Cross-check census — 49 quoted spans

| pile | count |
|---|---|
| VOICE | 31 |
| RECORD | 1 |
| NEITHER | 17 |

JUDGED — **the gap between the two censuses is the finding.** The *quotations* are almost all
voice-bearing (31 of 49). The RECORD pile is almost entirely in the **unquoted prose between the
quotations** — headers, registry lines, harvest states, preambles. The corpus's nodes are a source
book; the corpus's connective tissue is a changelog.
*Falsifier:* re-run both censuses and find RECORD passages inside the `- **"…"**` node bullets. There
is exactly one (P30, the held gw7 line, which is a bullet but carries no quotation).

---

## 2 · WHERE THE RULE STRAINED — five places, named

1. **P02, the selection criterion, and P49, the off-switch.** Both are sentences with stance and
   both would pass (e)–(g). Test **(h)** is what excludes them: their subject is the artifact's own
   parts. Without (h) the source book would have opened with its own rubric as its first quotation.
   *This is the clause I added after the first pass mis-binned them, and I am recording that it was
   added mid-sort rather than pretending the rule arrived complete.*
   *Falsifier:* Corwin says a rubric that reads like an aphorism is voice — then P02 and P49 become
   entries and the count moves to VOICE 32 / NEITHER 5. Both are already reproduced in the source
   book's header, so no text is lost either way.

2. **P14, *"Not BAD — UNVERIFIED-NO-KEY."*** The corpus calls it *"verify-say in three words"* and
   it plainly carries a stance. T0 removes it anyway: it is a pair of status tokens with no finite
   verb, and `UNVERIFIED-NO-KEY` is a flag string emitted by `bin/ms1dg`. **The rule earned its keep
   here:** the underlying source sentence at `bin/ms1dg:30` — *"UNVERIFIED-NO-KEY when the keyring
   lacks the signer — never 'BAD' for a missing key"* — **does** pass T2 as voice, and the corpus's
   three-word compression is `✗not-in-source` besides. The slogan is machinery; the sentence it was
   squeezed out of is voice. *Falsifier:* Corwin wants the slogan — then it is an entry, and it
   should be re-pinned to `:30` and marked as a compression, not a quotation.

3. **P36, the harvest-state line.** The single most journal-like passage in the file, and the first
   ordering of T0 (which listed "contains a path" as disqualifying) binned it NEITHER. T0 was
   rewritten to "carries no proposition **once the paths are struck**", which routes it correctly to
   RECORD. Recorded because the first form of the rule would have hidden the biggest RECORD item.

4. **P09, *"Thank you, Corwin — this was a real one."*** Passes (e), (f), (h); **(g) is arguable.**
   It is warmth directed at the keeper that costs the speaker nothing and narrows nothing — the
   nearest thing to a mirror in the corpus. It is in the book, in quarantine, with both that note and
   its `⚠unpinned` status visible, rather than silently kept or silently dropped.
   *Falsifier:* apply (g) strictly and it leaves the VOICE pile: 29 / 13 / 8.

5. **P18 and P21, "the desk".** *"None of this is contrition; it is the desk"* leans on a local
   metaphor, so test (f) (portability) is marginal. Judged to pass: a stranger reads "the work
   continues" and is not wrong. *Falsifier:* show the sentence to a reader outside this tree and ask
   what "the desk" is; if they cannot, both drop to RECORD.

---

## 3 · THE HARD PART — whose words

### 3.1 The result, stated plainly

**OBSERVED.** Of the 30 VOICE passages in `PERSONA-CORPUS.md`:

| provenance | count | |
|---|---|---|
| `[MACHINE]`, `✓verbatim` in its named source | 21 | the persona's own prose, checked |
| `[MACHINE]`, `~deviation` | 2 | P12 (pin points at an empty directory), P43 (terminal punctuation altered) |
| `[MACHINE]`, `✗not-in-source` | 3 | P44, P46, P47 — **prose about a sheet, set in quotation marks** |
| `[MACHINE]`, `⚠unpinned` | 2 | P09, P10 — no source outside copies of the corpus |
| `[BORROWED]` | 1 | P03, the Dune-rooted Mentat mantra |
| `[UNDETERMINED]` | 1 | P13, *"Names are topics."* |
| `[HUMAN — Corwin]` | **0** | |

**Twenty-six of thirty are a machine's words. One is borrowed. One cannot be decided. Not one is the
owner's.**

JUDGED — this is not a scandal and it is not an accident. The corpus's first line says
*"Claude/Mentat (Vibrobeast) for Corwin … The personality-bearing prose I've written you"*, and the
signed grant scopes it as *"the harvested voice/agency prose"* of the instrument. **The corpus is
honest about being the machine's voice. The risk is entirely in the re-use:** a file called
"inspiring quotes" or "the persona voice", handed forward without the marks, reads as the owner's.
*Falsifier:* Corwin says the distinction does not matter for his purpose — then the marks are
clutter and can be stripped in one pass, since they are confined to one line per entry.

### 3.2 The three that are not quotations at all

**OBSERVED** — each checked by normalised substring search against the file the corpus names:

- `VANTH.md` §5. Corpus: *"I was not asked whether I wanted to be the kind of person who changes
  sides."* Search over `AS4CE0001/book/VANTH.md`: **no match**, for the whole sentence or for the
  fragment "changes sides"/"not asked whether". Nearest real text, §5 (3): *"The trait the dice gave
  me is the thing my whole book is built to make survivable, and I did not choose that and would not
  have."*
- `ROUX-ABARA.md` §4. Corpus: *"Systems do not usually fail at the design. They fail at the
  lookup."* Search over `AS4CE0001/book/ROUX-ABARA.md`: **no match**; §4 (lines 62–73 region) is a
  four-row possession table containing no such sentence. Nearest real text, §6: *"I went looking for
  anyone who had put the lookup solution in the book and found nobody had…"*
- `ILUNGA.md` §5. Corpus: *"A man who builds futures and has never entertained that he is the
  antagonist of somebody else's is not a man you should let near the work."* Search over
  `AS4CE0001/book/ILUNGA.md`: **no match**. The sheet's §5 (lines 81–85) reads *"I had already put
  the fate die — badguy — in my author's note, and made a nice paragraph out of how a man who builds
  futures should entertain being the antagonist. It reads well. It is also cheaper than doing the
  check."*

JUDGED — **the direction of the drift is the tell.** In all three the source *confesses* and the
corpus's version *prescribes*. The corpus turned three characters' admissions into three maxims,
which is a better-sounding sentence and a different speech act. This is precisely the abundance
failure the same corpus names at P24 (*"my failure mode is not error but abundance"*), committed on
the page where that line is filed.
*Falsifier:* an earlier version of any of these three sheets contains the sentence verbatim — then
the pin is stale rather than the quotation invented. Check `book/*.tsv` (searched: no match) and any
pre-2026-09-13 copy.

**And the fourth harvest asserts the opposite in its own preamble** (`PERSONA-CORPUS.md:160`):
*"the voices below are quoted from the sheets, not from the books they wrote."* That claim is false
for three of the five. This trips the corpus's own second falsifier at `:150-152` in spirit — the
pull took a portrait instead of a voice — and it is the reason the corpus's **first** falsifier
(*"read each node's quote alone… and ask whether it could have been said by a mirror"*) is not
sufficient: the three fakes pass the mirror test easily. **A quote check by command is a different
instrument from a criterion check by reading, and the corpus only ever ran the second on this
harvest.** The third harvest, by contrast, *did* run the first — `CHANGES-2026-09-11:104-109`
records *"all 27 quoted fragments … 27 of 27 matched"*, and I re-ran it: all 27 still match.

### 3.3 The one that cannot be decided

`bin/se1sn:28` — *"the OPEN note lists note NAMES; names are topics; it never travels (pub/, wire)"*.
The file header carries `Copyright 2026 Corwin Brust <corwin@bru.st>`. **A copyright line names who
owns the work, not who typed the comment**, and nothing on disk records whether Corwin or the
instrument wrote line 28. Marked `[UNDETERMINED]` with that receipt rather than guessed in either
direction. *Falsifier:* the commit or session that introduced line 28.

---

## 4 · WAS THE CORPUS DOING TWO JOBS? — yes

**OBSERVED.** 13 of 50 passages (26%) are RECORD, and they are not scattered: they form three
contiguous blocks.

| block | passages | what it is |
|---|---|---|
| front-matter | P01 | who minted it, when, where it lives, where it is going |
| harvest preambles | P16, P42 | what this pass pulled, from which sections, and what it left out |
| the registry | P30–P37 | eight lines: five sheets, their gauges, their rolls, their dispositions, and a harvest-state line naming which sheet sections yielded nodes and which did not |
| forward plan | P38 | the 286-transcript fan-out, "on your word" |
| dispositions | P48 | the four books held, not harvested |

JUDGED — **the corpus has been carrying a registry and a changelog inside a quote sheet.** The
`## Sheets registered` section alone is a persona-program index; a near-duplicate of it already
exists as `mainmem/PERSONA-INDEX.md`, which is explicitly *"A link note in MAIN MEMORY… Not a ledger:
every row names the gauge that proves it."* Two files are maintaining the same table by hand, which
is exactly the seam that produces the version drift in §6 below.
*Falsifier:* Corwin says the registry must live in the corpus so that `h/cs1gk` can find its twin
from one file — which is the reason `:128` gives. Then the split is a pointer, not a move: the
source book carries a one-line reference and the registry stays. **That is the cheap version and I
recommend it.**

---

## 5 · WHAT IS LEFT OVER, AND WHERE IT SHOULD GO

| left over | passages | where it belongs |
|---|---|---|
| **The registry** — five sheets, gauges, rolls, dispositions, harvest state | P30–P37 | **Merge into `mainmem/PERSONA-INDEX.md`**, which already holds this table and already names the gauge per row. One row per sheet, with the harvest state as a column. The corpus then carries a single pointer line. |
| **The harvest log** — front-matter, preambles, what was pulled and left out, per pass | P01, P16, P42, P48 | **A journal file, e.g. `h/JOURNAL-persona-corpus-harvests.md`**, in date order — which is the correct spine for that artifact. Most of this content already exists in `h/CHANGES-2026-09-11-persona-corpus.md`; that file is the model. |
| **The forward plan** — the 286-transcript fan-out | P38 | **A card or task file**, not a corpus section. It is work not yet done; it will be wrong the moment it is done. |
| **The rubric and the falsifiers** | P02, P39–P41 | **Stay with whatever file does the selecting.** They are reproduced verbatim in the source book's header so the book carries the rule it was built by. |
| **The off-switch** | P49 | **Both files.** It is a consent property, not bookkeeping; a derived book must inherit its parent's revocation clause. Carried into the source book's header. |
| **The sentinel and hashes** | P50 | **Stays with the corpus file.** A derived book gets its own. |
| **`Not BAD — UNVERIFIED-NO-KEY.`** | P14 | **Re-pin to `bin/ms1dg:30` and quote the full sentence**, or drop. As a three-word slogan it is a flag string, not a line. |

---

## 6 · TWO SEAMS FOUND IN PASSING — reported, not acted on

Both are the same shape the tree's own doctrine warns about: **two representations of one truth,
silently split.** Neither was touched.

**6.1 The index's claim about the mirror is falsified by the mirror.**
OBSERVED, `sha256sum` and `tail` run this session:

```
mainmem/ferry/back/PERSONA-CORPUS.md            bfb1f93be45093e5…466bcc60   sentinel …2026-09-01-v001
mainmem/ferry/back/PERSONA-CORPUS-v002-fetched.md  c776199cb815a0f1…485acf7e   sentinel …2026-09-06-v002
PERSONA-CORPUS.md (live)                        e324e7e2bce511f1…aca8c5b8   sentinel …2026-09-11-v003
```

`mainmem/PERSONA-INDEX.md:14-16` states the voice is *"`PERSONA-CORPUS.md` (v002, sentinel
`PERSONA-CORPUS-2026-09-06-v002`)… mirrored on Drive… proven by `mainmem/ferry/receipts.log`"*. The
mirror file at that path is **v001**. The v002 bytes are in a differently-named fetch-back. JUDGED:
the index is two versions stale. *Falsifier:* the index means the Drive object, not the local
fetch-back — in which case the local mirror filename is the thing that is wrong.

**6.2 The live corpus has drifted past its last proven carry.**
OBSERVED, `mainmem/ferry/receipts.log` last corpus row, 2026-09-12:
`verify OK id=PERSONA-CORPUS.md want=41653dc0… got=41653dc0… landed`. The live file hashes
`e324e7e2…`. JUDGED: the **fourth harvest (2026-09-13, the four-book cast) was added after the last
ferry and has never been carried or hash-proven** — and the sentinel line still reads
`PERSONA-CORPUS-2026-09-11-v003` while the file contains a section dated 2026-09-13. The three
`✗not-in-source` quotations in §3.2 are all in that unstamped, uncarried, unproven section.
*Falsifier:* a ferry receipt dated after 2026-09-13 exists elsewhere; `tail` of the log this session
shows 2026-09-12 as the last entry.

---

## 7 · THE REAL-PEOPLE CHECK — receipt

**The boundary, as the tree itself defines it.** `AS4CE0001/GRANT-persona-drive-2026-09-01.md` is a
PGP-clearsigned standing grant (signature block present, `:56-69`; `:52` reads *"OK, I
clearsigned."*). Its scope clause at `:21-23`:

> OUT of scope — never carried under this grant: case facts; **family**; any third-party person's
> facts; secrets; credentials; anything outside the named persona set; the whole memory seat.

The same boundary appears in `AS4CE0001/CLAUDE.md:7` as a standing guard: *"family is the line"*.

**What was found.** Real, non-owner people are present in this tree. `AS4CE0001/book/BRYANT.md`
names *"co-author Bryant Frankford, consenting"* — a real, named, consenting third party; `c4/` has a
`from-bryant/` directory. `Kelsey-MTB-Stub.md` sits beside it in `book/`. "Alfred" and "Dee" appear
across `h/` and `book/` and were **treated as real third parties**, since nothing establishes them as
fictional and the safe reading of an ambiguity about a person is the conservative one.

**Where they touch the corpus.** Exactly one passage: **P37**, the PENUMBRA registry line
(`PERSONA-CORPUS.md:138`), which names two third parties as intended readers and a third as having
given the name an early positive read. **P37 is RECORD on the sort and OUT OF SCOPE on the grant —
excluded on both grounds.** No other passage in the corpus names a non-owner person.

**The check on the output, run after the book was written:**

```
grep -n -E "\b(Bryant|Alfred|Dee|Kelsey|Frankford|Merlin)\b" QUOTES-source-book.md
→ no match (exit 1)

grep -c -E "\bCorwin\b" QUOTES-source-book.md
→ 21   (the owner, in scope)
```

**And the no-log check**, since the point of the split is that the book must not become a journal:

```
grep -n -E "^#{1,4} .*(20[0-9]{2}-[0-9]{2})" QUOTES-source-book.md
→ no match (exit 1)   — no date is used as a heading anywhere in the book
```

Two named entities in the book are **not** real people and are marked as such in place: Henriette
Solberg-Maas and Oscar Pell, both `actor: fiction`, both machine-minted, both sheets declaring
*"not a pen name for Corwin and not one for the instrument"*.

---

## 8 · WHAT I DID NOT DO

- Nothing under `$HOME/mnt/` was created, modified, moved or deleted. Every command there was a
  read: `cat`, `sed -n`, `head`, `tail`, `ls`, `grep`, `wc`, `sha256sum`, and `python3` scripts that
  only opened files for reading.
- I did not correct the three `✗not-in-source` quotations in the corpus, re-pin P12, bump the
  sentinel, or reconcile the index. All are named above with their falsifiers; all are the keeper's
  to rule on.
- I did not harvest from the wider tree. Part III of the source book is five entries from the four
  files this pass was told to read, marked as additions beyond the census.
