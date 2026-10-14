# CARD — Desktop Commander via the classic claude_desktop_config.json (route B)

Supersedes nothing — this is an alternate route alongside
`CARD-2026-09-05-desktop-commander-connect.md` (route A: edit the plugin's own
`plugin.json` in the rpm cache). Corwin's call (2026-09-05, this session):
route A isn't reliable — the original card already named why (line 24: "a
plugin update may overwrite this file"). Route B adds `desktop-commander` as
a **standalone MCP server entry** in Claude Desktop's own user config, which
the plugin marketplace doesn't own and can't silently overwrite.

# ============================================================================
# CARD ID    : RUNCARD-2026-09-05-01-dc-config-route
# PURPOSE    : get desktop-commander tools loading, via claude_desktop_config.json
#              instead of the plugin.json edit route
# GATE       : none formal — his own machine, his own troubleshooting call
# DRIVER     : Corwin, at the Avalon keyboard (I can't reach %APPDATA% from here —
#              it's outside this session's connected folders)
# SIGNER     : n/a — no artifact to sign, a live local config
# PRECOND    : mingw64 node/npx still where the last session found them
# WRITES     : claude_desktop_config.json (backed up first); a .bak-<stamp> copy
# TRAIL      : each step below opens with a comment naming what it checks
# DISPOSITION: keep every .bak-<stamp> indefinitely — cheap, his call to prune
# ABORT      : any step below says STOP — restore from .bak-<stamp>, don't
#              restart the app on a broken or clobbered config
# ============================================================================

## [MINE ~90%] Known-good values, carried from route A's diagnosis
- mingw64 node: `C:/msys64/mingw64/bin/node.exe` → v24.16.0
- mingw64 npx:  `C:/msys64/mingw64/bin/npx.cmd`
- package: `@wonderwhy-er/desktop-commander@latest` (per the plugin.json route A already runs this same package silently against mingw64 npx — this route just changes *who launches it*, not what gets launched)

## [MINE ~65%, falsifier stated] Open question this route doesn't resolve on paper
The Cowork plugin tile (`plugin:desktop-commander:desktop-commander`) and a
hand-added `mcpServers.desktop-commander` entry may or may not coexist
cleanly — same display name, two different launch paths. Falsifier: after
restart, check the connector/plugin list — if the marketplace tile is still
shown failed *and* a same-named server also shows connected, that's a
collision, not a fix; the log at launch will say which one loaded. If
Claude Desktop silently prefers one over the other, step 6 below still
proves which one, because it's the actual `get_config` tools that answer,
not the tile's color.

---

## STEP 0 — reconfirm the fix still holds (positive control, before touching config)
```powershell
& "C:/msys64/mingw64/bin/node.exe" -v
& "C:/msys64/mingw64/bin/npx.cmd" -v
```
Expect: `v24.16.0` and an npm version. **If either errors "not recognized" — STOP.** msys64 moved or isn't there; nothing below will help.

## STEP 1 — locate + back up the classic config (read before you write)
```powershell
$cfg = "$env:APPDATA\Claude\claude_desktop_config.json"
if (-not (Test-Path $cfg)) { '{ "mcpServers": {} }' | Set-Content $cfg -Encoding utf8; "created skeleton" }
$stamp = Get-Date -Format yyyyMMdd-HHmmss
Copy-Item $cfg "$cfg.bak-$stamp"
Get-Content $cfg -Raw
```
Observable: a `.bak-<stamp>` file now exists next to it, and you see the current JSON printed. **Read it** — note every top-level key under `mcpServers`. That's your coverage line for step 2's gate.

## STEP 2 — merge in desktop-commander (JSON object edit, not text-splice — can't produce a trailing comma)
```powershell
$cfg = "$env:APPDATA\Claude\claude_desktop_config.json"
$json = Get-Content $cfg -Raw | ConvertFrom-Json
if (-not $json.mcpServers) {
  $json | Add-Member -NotePropertyName mcpServers -NotePropertyValue ([pscustomobject]@{}) -Force
}
$dcCmd  = "C:/msys64/mingw64/bin/npx.cmd"
$dcArgs = @("-y", "@wonderwhy-er/desktop-commander@latest")
if ($json.mcpServers.PSObject.Properties.Name -contains "desktop-commander") {
  $json.mcpServers."desktop-commander".command = $dcCmd
  $json.mcpServers."desktop-commander".args    = $dcArgs
} else {
  $json.mcpServers | Add-Member -NotePropertyName "desktop-commander" -NotePropertyValue ([pscustomobject]@{ command = $dcCmd; args = $dcArgs })
}
$json | ConvertTo-Json -Depth 12 | Set-Content $cfg -Encoding utf8
Get-Content $cfg -Raw
```
**GATE:** the printed JSON must still contain every key you saw in step 1, plus `mcpServers.desktop-commander.command` = `C:/msys64/mingw64/bin/npx.cmd`. **If a prior key is missing — STOP, restore the `.bak-<stamp>`.**

## STEP 3 — validate the file actually parses (belt + suspenders)
```powershell
try {
  Get-Content "$env:APPDATA\Claude\claude_desktop_config.json" -Raw | ConvertFrom-Json | Out-Null
  "JSON OK"
} catch {
  "JSON BROKEN: $($_.Exception.Message)"
}
```
**Must print `JSON OK`. If it prints BROKEN — STOP, restore the `.bak-<stamp>`, do not restart the app.**

## STEP 4 — fully quit and relaunch (a window reload is not a restart)
```powershell
Get-Process Claude -ErrorAction SilentlyContinue | Select-Object Id, StartTime
```
Quit Claude Desktop from the tray/File menu — not just close the window. Then:
```powershell
Get-Process Claude -ErrorAction SilentlyContinue
```
Expect: nothing printed (no lingering process). Relaunch normally, then:
```powershell
Get-Process Claude -ErrorAction SilentlyContinue | Select-Object Id, StartTime
```
Observable: a new PID, fresh `StartTime`.

## STEP 5 — verify (in a NEW chat/Cowork session — this one cached the failure ~15 min)
Check the connector/plugin list for `desktop-commander` status, then in the new session call `get_config`. That's the real proof, not the tile color (see the open question above).

## TELL-ME
Paste back: step 0's two version lines, whether step 1 found an existing `desktop-commander` block, and step 5's outcome (connected / still failed / collision). I'll take it from `get_config` onward — `set_config_value allowedDirectories` to the three roots already on record, then one `read_file` under `F:\claude\c4` with no folder dialog, per the standing grant.
