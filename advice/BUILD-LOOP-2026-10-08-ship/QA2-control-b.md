produced-by: control-b (no persona; claude-opus-5-5) · 2026-10-08 · QA pass N=2 of the BUILD-LOOP ship
licence of this note: CC-BY-SA-4.0
Read only. This file is the only thing written in a mount. Scratch files went to $HOME/qa2b, outside the mounts.
Tavern's selftest ran with its working folder at $HOME/qa2b/st. Afterwards `find -newer` showed nothing new
in either project (.git excluded).

# QA2 -- control-b

## OBSERVED: the QA plans' own checks, run again in the device shell
- topoforge: run.sh KIT GREEN. prove-red.sh PROVE-RED OK (14). verify.sh "every file in SHA256SUMS matches (51 files)".
  The SPDX grep passes. The WARN check, tests/browser/RESULT.txt, now reads GREEN, and its "File tested" sha 681cac2e... is today's index.html.
- tavern: gp-check 14 passed, 0 failed, GREEN. There are 0 non-ASCII lines and no line of 2000+ characters.
  The WARN check (RESULT.txt) reads GREEN for 0eb956f5..., which is today's tavern.py.
  `python3 tavern.py selftest` gives 167 checks, 0 failed, GREEN. scan.sh says CLEAN. `sha256sum -c` is all OK.
- plugin: tp2mt --check "every claim holds". tp2mt-tests pass=17 fail=0. tavernface 7/7.
  pn1ck says 1 pin, all match. launch-cmd-tests is GREEN, and "real cmd.exe" is still NOT TESTED.
  c4face-tests GREEN. makefile-bytecode-tests GREEN.
  The WARN check (`find polygram -name __pycache__ -newer releases/1.0.3`) is now EMPTY.
- repos: `git log` in projects/topoforge gives 30f87a4, author Bryant (index.html = 6a76e9ca..., his 1.5), then e35fc7f by Corwin.
  In projects/garden-pony it gives 0b3649b, author Bryant (tavern.py = 6ffaa566..., his 2.3.1), then patches 01, 02, 03, then project files.
  `git show <c>:tavern.py | sha256sum` after patch 03 = 0eb956f5..., the working file. Both working trees are clean. No remote is set.

## Part 1: is each QA1 row really fixed? (FOLD-QA1 numbering)

| row | verdict | evidence |
|---|---|---|
| 1 story hint contrast | HELD | index.html:2312 `id="storyAbout" style="color:var(--text-2)"`. RESULT.txt GREEN for 681cac2e. |
| 2 README/NEWS stale | HELD | `grep -n -i 'in progress\|not released'` returns nothing. README:49 "Not checked yet: drawing and moving shapes ... keyboard alone" is honest, not stale. |
| 3 sums/release omit tests/spec/patches | HELD | SHA256SUMS lists 28 tests/, 1 spec/, 1 patches/ (51 files). Every tracked file except .gitignore and SHA256SUMS itself is in it. |
| 4 topoforge REUSE | NOT HELD (regressed) | `reuse lint` (6.2.0) says not compliant: ".gitignore" has no licence. .gitignore was made at 16:25:19, after FT's clean lint at 09:22. See G1. |
| 5 Bryant's 1.5 a11y | HELD | index.html:237 `<nav id="menubar" aria-label="Menus">`, :236 `<h1 class="brand">`, `--text-3:#646d7a` / `#868f9c`. RESULT GREEN 33/33. One moderate (heading-order) is left and declared. |
| 6 tavern VERSION | HELD | tavern.py:184 `VERSION = "2.3.1+gp.1"`. gp-check K7 (stock 2.3.1 peer) is in the 14 passed. |
| 7 focus drop | HELD | tavern.py:7035 `if (fid) regRefocus(fid);`, :7670. RESULT GREEN for 0eb956f5. |
| 8 Share in Drops name | HELD | tavern.py:7767 `"aria-label": "Share in Drops: " + t.name + ...`. |
| 9 tavern NEWS/README | HELD | NEWS:50 now says the browser run found the faults. README:61 names what is left. |
| 10 tavern REUSE | NOT HELD (regressed) | Same as row 4: `reuse lint` in garden-pony says not compliant, file ".gitignore". See G1. |
| 11 secrets scan | HELD | `sh tests/scan.sh`: "sb: clean; read 25 ... allowed 14", "scan: CLEAN", exit 0. |
| 12 tablist "+" and no h1 | HELD | :6921 nav has no role, only an aria-label. :6990 two `div.tabgroup role=tablist`. :6331 `<h1 class="vh">`. |
| 13 Python floor | HELD | launch.cmd:23, :65, :69 say 3.10 and "too old". It has still never run under a real cmd.exe (declared). |
| 14 c4face guard | HELD in part | c4face is OFF by default (`C4_ON`/`c4.on`, c4face.py:119). The allow-list catches backtick, binding, constructor, import(), computed require, and aliased require. But it misses unicode-escaped names. See G3. |
| 15 Windows-only mint | HELD | plugin.py:1165 WINDOWS_ONLY and :1172 "Made for Windows only." launch-cmd-tests M5 PASS. |
| 16 __pycache__ from make dist | HELD | Makefile:9 `export PYTHONDONTWRITEBYTECODE = 1`. The QAPLAN WARN is empty now: polygram/__pycache__ is gone. FP said it could not delete it, so someone else did. Not seen who. |
| 17 old dist is the GIZA-failing shape | NOT HELD (Corwin's, declared) | dist/vibrobeast.plugin is still 08:05:22. `cat releases/1.0.4` still has only "start ... / from 1.0.3". Waits on his `make dist`. |
| 18 stock 2.3.1 said | HELD | tavernface.py:48 CARRIES, returned in both status answers (:137, :145). |
| 19 launch.cmd credit | HELD | launch.cmd:4 `Copyright 2026 Bryant Frankford ... and Corwin Brust`. |
| 20 no repos / no history | HELD locally, open remotely | Both local repos exist with history. No remote is set, and `git ls-remote` is still owed (waits on the GitHub sign-in, declared). |
| 21 Bryant first, of the working file | HELD | First commits change exactly `index.html` (3536+) and `tavern.py` (12435+), author Bryant, with bytes equal to his upstream sha. |
| 22 transcripts at AS4CE0001 root | NOT HELD | `git status --porcelain` still lists 24 root `?? *.txt` (21.txt, c.txt ... c27.txt, fix-comic-...txt). `git check-ignore -v c.txt` exits 1, so they are not ignored. The only remote is `code.bru.st/corwin/as4ce`. No design names where the GitHub "vibrobeast" repo is built from. |
| 23 key in session home | NOT HELD | QAPLAN-repos.md:2 is unchanged (`ssh -i $HOME/.ssh-il/key`). There is no script that puts it back. `grep -rn 'ssh-il\|\.keys'` over advice/ and bin/ finds only the QA reports. The key is still in session home (08:32). |

Count: 16 HELD; 2 HELD in part (14: guard misses escaped names; 20: local only, not pushed); 4 NOT HELD (4 and 10 regressed by one new file; 22 and 23 untouched); 1 waits on Corwin by design (17).

## Part 2: new findings (7). "What is wrong" is JUDGED. "Evidence" is OBSERVED.

| id | task | severity | what is wrong, in plain words | evidence | falsifier | fix you suggest |
|---|---|---|---|---|---|---|
| G1 | repos (topoforge, tavern) | issue | Making the git repos added a `.gitignore` to each project with no licence entry. Both projects stopped being REUSE compliant after the fixers had made them clean. No check in either QA plan runs `reuse lint`, so nothing went red. [MINE] | `reuse lint` in both projects: "The following files have no copyright and licensing information: * .gitignore", "not compliant". `ls -la --time-style=full-iso .gitignore`: 16:25:19 (topoforge), 16:25:56 (garden-pony). FT/FG lint was clean at 09:22/09:27. | `reuse lint` returns compliant with no change, e.g. because a newer reuse ignores .gitignore. Mine is 6.2.0, the same one the fixers used. | Add `.gitignore` to the code entry in each REUSE.toml (or give it an SPDX comment line), and commit. Add `CHECK: ... reuse lint` to QAPLAN-topoforge and QAPLAN-tavern so this cannot slip again. |
| G2 | repos (Bryant hand-off) | issue | The note written for Bryant is stale. It still says "patches 01 then 02" and "VERSION still says 2.3.1 ... Your call on numbering". It does not list today's changes to HIS code: the menubar role, labelled fields, --text-3 colours, h1 in TopoForge, and tablist/h1/sb:allow in Tavern. "Bryant first" means he hears about edits to his own lines from us, in the note made for him. [HIS] | `ls -la` LENS-2026-10-08-topo-pony/30-HANDOFF-FOR-BRYANT.md: 07:34, before FT/FG. Line 17 "patches 01 then 02 on 2.3.1 reproduce tavern.py". Line 29 "VERSION still says 2.3.1 in the patched file". `grep -i 'menubar\|tablist\|text-3'` on it: none. The lists exist only in 27-FT "Changes for Bryant" and 28-FG item 3a-3e. | A newer hand-off for Bryant exists elsewhere, or the repos' NEWS/ChangeLog are agreed to be his hand-off. topoforge/ChangeLog:4-8 does name the --text-3 and menubar changes, but garden-pony has no such list for him. | Regenerate 30-HANDOFF (or a 31-) from the 27-FT and 28-FG Bryant lists and PENDING items. Strike item 2 (VERSION) as handled with 2.3.1+gp.1. Do this before any push or invite. |
| G3 | plugin | warning | c4face's new allow-list claims "anything it cannot read is a hit". JavaScript lets a name be spelled with unicode escapes, and the lexer does not decode them. `require("fs")` and `process.env` pass the guard with zero hits, and node runs them: fs loads, env is read. c4face is OFF by default and is worded as a tripwire, so this is a warning, not an issue. [DOMAIN] | `scan_js('requir\\u0065("fs")', True)` gives `([], [])`. File $HOME/qa2b/u.js: `scan_js` gives `([], [])`. `node u.js` prints `function` then `1` (node at /usr/bin/node). | C4's c4-mcp.js is loaded in a way that rejects escaped identifiers, which node does not do. Or Corwin rules the tripwire only has to catch honest edits, and an escaped name is not honest. Then this is noise, but the "anything it cannot read" sentence should go. | In js_tokens/scan_js, treat any `\` inside an identifier token (outside strings, comments and regex) as a hit: "escaped name, cannot read". Add `require` and `process` plants to c4face-tests --prove-red. |
| G4 | topoforge | warning | bin/ship.sh writes the tarball into dist/, but the new .gitignore ignores only node_modules/, *.pyc and __pycache__/. After Corwin runs `sh bin/ship.sh 1.6` (the next step FT hands him), `git status` shows dist/, and a `git add -A` would commit the release tarball into the repo it was made from. [MINE] | topoforge/bin/ship.sh:14 `tgz=dist/topoforge-$v.tar.gz`, :24 `mkdir -p dist`. `cat .gitignore`: `node_modules/ *.pyc __pycache__/`. | The plan is to commit release tarballs on purpose. Or ship.sh is meant to be run only in a scratch copy. Nothing in RECIPE.org or 27-FT says either. | Add `dist/` to topoforge/.gitignore (same commit as G1). |
| G5 | tavern | warning | garden-pony's SHA256SUMS covers 9 of its 26 tracked files. It leaves out README.org, NEWS, INSTALL, AUTHORS, ChangeLog, REUSE.toml, tests/SPEC.md and the RESULT notes. This is the same gap QA1 row 3 closed for TopoForge, but it was never raised for Tavern. [MINE] | `grep -c . SHA256SUMS` gives 9. `git ls-files \| grep -v -F -f <(awk '{print $2}' SHA256SUMS)` lists the 17 files above. | The sums are meant only to prove the code reproduces from patches, with project files left to git's own hashes. If 28-FG or INSTALL says so, this is fine. I did not find that said. | Either sum every tracked file except SHA256SUMS (as TopoForge now does), or say in INSTALL what the sums cover and why. |
| G6 | repos | warning | Bryant's first commit has different dates in the two repos. TopoForge's says 00:03 (plausibly his own date). Tavern 2.3.1's says 2026-10-08 16:25:43, a few seconds before our patch commits. Then `git log` tells a reader Bryant wrote Tavern 2.3.1 today, in the same minute as our patches. [HIS] | `git log --date=iso` in garden-pony: `0b3649b Bryant Frankford ... 2026-10-08 16:25:43`, then 0ee9f5f 16:25:45. In topoforge: `30f87a4 Bryant Frankford ... 2026-10-08 00:03:00`. | 16:25 is a deliberate "date received" convention, said somewhere. Or Bryant's 2.3.1 really was released at that moment. | Before the first push (history is still local, so this is cheap), re-make 0b3649b with `GIT_AUTHOR_DATE` = his release time (Tavern-Setup or upstream file date), as was done for TopoForge. Then replay the patches. Say the convention in DESIGN-repos. |
| G7 | repos / plugin | warning | Row 22 is still open, and the push it guards is now one step closer. The 24 pasted chat transcripts sit untracked and not ignored at the AS4CE0001 root. Its only remote is code.bru.st/corwin/as4ce, and no design says what tree becomes github.com/inputloop/vibrobeast. This is the one item with an outward blast radius. [MINE] | See row 22 above (`git status`, `git check-ignore` exit 1, `git remote -v`). DESIGN-repos.md: "First wave: topoforge, tavern (with garden-pony), vibrobeast", with no source named. | DESIGN-repos (or Corwin's make dist plan) builds the vibrobeast repo from dist/ or a clean export. Say so, and this is closed. | Write one line in DESIGN-repos naming the vibrobeast repo's source. Add the root `*.txt` pattern (or `/c*.txt /21.txt /fix-comic-*.txt`) to AS4CE0001/.gitignore, or move them into h/. Run sb1rn over exactly what will be pushed. |

Not findings (checked and cleared): selftest 167/0 GREEN. The patch chain in git reproduces the working tavern.py at every
step's sha (7189227b, 4b8ecbf0, 0eb956f5). Tool names are limited to `[a-z0-9][a-z0-9_.-]{0,31}` (tavern.py:4215), so
the new `reg-*-NAME` ids are always valid ids. Both repos' working trees are clean. RESULT.txt in both projects names the
sha of the file now on disk.

## LENS (control-b's side)
1. Mine: the fixers did real work. Every accessibility and version row held, and the checks prove it. What broke came from the step after them (git init added a file), and the QA plans had no gauge for it (G1).
2. What I ascribe to Corwin: he wants Bryant handed full, working, credited software. The code is nearly there. The Bryant-facing words (G2) and the history dates (G6) lag behind the code.
3. His influence on mine: "Bryant first" made me rank the stale hand-off note (G2) an issue. It is the place Bryant learns we edited his lines.
4. Mine on his: G6 and G1 are cheapest now, while history is local. After a push, rewriting Bryant's commit is a force-push.
5. Persona and inverse: Bryant reading `git log` asks "when did I write this, and what did you change of mine?" Today the log answers the first wrongly for Tavern, and the hand-off answers the second only in our internal hand-backs.
6. From principles: the freedom to study needs the licence of every file stated (G1) and the sums to cover what is shipped (G5). The transcripts (G7) are the one place carelessness reaches other people.
