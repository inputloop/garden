---
name: family-shelf
description: >-
  Share as much as possible with a named friend or peer: the two shelves (/g/dist for anyone,
  /g/dist-fam for declared friends and family), the family cut (c4 family-cut, bin/fm1ct) and the rule
  that a hold needs a written reason. Use on "send Bryant", "what can Bridget see", "rebuild dist-fam",
  "what's going on, for Bryant", "can I share this with X", "is this held back", "why didn't Y get Z",
  or whenever a draft for a peer starts listing what to put IN instead of what to leave out.
---

# family-shelf — as much as possible, and a reason for every hold

Corwin, 2026-10-10: "rebuild /g/dist and /g/dist-fam so I can send Bryant as much as possible about
what's going on here", and fix what gates "access for my friends/peers to our work-product/worked
material".

**The two shelves.** `/g/dist` (G:\dist) holds what anyone may take away: the Ghostwheel ELPA, his
published Emacs config, the mirror tools, the learning center. `/g/dist-fam` (G:\dist-fam) holds what a
declared friend or family member takes away: one folder per peer, one zip per cut, and a KEEPER note
beside each zip that never goes in it.

**Who is a peer.** A row of `c4/d/family/PEERS.tsv`: name, since, the date of the last parcel, and his
word or a signed record. Never guessed. Adding someone is his call, written as a row.

**The rule that replaced the gate.** A cut is the whole tracked tree as of a commit, less the rows of
`c4/d/family/HOLDS.tsv`. A row has a CLASS, a SOURCE and a FALSIFIER:
- BLIND: an experiment's controls, agreed with the peer or an arm (the chamber, 4blind).
- LOCAL: reading context that by his word does not ship (`d/contexts/`).
- NEVER: a file that says of itself it never travels.
His own hold list (`evidence/share-hold.tsv`) is read too, and counted, never named. "Not yet asked
about", "might be too much", "is internal" and "is half built" are not holds. If you would hold
something and cannot write its row, send it.

**How.** `sh bin/fm1ct cut PEER --out /g/dist-fam` from the C4 root (add `--work DIR` where long
commands are stopped, and run it again until done), then `sh bin/fm1ct check ZIP`. The zip carries
READ-FIRST.md (what happened since the last parcel), KEPT-BACK.md, MANIFEST.md, SHA256SUMS, git-log.txt
and handoff-zip's INDEX.md. Sending is his; hand him the zip's sha256.

**Falsifiers.** A peer's zip lacks a tracked path that no row holds. A held path, an embargoed word, a
claude.ai link or an unreviewed secret is found by `fm1ct check`. KEPT-BACK.md names a path from his
own hold list.

Referents, both ways: `c4/h/PROJ-2026-10-10-family-cut/DESIGN.md` · `c4/spells/egress/` (check 3) ·
soft skill `egress` · `c4/d/door/43-his-family-shelf.part` · `G:\dist-fam\README.md`.

Off-switch: remove this folder; the egress skill still fires.

---
Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
SPDX-License-Identifier: CC-BY-SA-4.0 (prose); scripts it names are GPL-3.0-or-later.

<!-- footer: minted by bin/ft1mt from conventions/house.env and conventions/FOOTERS.org; edit those, not this -->
*Version 1.1.1: edition revised from 1.0.5 on 2026-10-10; spine: 2026-10-10.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4: https://creativecommons.org/licenses/by-sa/4.0/ (scripts GPL-3.0-or-later); Mentat (for Corwin; claude-opus-5-5)
<!-- /footer -->
