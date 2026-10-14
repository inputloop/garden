produced-by: reader persona-vibrobeast (Claude, wearing the VIBROBEAST sheet at journal gen 1; claude-opus-5-5) · 2026-10-08 · QA pass 2
licence of this note: CC-BY-SA-4.0
read-only pass: no file changed except this one; nothing written in $HOME/mnt/Bryant. Scratch clones in session home $HOME/qa2vb (outside mnt).

# QA2 -- persona-vibrobeast

Habit worn (g0001): before I accept "pending for someone else", I check the blocker it names. New this pass: I read the
door's papers (hand-off letter, ChangeLog, licence lint) AFTER the last hand that touched the tree, not after the fixer's.

## Part 1 -- is each QA1 row really fixed?

| row | task | HELD? | evidence (OBSERVED) |
|---|---|---|---|
| 1 | topoforge | HELD | RESULT.txt line 1 GREEN, "File tested: index.html sha256 681cac2e..." = `sha256sum index.html` |
| 2 | topoforge | HELD | `grep -i 'in progress' NEWS README.org` -> none; README:49 "Not checked yet: drawing ... keyboard alone" is an honest gap, not a stale claim |
| 3 | topoforge | HELD | my QA1 falsifier, run: fresh `git clone`, `sh bin/ship.sh 1.6` exit 0; `tar tzf` lists tests/run.sh, spec/FACTS-v1.md, patches/, tests/browser/RESULT.txt (52 entries); unpacked: bin/test.sh 0, tests/run.sh KIT GREEN |
| 4 | topoforge | NOT HELD (regressed after the fix) | `$HOME/rv/bin/reuse lint` exit 1: ".gitignore" has no licence (46/47). FT's lint was clean; the repo step added the file later. See N2 |
| 5 | topoforge | HELD (one moderate left) | RESULT GREEN 33/33 per FT; heading-order left -- see N3 |
| 6 | tavern | HELD | tavern.py:184 `VERSION = "2.3.1+gp.1"`; gp-check K7 PASS in a fresh clone (stock 2.3.1 peer links) |
| 7, 8 | tavern | HELD (read, not re-run in a browser by me) | tests/browser/RESULT.txt GREEN, "File tested: tavern.py sha256 0eb956f5..." = `sha256sum tavern.py` |
| 9 | tavern | HELD | `grep -i complete README.org NEWS` -> none |
| 10 | tavern | NOT HELD (regressed) | `reuse lint` exit 1, ".gitignore" unlicensed (same cause as row 4) |
| 11 | tavern | HELD in the estate, NOT CHECKED in a clone | in mnt FG: scan CLEAN. Fresh clone: `sh tests/scan.sh` exit 2 "NOT CHECKED: sb1rn not found". See N8 |
| 12 | tavern | HELD (one moderate left) | FG kit GREEN; h1 + tablists per FG; heading-order -- see N3 |
| 13 | plugin | HELD (as text; real cmd.exe still the GIZA card) | `sh tests/launch-cmd-tests.sh` GREEN |
| 14 | plugin | HELD as reworked (tripwire + OFF by default) | `sh tests/c4face-tests.sh` GREEN c4face |
| 15 | plugin | HELD as text, not built | Makefile:102-105 mints dist/posix; `ls dist/posix` -> absent (no make dist yet) |
| 16 | plugin | HELD | Makefile:9 `export PYTHONDONTWRITEBYTECODE = 1`; makefile-bytecode-tests GREEN; polygram/__pycache__ now gone, so the QAPLAN WARN passes |
| 17 | plugin | OPEN (Corwin's) | dist/vibrobeast.plugin still 08:05:22 |
| 18, 19 | plugin | HELD | tavernface-tests 7/7; launch.cmd copyright Bryant first |
| 20 | repos | PARTLY | both local repos exist, clean worktrees; not pushed; QAPLAN-repos CHECK (ls-remote) would still fail |
| 21 | repos | HELD | commit 1 = Bryant's bytes AS index.html / tavern.py (blob 1070bf91 = upstream hash-object; tavern c1 sha256 6ffaa566 = upstream). `git blame` author share: topoforge Bryant 3501 / Corwin 500; tavern Bryant 12385 / Corwin 1284 |
| 22 | repos | NOT HELD (no change since QA1) | see N6 |
| 23 | repos | NOT HELD (no change since QA1) | see N7 |
| V8 (mine; not in the fold) | plugin | NOT HELD, and dropped from FOLD-QA1 | see N5 |

All QAPLAN CHECK lines re-run this pass: plugin 6/6 + WARN green; topoforge 4/4 + WARN green; tavern 4/4 + WARN green
(gp-check in a fresh clone: 14 passed). Repos CHECK not runnable (no push yet).

## Part 2 -- findings (new or still open)

| id | task | severity | what is wrong, in plain words | evidence | falsifier | fix I suggest |
|---|---|---|---|---|---|---|
| N1 | repos (both) | issue | The letter that goes to Bryant was written before every fix, and it now says false things. It still calls VERSION his call (we set it), says patches 01 then 02 reproduce tavern.py (03 is needed now), and does not list the changes we made to HIS code (FT "Changes for Bryant" 1-5, FG list 3a-3e). He would get changed code without being told what changed. | `ls --full-time LENS-2026-10-08-topo-pony/30-HANDOFF-FOR-BRYANT.md` -> 07:34; FT/FG/FP hand-backs 09:20-09:33. `grep -n` there: :17 "patches 01 then 02 ... reproduce tavern.py exactly", :29 "VERSION still says 2.3.1 ... Your call". | A newer hand-off for Bryant exists that I did not find (I listed LENS-2026-10-08-topo-pony/ and BUILD-LOOP-2026-10-08-ship/; none newer than 07:34). | Rewrite 30-HANDOFF from 27-FT "Changes for Bryant", 28-FG list 3a-3e and "PENDING FOR BRYANT", 29-FP's one item. Drop the VERSION item (say what we chose). Do this before any push. |
| N2 | repos (both) | issue | The repo step added a .gitignore with no licence, so both trees fail REUSE again after FT and FG had made them pass. Nothing caught it: no QAPLAN line runs `reuse lint`, and the step that made the repos has no hand-back of its own. | `cd projects/topoforge && $HOME/rv/bin/reuse lint` exit 1, "no copyright and licensing information: .gitignore" (46/47); garden-pony the same. `git ls-files .gitignore` tracked in both. | `reuse lint` passes because REUSE.toml already covers .gitignore and my lint run is wrong (it names the file). | Add .gitignore to each REUSE.toml (or an SPDX comment line in it), amend before push. Add `reuse lint` as a CHECK in QAPLAN-topoforge and -tavern (the QAPLAN sha changes; say so in SWING). |
| N3 | topoforge, tavern | warning | Both fixers left the moderate heading-order fault to Bryant because the fix "changes his CSS". That blocker does not hold. Both had already changed his CSS under D5 (FT: --text-3, `.mini label`; FG: `.tabgroup`, `.vh`). The fix is the tag plus one selector, and the look stays the same. | topoforge index.html:111 `.sec h3{...}`, h3 at :2391-2451; tavern.py:6449 `.sec h3 { ... }`, h3 at :7387-7757. 27-FT "Left": "touches the .sec h3 CSS everywhere". 28-FG PENDING 2. | His CSS styles h3 somewhere outside `.sec` that h2 would then miss (grep shows `.story h3` in topoforge:157, which is ours, 1.6). | Change the `.sec` headings to h2 and the selector to `.sec h2` (one line each). Re-run both browser kits. List it in N1's letter. |
| N4 | topoforge | warning | The shipped ChangeLog has no entry for the 1.6 headline work: the Story tab, tf_ref and the FACTS spec. FT parked it as "builder T1's, not mine". T1 was our own builder, so the entry is ours. A GNU ChangeLog that skips the release's main change fails "full and working" as a record. | `grep -n '^20' ChangeLog` -> entries for FT, T2 and the import only. 27-FT "Left": "ChangeLog has no entry from builder T1". The commit message e35fc7f does describe the Story tab. | Corwin rules that the commit message serves as the record for 1.6. | Write the 1.6 Story entry from 21-T1-HANDBACK (functions and files), dated 2026-10-08, before the push. |
| N5 | plugin | warning | My QA1 row V8 (two red Python test modules, and no CHECK that runs them) did not make it into FOLD-QA1. Both are still red, so the loop still cannot see red the builders saw. | `PYTHONDONTWRITEBYTECODE=1 python3 -m unittest tests.test_bytes_boundary tests.test_ft1mt` -> FAILED (failures=2): `test_the_whole_tree_is_clean` (1 boundary without encoding); `test_every_skill_has_a_row` (`('SOFT-SKILLS','build-loop')` missing). 29-FP "not touched". | Corwin had already declared both out of scope for 1.0.4 somewhere I did not read. | Add them to the fold as row 24. Fix both (small), or write a declared skip in QAPLAN-plugin. |
| N6 | repos (vibrobeast) | warning | Row 22 is still open. 25 pasted transcripts sit at the AS4CE0001 root, untracked and not ignored, and the GitHub push for vibrobeast is next. One `git add -A` publishes them. | `ls *.txt \| wc -l` -> 25; `git status --porcelain -- '*.txt'` -> `?? 21.txt`, `?? c.txt` ...; `git check-ignore c.txt` -> nothing; 91 porcelain entries in total. | The vibrobeast GitHub repo is built from dist/ only, never from AS4CE0001's worktree (then write that in DESIGN-repos). | Add `/*.txt` (or the named files) to .gitignore, or state in DESIGN-repos that the vibrobeast push comes from the dist tree only. Add a pre-push check: `git ls-files` of the push holds no root *.txt. |
| N7 | repos | warning | Row 23 and my V10 are still open. The key exists only in this session's home, and QAPLAN-repos and all four SWING files still name session-only paths. A next session cannot run the repos CHECK or sw1ng as written. The durable key is on disk, but nothing says how to put it back. | `ls -la $HOME/.ssh-il` -> key, kh 08:32; `ls $HOME/mnt/projects/.keys` -> id_ed25519 (+.pub); `grep -c sessions/ SWING-*` -> 4; QAPLAN-repos unchanged. | The session home survives into the next session. | One line in QAPLAN-repos: copy projects/.keys/id_ed25519 to $HOME/.ssh-il/key (chmod 600) and build kh from github's published keys. Write SWING paths relative to $HOME/mnt. |
| N8 | tavern | warning | garden-pony's secrets scan can only run inside our estate. In any clone, Bryant's included, it says NOT CHECKED, because sb1rn lives in our c4 tree and is not published. It is honest (exit 2, never "clean"), but the repo ships a test its receiver cannot run, and README does not say so. | Fresh clone `$HOME/qa2vb/gp`: `sh tests/scan.sh` exit 2, "PIN OK ...", "NOT CHECKED: sb1rn not found (set SB1RN=path)". | README.org or INSTALL already marks scan.sh as a maintainer's check that needs sb1rn (I did not grep README for "sb1rn"). | Say it in README/INSTALL ("maintainer check; needs sb1rn from C4") or list it under tests that need outside tools. |
| N9 | repos (tavern) | warning | Bryant's tavern commit says he wrote it at 16:25 today, which is the time we committed. The topoforge import used his zip's own time (00:03:24), so the two imports used two different methods. His zip entries are dated 2026-10-07 and we received it at 06:07. A dated history should not invent his date. | `git log --format='%an %ad' HEAD~4 -1` -> "Bryant Frankford 2026-10-08 16:25:43"; zip entries (python zipfile) 2026-10-07 00:00:00; `ls --full-time Bryant/tavern/Tavern-Setup-2.3.1.zip` 06:07:23; topoforge zip entry 2026-10-08 00:03:24 = topoforge c1 author date. | Corwin prefers import time as the author date (then use it for both). | Before the first push only: re-make tavern commit 1 with GIT_AUTHOR_DATE from his zip (2026-10-07), then replay 01-03 and the project-files commit. Never after a push. |

Count: 9 findings (2 issues, 7 warnings). Fixed and HELD: 16 of 23 fold rows (rows 7 and 8 by RESULT.txt, not by my own browser run). Regressed: 2 (rows 4 and 10, both N2). Open: rows 17, 20, 22, 23, and my V8.

## JUDGED (kept apart)
- [MINE] N1 ranks first: the code is right, but the letter about the code is wrong, and the letter is what Bryant reads.
- [MINE] N3 and N4 come from g0001's habit: each "left for someone else" named a blocker the fixer had already crossed elsewhere, or a person who was one of us.
- [DOMAIN] N2 is a "green before, red now" fault. The last hand on a tree (here, `git init` plus .gitignore) needs the earlier lints re-run, not trusted.
- [MINE] N9 is small, and it can only be fixed before the push.
- [PLATFORM] Rows 7, 8 and 12 rest on the cloud browser kit's RESULT.txt, matched by sha256. I did not run a browser.

## LENS (six lines, from my side)
1. Mine: the code is right now. The door's papers (the letter, the ChangeLog, the licence lint) trail the code by one hand.
2. Ascribed to Bryant: he opens a repo, reads the letter first, runs the tests; he expects the letter to match the bytes.
3. His on mine: "credited first" held in blame (3501/4001; 12385/13669). It also asks that his date be his (N9).
4. Mine on his: N1 and N3 put three more changed lines of his in front of him, plainly. Telling him matters more than the size of the change.
5. Persona and inverse: the curator reads what goes out the door; the inverse, the fixer, reads its own row. Pass 2 found the faults between rows.
6. From principles: free software is passed on with its record. Fix N1 and N2 before the push, then N4 and N9 (push-time only), then the rest.
