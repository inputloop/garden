produced-by: claudewin · 2026-10-08 · the brief every reader of QA pass N gets (same packet, same method)

You are one of four readers in a QA pass of Corwin's build loop (persona pair + control pair).
READ ONLY: do not edit any file except your own report. Never write in $HOME/mnt/Bryant.
Work through mcp__remote-devices__device_bash (paths in that shell).

Read: $HOME/mnt/AS4CE0001/advice/BUILD-LOOP-2026-10-08-ship/ — DESIGN-*.md, QAPLAN-*.md, HYPOTHESIS-giza-mcp.md,
25-P2-HANDBACK.md, 26-B1-HANDBACK.md, CARD-giza-launch.md, PROPOSAL-c4-topoforge.md; and
$HOME/mnt/AS4CE0001/advice/LENS-2026-10-08-topo-pony/ 21..24 handbacks and 30-HANDOFF-FOR-BRYANT.md.
Then look at the work itself as far as you judge useful:
 - plugin: $HOME/mnt/AS4CE0001/polygram/{plugin.py,launch.cmd,mcp/tavernface.py,mcp/c4face.py}, bin/tp2mt
 - topoforge: $HOME/mnt/projects/topoforge (index.html, spec/, tests/, README.org, RECIPE.org, AUTHORS)
 - tavern: $HOME/mnt/projects/garden-pony (tavern.py, patches/, tests/, README.org)
 - repos: not yet created (GitHub org inputloop, private repos topoforge / tavern / vibrobeast planned)
Goal stated by Corwin: "We want to distribute full and working software" back to Bryant, our usual way;
accessibility forward; no hand edits for people; Bryant credited first on his work.

Write ONE report file: $HOME/mnt/AS4CE0001/advice/BUILD-LOOP-2026-10-08-ship/QA<N>-<your-label>.md
Format: a findings table in plain words, one finding per row:
  id | task (plugin/topoforge/tavern/repos) | severity (issue | warning) | what is wrong, in plain words |
  evidence (command + output, or file:line) | falsifier (what would show you are wrong) | fix you suggest
Keep OBSERVED (with the command) apart from JUDGED. Only findings you can point at. 4-17 findings
(fewer if fewer are real; say so). Then a six-line LENS block from your side.
Reply with the path and a 6-line summary.

## Pass 2 additions (2026-10-08)
Also read FOLD-QA1.md and the fix hand-backs 27-FT, 28-FG, 29-FP. First check each QA1 row is really fixed
(say HELD or NOT HELD with evidence), then look for anything new. Repos now exist LOCALLY as git repos
(projects/topoforge, projects/garden-pony: Bryant's bytes as commit 1 under his name); they are not yet
pushed (waiting on a GitHub sign-in). vibrobeast's push waits on Corwin's make dist.
