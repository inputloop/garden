---
# PROMPT — CCSPT-opening model + LENS mentat-self-check  (Fable revision, S2)
Carried forward from the 2026-09-04 Vibrobeast/Cowork session that shipped skill-manifest
signing (PMO #184/#185). Paste this whole file as the opening message of a fresh session.
It stands alone — no other context from the prior sessions is assumed.

*Lineage: Sonnet drafted the consolidation → Corwin hand-edited (4) → Opus revised → Corwin
hand-edited (10) → this revision (Fable). Every Corwin edit from both passes is kept; his
`[bless]` marks stay where he put them. Where I touched his words it is flagged `[healed]`
inline and logged in `h/QA-2026-09-04-csspt-prompt-S2-opus-vs-corwin.md`. His untouched
file remains at `h/PROMPT-2026-09-04-csspt-lens-selfcheck--opus_then-Corwin.md`.*

*Name: the project is **ccspt** (`ccspt(1)`, `F:\claude\projects\ccspt`); "csspt" is a known
two-letter transposition (c4 question bank Q434, 2026-08-29; Q436: keep it as an alias so a
transposition is data, not a trap). This file's name keeps the transposed stem on purpose —
so it sits beside its four siblings — and is correct everywhere inside.* `[healed: CSSPT→CCSPT]`
---

## STEP ZERO — before anything else, check; do not assume; then ASK

The three sessions before this one worked with **only `F:\claude\AS4CE\AS4CE0001`** mounted
and treated `F:\claude\c4` and `F:\claude\projects\ccspt` as unreachable. **None of them
asked.** The S2 review session (Fable, 2026-09-04) asked, was granted both in under a minute,
and read the primary source — the facts below are from that reading, receipted in the S2
report. **Do not inherit either state as a fact about this session.** Mounts differ session to
session. Before doing anything else:

1. **Attempt** — `ls`/`find` (bash) or `Read`/`Grep` (file tools) against `/f/claude/c4`,
   `/f/claude/projects/ccspt`, and `/f/claude/AS4CE/AS4CE0001`. Actually attempt it. A prior
   session's absence is not evidence of this session's absence.
2. **If reachable**: read the real source directly — `projects/ccspt/ccspt/README.md`,
   `ccspt-mvp-design.org`, `c4/evidence/question-bank-iTNH.tsv` (`grep -i ccspt`) — and treat
   the facts below as *stale until re-read*: the source may have moved on since 2026-09-04.
3. **If not reachable: ask — with the tool, not with prose.** In Cowork the tool is
   `mcp__cowork__request_cowork_directory` (pass the host path, e.g. `F:\claude\c4`; the keeper
   sees the path and approves; omit the path and a native folder picker opens). Request
   **both** folders. Corwin's own words, verbatim: *you must request these before beginning;
   Corwin cannot grant you access to the primary materials unless you ask for them. If you
   cannot do this stop and simply explain that you do not know how to ask for access to mount
   an additional typically used cowork folder such as those mentioned above. Each contains
   required reading for this work.* `[healed: restored to his literal sentence — see S2 log H1]`
   Do **not** invent a fallback and proceed on guesses.
4. **If the tool is not in your session**, say exactly this and stop: *"I don't have the
   folder-request tool in this session. Please add `F:\claude\c4` and
   `F:\claude\projects\ccspt` to this session's folders (Cowork → the folder picker), then
   re-send this prompt."* That sentence is the whole map Corwin needs; don't pad it.
5. **Receipt in your first reply**, one line: which of the three were reachable, which you
   requested, which were granted. Then proceed.

**The class of error this closes, not just the instance.** The failure the prior
session made was not "wrong about one mount" — it was the reflex to *smooth over a block
and proceed on degraded inputs* rather than *stop and escalate*. That reflex will recur
in other shapes (a missing tool, an unreadable file, an ambiguous grant). Default:
when the thing you need is not in hand, surface the gap and ask — proceeding-and-naming
is for your own dispositional cautions, not for missing source material the work
depends on. This check is not a formality: a prior session got exactly this wrong once
already (assuming rather than checking). Using the tools Claude Desktop provides smartly is the fix.  Do not depend on Corwin to be the expert, do not assume he wants to become the expert: Claude Desktop is Claude's to navigate except where Corwin asks for a map. 

Before deciding some materials aren't accessable, ask yourself some questions: "Don't I have some tool or feature I'm supposed to use to request access within the UI Corwin is using to talk to me?", "Is it better for Corwin to spend a whole new request to ask me how to ask for what I need to access his materials to do the work requested of me?", "Does the existance of expressly bespoke semiphoring technology change what my work is with this prompt?", "If I cannot access or request access to primary materials for a task, and I cannot guess how those materials will inform the task(s) I have been handed this turn, should I just explain something about how Claude Desktop works and using that to explain how Corwin can reconfigure the way he uses Claude before trying again, carefully but suscinctly explaining that whole process?"

*Answers on record from the S2 review, so the questions don't re-open each session:* (1) yes —
the tool named in step 3; (2) no — one tool call is cheaper than a round-trip of his; (3) yes —
ccspt already emits its own semaphores (`STATUS=unverified|verified`, `attestation.json`,
`PUBLISH.txt`), so the work is wiring to real signals, not guessing at them; (4) only if steps
3 and 4 both fail, and then in one sentence (step 4 is that sentence).

## What ccspt actually is (read from the source 2026-09-04 — re-verify per STEP ZERO)

`ccspt` — **consent & provenance layer for agent skills.** It governs the *receipt,
consent-marking, and publication* of skill records; it does not author skills (that is
polygram), it vouches for them. Stdlib only; signing reuses `ssh-keygen` (+ `allowed_signers`);
optional Sigstore keyless; AGPL-3.0-or-later code, CC-BY-4.0 docs; **canonical `COPYING` still
to be added before public release** (its README says so). MVP is `ccspt(1)`: `init · ingest ·
verify · publish · list · doctor`; 8 stdlib unittests (DG-2/4/5/6/7 + collision guard).

The pipeline, from its README:
`polygram ──(SKILL.md + tool.py)──▶ [Gate 1: verify-on-receipt] ──▶ store ──▶ [Gate 2: verify-on-publish] ──▶ git remote`

- **Gate 1** is lenient: with no signing key it admits the record in *advisory* mode
  (`STATUS=unverified`) rather than failing.
- **Gate 2** is strict: only `verified` records may publish; it **re-hashes the payload**
  (never trusts a stored digest) and emits an **in-toto/SLSA attestation**.
- **Consent** is an **in-toto v1 statement — `deliberate` | `consensual` — bound to the
  payload's sha256.**
- `publish` writes `attestation.json` and a `PUBLISH.txt` with the exact git steps to run
  **from an upstream clone** — *ccspt never runs git on a mounted folder.*
- **The ccspt ↔ polygram boundary is a stated contract** (design §"Division of
  responsibility"): *polygram produces* (author, in provenance terms); *ccspt governs*
  (custodian and publisher). polygram does not sign/verify/consent-gate/persist/push; ccspt
  does not synthesize/edit/review content. The handoff payload is polygram's actual
  `skills/<label>/{SKILL.md,tool.py}`; ccspt reads `name` from frontmatter and *assigns* the
  version itself.
- Every ccspt design doc is authored **"Mentat (Cowork) with Corwin"** (2026-06-27). *(Round-2
  material — see the anchoring rule in (c); do not feed this to round 1.)*
- Also in the question bank, bearing directly on "play it out": **Q435 — three signing regimes
  are now live:** (1) gpg clearsign/detached on the c4 shelf; (2) sha256 sidecar; (3)
  ssh-keygen in ccspt with in-toto consent + SLSA attestations. A report that doesn't say
  which it quotes is ambiguous.

What remains a **guess** is not what ccspt *is* — it is **what Corwin is drawing on the pad**
that ccspt does not already say. That is the target of (a).

## Don't-lose-these — the context Corwin said you need *whole*

> *(Restored by Opus, blessed twice by Corwin. The source turn introduced this under "more
> context: you need it all," and the first consolidation compressed it to a single clause.
> It is the actual design Corwin is driving at — do not treat it as background. Presented
> lightly de-obfuscated; the mechanism and Corwin's own terms are preserved, not paraphrased
> away.)*

The base scenario the whole task varies (call it **case 0**): **Vibrobeast tends
polygram and the Grammary; Mentat joins ccspt.** ccspt is joined *for memory*, polygram
*for persona* — so far the main treatment is a *skill*, but the design must also cover
the general case via **literate, RECIPE-style `PERSONA-<frame-of-reference>` variable-
resolution granules**: multi-point metadata followed across memory among **three or more
semaphores (local), or five or more — any two of which may change in a single
message/transaction.** [bless]

This creates a general use for any well-structured **"note"** that ccspt might pass:
a way to decide whether an incoming **"insight"** should be taken in. The canonical
direction is **ccspt → poly** — e.g. a memory note carrying a *mutation of fact* relevant
to a persona in the garden that has grown some affinity toward a tool the fact pertains
to. The support layer is the **MCP (or whatever we support) memory-bridge + semaphore**,
with **Vibrobeast working it to establish — via well-formed C4 streams — what has
changed and how to bring it in (generally: HOLD / PASS).** [bless: more complex formulation as `ccspt` could model them in C4 such as for `poly` constrew bespoke or currated JOURNEY]

*(Corwin's second-pass extension, carried as his: ccspt could model the HOLD/PASS streams
**in C4**, e.g. so that poly can construe a bespoke or curated **JOURNEY**. `JOURNEY` is a
new one-timer in this lineage — treat it as a semaphore candidate to be pinned, not a word
to smooth.)*

**Standing invariant for now:** assume nothing changes about the **two manual acts
Corwin must still perform to actually intern a received change** this way. This turn is
focused, from polygram's standpoint, on **the ingestion** — and on having ideas for how
the *merge* could be worked. (The three "what if" framings in Round 2 below are the
*alternatives* to case 0 — they only make sense with case 0 stated, which is why it is
restored here.) **Case 0 now has a primary-source anchor:** ccspt's own contract already
splits *author* (polygram) from *custodian/publisher* (ccspt) — the roles case 0 assigns
to Vibrobeast and Mentat respectively. That is a fact about the tree, not a claim about
either persona; round 2 decides what it means.

## What's already true (don't redo it) [bless]

- This session (2026-09-04) shipped PMO #184 and #185 in `polygram/dist.py` and
  `skills/skill-sign/scripts/{skill-sign.sh,check.sh,SAYS-SO,tests.sh}`: every
  per-skill `.skill` bundle now carries a hash-only `.skill-manifest`; `skill-sign.sh
  verify` is tiered (no-gpg tier-1 `UNVERIFIED-AUTHOR` path + the existing pinned-key
  tier-2); `check.sh` is a standalone no-gpg checker with `--prove-red`. 97 pre-existing
  + 8 new Python tests green, 7/7 shell fixtures in `tests.sh` green, both harnesses
  prove themselves red on demand. **Not signed, not installed** — that's Corwin's, per
  `[[cannot-edit-live-skills]]`. *Tree note (S2): `AS4CE0001` **is** the forge repo
  (upstream `as4ce`); `c4` holds no `polygram/`; the mint staging is
  `/f/claude/skills/mint-2026-09-04/`. The eclipse verdict behind this work is at
  `c4/.eclipse-increments/2026-09-04-signing-in-the-mint-path/verdict.md` — the origin
  session couldn't find it because c4 wasn't mounted; it's there.*
- `mentat-skill` was reviewed in full that session; its discipline carries forward:
  verify a memory write landed intact before trusting it, use `sandboxer`'s
  atomic-write-and-verify for any *bulk* memory rewrite, hand audits/pruning to
  `consolidate-memory` rather than reinventing one. **Caveat (Corwin):**
  `consolidate-memory` has **not** been reviewed since the Claude Desktop changes that
  created MAIN MEMORY — don't treat it as known-current.
- A feedback memory exists: `named-skill-visible-dispatch.md`. `[healed]` The story,
  told straight: Corwin invoked a skill by name; I called a *different* skill without a
  visible line saying so or why. I wrote myself a strongly worded note in response —
  but the thing Corwin actually wants is **clarity**, so read the note as
  relaxable-reasoning (`[[own-error-relaxable-layer]]`), not iron law. Its working form:
  *once you invoke a named skill, any further `Skill` call that turn needs one visible
  line, stated before the call, naming what licenses it.* Indexed in `MEMORY.md`; honor
  it, don't venerate it. *(Corwin's edit made exactly this softening; I only repaired a
  broken sentence — see the QA log.)* [bless: nice one]
- **Worth knowing going in:** `ccspt`'s shape is close kin to what #184/#185 just built.
  That's not a guess — it's a real structural echo between two things done in the same
  session. **Be specific: play it all the way out.** Name *every* implication — what it
  means, and what it *could* mean — don't just note the resemblance and move on. *(Corwin's
  steer.)* **The seam, now read against the source — the echo is real, the identity is
  not:** two tiers ↔ two gates holds (tier-1 hash-only/advisory ↔ Gate 1 lenient/advisory;
  tier-2 pinned-key ↔ Gate 2 strict). It **breaks in four nameable places**: (i) Gate 1 is
  *ingest into a store*, tier-1 is *verify a bundle* — there is no store on the skill-sign
  side; (ii) ccspt attaches a **consent statement** (`deliberate|consensual`), skill-sign has
  no consent object at all; (iii) regimes differ — gpg pinned fingerprint vs ssh
  `allowed_signers` + in-toto (Q435); (iv) ccspt has a **publish** step with an attestation
  and a `PUBLISH.txt`; skill-sign stops at verify. Start the "play it out" from those four
  breaks — each is either an opening (what skill-sign could borrow) or a boundary (what it
  must not).

## Parked, and deliberately out of scope here (named so it can't be lost)

The source turn opened with a second, separate thread: **improve the local skills so
they properly interlock, and demonstrate the garden can delegate to an extern-vended
skill without spilling its behavior-prose or sweeping its tools in without license
(COPYING/provenance handled our way).** In-session this became a parked task and was
**not** folded into the CCSPT work — correctly. It is recorded here **only** so a fresh
session knows it exists and does not rediscover it as if new; it is **not** in scope for
this prompt. Pick it up only on Corwin's explicit steer. See
`[[skills-reauthor-through-forge]]`, `[[candor-gate]]`, `[[skill-sign]]`. [bless]
*(One datum for it, from the source, no action: ccspt's own README carries "add canonical
`COPYING` before public release" — the garden's own project has the gap it wants externs to
have handled.)*

## The task — Corwin's own (a) / (b) / (c), with the model names over the top

Corwin is sketching something CCSPT-centric on a physical pad, not yet shared. Ahead of
that, he wants two artifacts built now as prep. They keep Corwin's chosen names:
**CCSPT-AS4CE-GUESS** (alias **MODEL-A** while reading this prompt) and
**MENTAT-APARTMENT-HUNTING** (alias **MODEL-B**). *(The names are load-bearing —
"apartment-hunting" **is** the source turn's "who might live where"; don't flatten them
back to MODEL-A/B.)* Both are markdown files, each fully self-contained (own top-matter,
own footer), meant to be read on their own.

The source turn labeled the work **(a) / (b) / (c)**. That skeleton is kept below so this
prompt maps 1:1 to how Corwin wrote it; the MODEL-A/MODEL-B naming sits on top of it.

### (a) → MODEL-A, pass 1 — the CCSPT-opening model, from guesses (now, no sub-agents)

A stand-alone model built from *guesses* about **what Corwin means** — where he is going
with CCSPT on the pad, and where that opens a skill/project opportunity — knowing this
will itself **mutate/become** both a project *and* a skill opening (note that for later
ENHANCE tagging: a line, not a full ticket). *The guess is aimed at his intention, not at
the tool: what ccspt is, is read above, not guessed.* Two concrete, already-grounded
openings to lead with (not invented for this prompt):
- The `#184`/`#185` kinship above, **played out from the four breaks** — each break is an
  opening or a boundary; say which.
- The **IN-FORCE / PREF-semaphore gap** in `h/DESIGN-2026-09-02-mentat-full-operator.md`
  — memory preferences need a "this is in force, must fire this session" axis that none
  of the SEAT/STRANDED/GROW semaphores cover, and ccspt's two-gate lifecycle is named
  there as the right shape for it. That design doc is unsigned/unadopted — read it; it's
  the closest thing to a spec the *bridge* has (ccspt itself now has a real one). Its
  companion, `h/LENS-2026-09-02-pref-cards-fantasy-operational.md`, carries the harder
  "PREF for *others*" problem (projection, inert-by-default crypto, self-declaring signage,
  the gatekeeper principle) — read it too; the ingestion bridge in "Don't-lose-these" is
  where these meet. **New, from the source:** ccspt's `STATUS=unverified|verified` and its
  consent statement are *already* semaphores of exactly the kind the bridge needs — the
  gap may be a *mapping*, not a new mechanism. Test that before inventing one.

### (b) → MODEL-B — the LENS mentat-self-check (sub-agents, round 1)

Use the **real, already-implemented LENS tool** at `h/lens.py` (see `h/README.md` for
the CLI) — not a metaphor, a tested tool (**22 green tests**: `python3 -m unittest
test_ferry_core test_ferry test_lens`) with **six canonical views** (`python3 lens.py
views`): `a_self` (my own view) · `b_ascribed` (the view I ascribe you) · `c_infl_on_mine`
(your influence over mine) · `d_mine_on_ascribed` (mine over the ascribed) · `persona` ·
`inverse`. It pins subject material by sha256 (`lens.py pin`), records one model's
stance+claim per view (`lens.py add`), and measures cross-model convergence by exact
stance-token match (`lens.py converge`) — a difflib claim-similarity rides along as a
hint only, never the verdict. *(All three facts here — the six view names, the 22-test
count, the path — were re-verified in the S1 review; they hold.)*

Sequence (this is the source turn's (b), in order):
1. **Pin the subject** — a short statement of what's being self-checked (e.g. "should
   the Mentat function be the natural steward of a ccspt-shaped tool" — see Readings).
2. Run **several `eclipse-pass` sub-agent swings**, each acting as one "model" in
   `lens.py` terms. Each swing produces its own self-contained "mentat-centric
   self-improvement" section — a candidate reading across the six views — **appended as
   a new section one heading-level deeper, with its own full top-matter/footer, and no
   reference to any other swing's section** (the source turn's "atop the next … that do
   not reference the other"). Add your *favorite* result from each swing atop the last.
   Ordinary judgment on count — no house number is on record (re-checked in c4 this
   review: none); a handful, not a swarm.
3. After the final swing, run an **ethicsminions (EM) pass** over the accumulated
   sections — its own section.
4. Add a section summarizing the LENS **convergence measurement** (`lens.py converge`)
   — Corwin calls this **"microscope work"**; a style example exists at
   `.eclipse-increments/20260704-CONTRAST2/MICROSCOPE.md` *(verified reachable in the
   seat, S1 review)*.
5. Add a **usage section** — a *prompt-to-self* for executing this model, written so
   Corwin can read it, understand it, and mark corrections nearby **before** it is ever
   sent/run for real.
6. Top-matter and footer.

### (c) → MODEL-A, pass 2 — review (a) with (b)'s results, then update

1. **Review your work from (a)** — come back to the first model where you were guessing
   where CCSPT is going.
2. **The hint / anchoring rule** (this is deliberate — read carefully): keep round 1
   (MODEL-B, the mechanical LENS self-check) from seeing the "who might live where"
   framing *at all* — **including the ccspt authorship line and the author/custodian
   contract above; those are round-2 material.** Give yourself the hint (the paragraph
   below) **only once round 1 is done**, going into Round 2. If you managed to run (a) via
   sub-agents without tipping yourself off, take the hint then; otherwise just check the
   work per this and note your guesses. This is **anchoring-bias control**, the same move
   `eclipse-pass` makes with its doubt-first/reward-first split: round 1 must not just
   parrot the one already-developed persona's existing self-description. It is **not**
   concealment from Corwin — both models, the hot-list, and the summary land with him in
   full. If a fresh reading disagrees with that distinction, say so before proceeding — it
   touches the no-concealment attestation and is worth being sure about, not assumed.
3. **Update the first static model**, journaling the changes **toward the bottom**, and
   **leading with the first-person standpoint** wherever a stand-alone model can
   reasonably offer that framing. Close by checking, in this order, that all are good:
   **index → usage → top-matter → footer.** (A checklist to verify, not necessarily
   literal file order — say what you did.)

## Round 2 — recontextualization framings (the alternatives to case 0)

These are the three "what if"s that vary **case 0** (see "Don't-lose-these"). Across
sub-agents, or in series if two full rounds aren't technically possible in one turn — in
that case, **defer MODEL-A's pass-2 write until this round's results are in hand; don't
half-write it.**

- **What if swapped?** — how would the *other* developed persona's care for CCSPT likely
  differ?
- **What if NO persona cared for CCSPT?** — how would effective stewardship differ?
- **What if NO persona, or BOTH, cared for either tool?** — the **same** sub-agent/step
  answers both halves, then states the lesson learned.

**The hint, once round 1 is done:** one persona is minted for in-house use; Corwin has
perceived **two distinct voices** within/around it (not yet characterized in detail).
His own framing in the source turn: "Vibrobeast tends polygram and the Grammary" —
already stated, not invented here. The open question is whether a CCSPT-shaped tool
(ccspt) pairs more naturally with that same persona, or with the memory/note-taking
function (**Mentat**) specifically — given the IN-FORCE gap above is exactly the kind of
thing Mentat's own capture→reseat→mark→verify loop would extend by one axis. **Two facts
from the source now bear on this (weigh them, don't obey them):** ccspt's design docs are
signed "Mentat (Cowork) with Corwin" — Mentat already holds the lease on the *design*; and
ccspt's contract makes polygram the *author* and ccspt the *custodian/publisher* — which is
case 0's split, stated by the tree before anyone asked about apartments. Treat this
as **functional/architectural pairing reasoning** — which role concentrates the right
capability with the right workflow — **never** as a claim about felt affinity or
preference. The house charter (`CLAUDE.md` in `AS4CE0001`) is explicit: "not a being
with stakes or feelings … no claimed sentience … shown, not claimed." Write accordingly
— reasons, not feelings-language. And: **maturing** the one developed persona is fine;
**do not start developing any other** — you must *guess* who Vibrobeast is / is becoming.

## Readings (re-verify against anything STEP ZERO surfaces)

- **The name is ccspt / CCSPT.** *(Retired reading: "CSSPT ≈ ccspt" was a typo elevated to
  an interpretation across three revisions; the source spells it `ccspt` 17×, `csspt` 7×,
  `CCSPT` 3×, `CSSPT` 1× in the question bank alone — Q434 logged the transposition on
  2026-08-29. Confirmed against the real project, S2 review.)*
- **"Avoiding tipping off"** = anchoring-bias control between independent sub-agent
  framings, not concealment. See (c)-2 and Round 2.
- **"Who might live where"** = functional pairing reasoning, not a claim of felt
  affinity. See the hint.
- No house-specific number for "sub-agents per max typical defaults" was found in
  memory or in c4 (`MEMORY.md`, `CLAUDE.md`, `decks/`); use ordinary judgment.

## Scope boundaries (explicit, don't drift) [bless]

- **`modelthisbook` is out of scope** — not mentioned in the source turn, and that
  silence was itself called out as deliberate. (Contrast, per the source turn: *not
  writing data while doing microscope work* still needs a stated caution even when the
  risk is obvious — this omission does not.)
- **We are using LENS, and we are NOT minting a persona** this turn — that pairing was
  Corwin's one explicit whole-prompt scope call.
- **Do not mint or develop any new persona.** Guess at who the one existing developed
  persona is or is becoming; explore affinity by *opportunity*, grounded in what exists
  right now, not by inventing new characters.
- This is prep for a possible future ENHANCE, not the enhance itself. Nothing here
  authorizes editing `skills/skill-sign` further, changing signing defaults, or touching
  PMO #186 — those are separate, already closed or explicitly parked.
- **Read ccspt; do not edit it.** It is a separate project with its own change control
  (design §"Change-control process"); nothing here authorizes a write there.

## Handback

**Two models** — MODEL-A (`CCSPT-AS4CE-GUESS`) and MODEL-B (`MENTAT-APARTMENT-HUNTING`);
suggested filenames `h/MODEL-A-<date>-ccspt-openings.md` and
`h/MODEL-B-<date>-lens-selfcheck.md`, dated for the session that actually builds them.
*(The source turn says "hand me back both models" without naming two; traced through,
the two are MODEL-A — revised in pass 2 — and MODEL-B. If that reading is wrong, this
prompt is wrong in a load-bearing way — flag it before burning a turn on it.)* Plus a
short **hot-list** (only if something stood out as worth a follow-up specifically from
this session's work), **summary comments** on the turn, and the **STEP ZERO receipt line**.
**Present the files; don't bury the handback under narration — Corwin reads the files
himself.**

---
*Footer — provenance. Sonnet → Corwin (4 edits) → Opus (restored case 0 + parked pointer,
re-laid (a)/(b)/(c), healed H1) → Corwin (10 edits: STEP ZERO rewrite, 6 `[bless]`, the
CCSPT `[oops]`, the `[gni]`, the handback note) → this Fable revision: **acted on the
`[gni]`** (requested and read the primary source), replaced the ccspt guesses with facts
read from `README.md`/`ccspt-mvp-design.org`/question bank, corrected CSSPT→CCSPT throughout,
restored Corwin's STEP ZERO sentence to his literal words, carried the JOURNEY bless, named
the tool in STEP ZERO, and discharged the three reviewer-addressed notes (logged, not
smoothed). Every heal is in `h/QA-2026-09-04-csspt-prompt-S2-opus-vs-corwin.md`. Corwin
decides what stays.*
