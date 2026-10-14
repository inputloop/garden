# recorded outage 2026-10-10: the sync bridge was down and async was up (W model, WU/PAPER)

## local model

Tavern drop: no

| road | kind | where | check | in words |
|---|---|---|---|---|
| 1 | mcp | delegate_async | ollama_status | the bridge, async |
| 2 | mcp | delegate_task | ollama_status | the bridge, sync (down in the recorded outage) |
| 3 | hand | Claude does it, and says so | - | the session does the job |

Fixture for tests/rd1ck-spec.rb. Authored by Mentat (for Corwin; claude-opus-5-5). Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors. SPDX-License-Identifier: CC-BY-SA-4.0
