# CHANGES — values-baseline (pass C, brief 3), 2026-09-11

Files written: `PATCH-2026-09-11-values-baseline-hold-not-harm.diff` (unified diff, unapplied),
`README.md` (6 lines). No full file is shipped, because there is no source to ship — see below.

---

## OBSERVED

- The skill has **no source under the lab's skills folder**. `ls
  /mnt/user-data/uploads/AS4CE0001/skills/` does not list it, and a grep for `values-baseline`
  across `/mnt/user-data/uploads` returns only two mentions of the *name*
  (`/mnt/user-data/uploads/c4/evidence/personas.tsv:44` and
  `/mnt/user-data/uploads/AS4CE0001/h/forms-exemplars.txt:354`) plus the memory note below —
  never a copy of the skill.
- The only reachable copy is the read-only installed cache at
  `/root/.claude/skills/synced/8460b5c5-7709-448e-a1b9-45577b5e1670_948346fb-5634-4a0d-bbc2-9a649c945411/values-baseline/SKILL.md`
  (3446 bytes, mtime 2026-09-09, mode `-rw-r--r--` in a synced cache directory).
- `/mnt/user-data/uploads/AS4CE0001/memory/own-error-relaxable-layer.md:18-19` —
  "values-baseline excludes behaviors not identities (HOLD, not HARM)".
- Installed `values-baseline/SKILL.md:50-56`, the section that lists what the skill excludes —
  "So fence it: it may rest on **behavior and traceability, never identity**, and it closes
  **no permanent exclusion** and no avenue to re-prove a claim. Exclusion that names a behavior
  and stays reopenable is a guard; exclusion that names a person is the thing we refuse to build."
- Installed `values-baseline/SKILL.md:45-46` —
  "Outcome on failure is **HOLD, with a name** for what's missing — not a silent FAIL."
- Installed `values-baseline/SKILL.md:9` and `:38-39` use the pair as one token —
  "it reads HOLD/HARM, not OK" and "yet HOLD/HARM to a native reader".
- `grep -c "HOLD, not HARM"` against the installed file returns **0** before the patch.
- `/mnt/user-data/uploads/c4/c/en:37` (o37) — "the ENHANCE patches for
  `ethicsminions`/`values-baseline`/`eclipse-pass` are drafted and unapplied (PMO #178)". The
  2026-09-04 drafts themselves are **not** on the mounted folders; redrafted from the notes, as
  the brief directs.
- `/mnt/user-data/uploads/c4/c/en:32` (o32) — "his rule 2026-09-11: falsifiers are added one
  skill at a time as each takes its next turn".
- The installed file has **no** falsifiers or off-switch section (no occurrence of "falsif",
  "off switch", or "prove-red"), consistent with o32's "0 of 58 installed skills carry a
  shipping section".

### Patch verified, not applied

```
$ patch -p0 --dry-run < PATCH-2026-09-11-values-baseline-hold-not-harm.diff
checking file values-baseline/SKILL.md
$ patch -p0 < PATCH-2026-09-11-values-baseline-hold-not-harm.diff
patching file values-baseline/SKILL.md
$ grep -c "HOLD, not HARM" values-baseline/SKILL.md
1
```

Run against a throwaway copy of the installed file in the scratchpad. The installed skill itself
was never written to — it is a read-only cache and is not this pass's to edit.

---

## JUDGED

### Why a patch and not a file

The preamble asks for full files, but a full file needs a source you are allowed to replace.
Here the only copy is an installed sync cache, and writing a "new SKILL.md" for it would either
be overwritten by the next sync or would silently fork a skill from a canon deck
(`c4_source_sha256: 11c3d274...`) that this pass cannot see. A diff the keeper applies by hand
keeps the decision with the person who owns the deck. Source: brief 3, "write a unified diff
... against it". [PLATFORM] — falsifier: the values-baseline source turns up on a folder that
gets mounted next session, in which case redo this as a full file against that source and drop
the patch.

### Where the distinction went

Into `## The fenced loss (keep it restricted)` — the one place the skill lists what it excludes,
and already the place that says "behavior and traceability, never identity" (SKILL.md:53-54).
The new `### HOLD is not HARM` subsection sits directly under that sentence and makes explicit
what the sentence assumes: a **HOLD** is a behaviour parked pending the missing ingredient or
consent, and is reopenable by construction; **HARM** is a judgement about a person and does not
reopen, because nothing could be produced that would answer it. The skill baselines behaviours
and never labels identities. Source: brief 3, and
`/mnt/user-data/uploads/AS4CE0001/memory/own-error-relaxable-layer.md:18-19`.

### What the patch does not touch

The frontmatter (including `description:` and the `c4_source_sha256` metadata) is untouched —
the ask does not change when the skill applies. The two existing `HOLD/HARM` slashed pairs at
`:9` and `:38` are left as they are; the new subsection explains the pair rather than rewriting
the sentences that use it. Nothing is deleted or reordered; the diff is one contiguous insertion.
[SKILL] — falsifier: a reader hits "HOLD/HARM" at line 9, takes it for one verdict, and never
reaches line 57; then the slashed pair is worth splitting too, in a later turn.

### The phrase appears exactly once, on purpose

The README's falsifier is `grep -c "HOLD, not HARM" ... prints 1`, so the patch is written to
introduce the string exactly once (verified: 0 before, 1 after). [MINE] — I chose to make the
falsifier a strict count rather than a presence check, so that a second copy of the phrase
pasted in later reads as a failure and gets noticed. It never blocks: if a future turn genuinely
wants the phrase twice, change the README's expected number and say why.

### Falsifiers section

Added, not amended — the installed file has no equivalent (see OBSERVED). Four checks and an
off-switch, per o32. Two of the four are phrased against the skill's own XX pair
(SKILL.md:43-48) so they can actually be run: hand the disclosed trail alone to a stranger, and
check that the retrace was not done by the author. [DOMAIN] — falsifier: the C4 canon deck
already carries a falsifier list that this duplicates, in which case merge rather than add when
the deck becomes readable.

---

## [MINE] choices, collected

1. Patch rather than full file, because the only copy is a read-only sync cache and the canon
   deck is out of reach. Falsifier: the source appears on a mounted folder — redo as a full file.
2. Placement of the new subsection inside the fenced-loss section rather than near the
   `HOLD/HARM` mentions at lines 9 and 38. Falsifier: a reader takes "HOLD/HARM" at line 9 as a
   single verdict and stops there.
3. The README falsifier is a strict count (`prints 1`), not a presence check. Falsifier: a later
   turn wants the phrase twice and the README has to be updated with it.
4. `patch -p0` paths (`values-baseline/SKILL.md`, no `a/`–`b/` prefixes), so the keeper applies
   it from the directory that holds the skill folder. Falsifier: the keeper works with `git
   apply` instead and needs `-p0` passed explicitly.
