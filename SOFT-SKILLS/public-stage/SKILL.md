---
name: public-stage
description: >
  The house's standard form for a new standalone project that others may contribute to: a public git stage on
  code.bru.st (mirrored to GitHub), a private .house/ side kept out of git, three models (the project's own, a
  sensitivity file doubly linked to what needs care, and a public MODEL.org), GPL-3.0-or-later code with CC BY-SA 4.0
  prose, a literate single file where that makes sense, and checks that are few, provable red, and easy to switch
  off. Use when starting or carving out a project ("make it a standalone project", "a public stage", "new repo",
  "put it on code.bru.st", "mirror to GitHub", "three-phase model"), or when tidying one before its first push.
---

# public-stage — a new project, in the house's standard form

Corwin, 2026-10-04: "we are going to be migrating most things that it might make sense for someone else to
contribute toward granularly to being public stages and standalone projects (mostly literate ones unless it just
doesn't make sense to do things literate style ...) ... work via code.bru.st ... build up my newish user page on
Github as the more visible surface ... a very standard form until/unless projects have some other logical home
(e.g. Savannah)."

Soft, until it shows use: the first two uses were egad and the mini-C4 game (Word Garden), 2026-10-04.

## The form (each line is something you can check)

1. **One folder, one git repository, the public stage.**  `git init -b master`; the first commit is the material as
   found, byte for byte, so later commits read as diffs.  Commits carry the author as the person and the
   attribution the keeper asked for (an `Assisted-by:` line naming the agent and model is the common form);
   never a link to an AI vendor's session pages.
2. **A private side, `.house/`, in `.gitignore`.**  It holds the verbatim prompts (`.house/q/`), the worked readings
   (`.house/h/REFORMAT-*`), copied personal data (`.house/data/`, with a README saying where each came from), the
   internal model and the sensitivity file.  Check: `git ls-files | grep -c '^\.house/'` prints 0.
3. **Three models** (his "three phase" trick):
   - `.house/model.md`: speaks from what we are building, exhaustively, for us.
   - `.house/SENSITIVE.md`: every place that needs care, one row each (S1, S2, ...), naming the referent's home;
     each place that points at it carries `[S#]`.  A small script checks both directions (egad's
     `.house/sensitive-links.sh`, with `--prove-red`).
   - `MODEL.org`: the public model, shareable without restriction, carrying none of the sensitive specifics.
4. **Licences:** `COPYING` (GPL-3.0-or-later, the code) and `LICENSE` saying prose is CC BY-SA 4.0; third-party
   data named with its licence and any notice it requires (WordNet's must travel with copies).
5. **`.gitignore` from the start:** `.house/`, `dist/` (generated), `__pycache__/`, `*.pyc`, fetched caches.
   (Learned 2026-10-04: a `.pyc` slipped into egad's second commit.)
6. **Literate where it makes sense:** one Org file a person edits; tanglers (Emacs `org-babel-tangle`, and a
   non-Emacs one such as egad's `jit/unpack.py`) write the other formats, and a test insists they agree.
7. **Checks:** few; each guards a promise to a person; each has `--prove-red`; each prints NOT CHECKED, never a
   pass, when its tool is missing; a named off switch for any that is not a promise to a person.  A slow check
   that already passed on exactly this content may be skipped (AS4CE0001's `bin/ck1sk`).
8. **Before the first push:** a secrets read over `git ls-files` (AS4CE0001's `bin/sb1rn`), and a leak read over
   `git archive HEAD` (paths, addresses, IPs) whose hits are each either an intended example or fixed.
9. **Remotes:** `origin` = `ssh://forgejo@code.bru.st/corwin/<name>`; the repository is created on code.bru.st by
   the keeper; a push mirror to `github.com/<his user>/<name>` is set in the Forgejo repository's settings.
   Projects with another logical home (Savannah) follow that home's form instead.

## Without the house's tools

Every step above runs with git, a shell and Python.  Where a step names a house tool (`ck1sk`, `sb1rn`,
`sensitive-links.sh`), its job is stated, so another tool can do it.

## How this skill can fail (falsifiers)

- A tracked file under `.house/` (check 2).
- A `[S#]` tag with no row, or a row with no tag.
- A public model that names a person, a device model, a real address or a key.
- A check that cannot go red.

---
Copyright (C) 2026 Corwin Brust <corwin@bru.st>.  Authored by Mentat (for Corwin).  CC BY-SA 4.0.

<!-- footer: minted by bin/ft1mt from conventions/house.env and conventions/FOOTERS.org; edit those, not this -->
*Version 1.0.1: edition revised from 1.0.0 on 2026-10-05; spine: 2026-10-04.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4: https://creativecommons.org/licenses/by-sa/4.0/ (scripts GPL-3.0-or-later); Mentat (for Corwin; claude-opus-5-5)
<!-- /footer -->
