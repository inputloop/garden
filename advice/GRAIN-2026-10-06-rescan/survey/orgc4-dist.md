# Survey: org-c4, G:\dist, skzb (2026-10-06)

Paths are as Corwin types them. **O** = observed (command or file named). **J** = judged, tagged, with a falsifier.
Method: device shell for listing and reading. Test runs were done in my own scratch copies (files staged out of the folders; Emacs 29.3 / Org 9.6.15 / Python 3 / mawk, Linux), since the device VM has no Emacs and I have no root. Nothing was written into his folders, except one slip: an early `git status` in F:\claude\projects\org-c4 refreshed `.git/index` (mtime now 2026-10-06 09:12 UTC). That is only git's stat cache; no content changed.

## 1. F:\claude\projects\org-c4  ("org-c4-themes")

**What it is (O):** a fork of fniessen/org-html-themes (BigBlow and ReadTheOrg kept unchanged) plus two things of his: `org-httpd`, an Emacs-native HTTP/SSE server written in built-ins only (7 `.el` files, router, export, `.design` heading index, config), and `src/c4_theme/c4-api.js`, a no-dependency browser script. Click a TODO in the browser, Org's own `org-todo` runs on the live buffer, an SSE patch replaces just that section of the page. Licence: AGPL for his additions. Remotes: `bru` = forgejo@code.bru.st:/corwin/org-c4, `origin` = git@git.sr.ht:~mplscorwin/org-c4-themes. HEAD `54c2559` (2026-08-04), 445 commits (history includes upstream's 2014 start). Newest file: 2026-10-04 (`.t/phase1-ert.log`, `.strings`). The tree has 13,880 files, but 13,167 of them are `e2e/node_modules`.

**Maturity: tested prototype.** Mutation API (O, README route table): toggle-todo, set-property/tags/title/priority, schedule, deadline, edit-body, body-text, refile, set-headline, rename-custom-id. DESIGN.md roadmap: R0-R6, R8 done; R7 (C4 responsive theme) in progress; R9 AI features, R12 theme switching, R11 conflict handling not started or deferred.

| Piece | Maturity | Newest | Tags |
|---|---|---|---|
| `org-httpd/` + `org-c4-start-server.sh` (server) | tested | 2026-07-01 | T3 |
| `src/c4_theme/` (c4-api.js 41 KB, c4-ui-base.js, c4.css) | prototype that runs | 2026-06-26 | T3 |
| `org-httpd/test/` (10 ERT files, 218 tests, golden snapshots, 2 bats files) | tested | 2026-07-01 | T7 |
| `org-c4-api-tests.sh` (curl against a live server) | tested | 2026-06-26 | T7 |
| `e2e/` (wdio specs, browser-free comparator selftests) | tested; browser phase needs Chrome | 2026-08-04 | T7 |
| `demo/make-demo.sh` + `Makefile` (Windows demo bundle, secret deny-gate) | tested (selftest) | 2026-06-26 | T1-adjacent, T7 |
| `hooks/post-commit` (tangle `.strings`, export `.org` to `.md`, amend) | in use | 2026-08-04 | T6, T7 |
| `docs/` (backlog, gadgets ideation + static `gadgets-demo.html`, risk notes, config-modes, sandbox-sync, coworking-loop) | design | 2026-07-01 | T3, T6 |
| `ADR-remote-access.md` (tunnel now; tailnet bind later; 0.0.0.0 never) | design, CANDIDATE | 2026-08-04 | T3 |
| `READY-org-vm-containerization.md` (jail half for OrgVM) | design, CANDIDATE | 2026-08-04 | T3, T7 |
| `agent/submit-prompt.js` (API send, gated `C4_AI=1`) | prototype | 2026-07-01 | T6 |

**Tests I ran (O, scratch copy):**
- ERT: `sh org-c4-run-tests.sh --only ert` printed `Ran 218 tests, 217 results as expected, 1 unexpected`. The one red is `tsnap-section/golden`: actual HTML has one extra blank line (395 vs 394 chars, first mismatch at 191).
- Startup diagnostics: `SUCCESS` (server listens, stops).
- API phase: `[api] summary: 119 passed, 0 failed` against a live Emacs server on loopback. My first run showed 33 failures ("Buffer is read-only"); that was my copy being read-only, fixed with `chmod -R u+w`.
- `e2e/test/lib/stability.selftest.js`: `SELFTEST OK`. `provision-classify.selftest.sh`: 7/7 ok. `make demo-check`: 4/4 OK.
- Not run: wdio browser phase (no Chrome), bats (not installed), `org-c4-check-instructions.sh` (my copy lacked its inputs).
- His own last full run (`dev.log`, 2026-08-03/04, Emacs 31.0.90): 218/218 ERT, "All tests passed". His `.t/phase1-ert.log` from **2026-10-04 19:10** reads 201/218; it ran on Emacs **27.1**, and all 17 failures are `void-function string-search` (13) or `org-collect-keywords` (4). README says Emacs 28.1 minimum.

**Relation to orgvm, org-httpd, the mood-rich app (O):**
- `org-httpd.el:18`: "Unlike orgvm (the Node/Express predecessor this project grew from), org-httpd runs *inside* Emacs." It keeps orgvm's two routes (`GET /:file`, `GET /:file/run/:block`) and ports `useCached`. So org-httpd is the Emacs-side successor to the Node server he showed at EmacsConf 2022. (The string "emacsconf" appears nowhere in the tree; the EmacsConf link is his, not the repo's.)
- The org-vm thread continues here: the READY brief (2026-08-04) says the serving half exists and the **jail half is entirely absent**. Its framing: C4 records consent, the container enforces. Plan leans bubblewrap; the brief is awaiting his bless.
- "Mood-rich": **zero hits for "mood"**. Nearest things: the C4 theme (`c4.css`, 2 `@media` blocks, colour tokens, honours colour-scheme and reduced-motion), roadmap R12 "theme switching" (not started), and the gadgets ideation, whose principle 6 reads "Touch/keyboard-first; hover & drag are enhancements" and which defines 14 gadget archetypes. TEST-PLAN lists "responsive layout at mobile/desktop widths" as unchecked. The ADR concedes a phone browser with no ssh client cannot reach the server.
- **J [DOMAIN]:** org-c4 is the best substrate in hand for a mobile Org app (live-edit loop, tested API, accessible theme base). The mood layer, the mobile layout and a phone-reachable transport are all unbuilt. Falsifier: a `mood`/skin file turning up in another tree (e.g. card-game or egad) would make this a second home, not the only one.
- **Reach:** not buried. `pmo/projects.tsv` row 3 calls it "Most mature; intended substrate for this supervisor"; `program-analysis.org` rates it a flagship. But the orgvm tie, the READY brief and the ADR are only discoverable inside the folder.

## 2. G:\dist  (his "g/dist": things C4 hands out)

**What it is (O):** README says "nothing here is a release yet". **Maturity: tested locally, unpublished.** Newest file 2026-09-28 08:13. No `.git` here (O: `ls -la`). Parts:
- `gw-elpa.el` + `DESIGN` + `QAPLAN` + `gw-elpa-test.sh` + `SWING`: a 7.7 KB builder for a **Ghostwheel ELPA**. DESIGN states contract E1-E10; QAPLAN Q1-Q5; SWING records QA pass 1 of 3 clean, state DONE.
- `elpa/`: the built archive, 8 packages (c4-stile-mcp 0.1.0, gw-elpa 0.1.0, erc-batch, erc-bouncer-scrollback, erc-find-history-mode, erc-hide-line, use-init at 0.1, erc-hide-group at 0.1.1 and 0.1).
- `config/`: his Emacs init as he runs it, GPL-3, with `PROVENANCE.tsv` (every edit made) and `HELD.tsv` (10 files held back).
- `mirror/`: tools for a "second reader over the mirrors" of GNU/Savannah, plus an experiment write-up and a list-reading note.
- `learn/mirrors/`: Learning Center run-cards (LC-01 rehearsed, LC-02..05 planned) and a 114 KB receipt log of a 160x loop (not opened).

**Tests I ran (O, scratch copy):**
- `sh gw-elpa-test.sh`: `24 passed, 0 failed`. `--prove-red`: control green, wrong-version RED at G20, no-readme RED at G18, swap-file RED at G19, "every tamper RED where named".
- `gw-elpa.el` byte-compiles with `byte-compile-error-on-warn`: clean (Q4).
- I installed all 8 packages from the shipped `elpa/` into a fresh Emacs: 8 of 8 `INSTALLED`. `elpa/gw-elpa-0.1.0.el` is byte-identical to `gw-elpa.el`.
- `python3 omni-check-test.py`: `22 passed, 0 failed`.
- `python3 mirror-heads-test.py`: **`21 passed, 4 failed`** under my TZ (America/Chicago); `TZ=UTC` gives **`25 passed, 0 failed`**. Cause: `mirror-heads.sh` lines 33-35 write ledger stamps in UTC (`date -u`) but read them back with awk `mktime`, which assumes local time. Reproduced by hand: a second run in the same minute printed "not asked (answered less than 0s ago)" with `MH_MIN_AGE=0`.
- Not run: `config/emacs/init-tests.el` (README claims 5/5 on Emacs 30.2), anything that touches real hosts.

**Gaps against its own README (O):** the table names `door/`, `carry/`, `bastion/`; none is in the folder (bastion is "not built" by its own word). `learn/`, `omni-check` and `mirmon-read` are not in README (dated 07:49; files run to 08:13). It says the heads test has "11 cases"; it prints 25.

**Threads:** T7 (ELPA, "slow walk" ordering: here, gw hosts, NonGNU, GNU last; no archive signatures yet, stated in DESIGN §4), T3 (participating gw hosts, name GHOSTWHEEL.org), T4 (the mirror work and run-cards are FOSS-involvement material; "mirroring mirrors" is his stated vision), T1 (`door images' recipes` is named but absent). **Reach:** README is the front door and records its origin in `c4/h/stile/dist-draft/`. I did not confirm links from the c4 tree (my grep timed out).

## 3. F:\claude\projects\skzb  (list only)

Newer than 2026-09-17: **`pm/dragaera-rights-audit.md`, 2026-10-06 07:24**, today, with a section "Update 2026-10-06 (Corwin's correction, plus the fancy skzb books thread)" that supersedes the earlier publisher-rights reading and flags deltas. `pm/last-response.md` and `pm/.last-prompt.md` are 2026-09-17 03:12, exactly at the line. Everything else is 2026-09-16 or older (31 files in all).

## Old instructions met

| Where | Instruction (short quote) | Judgement |
|---|---|---|
| `next-session-prompt.md` | "if it isn't mounted, **ask Corwin, don't hunt**" | good and in use (matches his ASK-FOR-iT) |
| `next-session-prompt.md` | "Everything is CANDIDATE until Corwin says otherwise." | good and in use |
| `.next-commands.sh`, seed | "ROTATE THE KEY FIRST at console.anthropic.com" | good and lost (see concern 1) |
| `next-session-prompt.md` | "`bash fail-on-claude-sandbox-desync.sh` — first AND last thing, every session" | troublesome: `.mentat` says an uncommitted `.gitignore` edit makes it print DESYNC STOP and block work; it predates his 2026-10-04 finding that git on these mounts works |
| `.agent-instructions` | "Always verify important file contents with the Read tool on the Windows path, not `cat` in bash." | stale: device-shell sizes matched the staged copies in every file I compared |
| seed | "Push is your pen: `git push bru master`" | stale: superseded 2026-10-04 (Claude can push with the dedicated key) |
| `cowork-prompt.md` | "hi claude" | stale test stub (10 bytes) |
| `dist/SWING` | "written down so it does not have to be remembered" | good and in use (sw1ng loop) |
| `dist/learn/mirrors/README.md` | "One small request per address, never retried." | good and in use (carried into `mirror-heads.sh`) |

## Concerns (each with its falsifier)

1. **[HIS] Possible leaked API key, rotation unconfirmed.** O: `git ls-tree` shows `.build.env` as a blob in `c115ef7` and in `8d563ea`; `git branch -r --contains c115ef7` lists both `bru/master` and `origin/master` (the sr.ht remote, last recorded 2026-07-01). The seed says the key sits in six commits "on bru Forgejo", and says nothing about sr.ht. `.build.env` mtime is still 2026-06-26. I did not open the file. J: whether the key was revoked is unknown, and sr.ht repos may be public. Falsifier: his word that it was revoked, or sr.ht showing the repo private. This one has an outside blast radius, so it is his to call.
2. **[PLATFORM] `mirror-heads.sh` cadence depends on the machine's timezone.** West of UTC the guard over-waits by up to the offset (5 h here); east of UTC it never fires, so a run asks more often than the one-an-hour politeness promise. Falsifier: with the awk read forced to UTC, 25/25 in both `TZ=UTC` and `TZ=America/Chicago`. Not patched (read-only).
3. **[PLATFORM] org-c4's golden `tsnap-section/golden` is Org-version-sensitive.** Falsifier: regenerate on Org 9.6.15; diff should be the single blank line.
4. **[PLATFORM] The 2026-10-04 red ERT run was Emacs 27.1, below the declared 28.1 floor**, so it is not evidence of a code regression. Falsifier: same tests green on 29.3 (seen: 217/218).
5. **[DOMAIN] The orgvm-compatible `GET /:file/run/:block` executes babel blocks over HTTP**, and only its router pattern is tested, not the handler (grep of `org-httpd/test` and `org-c4-api-tests.sh` finds no run-block case). The loopback bind is what protects it. Falsifier: a handler test turning up.
6. **[MINE] README counts are stale** (org-c4 README: "161 tests across 6 files", now 218 across 10; dist README: "11 cases"). I did not fix them.
