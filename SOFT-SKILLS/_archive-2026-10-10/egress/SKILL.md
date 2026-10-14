---
name: egress
description: >-
  At the way out, the checks ride with the thing leaving. Use whenever something is about to leave
  the machine or the tree: a zip for a lab partner, a cast of the tree, a git push, a page for the
  publication shelf, a mail, a "send this to Bryant", "package this up", "publish", "push", "cast".
  Fires the C4 spell `spells/egress/` (what never travels, secrets, terms, the MANIFEST, whole
  verdicts, and the same checks again once it is done). Implicit: no one needs to ask for it.
---

# egress — the third actor carries the checks

Corwin, 2026-09-26: two actors witness each other in doubly linked pairs (PERSONA and SKILL; MEMORY and
LOG); "the third actor is the egress, which is the solution to keeping the other two N(1) in terms of
lookups, checks included." So the checks live here, at the way out, and nowhere in the middle.

**When something is about to leave:** fire `c4/spells/egress/SPELL.md` with WHAT and TO. In short:

1. Leave out what never travels (`Z/chatlog/`, `.private`, `chamber/`, anything cleared for one place).
2. `c4 secrets-run WHAT`; a hit stops it.
3. Terms: TERMS v1 for his work (`c4/man/licensing-defaults.md`); others keep theirs.
4. `MANIFEST.md` and `SHA256SUMS` beside it (kind MANIFEST in `c4/c/kinds`).
5. Read every verdict whole: "NOT checked" is not CLEAN.
6. One line in the run record; then run steps 1, 2 and 4 again on what actually left.

**What it is not.** Not a gate on reading, building or editing inside the tree: in the middle, work
freely. Not a signing step: signing is Corwin's pen.

Referents, both ways: `c4/spells/egress/` (the spell names this skill) · `c4/model.md` "Current work"
(the three actors) · `c4/c/kinds`.

Off-switch: say "no egress check on this", or remove this folder.

---
Copyright (C) 2026 Corwin Brust <corwin@bru.st>.
SPDX-License-Identifier: GPL-3.0-or-later. Free software under the GNU General Public License, version 3
or (at your option) any later version, WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.

<!-- footer: minted by bin/ft1mt from conventions/house.env and conventions/FOOTERS.org; edit those, not this -->
*Version 1.0.1: edition revised from 1.0.0 on 2026-10-04; spine: 2026-09-26.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4: https://creativecommons.org/licenses/by-sa/4.0/ (scripts GPL-3.0-or-later); Mentat (for Corwin; claude-opus-5-5)
<!-- /footer -->
