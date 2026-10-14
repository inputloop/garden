# Lane C: design notes and QA plan, written before the build (2026-10-10)

*The build-loop shape for lane C's five tasks (DESIGN-extension-edition.md §3, Lane C). Each task: the SPEC
line first, then the test, then the code, then `--prove-red`.*

| task | SPEC line (written first) | test, language, plant | QA pass |
|---|---|---|---|
| C1 licence | "Writing ships CC-BY-SA-4.0; a prose file never carries a code licence; CC BY 4.0 appears only beside the TA model." | `tests/lc1ck-spec.rb` (Ruby; work is sh+awk) via `tests/lc1ck-tests.sh --prove-red`; plants: "CC BY 4.0" writing line in a scratch ToS; GPL SPDX on a scratch `.md` | `tests/tp2mt-tests.sh` green; lc1ck run on the live shelf, counts read back |
| C2 release | "No NEWS entry and no reason line refuses the release; a reason line lands in NEWS in plain words." | `tests/release-gate-spec.tcl` (Tcl; work and earlier tests sh) via `tests/release-gate-tests.sh --prove-red`; plants: no NEWS + no reason; a retired bracket tag; a GPL line on prose | `tests/release-gates-tests.sh` green; NEWS-lag gauge on the live tree |
| C3 README | "Every number and table about servers, the floor and preference keys in the minted README comes from SERVERS, editions.FLOOR and prefs.KNOWN." | `tests/readme-count-spec.awk` (awk; work and earlier tests Python) via `tests/readme-count-tests.sh --prove-red`; plant: a seventh server, the README must change; a typed "three servers" in shipped prose | `tests/test_plugin.py`, `tests/test_plugin_imports.py`, `tests/test_editions.py` green |
| C4 GRAMMARY | "Every entry has a 'whose word' line; gm1gk counts and never fails." | `tests/gm1gk-tests.sh --prove-red` (sh; the gauge is awk): a planted entry without "whose word" moves the count | QA-2: the local model reads the new entries cold, flags unclear words |
| C5 upgrades, hooks, NOTICE | "The gauntlet NOTICE names the version its SKILL.md carries; one countable row per hook." | `tests/notice-version-tests.sh --prove-red` (awk): a planted 1.4 goes red; a hooks row count | `test_vendored_bytes` green (Bryant's bytes untouched) |

Swing: none of this edits Bryant's bytes, `__main__.py` or `ChangeLog`; every change is backed out by
restoring the archived or git copy.

Authored by Mentat (for Corwin; claude-opus-5-5).
Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
SPDX-License-Identifier: CC-BY-SA-4.0
