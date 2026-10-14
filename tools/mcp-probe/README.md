# mcp-probe — read what Claude Desktop on Windows will not let a session read

Two `.cmd` files Corwin double-clicks (or `cmd //c` from mintty). Each writes `<name>.out.txt`
beside itself and prints nothing to the console — silence is by design. Written 2026-09-23 when
the vibrobeast plugin's servers sat at `not_started / could_not_prepare` and a session could
neither be granted the app's own folders nor type into a terminal under computer use.

- `mcp-probe.cmd`  — `where python3/python/py`, `py -0p`, does `python3 -c` run, and a first
  (wrong) guess at the log dir. Its finding: the interpreter was never the problem on avalon.
- `mcp-probe2.cmd` — where `claude.exe` runs from (PowerShell), the candidate app-data roots,
  then every `*.log` under them grepped for the server names and "prepare". Its finding: the app
  is the Microsoft Store build; logs are `%LOCALAPPDATA%\Claude\Logs\main*.log`; and the line
  `env declares reserved variable name "PYTHONPATH"`.

The outputs they produced that day carry his PATH and log excerpts; they are receipts, not
tools, and are archived by his hand (see the run-card in `advice/`).
- `mcp-probe3.cmd` — (2026-09-23, later) which vibrobeast build is INSTALLED: every dir under the
  app roots holding `MANIFEST` + `.claude-plugin\plugin.json`, its MANIFEST sha256 beside the
  shelf's, whether `prefs.py` / `spans.py` are in it, then `python3 -m polygram.mcp.freshness
  --shelf … --installed …` (exit 0 CURRENT · 1 BEHIND · 2 UNKNOWN), and the newest `main*.log`'s
  last 40 lines naming `mentcached`. Written because a session saw the desktop announce 17
  mentcached tools while the shelf mint serves 26 — the session cannot see which tree the desktop
  runs, this can.
