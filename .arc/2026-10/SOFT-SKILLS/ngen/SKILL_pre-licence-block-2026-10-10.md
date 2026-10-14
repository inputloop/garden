---
name: ngen
description: >-
  Programs that write programs, twice: from one data spec, two generators written apart in two
  languages each write an extractor, and the two extractors must print the same bytes. Use when a
  task can be written as a spec (what to find, what to print) and its answer should not rest on one
  program; on "ngen", "generate the program", "two means, two tests, two specs", "programs generating
  programs", "agreement test", "shared regex dialect". Fires the C4 spell `spells/ngen/` (spec one,
  spec two worked by hand, the ladder of rungs 0-8, mutants). Not Microsoft's ngen.exe.
---

# ngen — two means, two ways to test, two specs

Corwin, 2026-09-29: "the great feat: we must see if our programs can generate programs ... two means
to solve a given problem, two ways to test them, two specs", with the testing growing as the resume
mounts.

**When a job can be a spec:** fire `c4/spells/ngen/SPELL.md`. In short:

1. Spec one says what (rows of FACET KEY KIND PATTERN NOTE); spec two is the answer on a small fixture,
   worked by hand before either program runs, and grows with dated notes.
2. Two generators, no shared code, two languages (`bin/ngen-aw` sh+awk, `bin/ngen-py` Python); both
   refuse a pattern outside the shared dialect, with the same words, first fault left to right.
3. Two tests: agreement (A equals B) and expectation (each equals spec two), each shown red.
4. The ladder (`tests/ngen-spec.py`): rung 0 names the awk; rung 8 fuzzes patterns and lines.
5. Mutants (`--mutant`): every planted fault caught, or a line in Changes saying why not.

**Known.** mawk 1.3.4 matches short on some list patterns and panics on `$(z)+`; the awk half is for a
POSIX awk (the lab runs gawk). The name ngen is also .NET's Native Image Generator; see `c4/c/tla`.

Referents, both ways: `c4/spells/ngen/` · `c4/p/C4/ngen/DESIGN-2026-09-29-ngen.md` · `c4/spells/hui/`.

Off-switch: say "no ngen on this", or remove this folder.

---
Copyright (C) 2026 Corwin Brust <corwin@bru.st>.
SPDX-License-Identifier: GPL-3.0-or-later. Free software under the GNU General Public License, version 3
or (at your option) any later version, WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.

<!-- footer: minted by bin/ft1mt from conventions/house.env and conventions/FOOTERS.org; edit those, not this -->
*Version 1.0.1: edition revised from 1.0.0 on 2026-10-04; spine: 2026-09-29.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4: https://creativecommons.org/licenses/by-sa/4.0/ (scripts GPL-3.0-or-later); Mentat (for Corwin; claude-opus-5-5)
<!-- /footer -->
