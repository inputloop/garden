# 2/01 — session-history faculty (Task 2)

**Faculty:** `mcp__session_info__list_sessions` / `read_transcript` (local).

## What it is
- `list_sessions` returns every local Cowork session (here **74**), most-recent
  first, with `is_child` (true = this session spawned it) and the cwd.
- `read_transcript(session_id, limit, format)` reads a transcript. `format:auto`
  returns a one-line progress summary if the session is still running, else the
  full transcript; `full` forces it. It **blocks** up to `max_wait_seconds` so a
  running session's outcome arrives in one call.

## How I used it
Triage by title (dropped ~13 "Daily linux security digest" scheduled runs as
banter-dead), then fanned the ~60 remaining across sub-agents for mining.

## Nuance / undocumented-ish
- Titles are auto-generated and **occasionally mismatch the id** a sub-agent
  reports (see 2/03) — the id is authoritative, the title is the human re-find
  key.
- This is a genuine *self-introspection* surface: Claude can read its own past
  conversations as data. Pairs naturally with "pattern harvesting" — the whole
  reason this corpus is mineable.
