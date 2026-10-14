produced-by: P2 (Mentat for Corwin; claude-opus-5-5) · 2026-10-08 · task plugin, items 2 and 3 of DESIGN-plugin.md
SPDX-License-Identifier: CC-BY-SA-4.0

# P2 hand-back — the Windows launch that finds Python by itself, and c4face

## What we handled
1. **Windows launch (item 2).** A plugin minted on a Windows machine now starts each server as
   `cmd /d /c ${CLAUDE_PLUGIN_ROOT}\servers\launch.cmd NAME`. `servers\launch.cmd` (new, shipped in
   every mint) finds a Python 3.8+ by RUNNING candidates in this order: VIBROBEAST_PYTHON; `py -3`;
   every `python3` then `python` on PATH, skipping anything under `\WindowsApps\`; `C:\msys64\`
   ucrt64, mingw64, clang64 (python3.exe, then python.exe); `%LOCALAPPDATA%\Programs\Python\Python3*`;
   `%ProgramFiles%\Python3*`. Then `"<python>" -B "<here>launch.py" "NAME"`. It says on stderr which
   Python it chose (the Desktop log keeps it), or one sentence naming python.org / MSYS2 to install.
   Nobody edits JSON. Modeled on Bryant's Tavern-Setup `:TVL_FIND`/`:TVL_TRY`, credited in the file.
2. **c4face (item 3).** A sixth server. It finds the person's C4 tree and a node, then hands its
   stdio to `node <c4>/mcp/c4-mcp.js` -- C4's own server answers, with C4's own tools. Nothing of C4
   is copied in. Missing C4 or node: one tool, `c4_status`, in plain words, fix by asking Claude to
   set `c4.root` (new preference). On by default, and it checks every time (see [MINE] 6).
3. **Proposal** (not built): PROPOSAL-c4-topoforge.md -- TopoForge JSON <-> C4 canonical diagram as
   two pure tools in c4-mcp.js (your file), checked by FACTS round trip in jq. Why it sidesteps the
   Filesystem connector: the drawing travels as a tool argument and answer, never as a file.
4. **Hand-test card:** CARD-giza-launch.md (WHEN/DO/CHECK/TELL-ME; how to read GIZA's Desktop log;
   which line confirms or kills HYPOTHESIS-giza-mcp.md).

## OBSERVED (commands run in the device shell, from $HOME/mnt/AS4CE0001 unless said)
- `sh tests/launch-cmd-tests.sh` -> PASS L1-L9, M1, M2, M3, M4 (M4: "NOT CHECKED (exit 2): no
  cmd.exe on this host"), "launch-cmd-tests: GREEN". `--prove-red` -> 8 of 8 plants red.
- `sh tests/c4face-tests.sh` -> PASS C1-C8, M1 (C3 against the real `~/mnt/c4`: c4_fragments
  answers), "GREEN c4face". `--prove-red` -> 3 of 3 plants red.
- `sh bin/tp2mt --check` -> "every claim holds" (two new c4face claims held).
  `sh tests/tp2mt-tests.sh` -> TOTAL pass=16 fail=0; `--prove-red` -> PASS.
- `sh tests/tavernface-tests.sh` -> GREEN 7/7 (P1's work, unchanged by me).
- `sh bin/pn1ck check polygram` -> 1 pin, all match.
- `sh tests/mcp-tests.sh <scratch python-shape mint>` -> TOTAL pass=24 fail=0, c4face answers (8
  tools: it found ~/mnt/c4 by itself). Same on a cmd-shape mint -> each server "skip ... not
  checkable on linux", pass=8 fail=0. `--prove-red` -> 2/2.
- `sb1rn` on the new/changed files -> clean.
- Python suite, file by file (a single discover run is killed by the shell's time limit):
  40 files, 518 tests; test_plugin 63 OK (3 new), test_plugin_imports 2 OK.
  RED, both pre-existing and in files I did not touch:
  - test_bytes_boundary: flags tests/test_llama_bridge_vb.py and tests/test_mcp_llamabridge.py
    (text/bytes without encoding=).
  - test_ft1mt: no footer row for SOFT-SKILLS/build-loop.
- QAPLAN WARN `find polygram -name __pycache__ -newer releases/1.0.3` -> fires on
  polygram/__pycache__, dated 08:05:18, before my first write; no .pyc newer than my first file
  exists anywhere under polygram/ or tests/. I cannot delete it (deletion not permitted).
- `make dist` NOT run (per brief). Nothing installed or enabled.

## JUDGED -- my calls, each with its falsifier  [MINE]
1. **When cmd is used:** `--launch auto` (the default) = cmd when the MINTING host is Windows
   (os.name nt, sys.platform win32/cygwin/msys, or MSYSTEM set), python elsewhere. So `make dist` on
   avalon now mints the cmd shape, and GIZA gets it with no flag. `make dist LAUNCH=python` restores
   the old shape. Falsifier: CARD step 3 -- avalon's servers do not start after installing the new
   mint.
2. **No `/s`** (the brief offered `/d /s /c`): with /s, cmd strips the line's first and last quote,
   which cuts a quoted plugin path at its first space; without it, two quotes around an existing file
   are kept. validate() refuses /s. Falsifier: the Desktop log on a machine whose plugin path has a
   space shows cmd saying the path "is not recognized".
3. **VIBROBEAST_PYTHON is used as given** (no WindowsApps skip, no exist test) -- the person chose it.
   Falsifier: none harmful; if it is the stub, the probe fails and the search goes on.
4. **Added step 6, `%ProgramFiles%\Python3*`** (an all-users install), after the brief's five.
   Falsifier: none harmful; the probe still demands 3.8+.
5. **A Store-installed Python (a real one living under WindowsApps) is never used.** The stub
   opens the Store on every server start; skipping all of WindowsApps avoids six Store windows.
   Falsifier: CARD step 4 shows "no Python 3.8 or newer was found" while `where python` on that
   machine lists only a WindowsApps python that really runs.
6. **c4face on by default.** c4-mcp.js and its three libs require only readline and path, read and
   write no file, open no connection. That is checked at every start (GUARD in c4face.py: any
   require of net/http/https/http2/dgram/tls/dns/child_process/cluster/worker_threads/fs, or a
   dynamic import(), in c4-mcp.js or a lib file it names -> not started, c4_status says which).
   tp2mt carries it as a checked claim. Falsifier: a C4 change that needs one of those modules --
   c4face then stops serving C4 and says so; the on-by-default call must be made again.
7. **Proxy by exec on POSIX, by waiting on a child on Windows** (os.exec on Windows ends the parent,
   which the app would read as the server dying). Falsifier: node.exe processes left running on
   avalon after Claude restarts (Task Manager) -- then the parent needs to pass on its end.
8. **C4FACE_GUESS=0** (new knob) skips only the fixed-place guesses, so a machine that really has
   F:/claude/c4 can still test "nothing found". The kits set it. Falsifier: none; it narrows.
9. **c4_status is not offered alongside C4's tools** when C4 is served (that would need a JSON-RPC
   mux, not "the simplest correct way"). C4's own initialize answers as c4-work-surface;
   mcp-smoke.pl accepts that name for c4face.
10. **check-interpreter.sh on a cmd mint with no cmd.exe exits 2 "NOT CHECKED"** rather than 0.
    It never claims a pass it could not run. Where cmd.exe exists (MSYS2 on avalon) it runs
    `launch.cmd --list` and checks all six servers are listed.
11. **mcp-smoke.pl** prints "skip" for a cmd-shape server off Windows (not counted as a pass); on
    MSYS2 it passes the root as a Windows path and turns off MSYS argument rewriting.

## NOT TESTED, said plainly
- launch.cmd has never run under a real cmd.exe. The kit checks its TEXT (order, the WindowsApps
  skip, quoting, CRLF, ASCII, stderr-only output, labels, credit) and the mint's JSON. Whether the
  Desktop starts `cmd` with these args, and whether the finder finds GIZA's UCRT64 Python, is
  CARD-giza-launch.md. Whether HYPOTHESIS-giza-mcp.md held is GIZA's log (card step 4).
- c4face on Windows (the subprocess.call arm, `C:\Program Files\nodejs`) is untested here.

## Files
New: polygram/launch.cmd, polygram/mcp/c4face.py, tests/launch-cmd-SPEC.txt,
tests/launch-cmd-tests.sh, tests/c4face-SPEC.txt, tests/c4face-tests.sh, tests/fixtures/c4face/c4/
{mcp/c4-mcp.js, lib/c4-model.js}, this folder's CARD-giza-launch.md, PROPOSAL-c4-topoforge.md, this file.
Changed: polygram/plugin.py (docstring section 2026-10-08, LAUNCHES/host_is_windows/resolve_launch,
SERVERS + _SERVER_FILES, _mcp_json cmd arm, launch.cmd copy, README rows and Windows section,
_validate_cmd, check-interpreter.sh cmd branch), polygram/cli.py (--launch on dist and edition),
Makefile (LAUNCH=), polygram/mcp/{__init__,__main__,prefs}.py, bin/tp2mt, tests/tp2mt-tests.sh,
tests/test_plugin.py, tests/test_plugin_imports.py, tests/mcp-smoke.pl, ChangeLog.
P1's item 1 (tavernface, tp2mt tavern claims) untouched.

## Pending -- yours
- `make dist` on avalon, then the card (steps 1-3 avalon, 4-5 GIZA). Tell me the log line.
- PROPOSAL-c4-topoforge.md: whether to add the two tools to c4-mcp.js (your file).
- Re-sign whatever you sign: polygram/plugin.py and the tests changed (the working norm: edit,
  write it down, you re-sign).
- Not done: no rows in c4/c/names for c4face or launch.cmd (servers and launchers have no row
  there today; tavernface has none either). Say if they should.
- Pre-existing reds to route: test_bytes_boundary (llamabridge test files), test_ft1mt
  (SOFT-SKILLS/build-loop footer), the stray polygram/__pycache__ (08:05) that trips the WARN.

## Pending for Bryant (not taken on)
- Nothing of his was changed. launch.cmd borrows the shape of his :TVL_FIND/:TVL_TRY and credits
  him; if he would rather it carried his copyright line too, say so.
