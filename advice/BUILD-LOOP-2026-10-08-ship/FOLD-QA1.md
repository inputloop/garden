produced-by: claudewin (fold of QA pass 1) · 2026-10-08 · readers: persona-penumbra (P), persona-vibrobeast (V), control-a (A), control-b (F)
Convergence column: which readers found it. "persona-only" / "control-only" = one route; check another way before acting.

| # | task | sev | finding | found by | fix |
|---|------|-----|---------|----------|-----|
| 1 | topoforge | issue | Story hint #8a93a1 ~3.1:1 contrast (new in 1.6) | P V A F (+B1) | use existing --text-2 / #5b6472 |
| 2 | topoforge | issue | README/NEWS still say 1.6 in progress, keyboard unchecked | P V A F | refresh from B1 results |
| 3 | topoforge | issue | release recipe + SHA256SUMS omit tests/ spec/ patches/ | P V A F | ship them; sums cover them |
| 4 | topoforge | warn | REUSE: tests/browser RESULT.txt / CC note licensed wrong | F (control-only) | REUSE.toml rows |
| 5 | topoforge | warn | Bryant's pre-existing a11y criticals (menubar role, unlabelled fields, hint contrast) | B1 | in reach (D5): fix, list for Bryant |
| 6 | tavern | issue | VERSION "2.3.1" on a changed file; share_source labels it Bryant's (link check is PROTO only, :2149) | P V A F | suffix e.g. 2.3.1+gp.1 |
| 7 | tavern | issue | Tools tab: focus drops to top after Register/Approve/Revoke/Refresh (patch 02) | P V A F (+B1) | restore focus |
| 8 | tavern | issue | "Share in Drops" accessible name lacks visible words (:7751) | P V A F (+B1) | name starts with visible text |
| 9 | tavern | warn | NEWS/README claim keyboard+labels complete | P V | refresh |
| 10 | tavern | warn | REUSE gaps tests/browser | A F | REUSE.toml |
| 11 | tavern | warn | sb1rn secrets-scan hits on Bryant's token variable names, no pin/allow | P V | pin upstream (pn1ck-style) or sb:allow with reason |
| 12 | tavern | warn | Bryant's tablist "+" button (critical axe), no h1 | B1 | in reach: fix + list |
| 13 | plugin | issue | launch.cmd accepts Python 3.8 but Tavern needs 3.10 | P V | floor 3.10 (or per-server) |
| 14 | plugin | issue | c4face guard is a regex; misses backtick require, createRequire, process.binding, vm, os | P F | stronger check or on-by-default reversed |
| 15 | plugin | warn | a mint made on avalon is cmd-only: dead on macOS/Linux, unstated | F (control-only) | say so in README/manifest; mint both or detect |
| 16 | plugin | warn | __pycache__ comes from make dist's own run (torn 1.0.4, 08:05:18) | V A F | find who imports without -B in the dist path |
| 17 | plugin | warn | old dist/vibrobeast.plugin (08:05) is the GIZA-failing shape | A | Corwin re-runs make dist |
| 18 | plugin | warn | ships stock 2.3.1: no receipt fix / tavern_tools in plugin Tavern; unstated | P | say so in tavern_status + README |
| 19 | plugin | warn | launch.cmd copyright names only Corwin though it borrows Bryant's lines | P | credit Bryant |
| 20 | repos | issue | no repos, no git history yet | A F V | create (browser) + push |
| 21 | repos | issue | Bryant's bytes must be the first commit OF THE WORKING FILE, authored by him (blame) | V | commit upstream as index.html/tavern.py first |
| 22 | repos | warn | AS4CE0001 root holds ~22 pasted chat transcripts: never `git add -A` a public push | F (control-only) | push vibrobeast from its existing git remote state only; check .gitignore |
| 23 | repos | warn | key/known_hosts live in session home | A F | re-create from /f/claude/projects/.keys each session (scripted) |

Persona vs control (pass 1): all four found 1,2,3,6,7,8; persona-only: 11,13,18,19 (P/V); control-only: 4,15,22. Mutations recorded: penumbra g0001 (claim-older-than-evidence clock check), vibrobeast g0001 (check the blocker before accepting "pending for someone else"). Both mutations produced findings the controls did not (13, 6-blocker) and the controls found the outward-risk one (22).
