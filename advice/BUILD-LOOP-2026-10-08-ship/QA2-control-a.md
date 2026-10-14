produced-by: control-a (QA pass 2 reader, no persona; claude-opus-5-5) · 2026-10-08
licence of this note: CC-BY-SA-4.0 · read only: this file is the only thing I wrote under mnt/
(scratch copies went to the session home: ~/gpchk, ~/clt; nothing in mnt/Bryant)

# QA2 control-a: are the QA1 rows fixed, and what is new

## OBSERVED (device shell; command, then what came back)
- TopoForge, in projects/topoforge: `tests/run.sh` KIT GREEN; `tests/prove-red.sh` OK (14 cases);
  `bin/verify.sh` OK (51 files); `bin/test.sh` exit 0; licence grep 3 hits.
  `head -1 tests/browser/RESULT.txt` = GREEN, and its "File tested" sha = 681cac2e..., the same as `sha256sum index.html`.
- Tavern, in projects/garden-pony: `gp-check.sh` 14/0 GREEN; `--prove-red` PROVE-RED OK; `tests/scan.sh` CLEAN;
  `scan.sh --prove-red` OK; non-ASCII 0; no line of 2000+ characters; `sha256sum -c SHA256SUMS` all OK;
  RESULT.txt GREEN for 0eb956f5... (= tavern.py). Selftest, run on a copy in ~/gpchk: 167 checks, 0 failed, SELFTEST GREEN.
- Plugin, in AS4CE0001: `tp2mt --check` holds; tp2mt-tests pass=17 fail=0; tavernface 7/7; pn1ck 1 pin, match;
  launch-cmd-tests GREEN; c4face-tests GREEN; makefile-bytecode-tests GREEN.
  `find polygram -name __pycache__ -newer releases/1.0.3` now prints nothing, because polygram/__pycache__ is gone.
  dist/vibrobeast.plugin is still dated 08:05:22, and there is no dist/posix/.
- Repos: both projects are git repos on branch main, with no remote and a clean `git status --ignored`.
  - topoforge: 30f87a4 by Bryant (index.html only), then e35fc7f by Corwin.
  - garden-pony: 0b3649b by Bryant (tavern.py only), then 01, 02 and 03, then the project files, all by Corwin.
  - Blobs: `git show 30f87a4:index.html | sha256sum` = 6a76e9ca... (upstream 1.5). `git show 0b3649b:tavern.py` = 6ffaa566... (upstream 2.3.1).
  - The patches applied in order give 7189227b, 4b8ecbf0 and 0eb956f5. Those equal the tavern.py in commits 0ee9f5f, ba71a09 and afae35e.
  - A fresh `git clone` of each into ~/clt runs every kit green, with one exception: garden-pony's `tests/scan.sh` exits 2 with
    "NOT CHECKED: sb1rn not found".
  - The QAPLAN-repos ls-remote for all three repos still answers "...the correct access rights and the repository exists."

## QA1 rows: HELD or NOT HELD

| row | verdict | evidence |
|---|---|---|
| 1 story hint contrast | HELD | index.html:2312 `id="storyAbout" style="color:var(--text-2)"`; RESULT.txt GREEN for this exact file |
| 2 README/NEWS stale | HELD | NEWS: "Version 1.6 (2026-10-08; built and tested; no release packed or signed yet)"; README:41-60 lists what was checked and what was not |
| 3 ship list omits tests/spec/patches | HELD | SHA256SUMS 51 rows (28 tests, spec, patches); `comm` against `git ls-files` differs only by .gitignore and SHA256SUMS itself; ship.sh tars that list |
| 4 REUSE tests/browser (topoforge) | HELD (read, not linted by me) | REUSE.toml last table: tests/browser/RESULT.txt, tests/fixtures/*.md -> CC-BY-SA-4.0 |
| 5 Bryant's 1.5 a11y criticals | HELD (by RESULT.txt; kit not re-run by me) | RESULT.txt GREEN; 27-FT lists each change for Bryant |
| 6 VERSION label | HELD | tavern.py:184 `VERSION = "2.3.1+gp.1"`; gp-check K7 (stock peer) green |
| 7 Tools focus drop | HELD for the Tools tab | tavern.py:7024 fid, :7035 `regRefocus(fid)`; RESULT GREEN. See N3 for the rest of the page |
| 8 Share in Drops name | HELD | tavern.py:7767 `"aria-label": "Share in Drops: " + t.name + ...` |
| 9 tavern NEWS/README claims | HELD | README.org:55-63 says what ran and what did not |
| 10 tavern REUSE | HELD (read; FG reports `reuse lint` compliant) | REUSE.toml path list includes tests/browser/*.mjs and prose rows |
| 11 secrets scan | HELD here, see N6 for a clone | scan.sh CLEAN; prove-red OK |
| 12 tablist "+", no h1 | HELD | tavern.py:6990 two `tabgroup role=tablist` divs; RESULT GREEN |
| 13 Python floor | HELD (text only) | launch.cmd:93 `>= (3, 10) else 3`, :103 py -3 same floor; launch-cmd-tests GREEN |
| 14 c4face guard | HELD as re-scoped (off by default, tripwire) | c4face.py:119-121 C4_ON / c4.on; c4face-tests GREEN |
| 15 Windows-only mint | HELD in text, not built | plugin.py:1165 WINDOWS_ONLY; no dist/posix exists yet (needs make dist) |
| 16 __pycache__ | HELD | Makefile:9 `export PYTHONDONTWRITEBYTECODE = 1`; WARN now passes |
| 17 old dist plugin | NOT HELD (Corwin's step) | dist/vibrobeast.plugin 2026-10-08 08:05:22; releases/1.0.4 still has no finish line |
| 18 stock Tavern said | HELD (by tests) | tavernface-tests 7/7 (F1, M1 check the stock-2.3.1 words) |
| 19 launch.cmd credit | HELD | launch.cmd:3-5 Bryant first |
| 20 no repos | NOT HELD (half) | local repos exist; GitHub ls-remote: not found for all three |
| 21 Bryant's bytes first | HELD | blob sha256s above; author "Bryant Frankford <nathanielfrankford@gmail.com>" on 30f87a4 and 0b3649b |
| 22 transcripts at AS4CE0001 root | NOT HELD | see N2 |
| 23 key in session home | NOT HELD | ~/.ssh-il/key still 08:32 session home; `cmp` = same as projects/.keys/id_ed25519; no script found in AS4CE0001/bin or the ship folder |

## New findings

| id | task | severity | what is wrong, in plain words | evidence | falsifier | fix you suggest |
|---|---|---|---|---|---|---|
| N1 | tavern, topoforge | issue | The note we plan to give Bryant is out of date. It says patches 01 and 02 (there are now three), "VERSION still says 2.3.1" (fixed), selftest 164 (now 167), and that his received files were not changed. It does not list the accessibility changes FT and FG made to his own code, which he should take, change or drop. If he reads this note first, he gets the wrong picture. | LENS-2026-10-08-topo-pony/30-HANDOFF-FOR-BRYANT.md, last written 07:34, before 27-FT and 28-FG; its lines "patches 01 then 02", "Pending 2. VERSION still says 2.3.1", "selftest 164/164" | a newer hand-off for Bryant exists somewhere else and supersedes it | Regenerate 30-HANDOFF from 27-FT "Changes for Bryant", 28-FG "LIST FOR BRYANT" and "PENDING FOR BRYANT"; drop pending item 2; say "three patches". |
| N2 | repos (vibrobeast) | issue | The vibrobeast push is not safe yet, either way you do it. 24 chat transcripts (c.txt ... c27.txt, 21.txt, fix-comic-...txt) sit untracked at the root, and .gitignore does not exclude them, so `git add -A` would publish them. But the new plugin sources are also untracked: polygram/launch.cmd, mcp/c4face.py, mcp/tavernface.py, mcp/tavern_upstream.py, mcp/NOTICE-tavern, bin/pn1ck. So a push of only tracked files would ship a vibrobeast without the GIZA fix. | `git -C AS4CE0001 status --short`: 91 entries, 24 `??` at top level, including the files named | the push is planned from `make dist`'s output, not from the git tree (then say so in DESIGN-repos) | Add the transcripts to .gitignore (or move them to h/ or Claude outputs/), `git add` the named sources by name, then run sb1rn on the staged diff before any push. |
| N3 | tavern | warning | (Bryant's, from 2.3.1.) Keyboard focus is yanked by other people's activity. Every state or presence event (someone joins, leaves or renames) rebuilds the whole tab row, and on Tasks, Drops, Search and Settings it rebuilds the view too, so focus falls to the page. The Tools-tab fix covers only its own view. The browser kit runs on a quiet machine, so it cannot see this. It is not in PENDING FOR BRYANT. | tavern.py:6749 `kind === "presence"` -> scheduleState; :6653-6654 renderTabs(); renderView() if not editing; :6988 `clear(nav)`; same in upstream :6067, :6307 | with two machines linked, focus stays on a tab button or a Drops button while the other side joins or leaves | List it for Bryant in plain words. If in reach, generalise FG's fid/refocus to renderTabs and every view (about 3 lines each). Add a kit check that fires a presence event while a button has focus. |
| N4 | topoforge | warning | Someone who receives TopoForge cannot run the browser check. README and INSTALL never say how to run it or what it needs (Node, Playwright, Chromium, axe-core), yet ship.sh refuses to pack without its GREEN result. The kit's own header says playwright defaults to "global", but the code defaults to the cloud path /opt/npm-tools. Garden-pony's README does give the command and the axe note. | `grep -n -i 'browser' README.org INSTALL`: no run line; topoforge.browser.mjs:14 "default: global" against :22 `'/opt/npm-tools/node_modules/playwright'` | README or RECIPE.org already holds a run line I missed (RECIPE.org:53 names the kit but gives no command) | Add a "Check it in a real browser" block like garden-pony's README:55-63. Fix the header comment so it says what the code does. |
| N5 | topoforge, tavern | warning | Running either browser kit from the repo folder leaves a new untracked folder behind (out-topoforge/ or out-tavern/), because the default output folder is relative to where you are and .gitignore does not list it. That is a small trap for "no hand edits": the next `git add -A` picks it up. | topoforge.browser.mjs:26 `process.argv[3] \|\| 'out-topoforge'`; tavern-tools.browser.mjs:48 `'out-tavern'`; both .gitignore files = node_modules/, *.pyc, __pycache__/ | the kits are only ever run from a scratch folder, as written down somewhere | Add out-*/ to both .gitignore files, or default the output folder to the OS temp folder. |
| N6 | tavern | warning | In a fresh clone the secrets scan cannot run: it looks for Corwin's sb1rn two folders up and exits 2 "NOT CHECKED". That is honest, but README lists `sh tests/scan.sh` among the checks with no hint, and only INSTALL says "needs Corwin's sb1rn" without saying where to get it. | `git clone` into ~/clt/gp, `sh tests/scan.sh` -> exit 2 "NOT CHECKED: sb1rn not found (set SB1RN=path)"; README.org:36; INSTALL:13 | sb1rn is published in a repo Bryant can reach and README links it | Say where sb1rn comes from (the vibrobeast repo path, once pushed) next to README:36, or vendor it with a pin as polygram does. |
| N7 | repos | warning | Bryant's TopoForge commit carries a date nobody wrote down: 2026-10-08 00:03:00 UTC. That is not the upstream file's time (06:52:15), not the commit time (16:25), and not the rule used for his Tavern commit (16:25:43, the commit time). A date under his name should come from somewhere we can name. | `git -C topoforge log --format='%an %ad'` -> Bryant 2026-10-08 00:03:00; `ls --full-time upstream/topoforge-1.5.html` 06:52:15 | the 00:03 time comes from his drop or message (e.g. the Tavern drop time) | Name the source in the commit message, or use one rule for both (his release or drop time if known, else the commit time), and re-make the commit before the first push. |
| N8 | plugin | warning | Step 1 of the card has a stale check. It says to run `ls polygram/__pycache__ -lt` and see "nothing newer than this morning's 08:05 files". That folder no longer exists, so the command prints an error, and a reader cannot tell whether that counts as pass or fail. | CARD-giza-launch.md step 1 CHECK; `ls polygram/__pycache__` -> "No such file or directory" | Corwin's make dist recreates the folder (then the export failed, which the check would catch) | Change the CHECK to: "`ls polygram/__pycache__` says No such file or directory (that is the pass)". |

8 new findings: 2 issues and 6 warnings. Rows 17, 20 and 23 are waiting on Corwin's own steps (make dist, GitHub sign-in, a key script). Row 22 is not fixed and is the same thing as N2.

## JUDGED (kept apart from the evidence)
- [MINE] The three projects are in good shape as software. Each kit passes, proves itself red, and runs from a fresh clone. What is left is all at the boundary: what gets pushed, what Bryant reads, and what a receiver can rerun.
- [MINE] N2 is the only finding here that can do damage that is hard to take back (private transcripts in a public repo). Fix it before any vibrobeast push.
- [DOMAIN] N3 is Bryant's code and older than our work. "Accessibility forward" makes it worth one plain sentence to him even if we do not fix it.
- [MINE] I did not re-run the browser kits, `reuse lint` or `make dist`. For rows 4, 5, 10, 15 and 18 my HELD rests on reading the files and the RESULT.txt sha match, not on a fresh run.

## LENS (six lines, my side)
1. Mine: the fixes held. The ship is now blocked by packaging and paperwork, not by code.
2. Theirs (Bryant): he will judge us by the hand-off note and the first `git log`. Both should say exactly what we changed in his files, under a date we can explain.
3. Their pull on mine: his authorship is the first commit. That makes N7 and N1 about courtesy, not cosmetics.
4. Mine on theirs: only we can keep Corwin's transcripts out of a repo that Bryant may later make public (N2).
5. Persona and inverse: the eager reader says "push now, it's all green". The cautious reader says "wait for GIZA". The middle path: fix N1, N2 and N7 (all small), then push the two private repos. vibrobeast waits for make dist.
6. From principles: free software means someone else can rerun what we ran. N4 and N6 are where they still cannot.
