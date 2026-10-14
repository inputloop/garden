# Session usage sweep — model (2026-09-01)

What this is: a resumable methodology note for `SESSION-USAGE-SWEEP-2026-09-01.json`,
a manual tally of tool-call activity across 86 of your 287 local Cowork sessions.
Read this file cold, in a fresh session, to extend the sweep or repeat it elsewhere
without re-deriving the approach.

## Why it exists

`explain-usage` wants real token/cache telemetry from a session's own `.jsonl`
transcript. That's only available for the session asking the question, and it
doesn't expose cross-session data at all. `mcp__session_info__read_transcript`
gives legitimate cross-session read access to *other* local sessions, but only as
human-readable text with `(called ToolName)` markers — no usage objects. So this
sweep substitutes a proxy metric (tool-call counts by category) for real spend,
and says so everywhere rather than presenting it as billed-token data.

## The two tools that do all the work

- `mcp__session_info__list_sessions(limit=N)` — most-recent-first roster of local
  sessions: `session_id`, title, status, cwd. Both tools are global, not scoped to
  this project, so this entire method transfers to any other Cowork workspace
  unchanged.
- `mcp__session_info__read_transcript(session_id, format='full', limit=M)` — the
  session's transcript as `[user]`/`[assistant]` text with `(called ToolName)`
  markers. `limit` caps messages returned (most recent within the cap) — sessions
  longer than the cap silently show only a recent slice unless you flag it.

## Categorization used in the JSON

- **file_operations** — Read, Write, Edit, `mcp__workspace__bash`, Grep, Glob
- **web_research** — WebSearch, `mcp__workspace__web_fetch`
- **other** — delivery/task/skill/orchestration calls (present_files, TaskCreate/
  TaskUpdate, Skill, ToolSearch, AskUserQuestion, scheduled-tasks, visualize,
  session_info itself, and MCP connector tools such as Gmail drafts, Drive reads,
  wire_status)

This split is a judgment call, not a standard — a re-run could split "other"
differently and that's fine as long as it's stated.

## Known limitations (don't silently outgrow these)

- Not billed-token telemetry — a tool-call count, nothing more.
- Every session was read with a message cap; longer sessions are undercounted by
  default, not just the ones explicitly flagged `truncated`/`severe_undercount`.
- Five of the 86 rows end in an unresolved model-side API error (Opus/Fable
  safety-classifier flags, one server overload) rather than a normal close —
  flagged `ends_in_api_error`. Their counts reflect only what made it into the
  transcript before the error.
- Category assignment for connector/skill tools is judgment-based.

## A correction owed on this round's own arithmetic

The chat reply that shipped alongside the chart earlier in this session reported
a running total of "~2079 tool calls." That number was wrong — it carried forward
an approximate "~1450" figure for the first 28 sessions from an earlier compacted
summary instead of summing the actual per-session values, then added later
batches on top of the wrong base. Recomputing directly from the same per-session
arrays used to build both the chart and this JSON gives the real total:

**file_ops 1292 + web_ops 39 + other_ops 465 = 1796 tool calls across 86 sessions.**

Flagging this here rather than letting a wrong number sit uncorrected in the
transcript — the JSON's `totals` block is the number to trust going forward, not
anything stated in prose earlier in this conversation.

## How to extend this cold, in a new session

1. `mcp__session_info__list_sessions(limit=300)` (or higher — there were 287 at
   last count, that number only grows) to get the current roster.
2. Diff its `session_id` values against `SESSION-USAGE-SWEEP-2026-09-01.json`'s
   `sessions[].session_id` list. Anything not already present is uncovered.
3. For each uncovered session: `read_transcript(session_id, format='full',
   limit=35-150)`, tally `(called ToolName)` by the category table above.
4. Append new rows with `rank` continuing from 87 — don't renumber existing rows,
   even though "most recent" will have shifted underneath them.
5. Re-run the totals (sum `file_ops`/`web_ops`/`other_ops` across all rows,
   including the new ones) rather than adding a delta by hand — that's exactly
   the mistake this file's own correction section is about.
6. Update `coverage.sessions_measured`, `coverage.percent_covered`, and
   `coverage.next_uncovered_rank` to match.

## How to repeat this in a different project entirely

Nothing here is Vibrobeast-specific. Copy the categorization table and the two
tool names into the new workspace, point `list_sessions`/`read_transcript` at
whatever local session pool exists there, and the same method applies — the only
thing that changes is where the output JSON lands.
