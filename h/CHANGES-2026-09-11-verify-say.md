# CHANGES — verify-say/SKILL.md (Brief 2, Q6)

Source file: `/mnt/user-data/uploads/AS4CE0001/skills/verify-say/SKILL.md` (117 lines, `metadata:`
block present, no `.asc` found beside it in the staged tree — nothing to note under "signed file,
edit anyway").

## OBSERVED

- Ask, verbatim from `brief-2-posix-verify-say.md` §verify-say: "one more state for a copy: 'copied,
  re-read' (destination hashed, source unhashable) beside 'copied, verified' (both sides hashed); and
  the rule that a report prints NOT ATTEMPTED with the command for any check the reader could not
  run."
- Same ask, queue form, `h/ENHANCE-2026-09-04-queue.md:76-82` (Q6): "**Q6 · ENHANCE `verify-say` —
  the transport case**" ... "Ask: one more state for a *copy*: **'copied, re-read'** (destination
  hashed, source unhashable) beside 'copied, verified' (both sides hashed); and the rule that a
  report prints `NOT ATTEMPTED` with the command for any check the reader could not run."
- `SEATDIFF-2026-09-04.md:16-49` — every row of the morning's transaction table uses the exact phrase
  "copied, verified" (34 times, one per note) for a copy where, per the file's own framing (line 3:
  "with the sha that proves it"), both sides carry a sha in the table.
- `SEATDIFF-2026-09-04b.md` "Two piles, closed" (line numbers 126-134), item (2), quoted in full:
  "'copied, verified' in the morning's vocabulary meant sha-on-both-sides — tonight's is 'copied,
  re-read' and this file says so rather than borrowing the stronger word (`verify-say`)." This line
  itself names `verify-say` as the skill that should carry the distinction — the direct receipt for
  this ask.
- `SEATDIFF-2026-09-04b.md:31-45` (the evening transaction table) shows the actual weaker case: each
  row's "A-side identity" column reads "read→write, unhashed" and the table intro (line 31) says
  "sha = bash reader on the seat copy" — i.e. only the destination (seat copy) was hashed; the source
  side is marked "unhashed." This is the concrete instance "copied, re-read" describes, even though
  that exact phrase appears only in the evening file's JUDGED note, not in this table's own wording.
- `skills/verify-say/SKILL.md`, original "## The state vocabulary" section: the generic fallback is a
  3-item numbered list — "1. **Absent.** ... 2. **Present but unverified.** ... `verify NOT
  ATTEMPTED`. ... 3. **Verified.** ..." — each item bold-lead-word-then-period, then sentence(s). This
  is "the existing form" the ask says to match.
- Original "## Print the attempt, not the assumption" section already teaches printing the attempted
  command (with a `gpg --verify` / `sign.sh check-shelf` example) but its body text never uses the
  literal token `NOT ATTEMPTED` — that exact token appears once already, but only inside state 2 of
  the vocabulary list ("Write `PRESENT`, write `verify NOT ATTEMPTED`"), not beside the
  print-the-command rule itself.

## JUDGED

1. **[SKILL] Where the new states land.** The ask's copy-states pair doesn't fit either existing
   vocabulary cleanly — not shelf-shaped (no `.gate`), and not quite the generic Absent/Present/
   Verified triad either, since a copy has two sides to name instead of one artifact's single check.
   I read it as a specific case of state 3 ("Verified") that needs splitting, and added it as a new
   bullet pair directly under the numbered list, in the same bold-lead-word form, before the existing
   "Never blur SIGN into 'verified'..." caution sentence. Falsifier: if Corwin reads "copied, re-read"
   as its own top-level state rather than a Verified-adjacent case, it should be pulled out of the
   numbered list's shadow and given its own heading.
2. **[HIS] Wording kept close to the ask's own phrasing.** Per the ask ("this skill OWNS the words,
   so wording is the deliverable"), I used "Copied, verified." / "Copied, re-read." verbatim as the
   bold lead terms, and kept the parenthetical definitions ("both sides hashed" / "destination hashed,
   source unhashable") as the core of each sentence rather than paraphrasing them away. Falsifier:
   diff the landed section against the ask's exact quoted phrase; any drift in the two state names
   themselves (not the surrounding prose) is a miss, since the names are the deliverable.
3. **[SKILL] The `NOT ATTEMPTED` rule already existed, partially — amended rather than duplicated.**
   The token `NOT ATTEMPTED` was already present, but only inside state 2 of the vocabulary
   ("Present but unverified"), not in the "## Print the attempt, not the assumption" section the ask
   points at ("beside the print-the-attempted-command rule"). Per the ask's own instruction ("if so,
   amend the wording to name the copy case, and say so"): I amended that section's opening sentence to
   name the copy case explicitly (an unhashable source is now listed alongside "no key on hand, no
   network, out of scope, ran out of time") and added a line to the example block showing the literal
   token printed next to a copy-specific command (`source: NOT ATTEMPTED (sha256sum SOURCE)`), rather
   than writing a second, separate rule. Falsifier: grep the landed file for `NOT ATTEMPTED` — it
   should appear twice (state 2, and the amended "Print the attempt" section), both consistent.
4. **[MINE] Metadata/version untouched.** The file's `metadata.version` ("2.0.1") and `origin` line
   are unchanged. Per the pass preamble, signing/re-signing and version bumps are the runner's/
   keeper's call, not mine to make unasked. Falsifier: if house practice is that every substantive
   content change bumps `metadata.version` as part of the same edit (not just at sign time), this
   should gain a version bump now.
5. **[MINE] Frontmatter `description:` untouched.** The ask adds vocabulary and a printing rule; it
   does not change when the skill fires (still "whenever a report ... is about to say a file is
   'signed', 'verified', 'clean', or 'good'"). No edit made. Falsifier: if a copy-specific claim is a
   case the description doesn't clearly already cover, it should gain a clause naming "a copy" or
   "a transfer" explicitly.

## Falsifier section

Added "## How this skill can fail (falsifiers)" — the source file had no such section (checked: no
"How this skill can fail" heading; the word "falsifying" appears once, in the unrelated
print-the-attempt sentence, and is not a section of its own). Placed as the file's new last section,
after "## Note on this version," so the existing section order and the file's closing "Note on this
version" both stay intact. 3 checks + 1 off-switch line, per the preamble's spec.

## Output

`/mnt/user-data/outputs/passA/verify-say/SKILL.md` — full file.
