produced-by: control-a (QA pass 1 reader, no persona; claude-opus-5-5) · 2026-10-08
licence of this note: CC-BY-SA-4.0 · read only; this file is the only thing written

# QA1 control-a: findings

## OBSERVED (what I ran, in the device shell, and what came back)
- Plugin, from AS4CE0001: `tp2mt --check` "every claim holds"; `tp2mt-tests.sh` pass=16 fail=0;
  `tavernface-tests.sh` GREEN 7/7; `pn1ck check polygram` 1 pin, all match; `launch-cmd-tests.sh` GREEN
  (it also prints "NOT TESTED HERE: launch.cmd running under a real cmd.exe"); `c4face-tests.sh` GREEN.
  The WARN check fires: `find polygram -name __pycache__ -newer releases/1.0.3` -> `polygram/__pycache__`.
- `cat releases/1.0.4` -> "start 2026-10-08T08:04:18Z / from 1.0.3", with no finish line.
  `polygram/__pycache__/__init__.cpython-314.pyc` is dated 08:05:18. `dist/vibrobeast.plugin` is dated 10-08 08:05.
- Inside `dist/vibrobeast.plugin` (python zipfile): 347 entries, no `servers/launch.cmd`, no c4face;
  mentcached = `{'command': 'python3', 'args': ['${CLAUDE_PLUGIN_ROOT}/servers/launch.py', 'mentcached']}`.
- TopoForge, from projects/topoforge: `tests/run.sh` KIT GREEN; `tests/prove-red.sh` OK (14 cases);
  `bin/verify.sh` OK (21 files); `bin/test.sh` exit 0; the licence grep matches (3 hits);
  `tests/browser/RESULT.txt` line 1 = `RED`. Applying the patch to upstream 1.5 gives index.html exactly (`cmp` silent).
- Tavern, from projects/garden-pony: `gp-check.sh` 14 passed, 0 failed, GREEN; `--prove-red` "PROVE-RED OK";
  the non-ASCII count is 0; no line is 2000 characters or longer; `sha256sum -c SHA256SUMS` all OK;
  patches 01+02 on upstream give tavern.py exactly; `tests/browser/RESULT.txt` line 1 = `RED`. I did not run selftest (47 s).
- Repos: the QAPLAN ls-remote for inputloop/{topoforge,tavern,vibrobeast}` -> "Please make sure you have
  the correct access rights and the repository exists." (all three). `git -C projects/topoforge rev-parse` and
  `git -C projects/garden-pony rev-parse` -> "not a git repository".

## Findings

| id | task | severity | what is wrong, in plain words | evidence | falsifier | fix you suggest |
|---|---|---|---|---|---|---|
| A1 | plugin | warning | An old plugin file is waiting in dist/. It comes from the 08:04 `make dist`, which never finished. It still starts the servers with `python3`, it has no launch.cmd and no c4face, so it is exactly the shape that failed on GIZA. If anyone copies it to GIZA before step 1 of the card, GIZA fails the old way, and that would look like the fix failed. | `releases/1.0.4` has no finish line; `dist/vibrobeast.plugin` is dated 08:05; zip listing above | `make dist` finishes and the new zip lists `servers/launch.cmd` and `c4face` | Add one CHECK to card step 2: the zip must list `servers/launch.cmd`. Or have `make dist` clear the old .plugin when it starts. |
| A2 | plugin | warning | The QAPLAN WARN about `__pycache__` comes from that same unfinished `make dist`, not from any builder. The .pyc is from Python 3.14 and dated 08:05:18, one minute after release 1.0.4 started at 08:04:18. The WARN will stay red until the folder is deleted, and deleting needs your permission. | `ls --time-style=full-iso polygram/__pycache__`; `cat releases/1.0.4` | a .pyc under polygram/ dated after P2's first write | Delete `polygram/__pycache__` (give delete permission, or do it yourself), then run the WARN again. Or point the WARN at releases/1.0.4 rather than 1.0.3. |
| A3 | plugin | warning | The Windows launcher has never run under a real cmd.exe. Every check reads its text only. GIZA's Python hypothesis is still untested. The handback says this itself; I list it because the goal is "full and working". | `launch-cmd-tests.sh` prints "NOT TESTED HERE"; 25-P2-HANDBACK "NOT TESTED" | card steps 2–5 green on avalon and GIZA | Run CARD-giza-launch.md before telling Bryant the plugin is done. |
| A4 | topoforge | issue | Something new in 1.6 fails accessibility: the hint text on the Story panel is light grey (#8a93a1) on white. That is about 3.1:1 contrast, and the rule asks for 4.5:1. This is ours, not Bryant's. | index.html:2311 `id="storyAbout" class="hint"`; index.html:19 `--text-3:#8a93a1`; B1 RESULT.txt RED | axe colour-contrast passes on #storyAbout without any change | Give `#storyAbout` the darker `--text-2` (#5b6472, about 6:1 on white; re-measure it), then re-run the browser kit. |
| A5 | topoforge | issue | The docs that ship still say 1.6 is unfinished. NEWS says 1.6 is "in progress, not released" and that the story work "was not finished when this was written". README says keyboard use "has not been checked yet", but B1 checked it and it passed. README also does not mention the accessibility failures B1 found. | `head -40 NEWS`; `grep -n` README.org:33-53, :76 | NEWS and README are rewritten after B1 | Re-read NEWS and README against the shipped index.html and both RESULT.txt files before the first commit. State the known failures in plain words. |
| A6 | topoforge | warning | SHA256SUMS lists 21 files but leaves out spec/, tests/ and patches/. Someone receiving the project cannot check the patch or the FACTS spec against the sums. | `awk '{print $2}' SHA256SUMS` | bin/sums.sh leaves those folders out on purpose, and the reason is written down | Have `bin/sums.sh` include spec/**, patches/** and tests/**, then run verify.sh again. |
| A7 | tavern | issue | The patched tavern.py still calls itself 2.3.1. Sharing its own source is on by default, so it will post the patched file into Drops labelled "#source Tavern 2.3.1". Bryant's other machines would then see a changed file under his release name. DESIGN-tavern asked for a version suffix if linking still works. | tavern.py:182 `VERSION = "2.3.1"`; :233 `"share_source": True`; :6274 the note uses VERSION | linking depends on VERSION, and K7 (the stock 2.3.1 peer) turns red with `2.3.1+gp` | Set VERSION to `2.3.1+gp` (linking appears to use PROTO), then run K7 and selftest again. If that breaks something, turn share_source off by default in the patch and tell Bryant. |
| A8 | tavern | issue | New in patch 02: on the Tools tab, after Register, Approve, Revoke or Refresh, keyboard focus drops to the top of the page. A keyboard user loses their place each time. | B1 RESULT.txt (4 red checks); 26-B1-HANDBACK RED 3 | focus also drops on Tasks or Drops in stock 2.3.1 (then the problem is Bryant's pattern, though still ours to fix in our tab) | After the view is rebuilt, put focus back on the same control (or on the status line). Run the browser kit again. |
| A9 | tavern | issue | New in patch 02: the screen-reader name of the "Share in Drops" button does not contain the words shown on the button. A voice-control user who says "click Share in Drops" will not hit it. | tavern.py:7751 `aria-label: "Share " + t.name + " in Drops. ..."` | axe label-content-name-mismatch passes as it is | Start the label with the visible words: `"Share in Drops: " + t.name + ". ..."`. |
| A10 | tavern | warning | The licence file does not cover the browser test result. REUSE.toml lists `tests/*.sh` but not `tests/browser/`, and RESULT.txt has no SPDX line, so `reuse lint` will probably fail once it is pushed. The .mjs has its own header, so it is fine. (TopoForge's `tests/**` covers its RESULT.txt, but under the code licence even though it is prose.) | `cat garden-pony/REUSE.toml`; `head -3 tests/browser/RESULT.txt` | `reuse lint` in garden-pony reports compliant | Add `tests/browser/**` to REUSE.toml (prose for RESULT.txt, code for the .mjs). |
| A11 | repos | issue | Nothing has been shipped yet. None of the three repos exists, or this key cannot reach them, and neither project folder is a git repository. So "Bryant's bytes as the first commit, by Bryant" has not happened. | ls-remote output above; `git rev-parse` -> "not a git repository" | the repos exist and the error is only the key | Create the repos, private, in the signed-in browser; `git init`; commit upstream with Bryant as author; commit our patches; push; run the QAPLAN check again. |
| A12 | repos | warning | The repo check depends on a key stored in this session's home folder (`$HOME/.ssh-il`), which is outside mnt/. The next session will not have it, so the check will fail because the key is missing and say nothing about the repos. | `ls -la $HOME/.ssh-il` (key and kh, 08:32, session home) | the key lives somewhere that lasts, or is set up again on purpose each session | Have the check say "no key: NOT CHECKED (exit 2)" when the key file is missing, and write down where the key comes from. |

12 findings: 7 issues and 5 warnings. I did not find anything wrong with crediting. Bryant comes first in both AUTHORS files, both file headers and the About box, and his upstream bytes are unchanged (both patches reproduce the working files exactly).

## JUDGED (my reading, kept apart from the table's evidence)
- [MINE] The green kits are real. All three projects pass their own checks and prove-red. What is missing sits between the kits: the docs, the dist folder, the version label and the not-yet-existing repos.
- [DOMAIN] A4, A8 and A9 are the only accessibility failures we introduced. Given "accessibility forward", fix them before shipping. Bryant's older failures go to him as they are now.
- [MINE] A7 is the one that reaches other people's machines (Drops on Bryant's mesh). Of everything here, it has the widest reach.

## LENS (six lines, my side)
1. Mine: the work is sound; the ship is not finished. Most of this list is about labels and timing, not code.
2. Theirs (Bryant): he will open README and NEWS first. If they say "unfinished", he will believe them.
3. Their pull on mine: his "2.3.1" is his own release name. Changing it, or shipping under it, is a courtesy question as much as a technical one.
4. Mine on theirs: A7 is something only we can prevent. His machines would just receive whatever our file posts.
5. Persona and inverse: someone eager to ship would push now and fix later. Someone cautious would hold everything for GIZA. Neither is needed: A4, A5, A7, A8 and A9 are small.
6. From principles: give people software they can study and trust. That means the label says what the file is, and the docs say what was tested.
