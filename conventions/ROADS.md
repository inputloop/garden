# ROADS: the ways to reach each stored fact

*Form: a convention table, and the **source** (card 18: Markdown is what a person edits; a tool TSV is
minted from it with `bin/rd1ck --tsv`, never the other way round). Read by `bin/rd1ck` (the roads
checker), which walks each store's roads in order and prints, per road, **READ**, **NOT REACHED**,
**FENCED**, **READER PRESENT, NOT READ** or **PRESENT, NOT READ**. READ means rd1ck read one line
back from the store (the path is printed, the line never is), not merely that something is there. It never prints "absent": a road that did not answer this time is not evidence that the
fact is gone (TMTOWTDI, "there is more than one way to do it"). First edition 2026-10-10, from Model W's
eleven-row table (`c4/spells/extension/runs/2026-10-10/models/MODEL-2026-10-10-W-wire-first.md`,
"Seamless context access") less its fenced road, with Model T's per-class Tavern drop rows
(`MODEL-2026-10-10-T-tavern-first.md`, TMTOWTDI; cards 07, 17, 18).*

How to read a row:

- **road** is the order to try. **kind** says who can walk it:
  - `mount`: a path under the device shell's mount root (`$HOME/mnt` on the linked computer); rd1ck
    walks it and says READ only when it read one line back (a file's first line, or the first line of
    the first plain file in a folder). A target that is there but gives no line back is PRESENT, NOT
    READ.
  - `reader`: a reader program (like `bin/pr1ef`), not the store itself. rd1ck checks that it is
    there and does not run it, so it prints READER PRESENT, NOT READ, and the road never counts as
    serving the store. A `mount` road into a `bin/` folder is read the same way.
  - `mcp`, `connector`, `session`: a tool only the assistant's session can call; rd1ck cannot, so it
    prints NOT REACHED with "request: ask the session to call it".
  - `hand`: needs Corwin's hand (a drag, a paste, a folder connect); NOT REACHED, "request: ask in chat".
  - `drop`: the Tavern drop store by sha256. It needs gp.1 (the garden-pony patch to Tavern 2.3.1),
    which runs nowhere today, so it is NOT REACHED with "request: none open (needs gp.1)".
  - `host`: a code host or git history; NOT REACHED from rd1ck, "request: ask the session".
- **where** is the target. `-` means the target is not written down yet.
- **One road, two stores.** When one folder serves two stores, a single unmount closes both, so it
  is one road, not two; rd1ck says so at the end of its run. (Pass 2 found `AS4CE0001/memory`
  written as a road for both seat memory and account memory; the account memory has no seat copy,
  so that road is now `-`.)
- **Tavern drop** under each store says whether that class of fact may ride the drop (card 17: by
  class, yes or no, never by judgement; a fact holding a third party's fact never rides).
- Fenced paths are never a road: `c4/Z/`, `c4/a/`, `c4/p/`, `.keys/`, `.house/`, `SAVANNAH`,
  `.patternwalk/`. W's road 3 for Bryant drops (`c4/Z/from/Bryant`) is left out for that reason; if
  a fenced path is ever written into a row, rd1ck prints FENCED and does not touch it.

## preferences (server switches)

Tavern drop: yes (a prefs snapshot; `person.<other>.*` rows never ride)

| road | kind | where | check | in words |
|---|---|---|---|---|
| 1 | mcp | pref_list | key count matches the schema | the plugin's preference tool |
| 2 | mount | - | key count matches the schema | the `pref_export` copy in the seat (path not fixed yet) |
| 3 | reader | AS4CE0001/bin/pr1ef | the awk reader agrees with `pref_list` | `bin/pr1ef`, a reader for a mounted copy of the store (the reader, not the store) |
| 4 | hand | paste of pref_list | key count matches the schema | ask him to paste `pref_list` |
| 5 | drop | prefs snapshot by sha256 | sha matches | the Tavern drop (needs gp.1) |

## usage frame and spans

Tavern drop: yes, and it is not only counts. A frame row can hold: counts and dates; labels; the words of a question put to a person (question rows); the person's own preference values, `room.<tavern>.*` values included (pref rows); and the path of a folder a person said no to (a seatkeeper "no" mirrored as a pref row). Only `person.<other>.*` rows are kept out. All of these are in what the drop would carry. The drop runs nowhere until gp.1; before it runs, it should strip KEY, VALUE and NOTE or this line stays as written.

| road | kind | where | check | in words |
|---|---|---|---|---|
| 1 | mcp | span_report | row count plus last timestamp | the plugin's span report |
| 2 | mount | - | row count plus last timestamp | the frame file itself: `~/.mentcached/stats/fr` on the computer the server runs on, or wherever the `MENTCACHED_FRAME` environment variable points (an environment variable, not a preference; there is no `usage.store` setting). It is not under the mount root, so no target is written here |
| 3 | reader | AS4CE0001/bin/sp1rp | row count plus last timestamp | `bin/sp1rp`, the span reader in awk (the reader, not the store) |
| 4 | drop | frame by sha256 | sha matches | the Tavern drop (needs gp.1) |

## seat memory (MAIN MEMORY)

Tavern drop: no (holds family and third-party facts)

| road | kind | where | check | in words |
|---|---|---|---|---|
| 1 | mcp | seat_read / seat_index | `dl2.tsv` sha | the plugin's seat tools |
| 2 | mount | AS4CE0001/memory | `dl2.tsv` sha | the seat's memory folder on the mount |
| 3 | host | git history of AS4CE0001 | the note's commit | git history |

## account and project memory

Tavern drop: no (holds family and third-party facts)

| road | kind | where | check | in words |
|---|---|---|---|---|
| 1 | connector | memory tools (claude.ai) | the note's own date | the account memory |
| 2 | connector | project_read / project_search | the note's own date | the Project's docs |
| 3 | mount | - | the note's own date | a seat copy of the account memory: none exists yet (it is not mirrored to the seat; `AS4CE0001/memory` is the seat's own store, road 2 of seat memory) |

## Project docs

Tavern drop: no (Project docs are shared with the Project only)

| road | kind | where | check | in words |
|---|---|---|---|---|
| 1 | connector | project_read | the title matches | the Project tool |
| 2 | mount | AS4CE0001/advice | the title matches | the advice folder on the mount |
| 3 | host | git log message | the title matches | git log |

## persona sheets

Tavern drop: yes (a sheet that holds a third party's fact is skipped)

| road | kind | where | check | in words |
|---|---|---|---|---|
| 1 | mcp | persona_read | sha against LEDGER | the plugin's persona tool |
| 2 | mount | AS4CE0001/h/persona | sha against LEDGER | the persona folder on the mount |
| 3 | connector | Drive ledger id | sha against LEDGER | the Drive copy of the ledger |
| 4 | drop | sheet by sha256 | sha matches | the Tavern drop (needs gp.1) |

## skills text

Tavern drop: yes

| road | kind | where | check | in words |
|---|---|---|---|---|
| 1 | session | Skill tool | sha against the plugin manifest | the installed skill |
| 2 | mcp | soft_skill_read | sha against the plugin manifest | the soft-skill server |
| 3 | mount | AS4CE0001/dist/vibrobeast/skills | sha against the plugin manifest | the plugin's skills folder on the mount |
| 4 | host | code.bru.st / inputloop repo | sha against the plugin manifest | the code host |

## Bryant drops

Tavern drop: yes (his own drops; the ACK goes back by the road it came)

| road | kind | where | check | in words |
|---|---|---|---|---|
| 1 | mount | c4/from-bryant | SHA256SUMS in the drop | the dated intake folders in c4 |
| 2 | mount | Bryant | SHA256SUMS in the drop | the Bryant folder on the mount (F:\claude\Bryant) |
| 3 | drop | drop by sha256 | sha matches | the Tavern drop (needs gp.1) |

## local model

Tavern drop: no (a model, not a fact)

| road | kind | where | check | in words |
|---|---|---|---|---|
| 1 | mcp | delegate_async | ollama_status | the bridge, async, first poll at 60 s |
| 2 | mcp | delegate_task | ollama_status | the bridge, sync, short jobs only |
| 3 | hand | Claude does it, and says so | - | no local model: the session does the job and says so |

## connected folders

Tavern drop: no (a folder, not a fact)

| road | kind | where | check | in words |
|---|---|---|---|---|
| 1 | mount | . | `ls` of the root | the device shell's mount root |
| 2 | connector | Filesystem MCP | `ls` of the root | the Filesystem tools |
| 3 | hand | one line naming the folder and why, then the dialog | `ls` of the root | ask him to connect it |

## GRAMMARY and docs

Tavern drop: yes

| road | kind | where | check | in words |
|---|---|---|---|---|
| 1 | mount | AS4CE0001/GRAMMARY.md | gm1gk count | the word list on the mount |
| 2 | mount | AS4CE0001/dist/vibrobeast/GRAMMARY.md | gm1gk count | the plugin's `dist/` copy (not shipped in this edition, so NOT REACHED until it is) |
| 3 | host | code host | gm1gk count | the code host |

---
Authored by Mentat (for Corwin; claude-opus-5-5).
Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
SPDX-License-Identifier: CC-BY-SA-4.0
