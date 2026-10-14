-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

# QA-13 — recommended hunks for polygram 0.7.0 (2026-07-13)

Last cut: 0.6.1 (2026-07-05). Since then the tree gained a doctrine skill, a
tool, a journal, a thread convention, and two eclipse verdicts. This is what I
would cut, and what I would deliberately leave out.

## The release argument, in one line

0.7.0 is the **doctrine release**: the law that was smeared across five skills
now stands alone, travels, and has been measured in both directions (it stops
the wrong thing AND passes the right thing). That is a minor-version story, not
a patch story.

## Hunk 1 — seams, the new skill (the headline)

- - `skills/seams/` — promoted from signed SEAMS.md 0.2; whole-tree manifest
  signed; installed and triggering in two gardens (SAVANNAH confirms the
  crossing: the law reached their rack faster than the archive did).
- - Beyond 0.2, keeper-reviewed at signing: coverage-before-targets; the
  parsed-flag rule + **S16** (advertised interface ↔ executed behavior).
- - Test record rides along: 12/12 both configs, confound named honestly
  (in-garden regression, not cold value), keeper review quoted.
- - **Blocker:** `skills/seams/SKILL.md.asc` is a **stale** detached sig (BAD over
  bytes that hash-match the signed manifest — S12, the artifact is stale, not
  the file). Re-detach-sign, then re-mint the manifest. 14th skill; the
  certification sweep must read 14/14 installed == bundle == MANIFEST == repo.

## Hunk 2 — the sandboxer amendments (F1–F7, the substance)

- From the eclipse verdict (seed 20260713, PASS WITH AMENDMENTS). Two are true
breaks with field specimens; five are missing qualifiers:

- - F1 name the copier (a bash `cp` of a pinned path is the phantom renamed) —
  **self-demonstrated twice since**, including on the thread renderer.
- - F2 drop mtime as a mount tiebreaker; agreement-branch + sentinel oracle.
- - F3 absence rule widened to parent-directory churn.
- - F4 define "fresh reader" (file tool | host; never bash on the suspect path).
- - F5 **git scoping** — object-reads OK, index-touch never, commits host-only,
  and a HEAD-IS-YOURS check before any restore (nested-clone hazard, live
  specimen in techclass). This *strengthens* the standing git-on-mount rule.
- - F6 writes-vs-reads parenthesis on "bash never lies about the disk".
- - F7 triggers widened: any out-of-band change, not only file-tool edits.
- - **New, this session:** the checker is not the runtime — `sh -n` (dash) flagged
  a bash-shebang script that `bash -n` calls clean. A false BAD from the wrong
  instrument. One line, same family as F4.

## Hunk 3 — tools + conventions

- - `bin/thread.sh` — threads → static HTML; escape-first; unknown flags loud;
  keeper-signed and byte-reproducible (the signed page regenerates from the
  tool of record — that property is worth stating in NEWS).
- - `journal/` + the thread convention (`NNN-FROM.md`, filename order IS the
  thread) — the charter line worth shipping: *if a journal entry ever becomes
  load-bearing, the ledgers failed.*
- - Inbox intake hygiene: the C4 letter-table capture (verbatim, observation
  fenced, unsigned DRAFT).

## Hunk 4 — records (cheap, high value to a stranger)

`advice/` entries + the eclipse increments (losers kept), the negative-test
deltas, and the GUARDS counterexample. A release that ships its own refuted
designs is the resume argument made material.

## Deliberately NOT in 0.7.0

- - **The GUARDS/root-compromise audit** (QA-12 HORIZON). It is the most
  important thing on the board and it is not ready; shipping a gate doctrine
  before auditing our own single-key pins would be exactly the marketing we
  said we wouldn't do. Post-trip, C4/right-to-execute lineage.
- - **The Avalon drop/movepack items** — different project, different release
  train, and two of them wait on your rulings.
- - **MASKING-RULING tiers extract** — must come from the enclave, blessed.

## Order of operations (release-runbook; the sandbox cannot push)

1. Keeper: re-detach-sign seams SKILL.md; re-mint its whole-tree manifest.
2. Fold F1–F7 into sandboxer; re-sign that skill tree.
3. Sign the queue in QA-12 (MODEL-gates-engage-logic first — migration traffic
   leans on it, and an unsigned model everything cites is a seam with no
   tiebreaker).
4. NEWS + VERSION bump; `bin/release --apply` on the HOST (one blessed path —
   no hand-rolled wrapper; that lesson is already paid for).
5. Certification sweep 14/14; signed tag + assets to Forgejo.

sentinel: QA-13-RELEASE-0.7.0-PLAN-2026-07-13

-----BEGIN PGP SIGNATURE-----

iQGzBAEBCgAdFiEE7Od89BfHbBrPznwrW2E1URWA8AcFAmpUhcQACgkQW2E1URWA
8Acm5Qv/UhWCu3BWFt0lvy725fcPH4b49pxgeLnGaWV+AABlcRavNL4QMrgBNfSb
xypqTfeGQp4+JphHcQKVqmUWl+OhZ4pszR4wjTtt5AvVOrrhjP9x6+oSoHfFicb0
taAmjjlk52RiVq2ZpBeYtGOHvzl2zS0p67gJc5woZwKc8XNKNbQLAXwPMFie5lYn
h5lnxADBVONn7+ohsvzXe4eP/qA/yRsbnKEMjkhzkJtReQVzO6uA6khs02LH5+w9
vP3mT8J9O21Cn7rOnOJbIOtyf83O/LQ/CxqJRme5657tx29WnHQbONGNw3MbOn9z
rqeFOmGUafpqpmeFkpNyNzDlHDv5tnfJSlTbq2vGyoyn6lyJFGtBqt1cJTOKWpkM
fzbAc/UUnDGWEnyxAGswiOi4JhBxxQG7Hhg5UIHsng0SVj9U2jpH//z7WLL38L6c
MWIs9FZo5TIKrCcLrUd+sx0Ou2lNTUNuqh8zACvOW7FltLwJRGre6hu274FwSKji
98jbcPbD
=MF9w
-----END PGP SIGNATURE-----
