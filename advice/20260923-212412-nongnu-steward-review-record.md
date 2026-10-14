# nongnu-steward — review record (skilltank · skill-creator · ethicsminions) and what the day taught

2026-09-23. Two piles: OBSERVED carries its command; JUDGED is marked. Tags per the house:
[CORWIN] his words · [DOMAIN] a law of the field · [SKILL] a named skill · [PLATFORM] the harness ·
[MINE] my disposition (never blocks; proceed and name).

## What landed (OBSERVED: `find SOFT-SKILLS/nongnu-steward -type f | wc -l` → 45; `ls SOFT-SKILLS/considerate-reader`)

`SOFT-SKILLS/nongnu-steward/` — SKILL.md (description 1003/1024, `skill-lint.sh`) · COPYING (GPLv3, bytes
= gnulib doc/COPYINGv3 sha 3972dc97…) · references/{MODEL-steward.md (E1–E18, three rings, every
citation resolving to a manifest row), notices.md, checklist.md, PERSONA-template-steward.md (cs1gk
FAULT 0), INQUIRE.md (5 questions with drafts), canon-seed.tsv, canon.tsv (58 rows: git 10 · raw 2 ·
static 45 · browser 1), canon/ (22 text snapshots + README `covers: *`)} · scripts/{nslib.sh, ns1op,
ns1hd, ns2ld, ns2cn} · tests.sh (53 ok, `--prove-red` PASS) · tests/spec.pl (Perl, 45 ok, `--prove-red`
PASS) · bridge `tests/nongnu-steward-tests.sh` (gd1ck: GREEN, 2 legs).
`SOFT-SKILLS/considerate-reader/` — the spell Corwin asked for, as a soft skill (description 998/1024) + COPYING.

## skilltank (OBSERVED: `scan_candidates.py --memory memory --skills <rack incl. SOFT-SKILLS> --drop-generic`)

No memory cluster drove this skill; the request did. The gate: ships runnable resources (4 scripts, a
manifest) — yes; recurring need (every free software project) — yes; one capability — yes ("tending to a
reviewer's floor"). Lane overlap checked by reading descriptions: `medley-review` is Savannah host config,
`savane-forensics` is breach work, `release-runbook` is the polygram release — no collision; one-way
references only. [SKILL:savane-forensics §40] independently states the SHORT-NOTICE rule ("a one-line
'License GPLv3+.' is not enough"). Verdict: NEW. `considerate-reader`: NEW (nothing on the rack covers the
manner of reading; `candor-gate` covers consent for an imported skill's egress, `verify-say` the wording).

## skill-creator, as the "skill-designer" pass (JUDGED: no `skill-designer` exists in the tree — ledger C1)

Authoring pass: TOC added to the 341-line model; description made pushier and trimmed back under the
limit twice (1029 → 1014 → 1003). Three with-skill cold-reader runs (subagents with only the skill's files,
against fixtures on avalon, no network): 20/21 assertions held; the miss was real — the persona template's
own footer (my notice) was copied into Jane's sheet. Enhancements folded in from the runs: `--name` /
`steward.name` (headers said "part of newproj"), images and PDFs audited as binaries needing a README (a
`.png` was silently skipped), `COPYING-SHORT` (a 307-byte stub passed as present), the template footer as a
slot with the template's own notice moved into a comment, one line explaining the NEWS `mark:`. Re-run of the
persona eval after the fixes: 8/8. Viewer: `outputs/nongnu-steward-eval-review-iteration-{1,2}.html`.
Not done: baselines (no-skill runs) and the description-optimisation loop (`claude -p`); both are the
loop's next turns if he wants them.

## ethicsminions (OBSERVED: `check_principles.py --memory memory --expect attestations.txt --skills <rack>` → 0 risk notices, 2 OPPTY)

RISK, by hand, on the new skill:
- [DOMAIN] network egress: none unasked. `ns1op` reports; `ns2cn --check` is on demand, one row at a
  time, git blob ids before pages, 5xx/429 = unreachable never a change. Falsifier: any request in a
  session where no `--check`/`--refresh` was asked.
- [DOMAIN] third-party text carried: only where the page states a permission (README lists each);
  unstated-licence pages are hashed, not copied; verbatim copies are never edited.
- [PLATFORM] the delete permission on F:\claude\AS4CE\AS4CE0001 stays enabled for this session; it was
  used for 26 snapshot files I had written and for nothing else.
- [MINE] the persona template's §13 describes misuse patterns (threshold gaming, bulk paste, guessed
  licences, applying in the keeper's name) — a feature; cs1gk G10 FAULTs a system actor without it.
- [CORWIN] "never push Savannah": every eval report checked — no "apply to Savannah" in any (assertion ×4).
OPPORTUNITY: the skill is pub-safe (method, no cases) → a graduation candidate for `skills/` and the
plugin, and useful to any maintainer; the `ns1hd` audit could be offered to savannah-hackers as a
pre-submission self-check (INQUIRE.md §1's draft mentions it); `ns2ld`'s compat table could be checked
against SPDX's `isFsfLibre` flags (an opening, not done; it would add a dependency).

## What the estate itself showed (OBSERVED: `sh SOFT-SKILLS/nongnu-steward/scripts/ns1hd --quiet --tsv bin polygram tests skills`)

`skills/`: 89 NO-NOTICES · 6 SHORT-NOTICE · 4 NO-COPYRIGHT · 1 NO-LICENSE · 1 GPL-ONLY · 1 BINARY.
`bin/`+`polygram/`: 23 SHORT-NOTICE (the house idiom `GPLv3-or-later.`) · 4 NO-NOTICES (`bin/freshen`,
`bin/polygram`, `bin/release`, `bin/thread.sh`) · 0 GPL-ONLY after the "GPLv3 or later" fix (`bin/sh1ck`
was a false positive). `AS4CE0001/COPYING` differs from gnu.org's `gpl-3.0.txt` only in line wrapping from
line 147 (`diff`): same text, not the canonical bytes. JUDGED: a header pass over `skills/` is a real job
and the pen is his — `ns1hd --suggest` prints each header; not done here, not a defect of the skill.

## The lessons, each with the receipt

1. **Decide the form and the licence before writing a byte.** I wrote 26 snapshots of pages that state no
   licence, then needed a delete; the approval cost Corwin ninety minutes IRL. [CORWIN, mid-turn]
2. **Generated content is the wrong object to pin.** A `date:` header makes a raw HEAD sha differ every
   request; cgit's `Last-Modified` is the response time. The manifest now pins commit + blob ids where a
   repository exists. [CORWIN: "prefer git clone rather than scrape CGI"]
3. **A nine-wide check got a 502 page naming AI-scraper load** (`ns2cn --diff emacs-contribute`, 20:48Z).
   That is the pattern behind Bob's mirrors network. Width is now 1, there is no schedule, a 5xx is
   unreachable. And I then ran the full check twice in a row for a summary line (21:2xZ) — the same
   reflex at small scale; noted, not excused. [CORWIN: diligence is a careful check, not a routine guard]
4. **Routine keeps its egalitarian value** (same ladder, same audit for everyone) but it is not access
   and it is not diligence; the model says so in §8, the spell in its first section. [CORWIN, follow-up]
5. **Savannah's git ignores partial-clone filters** ("filtering not recognized by server, ignoring"):
   one file = a whole-tree depth-1 fetch there (gnulib 12 MB); gcc.gnu.org honours the filter (1 object).
   Big Savannah repos are pinned at commit level only until a calm day; the ask is INQUIRE.md §3.
6. **A subagent's `Write` refuses report files**; heredocs work. Perl `ok_` needed a `($$)` prototype —
   a failed match in list context slid the message into the condition and passed falsely (caught by a
   warning, fixed, and the parser bug it hid — `key = value` with spaces — fixed with it).

## Forks routed (to Corwin, as risks he accepts or declines; none block)

- F1 Header pass over `skills/` (89 files) and `bin/` (27): `--suggest` is ready; bulk edits are the
  bad-guy roll's first move, so one directory at a time under his eye.
- F2 `prefs.py` KNOWN row `steward.auto` so `pref_set` can switch the implicit run over MCP (one line +
  a test; touches polygram, hence the plugin).
- F3 gd1ck discovering `SOFT-SKILLS/*/tests.sh` directly instead of via the bridge (a two-line loop in
  `bin/gd1ck`; the bridge works today).
- F4 The five INQUIRE notes: his to send or not.
- F5 A tiny CVS pserver client (port 2401 answers; no `cvs` binary installable in the VM) would make the
  www and gnustandards sources pinnable by revision.
- F6 Refresh the five commit-level pins (`ns2cn --refresh emacs-contribute emacs-admin-copyright
  coreutils-hacking guix-contributing-texi guix-texi`) on a day Savannah's git server is calm; the
  first fetch is whole-tree-at-depth-1 per repository.

---
Copyright (C) 2026 Corwin Brust <corwin@bru.st>. Authored by Mentat (for Corwin).
SPDX-License-Identifier: GPL-3.0-or-later. Copying and distribution of this file, with or without modification,
are permitted in any medium without royalty provided the copyright notice and this notice are preserved.
This file is offered as-is, without any warranty.
