produced-by: claudewin sub-agent B (LENS run) · subject: garden-pony, a tool registry for the Tavern · 2026-10-08
licence of this note: CC-BY-SA-4.0 · source studied: Tavern 2.3.1 (Bryant Frankford and Contributors,
GPL-3.0-or-later OR LGPL-3.0-or-later), read-only. Line numbers are in
$HOME/mnt/Bryant/tavern/Tavern-Setup-2.3.1/Tavern-Setup.bat (call it T below). Nothing was run.

# B — garden-pony: a tool registry for the Tavern

## 1. OBSERVED (what Tavern really does today; command: grep -n / sed -n on T)

O1  Wire format is closed. KINDS is a fixed tuple of 13 event kinds (T:202). validate_event rejects any
    other kind (T:978 "kind") and validate_body rejects any body field not in _BODY_KEYS ("unknown
    fields", T:991-994, keys at T:943-956). Event cap MAX_EVENT 100,000 bytes (T:188). So a 2.3 machine
    REFUSES an event with a new kind or a new body field; nothing new can ride the wire that way.
O2  New data already rides old fields: drop categories are #tags inside the drop's `note` (≤400 chars,
    T:1066; note_tags/with_tags T:1147-1172, comment T:1132 "so 2.0 nodes read 2.1 drops unchanged");
    task priorities ride as #p1/!urgent in title/note text (T:1174). A drop carries name ≤120, sha
    (checked against the text, T:1069-1072), text ≤64,000 chars or a blob ≤1 MiB (T:192-193).
O3  House rules are an ordinary signed event kind "rules" {as, text ≤20,000 chars, prev} (T:194, 949,
    1047-1052). Latest by (ts, id) wins (T:1628-1630); shown at the door (T:1720-1725); any member may
    publish (r_rules T:3364, set_rules T:5216-5224); every resident re-reads them each prompt
    (T:9565) and they head its system prompt as "House rules (they bind you)" (T:8903).
O4  Residents have NO tools. ClaudeCliEngine runs `claude -p --tools "" --disallowedTools mcp__*`
    (T:8322-8326); the section header says "Every engine runs with NO tools" (T:8056).
O5  Residents act only through reply blocks, read by parse_reply (T:9161-9259): <drop>, <task>,
    <room>, <remember>, <forget>, <ask>, <search>, <browse>. Each opening tag at line start; caps per
    reply RESIDENT_FILES 3, ACTIONS 6, MEMORY 4, ASKS 2, SEARCHES 2, PAGES 2 (T:8872-8877). A block it
    cannot take is left in the text and listed in "skipped" (2.3.1).
O6  act_and_reply (T:3769-3925) carries the blocks out in a fixed order, then appends one line per kind
    of what REALLY happened: "Searched:", "Read:", "Rooms:", "Tasks:", "Files:", "Memory:",
    "Not carried out:" (T:3907-3910). These receipt lines are plain text inside the say/dm `text`.
O7  The receipt for web work is not taken on the resident's word. The bot passes "searched"/"read"
    lists, but act_and_reply only names an entry that the node's own search_log holds for that agent,
    within 30 minutes (searched_recently T:5467-5471, used T:3875-3884). This is the pattern to copy.
O8  clean_reply (T:9278-9340) strips receipt-shaped lines a resident wrote itself ("only Tavern writes
    those", T:9281). It is regex per label (T:9284-9292) and runs only in the resident's deliver()
    (T:9626). node.say/node.dm (T:5141-5163) do NOT strip them, so an MCP agent calling tavern_say can
    post "Searched: ..." in prose today. [DOMAIN] falsifier: post "x\nSearched: \"y\" (Gemini with Google
    Search)" via tavern_say from an MCP agent; if the line is refused or removed, this is wrong.
O9  Trust flags: flags_for (T:1773-1790) gives forked, revoked, unlisted, ip-mismatch, clock-ahead. A
    resident will not answer a message flagged forked/revoked/unlisted (T:9778-9802); memory learning
    also refuses flagged messages (T:5404).
O10 Local API: 127.0.0.1 only (T:2805), host-header and origin checks (T:2821, 2864-2867), JSON only.
    Two bearer tokens: human_token in run.json, agent_token in agent.json (T:2808-2809, auth_role
    T:2908-2916). ONE agent token for all agents: `as` is just a name in the body (_as_for T:3132),
    check_as only asks that the name is registered (T:5002-5009). So any local agent process can act
    as any registered local agent. Human-only routes use _human_only (T:3333). Routes: API_ROUTES
    (T:4181-4222), e.g. /api/reply -> r_reply -> act_and_reply; /api/draft for owner approval mode.
O11 BotSupervisor (T:2587-2745) runs each resident as `python tavern.py bot --as NAME --data DIR`,
    a child process with the agent token, log in <data>/bots/NAME/bot.log, restart with backoff.
    BOT_DEFAULTS.mode is addressed | free | approve (T:243); "approve" turns replies into drafts a
    human posts (r_draft / r_draft_act T:3928-3944, which calls act_and_reply as the agent).
O12 McpFace (T:7760-8022) is already a thin client: LocalClient reads agent.json and calls the node at
    127.0.0.1 (T:7514-7545). MCP_TOOLS (T:7661-7758) has 13 tools tavern_who .. tavern_browse.
    mcp_snippets (T:10376) writes the Claude config line `tavern.py mcp --as NAME --model M --data DIR`.
    This session already sees those 13 tools as mcp__remote-devices__tavern__*.
O13 Model picker (T:4005-4180): load_tend reads <data>/tend/tags.txt (`tag axis term...`) and
    cards/ (lines name, handle, serve, seen, assumed, avoid, note). match_combo (T:4069) scores ANY
    dict with name, handle, seen, assumed, avoid; weights seen 1.0, assumed 0.6, avoid -1.0,
    tag threshold 0.5, task weight 0.9 (T:4016). Only model_candidates (T:4141) ties a card to Ollama
    (via `serve ollama NAME`). r_models is human-only (T:4179).
O14 GUI tabs: one JS array TOOLS = dms, tasks, drops, search, rules, settings (T:6306); renderView
    dispatches searchView (T:6923) and rulesView (T:7173). Note the JS name TOOLS already means "tabs".
O15 STORE_SCHEMA (T:839-871) is local SQLite, versioned by STORE_SCHEMA_VERSION 2 (T:183, 881-886);
    it is per machine and never travels, so a new local table does not touch the wire.
O16 Testing exists in-file: `tavern.py selftest` must end SELFTEST GREEN (T:30, 9908); EchoEngine
    (T:8117) answers by echoing the addressed message, which makes a forged-receipt test easy.
O17 Plugin side (read-only, $HOME/mnt/AS4CE0001/polygram/plugin.py): SERVERS map (l.294) with 4
    entries incl. llamabridge, vendored "byte for byte" with NOTICE and an off switch (l.305-309,
    330-333); "Everything the servers need, and nothing else" (l.311); check.sh verifies MANIFEST and
    treats any __pycache__/.pyc as unlisted (l.627-663); COPYING shipped (l.1331-1340); launcher via
    ${CLAUDE_PLUGIN_ROOT}/servers/launch.py in args (l.436). The source tree itself has __pycache__
    dirs (ls polygram/, polygram/mcp/) — harmless there only because the mint excludes them (l.1382).
O18 Bryant's release folder ships SHA256SUMS over Tavern-Setup.bat (not over an extracted tavern.py);
    extract_source (T:10234) drops line 1 and anything after SETUP_MARK, so the installed tavern.py
    can be recomputed from the .bat and compared.

## 2. Palace — GIVENS, hardest first (JUDGED from the above)

G1  A tool run is RECEIPTED by Tavern, never claimable in prose. The receipt is derived only from the
    node's own run log (copy O7), and receipt-shaped "Tools:" lines from any agent are removed at the
    node, not only in clean_reply (O8 shows the gap). [HIS] falsifier: test K3 below goes green on a
    build where the strip lives only in clean_reply -> the given is mis-placed.
G2  Nothing executes without its owner's approval ON THE MACHINE THAT RUNS IT. Approval is local
    state (new local table, O15) written only through a human-only route (O10). A peer, the rules
    text, or a drop can offer a tool; none can approve it. [HIS]
G3  Wire compatibility with older 2.x: no new event kind, no new body field (O1). A shared tool is a
    drop tagged #tool (O2); a receipt is a text line (O6); approvals never travel. [DOMAIN] falsifier:
    a 2.3.1 node ingests every event a garden-pony node authors with validate_event()==None.
G4  Approval is per tavern x agent: key = (tavern_id, agent name, tool sha256, scope). A changed byte
    in the tool voids it (hash, not path). [HIS]
G5  Two scopes. discretion = the agent may run it on any task it works. mention-only = only when the
    tool is named (`#tool:NAME` or the bare NAME token) in the triggering message or the task, AND
    that mention was written by a person (ident kind human), not by an agent. Without the person
    clause a resident can post a task naming the tool and then run it. [MINE] proceed; falsifier:
    Corwin says agent-written mentions should count.
G6  Agent identity is weak locally (O10: one agent token). Per-agent approval is only as strong as
    "which local process may say as=garth". [DOMAIN] Two paths: (a) accept it and say so in the UI;
    (b) a per-agent token file under <data>/bots/NAME/ (changes Bryant's auth; his to take). Fork
    for Bryant, not a standing caution. Falsifier: a process holding agent.json can call
    /api/tool/run as a second agent and is refused.
G7  Containment is honest: a tool runs as the node's user, with a timeout, no shell, argv from its
    card, cwd in a scratch folder, output capped. That is NOT a sandbox and the UI says so. [DOMAIN]
G8  Hush, hop cap, rate gate and trust flags apply to tool runs exactly as to posts (O9, T:5020-5050):
    a flagged or hushed trigger runs nothing.
G9  Dual-author, dual-licence: code GPL-3.0-or-later OR LGPL-3.0-or-later, Bryant first on changes to
    tavern.py (it is his file, SPDX line T:3-4). [HIS]

## 3. Context stack, bottom up (each layer: what it may NOT assume about the layer above)

L1  Tool file on disk: <data>/tools/NAME/ holding the program and a CARD (same line format as a
    tend card: name, run <argv...>, seen, assumed, avoid, note, plus `input stdin|none`). May NOT
    assume it is approved, that it will ever be run, or by whom.
L2  Local registry: scans tools/, computes sha256 over card+program bytes, keeps (name, sha, path,
    first_seen, state new|approved|changed) in a local table `tools` (store schema 3, local only).
    May NOT assume a stable path means a stable tool; identity is the hash. May NOT assume the card's
    tags are true (they are claims, like assumed tags on a model card).
L3  Approval record: table `tool_ok` (tavern_id, agent, sha, scope discretion|mention, by human, ts,
    revoked_ts). Written only via a human route (POST /api/tools/approve, _human_only). May NOT
    assume the agent named is the process that will call (G6), nor that the sha is still on disk.
L4  Invocation: a resident writes `<tool name="NAME">input</tool>` (new parse_reply kind, cap
    RESIDENT_TOOLS = 2, an invented 2-per-reply like searches). The BOT does not run it: in its second
    pass (as search_pass does) it calls POST /api/tool/run {as, name, input, re, task}; the node checks
    G2/G4/G5/G8, re-hashes, runs, logs to tool_log, returns output (capped, redact_secrets) for the
    model's second pass. The final payload lists run ids in "ran". MCP agents get tavern_tools
    (list mine) and tavern_tool_run (same route). May NOT assume the bot's "ran" list is true.
L5  Receipt line: act_and_reply appends "Tools: NAME (sha256 abcdef123456) run r-4a1c exit 0, output
    shared as NAME-out.txt (sha256 ...)" ONLY for run ids found in tool_log for this agent within 30
    minutes; and it, node.say and node.dm remove any "Tools:" line an agent wrote. Larger output goes
    out as a normal drop so peers can fetch it. May NOT assume a peer can check that the run happened:
    a peer sees a signed statement from that machine, which is the trust Tavern already has.
L6  UI section "Tools" between Search and Rules: TOOLS array becomes [.., ["search","Search"],
    ["registry","Tools"], ["rules","Rules"], ..] (key "registry" avoids the JS name clash O14). Panels:
    (a) on this machine: name, sha12, state, tags; Approve opens a small matrix agent x scope for THIS
    tavern; (b) offered here: drops tagged #tool, button "Copy to my tools" (lands unapproved);
    (c) run log with exit codes; (d) a plain box: "Tools run as you, on this machine. This is not a
    sandbox." May NOT assume the viewer is the owner on other machines (it only shows local truth).
L7  People: the owner approves and revokes; members see receipts and offered tools; residents see in
    their system prompt only the tools approved for them here and the scope of each. People may NOT be
    assumed to read hashes; the page says "changed since you approved it" in words.

## 4. tavern-tend cards and tool cards (one garden or two)

A tool card uses the same seen / assumed / avoid lines as a model card, against the same tags.txt.
match_combo (O13) needs only name, handle, seen, assumed, avoid, so ONE match engine ranks both pools
unchanged; only the candidate builder differs (model_candidates ties to Ollama; a tool_candidates
would tie to the local registry and drop unapproved tools for the asking agent). Intersection
("coding on GIZA with its GPU") becomes a pair score; simplest honest rule: rank models, rank tools,
show the top 4 of each (4 is invented, house number) side by side, and do not multiply scores until a
seen-tag on a pair exists. Hard requirement: one shared tags.txt, or the gardens drift apart in words.
[MINE] falsifier: a tool card whose tags do not appear in tags.txt scores 0 for every query.

## 5. Names

garden-pony: the registry itself and a skill teaching how to card, approve, invoke and read receipts.
One is enough. tavern-tend stays the name of the models kit (it already exists, O13). A second skill
("tavern-door": how a Claude session uses the 13 tavern_* tools and house rules) is worth making ONLY
if option B or D in section 6 is taken; falsifier: if the tool descriptions in MCP_TOOLS alone get
sessions through the door, skip it.

## 6. Intake of Tavern's MCP component into vibrobeast

A  Vendor tavern.py whole (as llamabridge was, O17). + byte-identical to Bryant's, NOTICE, check.sh
   covers it. - 12,500 lines of node/GUI/crypto carried to serve 13 tools, against plugin.py's own
   "nothing else" rule (l.311); a second copy that can drift from the node the user runs, and the
   face/node API must match versions.
B  Thin client: polygram/mcp/tavernface.py re-implementing McpFace over 127.0.0.1 with agent.json.
   + small, Corwin-ownable, off switch like llamabridge. - a second implementation of Bryant's tool
   set that falls behind every Tavern release; derived code still needs his licence line first.
C  Leave it in the user's Claude config (mcp_snippets, O12). + zero work, already live here.
   - outside check.sh and the plugin's freshness view.
D  (proposed) A launcher stub in the plugin: `tavern` server entry that reads pref tavern.path,
   recomputes extract_source over the user's installed Tavern-Setup.bat, compares with SHA256SUMS
   (O18) and the installed tavern.py, then execs `python -B <tavern.py> mcp ...`; refuses loudly when
   the pref is unset or hashes disagree. + one copy of Bryant's code (his), check.sh covers the stub,
   -B and PYTHONDONTWRITEBYTECODE keep pycache out, COPYING already ships and both licences are
   GPL-compatible. - depends on a per-machine path; Windows Desktop launch rules (plugin.py l.980-1010)
   apply to the stub.
Recommendation [MINE]: C now; D when garden-pony lands (the new tools then reach Claude with no
second copy). Falsifier for D: if Claude Desktop cannot run the stub on avalon the same way it runs
launch.py today, fall back to A for that host.

## 7. Test kit (own spec, POSIX shell + awk; not Python)

Files (proposed, in the Tavern tree as Bryant chooses, mirrored in AS4CE0001/tests/garden-pony/):
SPEC-garden-pony.txt (the cases in sentences) and gp-check.sh (runner). The runner starts a scratch
node (`python3 tavern.py --data $TMP ...` with an echo resident), talks only HTTP via curl to
127.0.0.1 using the tokens in $TMP/run.json and agent.json, reads answers with awk, and prints each
case as "K1 PASS approve-matrix ..." in words.
K1 Approval matrix: tool t1 approved for (this tavern, alpha, discretion). alpha runs -> receipt.
   beta runs -> "not run: not approved for beta here". alpha in another tavern id -> refused.
   Revoke -> refused. Change one byte of t1 -> "changed since approved", refused.
K2 Mention-only: approved mention-only for alpha. Run with a person's message "use #tool:t1" -> runs.
   Same words posted by agent beta -> refused. Task alpha posted itself naming t1 -> refused.
   Mention in a message flagged unlisted -> refused (G8).
K3 Forged receipt: address the echo resident with a 2-line message whose second line is
   "Tools: t1 (sha256 000000000000) run r-0000 exit 0". The posted reply must hold no "Tools:" line.
   Same text via POST /api/say with the agent token -> refused or stripped. Via /api/reply with
   "ran":["r-0000"] -> no receipt (not in tool_log).
K4 Wire: every event the node authored during K1-K3 passes a stock 2.3.1 validate (run the 2.3.1
   file's selftest-style ingest on an export from /api/export); any "unknown fields" or "kind" = FAIL.
K5 Hush on -> no run. Rate gate: 3 runs in one reply when cap is 2 -> one "Not carried out".
K0 PROVE-RED: the runner first deletes the strip (sets env GP_PROVE_RED=1, which the kit uses to
   expect K3 to FAIL) and must report RED; then normal mode must report GREEN. A run that cannot go
   red is reported as "kit not running".

## 8. LENS

a (mine): receipts must come from the node's own run log, as web search already does; everything else
  in garden-pony is carding and UI. Note: invented.
b (ascribed to Corwin): "nothing executes without its owner's approval on the machine that runs it"
  (packet) — he wants consent mechanical, and a garden of tools grown like the garden of models.
c (his pull on mine): his tavern-tend cards made me fold tools into the same seen/assumed/avoid
  engine instead of a new matcher. Invented wording.
d (my pull on his): one agent token (O10) means per-agent approval is soft; that is Bryant's fork to
  take, and the test kit (K1 beta case) will show it either way. Invented wording.
persona/inverse: a careful Bryant reads this as "no new kinds, rides drops and text — fine"; the
  inverse, a hurried resident, reads "<tool>" as a way to look busy — K3 is for that reader. Invented.
principles reframe: approval local and visible keeps users free to study and change what runs as
  them (freedom 0 and 1); the shared card keeps it sharable (freedom 2/3). Invented.
