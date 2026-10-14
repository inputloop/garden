produced-by: Mentat (for Corwin; claude-opus-5-5), builder G1 - 2026-10-08
licence: CC-BY-SA-4.0 - subject: Tavern 2.3.1 receipt forgery fix + garden-pony tool registry
work folder: $HOME/mnt/projects/garden-pony/ (Bryant's upstream/ untouched; nothing written in $HOME/mnt/Bryant)

# G1 hand-back: Tavern receipts and garden-pony

## What we handled

1. STAGE 1, `patches/01-receipt-forgery.patch` (182 lines, against upstream/tavern-2.3.1.py).
   A line an agent types in the shape of a Tavern receipt ("Searched:", "Read:", "Rooms:", "Tasks:",
   "Files:", "Memory:", "Tools:", "Not carried out:") is now MARKED:
   `(typed by the agent, not a Tavern receipt) Searched: ...`. It applies in node.say and node.dm
   for every agent post (so MCP agents through tavern_say/tavern_dm too), and in act_and_reply
   for residents, where the agent's words are marked first and Tavern's own receipts are appended
   after (passed with an internal `receipts=True`). clean_reply still drops exact copies of real
   receipts, now including "Tools:". People's posts are unchanged. Resident instructions name every
   label and say a typed one is marked. 4 new selftest checks, including garth's case (#931ea781).
2. STAGE 2, `patches/02-garden-pony.patch` (1484 lines, applies on top of 01).
   - Registry in `<data>/tools/NAME/` (program copy + manifest.json: name, argv, sha256, timeout,
     input stdin|none, run-as note, seen/assumed/avoid tags, note, source, state local|proposed).
     JSON files, not a new SQLite table, so the store schema stays 2 and a 2.3.1 binary can still
     open the data folder.
   - Approvals `<data>/tools/grants.json`, local only: tavern id x agent x tool x sha256, use and/or
     delegate, scope discretion | mention, granted-by (person:NAME or agent:NAME), revocable,
     revoked-by. An agent with delegate rights may let ANOTHER agent USE the tool within its own
     delegate scope; never wider, never delegate, never itself. When its delegate rights go, what it
     granted shows "lapsed" (not deleted). Mention-only counts `#tool:NAME` or a `<tool name="NAME">`
     block on the answered message or task, written by a person or by an agent on this machine
     holding delegate rights for that tool; forked/revoked/unlisted messages count for nothing.
   - Runs: `POST /api/tools/run`. No shell, argv list ({program}, {python}), timeout, empty temp
     folder, short environment without Tavern's tokens, output capped at 8000 characters, secrets
     redacted, hush respected, 17 runs/agent/hour (invented, house number). Every run or refusal goes
     to `<data>/tools/runs.jsonl` with a run id.
   - Receipts: the "Tools:" line is written only from the run log (copying searched_recently): the
     reply names run ids (`ran`), act_and_reply looks each up for that agent within 30 minutes.
     A refused run becomes "Not carried out: a <tool> run of t1: <why>", also from the log.
   - Residents: `<tool name="x">input</tool>` (2 per reply) runs in the second pass with the web;
     output reaches the model in `<tools>`; approved tools and their scope are in its instructions.
   - MCP: one new tool `tavern_tools` (list, run, grant, revoke) and `tavern_say ran=[...]` so an
     MCP agent's post carries Tavern's receipt. It fit cleanly (Tavern's own face calls the same
     routes), so I did it.
   - Sharing: "Share in Drops" posts `NAME.tool.json` (bundle garden-pony/1) tagged #tool, sha256 in
     the note. Other machines list it as offered; "Copy to my tools" lands it as proposed,
     unapproved, refused when the program does not hash to its card or its note.
   - Card: FACTS/GAPS by fixed rules; no judgement words (safe, sandboxed, read-only, harmless,
     secure; a selftest check holds it). GAPS always include "not known to Tavern", "nothing holds
     it in beyond...", and "one agent key on this machine...".
   - Owner's view ranks tools against tavern-tend's tags.txt with Tavern's own match_combo.
   - UI: a Tools tab between Search and Rules (tab key "registry"; the JS name TOOLS stays tabs).
     Register form, rank box, one card per tool with FACTS/GAPS, approvals table with Revoke,
     approve fieldset (agent, use, delegate, when), Share, Offered table, Run log. Native buttons
     and inputs (keyboard), every control labelled, results in an aria-live status, states in words.
   - HOWTO_MD sections 8 and 9 updated. Header of tavern.py: Bryant's lines kept first; a second
     SPDX-FileCopyrightText for Corwin "(the changes marked 2.3.1+gp)" and a Mentat credit line.
   - 13 new selftest checks (_selftest_tools, plus one in the mesh: share on A, adopt on C).
3. Independent kit `tests/gp-check.sh` (POSIX sh + awk + curl) with its own `tests/SPEC.md`: K1
   approval matrix + revoke, K2 delegate cannot exceed, K3 mention-only, K4 forged receipts (MCP
   path, reply path, person untouched), K5 echo resident (forged lines; real tool receipt), K6
   sha mismatch (changed byte; bad offered card; agent cannot register), K7 a stock 2.3.1 peer
   joins and syncs. `--prove-red` plants two faults. Exit 0/1/2.
4. Project files (D5): README.org, AUTHORS, NEWS, INSTALL, ChangeLog, COPYING, COPYING.LESSER,
   LICENSES/ (GPL, LGPL from Bryant's Tavern-Setup-2.3.1 LICENSES/; CC-BY-SA from the topoforge
   folder), REUSE.toml, SHA256SUMS. Names table (D4): c4/c/names gained
   `garden-pony-check  gp1ck  ../projects/garden-pony/tests/gp-check.sh  ...` (gp1ck was unused).
   garden-pony already had its skillnames row (someone else's); I did not touch skillnames.

## OBSERVED (commands and results)

- `sha256sum upstream/tavern-2.3.1.py` -> 6ffaa566...e78c (as briefed); tavern.py started identical.
- Baseline before any edit was taken from the brief (147); after stage 1:
  `PYTHONDONTWRITEBYTECODE=1 python3 tavern.py selftest` -> 151 checks, 0 failed, 45.8 s, GREEN.
  Stage-1 file alone (with its final header): 151 checks, 0 failed, 45.9 s, GREEN.
- First stage-1 run was RED (2 fails): my extra resident message used up the echo bot's 4/minute
  rate and an MCP post emptied a rate bucket. Fixed by folding the forged lines into the existing
  first ping and clearing the bucket. Then GREEN.
- Final tavern.py: `selftest` -> 164 checks, 0 failed, 47.8 s, SELFTEST GREEN.
- One stage-2 check failed first: my test expected re-registering the ORIGINAL bytes to void old
  approvals; it does not (same sha256 = same tool, by design). I rewrote the test to say so (same
  bytes keep approvals; new bytes start over).
- Selftest prove-red (both faults planted in a copy): 164 checks, 10 failed, RED.
- `sh tests/gp-check.sh` -> 14 passed, 0 failed, GREEN, exit 0 (K7 with stock 2.3.1 included).
- `sh tests/gp-check.sh --prove-red --no-stock` -> 8 passed, 5 failed, "PROVE-RED OK", exit 0.
- `patch` of 01 then 02 onto upstream reproduces tavern.py byte for byte (cmp). `sha256sum -c
  SHA256SUMS` all OK. Every line ASCII and under 2000 characters (checked on every save).
  `node --check` on the generated GUI_JS: OK. No __pycache__ or .pyc in the project folder.
- validate_event() passes on every event the tools test node wrote; event kinds stay the 13.

## JUDGED

- Marking, not stripping, for the broad rule. [MINE] Stripping a line by label alone would delete
  an agent's real words ("Tasks: we should split this") and silently change what it said; marking
  keeps the words, shows the attempt, is idempotent, and no line then starts with a label, so
  neither a person nor a program can take it for Tavern's. Stripping stays only for exact copies of
  real receipts in residents' replies (echo noise from context, the existing clean_reply idea).
  Falsifier: if marked lines read as clutter in the room over a week of use, switch the broad rule
  to strip.
- Agents cannot pass on delegate rights, only use. [MINE] D2 says delegates "may grant use"; this
  keeps delegate chains one hop deep and the source of delegate always a person. Falsifier: Corwin
  or Bryant wants delegate-of-delegate.
- An agent's mention counts only if that agent is on THIS machine and holds delegate rights here.
  [MINE] Approvals are local, so a remote agent's name means nothing here. Falsifier: a case where a
  remote agent's mention should start a local run.
- A person at this machine may run any registered, unchanged tool through the API without an
  approval row (it is their machine); there is no UI button for that. [MINE] Falsifier: Corwin wants
  people approved too.
- Reduced environment for tool runs (PATH, HOME, TEMP and a few more; no tokens). [DOMAIN] A tool
  that needs another variable (e.g. OLLAMA_HOST) will not see it. Falsifier: a real tool fails for
  want of one.
- The c4/c/names path `../projects/...` assumes c4 and projects are siblings (F:\claude\c4 and
  F:\claude\projects). [PLATFORM] Falsifier: the names checker rejects the row.

## Not done

- I did not open the Tools tab in a browser. Its JavaScript parses and its data routes are tested,
  but layout, focus order and screen-reader output are not checked by hand. Plain next step: open
  Tavern from tavern.py with a scratch --data, Tab through the Tools tab.
- forked/unlisted/revoked flags stopping a mention or run: in the code, not in any test (needs a
  misbehaving second machine).
- Long tool output is cut at 8000 characters; design B's "share it as a drop" is not built.
- The RAN fact-line grammar from the C notes (T1/T4) is not built; receipts are prose lines.
- Plugin intake (P1's tavernface) not touched; tavern_tools reaches Claude through Tavern's own MCP
  face whenever that face runs this tavern.py.

## PENDING FOR BRYANT (his file, his calls)

1. One agent token for all local agents (agent.json). Any local agent program can say as=alpha, so
   "per agent" approval is only as strong as that. Every tool card says so. A per-agent token file
   (e.g. <data>/bots/NAME/token) would change his auth.
2. VERSION is still "2.3.1". share_source puts the running tavern.py into Drops "once per version"
   with "#source Tavern 2.3.1"; a 2.3.1+gp machine would offer a different file under the same
   label. He should pick a version name (or say how forks are labelled) before anyone runs this.
3. Receipt marking happens on the machine that authors the post. A stock 2.3.1 machine's agents can
   still type receipts, and receivers cannot tell. Fixing that on the receiving side needs a wire
   change or signed receipts: his protocol.
4. "Not carried out:" items from a resident's own parse ("skipped") are still taken from the bot's
   payload (as in 2.3.1). Tool refusals now come from the log; the rest is unchanged.
5. "Question for @x:" and "Note for @x:" lines (Tavern-written for <ask>) are not in the marked
   list; an agent can still type them. Small, his choice whether they count as receipts.
6. Containment: a tool runs as the account running Tavern; no sandbox. On Windows .bat/.cmd run
   via `cmd /c`; the UI's command field splits on spaces (paths with spaces need the API's list).
7. The 17 runs/agent/hour limit and the 2 tools per reply are invented numbers.
8. Taking the patches: 01 stands alone (151 checks GREEN); 02 needs 01.
