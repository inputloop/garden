---
name: hui
description: >-
  Read a program as a person meets it: its HUMAN-INTERFACE-MODEL (hui, lower case, a TLA). Use when a
  project arrives or changes and someone asks what it is like to use, what it looks like, what it
  remembers, how it is written, or what changed between versions; on "hui", "human interface model",
  "UI style", "what changed for the user", "read the interface". Fires the C4 spell `spells/hui/`
  (facets by both ngen extractors, a model as a book of chapters, a doubly linked journal, kept per
  project in p/PROJECT/hui/). Implicit inside tech intake (chapter 14, T4b); callable alone.
---

# hui — the interface a person meets, read twice and written down

Corwin, 2026-09-29: a sister spell to tech intake, "implicit in the intake spell but callable alone",
that looks at UI style, features, behaviours, themes, technical patterns, code form and authoring
notes, with a journal "in doubly linked form", kept per project.

**When a project should be read for its interface:** fire `c4/spells/hui/SPELL.md` with PROJECT (the
file), VERSION, HUI_HOME (`p/<project>/hui/`) and PRIOR. In short:

1. Facets: both ngen extractors on the file; keep the table only if the two agree byte for byte.
2. A count says where to look; reading says what it is. Read the lines behind any count you will
   repeat (2026-09-29: thirty "used to" lines were twenty-nine change notes).
3. The model: one chapter per facet, each with a root in the taxonomy and the tension it bears.
4. Names made on the way are checked against `c4/c/tla`.
5. One journal entry per reading, appended with `sh bin/dlink append` one at a time; a correction is
   a new entry, never an edit to an old one.

**What it is not.** Not a review of the author's choices: a choice the author states (one file, no
build step) is recorded as his, not held against the work. Not a gate.

Referents, both ways: `c4/spells/hui/` · `c4/spells/ngen/` · `c4/bin/dlink` · `c4/c/tla` ·
first run `c4/p/quantum3D5/hui/`.

Off-switch: say "no hui on this", or remove this folder.

---
Copyright (C) 2026 Corwin Brust <corwin@bru.st>.
SPDX-License-Identifier: GPL-3.0-or-later. Free software under the GNU General Public License, version 3
or (at your option) any later version, WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.

<!-- footer: minted by bin/ft1mt from conventions/house.env and conventions/FOOTERS.org; edit those, not this -->
*Version 1.0.1: edition revised from 1.0.0 on 2026-10-04; spine: 2026-09-29.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4: https://creativecommons.org/licenses/by-sa/4.0/ (scripts GPL-3.0-or-later); Mentat (for Corwin; claude-opus-5-5)
<!-- /footer -->
