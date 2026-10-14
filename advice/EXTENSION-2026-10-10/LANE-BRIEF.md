# Lane brief: build the extension edition (spell "extension", chapter 5)

You are one of four builders, each in its own lane. The lanes run at the same time in one git tree.

## Access
- Use only `mcp__remote-devices__device_bash`; load it with ToolSearch
  "select:mcp__remote-devices__device_bash".
- Work in `$HOME/mnt/AS4CE0001`, the garden. The C4 tree is `$HOME/mnt/c4`.
- Local Read/Write/Bash act on a different machine. Never use them for these files.
- Keep each call under 100 s; pass timeout_ms up to 180000 for test runs.
- Edit files in place with python or sed read-modify-write. Never re-type a file from tool output.

## Read first
- `advice/EXTENSION-2026-10-10/DESIGN-extension-edition.md`, all of it. Your lane's table in §3
  and the contracts in §2 are your job.
- `$HOME/mnt/c4/spells/build-turn/SPELL.md` and `dist/vibrobeast/skills/build-loop/SKILL.md`: one
  DESIGN, a QA plan written before the build, the build, QA passes, then a swing.
- `$HOME/mnt/c4/spells/extension/SPELL.md`, chapter 1 (Corwin's own words) and chapter 7
  (falsifiers).
- The cards your tasks cite, in `$HOME/mnt/c4/spells/extension/runs/2026-10-10/cards/`.

## Rules
1. **Stay in your lane.** Touch only the files your lane's tasks name, plus new files under
   `tests/`, `bin/` or `conventions/` that your tasks create. If you need a change in another lane's
   file, write it as a request in `advice/EXTENSION-2026-10-10/REQUESTS-lane-<X>.txt` and carry on.
2. **Spec first.** For every task, write the SPEC line(s) first, then the test, then the code.
   - Each test must go red when its plant is in. Run `--prove-red` and show it going red.
   - Use the test language the design names for each task: Tcl, Ruby or awk where the fault escaped
     before. Python unit tests go in `tests/test_mcp_*.py`.
3. **R-rows.** Do not edit `polygram/mcp/__main__.py`. Write your rows (number, the sentence, the
   check code) into `advice/EXTENSION-2026-10-10/R-ROWS-lane-<X>.txt` for the conductor.
4. **ChangeLog.** Do not edit `ChangeLog`. Write GNU-style entries into
   `advice/EXTENSION-2026-10-10/CHANGELOG-lane-<X>.txt`.
5. **No git commit, no `make dist`, no install, no signing.** If a signed file must change, archive
   the old signed copy beside it (`<name>.signed-<date>`), make the change, and list it under
   "re-sign owed" in your hand-back.
6. **Footers.**
   - New prose: "Authored by Mentat (for Corwin; claude-opus-5-5)." then
     "Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors." then
     "SPDX-License-Identifier: CC-BY-SA-4.0".
   - New code: the same, with SPDX `GPL-3.0-or-later OR LGPL-3.0-or-later`.
   - Match house.env / ft1mt if a tool mints footers.
7. **No retired bracket tags.** ([HIS], [DOMAIN], [SKILL], [PLATFORM], [MINE]) Cite sources instead.
8. **Docs as you go.** Update the docs and the GRAMMARY request for any term you add: lane C owns
   GRAMMARY.md, so the other lanes put new terms into REQUESTS for lane C.
   - Plain words. Explain each tool code on first use, e.g. "st1dt (the seating detector)".
9. **Never read or list** `.keys/`, `*.secret`, `.house/`, `c4/Z/`, `c4/a/`, `c4/p/`, SAVANNAH, or
   `.patternwalk/`. Corwin, 03:45, on `.patternwalk/`: "This is the only session they have been mounted
   to, not inside our scope for seating." So the seating tools treat the recordings as out of scope, not as secret. At 03:47 he added that any ingest of them goes through a future tool, whose output (or MCP surface) is what may be seated; that tool is not in this edition.
10. **Local model** (optional, for drafting or as a first reader). Use
    `mcp__remote-devices__plugin_vibrobeast_llamabridge__delegate_async` then `delegate_result`
    (gemma4:12b-8k, think "false").
    - One call at a time: other lanes share the GPU. Poll from 60 s.
    - Record what it did in your hand-back.
11. **Run the existing suites your files touch** before and after your work.
    - The baseline: `python3 -m polygram.mcp --prove-red` and the relevant tests/*.
    - Report both runs.

## Hand-back
- Write `advice/EXTENSION-2026-10-10/HANDBACK-lane-<X>.md` with these parts:
  - per task: done / partial / not started;
  - files changed;
  - tests, with their green and prove-red output lines;
  - re-sign owed;
  - requests to other lanes;
  - anything that surprised you.
- OBSERVED (with command) apart from JUDGED, each judgement with a falsifier.

Authored by Mentat (for Corwin; claude-opus-5-5).
Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
SPDX-License-Identifier: CC-BY-SA-4.0
