status: DESIGN · 2026-10-08 · task plugin (vibrobeast, release 1.0.4 torn -> finish)
His words: "errors from make dist ... (no idea how to set this)"; "on GIZA MCP servers did not come up?";
"c4's MCP server: can we include/support this in our plugin? ... an effective work around for the
Filesystem connector bug ... to the extent shapes known to C4 can be transacted in terms of C4".
Design:
1. make dist: tp2mt's network claims learn tavernface (Bryant's Tavern, off until tavern.on, MCP mode
   only, local node 127.0.0.1 only); Words/Privacy text say so; a planted test proves the off-switch claim.
2. GIZA: see HYPOTHESIS-giza-mcp.md. Windows mints launch through cmd.exe + servers\launch.cmd that finds
   Python by itself (Tavern-Setup's :TVL_FIND as the model, credited), never the WindowsApps stub; no
   JSON edits by the person; plain stderr sentence when no Python is found.
3. c4face: a server that runs C4's own c4-mcp.js (node, stdlib) from the person's C4 tree, found by
   itself (C4_ROOT, pref c4.root, sibling ../c4); node found the same way python is; off with a plain
   status when no C4 tree or no node; adds TopoForge <-> C4 canonical diagram transacting only if it
   fits cleanly (say what was done).
