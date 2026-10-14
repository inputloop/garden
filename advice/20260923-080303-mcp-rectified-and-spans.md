---
kind: decision+landing
recorded: 2026-09-23T08:05Z
by: Mentat (for Corwin)
---

# The MCP servers work; the bug was one env line; stats landed as four tools

## OBSERVED (each with its source)

- `get_device_info` on avalon, 07:05Z: mentcached / persona / skillx all `not_started · could_not_prepare`.
- All three answer initialize + tools/list from `dist/vibrobeast` in the VM (device_bash) -- the Python was never broken.
- `Inbox/mcp-probe-2026-09-23/mcp-probe.out.txt` (Corwin ran it): `where python3` → `c:\msys64\mingw64\bin\python3.exe`, 3.14.5, rc=0. The README's Store-alias theory is FALSIFIED for avalon.
- `mcp-probe2.out.txt`: the app is the Microsoft Store build (`C:\Program Files\WindowsApps\Claude_2.7032.0.0_x64__pzs8sxrjxfjjc`); logs at `%LOCALAPPDATA%\Claude\Logs\`; and there, hourly since 09-19:
  `[PluginMcpHostConfig] Plugin "plugin_019U3bNQkGTiXZ6scgwqCx7c" server "mentcached": failed to build host proxy target: env declares reserved variable name "PYTHONPATH"`
- Same log: 2026-09-19 12:20 and 09-20 02:20, all three servers `Connected` and announced (16/7/4) -- a build without that line has worked here before.
- After the no-env mint was installed (Corwin, ~07:52Z): `get_device_info` → all three `announced`; `seat_mode` → SEATED, `C:\Users\corwi\.mentcached\seat`; persona NOTVISIBLE (no PERSONA_ROOT; by design); skillx REFUSING with B1..B3.

## JUDGED

- The whole of `could_not_prepare` was `"env": {"PYTHONPATH": ...}` in `.mcp.json` -- a [PLATFORM] rule (Claude Desktop reserves that name for plugin servers). The 09-19 hypothesis in `polygram/plugin.py` was right about WHERE and wrong about WHAT; the module docstring now says so with the receipt.
- The `--self-locating` arm (absolute launcher path) was not needed; `${CLAUDE_PLUGIN_ROOT}` in `args` is honoured. It stays as the last-resort arm.

## LANDED

- `polygram/plugin.py`: default mint = `python3 ${CLAUDE_PLUGIN_ROOT}/servers/launch.py NAME`, NO env key; launcher always shipped; `validate()` and `check-interpreter.sh` FAULT on a PYTHONPATH env, quoting the log line; README rewritten around what actually broke.
- `dist/vibrobeast/` + `dist/vibrobeast.plugin` re-minted twice (same 61 skills; canon 13 from `c4/dist/skills`): first the no-env fix (sha `0e17f3bc…`, installed and proven), then with spans (sha `885a52f4…`, 333 files, check.sh OK). **The second one is not installed yet** -- see the card.
- `polygram/mcp/spans.py` on mentcached: `span_start / span_mark / span_stop / span_report` -- time is the server's (UTC, on arrival), tokens are the caller's (`tokens_left`), ledger `~/.mentcached/stats/spans.tsv` is append-only one-row-per-event (`$MENTCACHED_STATS` names another; never created). 21 tools now. `--prove-red` gained R12/R13 (stop with nothing open; stop twice).
- `bin/sp1rp` (SPANS 1 REPORT): the awk twin reader; `tests/sp1rp-tests.sh` cross-checks server vs awk on the same bytes, 15/15 + prove-red.
- `tests/mcp-smoke.pl` + `tests/mcp-tests.sh` (Perl spec, sh wrapper, tier smoke): starts each server exactly as the desktop does (verbatim argv, `${CLAUDE_PLUGIN_ROOT}` substituted, clean env), refuses any env block with the log line beside it, JSON-RPC handshake + one call, no `__pycache__` afterwards. Goes red on two plants. Against the OLD dist it FAILs ×3 for the desktop's exact reason.
- `bin/gd1ck`: results held in memory as well as the temp dir; per-leg TMPDIR; workspace guard that FAILs BY NAME the leg that deletes the kit's workspace (prove-red plants one); verdict BROKEN (exit 3) whenever counts disagree -- the "verdict: no failures" over a vanished directory cannot recur; one leg per python file; `--smoke`, `--match RE`, SLOW list (`GD1CK_SLOW`, default 60s); `--list` shows tiers. Smoke tier: 11 legs, ~30s. Suites join the tier with a `# tier: smoke` line (mcp, sp1rp, test_first_run, test_mcp_metrics, test_mcp_spans, test_mcp_store, test_plugin_imports).
- Deleted, with permission: 11 `.pyc` under `dist/vibrobeast/servers` that this session's first probe wrote; two `.lf` scratch copies in `Inbox/mcp-probe-2026-09-23/`. The two probe scripts now live in `tools/mcp-probe/` (host-side helpers; README beside them). Their outputs stay in `Inbox/` until his hand archives them -- run-card `advice/20260923-*-runcard-inbox-receipts-and-seat-debris.md`, Card A.
- Parked in `.eclipse-increments/`: `gd1ck.2026-09-22.before-workspace-guard`, `plugin.py.2026-09-23.before-no-env`, `test_plugin.py.2026-09-23.before-no-env`.

## OPEN, with falsifiers

- Which leg deleted the workspace on the host's hour-long run: not reproduced here (23 c4 test legs ran under the guard, clean). The next full run on avalon names it, or the guard is wrong.
- c4 has three RED items today (ju1as, sw1ng, whose --prove-red >40s) that predate this session. Not touched.
- The `.asc` beside `polygram-curation-0.7.0.*` still reads BAD by content (since 09-19); drawer-vs-door, Corwin's call. Nothing here re-signs.

## Amended 08:35Z -- what his first smoke run on avalon found

Two RED, both real, both Windows-shaped, one of them a wrong: (1) `test_first_run.py` had been
writing its fixtures into his REAL seat on every host run (HOME redirected; Windows reads
USERPROFILE) -- guarded now, and the debris is his call (run-card, Card B); (2) `sp1rp-tests.sh`
embedded a `/tmp` path in `python -c` text, which msys2 does not path-convert -- argv now.
Also learned: the smoke tier costs ~100s on the F: mount (check.sh's sha256 over 333 files is 42s
of it), and `gd1ck --keep DIR` now saves a failed leg's whole output for a remote reader.

## Amended 09:1xZ -- plugin_freshness, and what the archiver became

- His question *"What changed in the plugin that I need to reinstall it? I thought the skillx MCP
  server was able to bring in this type of change"* has two honest answers, both written into the
  plugin README: skillx is party-to-party exchange (offer/accept/syndicate between keepers), not an
  installer; and [PLATFORM] an MCP server cannot add or update a skill in Claude Desktop -- the
  channels are the plugin upload and Settings -> Capabilities, both his hand.
- So the ceremony was made cheap instead: `plugin_freshness` on mentcached (`polygram/mcp/freshness.py`)
  compares the MANIFEST the server runs from (root found by walking up from its own file, or
  `$CLAUDE_PLUGIN_ROOT`) with the shelf's (`shelf` arg / `$POLYGRAM_DIST`) and answers CURRENT /
  BEHIND / UNKNOWN, the files that would change (servers / skills by name / other) and a one-line
  `reinstall:` in words. Same answer from a shell: `python3 -m polygram.mcp.freshness --shelf
  dist/vibrobeast --installed DIR`. Tests: `tests/test_mcp_freshness.py` (11), `tests/freshness-tests.sh`
  (8 + prove-red, runs the real comparison when `VIBROBEAST_INSTALLED` is set), prove-red R14.
  mentcached: 22 tools. Mint landed: `dist/vibrobeast.plugin` sha `a2405f0a…`, 334 files.
- Against the mint he installed at ~08:1xZ (spans, 21 tools) the shelf now differs in 5 files, 3 of
  them servers -- this one IS a reinstall that buys something.
- The archiver: see `advice/20260923-083138-runcard-inbox-receipts-and-seat-debris.md` (amended) --
  `c4/bin/aw2ri retire` + `put --force`, `c4/tests/aw2ri-tests.sh`, inculcat-boxer grown from stub.

## Amended 09:5xZ -- switches, the dynaloader, and `make dist` on Windows

- `make dist` on avalon: `WinError 5` unlinking `dist/vibrobeast/skills/consent-gate/references/CONSENT-RECORD-TEMPLATE.md`
  -- copy2 preserves a read-only mode into the mint and Windows will not unlink it. `plugin._rmtree_force`
  clears the attribute and retries, and names the file if something still holds it. Test in
  `tests/test_plugin.py::AStaleMintNeverBlocksTheNextOne`.
- Preferences (`polygram/mcp/prefs.py`): a known list of keys with defaults; `~/.mentcached/prefs.tsv`
  (or `$MENTCACHED_PREFS`, never created), append-only, last row wins, says who and why. Tools
  `pref_list` / `pref_set`; unknown keys refused (prove-red R15). Keys: `freshness.auto` (on),
  `freshness.shelf`, `softskills.auto` (on), `softskills.roots`.
- The on-open panel (`polygram/mcp/checks.py`): `seat_mode` and every `span_start` carry `checks`
  -- freshness and soft-skills -- each gated by its pref, each saying off / ran / could-not, never
  gating the call that carries it.
- The dynaloader (`polygram/mcp/softskills.py`): `SOFT-SKILLS/<name>/SKILL.md`, installed-skill
  format, scanned on every call from the `softskills.roots` pref / `$SOFT_SKILLS` / defaults.
  `soft_skills_list`, `soft_skill_read {name, file?}`; refuses `..`, absolute paths, non-text and
  >256 KB (prove-red R16). Twin: `bin/ss1ls` (+ `tests/ss1ls-tests.sh`, cross-checks names and
  the folded description against the python loader). Seed and acceptance test:
  `SOFT-SKILLS/soft-skills/SKILL.md`. INDEX.md gained the row.
- mentcached: 26 tools. Mint landed: `dist/vibrobeast.plugin` sha `dea326ae…`, 339 files. Smoke
  tier: 19 legs.
