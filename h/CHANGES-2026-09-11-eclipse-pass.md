# CHANGES — eclipse-pass (pass A, brief 4: the reflection family) · 2026-09-11 · builder: fable

Ask carried by `/home/claude/work/passA/brief-4-eclipse-family.md` (o34 + o35 + the eclipse part of o37;
o32 = the falsifier rule). The o-numbers are not present anywhere in the staged tree
(`grep -rn 'o3[2-7]' /mnt/user-data/uploads/AS4CE0001` → nothing), so the brief is cited as their carrier.

## Files written

- `/mnt/user-data/outputs/passA/eclipse-pass/SKILL.md` — full new file. Purely additive: 58 lines added,
  0 removed (`diff` against the staged original). Frontmatter `name:` and `description:` unchanged.
- `/mnt/user-data/outputs/passA/eclipse-pass/scripts/eclipse_pass.sh` — full new file. One `echo` line added
  after the header (line 61); no other change.
- `/mnt/user-data/outputs/passA/eclipse-pass/CHANGES.md` — this file.

Not touched: the five moves (SKILL.md:69–97), the script's behaviour (verified below), the `.asc` question
(his 2026-09-10 norm per the preamble: edit, write it down, tell him, he re-signs).

## Change 1 — new section `## The reflection family — where this pass sits` (SKILL.md:37–67)

Source: brief line 47–53, item 1: "Add a section `## The reflection family — where this pass sits` that
names the four ...". Direction: `memory/reflection-family-drift.md:13`.

OBSERVED
- `memory/reflection-family-drift.md:13`: "Enhance eclipse/microscope to mention the LENS and be clear that
  'reflection' is a *family*: wider techniques (the LENS — nearly all contexts) and narrower ones
  (eclipse-pass — debugger-on critique of one target). Eclipse is a narrow reflection; the LENS is the wide one."
- `memory/lens-microscope-bubble-chamber.md:13–17` (his words, 2026-09-07, in the note's quote block): "The
  important point is to have the tool name and framing of the microscope as a scaling aparatus that reaches
  bubble chamber when we think of several AI working together over wire. Lens is the common baseline that
  works very nicely for humans as a general thought experiment. Several of the notes shared tonight are me
  using the Lens just that way and writing down my notes ..."
- `memory/lens-microscope-bubble-chamber.md:19`: "The rung is chosen by how much reasoning you can still
  observe, not by taste." — this line sits OUTSIDE the quote block in the note.
- `memory/lens-microscope-bubble-chamber.md:21–27`: the three rungs — LENS "one human. You can hold the whole
  thing; turn it by hand. Nothing needs capturing because nothing is being lost yet." · MICROSCOPE "one mind is
  no longer enough magnification. Strip the assumptions, keep only what survives with no trust in the scorer.
  Keep-the-WINNERS." · BUBBLE CHAMBER "several AI, over a wire, each stateless and flushing at session end. The
  reasoning is gone before you can look at it, so you observe the track, not the particle. That is why
  [[bubble-chamber-method]] is capture-first."
- `memory/lens-microscope-bubble-chamber.md:29–30`: "Microscope is not a rung you stand on — it is what carries
  you between them. That is the whole of 'scaling apparatus.'"
- `memory/lens-microscope-bubble-chamber.md:32–34`: "keep-the-winners (microscope) and keep-the-losers (eclipse)
  stopped being rivals the moment they were seen as living on different rungs. Both are needed; the installed
  `eclipse-pass` skill carries only the second, and that gap is real and owed."

JUDGED
- The section names all four rungs, quotes his two 2026-09-07 sentences verbatim, states the microscope gap
  as "real and owed" in his words, and gives the rung rule. [HIS] for the quoted sentences and the gap.
- [HIS→MINE, 1 line] The rung rule ("by how much reasoning you can still observe, not by taste") is outside the
  quote block in the note, so it is his rule as recorded by the instrument, not a verbatim quote. The brief
  calls it "his rule"; the skill says "His rule for choosing". Falsifier: he says the phrasing is not his.
- [MINE] His quote is kept with the spelling on file ("aparatus"); I did not silently correct a quote.
  Falsifier: he asks for it cleaned; then fix it in the quote and say so.
- [MINE] Placement: after "When this applies", before "The five moves" — the family section becomes the bridge
  from "a critique is wanted" to "which rung". Falsifier: he or the runner prefers it before "When this
  applies" (so the rung rule informs the trigger); a move is a cut-and-paste with no wording change.
- [MINE] The closing two sentences of the section ("If you can still hold every claim ... capture first") are
  my plain-words expansion of the rung rule, drawn from :21–27. Falsifier: he reads them as adding a rule
  he did not give; then cut them to the one bold sentence.
- [MINE] The bubble-chamber pointer cites `lens-microscope-bubble-chamber` (which I read) rather than
  `bubble-chamber-method` (referenced at :27 but not in the staged tree). Falsifier: `bubble-chamber-method`
  exists in his live memory; then the pointer may be swapped.
- [MINE] `description:` left unchanged: the trigger phrases and the "when" do not change; the section adds
  siblings, not triggers. Falsifier: skilltank reads "pick the rung by observability" as a change to when the
  skill applies; then extend `description:` by one clause.

## Change 2 — LENS content held as unconfirmed (SKILL.md:49–51)

Source: brief line 54–56, item 2: "do NOT codify the four-step reading ... as his. You may mention it in one
sentence as 'the instrument's unconfirmed reading, see memory lens-discipline'".

OBSERVED
- `memory/lens-discipline.md:11`: "CANDIDATE — my reading of Corwin's 2026-09-01 'LENS', pending his confirm
  (do not cite as settled)."
- `memory/lens-microscope-bubble-chamber.md:44–47`: "STANDING CAUTION. [[lens-discipline]] is still marked
  CANDIDATE ... Tonight confirms LENS's role (the human baseline) and that he uses it. It does not confirm my
  four-step reading of its content (four views apart · persona-plus-inverse · principles reframe ·
  notes-or-stop). Those four remain unconfirmed and must not be cited as his."

JUDGED
- One parenthetical sentence, naming the reading as the instrument's and unconfirmed, pointing at
  `lens-discipline`. The four steps themselves are not named in the skill. [HIS] The falsifier stays as on
  file: he has not confirmed the four steps.
- [SKILL] Concern, out of this brief's scope but seen while sourcing: `h/lens.py:4–6` states the four-step
  reading as settled ("The LENS is the reflection discipline (making-vibrobeast .md, section 1): four views
  held apart, then persona and its inverse, then reframe each point from principles, then notes ..."), which
  the memory caution forbids. Falsifier: he confirms the four steps (then lens.py is right and the caution
  lifts); or lens.py's docstring gains a CANDIDATE mark. Not edited here; named for the runner.

## Change 3 — "Drift, eventual" paragraph under "After the pass" (SKILL.md:134–140)

Source: brief line 57–60, item 3: "a reflection pass is legitimate self-directed drift spend and should be
logged as such; note that the ethicsminions `drift` guard is currently SKIPPED for want of an `--expect`
attestations file, so the coupling is named, not wired. Keep it to what is on file."

OBSERVED
- `memory/reflection-family-drift.md:14`: "Couple to Drift — 'eventual, so far': running a wider/narrower
  reflection pass is legitimate self-directed drift spend, logged. Concrete hook found live: the ethicsminions
  `drift` guard is currently SKIPPED (no `--expect` attestations file) — coupling reflection↔drift could feed it."
- `skills/ethicsminions/scripts/check_principles.py:74–75`: `def g_drift(mem, expect): if not expect: return
  ("SKIP","no --expect attestations file given (drift check skipped).")`
- `skills/ethicsminions/references/attestations.txt:1` and `:8–9`: "Attested principle lines — the minions drift
  check (--expect this file)." ... "Run: python3 scripts/check_principles.py --memory WORKSPACE --skills
  WORKSPACE/skills --expect skills/ethicsminions/references/attestations.txt".

JUDGED
- Written as: drift spend, log it; the guard reports SKIP unless `--expect` is passed; found SKIPPED live
  2026-09-01; coupling named, not wired. [HIS] for the direction.
- [DOMAIN] Nuance kept out of the skill to stay "to what is on file": an attestations file DOES exist in the
  staged tree (`references/attestations.txt`), so "for want of a file" is more exactly "for want of the flag
  being passed at run time". The skill says "unless `check_principles.py` is given an `--expect` attestations
  file", which is true under both readings. Falsifier: run `check_principles.py ... --expect
  skills/ethicsminions/references/attestations.txt` on his tree and see the drift guard leave SKIP.
- Nothing was wired (no `--expect` plumbing, no log format invented); brief says named, not wired.

## Change 4 — script: one header line (scripts/eclipse_pass.sh:61)

Source: brief line 61–62, item 4: "Do not touch the five moves or the script's behaviour. If the script prints
a header naming the ritual, you may add one line naming the family; otherwise leave it."

OBSERVED
- `scripts/eclipse_pass.sh:60` (original): `echo "eclipse-pass — target: $TARGET"` — the header names the ritual.

JUDGED
- [MINE] The optional line was exercised: one `echo` naming the four rungs and this pass's place, directly
  after line 60. Falsifier: the runner or he prefers the script untouched (fewer re-signs); drop the line
  and ship only SKILL.md — nothing else depends on it.
- Verification, run in the sandbox scratchpad against four dummy candidate dirs:
  `sh -n` OK · dry run old vs new: `diff` shows exactly the one added line · `--apply` old vs new: exit 0
  both, scaffold files structurally identical (pass.md section 4 "Debugger ON — keep the losers" present
  at pass.md:25 in both; the only diff was the project pick, see the [PLATFORM] concern below).

## Change 5 — falsifier section (SKILL.md:142–158)

Source: preamble line 18–23 (o32, his rule 2026-09-11: "add falsifiers for each skill as we take a next turn
with it") and brief line 63–64, item 5: "eclipse-pass already keeps losers — its falsifier is e.g. 'if the
losers were not written down, the verdict is untrustworthy: check the pass file for a losers section'".

OBSERVED
- No section headed "How this skill can fail" existed. The nearest equivalent is one bullet,
  `SKILL.md:126–127` (unchanged position): "The verdict is only trustworthy if the losers were kept — check
  `.eclipse-increments/` actually has the contrast, not just the winner."
- `scripts/eclipse_pass.sh:103–105`: the scaffold's losers section is `## 4. Debugger ON — keep the losers`.

JUDGED
- Added the section (four checks + one off-switch line). The existing "After the pass" bullet was left in
  place (no reorganising); the new first falsifier points at the concrete file section (`pass.md` §4) rather
  than restating the bullet. Said here as the preamble asks: the bullet and the section overlap on the
  losers check by design; the bullet stays because it is in the flow of the ritual.
- The four checks: losers section empty · seed does not reproduce the pick · only one bias filled · the
  target could be held in one head (wrong rung; should not have fired). Each is a thing you can look at.
- [MINE] Off-switch wording: "debugger off" (already in the skill, move 4) to discard losers; "no eclipse,
  just a lens" to skip the ritual; removing the skill directory stops the triggers. Falsifier: he wants a
  different phrase; it is one line.

## [PLATFORM] concern found while verifying — the seed is ignored by this sandbox's awk

OBSERVED
- `scripts/eclipse_pass.sh:53`: `awk -v s="$SEED" 'BEGIN{srand(s)} {print rand()"\t"$0}'` — the seeded
  shuffle. `SKILL.md:78–79` (text unchanged; was :46–47 in the original): "seeded and reproducible, so the
  selection can't be (and can't be accused of being) cherry-picked".
- Sandbox: `awk` → `/usr/bin/mawk`, "mawk 1.3.4 20240123"; `nawk` is the same binary; no gawk or busybox.
  Six dry runs of the ORIGINAL script with `--seed 42` over four candidates gave four different picks.
  `printf 'a\nb\nc\nd\n' | mawk -v s=42 'BEGIN{srand(s)} {print rand()}'` differs every run; so does
  `srand(42)` as a literal, and `mawk -W random=42`. `srand(7)` after `srand(42)` reports 42, so the seed is
  stored but does not steer `rand()`.

JUDGED
- [PLATFORM] In this build environment the "reproducible pick" claim is false; the skill's honesty pillar
  (not cherry-picked) rests on it. Not fixed here — brief item 4 forbids touching the script's behaviour, and
  the fix is a platform choice (e.g. require gawk, or replace the awk shuffle with a POSIX-portable seeded
  hash) that is his to rule. Named in the new falsifier line 2 as a live example. Falsifier: on his machine,
  run `eclipse_pass.sh --target X --from DIR --pick 3 --seed 42` twice; identical picks dissolve the concern
  there (gawk honours `srand(seed)`); different picks make it a real bug to queue.

## o35 — LENS as its own skill, or a section here?

OBSERVED: the direction is to *mention* LENS in eclipse (`reflection-family-drift.md:13`), not to build a LENS
skill; what is confirmed of LENS is its role — human baseline, "nothing needs capturing" (`lens-microscope-
bubble-chamber.md:21–22, :45`); its content (the four steps) is unconfirmed (`:46–47`, `lens-discipline.md:11`);
yet a LENS tool already exists at `h/lens.py:2–6` and codifies those four steps as settled, and queue Q12 already
treats lens.py as a thing to enhance (`h/ENHANCE-2026-09-04-queue.md:134`).
JUDGED [MINE]: a section here is right today — the confirmed LENS is a pointer to a human habit, too thin to be a
skill without codifying exactly what item 2 forbids; the pressure to make it a skill comes from lens.py, whose
docstring has run ahead of his confirmation. The one check that settles it: he confirms or rejects the four-step
reading — confirmed, LENS earns its own skill with lens.py as its script; rejected or silent, it stays a section
here and lens.py's docstring gets the CANDIDATE mark.

## [MINE] choices, collected (none blocks)

1. Section placed after "When this applies", before "The five moves".
2. His quote kept with the spelling on file ("aparatus").
3. Two plain-words sentences expanding the rung rule at the end of the family section.
4. Bubble-chamber pointer cites `lens-microscope-bubble-chamber`, not the unstaged `bubble-chamber-method`.
5. `description:` unchanged.
6. The optional script header line was added (one `echo`).
7. Off-switch phrases: "debugger off" / "no eclipse, just a lens" / remove the directory.
8. Falsifier line 2 carries the mawk finding as a dated parenthetical.
