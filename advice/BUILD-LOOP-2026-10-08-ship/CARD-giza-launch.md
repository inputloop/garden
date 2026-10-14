produced-by: P2 (Mentat for Corwin; claude-opus-5-5) · 2026-10-08
SPDX-License-Identifier: CC-BY-SA-4.0

# CARD — does the new Windows launch start the servers on GIZA (and still on avalon)?

What changed: a plugin minted on a Windows machine now starts each server with
`cmd /d /c <plugin>\servers\launch.cmd NAME`, and `launch.cmd` looks for a Python by itself
(your VIBROBEAST_PYTHON if you ever set one; `py -3`; `python3`/`python` on PATH but never the
Microsoft Store stub; `C:\msys64\ucrt64`, `mingw64`, `clang64`; python.org installs). Nobody edits
JSON. It writes one line to the Desktop's log naming the Python it chose, or one sentence saying
what to install. Nothing of this has run under a real cmd.exe yet: this card is that test.

The question it answers: HYPOTHESIS-giza-mcp.md said GIZA's servers died because `python3` there is
missing or the Store stub. If the log on GIZA (step 5) shows the servers starting with
`C:\msys64\ucrt64\bin\...python...exe`, the hypothesis held and the fix works.

---

**1. WHEN** you are next at avalon with time for one `make dist` (about 6.5 minutes).
**DO** in the MSYS2 shell, at the AS4CE0001 folder: `make dist`
**CHECK** the mint prints a line `launch:   cmd.exe + servers\launch.cmd (finds Python by itself ...)`,
then `make dist: dist/vibrobeast.plugin is for Windows; minting the macOS/GNU-Linux shape in dist/posix/`
and a second mint (since FP).
**TELL ME** if that line is missing, or if the mint prints PROBLEMS.

**2. WHEN** the mint is done.
**DO** still in MSYS2: `sh dist/vibrobeast/check-interpreter.sh`
**CHECK** a line `OK     launch.cmd found Python: "..."` and then `OK     NAME: listed by launch.cmd --list`
for all six servers (mentcached, persona, skillx, llamabridge, tavernface, c4face).
**TELL ME** the Python path it printed, or the whole output if any line says FAULT.

**3. WHEN** step 2 is green, and before you install anything (FP2, 2026-10-08).
**DO** still in MSYS2, at the AS4CE0001 folder, paste this one line:
`p=dist/vibrobeast.plugin; ls -l "$p"; echo "new files: $(unzip -l "$p" | grep -cE ' servers/launch\.cmd$| servers/polygram/mcp/c4face\.py$') of 2; servers started by cmd: $(unzip -p "$p" .mcp.json | grep -c '"command": "cmd"') of 6"; unzip -p "$p" .claude-plugin/plugin.json | grep '"version"'; unzip -p "$p" .mcp.json | sha256sum; sha256sum "$p"`
**CHECK** the date `ls` shows is today's, after you ran `make dist` (not 08:05); `new files: 2 of 2`;
`servers started by cmd: 6 of 6`; the version is 1.0.4 or later; and the first sha (of .mcp.json) is
NOT `0829ef21b589...`, which is the old 08:05 plugin, the one that died on GIZA. (The version alone
cannot tell them apart: the old one already says 1.0.4.) The old plugin reads `0 of 2` and
`0 of 6` on this line; that was tried on it before this step was written. Keep the second sha (of
the whole .plugin): step 5 compares GIZA's copy with it.
**TELL ME** any number short of 2 of 2 or 6 of 6, or the old sha. Then do not install it. (No
`unzip` in MSYS2? `pacman -S unzip`, or ask me for the same line in Python.)

**4. WHEN** step 3 is green.
**DO** install `dist/vibrobeast.plugin` on avalon the usual way, restart Claude, then in a new chat
ask: "run get_device_info and tell me whether the vibrobeast servers started".
**CHECK** the six servers show as started. c4face shows one tool, c4_status, saying OFF: since
FP (29-FP-HANDBACK.md) it is off until you ask Claude to "turn C4 on"; after that and a restart it
shows C4's own tools, c4_fragments and the rest, because F:\claude\c4 is there.
**TELL ME** any server not started. If avalon broke: `make dist LAUNCH=python` brings back the old
shape at once; tell me and I will read avalon's log the same way as step 5.

**5. WHEN** avalon is fine. Copy the same `vibrobeast.plugin` to GIZA.
**DO** on GIZA, first in a Command Prompt where you copied it: `certutil -hashfile vibrobeast.plugin SHA256`;
it must print the same sha as the whole-.plugin sha from step 3 (if not, the old file was copied). Then install it, restart Claude. Then open the Desktop's log folder: press Win+R, paste
`%LOCALAPPDATA%\Claude\Logs` and press Enter. (If that folder does not exist, the app is the Store
build: paste `%LOCALAPPDATA%\Packages` instead, open the folder whose name starts `Claude_`, then
`LocalCache\Roaming\Claude\logs`.) Open the newest `main*.log` (and any `mcp*.log`) in Notepad and
press Ctrl+F for `vibrobeast:`.
**CHECK** one of these, for each server:
  - `vibrobeast: starting the mentcached server with "C:\msys64\ucrt64\bin\python3.exe"` (or another
    real python) -> **the hypothesis held and the fix works.**
  - `vibrobeast: the mentcached server cannot start because no Python 3.10 or newer was found` ->
    the finder looked everywhere it knows and found none: GIZA's Python is somewhere new.
  - `vibrobeast: the mentcached server cannot start because the only Python found on this computer
    is too old ("...")` -> a Python runs there, but it is older than 3.10 (the floor since FP).
  - no `vibrobeast:` line at all, and a line mentioning `cmd` or `ENOENT` -> the Desktop did not
    start cmd.exe the way we expected: **the cmd launch is the problem, not Python.**
  - `env declares reserved variable name "PYTHONPATH"` -> an old plugin is still installed (H2).
**TELL ME** the matching line (copy it), and for the second case the output of
`where python python3 py` in a Command Prompt on GIZA.

**6. WHEN** you want to test the finder alone, with no Claude in the loop.
**DO** on GIZA in a Command Prompt, in the installed plugin's folder (or the unzipped
`vibrobeast.plugin`): `servers\launch.cmd --list`
**CHECK** the first line names the Python, then the six servers and their tools are listed.
**TELL ME** what it printed if it is anything else.
