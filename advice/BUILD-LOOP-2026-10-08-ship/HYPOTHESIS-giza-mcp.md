produced-by: claudewin · 2026-10-08 · written BEFORE any fix (house rule: hypothesis first if a surprise is possible)

# Why the vibrobeast servers did not come up on GIZA — hypothesis

OBSERVED
- dist/vibrobeast/.mcp.json launches every server as `"command": "python3"` (bare name, resolved on PATH
  by Claude Desktop, which is launched from Explorer, not from an MSYS2 shell).
- On avalon `where python3` resolves to c:\msys64\mingw64\bin\python3.exe (plugin.py, 2026-09-23 note).
- GIZA's own setup (projects/giza/SETUP-FROM-METAL.md) installs Python inside MSYS2 **UCRT64**
  (mingw-w64-ucrt-x86_64-python), i.e. C:\msys64\ucrt64\bin\python.exe, and says nothing of adding it
  to the Windows PATH. UCRT64's package ships `python.exe` and `python3.exe`.

JUDGED (hypothesis H1)
- On GIZA `python3` is either not on Desktop's PATH or resolves to the Microsoft Store "App Execution
  Alias" stub (%LOCALAPPDATA%\Microsoft\WindowsApps\python3.exe), which opens the Store / exits non-zero
  instead of running the server. Either way every server dies at spawn.
Falsifier: GIZA's Claude Desktop log (%LOCALAPPDATA%\Claude\Logs\main*.log, or the Store build's
  ...\Packages\Claude_*\LocalCache\Roaming\Claude\logs) shows the servers spawning a real python and
  failing later (import error, seat path), or naming another reason (e.g. the reserved-env line of
  2026-09-23 from an old mint). If the log shows a spawn ENOENT or the WindowsApps path, H1 holds.
Alternative H2: an older .plugin (pre-2026-09-23, with PYTHONPATH in env) was installed on GIZA.
  Falsifier: the log line "env declares reserved variable name PYTHONPATH".

What fixes H1 without anyone editing JSON (D3, accessibility):
- On Windows the mint launches through `cmd.exe` (always present) running a shipped `servers\launch.cmd`
  that FINDS a working Python 3.8+ the way Bryant's Tavern-Setup finds one (:TVL_FIND): VIBROBEAST_PYTHON,
  then `py -3`, then python3/python on PATH that is NOT the WindowsApps stub, then the MSYS2 trees
  (ucrt64, mingw64, clang64), then %LOCALAPPDATA%\Programs\Python\Python3*. If none: the server prints a
  plain sentence to stderr (which the Desktop log keeps) saying what to install.
