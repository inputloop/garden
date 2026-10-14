produced-by: builder T2 (Mentat, for Corwin; claude-opus-5-5) · subject: TopoForge project files + RECIPE · 2026-10-08

# T2 hand-back — TopoForge gets its free-software project files and a recipe

## Handled
All in `$HOME/mnt/projects/topoforge/`. Nothing written in index.html, upstream/, tests/, spec/,
patches/ or $HOME/mnt/Bryant.

- README.org (what it is, open index.html from file://, exports, accessibility statement, licences,
  authors with Bryant first), AUTHORS (Bryant, then Corwin <corwin@bru.st>; makers Alfred and Mentat),
  NEWS, ChangeLog (GNU style, two entries dated today), INSTALL (nothing to install; sha256sum check;
  v1.5 sha 6a76e9ca...; gpg line for a future signed release).
- COPYING (GPL v3), COPYING.LESSER (LGPL v3), LICENSES/{GPL-3.0-or-later,LGPL-3.0-or-later,CC-BY-SA-4.0}.txt
  — copied, not moved.
- REUSE.toml: code (index.html, upstream/**, bin/**, kit/**/*.py, tests/**, patches/**) =
  GPL-3.0-or-later OR LGPL-3.0-or-later; prose (docs, spec/**, kit/**/*.org) = CC-BY-SA-4.0;
  RECIPE.org = CC-BY-SA-4.0 AND (GPL-3.0-or-later OR LGPL-3.0-or-later).
- RECIPE.org: licence/authorship header; ingredients with sha256s; tangle, verify, sums, test, ship
  steps as POSIX sh src blocks. bin/{tangle,verify,sums,test,ship}.sh are TANGLED from it.
- bin/sums.sh writes SHA256SUMS (no temp file: these mounts may not allow deleting one).
- Test kit for the scripts, per the test rule: kit/project-files/SPEC.org (its own spec) and
  check.py (Python stdlib, a language other than the sh under test), with 4 planted faults that must go red.
- SHA256SUMS written over MY files plus upstream only (20 files); index.html left out on purpose.

## OBSERVED (command -> result)
- `sha256sum upstream/topoforge-1.5.html index.html` -> both 6a76e9ca...9e2a (T1 had not changed index.html
  when I finished).
- `sh bin/tangle.sh` (bootstrapped from RECIPE.org with the sed one-liner in it) -> 5 files tangled;
  the bootstrap and the tangled tangle.sh are the same bytes.
- `PYTHONDONTWRITEBYTECODE=1 python3 -I kit/project-files/check.py` -> first run RED "T3 committed
  bin/sums.sh differs from RECIPE.org" (a real catch: I had edited the recipe after tangling); after
  re-tangle -> "GREEN tangle, sums, verify; 4 planted faults all seen", exit 0.
- `sh bin/verify.sh` -> "OK upstream ... v1.5", "OK every file in SHA256SUMS matches (20 files)", exit 0.
- `sh bin/test.sh` -> "NOT BUILT: tests/ ... builder T1 ... not here yet", kit green, exit 2 (honest: not 0).
- `reuse lint` (reuse installed in a venv outside the mounts) -> "compliant with version 3.3 of the
  REUSE Specification", 15/15 files with copyright and licence.
- `grep` in v1.5: About box says "Version 1.0" (index.html l.2341); 22 `aria-` attributes, 1 `aria-live`.
- `tavern_drops` -> "Cannot reach the Tavern node on this machine ... refused". Alfred's release notes
  (TopoForge-results.md) were not readable; a grep of Bryant/chat, from, tavern found no copy.
- `find . -name __pycache__` in the project -> none.

## JUDGED
- NEWS 1.0-1.4 are left as "waiting for Alfred's notes" rather than guessed. 1.5 is described from the file
  itself. [MINE] Falsifier: Alfred's notes list 1.5 features I did not, or vice versa.
- NEWS 1.6 describes T1's planned work (story panel, Markdown export, tf_ref handles) and says it is
  unfinished. [MINE] Falsifier: T1's shipped file differs; NEWS must be re-read against it before release.
- Accessibility statement says only what was observed (shortcuts exist, some aria) and names what is not
  checked (keyboard-only drawing on the canvas). [DOMAIN] Falsifier: a keyboard-only walk-through of
  open/draw/name/connect/export.
- Visio 2010 "light-tested on avalon" is written as reported, not observed by me. [MINE]
- REUSE.toml pre-covers tests/** and patches/** as code and spec/** as prose. [MINE] Falsifier: T1
  puts prose in tests/ or code in spec/; then that path's line moves.
- bin/test.sh runs tests/run.sh if present, else every tests/*.sh. [MINE] Falsifier: T1's tests/ holds
  helper .sh files that are not entry points — then T1 should add tests/run.sh.
- bin/ship.sh uses GNU tar --transform (fine on msys2 and Linux; not on BSD tar). Not run: it would create
  dist/ and a tarball nobody asked for yet.
- Emacs tangling (C-c C-v t) not tried (no Emacs in this shell); the kit compares tangle.sh to a Python
  second reader, not to Emacs. Expected to agree; untested.

## Pending
- At ship: `sh bin/sums.sh` with no arguments (full list incl. index.html), then `sh bin/verify.sh`,
  `sh bin/test.sh` must exit 0 (needs T1's tests/), then `sh bin/ship.sh 1.6`; Corwin signs.
- RECIPE.org ingredients: index.html's sum is "working copy, recomputed at ship".
- NEWS 1.0-1.4 from Alfred's TopoForge-results.md once the Tavern is up.
- For T1: confirm tests/ entry point; consider bumping the About box version.

## Pending for Bryant (not taken on)
- The About box in his 1.5 says "Version 1.0".
- index.html carries no licence/copyright line inside the file; REUSE.toml covers it from outside. Whether
  to add an SPDX comment at the top of index.html is his call (and T1's file today).
- His release notes for 1.0-1.4, if he wants them in NEWS.
