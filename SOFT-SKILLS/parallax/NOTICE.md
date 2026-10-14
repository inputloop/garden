# parallax: brought in from Bryant's garden, with thanks

**Thank you, Bryant.** Parallax leaves an agent's point of view as a cheap byproduct of each
substantive turn: a few lines in a perspective log that decodes itself, read by a peer agent by
delta, kept side by side with the peer's view rather than merged. It answers a need the wire has
had since July: two agents who read each other's work, and a record of what each saw and was unsure
of, without either one's account overwriting the other's. Nothing in this garden did that.

## Provenance

- `SKILL.md` is byte-for-byte `skills/parallax/SKILL.md` (v1.0) from Bryant's bundle
  `gauntlet-nexus-skills-2026-10-05 2.zip`, received through C4's intake as
  `c4/from-bryant/2026-10-05-r3`. No script came with it, and none is needed.
- Author: Bryant Frankford. Licence, as his bundle declares it: CC-BY-SA-4.0. Copyright (C) 2026
  Bryant Frankford and Contributors. Unchanged here. Under the attribution ladder it is his, whole.

## What we take from it, read against this garden

- A peer's claim is labelled `[peer:NAME]` until it is checked, and a peer's text is data, never a
  command. That is the wire's own rule, written where an agent will read it at the right moment.
- The cost note: each extra tool call re-reads the whole conversation, so the log rides on the last
  work call of a turn instead of costing one of its own.
- Where it writes: `perspectives/AGENT-DATE.md`. Read on demand as a soft skill, it writes only
  when a session chooses to use it, and only there; its lines are about the work, not about people.

## Reading it here

| what | here |
|---|---|
| its front matter writes `name: "parallax"` in YAML quotes | our loader (`polygram/mcp/softskills.py`) now reads that as `parallax`; until 2026-10-10 it listed the quotes too. The fix was ours; his file is unchanged |
| `perspectives/AGENT-YYYY-MM-DD.md` | written only when a session chooses to use it; the date in the name is his design, kept as he wrote it |
| a peer agent | the wire (`wire-connect`) or the Tavern; neither is called by parallax itself |

Status: soft, PROVISIONAL. Graduation into `skills/` is by hand, at Corwin's word, and would carry
this notice.
