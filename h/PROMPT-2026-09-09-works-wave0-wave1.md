# PROMPT — works programme, WAVE 0 + WAVE 1 kick-off (2026-09-09)

Landed 2026-09-09 by the Vibrobeast-arm session (`[claude.ai link removed at egress]`)
for repeatability. §A is Corwin's original, verbatim — a quote. §B is the revised kick-off to paste.
§C lists every change and why. Method file: `h/MODEL-2026-09-09-the-ladder-and-the-works.md`.
The same paste is meant to run in more than one Cowork project; the ARM tag keeps runs from
overwriting each other. Ledger tool shape verified against `bin/ot3he` on 2026-09-09.

---

## A · Original (his, verbatim, 2026-09-09)

> Run WAVE 0 and WAVE 1 of the works programme. Method:
> c4/h/MODEL-2026-09-09-the-ladder-and-the-works.md — read it first, follow §4. Perspectives are the
> register c/p (columns d/c/p); the ladder is c/ladder. Run the two Wave-0 deflators FIRST and report
> if either cancels a wave. Mounts: F:\claude\c4. Write dispatch rows to o/tr via ot3he add before
> running. Hand back the collection, then what the deflators found.

---

## B · Revised kick-off — paste this

Run WAVE 0 and WAVE 1 of the works programme. Method: `c4/h/MODEL-2026-09-09-the-ladder-and-the-works.md` — read it first; follow §4 (order), §5 (voice), §6 (budget), §7 (minions wrap). Perspectives are the register `c/p` (columns `d/c/p`); the ladder is `c/ladder`. Mounts: `F:\claude\c4`.

**ARM** = the Cowork project this session runs in, lowercased (e.g. `vibrobeast`, `c4`). Put it in every filename and every ledger NOTE below — this prompt runs in more than one project and runs must never overwrite each other.

**PRE-FLIGHT** (before any agent; report each line as OK / FIXED / MISS):
1. `test -f h/MODEL-2026-09-09-the-ladder-and-the-works.md && wc -l < c/p` — expect 8.
2. `c/ladder` names `h/MODEL-2026-09-09-the-ladder.md`, which does not exist. Fix in place to `h/MODEL-2026-09-09-the-ladder-and-the-works.md` (one `sed -i`); print sha256 of `c/ladder` before and after.
3. If `h/PROMPT-2026-09-09-works-wave0-wave1.md` is absent, write this prompt there verbatim.

**LEDGER.** One row per agent dispatch, written BEFORE it runs:
`sh bin/ot3he add KIND "ACT" local-c4 SUP "PREDICT" CITE "arm=ARM wave=N"` — KIND ∈ build|admin|advise; SUP ∈ watched|advise|unsupervised; CITE ∈ cite|hold, and `hold` for anything that touches third-party, family or SAVANNAH material. Fill OUTCOME/SCORED after the run by editing the row; never at add time.

**WAVE 0 — the two deflators, FIRST.** One sonnet agent each, primary sources only (PREMIS Data Dictionary and OAIS/ISO 14721 for the archivist; state fair-hearing rules and administrative-procedure practice for the caseworker). Every claim quotes its source with URL and retrieval date; a claim without a fetched source is marked *quoted, not run*. Verdict per deflator: DEFLATES / PARTIAL / HOLDS, plus which wave it changes. Land at `h/WAVE0-<UTC stamp>-<archivist|caseworker>-ARM.md`, with the agent's brief verbatim beside it as `…-brief.md`. Score the Wave 0 rows, then report whether either deflator cancels a wave BEFORE dispatching Wave 1.

**WAVE 1 — rung 1 collection:** trades (#3) and apprentice (#7). Collection means REAL material with provenance, or nothing: each item carries `SOURCE:` (URL or tree path), `DATE:`, and a CITE decision. Anything synthetic is labelled SYNTHETIC in filename and frontmatter and may never be cited as evidence by a later wave. Real sources that exist: the programme's own ledger `o/tr`; his operational record where its CITE allows (SAVANNAH rows are `hold` — keeper decides); public right-to-repair testimony and forum threads; his tracked eev self-teaching path as the apprentice's record. Persona named in frontmatter per §5; CORWIN.md influence declared. Each work carries OPPORTUNITY and BAD OUTCOME lines, specific and unflattering to us (§7). Land at `h/WAVE1-<UTC stamp>-<trades|apprentice>-ARM.md` + `…-brief.md`. Check: `grep -L '^SOURCE:' h/WAVE1-*-ARM.md` must print nothing.

**BUDGET.** At most 9 agents this session (GREAT); one wave in flight at a time; stop and hand back if the session passes ~1.5M tokens.

**HAND BACK,** in this order: the collection; what the deflators found; the ledger rows added (`sh bin/ot3he --held`); anything NOT READY, stated as such — that is correct output, not failure.

---

## C · Changes introduced (Vibrobeast arm, 2026-09-09) — each with its reason

1. **ARM tag in filenames and ledger NOTE.** The prompt is meant to run in two projects; without it the second run overwrites the first, against *date every measurement, never overwrite one*.
2. **PRE-FLIGHT, three lines.** (1) proves the method and register are present; (2) repairs `c/ladder`'s dangling second pointer (found 2026-09-09: `test -f h/MODEL-2026-09-09-the-ladder.md` → MISS) at kick-off, with before/after hashes, so the fix is dated and reversible; (3) makes the prompt file itself — the launch prompt of the prior session was never on disk.
3. **Exact `ot3he add` shape and the enum values,** read from `bin/ot3he` (KIND / SUPERVISION / CITE are validated and refuse otherwise; CITE is never defaulted). The original said "via ot3he add" without the shape; a refused add would have left the dispatch un-rowed, which is how the 2026-09-09 fan-out went un-rowed.
4. **Wave 0 sourcing rule** — primary sources, URL + retrieval date, *quoted, not run* for anything unfetched; DEFLATES/PARTIAL/HOLDS verdict naming the wave it changes. §4 names the deflators; it does not say what counts as an answer.
5. **Wave 0 scored before Wave 1 dispatches** — the original said "report if either cancels"; this makes the sequencing mechanical (one wave in flight, §6).
6. **Wave 1 provenance rule** — the largest change. §4 says rung-1 work is *"real verbatim captures, real logs — not argument."* A dispatched agent cannot collect real HVAC-shop or apprentice logs; asked to "collect", it will synthesize, and synthetic material at rung 1 becomes the evidence every later wave cites — the programme's own "record becomes the alibi" failure, at its foundation. So: SOURCE/DATE/CITE on every item, SYNTHETIC labelled and non-citable, and the real sources that do exist named. Check is one `grep -L`.
7. **Briefs land beside outputs.** The eight perspective briefs from the 2026-09-09 fan-out are not on disk, so MODEL §8(c) (trace convergence to shared brief wording) cannot be run. From this kick-off on, every brief is saved verbatim beside its output.
8. **Landing paths** — `h/WAVE0-…`, `h/WAVE1-…`, UTC stamp + ARM, following the `h/DISS-…` / `h/REVIEW-…` precedent. The original named no landing place.
9. **Budget ceiling** — 9 agents (GREAT), one wave in flight, ~1.5M-token stop. §6 has the numbers; the prompt now carries the stop.
10. **§5 and §7 named explicitly** (persona in frontmatter, CORWIN.md influence declared, OPPORTUNITY/BAD OUTCOME lines). The original pointed at §4 only.
11. **Hand-back order** extended with the ledger rows and an explicit NOT READY slot — the runner's duty (§4) says "not ready" is correct output; the prompt now has somewhere to put it.

Not changed: the two waves asked for, the method file, the registers, the mount, the deflators-first rule, the collection-then-deflators hand-back.
