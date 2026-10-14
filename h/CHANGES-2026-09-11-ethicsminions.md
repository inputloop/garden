# CHANGES — ethicsminions (pass C, brief 3), 2026-09-11

Files written: `SKILL.md` (full new file), `references/attestations.txt` (full new file).
`scripts/check_principles.py` is **unchanged** and is not re-shipped here.

---

## OBSERVED

- `/mnt/user-data/uploads/AS4CE0001/memory/reflection-family-drift.md:14` —
  "Concrete hook found live: the ethicsminions `drift` guard is currently **SKIPPED**
  (no `--expect` attestations file) — coupling reflection↔drift could feed it."
- `/mnt/user-data/uploads/AS4CE0001/skills/ethicsminions/scripts/check_principles.py:75` —
  `if not expect: return ("SKIP","no --expect attestations file given (drift check skipped).")`
- `/mnt/user-data/uploads/AS4CE0001/skills/ethicsminions/scripts/check_principles.py:79-80` —
  `missing = [ln.strip() for ln in read(ef).splitlines() if ln.strip() and not
  ln.lstrip().startswith("#") and ln.strip() not in hay]`
- `/mnt/user-data/uploads/AS4CE0001/skills/ethicsminions/scripts/check_principles.py:138` —
  `--expect`, "optional attestations file: one expected principle line per row; rows missing
  from memory are flagged as drift".
- `/mnt/user-data/uploads/AS4CE0001/skills/ethicsminions/scripts/check_principles.py:78` —
  `hay = "\n".join(read(p) for p in notes(mem) + [mem/"MEMORY.md"])`
- `/mnt/user-data/uploads/AS4CE0001/skills/ethicsminions/references/attestations.txt:10` —
  the first non-comment line reads `two attestations`.
- `/mnt/user-data/uploads/c4/c/en:48` (o48, RULING, held-by-keeper) —
  "The signed canon carries three standing attestations but the loaded session instructions
  only carry two, unsigned and six weeks stale".
- `/mnt/user-data/uploads/c4/c/en:32` (o32) —
  "his rule 2026-09-11: falsifiers are added one skill at a time as each takes its next turn".
- `/mnt/user-data/uploads/AS4CE0001/skills/ethicsminions/SKILL.md:53-57` — the RISK bullet list
  names `memory-present`, `principles-present`, `truncation`, `duplication`, and stops. Neither
  `drift` nor `description-length` appears anywhere in the skill's prose.
- `/mnt/user-data/uploads/AS4CE0001/skills/ethicsminions/SKILL.md:85` —
  "When expectations and memory disagree, treat SAVANNAH as the arbiter".
- `/mnt/user-data/uploads/AS4CE0001/skills/ethicsminions/references/attestations.txt:6` —
  the file's own rule: "a minions pass — never to make a red check green."
- No `MEMORY.md` exists anywhere under `/mnt/user-data/uploads` (`find . -name MEMORY.md`
  returns nothing), and of the five pinned lines that shipped in `attestations.txt`, only
  `universalism/egalitarianism` appears in a memory note
  (`/mnt/user-data/uploads/AS4CE0001/memory/lens-discipline.md`).
- No 2026-09-04 draft patch for this skill is on the mounted folders; a grep for
  `ethicsminions` across the lab returns only the skill's own files, the queue row o37
  (`/mnt/user-data/uploads/c4/c/en:37`, "the ENHANCE patches for
  `ethicsminions`/`values-baseline`/`eclipse-pass` are drafted and unapplied (PMO #178)"),
  and the memory note above. Redrafted from the notes, as the brief directs.

### Guard output — before

Command: `python3 skills/ethicsminions/scripts/check_principles.py --memory . --skills skills`
(run from `/mnt/user-data/uploads/AS4CE0001`).

```
  [SKIP  ] drift              no --expect attestations file given (drift check skipped).
```

(1 risk notice, 2 opportunities; every other check as before.)

### Guard output — after

Command: `python3 skills/ethicsminions/scripts/check_principles.py --memory . --skills skills
--expect skills/ethicsminions/references/attestations.txt`, run against the staged lab with
the two new files dropped in.

```
EthicsMinions — guard report (advisory)

 RISK  (NOTICE = a human should look):
  [NOTICE] memory-present     MEMORY.md index is missing — memory may be unreadable.
  [PASS  ] principles-present principle/attestation notes: PERSONA-CORPUS.md, SEATDIFF-2026-09-04.md, SEATDIFF-2026-09-04b.md, account-memory-store-D.md, c4-forge-mint-2026-09-04.md, lens-discipline.md
  [PASS  ] truncation         no truncation signals.
  [PASS  ] duplication        no duplicated bodies across memory/skills.
  [NOTICE] drift              attested values not found in memory (drift): wrong with entrusted systems and authority | concealment from investigations | do not give up on people, opportunities, or problems | four freedoms ordering | family/non-participant line | mechanical consent
  [PASS  ] description-length all skill descriptions within the 1024-char load limit.

 OPPORTUNITY  (OPPTY = an opening worth routing to SkillTank):
  [OPPTY ] skill-themes       recurring themes no skill covers (→ SkillTank): access, account, architecture, automemorydirectory, carried, ccspt, character, contexts
  [PASS  ] share-plugin       no un-shared plugin-worthy skills flagged.
  [OPPTY ] value-gaps         stated values no skill operationalizes yet (→ candidate guards/skills): free software

2 risk notice(s), 2 opportunity(ies). Memory fixes → Mentat; skill/opportunity ideation → SkillTank → skill-creator.
```

The drift guard **runs**. Its real verdict on the staged surface is a NOTICE naming six
lines memory does not carry — including all three standing attestations.

### Proof the drift check is actually reading memory

Dropped `memory/zz-probe.md` containing the single line
`No concealment from investigations.`, re-ran, and that echo left the NOTICE list while the
other five stayed:

```
  [NOTICE] drift              attested values not found in memory (drift): wrong with entrusted systems and authority | do not give up on people, opportunities, or problems | four freedoms ordering | family/non-participant line | mechanical consent
```

Probe file removed afterwards; the staged lab is unchanged.

---

## JUDGED

### The format is the existing file's — no new `expect.txt`

The guard takes any path via `--expect` and wants one expected line per row with `#` comments
(check_principles.py:79-80, :138). That is exactly the shape `references/attestations.txt`
already had, so I amended that file and did **not** add a `references/expect.txt`. Source:
brief 3, "make `references/attestations.txt` (or a new `references/expect.txt` if the format
differs — say which)". It does not differ; attestations.txt it is.

### Why the guard was SKIPping, and what actually fixed it

The file existed and was well-formed; nothing passed it. The SKIP is produced before the file
is ever read (check_principles.py:75), so the fix is in the **documented command**, not the
data. `SKILL.md`'s command block now passes `--expect references/attestations.txt` as standing
state rather than listing it as an optional extra. [SKILL] — falsifier: run the command exactly
as the skill prints it and the drift line still says SKIP.

### Replacing `two attestations` with the three

`attestations.txt:10` pinned the count at two. Canon carries three, and the gap is a live
keeper ruling (o48, `/mnt/user-data/uploads/c4/c/en:48`). I removed that line and pinned the
three attestations instead, each with the full canon sentence in a comment above the fragment
the guard matches. [DOMAIN] — falsifier: SAVANNAH turns out to carry two standing attestations,
not three, in which case o48 is answered the other way and this file is wrong.

This is not "making a red check green" in the sense the file's own header forbids
(attestations.txt:6) — the old line was green and vacuous (it matched nothing but itself), and
the new lines are red. The three attestations went in knowing they would NOTICE.

### The three lines are mid-sentence fragments, deliberately  `[MINE]`

The match at check_principles.py:79-80 is a plain, case-sensitive `in` test. Canon writes
"No wrong with entrusted systems and authority."; a note may write "no wrong with ...". Pinning
the full sentence would make the guard case-fragile, so each echo drops the leading word:
`wrong with entrusted systems and authority`, `concealment from investigations`,
`do not give up on people, opportunities, or problems`. `[MINE]` — this is my choice of
phrasing, not a quoted canon line; I have said so in a comment block at the top of the file so
nobody "tidies" it back. Falsifier: the probe above — a note containing
`No concealment from investigations.` clears that echo, which a full-sentence pin with a capital
`N` would not have done. It never blocks: if Corwin prefers exact canon sentences, swap them and
accept the case-sensitivity.

### The other three stale lines stay

`four freedoms ordering`, `family/non-participant line`, and `mechanical consent` also fail to
match memory. Deleting them would have made the report green by shrinking the expectation, which
is precisely what attestations.txt:6 forbids. They stay, and they NOTICE. [SKILL] — falsifier:
these three were never meant as memory echoes at all (e.g. they are section titles from a note
that is not on the mounted folders), in which case they belong in comments, not rows.

### What I changed in SKILL.md, and what I left alone

Added: a `drift` bullet to the RISK list (it was the one guard the prose never named); a
`## The drift guard (it runs — pass --expect)` section saying it runs, that it reads
`references/attestations.txt`, that the match is a case-sensitive substring test, that canon is
three attestations, and how to switch it off; one sentence in the SAVANNAH section noting the
file holds echoes of canon, not a second copy; the `--expect` flag moved into the standing
command. Frontmatter `name:` and `description:` are byte-identical to the staged original — the
ask does not change when the skill applies.

Left alone: `description-length` is also a real guard the prose never names
(check_principles.py:84, SKILL.md:53-57). That is outside this brief's "amend only where it
describes the drift guard", so it is recorded here and not fixed. [SKILL] — falsifier: someone
reads SKILL.md, runs the script, and is surprised by a check the skill never mentioned; then
it is worth a line.

### Falsifiers section

The skill had **no** equivalent section (no occurrence of "falsif", no off-switch, no
shipping/red-test language) — confirming o32's count from
`/mnt/user-data/uploads/AS4CE0001/memory/skills-focus-model.md:32`. So this is an addition, not
an amendment. Four checks plus an off-switch, per o32's rule
(`/mnt/user-data/uploads/c4/c/en:32`, "falsifiers are added one skill at a time as each takes
its next turn"). The third check is the one that was actually run above, so it is known to work.

### Signed-file note

No `.asc` sits beside any ethicsminions file on the mounted folders (`find . -name "*.asc"`
returns nothing across `/mnt/user-data/uploads`), so the 2026-09-10 edit-anyway norm did not
need invoking here. Recorded so the runner does not go looking.

---

## [MINE] choices, collected

1. The three attestation echoes are **mid-sentence fragments**, not full canon sentences, to
   survive the guard's case-sensitive match. Falsifier: the `No concealment from
   investigations.` probe clears the fragment and would not clear a capitalised full sentence.
2. Full canon sentences kept as `#` comments directly above each fragment, so a reader sees the
   whole promise even though the guard matches less. Falsifier: a future editor uncomments one,
   the check goes red for no substantive reason, and the comment block explaining why gets read.
3. Kept the three other stale pinned lines rather than pruning them. Falsifier: Corwin says they
   were never memory echoes; then they move into comments.
