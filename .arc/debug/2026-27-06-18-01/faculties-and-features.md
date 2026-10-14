# Cross-cutting — faculties, features, and their interactions

Things observed this session that are easy to forget we have, and how they
interlock. (Token-aware: this is the "what can the harness do" cheat-sheet.)

## Tool loading
- **ToolSearch / deferred tools.** Most tools start *unlisted*; their schemas
  must be fetched (`select:<name>` or keyword) before they're callable. Load in
  bulk (one call, comma-separated). Children must do this too.

## Skills (the farm)
- Skills are **read-only as installed** in a session — you cannot edit the live
  cache. The polygram way around this: author skills as **files** in a workspace
  `skills/`, then `polygram dist --format skill` mints a folder-rooted `.skill`
  zip the user installs via the desktop **"Save skill"** gate. That install is
  the human gate — Claude builds + QC's, Corwin accepts.
- The chain seen end-to-end: **skilltank** (find candidate) → **polygram**
  gate/`review --promote` (skeleton) → hand-author → **2-agent QC AND-gate** →
  `dist` (.skill) → **pmo** (track) → **memory** (record). Each faculty hands to
  the next; none re-implements another.
- `skilltank` raw scan is token-frequency noisy (bare tokens `claude/code/bru`).
  The *gate* (ship a runnable? recurring? one capability?) is where judgment
  lives — exactly the noise polygram's HOLD is designed to catch.

## Memory
- Space memory = a dir of one-fact `.md` files + a `MEMORY.md` index; relate
  with `[[slug]]` wikilinks. Index loads each session; notes recall as
  background context (verify before acting on them — they may be stale).
- Edit/Write require a prior **Read in this conversation** (the harness tracks
  file state); a file shown only in a system-reminder still needs a Read.

## Mount / sandbox (see 1/02)
- Host path vs bash mount path differ; only bash uses `/sessions/.../mnt/...`.
- Deletes blocked until `allow_cowork_file_delete`; cross-device `mv` needs it,
  same-dir `mv` doesn't (atomic rename). Verify writes by re-reading via bash.
- **Never git on the mount** (writes desync) — commits are manual on Corwin's
  machine; the sandbox also can't push to code.bru.st (SSH host-key).

## Available-but-unused this session (worth remembering)
computer-use (desktop control), Claude-in-Chrome (web), visualize (inline
SVG/HTML widgets), scheduled-tasks (recurring runs), create_artifact (live
connector-backed pages), mcp-registry (suggest connectors), present_files. Any
of these could carry a future "pattern-harvest" output (e.g. a live artifact
dashboard over the banter TSV).
