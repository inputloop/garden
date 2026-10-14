# CHANGES — sandboxer (pass A, brief 3, 2026-09-11)

Output: `SKILL.md` (full file; 23,006 B → 30,686 B). No other file touched.
A `.asc` beside the live copy does not freeze it (his 2026-09-10 norm): the edit is made, written
down here, and handed back for a re-sign.

---

## OBSERVED — what the sources say

**The ask.**
- `brief-3-sandboxer-skilltank.md:38-40` — "add a section `## Memory stores — what a session can
  and cannot reach` carrying the six fingerprints from §6, each with its receipt (command or
  file:line) and its date, in the same voice as the existing Fingerprints section."
- `h/ENHANCE-2026-09-05-tree.md:93-94` — "**Q14 ENHANCE `sandboxer` — a memory-stores section**
  (tier P; forge). Six fingerprints, each receipted tonight, in
  `h/MODEL-2026-09-05-memory-situation.md` §6."

**The six fingerprints, quoted from `h/MODEL-2026-09-05-memory-situation.md` §6 (line 105:
"Fingerprints to add, each a sentence, each receipted tonight").**
1. `:106-107` — "A is **not a mount**: bash sees nothing of it; the file tool does;
   `request_cowork_directory` refuses it by policy — never `ls` for it, never say it's absent."
   Receipt at `:12` (§1 table, row A): "`ls /mnt/.claude` → `projects skills`" and
   "`request_cowork_directory` refuses the path ("inside Claude's own application data")".
2. `:108-109` — "Seat `MEMORY.md` **append denied while mode reads rwx** → say "locked from this
   reader", card the host line, never retry." Scope measured at `:30-32` (§1b): "**98 of 156**
   seat notes refuse the append from the sandbox; the split is exact"; and "Only
   `AS4CE0001/memory/` is fenced, and only for notes this session did not create."
3. `:110-111` — "`rm` refused → **never create a probe** (I did tonight: `.probe-2` is on the
   card)." Receipt at `:13`: "`rm .probe-2` → Operation not permitted"; card at `:164`.
4. `:112` — "`mv` onto an existing file fails ("unable to remove target") — `cp` overwrites in
   place." Also `h/ENHANCE-2026-09-05-tree.md:46`: "*New fingerprint tonight, for Q4:* `mv` onto
   an existing file fails on the mount".
5. `:113-114` — "A note written by the file tool comes back with a harness `modified:` stamp —
   **A and seat copies never byte-match after a Write**." Platform receipt at `:55`: "the harness
   stamps `modified:` into frontmatter on write (why A and seat copies never byte-match after a
   Write — expected, not drift)". Instrument receipt: `memory/memory-situation-2026-09-05.md:8`,
   `seat_copy: "copied, re-written from the same source text; A's frontmatter carries the harness
   timestamp"`.
6. `:115-116` — "The session transcript is at `/mnt/.claude/projects/<…>/<session>.jsonl` — the
   reader for out-of-bounds audits (Q7)." Receipt at `:14`: "`find .claude/projects -maxdepth 3`".

**The canary, `MODEL…:117`** — "Canary for all of the above: `bin/ms1dg --seat <seat>` — run it
before claiming anything about memory." Test state from the same file's header `:3-4`: "32/32,
`--prove-red` PASS".

**The seventh, receipted this turn.** `brief-3-sandboxer-skilltank.md:40-44` — "eleven seat notes
under `AS4CE0001/memory/` dated 2026-09-01..04 are read-only on the Windows host (the bridge
reports `saveBackBlocked: read_only`) while the Linux mount shows them `rwx` … so a refused write
to a seat note is a host mode bit, not a lock, and the fix is the keeper's `attrib -r` /
`chmod u+w`, never a retry loop."

**What was already in the file (checked so as not to duplicate, per `brief:34`).** The existing
`## Fingerprints — dated, each with its receipt` section (`SKILL.md:357-389` in the original)
already carries two of the six in general form:
- `:362-365` — "**2026-09-04 · `rm` is refused on both AS4CE mounts** … **never create probe
  files** on a mount."
- `:366-370` — "**2026-09-04 · a host-side lock reads as a mode-bit refusal** … `AS4CE0001/memory/
  MEMORY.md` still refusing append 2026-09-11 while a sibling note appends fine."
It does **not** carry the `mv`-onto-existing line, store A's invisibility, the harness stamp, or
the transcript path.

**Supporting notes named in the brief, and what each actually gave.**
- `memory/memory-stores-map.md:13-16` — the A/B/C/D map ("A — Cowork auto-memory … B — AS4CE0001
  hub … C — SAVANNAH enclave … D — DEFRAG old-home"). Used for the section's opening paragraph.
- `memory/account-memory-store-D.md:12` — "**D = account/cloud memory** (Settings→Memory) — rich,
  structured … but **NOT consumed by local Cowork**"; `:15` — "**CARE:** store D holds family …
  **not persisted here**". Used for the one line on D in the opening paragraph.
- `memory/main-memory-seat.md:11` — "this project (AS4CE0001 / Vibrobeast) is the seat of local
  memory — MAIN MEMORY". Background for "the seat"; no new fingerprint.
- `memory/mount-stale-size-reads.md:16,18` — the rename dance and the TREE-VERIFY corollary. Both
  are **already** in the skill's read-side section; nothing added from it.
- `memory/main-memory-desync.md:11` — "**Standing project rule — Corwin, 2026-09-01** … do NOT
  rush the keeper to wear a new skill." Despite its name this note is about *pacing*, not a memory
  desync, and contributed nothing to the section. Flagged so the next reader does not go looking
  for a fingerprint in it.

---

## JUDGED — the edits made, and why

1. **Added `## Memory stores — what a session can and cannot reach`** (new `SKILL.md:391-455`),
   after `## Fingerprints` and before `## Relationship to Mentat`. Opening paragraph names the
   four stores and the reader-seam; then the six fingerprints as dated bullets in the Fingerprints
   voice (bold dated lead, the rule, the receipt); then the seventh (2026-09-11); then the canary
   as a closing paragraph rather than a bullet, because it is an instruction, not a measurement.
   [SKILL]
2. **Did not duplicate the two overlapping fingerprints.** The `rm` bullet says "The general
   refusal is the 2026-09-04 fingerprint above" and adds only the store-specific consequence (the
   probe created two unremovable strays). The fence bullet says "This is the *host-side lock reads
   as a mode-bit refusal* fingerprint above with its scope measured" and adds only §1b's numbers.
   [SKILL]
3. **Extended `description:`** with one clause on memory-store reach and three triggers ("why
   can't I write this memory note", "is the memory locked", "which memory is this"). Permitted by
   the preamble because the ask changes *when* the skill applies — a memory-write refusal is now
   in scope. `name:` untouched. [SKILL]
4. **Added `## How this skill can fail (falsifiers)`** at the end (`:466-493`): four concrete
   checks (a stale fingerprint, firing where there is no mount, a BAD off one reader, a repair of
   something unbroken) plus the off-switch. The skill had no equivalent section, so this is new,
   not an amendment. The brief asked specifically for a "this fingerprint is stale when…" line;
   that is the first bullet, written as a re-measure instruction because the section's own rule
   (`:359-360`) is "never delete one". [SKILL]

### [MINE] choices — none of these blocks; each has its falsifier

- **[MINE] Placement: the new section sits after Fingerprints, not inside it.** The six are
  about *which store a reader can reach*, not about *how the mount misbehaves*, and burying them
  in a flat list would lose the store map that makes them legible. Falsifier: he says the
  fingerprint list should stay the single home for dated facts — then fold the seven bullets in
  and keep only the opening paragraph as its own section.
- **[MINE] Store D is one line in the opening paragraph, not a seventh fingerprint.** §6 names
  six; D is reach-relevant but was not on that list. Falsifier: he asks for D as its own dated
  bullet with the Settings-panel receipt.
- **[MINE] The 2026-09-11 host read-only bullet is written as *narrowing* the §1b fence guess, not
  replacing it** ("the cheapest explanation for the previous bullet"). The model's own guess is
  tagged `[MINE ~65%]` at `MODEL…:37`, so neither is settled. Falsifier: CARD 7's host run
  (`MODEL…:166`) reads 0 fenced on the host *while* those eleven files are still read-only — then
  the fence and the mode bit are two separate faults and the bullets must be decoupled.
- **[MINE] The description clause is 40 words and adds three triggers.** Falsifier: the skill
  starts firing on ordinary small memory-note writes, which `:26-27` explicitly excludes — then
  cut the triggers back to "is the memory locked".
- **[MINE] Added the missing blank line before `## Relationship to Mentat`.** In the original the
  heading sat flush against the last fingerprint bullet (`:389-390`), which renders the heading
  inside the list. Falsifier: it was deliberate — revert one newline.

### Concerns

- **[DOMAIN] The fence numbers are one night's measurement from one reader.** "98 of 156" and
  "eleven notes" are both single-reader counts, and this skill's own rule is that one reader is
  not proof. Written into the section as receipts with dates rather than as standing facts.
  Falsifier that dissolves it: the CARD 7 host run agrees, or re-measures them.
- **[PLATFORM] `bin/ms1dg` is referenced as the canary but does not ship with this skill.** The
  section says `sh bin/ms1dg --seat <seat>` with no path resolution; if the tool moves to
  `c4/bin/` (its stated destination, `memory/memory-situation-2026-09-05.md:17`) the line goes
  stale. Falsifier: the canary command runs from a fresh session's working directory as written.
- **[MINE] I could not re-run any of the six receipts from here.** The staged uploads are a
  read-only copy; `/mnt/.claude`, the seat mount and the bridge are not reachable in this
  sandbox. Every fingerprint is transcribed with its source line, not re-measured. Falsifier: run
  the receipts on the host and diff the answers against the section.
