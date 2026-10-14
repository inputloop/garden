# CARD — get Desktop Commander connected (keeper's hands)

Grant on record (2026-09-05): allowedDirectories = F:\claude · D:\projects · H:\ta ; telemetry default.
Plugin spawns on the host: `npx -y @wonderwhy-er/desktop-commander@latest` (plugin.json, no cmd /c, no pin).

## DIAGNOSED (his paste, 2026-09-05)
    node -v → v12.10.0      npx -v → 6.10.3
    where.exe npx → C:\Program Files\nodejs\npx.cmd  (first)   c:\msys64\mingw64\bin\npx.cmd  (second)
    npx -y @wonderwhy-er/desktop-commander@latest → "ERROR: You must supply a command."
Cause [DOMAIN, npm]: npx 6 (Node 12, 2019) has no `-y`; it eats the flag, finds no command, exits → "Connection closed".
Desktop Commander itself wants Node ≥18 [MINE ~90%; falsifier: its package.json `engines`]. So Node 12 fails twice over.

## UPDATE (his paste #2): mingw64 node is v24.16.0; `c:\msys64\mingw64\bin\npx -y @wonderwhy-er/desktop-commander@latest` ran SILENT — works, cache warm.
Chosen route: point the plugin at that npx. The plugin cache is read-only to me ("plugin, skill, or knowledge content") — the edit is yours.

## DO (chosen route — one line-edit)
File:  %APPDATA%\Claude\local-agent-mode-sessions\948346fb-5634-4a0d-bbc2-9a649c945411\8460b5c5-7709-448e-a1b9-45577b5e1670\rpm\plugin_01S1HcuzG4CPx8bTxZDQAguG\.claude-plugin\plugin.json
       (/c/Users/corwi/AppData/Roaming/Claude/local-agent-mode-sessions/948346fb-…/8460b5c5-…/rpm/plugin_01S1HcuzG4CPx8bTxZDQAguG/.claude-plugin/plugin.json)
1. copy plugin.json plugin.json.bak
2. change ONE line:   "command": "npx",   →   "command": "C:/msys64/mingw64/bin/npx.cmd",
   (forward slashes: valid for spawn, no JSON escaping to get wrong)
   ready-made full copy: AS4CE0001/h/plugin.json.desktop-commander-mingw64 — same bytes except that line
3. fresh Cowork session (this one's failure is cached ~15 min)
Caveat: a plugin update may overwrite this file — then re-apply, or take the durable route below.

## DURABLE ROUTE (later, no config edits)
Uninstall/rename C:\Program Files\nodejs (Node 12) so bare `npx` resolves to mingw64 — only if msys64\mingw64\bin is on the REGISTRY path:
    [Environment]::GetEnvironmentVariable('PATH','User'); [Environment]::GetEnvironmentVariable('PATH','Machine')
pacman then keeps Node current for every GUI app.

## WHEN (original)
Before the next Cowork session that should have DC.

## DO
1. Check the second Node first — it may already be current:
       c:\msys64\mingw64\bin\node.exe -v
2. Upgrade the one the Claude app finds first (C:\Program Files\nodejs): nodejs.org → current LTS (24.x today) MSI.
   It replaces the Node 12 install in place; PATH is untouched. (winget alternative: `winget upgrade OpenJS.NodeJS.LTS`.)
   Do NOT reorder PATH to put mingw64 first for every GUI app — wider than the need.
3. New PowerShell, then:
       node -v; npx -v
       npx -y @wonderwhy-er/desktop-commander@latest
   this one sits SILENT (waiting on stdio) — ~10 s, Ctrl-C. Cache warm.
4. Fresh Cowork session.

## CHECK
- node ≥ 18, npx ≥ 7; step 3 silent, no "must supply a command"
- if anything on Avalon still needs Node 12, say so before step 2 (nvm-windows is the side-by-side route)

## TELL-ME
"node upgraded, silent run OK" — then I run `get_config` → `set_config_value allowedDirectories` (the three roots) → one `read_file` under F:\claude\c4 with no folder dialog = done.

## If it still closes with Node ≥18
Bare `npx` may need `cmd /c npx …` on Windows (reference note). Plugin-config edit on your side; I'll write the block.
