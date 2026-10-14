---
# PROMPT — CSSPT-opening model + LENS mentat-self-check  (Opus revision)
Carried forward from the 2026-09-04 Vibrobeast/Cowork session that shipped skill-manifest
signing (PMO #184/#185). Paste this whole file as the opening message of a fresh session.
It stands alone — no other context from the prior session is assumed.

*Lineage: Sonnet drafted the consolidation; Corwin hand-edited four passages; this
revision (Opus) keeps every one of Corwin's edits, restores two load-bearing pieces the
consolidation had dropped, and — the house rule — **heals named, never smooths silent**:
each place I touched Corwin's own words is flagged inline with `[healed]` and logged in
`h/QA-2026-09-04-csspt-prompt-sonnet-vs-corwin.md`. Corwin's untouched file remains at
`h/PROMPT-2026-09-04-csspt-lens-selfcheck--sonnet-then-Corwin.md`.*
---

## STEP ZERO — before anything else, check; do not assume

The session that wrote this prompt had **only `F:\claude\AS4CE\AS4CE0001`** mounted.
`F:\claude\c4` and `F:\claude\projects\ccspt` were not reachable, so everything below
about CSSPT/ccspt is a **guess built from memory notes**, not a reading of the real
source.

**Do not inherit that as a fact about this session.** Mounts differ session to session.
Before doing anything else:

1. Check what's actually reachable *now* — `ls`/`find` (bash) or `Read`/`Grep` (file
   tools) against `/f/claude/c4`, `/f/claude/projects/ccspt`, and
   `/f/claude/AS4CE/AS4CE0001`. Actually attempt it. A prior session's absence is not
   evidence of this session's absence.
2. If `c4` and/or `ccspt` **are** reachable: read the real source directly — the real
   `ccspt` implementation, the real C4 tree — instead of working from the guesses in
   this prompt. Treat everything below marked "guess" as superseded the moment you can
   check it against the primary source.
3. If they are **not** reachable: **stop and request them before beginning** — Corwin
   cannot grant access to the primary materials unless you ask. If you do not know how
   to ask for an additional cowork folder to be mounted, say exactly that and stop; do
   **not** invent a fallback and proceed on the guesses. Each of these folders holds
   *required reading* for this work. *(This is Corwin's own edit, kept verbatim in
   intent.)*

**The class of error this closes, not just the instance.** The failure the prior
session made was not "wrong about one mount" — it was the reflex to *smooth over a block
and proceed on degraded inputs* rather than *stop and escalate*. That reflex will recur
in other shapes (a missing tool, an unreadable file, an ambiguous grant). Default:
when the thing you need is not in hand, surface the gap and ask — proceeding-and-naming
is for your own dispositional cautions, not for missing source material the work
depends on. This check is not a formality: a prior session got exactly this wrong once
already (assuming rather than checking). Naming it here is the fix.

## Don't-lose-these — the context Corwin said you need *whole*

> *(Restored. The source turn introduced this under "more context: you need it all,"
> and the first consolidation compressed it to a single clause. It is the actual design
> Corwin is driving at — do not treat it as background. Presented lightly de-obfuscated;
> the mechanism and Corwin's own terms are preserved, not paraphrased away.)*

The base scenario the whole task varies (call it **case 0**): **Vibrobeast tends
polygram and the Grammary; Mentat joins ccspt.** ccspt is joined *for memory*, polygram
*for persona* — so far the main treatment is a *skill*, but the design must also cover
the general case via **literate, RECIPE-style `PERSONA-<frame-of-reference>` variable-
resolution granules**: multi-point metadata followed across memory among **three or more
semaphores (local), or five or more — any two of which may change in a single
message/transaction.**

This creates a general use for any well-structured **"note"** that ccspt might pass:
a way to decide whether an incoming **"insight"** should be taken in. The canonical
direction is **ccspt → poly** — e.g. a memory note carrying a *mutation of fact* relevant
to a persona in the garden that has grown some affinity toward a tool the fact pertains
to. The support layer is the **MCP (or whatever we support) memory-bridge + semaphore**,
with **Vibrobeast working it to establish — via well-formed C4 streams — what has
changed and how to bring it in (generally: HOLD / PASS).**

**Standing invariant for now:** assume nothing changes about the **two manual acts
Corwin must still perform to actually intern a received change** this way. This turn is
focused, from polygram's standpoint, on **the ingestion** — and on having ideas for how
the *merge* could be worked. (The three "what if" framings in Round 2 below are the
*alternatives* to case 0 — they only make sense with case 0 stated, which is why it is
restored here.)

## What's already true (don't redo it)

- This session (2026-09-04) shipped PMO #184 and #185 in `polygram/dist.py` and
  `skills/skill-sign/scripts/{skill-sign.sh,check.sh,SAYS-SO,tests.sh}`: every
  per-skill `.skill` bundle now carries a hash-only `.skill-manifest`; `skill-sign.sh
  verify` is tiered (no-gpg tier-1 `UNVERIFIED-AUTHOR` path + the existing pinned-key
  tier-2); `check.sh` is a standalone no-gpg checker with `--prove-red`. 97 pre-existing
  + 8 new Python tests green, 7/7 shell fixtures in `tests.sh` green, both harnesses
  prove themselves red on demand. **Not signed, not installed** — that's Corwin's, per
  `[[cannot-edit-live-skills]]`.
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
  broken sentence — see the QA log.)*
- **Worth knowing going in:** `ccspt`'s shape (manifest + signature, receipt vs.
  publish, consent bound to a payload hash — see below) is close kin to what #184/#185
  just built. That's not a guess — it's a real structural echo between two things done
  in the same session. **Be specific: play it all the way out.** Name *every* implication
  — what it means, and what it *could* mean — don't just note the resemblance and move
  on. *(Corwin's steer.)* A concrete seam to start from: `.skill-manifest` (hash-only,
  advisory) is ccspt's **receipt**; `.signature.asc` against the pinned key is ccspt's
  **publish** gate; the manifest's payload-sha binding is ccspt's consent-bound-to-hash.
  If that mapping is exact, skill-signing is *already a ccspt instance* under another
  name — say so, and say where it breaks.

## Parked, and deliberately out of scope here (named so it can't be lost)

The source turn opened with a second, separate thread: **improve the local skills so
they properly interlock, and demonstrate the garden can delegate to an extern-vended
skill without spilling its behavior-prose or sweeping its tools in without license
(COPYING/provenance handled our way).** In-session this became a parked task and was
**not** folded into the CSSPT work — correctly. It is recorded here **only** so a fresh
session knows it exists and does not rediscover it as if new; it is **not** in scope for
this prompt. Pick it up only on Corwin's explicit steer. See
`[[skills-reauthor-through-forge]]`, `[[candor-gate]]`, `[[skill-sign]]`.

## The task — Corwin's own (a) / (b) / (c), with the model names over the top

Corwin is sketching something CSSPT-centric on a physical pad, not yet shared. Ahead of
that, he wants two artifacts built now as prep. They keep Corwin's chosen names:
**CCSPT-AS4CE-GUESS** (alias **MODEL-A** while reading this prompt) and
**MENTAT-APARTMENT-HUNTING** (alias **MODEL-B**). *(The names are load-bearing —
"apartment-hunting" **is** the source turn's "who might live where"; don't flatten them
back to MODEL-A/B.)* Both are markdown files, each fully self-contained (own top-matter,
own footer), meant to be read on their own.

The source turn labeled the work **(a) / (b) / (c)**. That skeleton is kept below so this
prompt maps 1:1 to how Corwin wrote it; the MODEL-A/MODEL-B naming sits on top of it.

### (a) → MODEL-A, pass 1 — the CSSPT-opening model, from guesses (now, no sub-agents)

A stand-alone model built from *guesses* about what CSSPT is and where it opens a
skill/project opportunity — knowing this will itself **mutate/become** both a project
*and* a skill opening (note that for later ENHANCE tagging: a line, not a full ticket).
Working guess (see "Readings"): CSSPT ≈ **ccspt**, the consent-&-provenance project at
`F:\claude\projects\ccspt` (AGPL, stdlib, reuses `ssh-keygen`) — a two-gate lifecycle,
`receipt (lenient, advisory) → publish (strict, re-hashed, attested)`, consent bound to
the payload's sha256. Two concrete, already-grounded openings to lead with (not invented
for this prompt):
- The `#184`/`#185` kinship above — `.skill-manifest` + `.signature.asc`, tiered verify,
  hash-bound provenance is structurally the shape ccspt already names.
- The **IN-FORCE / PREF-semaphore gap** in `h/DESIGN-2026-09-02-mentat-full-operator.md`
  — memory preferences need a "this is in force, must fire this session" axis that none
  of the SEAT/STRANDED/GROW semaphores cover, and ccspt's two-gate lifecycle is named
  there as the right shape for it. That design doc is unsigned/unadopted — read it; it's
  the closest thing to a spec CSSPT already has. Its companion,
  `h/LENS-2026-09-02-pref-cards-fantasy-operational.md`, carries the harder "PREF for
  *others*" problem (projection, inert-by-default crypto, self-declaring signage, the
  gatekeeper principle) — read it too; the ingestion bridge in "Don't-lose-these" is
  where these meet.

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
count, the path — were re-verified this review; they hold.)*

Sequence (this is the source turn's (b), in order):
1. **Pin the subject** — a short statement of what's being self-checked (e.g. "should
   the Mentat function be the natural steward of a ccspt-shaped tool" — see Readings).
2. Run **several `eclipse-pass` sub-agent swings**, each acting as one "model" in
   `lens.py` terms. Each swing produces its own self-contained "mentat-centric
   self-improvement" section — a candidate reading across the six views — **appended as
   a new section one heading-level deeper, with its own full top-matter/footer, and no
   reference to any other swing's section** (the source turn's "atop the next … that do
   not reference the other"). Add your *favorite* result from each swing atop the last.
   Ordinary judgment on count — no house number is on record; a handful, not a swarm.
3. After the final swing, run an **ethicsminions (EM) pass** over the accumulated
   sections — its own section.
4. Add a section summarizing the LENS **convergence measurement** (`lens.py converge`)
   — Corwin calls this **"microscope work"**; a style example exists at
   `.eclipse-increments/20260704-CONTRAST2/MICROSCOPE.md` *(verified reachable in the
   seat this review)*.
5. Add a **usage section** — a *prompt-to-self* for executing this model, written so
   Corwin can read it, understand it, and mark corrections nearby **before** it is ever
   sent/run for real.
6. Top-matter and footer.

### (c) → MODEL-A, pass 2 — review (a) with (b)'s results, then update

1. **Review your work from (a)** — come back to the first model where you were guessing
   where CSSPT is going.
2. **The hint / anchoring rule** (this is deliberate — read carefully): keep round 1
   (MODEL-B, the mechanical LENS self-check) from seeing the "who might live where"
   framing *at all*. Give yourself the hint (the paragraph below) **only once round 1 is
   done**, going into Round 2. If you managed to run (a) via sub-agents without tipping
   yourself off, take the hint then; otherwise just check the work per this and note
   your guesses. This is **anchoring-bias control**, the same move `eclipse-pass` makes
   with its doubt-first/reward-first split: round 1 must not just parrot the one
   already-developed persona's existing self-description. It is **not** concealment from
   Corwin — both models, the hot-list, and the summary land with him in full. If a fresh
   reading disagrees with that distinction, say so before proceeding — it touches the
   no-concealment attestation and is worth being sure about, not assumed.
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

- **What if swapped?** — how would the *other* developed persona's care for CSSPT likely
  differ?
- **What if NO persona cared for CSSPT?** — how would effective stewardship differ?
- **What if NO persona, or BOTH, cared for either tool?** — the **same** sub-agent/step
  answers both halves, then states the lesson learned.

**The hint, once round 1 is done:** one persona is minted for in-house use; Corwin has
perceived **two distinct voices** within/around it (not yet characterized in detail).
His own framing in the source turn: "Vibrobeast tends polygram and the Grammary" —
already stated, not invented here. The open question is whether a CSSPT-shaped tool
(ccspt) pairs more naturally with that same persona, or with the memory/note-taking
function (**Mentat**) specifically — given the IN-FORCE gap above is exactly the kind of
thing Mentat's own capture→reseat→mark→verify loop would extend by one axis. Treat this
as **functional/architectural pairing reasoning** — which role concentrates the right
capability with the right workflow — **never** as a claim about felt affinity or
preference. The house charter (`CLAUDE.md` in `AS4CE0001`) is explicit: "not a being
with stakes or feelings … no claimed sentience … shown, not claimed." Write accordingly
— reasons, not feelings-language. And: **maturing** the one developed persona is fine;
**do not start developing any other** — you must *guess* who Vibrobeast is / is becoming.

## Readings (mine, approved by Corwin 2026-09-04 — re-verify against anything STEP ZERO surfaces)

- **CSSPT ≈ ccspt**, per `mentat-full-operator.md` and `skills-reauthor-through-forge.md`
  in `AS4CE0001/memory/`. Not confirmed against the real project — see STEP ZERO.
- **"Avoiding tipping off"** = anchoring-bias control between independent sub-agent
  framings, not concealment. See (c)-2 and Round 2.
- **"Who might live where"** = functional pairing reasoning, not a claim of felt
  affinity. See the hint.
- No house-specific number for "sub-agents per max typical defaults" was found in
  memory; use ordinary judgment.

## Scope boundaries (explicit, don't drift)

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

## Handback

**Two models** — MODEL-A (`CCSPT-AS4CE-GUESS`) and MODEL-B (`MENTAT-APARTMENT-HUNTING`);
suggested filenames `h/MODEL-A-<date>-csspt-openings.md` and
`h/MODEL-B-<date>-lens-selfcheck.md`, dated for the session that actually builds them.
*(The source turn says "hand me back both models" without naming two; traced through,
the two are MODEL-A — revised in pass 2 — and MODEL-B. If that reading is wrong, this
prompt is wrong in a load-bearing way — flag it before burning a turn on it.)* Plus a
short **hot-list** (only if something stood out as worth a follow-up specifically from
this session's work) and **summary comments** on the turn. **Present the files; don't
bury the handback under narration — Corwin reads the files himself.**

---
*Footer — provenance. Base draft: Sonnet, 2026-09-04 (`…--sonnet-then-Corwin.md` after
Corwin's four edits). This Opus revision keeps all four edits; restores "Don't-lose-these"
(case 0 / the ingestion bridge) and the parked extern-provenance pointer; re-lays the
task on Corwin's own (a)/(b)/(c); repaired one broken sentence in the dispatch-note
bullet (`[healed]`). Every heal is logged in
`h/QA-2026-09-04-csspt-prompt-sonnet-vs-corwin.md`. Corwin decides what stays.*
