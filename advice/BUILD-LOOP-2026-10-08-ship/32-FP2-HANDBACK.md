produced-by: FP2 (Mentat for Corwin; claude-opus-5-5) · 2026-10-08 · fixer for FOLD-QA2 rows 4, 6, 7, 13, 14
SPDX-License-Identifier: CC-BY-SA-4.0

# FP2 hand-back: FOLD-QA2 rows 4, 6, 7, 13 and 14

All five rows are fixed in AS4CE0001. Nothing was committed, installed or enabled, and `make dist`
was not run. Nothing was written under Bryant/. Every test listed below is green.

## What was handled

| row | what changed | where |
|-----|--------------|-------|
| 4 | The pasted chat transcripts at the tree root are now ignored by git. Each file is named in a dated comment. None was moved or deleted. | .gitignore (new block at the end) |
| 6 | The plugin now calls the patched Tavern "2.3.1+gp.1", matching garden-pony. The test now checks for that exact wording. | polygram/mcp/tavernface.py:51, tests/tavernface-tests.sh:55, tests/tavernface-SPEC.txt F1 |
| 7 | c4face now decodes escaped spellings before it matches anything. This covers names and strings written with \uXXXX, \u{..} or \x, and legacy octal. A name escape it cannot read now counts as a hit. 16 new evasions were planted, and a sixth prove-red plant was added. c4face is still off by default. | polygram/mcp/c4face.py (`js_unescape`, `_ESC`, `_ID_ESC`, the identifier reader, `scan_js` kind "bad"), tests/c4face-tests.sh, tests/c4face-SPEC.txt C11 + R |
| 13 | The GIZA card no longer has the stale __pycache__ check. A new step 3 checks that the .plugin is the NEW build before anything is installed. Step 5 adds a matching sha check on GIZA. Steps 4-6 were renumbered. | CARD-giza-launch.md |
| 14 | The llamabridge test files now pass `encoding="utf-8"` (and `newline="\n"` on writes). The register got back its row for the SOFT-SKILLS copy of build-loop. | tests/test_llama_bridge_vb.py, tests/test_mcp_llamabridge.py, conventions/FOOTERS.org:16 |

## OBSERVED (commands and results)

Row 4
- I read the first lines of each root `*.txt`. All are pasted chat text or pasted bits: Claude Desktop
  transcripts, your prompts, a lyrics page, a Discord link. c20.txt is a third party's e-mail address
  and phone number.
- The new lines are `/c.txt`, `/c[0-9]*.txt`, `/[0-9]*.txt` and `/fix-comic-rewrite-session-improve-orgvm.txt`.
  They match only at the root.
- `git check-ignore` says c.txt, c20.txt, 21.txt and fix-comic-...txt are ignored. The tracked
  `fix-comic-...REWRITE.txt` is not matched.
- `git ls-files -ci --exclude-standard` prints nothing, so no tracked file is newly ignored.
- `git status --porcelain -- '*.txt'` now lists only 3 untracked .txt files: tests/c4face-SPEC.txt,
  launch-cmd-SPEC.txt and tavernface-SPEC.txt. These are new test specs, not transcripts.

Row 6
- `grep -rn '+gp'` over the plugin found the old wording in one place only: tavernface.py:51.
- I tested the new check against the old sentence by hand, and it fails, as it should.
- `sh tests/tavernface-tests.sh`: GREEN 7/7. `--prove-red`: PROVE-RED PASS (3 plants).

Row 7
- Before the fix, the old guard (a saved copy) passed all six of these with zero hits:
  `require("fs")`, `x["\x63onstructor"]`, `pr\u{6f}cess.env`, `ev\u{61}l(1)`,
  `globalThis`, `x["constructor"]`.
- After the fix, each one gives a hit: "require of fs", "the string 'constructor'", "process.env",
  "eval", "globalThis".
- `process[`env`]` was already caught before this fix, as "process used directly".
- `a\x62c` gives "an escaped name this check cannot read".
- These clean lines give no hit: `"café \n \"q\" \\"`, `process.stderr.write("A")`, a
  line continuation, and `/A/`.
- `sh tests/c4face-tests.sh`: GREEN.
  - C11 now plants 40 evasions (20 lines, each into c4-mcp.js and into a lib).
  - C3 (the real C4 tree at mnt/c4) still starts, so there is no false alarm on what C4 really is.
  - M1 mint: PASS.
- `sh tests/c4face-tests.sh --prove-red`: "PROVE-RED PASS: all six plants went red".
  - The new plant (f) makes `js_unescape` return its input undecoded. That gives "4 planted
    evasion(s) missed".
  - The old-regex plant (d) now misses 64.

Row 13
- The old dist/vibrobeast.plugin (08:05, sha256 67fa5edf...) already says `"version": "1.0.4"`, so the
  version alone cannot tell the old build from the new one. The card says so.
- I ran the card's step-3 line exactly as pasted:
  - on the old plugin: `new files: 0 of 2; servers started by cmd: 0 of 6`, and the .mcp.json sha is `0829ef21b589...`;
  - on a scratch cmd-shape mint I made outside the tree (`plugin.mint_plugin(..., launch="cmd")` into
    $HOME/fp2mint, not dist/): `2 of 2; 6 of 6`, and the .mcp.json sha is 9d7b546d... So the
    line tells the two builds apart.

Row 14
- Before: `python3 -m unittest tests.test_bytes_boundary tests.test_ft1mt` -> FAILED (failures=2).
  The boundary failures were 13 lines in the two llamabridge test files. The ft1mt failure was that
  ('SOFT-SKILLS','build-loop') had no row.
- What ft1mt shows: commit 8b1100b "graduated to skills/ (ss2gr)". The FOOTERS row was moved from
  SOFT-SKILLS to skills.
- What ss2gr's own header says: graduation "leaves the soft copy in place (the dynaloader shadows it)".
- The soft copy's body sha is still `24e18cc792ac`, which matches its row at 1ecefe3. I put that row
  back, word for word.
- After: the same two modules -> `Ran 10 tests ... OK`. `sh bin/ft1mt check` -> "85 row(s); every
  footer is as minted". `sh bin/ft1mt --prove-red` -> "every planted fault caught".

Runs (all with PYTHONDONTWRITEBYTECODE=1)
- Every CHECK line in QAPLAN-plugin passed with rc=0: tp2mt --check, tp2mt-tests (TOTAL pass=17
  fail=0), tavernface-tests, pn1ck check (1 pin, all match), launch-cmd-tests, c4face-tests.
- The QAPLAN-plugin WARN line passed: no __pycache__ newer than releases/1.0.3.
- The full Python suite, run one file at a time: **40 files, 518 tests, 0 failures, 0 errors.**
  test_plugin alone takes 123 s.
- A `polygram/mcp/__pycache__/c4face.cpython-310.pyc` showed up at 16:37:29Z, and I removed it. The
  device runs Python 3.10, so it may have come from one of my runs, even though every run set the
  variable. I did not find out which. Afterwards, `find . -name __pycache__ -newer releases/1.0.4`
  (not counting dist/) printed nothing.

## JUDGED

- [MINE] For row 14 I fixed the register, not the test. The two tools disagree here. ft1mt checks
  "has a row" by name only. The Python test checks it by folder and name. ss2gr means the soft copy
  to stay. Without a row, nothing checks that copy's footer. Falsifier: if you mean graduated soft
  copies to go once you allow deletes, take out FOOTERS.org line 16 when the folder goes.
- [DOMAIN] c4face is still a tripwire, not a fence. A computed name (`"constr" + "uctor"`) still gets
  through, and the docstring still says so. The fix closes escaped spellings and nothing more.
- [PLATFORM] The device_bash transport turns `\uXXXX` in a command into the real character. I first
  wrote test inputs that way, and they arrived already decoded, so I built every test input with
  chr(92) instead. Before finishing, I checked that c4face.py is plain ASCII with its escapes intact.
  Builders who write escaped JS through this tool will hit the same trap.
- [MINE] The card's step-3 line needs `unzip` in MSYS2. The card says `pacman -S unzip` if it is
  missing.

## For Corwin (not run): what to track before the vibrobeast push

New plugin sources, kits and skills that are untracked now and should be tracked:

    git add -- bin/pn1ck polygram/launch.cmd polygram/mcp/NOTICE-tavern polygram/mcp/c4face.py polygram/mcp/tavern_upstream.py polygram/mcp/tavernface.py releases/1.0.3 releases/1.0.4 skills/build-loop/.signature.asc skills/llama-bridge/.signature.asc skills/llama-bridge/.skill-manifest skills/vibrobeast/.signature.asc skills/vibrobeast/.skill-manifest skills/garden-pony skills/topoforge-story tests/c4face-SPEC.txt tests/c4face-tests.sh tests/fixtures/c4face tests/launch-cmd-SPEC.txt tests/launch-cmd-tests.sh tests/makefile-bytecode-tests.sh tests/tavernface-SPEC.txt tests/tavernface-tests.sh

The advice papers below are also untracked. The tree already tracks 512 advice files, so these would
normally go in too. They are your call, and they hold QA text about your own setup:

    git add -- advice/BUILD-LOOP-2026-10-08-ship advice/LENS-2026-10-08-topo-pony advice/20261008-044039Z-dist-polygram-curation.md advice/20261008-080523Z-dist-polygram-curation.md advice/GRAIN-2026-10-06-rescan/CORWIN-DELTA-2026-10-06.md.asc

Your existing changes to tracked files are still uncommitted. FP2's own changes to tracked files
are in .gitignore, conventions/FOOTERS.org and the two llamabridge tests. FP2's other edits are to
files the first line above adds: tavernface.py, c4face.py and the c4face and tavernface kits.

## Still open (not FP2's)
- Row 17: the installable plugin is still the 08:05 build. It waits on your `make dist`, and card
  step 3 now catches it.
- Rows 1-3, 5 and 8-12 belong to other fixers.
