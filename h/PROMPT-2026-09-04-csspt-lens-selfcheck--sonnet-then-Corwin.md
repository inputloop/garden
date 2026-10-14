---
# PROMPT — CSSPT-opening model + LENS mentat-self-check
Carried forward from a session on 2026-09-04 (Vibrobeast/Cowork). Paste this whole file
as the opening message of a fresh session. It is written to stand alone — no other
context from that prior session is assumed.
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
3. If they are **not** reachable: you must request these before beginning; Corwin cannot grant you access to the primary materials unless you ask for them.  If you cannot do this stop and simply explain that you do not know how to ask for access to mount an additional typically used cowork folder such as those mentioned above.  Each contains required reading for this work.

This check is not optional and not a formality — a prior session got exactly this
wrong once already (see `[[named-skill-visible-dispatch]]`-style miss, different
flavor: assuming rather than checking). Naming it here is the fix.

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
  `consolidate-memory` rather than reinventing one.  Consolidate memory has not been 
  reviewed since the changes to Claude Desktop leading to creation of MAIN MEMORY.
- A feedback memory exists: `named-skill-visible-dispatch.md` — Corwin
  invoked a skill by name and I called a different one without explaining, so I wrote this strongly worded note to myself; Corwin mostly wants clarity. Meanwhile, I decided
  that any further `Skill` call that turn needed one visible line,
  stated before the call, naming which line licenses it and immediately indexed in
  `MEMORY.md` then stated as fact the only options is to honor it going forward.
- **Worth knowing going in:** `ccspt`'s shape (manifest + signature, receipt vs.
  publish, consent bound to a payload hash — see below) is close kin to what #184/#185
  just built. That's not a guess — it's a real structural echo between two things done
  in the same session, worth leading with rather than burying.  Be specific.  If there are implications name every single one, playing it out: what does it mean? what *could* it mean?

## The task, restated cleanly

Corwin is sketching something CSSPT-centric on a physical pad, not yet shared. Ahead
of that, he wants two artifacts built now as prep — call them **CCSPT-AS4CE-GUESS** (or
"MODEL-A" for the purposes of reading this prompt) and **MENTAT-APARTMENT-HUNTING** (or
"MODEL-B" for the purposes of reading this prompt). Both are markdown files, each fully
self-contained (own top-matter, own footer), meant to be read on their own.

### MODEL-A — the CSSPT-opening model (built in two passes)

**Pass 1 (now, no sub-agents needed):** a stand-alone model built from *guesses* about
what CSSPT is and where it opens a skill/project opportunity. Working guess (see
"Readings" below): CSSPT ≈ **ccspt**, the consent-&-provenance project at
`F:\claude\projects\ccspt` (AGPL, stdlib, reuses `ssh-keygen`) — a two-gate lifecycle,
`receipt (lenient, advisory) → publish (strict, re-hashed, attested)`, consent bound to
the payload's sha256. Two concrete, already-grounded openings to lead with (not
invented for this prompt):
- The `#184`/`#185` kinship above — `.skill-manifest` + `.signature.asc`, tiered
  verify, hash-bound provenance is structurally the same shape ccspt already has a
  name for.
- The **IN-FORCE / PREF-semaphore gap** in `h/DESIGN-2026-09-02-mentat-full-operator.md`
  — memory preferences need a "this is in force, must fire this session" axis that
  none of the SEAT/STRANDED/GROW semaphores cover, and ccspt's two-gate lifecycle is
  named there as the right shape for it. That design doc is unsigned/unadopted — read
  it, it's the closest thing to a spec CSSPT already has.

Note *every* opening found for later ENHANCE tagging (a line, not a full ticket) —
this is prep, not the enhance itself.

**Pass 2 (after MODEL-B, step below):** revise MODEL-A in light of MODEL-B's results
and the three recontextualization framings. Journal the changes at the bottom of the
file, **leading with first-person standpoint wherever a stand-alone model can
reasonably offer that framing**. Close by checking four things are all still good:
the index, the usage section, the top-matter, the footer. (Read that as a checklist to
verify, not necessarily literal file order — top-matter conventionally opens a
document; use judgment and say what you did.)

### MODEL-B — the LENS mentat-self-check model

Built via sub-agents, round 1. Use the **real, already-implemented LENS tool** at
`h/lens.py` (see `h/README.md` for the full CLI) — this is not a metaphor, it's a
tested tool (22 green tests: `python3 -m unittest test_ferry_core test_ferry
test_lens`) with six canonical views (`python3 lens.py views`):
`a_self` (my own view) · `b_ascribed` (the view I ascribe you) · `c_infl_on_mine`
(your influence over mine) · `d_mine_on_ascribed` (mine over the ascribed) ·
`persona` · `inverse`. It pins subject material by sha256 (`lens.py pin`), records
one model's stance+claim per view (`lens.py add`), and measures cross-model
convergence by exact stance-token match (`lens.py converge`) — a difflib
claim-similarity rides along as a hint only, never the verdict.

Sequence:
1. Pin the subject — a short statement of what's being self-checked (e.g. "should the
   Mentat function be the natural steward of a ccspt-shaped tool" — see Readings).
2. Run **several `eclipse-pass` sub-agent swings**, each acting as one "model" in
   `lens.py` terms: each swing produces its own self-contained "mentat-centric
   self-improvement" section — a candidate reading across the six views — appended to
   MODEL-B as a new section **one heading-level deeper, with its own full
   top-matter/footer, and no reference to any other swing's section.** Ordinary
   judgment on count — no house-specific number is on record; a handful, not a swarm.
3. After the final swing, run an **ethicsminions (EM) pass** over the accumulated
   sections — its own section.
4. Add a section summarizing the LENS **convergence measurement** (`lens.py
   converge`) — Corwin calls this "microscope work"; there's house precedent for that
   name and register at `.eclipse-increments/20260704-CONTRAST2/MICROSCOPE.md` if a
   style example is useful.
5. Add a **usage section** — a prompt-to-self for actually executing this model,
   written so Corwin can read it, understand it, and mark corrections nearby *before*
   it's ever sent/run for real.
6. Top-matter and footer.

## Round 2 — recontextualization (informs MODEL-A's pass 2)

Across sub-agents (or in series if two full rounds aren't technically possible in one
turn — in that case, defer MODEL-A's pass 2 write until this round's results are in
hand, don't half-write it):

- **What if swapped?** — how would the *other* developed persona's care for CSSPT
  likely differ?
- **What if NO persona cared for CSSPT?** — how would effective stewardship differ?
- **What if NO persona, or BOTH, cared for either tool?** — same question, same
  sub-agent/step answers both halves, then states the lesson learned.

**Sequencing note (read carefully, this is deliberate):** keep round 1 (MODEL-B, the
mechanical LENS self-check) from seeing the "who might live where" framing at all —
give yourself that hint (the paragraph below) only once round 1 is done, going into
round 2. This is **anchoring-bias control**, the same move `eclipse-pass` already
makes with its doubt-first/reward-first split and convergence check: round 1
shouldn't just parrot back the one already-developed persona's existing
self-description. It is **not** concealment from Corwin — both models, the hot-list,
and the summary land with him regardless, in full. If a fresh reading of this
disagrees with that distinction, say so before proceeding — it touches the
no-concealment attestation and is worth being sure about, not assumed.

**The hint, once round 1 is done:** one persona is minted for in-house use; Corwin has
perceived two distinct voices within/around it (not yet characterized in detail). His
own framing in the source prompt: "Vibrobeast tends polygram and the Grammary" —
already stated, not invented here. The open question is whether a CSSPT-shaped tool
(ccspt) pairs more naturally with that same persona, or with the memory/note-taking
function (Mentat) specifically, given the IN-FORCE gap above is exactly the kind of
thing Mentat's own capture→reseat→mark→verify loop would extend by one axis. Treat
this as **functional/architectural pairing reasoning** — which role concentrates the
right capability with the right workflow — never as a claim about felt affinity or
preference. The house charter (`CLAUDE.md` in `AS4CE0001`) is explicit: "not a being
with stakes or feelings... no claimed sentience... shown, not claimed." Write
accordingly — reasons, not feelings-language.

## Readings (mine, approved by Corwin 2026-09-04 — re-verify against anything new
STEP ZERO surfaces)

- **CSSPT ≈ ccspt**, per `mentat-full-operator.md` and `skills-reauthor-through-forge.md`
  in `AS4CE0001/memory/`. Not confirmed against the real project — see STEP ZERO.
- **"Avoiding tipping off"** = anchoring-bias control between independent sub-agent
  framings, not concealment. See the sequencing note above.
- **"Who might live where"** = functional pairing reasoning, not a claim of felt
  affinity. See the hint paragraph above.
- No house-specific number for "sub-agents per max typical defaults" was found in
  memory; use ordinary judgment.

## Scope boundaries (explicit, don't drift)

- **`modelthisbook` is out of scope** — not mentioned in the source prompt, and that
  silence was itself called out as deliberate (contrast: not writing data while using
  microscope work needs a stated caution even when the risk is obvious; this omission
  doesn't).
- **Do not mint or develop any new persona.** Guess at who the one existing developed
  persona is or is becoming; explore affinity by *opportunity*, grounded in what
  exists right now, not by inventing new characters.
- This is prep for a possible future ENHANCE, not the enhance itself. Nothing here
  authorizes editing `skills/skill-sign` further, changing signing defaults, or
  touching PMO #186 — those are separate, already closed or explicitly parked.

## Handback

Two files (MODEL-A, MODEL-B — suggested names `h/MODEL-A-<date>-csspt-openings.md`
and `h/MODEL-B-<date>-lens-selfcheck.md`, dated for the session that actually builds
them), plus a short hot-list (if anything stood out as worth a follow-up specifically
from this session's work) and summary comments/thoughts on the turn. Present the
files; don't bury the two-models handback under a wall of narration — Corwin reads
the files himself.
