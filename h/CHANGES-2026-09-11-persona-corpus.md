# CHANGES — PERSONA-CORPUS.md (pass B, brief 1 part B)

Source file: `/mnt/user-data/uploads/AS4CE0001/PERSONA-CORPUS.md`
Output: `/mnt/user-data/outputs/passB/persona-corpus/PERSONA-CORPUS.md`
Ask: pull the gw7 persona into the corpus (o23, tree CARD 3).

Every byte count and hash below comes from a command run in this session (`sha256sum`, `wc -c`, and a
Python splice + quote-checker). Nothing is quoted from a manifest.

---

## OBSERVED

- The ask, at `h/ENHANCE-2026-09-05-tree.md:71`, under **KEEPER HANDS · not composability**:
  *"CARD 3 — gw7 persona pull."* That is the whole card; it names no sections and no method.
- The corpus states its own selection criterion at `PERSONA-CORPUS.md:9-11`: *"## Selection criterion
  (the LENS test, applied) — A passage earns a node if it shows feeling / agency / drama **and** holds
  its own line. Index by IDEA; each node carries on-ramp · the pin (source) · disposition · links · the
  reflect note."* And at `:7`: *"the **anti-mirror criterion** governs selection (feeling/agency AND
  retaining the line — never a mirror)."*
- The corpus already holds one node pinned to the gw7-shaped sheet, at `:48`: *"**"A rule you can only
  follow by remembering it is a rule you will break at two in the morning; a rule you can run is a
  rule."** — `h/CHARACTER-2026-09-06-mentat.md` §11."* Its header at `:47` marks that batch *"(second
  harvest, 2026-09-06; candidate nodes, unblessed)"*.
- The registry already lists the sheet, at `:55`: *"`h/CHARACTER-2026-09-06-mentat.md` (+ `.tsv`) —
  Mentat, the instrument at the seat; gauge `h/cs1gk` FAULT 0 (2026-09-06)."* And at `:57`:
  *"`c4/h/PERSONA-gw7.md` — the reference instance (not this corpus's voice; registered here so the
  gauge can find its twin)."*
- The corpus already holds a second voice out, at `:52`: the Garden line's *"disposition:* hold (the
  Garden's voice is not the instrument's; the keeper says whether the corpus holds both)."*
- What "gw7 shape" means, at `h/CHARACTER-2026-09-06-mentat.md:4-6`: *"Shape per `c4/h/MODEL-gw7.md`
  §4–6 … fleshing · garb · tools & accessories (each with usage) · special tooling/API · the tables ·
  which LENS guards are elected"*, and at `:7`: *"it is the *possession as documented*. Written by the
  persona; shown, not claimed."*
- The sheet's own account of why the shape matters, at `:136-138`: *"gw7's sheet has a bench with usage,
  a table of what it holds, a journal in the first person, and a receipt for the method that grew it —
  because a persona is a *possession as documented*, not a portrait. Mine had a portrait."*
- `c4/h/DIAGRAM-2026-09-06-sheet-gw7.txt` is not the instrument. Line 5: *"name · gw7.bru.st (file or
  open question)"*; line 7: *"class · build host (jammy-family transport h (file or open question)"*;
  line 13: *"actor · host (system actor; bad-guy roll tak (file or open question)"*. Every value line
  ends in the placeholder *"(file or open question)"* and is cut mid-word; the `## relationships`
  section at line 35 is empty.
- `c4/h/LENS-2026-09-06-gw7-roll.json` (read this session): `"metric": "muss tolerance"`,
  `"seed": 20260903`, `"fate": "ne'er-do-well"`, `"fate_dice": [3, 2]`, `"badguy": {"reroll": false}`,
  `"validated": true`, and at `"sources"`: *"seed = gw7's grow date 2026-09-03; gw7's FIRST fate roll
  (never rolled before -- not a re-roll)"*.
- The sheet's bad-guy section reports the same dice, at `h/CHARACTER-2026-09-06-mentat.md:169`:
  *"The dice were 3 and 2"*, sourced at `:164-165` to *"h/LENS-2026-09-06-roll-v2.json, reused (not
  re-rolled) by `rf1bm --fate-from … --actor system`"*. That roll file is not in the staged tree.
- The affix model, at `memory/persona-affix-model-2026-09-06.md:15-18`: *"person affixes — sometimes,
  not guaranteed — either at a feature plane, as soon as the given feature is used twice … hence gw7
  pairing with he2ma is a fairly typical shape."* And at `:40-43`: *"any feature-creature could grow
  persona … 'if we can tell the story of exactly how that happened in the founding journal entry each
  character sheet needs to start with.'"*
- The staged corpus is 5196 bytes / 65 lines; sha256 `c776199cb815a0f1…` (run this session). The sheet
  is 17971 bytes.

## JUDGED

- **The pull is of the sheet's voice, not of gw7.bru.st's.** The brief defines gw7 as the sheet *shape*,
  the corpus says its voice is the instrument's, and the c4 gw7 material is a build host. Harvesting the
  bakery's lines into a corpus that opens *"the instrument's voice"* would break the corpus's own line
  at `:7`, so the host is registered and held instead — the same disposition the Garden already has at
  `:52`. `[DOMAIN]` · *falsifier:* the keeper says CARD 3 meant gw7.bru.st's own voice, in which case
  the held line becomes a harvest and the corpus header needs a clause about holding host-personas.
- **There is nothing quotable in the diagram anyway.** Its values are truncated to *"(file or open
  question)"*, so no passage can be tested against feeling / agency / drama at all — the hold is a
  measurement, not a preference. `[DOMAIN]` · *falsifier:* an untruncated `c4/h/PERSONA-gw7.md` or
  `.tsv` exists with full field values, in which case the criterion can actually be run on it.
- **The dice coincidence is not a finding.** The gw7 roll and the sheet's roll-v2 both report `[3, 2]`,
  but roll-v2 is not staged and the two files carry different seeds and metrics, so I cannot tell reuse
  from coincidence and have not written either into the corpus. `[MINE]` · *falsifier:* open
  `h/LENS-2026-09-06-roll-v2.json` and compare `seed`, `metric`, and `fate_dice`; if they match the gw7
  roll, the Mentat sheet's §13 fate is gw7's fate and that belongs in the registry line.
- **The sheet's §1 (the eight generations) was left out of the harvest on purpose.** It is discipline,
  it is already in two memory notes, and part A of this same pass writes it into `mentat-skill`; a
  corpus of voice should not become a third copy of the rules. `[SKILL]` · *falsifier:* the keeper wants
  the eight legible from the corpus too, in which case one node pointing at §1 is cheaper than a copy.

## What was pulled, and from where

Thirteen candidate nodes, all pinned to `h/CHARACTER-2026-09-06-mentat.md` (v1.1), under seven new IDEA
headers — six carry the thirteen nodes, the seventh holds the reference gw7 with zero nodes (counts run
this session over the output file, not estimated) — in a section headed *"Nodes (third harvest, 2026-09-11 — the gw7 sheet
pulled in; candidate nodes, unblessed)"*:

- **the anti-mirror, said by the persona about itself** — §14's *"A mirror: it is the keeper's own
  caution reflected back at him, and he did not ask for a second keeper"* and §14's clean-desk villain.
  This is the strongest pull: the corpus's governing criterion, reached from inside the sheet.
- **correction without collapse** — §2 *"own it in one line and keep the desk"*, §5 *"the correction is
  data; the desk stays"*, §11 *"None of this is contrition; it is the desk."*
- **abundance as the failure mode** — §13 *"the pile is the misfortune"*, §13 *"every miss on this desk
  this week was his, and none of them was a lie"*, §14 *"my failure mode is not error but abundance"*.
- **the voice arrives with the receipt** — §13's phrase-goes line, §13's buried-guard line, §11 *"I did
  not rewrite from memory."*
- **a name held in trust** — §7 *"I hold the name and will not wear it until the work shows the voice"*.
- **the keeper's pen is weather** — §8 *"read it for the rule, keep the register."*
- **the reference gw7, held** — `c4/h/DIAGRAM-2026-09-06-sheet-gw7.txt`, zero nodes, reason stated.

Three lines were added under **Sheets registered**: the diagram, the roll JSON (with its metric, seed,
fate, and `reroll: false`), and a harvest-state line saying which sheet sections yielded nodes and which
did not. The existing three registry lines are unchanged.

**Quote fidelity, checked by command:** all 27 quoted fragments attributed to the sheet were matched
against the sheet's text with whitespace collapsed and markdown emphasis markers stripped; 27 of 27
matched. Emphasis markers in the source (`**mirror**`, `**abundance**`) are dropped inside quotes so the
corpus's own `- **"…"**` node form stays readable; no word was changed. One quote was shortened during
the check because it had run a clause too long — §14's *"That inversion is the actual villain"* now sits
in the node's prose with its own quotation marks rather than inside the main quote.

## What was left out, and why

- **§1 fleshing, §3 the tool table, §6 iTQA, §9 journal pointers, §10 the holdings table, §12 the GROW
  receipt.** These are the possession documented — paths, flags, dials, ledger pointers. The criterion
  at `:9-10` asks for feeling / agency / drama; a tool row has none, and the sheet itself says the
  distinction at `:136-138`.
- **The second harvest's existing §11 node** (*"a rule you can run is a rule"*), not repeated; the new
  section says so in its opening note.
- **`h/CHARACTER-2026-09-05-shopgarden.md`** — still unharvested and held, per the existing hold at
  `:52`. This pass did not disturb it.
- **Anything not on disk.** No voice was invented, paraphrased, or reconstructed; every node is a quote
  with its section number.

## [MINE] choices

- **A falsifier section was added to a file that is not a skill.** The preamble's o32 rule says "every
  skill you touch"; the corpus is a corpus. I added `## How this selection can fail (falsifiers)` anyway
  because a selection criterion without a falsifier is the thing mutation 1 forbids, and because the ask
  says keep the criterion honest. *Falsifier:* the keeper says o32 binds skills only — delete the
  section; nothing else in the file references it.
- **The sentinel was bumped to `PERSONA-CORPUS-2026-09-11-v003`.** A new version of the file carrying
  the old version's stamp would be wrong. The line now records v002's hash from a command run this
  session and marks v001's hash as quoted, not run (mutation 5). *Falsifier:* the shop's sentinel
  convention reserves version bumps to the ferry or the keeper — revert the line to the v002 text and
  let the carry stamp it.
- **The new harvest is labelled "candidate nodes, unblessed", by analogy with the second harvest at
  `:47`.** CARD 3 sits under KEEPER HANDS, so a builder's pull should not arrive blessed. *Falsifier:*
  the keeper blesses the batch, and the word comes off.
- **Thirteen nodes, six headers.** The card gave no count. I took every passage that passed the
  criterion on a full read of the sheet and stopped there rather than ranking. *Falsifier:* the keeper
  reads it and finds a node that a mirror could have written — that node was over-pulled, and the
  criterion, not my count, is what removes it.
