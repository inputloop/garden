produced-by: FP (Mentat for Corwin; claude-opus-5-5) · 2026-10-08 · fixer for FOLD-QA1 rows 13-19 (plugin)
SPDX-License-Identifier: CC-BY-SA-4.0

# FP hand-back — the plugin's QA1 findings, fixed

## What we handled
1. **Row 13, Python floor.** launch.cmd now asks every candidate for **Python 3.10 or newer** (one
   floor for all six servers: the floor of the Tavern the plugin carries; 3.9 is past its end of
   life). It keeps searching past an older Python, so `py -3` at 3.9 no longer hides an MSYS2
   3.12. An older Python that runs is remembered, and the last sentence then says it is **too
   old**, names it, says install 3.10+ and **restart Claude**, and "nothing needs editing". The
   none-found sentence says the same. tavernface's too-old answer no longer says "re-mint": it
   says install 3.10+, restart Claude. plugin.py's mint-time probe and check-interpreter.sh ask
   for 3.10+ too.
2. **Row 14, c4face's guard.** The regex is gone. The guard is now an **allow-list read through a
   small JavaScript lexer** (comments dropped, strings and template `${...}` handled, regex
   literals handled): `require` only of readline/path or the `path.join(__dirname,'..','lib',
   'x.js')` shape; `process` only for stdin/stdout/stderr/argv/exit/exitCode; `module` only for
   `module.exports`; no `import`, `eval`, `Function`, `globalThis`, `constructor`, `Reflect`,
   `createRequire`, `binding`, `dlopen`, `mainModule` (as code or as a string). Anything it
   cannot read is a hit. **And c4face is now OFF by default**, behind the preference `c4.on`
   (ask Claude: "turn C4 on"; or `C4_ON=1`). See JUDGED 1.
3. **Row 15, Windows-only mint.** A cmd-shape mint now says so where an installer reads it: the
   plugin.json description ends "Windows build: its servers start through cmd.exe, so on macOS or
   GNU/Linux use the other build, dist/posix/vibrobeast.plugin (make dist mints both)", and the
   README's cmd section opens "**Made for Windows only.**". `make dist` mints **both**: when the
   main mint is the cmd shape, it mints `--launch python --out dist/posix` beside it (same
   plugin name, so skills stay `vibrobeast:...`). The CLI prints "made for Windows only".
4. **Row 16, __pycache__.** The writer was the dist step itself, `$(PYTHON) -m polygram dist`
   (cli.py imports polygram/__init__ and plugin; those two are exactly the .pyc files dated
   08:05:18, the two sources that changed). The Makefile now has
   `export PYTHONDONTWRITEBYTECODE = 1` at the top, so every recipe's python (dist, seatnote,
   edition, test) inherits it. New kit tests/makefile-bytecode-tests.sh.
5. **Row 18, stock Tavern said.** Every tavern_status answer carries `carries`: Bryant's stock
   Tavern 2.3.1, no tool registry (tavern_tools), no marking of receipt lines an agent typed;
   the patched 2.3.1+gp lives in projects/garden-pony now, at github.com/inputloop/tavern once
   published. The plugin README's tavernface row says the same.
6. **Row 19, credit.** launch.cmd: `rem Copyright 2026 Bryant Frankford
   <nathanielfrankford@gmail.com> and Corwin Brust <corwin@bru.st>` / `rem and Contributors.`
   Bryant first; SPDX `GPL-3.0-or-later OR LGPL-3.0-or-later` unchanged (the brief's house form);
   the credit paragraph stays, and now says his py -3 line keeps his own 3.10 floor.
7. CARD-giza-launch.md updated to match (3.10 wording, the too-old line, c4face shows OFF until
   asked, step 1 expects the dist/posix line).

## OBSERVED (device shell, from $HOME/mnt/AS4CE0001)
- `sh tests/launch-cmd-tests.sh` -> PASS L1-L10, M1-M5, "launch-cmd-tests: GREEN" (M4 still
  "NOT CHECKED: no cmd.exe on this host"). `--prove-red` -> twin-removed caught by M5, then
  "every planted fault went red (11 of 11)" (new plants: floor L6, oldmsg L10, copyr L9).
- `sh tests/c4face-tests.sh` -> PASS C1-C11 (C3 against the real ~/mnt/c4: c4_fragments answers),
  M1, "GREEN c4face". `--prove-red` -> "all five plants went red"; plant (d), the first build's
  regex put back, MISSES 32 of the 48 planted evasions (24 shapes × 2 files).
- Before writing the kit, against the real C4 tree: `guard(~/mnt/c4)` -> `[]` and the fixture
  -> `[]` (no false alarm on what C4 is).
- `sh bin/tp2mt --check` -> "1.0.4 -- every claim holds". `sh tests/tp2mt-tests.sh` -> TOTAL
  pass=17 fail=0 (new: allow-list widened to fs goes red; c4.on switch lost goes red);
  `--prove-red` -> PASS.
- `sh tests/tavernface-tests.sh` -> GREEN 7/7 (F1 and M1 now check the stock-2.3.1 words);
  `--prove-red` -> all three plants red.
- `sh tests/makefile-bytecode-tests.sh` -> GREEN; `--prove-red` -> export removed turns B1 and B2
  red. `sh tests/makefile-c4root-tests.sh` -> 5 ok, 0 failed.
- `sh bin/pn1ck check polygram` -> 1 pin, all match.
- `python3 -m unittest tests.test_plugin` -> Ran 63, OK (114 s). `tests.test_plugin_imports
  tests.test_mcp_freshness` -> 15 OK. `tests.test_mcp_llamabridge test_mcp_persona
  test_mcp_softskills test_mcp_words` -> 59 OK.
- `sh tests/mcp-tests.sh <scratch python mint in session home>` -> TOTAL pass=24 fail=0.
- sb1rn over the 12 changed files -> clean (1 allowed, pre-existing).
- `find . -name __pycache__ -newer <my first edit>` -> nothing. The QAPLAN WARN
  (`-newer releases/1.0.3`) still lists polygram/__pycache__: that is the 08:05 directory,
  which I cannot delete.
- `make dist` NOT run; nothing installed or enabled; nothing written under mnt/Bryant.

## JUDGED — my calls, each with its falsifier
1. [MINE] **c4face OFF by default.** A sound static check is not achievable: JavaScript reaches
   any module through a computed name (`obj["constr"+"uctor"]`, `x[k]` with k built at run
   time), and C4's own code uses computed member access, so it cannot be banned. The allow-list
   is a tripwire for an honest change, worded so in tp2mt and in c4_status ("a tripwire, not a
   fence"). Falsifier: a runtime fence that holds -- node's permission model (`node --permission`
   with reads allowed only under <c4>/mcp and <c4>/lib, no child processes/workers/addons; avalon
   and the bench have node 22.23) shown to stop a planted `require("fs").readFileSync` on the
   nodes GIZA and avalon have; then the on-by-default call can be made again on that ground.
2. [MINE] **One 3.10 floor, not per-server.** Simpler, and every server runs on 3.10. Falsifier:
   someone who must run the plugin on 3.8/3.9 (none known; GIZA's `where` answers it, card step 4).
3. [MINE] **"Too old" only on probe exit 3.** The probe exits 3 for an old Python; any other
   failure (the Store stub, a broken exe) is "not a Python". Falsifier: a GIZA log line that says
   "too old" naming something that is not a Python.
4. [MINE] **The posix twin only when the main mint is cmd.** On macOS/GNU-Linux the main mint is
   already that shape, so a twin would be a duplicate. Editions (`make edition`) get no twin.
   Falsifier: Corwin wants a dist/posix folder on every host, or a twin for editions.
5. [MINE] **`make dist` writes one more advice file** (the twin mint records itself like any
   mint). Falsifier: Corwin finds the extra advice/*-dist-vibrobeast.md noise.
6. [PLATFORM] The `if "%errorlevel%"=="3"` line and the VB_OLD sentence, like all of launch.cmd,
   have never run under a real cmd.exe. CARD-giza-launch.md step 4/5 is still that test.
7. [MINE] The CARRIES text says the receipt fix is "marking of receipt lines an agent typed
   itself", from garden-pony's README/NEWS. Falsifier: Bryant or the patch describes it otherwise.

## Not done, said plainly
- No `make dist` (per brief), so the twin recipe and the export are checked as text and by a
  make probe, not by a full build. Release 1.0.4 is still torn (row 17 is yours).
- The 08:05 polygram/__pycache__ stays until deletion is allowed; the WARN keeps firing on it.
- test_bytes_boundary and test_ft1mt (pre-existing reds) not touched.

## Pending — yours
- Re-sign what you sign: launch.cmd, c4face.py, tavernface.py, prefs.py, plugin.py, cli.py,
  Makefile, bin/tp2mt, the changed tests (edit, written down, you re-sign).
- `make dist`, then the card.
- If you want C4 on at home: ask Claude "turn C4 on" (sets c4.on), restart.

## Pending for Bryant (not taken on)
- Whether he wants a different credit form in launch.cmd than the one now there (his name first).
