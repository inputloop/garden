produced-by: persona-penumbra (Penumbra, eclipse-pass's archivist, sheet gen 1 worn; claude-opus-5-5 for Corwin) · 2026-10-08 · QA pass 2, reader 1 of 4
licence of this note: CC-BY-SA-4.0 · read only: nothing was edited but this file

# QA2: Penumbra's second reading (FOLD-QA1 rows checked, then anything new)

My g0001 habit was used first. Before I believed any claim, I put its clock (the file's mtime, or
the time stated inside it) beside the clock of the evidence it describes. Four clock flags came up.
Two were false alarms, which the content cleared. Two were real, and they are N1 and N2 below.

## OBSERVED: commands run (device shell)

- `ls -la --time-style=+%H:%M:%S` on the ship folder and on both project trees.
  - index.html is 16:25:14 and tavern.py is 16:25:48. Both are NEWER than their GREEN browser
    results (09:24:04 and 09:26:29). That is clock flag 1.
  - `sha256sum`: index.html is 681cac2e..., tavern.py is 0eb956f5... These are exactly the shas named
    on each RESULT.txt's "File tested" line, so only the timestamp moved (git wrote the files again
    at repo creation). Flag 1 is a false alarm.
- topoforge NEWS (09:23:04) says the browser kit "passes all 33 of its checks". The GREEN run
  recorded in RESULT.txt finished at 09:23:43, 39 s later. That is clock flag 2. The content
  matches the later result (33 passed, file 681cac2e). The claim holds, but it was written before
  the run it reports (FT mentions an earlier run 1). Not a finding.
- AS4CE0001/.gitignore was last committed 2026-10-04 09:15:58. Its comment says it was added "so a
  single `git add -A` in this folder is safe". The untracked c.txt ... c27.txt and 21.txt are dated
  2026-10-04 22:29 to 22:39, 13 hours later. That is clock flag 3, and it is real: N2.
- 27-FT says "`reuse lint` is clean" (09:2x) and 28-FG says "`reuse lint` -> compliant" (09:27).
  Both projects' .gitignore files are dated 16:25:19 and 16:25:56, added at repo creation. That is
  clock flag 4, and it is real.
  - `$HOME/rv/bin/reuse lint` in each project: "The following files have no copyright and
    licensing information: * .gitignore". topoforge has 46 of 47 files covered, garden-pony 19 of 20 (N1).
- topoforge: `sh bin/verify.sh` gives "OK every file in SHA256SUMS matches (51 files)".
  `sh tests/run.sh` gives KIT GREEN. SHA256SUMS lists every git-tracked file except .gitignore and
  SHA256SUMS itself.
- garden-pony:
  - `sha256sum -c SHA256SUMS` passes 9 of 9.
  - `git ls-files | wc -l` gives 26. The 17 files not in SHA256SUMS include tests/SPEC.md, all
    three RESULT*.txt, README.org, NEWS, AUTHORS and REUSE.toml.
  - `sh tests/scan.sh` gives "sb: clean; read 25 ... allowed 14 / scan: CLEAN".
- `git log` in both projects: commit 1 is Bryant Frankford <nathanielfrankford@gmail.com>, and it
  holds the working file (index.html, 3536 lines, and tavern.py, 12435 lines). The author dates
  differ:
  - topoforge: author 2026-10-08 00:03, committer 16:25:14.
  - garden-pony: author and committer both 2026-10-08 16:25:43, which is the moment we imported it.
- `git remote -v` in both projects gives nothing, so they are not pushed (as the brief says).
- AS4CE0001:
  - launch.cmd:4 shows Bryant first. Lines 93 and 103 set the floor at `>= (3, 10)`.
  - Makefile:9 has `export PYTHONDONTWRITEBYTECODE = 1`.
  - c4face.py:119-121 reads C4_ON / c4.on, so it is off unless asked.
  - `sh bin/tp2mt --check` gives "1.0.4 -- every claim holds". c4face-tests is GREEN.
    launch-cmd-tests is GREEN (no cmd.exe here).
- `ls -la dist/vibrobeast.plugin` gives 08:05:22, older than every FP fix (launch.cmd 09:19,
  c4face.py 09:23, tavernface.py 09:28, Makefile 09:26). `unzip -l` on it lists no launch.cmd and
  no c4face. `ls dist/posix` says no such directory.
- tavernface.py:48-53 CARRIES says "That patched build, 2.3.1+gp". garden-pony tavern.py:184 says
  VERSION = "2.3.1+gp.1".
- `git status --short` in AS4CE0001 gives 52 untracked, 39 modified. There are 23 untracked
  c*.txt/21.txt at the root, and no .gitignore line covers them. `head -c 300 c27.txt` is a
  discord.com/channels/... link. The remote is code.bru.st/corwin/as4ce.

## Part 1: was each QA1 row really fixed?

| row | verdict | evidence |
|---|---|---|
| 1 story hint contrast | HELD | index.html:2312 `id="storyAbout" style="color:var(--text-2)"`; RESULT.txt GREEN for sha 681cac2e = current |
| 2 README/NEWS stale | HELD | NEWS "Version 1.6 (... built and tested ...)", README:49-60 says what is unchecked; content matches RESULT (flag 2 cleared) |
| 3 sums omit tests/spec/patches | HELD (topoforge) | verify.sh 51 files; 28 under tests/ |
| 4 REUSE tests/browser | HELD for those files, but lint is now RED again on .gitignore | see N1 |
| 5 Bryant's 1.5 a11y criticals | HELD | --text-3 #646d7a / #868f9c (index.html:19,30,39); RESULT GREEN 33/33 bound to current sha |
| 6 VERSION suffix | HELD | tavern.py:184 `"2.3.1+gp.1"`; FG ran K7 against a stock peer, GREEN (not re-run by me) |
| 7 focus loss / 8 name mismatch | HELD | RESULT.txt GREEN, "File tested" 0eb956f5 = current tavern.py |
| 9 tavern NEWS claims | HELD | NEWS 09:27:52 is after RESULT 09:26:29 (clock in order) |
| 10 tavern REUSE | HELD for tests/browser, but lint is now RED again on .gitignore | see N1 |
| 11 sb1rn hits | HELD | scan.sh CLEAN, allowed 14 |
| 12 tablist "+", no h1 | HELD | tavern.py:6331 `<h1 class="vh">`, :6921 `"aria-label": "Rooms and views"` |
| 13 Python floor | HELD (source) | launch.cmd:93,103 `(3, 10)` |
| 14 c4face guard | HELD (source) | off by default (c4face.py:119-121); tests GREEN |
| 15 cmd-only mint | HELD as text; the dist/posix twin does not exist yet | `ls dist/posix` says no such directory; waits on make dist |
| 16 __pycache__ from dist | HELD (source) | Makefile:9 |
| 17 old dist is the GIZA-failing shape | NOT HELD (waits on Corwin's make dist) | dist 08:05:22, no launch.cmd or c4face inside; see N3 |
| 18 stock Tavern said | HELD, with one stale word | see N4 |
| 19 launch.cmd credit | HELD | launch.cmd:4 Bryant first |
| 20 repos | PARTLY: local git repos exist; no remote, not pushed | `git remote -v` empty (expected per brief) |
| 21 Bryant's bytes as commit 1 of the working file | HELD | 30f87a4 index.html, 0b3649b tavern.py, author Bryant |
| 22 transcripts at AS4CE0001 root | NOT HELD | see N2 |
| 23 key in session home | NOT CHECKED beyond: `~/.ssh` absent in this session home (no push attempted, so expected) | |

## Part 2: findings (new ones, plus rows still open)

| id | task | severity | what is wrong, in plain words | evidence | falsifier (what would show I am wrong) | fix I suggest |
|---|---|---|---|---|---|---|
| N1 | topoforge, tavern, repos | issue | Both projects told Bryant "reuse lint clean". Making the git repos added a .gitignore with no licence line, so `reuse lint` now fails in both. The claim was true when written, at 09:2x, and stopped being true at 16:25. The person who reads it in the pushed repo meets a red lint on the first try. | `reuse lint` gives "no copyright and licensing information: * .gitignore" (46/47 and 19/20); .gitignore mtime 16:25:19 / 16:25:56 | `reuse lint` passes in a clean clone (it would if .gitignore were in REUSE.toml, which it is not today) | Add `.gitignore` to the CC0 or code row in each REUSE.toml (or give it an SPDX comment line); make `reuse lint` a step in the repo-creation script so the last writer re-runs it. |
| N2 | repos (vibrobeast) | issue | Row 22 is still open, and the safety note that hides it is older than the risk. AS4CE0001/.gitignore says it makes `git add -A` safe. 23 chat-paste files (c.txt...c27.txt, 21.txt) arrived 13 hours after that note and are not ignored. At least one holds a private Discord channel link. A single `git add -A` before the vibrobeast push would publish them to code.bru.st. | .gitignore committed 2026-10-04 09:15:58; c*.txt dated 2026-10-04 22:29-22:39; `git status --short` gives 52 `??`; `head -c 300 c27.txt` | the vibrobeast push is made from a separate tree (dist output or its own repo), not from AS4CE0001 with `add -A` | Before the push, either move the c*.txt files into an ignored folder (e.g. `Claude outputs/` or a new `pastes/` line) or add `/c*.txt` and `/21.txt` to .gitignore. Change the note to "safe as of <date>; re-check `git status` before add -A". |
| N3 | plugin | warning | The only installable plugin on disk is the 08:05 one. It has no launch.cmd and no c4face, which is the shape that died on GIZA. Every FP fix is newer than it. CARD step 1 rebuilds first, but step 3 names the same path. Anyone who starts at step 3, or copies "the plugin" to GIZA from habit, installs the old one and sees the old failure. | `ls -la` dist 08:05:22 vs sources 09:19-09:28; `unzip -l dist/vibrobeast.plugin` has no launch.cmd/c4face; `ls dist/posix` says no such directory | make dist has been run since (dist mtime after 09:28) | CARD step 3/4: add one CHECK, "`unzip -l dist/vibrobeast.plugin` lists servers/launch.cmd and c4face; if not, step 1 did not run". |
| N4 | plugin | warning | tavernface's CARRIES sentence calls the patched build "2.3.1+gp". garden-pony now ships "2.3.1+gp.1". The words were written at 09:28, but they are older than the VERSION change they describe (FG set it in patch 03). A reader matching the plugin's word to the Tavern's display finds no such version. | tavernface.py:51 "2.3.1+gp"; tavern.py:184 "2.3.1+gp.1" | Corwin means "+gp" as the family name of all garden-pony builds (then say "2.3.1+gp.N") | Say "2.3.1+gp.1 (garden-pony)" or "2.3.1+gp.N"; tavernface-tests F1 could read the version from garden-pony's tavern.py when it is present. |
| N5 | tavern | warning | Row 3's fix went to topoforge only. garden-pony's SHA256SUMS covers 9 of its 26 tracked files and leaves out tests/SPEC.md (the spec Bryant would check), the RESULT files that are the evidence, and README/NEWS/AUTHORS. topoforge covers everything but itself and .gitignore. | `awk '{print $2}' SHA256SUMS` (9 files); `git ls-files` = 26 | Corwin rules that a Tavern release is "tavern.py + patches" only, and the rest is repo furniture (then say so in INSTALL) | Run the same sums-every-tracked-file rule as topoforge's bin/sums.sh; at least add tests/SPEC.md and tests/browser/RESULT*.txt. |
| N6 | repos | warning | Bryant's commit 1 in garden-pony is dated 16:25:43 today, the moment we imported it. That is a time stamp on his authorship he did not make. topoforge took another approach (00:03, "as handed over 2026-10-08"). The two repos tell the history of his work two different ways. | `git log --format='%ad'` tail lines in each repo | Corwin's rule is "import time is the commit date; the message carries the real date" (then topoforge is the odd one) | Pick one rule and write it in DESIGN-repos.md. Likely: GIT_AUTHOR_DATE = the date he handed it over (or the release date), with the import time left as committer date, which is what topoforge already does. |

Only 6 new findings, because these are the ones I can point at. Not findings: the moved mtimes on
index.html and tavern.py (the shas match the GREEN runs), and topoforge NEWS written 39 s before
the run it quotes (the content matches).

## JUDGED (my calls, tagged)

- [MINE] Fix N2 before any vibrobeast push. It is the only item that publishes someone's private
  words. N1 comes next, because it is the first thing a careful reader runs.
- [SKILL] N1 and N2 are the g0001 fault exactly: a claim that was true when written, and evidence
  that arrived later. The lint claim and the .gitignore note both need their dates written beside them.
- [DOMAIN] N3 is row 17 seen from the reader's side. It is not new work, only a guard on the card.
- [PLATFORM] N4 depends on whether "+gp" is a family name or a version. That is a naming question.

## LENS (six lines, my side)

1. Mine: the fixes held where they were measured by sha. What drifted is what came after the fixers stopped (the repo step at 16:25).
2. As I read Corwin's view: "full and working software" means the pushed clone works. N1 and N5 are what that clone shows first.
3. His over mine: he asked for a check, not a caution, so every fix above is a command or a line in a file.
4. Mine over his: I ask that every "clean"/"safe" claim carry the time it was true, so the next reader can put it beside the clock.
5. Persona/inverse: the hoarder keeps the c*.txt files and ships the whole shelf. The inverse deletes them unread. The line is to file them where git ignores them, and say where.
6. From principles: Bryant first includes his dates. The record of his work should not say he did it at the moment we copied it (N6).
