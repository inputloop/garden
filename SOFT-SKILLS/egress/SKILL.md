---
name: egress
description: >-
  At the way out, the checks ride with the thing leaving. Use whenever something is about to leave
  the machine or the tree: a zip for a lab partner, a cast of the tree, a git push, a page for the
  publication shelf, a mail, a "send this to Bryant", "package this up", "publish", "push", "cast".
  Fires the C4 spell `spells/egress/` (what never travels, secrets, terms, the MANIFEST, whole
  verdicts, and the same checks again once it is done). For a declared friend or peer the parcel is
  the whole tree less reasoned holds (`c4 family-cut`). Implicit: no one needs to ask for it.
---

# egress — the third actor carries the checks

Corwin, 2026-09-26: two actors witness each other in doubly linked pairs (PERSONA and SKILL; MEMORY and
LOG); "the third actor is the egress, which is the solution to keeping the other two N(1) in terms of
lookups, checks included." So the checks live here, at the way out, and nowhere in the middle.

**When something is about to leave:** fire `c4/spells/egress/SPELL.md` with WHAT and TO. In short:

1. Leave out what never travels (`Z/chatlog/`, `.private`, `chamber/`, `d/contexts/`, anything
   cleared for one place); `c4 embargo WHAT` for his embargoed words.
2. `c4 secrets-run WHAT`; a hit stops it unless it is reviewed in `c/secret-reviewed`, bound to its
   path, line and line sha.
3. Terms: TERMS v1 for his work (`c4/man/licensing-defaults.md`); others keep theirs. 3a: no claude.ai
   links or Claude-aimed text unless asked for or the thing is itself such text.
4. `MANIFEST.md` and `SHA256SUMS` beside it (kind MANIFEST in `c4/c/kinds`).
5. Read every verdict whole: "NOT checked" is not CLEAN.
6. One line in the run record; then run steps 1, 2 and 4 again on what actually left.

**When TO is a friend or peer** (a row of `c4/d/family/PEERS.tsv`): `sh bin/fm1ct cut PEER` onto
`/g/dist-fam/PEER/`. The parcel is the whole tracked tree as of a commit, less the rows of
`d/family/HOLDS.tsv`, each with a class (BLIND, LOCAL, NEVER), who says so, and what opens it. "Not
yet asked about" is not a hold: an allow-list for a peer is the fault this rule replaced (his ask,
2026-10-10: "as much as possible"). Embargoed lines and claude.ai links are replaced, not whole files
dropped. On a host that stops long commands, add `--work DIR` and run it again until it says done.

**What it is not.** Not a gate on reading, building or editing inside the tree: in the middle, work
freely. Not a signing step: signing is Corwin's pen. Not a send: the zip is made for the keeper.

Referents, both ways: `c4/spells/egress/` (the spell names this skill) · `c4/model.md` "Current work"
(the three actors) · `c4/c/kinds` · soft skill `family-shelf` · `c4/d/door/43-his-family-shelf.part`.

Off-switch: say "no egress check on this", or remove this folder.

---
Copyright (C) 2026 Corwin Brust <corwin@bru.st>.
SPDX-License-Identifier: GPL-3.0-or-later. Free software under the GNU General Public License, version 3
or (at your option) any later version, WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.

<!-- footer: minted by bin/ft1mt from conventions/house.env and conventions/FOOTERS.org; edit those, not this -->
*Version 1.1.2: edition revised from 1.0.1 on 2026-10-10; spine: 2026-09-26.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4: https://creativecommons.org/licenses/by-sa/4.0/ (scripts GPL-3.0-or-later); Mentat (for Corwin; claude-opus-5-5)
<!-- /footer -->
