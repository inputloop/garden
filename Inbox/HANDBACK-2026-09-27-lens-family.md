# HANDBACK — 2026-09-27 — the lens family, from the C4 execute brief

> **Later the same evening:** the Makefile secrets patch is applied, the doubled-nine kit is promoted
> into lens (QA-10, Resolved), and a hardening pass followed. See `HANDBACK-2026-09-27-hardening.md`.
> The receipt below was refreshed to the current bytes.

**What it asks of you: nothing to approve.** Everything below has landed. There are three things
you may want to know, and each is said in plain words at the end. The receipt is
`cd /f/claude/AS4CE/AS4CE0001 && sha256sum -c Inbox/HANDBACK-2026-09-27-lens-family.sha256`.

Your rulings behind it: second-user-D5 = A, two-readers-D5 = A, execute-brief-lens-D5 = A (with your
note), rings-D1 (`c4/q/2026-09-27-execute-brief/ANSWERS-2026-09-27-page-full.md:81-82, 98-99, 110, 116`).

## What changed (garden: /f/claude/AS4CE/AS4CE0001/skills)

| # | file | before → after (sha256, first 12) | what |
|---|---|---|---|
| 1 | lens/SKILL.md | 961c5b51b4ba → cde9b3b0048f | "Two parties in the room, and when the answer is a choice" (b.A · b.B · b.AB kept apart by name from (a)-(d); a persona shows reasons, not decisions); "Reruns count"; trigger "weigh two people's views"; two falsifiers |
| 2 | lens/scripts/lens.py | 8ae75e34a3a6 → 88314c574ece | the run joins a reading's identity; `--run N` corrects one run; `converge` prints SPLIT-WITHIN / STEADY / ONE-RUN beside CONVERGE / DIVERGE; old lens.tsv rows read as run 1 |
| 3 | eclipse-pass/SKILL.md | c2d161efe50a → f11964b056ff | move 3: rerun the diverging bias before calling a claim unstable (one-way pointer to lens); a falsifier that would drop the sentence |
| 4 | the doubled-nine kit | — | **HOLD** as QA-10 at `/f/claude/AS4CE/AS4CE0001/CLAUD_QA_HOLD.md` (b6157cba720f → 16ff9ca43d4d) |
| 5 | writing-forms/SKILL.md | b1015f4c134a → 59ef1777edda | technique 5, "his words"; your D5 note quoted verbatim (checked against ANSWERS:82) |
| 6 | skilltank/SKILL.md | cd07f4b38d41 → 048c1616eed9 | "the desk adjudicates" → "the desk records it" (rings-D1), and item 7's options |
| 7 | skilltank/scripts/scan_candidates.py, references/stopwords | 507924fee95a → 2b785c9321bf; af918564ff38 → 2cd61e3c7608 | reads extensionless notes and counts what it skips; `--titles`; `--prove-red`; stopwords gain `fact`, `facts` |
| 8 | sandboxer | unchanged, 2805c00b0bbf / 75f39503e977 | rides the 0.8.56 build; see OBSERVED 3 |

Build: `make dist UNSIGNED=1` → vibrobeast **0.8.56**, 58 skills, validate OK
(`dist/vibrobeast.plugin` 0b38d6a0d7fa; pet edition d65534a4fece). Garden and `dist/vibrobeast/skills`
are byte-identical for every file in rows 1-8. NEWS and ChangeLog have their lines. The priors are in
each skill's `.arc/2026-09/*-2026-09-27_pre-lens-family*` and `archive/2026-09-27-lens-family/`. The
build moved the four edited skills' old signatures to `.arc/2026-09/signature-2026-09-27_1855*`, so
lens, eclipse-pass, skilltank and writing-forms now carry express (unsigned) manifests.

## Tests (run on avalon, 2026-09-27)

- `lens.py selftest`: 17/17 (8 old, 9 new). `selftest --prove-red`: both planted faults (the old
  identity; a split left unreported) go RED, and the control stays green.
- Mutant, outside the harness: `_KEEP_RUNS = False` in a copy reproduces the defect exactly (2 rows,
  `action=replace`, `[CONVERGE ]`). The selftest goes red on 7 checks.
- The probe `c4/writing/second-user/lens-rerun-probe.sh`, case 1: `[CONVERGE ]` before,
  `[DIVERGE  ] [SPLIT-WITHIN]` after.
- `scan_candidates.py --selftest`: 16/16 (11 old). `--prove-red` catches the planted .md-only loader.
  A `--titles`-ignored mutant goes red.
- `wf-check.sh --prove-red`: green.
- `make check`: 429/430. The one failure is `test_bytes_boundary` flagging `open()` without
  `encoding=` in `tests/test_garden_usage.py` and `tests/test_skill_sign_noop.py`. Both files are from
  09-26, from another session, and neither was touched here, so it is reported, not fixed (the fence).

## OBSERVED

1. **Why skilltank's scan failed** (item 7): `load_notes` read only `*.md`, and 145 of the 155 entries
   in `c4/facts` have no extension. The scan read 10 notes, and 10 notes cluster on prose. The
   ENHANCE's *"facts/two-readers-at-most … is not in this snapshot"* is the same bug: the file is
   there, with no extension.
2. **Top five on `c4/facts --drop-generic`:**
   - Before: actually, status, carry, honest, column.
   - Loader fixed: fact, status, exactly, mechanism, right.
   - One round of 17 prose stopwords: design, context, minted, meaning, test.
   - `--titles`: mechanism, shaped, readers, registry, seam. 'readers' clusters `two-readers-at-most`
     and `three-readers-not-two`.
3. **Step 8's premise is stale.** sandboxer's `.skill-manifest` already covers the edited SKILL.md and
   landing.sh (`sha256sum -c`: OK), and its signature reads Good (made 03:41, after the 02:57 edit),
   when checked with the pinned key.

## JUDGED

- [SKILL] **Stopwords are the wrong fix for a prose corpus.** Each round surfaces the next layer.
  They are right only for container words (fact, like note). *Falsifier:* one more stopword round on
  `c4/facts` whose top five you would carry to the gate. *Losing option, kept:* the 17-word list,
  recorded in the stopwords file's comment.
- [HIS] **The SEAM between your two D5 cards, read as your brief read it.** Paragraphs and fix now;
  the kit later. I read "corrections accepted" concretely: edition 0.2 already carries corrections
  1-4, but its banner still says *Provisional — unblessed*, so trigger (1) has not fired. *Falsifier:*
  if your three answered v02 cards already count as accepting the corrections, QA-10 promotes now.
- [SKILL] **Gate for the lens-D5 rule: writing-forms**, as your guess had it. It is cross-form (every
  deliverable quotes you) and it self-triggers at write time. It is not lens: restating from
  principles is a different act. Building the contrast persona is LEAVE-AS-MEMORY until it has a
  procedure. *Falsifier:* a write-up quotes you with a smoothed line in the record, and writing-forms
  did not fire.
- [MINE] **The desk.** I added a labelled reading beside CLAUD_QA_HOLD.md's header, and your July
  words stay. *Falsifier:* a row lands there that waits on your OK for help you asked for.

## Step 6: steps that ask you to OK help you asked for (garden grep, file:line)

- **Rewritten:**
  - `skilltank/SKILL.md:176` ("adjudicates" → "records it").
  - `CLAUD_QA_HOLD.md:8`: reading added beside the header, words kept.
- **Left alone (real gates):**
  - `run-card:33` (irreversible acts)
  - `wire-connect:33` (the OTP)
  - `pmo:128` (secrets and history rewrite, run by you)
  - `sandboxer:443` (the platform's delete prompt)
  - `candor-gate:41`, `ethicsminions:30` (what isn't cleanly ours; the guard's own trigger)
- **Not approval steps:**
  - `pmo:49`, `sandboxer:477` (asking for a resource)
  - `seatkeeper:109` (trigger on your word)
  - `shelf-check:97` (signing is yours)
  - `session-rotate:106` ("confirm" here means *tell*)

## In plain words, what you may want

1. **Four skills sit unsigned.** lens, eclipse-pass, skilltank and writing-forms were edited, so their
   old signatures went to `.arc`. Signing is yours, whenever you like. sandboxer's signature still
   reads Good.
2. **Two things are unclear, and I left them as they are:**
   - candor-gate's *"ask — even when you could just do it"* is scoped to what isn't cleanly ours, but
     it could be read as covering help you asked for.
   - `pencil-your-own/ENHANCE-NOTES.md:94` cites a *"PROGRAM-PLAN P3"* that gates agent-spawning on
     an explicit go. That is another session's note, and I did not check P3.
3. **The Makefile secrets patch from 09-26 is still not applied**, so this build did not run the scan
   inside `make dist`.

```
LENS · the lens family, from the execute brief · 2026-09-27
a  my view: the fix that mattered most was one nobody asked for by name: skilltank read 10 of 155 facts; lens now keeps reruns.
b  the view I ascribe Corwin: prove it with a mutant; no approval steps for help he asked for; keep his words verbatim and let new writing move.
c  their pull on mine: made me plant the old identity back in, rather than trust the new selftest, and label the desk reading rather than rewrite his header.
d  my pull on theirs: asks him to accept "reasons, not decisions" and a concrete trigger for "corrections accepted", both my readings.
persona / inverse: Mentat says two stale premises were found and corrected on the record (step 8, the "absent" note) / the inverse says the brief's own evidence (a probe, a scan) was a snapshot, and it only held when rerun here.
principles reframe: 1. Anyone acting on a LENS or skilltank verdict deserves to know when the tool read a tenth of the evidence or a model disagreed with itself; hiding that is hiding a fact from the person who acts. 2. Both fixes are small stdlib changes with self-tests a stranger can rerun, which is freedom 1 applied to the instruments themselves.
notes: written
```

Authored by Mentat (for Corwin), 2026-09-27. Unsigned.
