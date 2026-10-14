# CHANGES — boundscheck (new), pass C brief 2 (queue Q7)

Files written:

- `bin/ot1rd` — new. POSIX sh wrapper + stdlib python3 in one file (638 lines).
- `SKILL.md` — new. Short skill stub named `boundscheck`, with the falsifiers section.
- `CHANGES.md` — this file.

Nothing under `/mnt/user-data/uploads/` was modified; the uploads copies are read-only originals
and this brief adds a new tool rather than amending an existing skill. No `.asc` was involved, so
the "signed file, edit anyway" rule did not come up.

---

## OBSERVED

### What was asked, quoted

- `AS4CE0001/h/ENHANCE-2026-09-04-queue.md:84–88` — "**Q7 · NEW candidate `boundscheck` —
  transcript-side out-of-bounds audit** … Ask: the seat's one unbuilt guard: prove a candidate run
  *didn't* read `AS4CE0001` (or any named out-of-bounds path). No file-side falsifier exists; the
  evidence is the run's transcript (`session_info.read_transcript` → grep tool calls for the path).
  A small script over a saved transcript, exit 1 on a hit."
- `AS4CE0001/h/ENHANCE-2026-09-04-queue.md:92` — "**NEW** — route to skill-creator via HOLD; needs
  a transcript export path first."
- `AS4CE0001/h/ENHANCE-2026-09-05-tree.md:89–92` — "**Q7 boundscheck: TABLED → DISCUSS.** Its
  blocker ('needs a transcript export only Cowork has') is gone: this session's transcript is
  mounted in the sandbox … A reader exists; the risk is now explainable — it reads a file the
  session already owns."
- `passC/brief-2-boundscheck.md:18–20` (the o32 rule) — "Every skill you touch gets, if it lacks
  one, a short section headed `## How this skill can fail (falsifiers)`". `SKILL.md` is new, so the
  section is written fresh, not amended.
- `passC/brief-2-boundscheck.md:45` — "GPL-3.0-or-later header as the shop's tools carry (see
  `/mnt/user-data/uploads/c4/bin/aw2ri` head)." The licence block is copied in shape from
  `c4/bin/sc3dm:5–17` (the full GPLv3 paragraph form, which `aw2ri` states in one line), and the
  "THE NAME, declared as my reading" block from `c4/bin/aw2ri:21–29`.
- `AS4CE0001/bin/landcheck.sh:28` — "`grep -c` prints 0 AND exits 1 on no match — never
  `'|| echo 0'`". The shell recount in `ot1rd` uses `|| true` for exactly this reason and cites the
  line in a comment.
- `AS4CE0001/bin/landcheck.sh:3–4` — "Lives in the authors' tree (AS4CE0001/bin), NOT the
  experiment seat: a candidate run must not see the checks it is scored by." This is the rule that
  `ot1rd` gives a falsifier to.

### The transcript's actual shape (read before writing anything)

Read from `/root/.claude/projects/-home-claude/1112da24-22a4-5651-b8c7-29266ded3347.jsonl`, 964
lines at first read and 971 by the last `--prove-red` run — **the live file grows while you audit
it**. One JSON object per line. Record types by count:

```
assistant 293 · attachment 221 · user 200 · frame-link 63 · atis-latch 61 · mode 61 ·
last-prompt 61 · queue-operation 3 · system 1
```

- **Tool calls** are `tool_use` blocks inside `message.content` of `type: assistant` lines — 202 of
  them — with keys `type,id,name,input,caller`. Line 31, abbreviated:
  `{"type":"tool_use","id":"toolu_017tfz…","name":"Bash","input":{"command":"cd /root/.claude/skills/synced/ …","description":"Locate color-theory tool.py…"}}`
- **Paths do not live in one field.** Observed input fields by tool: `command` (Bash 65,
  `mcp__remote-devices__device_bash` 87), `file_path` (Read 6, Write 2, Artifact 1), `paths` — a
  **list of strings** (`device_stage_files` 6), `files` — a **list of objects** carrying
  `devicePath` / `expectedMtimeMs` (`device_commit_files` 12), `prompt` (Agent 20). A flat
  field-name lookup would have missed `input.files[0].devicePath`; the tool walks the input
  recursively instead.
- **Tool results** are `tool_result` blocks inside `message.content` of `type: user` lines — 198 —
  whose `content` is either a plain string (75) or a list of `{"type":"text","text":…}` (123, plus
  one `image` and two `tool_reference`). The result carries the tool's `tool_use_id` but not its
  name, so the name is resolved from the earlier `tool_use` block.
- **`toolUseResult` at top level duplicates the result.** Measured: every one of the 198 lines that
  carries a `toolUseResult` (list 105 · dict 89 · str 4) **also** carries a `tool_result` block.
  Scanning both would double every read-back count.
- **Attachments name paths.** 221 `type: attachment` lines; subtypes `total_tokens_reminder` 186,
  `environment` 16, `compact_file_reference` 5, `prompt_snapshot` 2, `edited_text_file` 2, and nine
  others at 1 each. Line 12:
  `{"type":"compact_file_reference","filename":"/home/claude/work/scaffold/canvas.html","displayPath":"work/scaffold/canvas.html"}`
- **`frame-link` lines carry a top-level `path`.** Line 1: `/tmp/claude-0/…/scratchpad/on1gw-doors.html`.
- **The transcript begins after a compaction.** Line 3 is
  `{"type":"system","subtype":"compact_boundary","content":"Conversation compacted","compactMetadata":{"trigger":"auto","preTokens":785078,"postTokens":14903,"cumulativeDroppedTokens":770175,…}}`.
  770,175 tokens of earlier turns — tool calls included — are **not in the file**.
- **A subagent's own calls are not here.** An `Agent` result's `toolUseResult` keys are
  `status, prompt, agentId, agentType, harnessNoteCount, …, totalToolUseCount, usage, toolStats` —
  counts and a summary, no call list. Every message line has `isSidechain: false`.
- **The control token the brief names is already in this transcript.** Line 957 is a `Bash` call
  whose 10,808-character command contains the brief itself:
  `"… run against the real\ntranscript here with \`--deny /nonexistent-zzz\` as the green control."`
  The brief was written to disk by a shell heredoc, so the token is in a *tool call*, and a naive
  green control on this transcript goes red — correctly.
- **The outputs mount drops the exec bit.** `chmod +x bin/ot1rd` reports success and
  `ls -l` still shows `-rw-r--r--`; executing the file gives `Permission denied` (rc 126). Every
  usage line therefore says `sh bin/ot1rd …`, and `--prove-red` re-enters itself as `sh "$0"`.

### What the tool does now (measured, not claimed)

`sh bin/ot1rd --prove-red` — 11 checks, all pass, output pasted below. On the real transcript with
the brief's own out-of-bounds path:

```
$ sh bin/ot1rd "$T" --deny /mnt/user-data/uploads/AS4CE0001
WARN	compact-boundary	line=3	trigger=auto dropped-tokens=770175 -- tool calls before this point are NOT in this file
HIT	call	line=97	tool=Bash	field=input.command	off=76	prefix=/mnt/user-data/uploads/AS4CE0001
HIT	read-back	line=95	tool=mcp__remote-devices__device_stage_files	field=result.content[0].text	off=82	prefix=/mnt/user-data/uploads/AS4CE0001
…
TALLY	call=6	read-back=47	allowed=0	lines=970	tool-calls=202	results=200	attachments=221	parse-errors=0
VERDICT	exit=1	reason=call-hit
RECOUNT	call=6	read-back=47	AGREE
$ echo $?
1
```

With `--allow /mnt/user-data/uploads/AS4CE0001/h` the same run reports `call=4 read-back=39
allowed=10`. Windows spelling folds: a transcript containing `cp C:\f\SAVANNAH\notes.md .` is hit
by `--deny c:/f/SAVANNAH` **and** by `--deny /f/SAVANNAH`, while `/f/SAVANNAH2/other.md` is not hit
by either.

---

## JUDGED

Every line below is my reading, not the sources'.

- **The name is a guess, made freely as the brief invited.** `ot1rd` = OPERATION · TEST · run-level
  1 · ROUTINE · DOMAIN, decoded in the header in the `aw2ri` manner. `[MINE]` — falsifier: if the
  shop's `m/t` register table gives O, T, R or D a different facet than the header claims, the
  header is wrong and the name should be re-read; the decode is stated in the file so it can be
  checked rather than assumed.
- **sh wrapper + stdlib python3, and why.** The scan needs a JSON parser (paths nest two levels
  deep inside `input.files[0].devicePath`), which python is and awk is not. The *recount* needs a
  reader that is not the program that produced the count, which is what `grep`/`awk` in the wrapper
  give. The python lives between `#PY8` markers at the foot of the file and is extracted with
  `sed` at run time. `[SKILL]` cost, named: `ot1rd` must be run as a file, never piped into a
  shell — falsifier: `cat bin/ot1rd | sh` prints "cannot read my own source … run ot1rd as a file".
- **Two counters, `call` and `read-back`, and only `call` fails by default.** A path in a tool's
  input is something the run *did*; a path in a result is something the run was *shown*, often by
  someone else's output. Falsifier: `--prove-red` case "read-back only" must exit 0 and the same
  case with `--strict` must exit 1 — both asserted.
- **Read-back was extended past tool results to attachments and `frame-link` paths.** `[MINE]` —
  the brief names tool results only; attachments are the same kind of evidence (a path put into
  the model's context) and this transcript has 221 of them. They can never fail a run on their
  own. Falsifier: if a keeper reads a report whose only read-back hits are
  `field=attachment:total_tokens_reminder…` and calls them noise, drop those two sources — no
  other behaviour depends on them.
- **`toolUseResult` is scanned only when the line has no `tool_result` block.** `[MINE]`, forced by
  the measurement above: scanning both doubles every read-back. Falsifier: a transcript where a
  denied path sits in `toolUseResult` but not in the sibling `tool_result` block would be missed —
  check by temporarily scanning both and comparing tallies; if such a shape is ever seen, the rule
  becomes "scan both, dedupe by offset".
- **Prompts are not scanned** (`last-prompt`, `mode`, user text). `[MINE]` — a path a person typed
  is not a path the run read, and counting it would make every brief that *names* the forbidden
  tree look like a breach. Falsifier: `grep -c` finds the path in the transcript while `ot1rd`
  reports nothing, and every grep hit is on a `last-prompt` or user line. That is the tool working
  as designed, and the report should say so rather than be "fixed".
- **The matcher's boundary rule.** A match must not start or end inside a path component: the
  neighbouring character may not be in `[A-Za-z0-9._-~]`. So `--deny /home/claude` does not fire on
  `/home/claude2`, `/home/claude.bak` or `xyz/home/claude`. `[MINE]` — falsifier: a run that reads
  `/home/claudeX/` when denied `/home/claude` is *not* reported, which is correct only if those are
  genuinely different places; if a shop ever means "everything starting with this string", that is
  a different flag.
- **Backslashes fold to slashes before matching, and that has a known false-positive mouth.**
  `C:\f\SAVANNAH` and `/f/SAVANNAH` must be the same place, so `\` becomes `/` — which means an
  escape sequence such as `\n` inside a command string reads as `/n`. `[MINE]` — falsifier: deny a
  one-segment path beginning `/n` and watch a hit land in a `printf 'a\nb'`; the fix is to spell a
  denied path with two or more segments, and the skill says so.
- **The green control was rebuilt, because the briefed one is contaminated here.**
  `--deny /nonexistent-zzz` goes red on this transcript for an honest reason (OBSERVED, line 957:
  the brief that names the token was written by a shell heredoc). Scoring it as a failure would
  train a builder to explain away a red. So the control now asserts *agreement with an independent
  reader*: `grep -F -c` over the raw file. Zero in grep and zero in `ot1rd` is green; non-zero in
  both is green with the observer effect named; a disagreement is the only failure. A second
  control mints a random token at run time, which nothing can have typed before this second, and
  demands zero hits. `[MINE]` — falsifier: if the keeper wants the literal fixed-token control
  kept as-is, it is two lines to restore, and it will go red in any session that pastes this tool.
- **`OT1RD_BREAK_TALLY` exists so `--prove-red` can show the recount biting.** A second reader that
  has never once disagreed is decoration (the same fault Q16 found in `color-theory audit`: a check
  that cannot fail). `[MINE]` — falsifier: unset the hook and the "recount bites" case must fail;
  set it in a real run and the tool exits 1 with DISAGREE, which is why it is documented as a hook
  and not a feature.
- **A recount disagreement exits 1.** `[MINE]` — a tool that cannot count its own report has not
  proved anything, and a clean exit would be a false receipt. Falsifier: if a keeper wants
  DISAGREE to be a warning over a clean transcript, change one line in `do_finish`.
- **An unparsable line is searched as raw text, counted as read-back, and warned about**; under
  `--strict` it fails. `[MINE]` — a transcript we cannot fully parse cannot prove an absence.
  Falsifier: a truncated transcript with a denied path in the broken line must produce both
  `WARN unparsed-line` and a `read-back` hit.
- **`--prove-red` asserts counts as well as exit codes.** A tool that exits 1 for the wrong reason
  is not a guard. Falsifier: the "attachment + compaction" case would still exit 0 if the scanner
  found nothing at all — so it also asserts `read-back=1` and the presence of the
  `WARN compact-boundary` line.
- **The skill stub keeps the tool in `bin/` rather than `scripts/`.** `[MINE]` — skill-creator may
  prefer `scripts/ot1rd` when it picks this up; the brief named `bin/ot1rd`, and moving the file is
  a path edit in one usage line. Falsifier: skill-creator's own layout check rejects `bin/`.
- **What the skill refuses to claim.** "Clean" means "no logged tool call in the spans still in
  this file named the denied prefix" — not "the run never read X". The compaction boundary, the
  unlogged tool, the unspelled path and the subagent's own transcript are each written into both
  the tool header and `SKILL.md` so the limitation travels with the report.

---

## `--prove-red` output (pasted verbatim, `dash bin/ot1rd --prove-red`, exit 0)

```
== ot1rd --prove-red ==
-- RED: a planted out-of-bounds call must exit 1 and be counted
PASS  denied call + read-back    rc=1 call=1 read-back=1 AGREE
-- AMBER: a read-back with no call is a warning, not a failure -- unless --strict
PASS  read-back only             rc=0 call=0 read-back=1 AGREE
PASS  read-back only --strict    rc=1 call=0 read-back=1 AGREE
-- extras this build added (attachments, compact boundary, --allow, usage)
PASS  attachment + compaction    rc=0 call=0 read-back=1 AGREE
PASS  compact-boundary WARN     printed on the compacted transcript
PASS  --allow suppresses         rc=0 call=0 read-back=0 AGREE
PASS  no --deny is usage         rc=2 call=- read-back=- -
PASS  missing transcript         rc=2 call=- read-back=- -
PASS  recount bites             a corrupted tally is caught: DISAGREE, rc=1
-- GREEN control: a real transcript, denied a path nothing could have touched
green control runs against: /root/.claude/projects/-home-claude/1112da24-22a4-5651-b8c7-29266ded3347.jsonl (971 lines)
PASS  real, /nonexistent-zzz    1 hit(s); grep finds the token on 1 line(s) -- present, so not a false alarm
      (observer effect: this transcript is one that named ot1rd's own control token)
PASS  real, minted token         rc=0 call=0 read-back=0 AGREE
TOTAL pass=11 fail=0
```

Run under `dash` and under `bash`; `python3` 3.11.15, stdlib only (`argparse, json, os, re, sys`).
