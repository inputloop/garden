---
# ENHANCE — 2026-10-10 — double coverage by depth overlap, back toward the garden
His words (2026-10-10, s1c session): "I like the idea of double coverage by depth overlap. I'd like
to model that out with a soft skill in mind. We should base ENHANCE back toward the garden
generally, and then review after testing were we found opportunities to setup such tests."
New beside this note: `SOFT-SKILLS/depth-overlap/SKILL.md` (PROVISIONAL). First test case:
inputloop/s1c `tests/DEPTHS.md` (commit cited there). Nothing below is applied; take or strike.
C4 tree not connected this session: the same bytes are owed to `c4/h/` at the next carry-in.
---

## Where it came from

The s1c suite grew one kit per feature, each in a new language (eleven by 2026-10-10). Asked whether
that was "competing kits" or an over-claim, the answer was: independent, yes; competing only where
two kits check the same promise, which was true in one place (the netcode). He took the idea of
double coverage at different depths, and the toolchain cost as social value: each language a seat
for someone whose interest is that language's testing, invited with "great idea, do you want to take
over design of that bit?".

## What the first test case showed (s1c, three planted faults, receipts in tests/DEPTHS.md)

| plant (each on a copy) | kits claiming the promise | fired | survived |
|---|---|---|---|
| F1 the 3D ground's tops 3 px low | PHP (geometry vs the game's log), Rust (pictures), Emacs Lisp (pictures, round trip) | PHP | Rust, Emacs Lisp |
| F2 a netplay snapshot forgets the planes' block word | netsim-test (in process), TestNet.java (real UDP) | none (a probe: 1,558 frames flagged; its control 0) | both |
| F3 exported texture coordinates 64 px off | Emacs Lisp (pictures through the loader), PHP (OBJ geometry) | Emacs Lisp | PHP (its promise is geometry) |

Two of three plants found a promise the suite only looked layered on: F1 is single-covered by the PHP
kit, and F2 passes both netcode kits because they share one observer, the C checksum of work RAM,
which cannot see presentation state. Three plants is a small sample; he asked to see results in
detail before assuming what they tell us, so this note proposes, it does not conclude.

## Items

### 1. grand-test-manifest: say what "written apart" means for GRAND (ENHANCE)

GRAND owes "two logic checks written apart". Proposed: under each `logic-1:` / `logic-2:` slot, two
more lines,

```
     depth: STRUCTURE | STATE | BEHAVIOUR | OUTPUT | TRANSPORT | OUTSIDE (or the work's own name)
     observer: <the code or reference that turns what happened into a verdict>
```

and the rule: for GRAND, the two logic checks name different observers; where the promise spans
layers, different depths too, and one plant sits in the layer between them. Observed reason: F2,
where two checks written apart, in two languages, over two transports, shared one observer and were
blind together.

### 2. grand-test-manifest: a reading for a pair, not a new STATE word (ENHANCE, small)

No new STATE word. The join already reads BLIND for a surviving plant. Proposed: the depth-overlap
map's words (DOUBLE, SAME-DEPTH, SINGLE, UNCOVERED) stay in depth-overlap and are never pasted into
STATE, so STATE stays derived from receipts alone.

### 3. ngen: one cross-reference line (ENHANCE, one line)

ngen proves two means agree at one depth (same bytes out). depth-overlap asks for two depths. They
compose: an ngen pair is one row's worth of agreement; a second depth is another row. Proposed line
for ngen's body: "Agreement at one depth; for a second depth on the same promise, see
depth-overlap."

### 4. SEATS as a writing form (NEW form, C4 side)

A SEATS list beside a depth map: seat, kit, depths, what it owns, open questions, the invitation
line, and no person named until they say yes. Proposed as a row in `c/wf` (C4) so writing-forms finds
it. First instance: s1c `tests/DEPTHS.md` § Seats.

### 5. skilltank: nothing to change

A promise a plant shows BLIND is grand-test-manifest's T2 receipt already; skilltank's RAISE route
covers it. Listed so the next reader does not look for a missing item.

## Questions banked for his ruling (not asked; question-economy: one at a time when they come up)

- Q-a The working name depth-overlap: keep, or his name for it.
- Q-b The six depth names, or fewer (STRUCTURE, STATE, BEHAVIOUR, OUTPUT, TRANSPORT, OUTSIDE).
- Q-c Is the observer rule part of "written apart" (item 1), or a separate GRAND slot.
- Q-d Where SEATS lives for a project: beside its depth map (s1c tests/DEPTHS.md), or a garden-wide
  register of seats across projects.

## Receipts

All commands and counts: inputloop/s1c `tests/DEPTHS.md` § Plants. The soft skill's falsifiers are
in its SKILL.md; the first of them (every DOUBLE row cites a plant or says OPEN) is held by the s1c
map as written.

## His answers, 2026-10-10 13:11 (verbatim)

- Q-a The working name depth-overlap: keep, or his name for it. [KEEP]
- Q-b The six depth names, or fewer (STRUCTURE, STATE, BEHAVIOUR, OUTPUT, TRANSPORT, OUTSIDE). [REVISE I have been modeling as sets of four along lens/dipolar thinking, contrasting pairs that can show tension as to unsigned number lines joined at zero, where values for either can be added to give an overall distract away from zero in either direction. Given a consistent measure for each this may predict influence in the terms given, enabling change over series -such as time- to convey pressures as two such number lines set perpendicular. In the case of DEPTH I would set this first GRAIN as UNIVERSE/GRAIN and CONTAIN/LAYER, swapping around forms (e.g. gerund) typically in opposing pairs to represent frame of reference to for a fact consistently across both directions away from zero along a given line and either consistently or diametrically considering the line pairs; this can then be applied to itself using words that relate to the "end-point" words or that typify extremes to make four new corner, generally joining one degree of seperation each away from a mutual concept the line top and focused new lens edge/corner word can each be used to usefully describe (including quantify, qualify, or contexualize where these form meaningful frame of reference that can be applied evenly to a given fact/question applied to each of the four line number parts away from the four zero balance point center of the given LENS GRAPH]
- Q-c Is the observer rule part of "written apart" (item 1), or a separate GRAND slot. [separate layer, merge/plaid: if that isn't workable then item 1]
- Q-d Where SEATS lives for a project: beside its depth map (s1c tests/DEPTHS.md), or a garden-wide  register of seats across projects. [two reader, both doubling linking each other and/or other context/meaning bearing referents and constituents: the project's lab notes or model or persona log or similar one which is within the garden where our extension unpacks/builds, the other may be (a) universal in lab and tagged/grouped by project, or by project, or by session for example as a more or less transient preference, taking what we find in this order so that overriding rules about where to find hat must be tidied and not simply shadowed, leaving the default option to get quickly to done being to branch/fork the seat, so we should make joining/merging or maintaining slowing diverging or eventually concurrent versions of the seat as routine and simple as we can, or (b) a SEAT file, effectively a bespoke to purpose@user character sheet FORM]

Folded into `SOFT-SKILLS/depth-overlap/SKILL.md` the same day (the provisional draft is kept in
`SOFT-SKILLS/_archive-2026-10-10/depth-overlap/`). Item 1 above now reads: the observer is its own
layer, crossed with the depths like a plaid; item 1's two extra lines stay as the fallback.
