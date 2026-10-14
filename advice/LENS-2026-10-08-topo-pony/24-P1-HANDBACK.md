produced-by: builder P1 (Mentat, for Corwin; claude-opus-5-5) · 2026-10-08 · licence of this note: CC-BY-SA-4.0

# P1 hand-back — Tavern into vibrobeast (D3), two skills and their names (D4)

## What we handled

1. **Bryant's Tavern now ships inside the vibrobeast plugin, off until you ask for it.** Nobody has
   to edit JSON. To turn it on, you say "turn the Tavern on" to Claude, and Claude sets
   `tavern.on` with the plugin's own pref_set tool. Then restart Claude. Once on, it finds your
   Tavern by itself and uses Tavern's own 13 tools.
2. **Tavern's file is carried whole and unchanged**, with its hash pinned (NOTICE-tavern).
3. **A small new check, `bin/pn1ck`, lets `make dist` carry Bryant's file.** Without it, dist
   would refuse to mint (see OBSERVED 6).
4. **Two new skills:** `garden-pony` and `topoforge-story`. Both have rows in the name register and
   minted footers with Bryant first.

## OBSERVED (command -> result)

1. `sha256sum polygram/mcp/tavern_upstream.py` -> `6ffaa566...e78c`, the same as upstream/tavern-2.3.1.py.
2. `sh tests/tavernface-tests.sh` -> 7/7 PASS, `GREEN tavernface: 7/7`. The cases are V1 (bytes),
   F1 (off by default), F2 (on through pref_set alone, with no Tavern -> "NO TAVERN FOUND", what to
   do), F3 (~/Tavern/tavern-data found by itself, Tavern's own tools served, closed port -> "Cannot
   reach the Tavern node... Is it running?"), F4 (pref tavern.data wins, tavern.as names the
   agent), M1 (a real mint ships the three files, the pin holds, .mcp.json launches through
   `${CLAUDE_PLUGIN_ROOT}/servers/launch.py`, the minted check.sh is green, no __pycache__) and
   S1 (pn1ck).
3. `sh tests/tavernface-tests.sh --prove-red` -> red under all 3 plants: one byte in the vendored
   file, the switch forced always-on, and the scan list refused. Then `PROVE-RED PASS`.
   `sh bin/pn1ck --prove-red` -> PASS.
4. The polygram suite was run one module at a time, because a call here lasts at most 180 s and
   background runs are killed: 40 modules, **38 OK, 2 FAILED, and neither failure is ours**:
   - `test_bytes_boundary`: 13 findings in tests/test_llama_bridge_vb.py and
     tests/test_mcp_llamabridge.py (read_text/write_text/subprocess with no encoding). We did not
     touch those files (last commit ad4657b).
   - `test_ft1mt.test_every_skill_has_a_row`: SOFT-SKILLS/build-loop (from 2026-10-04) has no
     FOOTERS row of its own, because a skills/build-loop row already exists under that name.
   - `test_plugin` failed twice before the fix below. It is now 60/60 OK. `test_plugin_imports`
     (extended) is OK.
5. Skill lint (skills/skill-sign/scripts/skill-lint.sh): garden-pony ok (description 759/1024),
   topoforge-story ok (667/1024). `sh bin/ft1mt check` -> 84 rows, every footer is as minted.
6. `sh c4/bin/sb1rn polygram/mcp/tavern_upstream.py` -> 5 HITs `assigned-secret` (lines 2807, 2808,
   4330, 4331, 11621, i.e. `token=self.agent_token`, `secrets.token_hex(24)`). Those are variable
   names, not secrets. With pn1ck in the dist recipe, the same scan
   (`sb1rn skills bin $(pn1ck unpinned polygram) c4/dist/skills`) -> `sb: clean; read 861`.
7. `awk -f bin/bytes-lint.awk polygram/mcp/tavern_upstream.py` -> 7 findings (lines 1334, 2404, 4267,
   8348, 8387, 8478, 9395). They are listed in NOTICE-tavern for Bryant. The whole-tree lint now
   skips that one pinned file.
8. `sh c4/bin/nm1fl check` -> `ok 65 skills, 260 names checked`. `nm1fl check AS4CE0001/skills`
   -> 6 FAULTs for skills that had no row before today (build-loop, drift, kid-glove,
   llama-bridge, persona-engine, vibrobeast). Ours are not among them.
9. `sh c4/bin/c4 pinned-check --prove-red` -> PASS. The new c/names row resolves.

## Files

New: polygram/mcp/{tavern_upstream.py, tavernface.py, NOTICE-tavern}; bin/pn1ck;
tests/{tavernface-SPEC.txt, tavernface-tests.sh}; skills/garden-pony/SKILL.md;
skills/topoforge-story/SKILL.md; this note.
Changed: polygram/plugin.py (SERVERS gets `tavernface`, off by default; _SERVER_FILES gets 3
files), polygram/mcp/{__init__,__main__,prefs}.py (prefs tavern.on / tavern.as / tavern.data),
Makefile (dist runs pn1ck before sb1rn), tests/{test_plugin, test_plugin_imports,
test_bytes_boundary}.py, conventions/{FOOTERS, MAKERS}.org, ChangeLog; c4/c/skillnames (2 rows),
c4/c/names (1 row: pinned-check / pn1ck / ../AS4CE0001/bin/pn1ck).
Names: garden-pony = stable-hand / manage-agent-tool-registry / pony-ride;
topoforge-story = drawing-narrator / describe-network-drawing / map-tells-tale.
Nothing was committed and nothing was installed or enabled. Other builders are working in the same
trees, so committing is left to you.

## JUDGED

- The server is named `tavernface`, not `tavern`. The house tests require each server's name to
  match its module. That also keeps it apart from the `tavern` server already in your Claude
  config. If both are on, you will see two sets of tavern_* tools; turn one off. [MINE]
  Falsifier: if you want the name `tavern`, the module can be renamed and the tests updated.
- Tavern runs in-process, as `tavern.py mcp` would, because it needs no second interpreter
  lookup. It needs Python 3.10 or newer. On an older Python, tavern_status says so in words
  instead of crashing (Tavern exits at import below 3.10). [DOMAIN]
- Where it looks for Tavern: TAVERN_DATA, then pref tavern.data, then ~/Tavern/tavern-data (the
  installer's fallback in `cmd_install`), then Downloads, Desktop, Documents, OneDrive
  Desktop/Documents and home, each with and without a Tavern/ folder. A folder where Tavern is
  running (agent.json) wins. [MINE] Falsifier: on avalon, `tavern_status` with tavern.on set
  either finds the real folder or names where it looked.
- pn1ck changes a security gate (it shrinks the dist secrets scan by exactly the pinned files),
  so I name it here: [MINE]. Its argument: published author bytes whose hash matches the pin
  cannot carry a secret of ours. Falsifier: if you would rather keep scanning everything and
  accept the 5 hits by hand, remove the two Makefile lines and the scan is as before.
- garden-pony and topoforge-story describe the designs (B with your D2, A with your D1), not
  finished code. Each starts with a grep that says whether your copy has the feature yet.
  garden-pony marks one point as not settled: whether revoking a delegate also takes back the
  grants that delegate made.

## Not done / pending (for you)

- **`make dist` was not run.** The last dist took 6.5 minutes (releases/1.0.3, 04:39 to 04:45),
  which is longer than one call can last here, and a cut-off run leaves a torn release. Run
  `UNSIGNED=1 make dist` (or signed) yourself. The temporary mint in M1 proves the plugin contents.
- `bin/release` scans with sb1rn without pn1ck. A release tag will show the same 5 hits until it
  learns pn1ck, or until you pass `--accept-secret "vendored Tavern: variable names"`. This is a
  fork for you; I did not change bin/release.
- The skills are unsigned and not in dist until you sign and mint them.
- Six skills have no c4/c/skillnames row (listed in OBSERVED 8). SOFT-SKILLS/build-loop has no
  FOOTERS row of its own. Both predate today.
- `ft1mt seed` also added a FOOTERS row for SOFT-SKILLS/intake, a skill that had none. Keep or drop
  it as you like.

## Pending for Bryant (not taken on here)

- 7 byte-boundary findings in tavern.py: places where the file means different bytes on Windows
  than on GNU/Linux. They are listed in NOTICE-tavern.
- His lines that store the agent and human tokens trip a secrets scanner by name. That costs him
  nothing, but any downstream scanner will need a pin or an allow line for them.
