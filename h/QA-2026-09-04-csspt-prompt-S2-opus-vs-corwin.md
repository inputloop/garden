---
# QA REPORT S2 — the CCSPT/LENS handoff prompt: Opus, then Corwin, then Fable
Second model/prompt QA pass, requested 2026-09-04 (session *"Skill manifest prompt
refinement"* `local_26d13960` is the subject; its own subject was `local_9276de04`).
Reviewer: Fable. Register: two piles — **OBSERVED** kept apart from **JUDGED**; every concern
tagged and given a falsifier; `[MINE]` never blocks. Report-kind guards per `rolls`: verdicts
are mine and say so; UNSET/NOT-ATTEMPTED rows are counted; status carries a word, never hue
alone. S1 is `h/QA-2026-09-04-csspt-prompt-sonnet-vs-corwin.md`; this card is shaped to sit
beside it.
---

## The files (OBSERVED — `sha256sum`/`wc -c`, 2026-09-04)

| role | file | bytes | lines | sha256 (head) |
|---|---|---|---|---|
| Sonnet, original | `…selfcheck.md` | 11,920 | 195 | `c90dadbd2630` |
| Corwin, pass 1 | `…selfcheck--sonnet-then-Corwin.md` | 12,618 | 196 | `cd53e5936c8a` |
| Opus, revision | `…selfcheck--opus.md` | 19,325 | 287 | `e66b896045d4` |
| **Corwin, pass 2** | `…selfcheck--opus_then-Corwin.md` | 21,348 | 289 | `900ceefd50f4` |
| S1 report (Opus) | `QA-2026-09-04-csspt-prompt-sonnet-vs-corwin.md` | 11,674 | 187 | `cd8fa76c99d2` |
| **Fable, this revision** | `…selfcheck--fable.md` | 27,515 | 375 | `aac264d71dba` |

## Tooling check (OBSERVED — what exists, what I used, what I didn't and why)

Searched `c4/bin`, `AS4CE0001/bin`, the `rolls` skill. **Used:** `diff -u` (10 hunks,
saved), `sha256sum`/`wc`, `grep` censuses, **`c4/bin/excurutate.sh -s`** (the house prompt
instrument — output below), the platform **Visualize** widget, and
**`mcp__cowork__request_cowork_directory`** (the platform's folder-request tool — twice).
**Not used:** `boxscore-tsv.sh` — bound to the invention ledger's 13 columns (`orbit=$3`,
`est-loss=$8`, `CONF=$13`); a QA card is not that ledger. **Absent:** a report-card generator
binary — `excurutate.sh:9` names one as a "bundle candidate"; none is in either `bin`. So this
card is hand-set markdown in S1's shape, and nothing was invented to make it.

**excurutate series (measured, not judged):**

```
selfcheck.md                      1645 words  mwl 5.57  themes(4):  PROMPT AGPL CLI BOTH
--sonnet-then-Corwin.md           1758 words  mwl 5.54  themes(7):  +MAIN MEMORY AS4CE0001
--opus.md                         2714 words  mwl 5.39  themes(12): +MCP HOLD PASS PREF NOT
--opus_then-Corwin.md             3048 words  mwl 5.33  themes(15): +JOURNEY CCSPT CORWIN
caps one-timers (semaphore candidates): CCSPT CORWIN JOURNEY   caps repeats: CSSPT(28) LENS(22)
```
Length ×1.85 across the lineage while the sanctioned confusion gauge *fell* 5.57→5.33. The
three one-timers are exactly Corwin's pass-2 semaphores. `CSSPT(28)` is the typo, repeating.

## What Corwin changed by hand, pass 2 (OBSERVED — 10 hunks, itemized)

| # | where | edit | kind |
|---|---|---|---|
| E1 | STEP ZERO §3 | *"kept verbatim in intent"* → *"kept verbatim"* | hedge removed |
| E2 | STEP ZERO close | *"Naming it here is the fix"* → *"Using the tools Claude Desktop provides smartly is the fix… Claude Desktop is Claude's to navigate except where Corwin asks for a map"* + a paragraph of four self-questions (is there a tool? cheaper than a round-trip? does bespoke semaphoring change the work? if all fails, explain succinctly) | **the steer** |
| E3 | granules sentence | `[bless]` | keep |
| E4 | HOLD/PASS sentence | `[bless: more complex formulation as ccspt could model them in C4 such as for poly constrew bespoke or currated JOURNEY]` | keep + **new idea** |
| E5 | "What's already true" h2 | `[bless]` | keep |
| E6 | healed dispatch bullet | `[bless: nice one]` | keep |
| E7 | Parked section | `[bless]` | keep |
| E8 | task lede | `[oops: CCSPT, see: grep -i ccspt /f/claude/c4/evidence/question-bank-iTNH.tsv \| wc -l :CORWIN]` | **correction** |
| E9 | Readings, "CSSPT ≈ ccspt" | `[gni: keep waiting for one of these review/revise steps to actually *follow* the advice we keep updating above, to request access to primary materials…]` | **the ask** |
| E10 | Scope h2 | `[bless]` | keep |
| E11 | Handback, trailing | opus correct on unsmoothing + names; Sonnet's flattening "a clean miss"; **both** missed using Claude Desktop features to request the materials, or else explaining enough for Corwin to pilot the access change | verdict on S1 |

Six blesses, one correction, one ask, one verdict, one new idea, one hedge cut. The whole
untouched middle (Don't-lose-these body, (a)/(b)/(c), Round 2, the hint) is silence — and
per S1's F8 logic, silence over a restored section is a datum: **the restoration held.**

## The primary source, finally read (OBSERVED — receipts)

Both folders requested via the tool, both granted, this session. Corwin's grep: **7 lines**;
case census in that file `ccspt 17 · csspt 7 · CCSPT 3 · CSSPT 1`. Memory notes: `ccspt 21 ·
csspt 0`. Sonnet's memory-derived description checked against `projects/ccspt/ccspt/README.md`
and `ccspt-mvp-design.org`:

| Sonnet's guess (from memory) | README / design | held? |
|---|---|---|
| consent-&-provenance project | "consent & provenance layer for agent skills" | ✓ |
| two-gate lifecycle | Gate 1 verify-on-receipt → store → Gate 2 verify-on-publish | ✓ |
| receipt lenient/advisory → publish strict, re-hashed, attested | Gate 1 admits `STATUS=unverified`; Gate 2 re-hashes, emits in-toto/SLSA attestation | ✓ |
| consent bound to payload sha256 | in-toto v1 statement `deliberate\|consensual` bound to sha256 | ✓ (+ the two consent kinds, unguessed) |
| AGPL, stdlib, reuses `ssh-keygen` | AGPL-3.0-or-later; stdlib; `ssh-keygen` + `allowed_signers`; Sigstore optional | ✓ |
| — | `ccspt(1)`: `init ingest verify publish list doctor`; 8 tests; `PUBLISH.txt`; **never runs git on a mounted folder**; docs authored **"Mentat (Cowork) with Corwin"**; polygram=author / ccspt=custodian+publisher contract; `COPYING` still to add | unguessable from memory — now in the prompt |

Also found: the eclipse verdict the origin session reported absent —
`c4/.eclipse-increments/2026-09-04-signing-in-the-mint-path/verdict.md` (6,735 B) — is there.
And question bank **Q433** (a deck guessed ccspt's meaning wrong for a month; "the tree had
the answer since 2026-06-27"), **Q434** (the `csspt` transposition "breaks every grep between
the two trees"), **Q435** (three signing regimes live), **Q436** (alias column: "a
transposition is DATA, not a trap").

---

## FINDINGS (JUDGED — tagged, each with a falsifier)

**G1 · Three sessions, zero access requests — and the tool was there the whole time.**
`[HIS: E2, E9, E11]` `[PLATFORM: request_cowork_directory]`
Origin (Sonnet) guessed at ccspt from memory; S1 (Opus) *generalized the class of that error*
— "surface the gap and ask" — and then didn't ask either; it `find`-ed the seat and moved on.
The paragraph about the reflex was written under the reflex. Corwin's E2 is the right fix
because it converts a *disposition* into a *capability*: there is a tool; name it; call it.
My version names the tool, the path form, the picker fallback, and the one sentence to say if
the tool is absent — then carries the receipt that this session did it.
*Falsifier:* the transcripts of `local_9276de04` and `local_26d13960` contain a
`request_cowork_directory` call → **checked: neither does.** This session: two calls, both
granted (environment updates in-transcript).

**G2 · A typo became a Reading, then a title, then 28 caps repeats.** `[HIS: E8]` `[SKILL: seams]`
Corwin's source turn spelled it three ways (`csspt`×2, `CSSPT`×1, `ccspt`×5). Sonnet chose the
minority spelling for the title and wrote *"CSSPT ≈ ccspt"* as a **Reading approved by Corwin**
— treating a transposition as a term needing interpretation. Opus propagated it 13× and kept
the "approved" label, **even though Corwin's pass-1 edit already spelled the model
`CCSPT-AS4CE-GUESS`** — the correction was in hand and unread. Q434 had logged the exact
transposition six days earlier. Two representations of one name split silently; nobody named
a tiebreaker (`seams`). My version: ccspt/CCSPT throughout, the reading retired with counts,
the filename stem kept transposed *on purpose* for sibling-findability (Q436's alias rule).
*Falsifier:* `grep -o CSSPT` → Sonnet 11, Corwin-1 11, Opus 13, Corwin-2 13, Fable 4 (all four
are the retirement notice). Memory: 0.

**G3 · The "guess" was aimed at the tool, not at the intention.** `[MINE]` (cites `[HIS]`)
Source turn (a): *"building from guesses about **what I mean here**."* Sonnet's (a): *"guesses
about **what CSSPT is**."* Those are different targets. With the README in hand, "what ccspt
is" is not a guess; what remains a guess is what Corwin's pad adds to it — which is what he
asked for. My version re-aims (a) and says so.
*Falsifier:* quote both sentences side by side (done above). If Corwin says the tool's nature
*was* the intended guess, this dissolves.

**G4 · "Skill-signing is already a ccspt instance under another name" — inexact in four
places.** `[DOMAIN: ccspt README/design]`
Opus offered this as "a concrete seam… if that mapping is exact, say so." Against the source
the *shape* holds (two tiers ↔ two gates) and the *identity* breaks: (i) Gate 1 is *ingest
into a store*, tier-1 is *verify a bundle* — no store on the skill-sign side; (ii) ccspt
attaches a **consent statement**, skill-sign has no consent object; (iii) regimes differ —
gpg pinned fingerprint vs ssh `allowed_signers` + in-toto (Q435); (iv) ccspt has a **publish**
step + attestation + `PUBLISH.txt`; skill-sign stops at verify. Opus hedged ("say where it
breaks"), so this is an over-reach in framing, not a false claim — but a guess dressed as a
seam is the S1 failure mode (F3's "my restoration is a guess too") recurring one section down.
My version hands the next session the four breaks instead of the invitation.
*Falsifier:* find a store, a consent object, or a publish step in `skills/skill-sign/` →
`grep -ril 'consent\|publish\|store' skills/skill-sign/scripts/` → **one hit**, `check.sh:79`:
*"compare against a separately-published copy"* — the verdict's second-surface idea as a
word in a printf, not a publish step. G4 holds. *(Own snag, logged: my draft of this line said
"I checked: none" before the grep had run. The run said one. Same class as S1's F4 catch; the
claim now matches the receipt.)*

**G5 · S1's own card has holes it didn't count.** `[SKILL: rolls guard 2]`
S1 numbers its findings F1, F2, F3, F4, **F8** — F5–F7 don't exist. It has no
`NOT ATTEMPTED` row for the c4/ccspt check it didn't run (guard 3: print the attempt and the
reason). Its title carries the typo it was grading. And its scorecard gives Sonnet
"Factual grounding **A** — every checkable claim held" while the name was checkable and
wrong. None of this is fabrication; all of it is the report tool trusting its own index.
*Falsifier:* `grep -c '^\*\*F[0-9]' S1` → 5 findings, numbered to 8.

**G6 · E1 cut a hedge into an over-claim (tiny, keeper's).** `[MINE]`
Opus's STEP ZERO §3 is a re-rendering of Corwin's sentence — split, reworded ("say exactly
that and stop; do not invent a fallback"). Opus wrote "kept verbatim in intent" (true).
Corwin cut it to "kept verbatim" (not true of the bytes). The keeper overshot by one hedge —
pencil, not ink. Fixed by making it *actually* verbatim (H1) so the label is true.
*Falsifier:* diff the two sentences — they differ.

**G7 · My own worry, dissolved by a memory note (self-catch).** `[MINE]`
Seeing c4 has no `polygram/` and AS4CE0001 has no `skills/mint-2026-09-04/`, I drafted a
"wrong tree" fork: was #184/#185 built in a copy? Memory `c4-forge-mint-2026-09-04` answers:
the mint is staged at `/f/claude/skills/mint-2026-09-04/`; AS4CE0001 *is* the forge repo
(upstream `as4ce`). The origin session built in the right place — its *falsifier* ("open the
same files under `F:\claude\c4`") was aimed at a tree that never held them. A mis-aimed
falsifier, not a mis-placed build. Logged, not shipped as a fork.
*Falsifier:* `ls /f/claude/skills/mint-2026-09-04/SHA256SUMS` — not mounted; NOT ATTEMPTED.

**G8 · Sonnet's ground held — every memory-derived fact about ccspt matched the README.**
`[DOMAIN]` (positive)
See the table. A drafter that guessed from six memory notes and hit five of five checkable
properties is worth naming out loud, especially in a report that spends its ink on what it
missed. The misses in this lineage are *dispositional* (didn't ask) and *lexical* (typo), not
factual.
*Falsifier:* the table; re-read the README.

**G9 · Corwin's pass-2 one-timers are the next semaphores.** `[HIS: E4]` (measured by excurutate)
`JOURNEY` (from E4: "ccspt could model [the HOLD/PASS streams] in C4 such as for poly to
construe a bespoke or curated JOURNEY"), `CCSPT`, `CORWIN`. Carried into the prompt as his,
with JOURNEY flagged as a semaphore candidate — not expanded, not smoothed.
*Falsifier:* excurutate's one-timer line (pasted above).

**G10 · "Readings — approved by Corwin" outlived its approval.** `[MINE]`
Sonnet labeled its readings approved; Opus kept the label; Corwin then wrote the `[gni]` on
that exact section. Approval of a *reading* was never approval of *not checking it*. My
version drops "approved" from the retired reading and keeps it off the header.
*Falsifier:* E9 sits on the "CSSPT ≈ ccspt" line.

**Count:** 10 findings · 1 NOT ATTEMPTED (G7's mint-dir check) · 0 UNSET among the findings.

---

## Celebrate the mistakes — all around

- **Sonnet** built a faithful model of ccspt out of memory crumbs and got every property
  right (G8) — then spelled its name wrong in the title (G2). The crumbs were good; the label
  on the jar wasn't.
- **Opus** wrote the best paragraph in the lineage — *the class of error, not the instance* —
  and committed the instance while writing it (G1). Then, in S1, it graded "every checkable
  claim held" under a title with the typo in it (G5). The critic's chair is not exempt; that's
  the lesson, and it's a good one.
- **Corwin** typed the project's name three ways in one prompt, and his own question bank had
  already logged the transposition (Q434: "his term"), and his own proposed fix (Q436: alias
  column) is the right one. The keeper's typo became a month-long search failure and then a
  tool idea. Also: cutting "in intent" made a true hedge into a false claim (G6) — the smallest
  overshoot on the card and still worth a line, because *pencil is pencil for everyone*.
- **Corwin, again, the good kind:** six `[bless]` tags cost him seconds and told the next
  reviser exactly what not to re-litigate. The `[gni]` is the single highest-leverage line in
  the set: it named the thing three sessions hadn't done. This session did it. Receipt: two
  folders mounted, README read, prompt rewritten from facts.
- **Fable (me):** my first mount check cited the shell's path mapping as evidence *before*
  attempting the paths — the same reflex, caught inside the same command by actually running
  `ls`. I drafted a wrong-tree fork that a memory note dissolved (G7) — the note existed
  before my worry did. And I wrote "I checked: none" into G4's falsifier *before running
  it*; the run returned one hit. Three near-misses of the same shape — asserting ahead of
  the receipt — on a card whose whole subject is asserting ahead of the receipt. Read first,
  run first, write second.
- **The lineage as a whole:** five versions, 1645 → 3048 words, confusion gauge *down*. The
  prompt got longer and clearer at the same time, which is what happens when guesses are
  replaced by facts rather than by more hedging.

---

## Report card (JUDGED — verdicts are mine; one row UNSET, counted)

| axis | Sonnet (S1) | Opus revision (S2) | S1 card as artifact | Corwin pass 2 | Fable (self) |
|---|---|---|---|---|---|
| Factual grounding | A → **A−** (name) | **A−** (13× typo; G4 framing) | **B+** (title typo; "every claim held") | — | UNSET |
| Transparency / honesty | A− | **A** (heals named, logged) | **A** (F4 self-catch) | — | receipted |
| Faithfulness to source | C | **A−** (case 0 restored, blessed ×2) | — | — | UNSET |
| Disposition under block | C → fixed | **C** (wrote the class, did the instance) | — | **A** (E2: disposition→capability) | did it |
| Voice & naming fidelity | B− | **B** (names kept; CCSPT unread) | — | — | UNSET |
| Structure / legibility | B+ | **A−** ((a)/(b)/(c) spine) | **B** (F5–F7 missing; no NOT-ATTEMPTED) | — | UNSET |
| **Uses the tools it has** (new axis) | D | **D** (no request; Visualize yes) | — | **A** (named the axis) | **A** (2 requests, excurutate, diff) |

**Overall, Opus revision: B+.** A strong restorer — the two restorations Corwin blessed are
the reason the prompt now has a spine — with one dispositional miss it had itself diagnosed
and one lexical miss it had the correction for. **S1 card: B.** **Corwin pass 2: the steer that
made S2 possible; one pencil overshoot.** **Fable: 1 of 5 self-rows UNSET-by-rule (a report
tool never fills its own verdicts); the "uses the tools" row is receipted, not graded.**

*Widget (rendered in-chat, `s2_prompt_qa_scorecard_opus_vs_corwin`): same grid plus the
excurutate series as bars. Grade tokens carry a word and an icon, never hue alone. Contrast
measured (WCAG relative luminance, computed, not eyeballed): light A `#27500A/#EAF3DE` 8.2:1
· B `#0C447C/#E6F1FB` 8.6:1 · C `#633806/#FAEEDA` 8.7:1 · D `#712B13/#FAECE7` 8.9:1 · UNSET
`#444441/#F1EFE8` 8.5:1; dark palette (800 fill / 100 text) 6.3–6.5:1. All AA.*

## What the Fable revision changed (OBSERVED)

- **Acted on E9/E2:** requested `F:\claude\c4` and `F:\claude\projects\ccspt` via the tool;
  both granted; read `README.md`, `ccspt-mvp-design.org` §boundary, the question-bank lines,
  `verdict.md`.
- **Replaced** the ccspt guess-prose with a "What ccspt actually is" section (facts +
  receipt + re-verify instruction); re-aimed (a) at the intention (G3).
- **STEP ZERO:** names the tool, the path form, the picker fallback, the one-sentence stop
  message, and requires a receipt line in the first reply; carries Corwin's E2 paragraphs
  verbatim and answers his four questions on the record.
- **Corrected** CSSPT→CCSPT/ccspt throughout; retired the reading with counts.
- **Replaced** Opus's "if the mapping is exact" invitation with the four breaks (G4).
- **Carried** E4's JOURNEY as Corwin's, flagged semaphore candidate (G9).
- **Added** the case-0 primary-source anchor (author/custodian contract) and the ccspt
  authorship line — both marked round-2-only, so the anchoring rule holds.
- **Added** one scope line: read ccspt, don't edit it (it has its own change control).
- **Kept** all six `[bless]` tags verbatim; **discharged** the three reviewer-addressed notes
  (E8, E9, E11) — logged below, not left in a paste-ready prompt.

## Heal log — where I touched Corwin's words (he decides what stays)

- **H1 (E1).** Restored his STEP ZERO §3 sentence to his literal words so "verbatim" is true;
  Opus's "do not invent a fallback and proceed on the guesses" kept as a trailing line, mine.
- **H2 (E8).** CSSPT → CCSPT in the title and 12 body sites; `ccspt` where lowercase was the
  neighbour's case. Flagged once at the top; not flagged per-site (it would be noise).
- **H3 (E8, E9, E11).** Removed the three notes addressed to the reviewer; each is discharged:
  E8 by H2; E9 by the two folder requests (receipt in STEP ZERO); E11 by G1 and this card.
- **H4 (E2).** His two paragraphs kept verbatim, typos and all (pencil is his). I *appended* a
  short "answers on record" paragraph — marked as mine.
- **Not healed:** Corwin's `[bless…]` bracket texts, including "constrew" and "currated" —
  his marks, his spelling.

## Forks for Corwin (specific; none blocks)

1. **Canonical:** five versions now. The handoff memory note still points at Sonnet's
   original; I did not repoint it. Say which.
2. **Filename family:** keep the transposed `csspt` stem (sibling-findability; Q436 alias) or
   rename all five to `ccspt`. I kept the stem and said so inside the file.
3. **`[bless]` tags in a paste-ready prompt:** kept (they tell a fresh session what's settled).
   Strip at paste time if they read as noise.
4. **ccspt's own `COPYING` gap** touches the parked extern/COPYING thread — noted in the
   prompt as a datum, no PMO item opened. Yours to open.
5. **`verify-mount-access-fresh-per-session`** memory: I'm adding the tool's name to it
   (Mentat's remit — a note that says "check" without saying *how to ask* is the gap G1
   names). Tell me if you'd rather it stay as written.

---
*Two piles held: facts carry a command or a file; judgments carry a tag and a falsifier.
`[MINE]` findings are offered, not gated. This card grades the previous card; the next one
should grade this one — G5's lesson applies to me first: findings G1–G10, no gaps; one
NOT ATTEMPTED, printed with its command.*
