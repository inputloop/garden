# CHANGES — posix/SKILL.md (Brief 2, Q5)

Source file: `/mnt/user-data/uploads/AS4CE0001/skills/posix/SKILL.md` (86 lines, no `.asc` found
beside it — nothing to note under "signed file, edit anyway").

## OBSERVED

- Ask, verbatim from `brief-2-posix-verify-say.md` §posix: "`grep -c PATTERN FILE || echo 0` prints
  `0` and `0` (grep -c prints 0 and exits 1 on no match) → 'Illegal number'; use `n=$(grep -c …);
  n=${n:-0}`. Also: `dash -n` as the parse check before running; a scorer's `--prove-red` shape
  (corrupt a copy of the good fixture, expect the named FAIL)."
- Same ask, queue form, `h/ENHANCE-2026-09-04-queue.md:67-74` (Q5): "**Q5 · ENHANCE `posix` — the
  gotchas ledger**" ... "Ask: `grep -c PATTERN FILE || echo 0` prints `0` **and** `0` ... Receipts:
  `AS4CE0001/bin/landcheck.sh:29` (the comment carries the rule) · first test run output ('[: Illegal
  number: 0') · `tests/landcheck-tests.sh`." — the queue's own section title, "the gotchas ledger", is
  what I named the new SKILL.md section after.
- `bin/landcheck.sh:28` (my count — see JUDGED (1) below): `u=$(grep -c ': UNSET$' "$r"
  2>/dev/null); u=${u:-0}   # grep -c prints 0 AND exits 1 on no match — never '|| echo 0'` — this is
  "the comment [that] carries the rule."
- `bin/landcheck.sh` header, lines 7-8: "usage: sh bin/landcheck.sh RUN-DIR ... sh bin/landcheck.sh
  --prove-red    corrupt a copy of the good fixture; expect FAIL" and the working `--prove-red` case
  at lines 61-67 (corrupts a copy of `tests/fixtures/landcheck/good-run`, checks the good fixture
  still PASSes, then checks the corrupted copy FAILs on B13) — this is the `--prove-red` shape the
  ask names.
- `skills/posix/SKILL.md` step 3 of "The review loop" (original): "`sh -n` or `bash -n` per shebang
  ... every test written that could be." — this is "where the skill talks about testing," the ask's
  named landing spot for `dash -n` and `--prove-red`.
- No section named "ledger" or word "gotcha" exists anywhere in the source `posix/SKILL.md` (checked
  by full read + grep, both empty). `sandboxer/SKILL.md` has the shop's precedent form for this kind
  of entry — "## Fingerprints — dated, each with its receipt" (bold dated bullet, one-line lesson,
  `Receipt:` citation) — and `h/ENHANCE-2026-09-05-tree.md:46` groups the two as siblings: "`Q4+Q5+Q6`
  sandboxer fingerprints · posix gotchas · verify-say transport words."
- `tool.py` docstring: "stdlib only; READ-ONLY; always exits 0" and its `BASHISMS` list (lines 27-40)
  is a hardcoded Python list inside the file itself — not a separate file the script reads at
  runtime.

## JUDGED

1. **[MINE] Line-number correction.** The brief and the queue both cite `bin/landcheck.sh:29` for
   the comment that carries the rule. Counting the staged file, the comment sits on line 28 (line 29
   is the `if [ "$u" -eq 0 ]` that consumes `$u`). I quoted line 28 in the new ledger entry rather
   than repeat the off-by-one. Falsifier: `sed -n '28,29p' bin/landcheck.sh` in the runner's own copy
   — if the comment is actually on 29 there, my count (and this note) is wrong and the entry's line
   number should be corrected.
2. **[SKILL] "The posix ledger" didn't exist in the staged file.** Neither the ask's phrase ("the
   posix ledger") nor the word "gotcha" appears anywhere in `posix/SKILL.md`, so there was no
   existing in-skill form to match by literal grep. I built the new section on the shop's nearest
   established analog — `sandboxer`'s dated-bullet "Fingerprints" ledger, which the tree file already
   treats as the same kind of thing as "posix gotchas" (see OBSERVED above) — and named the heading
   "## The gotchas ledger" to match the queue entry's own title for this work (Q5's heading). This is
   additive, not a reorganization: nothing else in the file moved. Falsifier: if a `posix.md` or other
   named ledger surfaces elsewhere in the shop (mentat project-memory, a different skill file) with
   its own established form for posix gotchas, this section should be renamed/reshaped to match that
   instead.
3. **[MINE] Placement of the new ledger section.** Put it between "## Tooling" (which already
   introduces `tool.py`, the other advisory surface) and "## Provenance" (kept as the file's closing
   section, unchanged). Falsifier: if a later ask wants gotchas ledger entries surfaced earlier
   (nearer the review loop) rather than as an appendix, move it — no content changes needed.
4. **[MINE] `dash -n` phrased as "where dash is on PATH."** `dash` is not guaranteed present on every
   box (Debian/Ubuntu ship it as `/bin/sh`; other systems may not have it at all), so I worded it as
   an added check when available rather than a hard requirement, alongside the existing `sh -n`/
   `bash -n` line. Falsifier: if Corwin wants `dash -n` to be a hard gate (fail the review when
   `dash` is absent) rather than a "run it if you can" check, say so and the wording tightens.
5. **[SKILL] `tool.py` left unchanged.** The ask says "do not change tool.py unless the gotcha
   belongs in a machine-readable ledger it reads — say which in CHANGES.md." `tool.py`'s `BASHISMS`
   list is hardcoded inside the script (see OBSERVED), not a separate ledger file it reads at
   runtime, and it is a different domain (bash-under-`#!/bin/sh` heuristics, not `grep -c` exit-status
   behavior) — so the `grep -c` gotcha does not belong there. `tool.py` is untouched. Falsifier: if
   `tool.py` is later refactored to read an external gotchas file, this grep -c entry becomes a
   candidate for that file too.
6. **[MINE] Frontmatter untouched.** `name:` and `description:` are unchanged — the ask adds review
   content, it does not change when the skill fires. Falsifier: if the new `dash -n`/`--prove-red`/
   ledger material changes what should trigger the skill (it doesn't, on my reading), the description
   would need a matching edit.

## Falsifier section

Added "## How this skill can fail (falsifiers)" — the source file had none (checked: no "How this
skill can fail" or similar heading present). Placed after the new gotchas ledger, before
"## Provenance" (kept last, per house form). 3 checks + 1 off-switch line, per the preamble's spec.

## Output

`/mnt/user-data/outputs/passA/posix/SKILL.md` — full file, `tool.py` not included (unchanged; still
at `/mnt/user-data/uploads/AS4CE0001/skills/posix/tool.py`, read-only reference).
