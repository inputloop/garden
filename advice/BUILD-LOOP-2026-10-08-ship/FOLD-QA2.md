produced-by: claudewin (fold of QA pass 2) · 2026-10-08 · readers: persona-penumbra (P, g0001->g0002), persona-vibrobeast (V, g0001->g0002), control-a (A), control-b (F)
QA1 rows: held 16-19 of 23 by reader; all agree rows 17 (make dist), 20 (push), 22 (transcripts), 23 (key script) open; 4 and 10 RED AGAIN.

| # | task | sev | finding | found by | fix |
|---|------|-----|---------|----------|-----|
| 1 | topoforge,tavern | issue | new .gitignore (repo step) has no licence: reuse lint fails; no QAPLAN line runs reuse lint | P V F | SPDX in .gitignore; add CHECK: reuse lint |
| 2 | tavern(handoff) | issue | 30-HANDOFF-FOR-BRYANT.md stale (07:34): 2 patches, VERSION, selftest 164, omits our edits to his code | V A F | rewrite from 27/28 |
| 3 | repos | issue | Bryant's Tavern commit dated at import (16:25); TopoForge 00:03 has no named source | P V A F | rebuild local history with sourced dates (drop/zip times), before push |
| 4 | plugin/repos | issue | vibrobeast push: `git add -A` would publish ~24 chat transcripts; tracked-only push misses new plugin sources; no design says what tree the GitHub repo is | P A F | ignore transcripts; repo = minted dist/vibrobeast tree after make dist (pend to Corwin) |
| 5 | tavern | warn | garden-pony SHA256SUMS covers 9 of 26 tracked files | P F | cover all shipped files |
| 6 | plugin | warn | tavernface says "2.3.1+gp", build says "2.3.1+gp.1" | P | match |
| 7 | plugin | warn | c4face allow-list misses unicode-escaped names (fs) | F (control-only) | normalise escapes in the lexer; stays off by default |
| 8 | both apps | warn | heading order left to Bryant, though our fixes already edit his CSS | V (persona-only) | fix ours |
| 9 | topoforge | warn | ChangeLog lacks the 1.6 Story work entry | V | add |
| 10 | topoforge | warn | README gives no way to run browser kit; kit header disagrees with code; out-*/ dirs not ignored | A | doc + ignore |
| 11 | tavern | warn | clone's scan.sh exits 2 without sb1rn; README silent | A | say where; fall back clearly |
| 12 | tavern | warn | Bryant's 2.3.1: presence/state events rebuild tab row -> focus falls to page (:6749 :6654 :6988) | A | in reach: keep focus; list for Bryant |
| 13 | plugin | warn | GIZA card: stale __pycache__ step; does not check the installed .plugin is the new build | P A | update card |
| 14 | plugin | warn | two red python test modules (bytes boundary in llamabridge tests; ft1mt footer row SOFT-SKILLS/build-loop) never folded | V | fix in reach |

Persona vs control (pass 2): persona-only 8, 9 (V g0001 "check the blocker"); control-only 7, 10, 11, 12; both P (g0001 clock) and V (g0002 last-hand) found row 1 by timing; controls found it by re-running lint. Mutations: penumbra g0002 (sha over mtime; re-run claims older than the last tree change), vibrobeast g0002 (outward papers checked after the LAST hand). Neither g0001 falsifier fired.
