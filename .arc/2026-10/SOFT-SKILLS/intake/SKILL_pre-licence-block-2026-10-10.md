---
name: intake
description: >-
  At the way in, the gate rides with the thing arriving. Use whenever material arrives to be brought
  into the tree: a lab partner's drop, a chat export (Discrub HTML, a claude.ai account export or its
  download manifest), an archive, a saved web page, a working project, "ingest this", "cast this",
  "intake", "here is the export", "Bryant sent". Fires the C4 spell `spells/ingest/`, whose source
  chapters pick the reader. Implicit: no one needs to ask for it.
---

# intake — the gate at the way in

The counterpart of `egress`. Egress carries the checks out; intake carries the gate in. Between the
two, work freely.

**When something arrives:** fire `c4/spells/ingest/SPELL.md` with DROP and SOURCE. In short:

1. Land the bytes as they arrived, under `from-<source>/$S/`; hash them (`SHA256SUMS`).
2. Measure, do not read: sizes, hashes, names, counts, and the reader's `shape` where it has one.
3. `c4 intake check`, then `c4 intake accept`. Only then is anything read.
4. Provenance, then atoms; then what goes back to the source.

**Which reader** (the spell's source chapters):

| arrives as | reader | chapter |
|---|---|---|
| Discrub export of a Discord DM (HTML) | `c4/bin/dm1rd read` | the spell's main steps |
| claude.ai account export: a `manifest-*.json`, then category zips | `c4/bin/cx1rd manifest`, `shape`, `book` | "Source: a claude.ai data export" |
| a working technical project | its own build and tests | "Source: technical projects" |
| a saved web page (`X.html` + `X_files/`) | split the two authors first | "Source: saved web pages" |

**For a lab partner, it is a loop.** The spell's chapter "The loop" carries a partner's drop all the way:
land it in the garden (`externs/<partner>/`, candidates only), build what it asks for with prove-red,
and cut what goes back with the lab-kit recipe (`projects/lab-kit/`), zipped for the keeper by default.
Sending stays his.

**Two rules that ride with every drop.** A download link, token or key in a drop is a key, not a
fact: it is withheld from every shop file (`cx1rd manifest` does this for the export manifest;
`ke1id scan` finds the rest by kind, without printing them). And a person's words keep their owner:
quoting needs that person's row, paraphrase does not.

**What it is not.** Not a reading of the material: it decides when reading may start. Not a judgement
of what the keeper may say or keep: his words are his.

Referents, both ways: `c4/spells/ingest/` (the spell names this skill) · `c4/bin/dm1rd` ·
`c4/bin/cx1rd` · `SOFT-SKILLS/egress/` (the way out).

Off-switch: say "no intake gate on this", or remove this folder.

---
Copyright (C) 2026 Corwin Brust <corwin@bru.st>.
SPDX-License-Identifier: GPL-3.0-or-later. Free software under the GNU General Public License, version 3
or (at your option) any later version, WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.

*Version 1.0.0: first edition on 2026-10-06; spine: 2026-10-06.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4: https://creativecommons.org/licenses/by-sa/4.0/ (scripts GPL-3.0-or-later); Mentat (for Corwin; claude-opus-5-5)
