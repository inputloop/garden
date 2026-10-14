# CONVENTION — the memory index, written down for the first time

*Opus 5, 2026-09-13. Every rule below is reverse-engineered from what the stores already do, or is
marked `[MINE]` as an invention needing his word. The audit that produced it:
`h/MODEL-2026-09-13-mentat-audit.md`. Gauged by `bin/ms1dg` (37/37).*

The index has been governed, until today, by one sentence in a vendor skill: *"Update `MEMORY.md` so it
stays under 200 lines and ~25KB. One line per entry, under ~150 chars."* That skill has never seen this
house. What follows is the house's own.

## 1 · The index is a set of pages, not a file

`MEMORY.md` is the page the harness **loads**. Beside it may sit continuation pages named
`memory-index-*.md`. Coverage, desync and staleness are properties of the whole set; only the loaded
page is measured against the platform's read limit. The seat has carried a second page since 2026-09-11
(`memory-index-2026-09-11.md`); every tool that reads "the index" must read the set.

A continuation page that the loaded page never links to is **invisible** — no session will find it.
`ms1dg` G2b FAULTs on that.

## 2 · The budget belongs to the loaded page alone

200 lines and 25KB, the harness's own cap, on `MEMORY.md`. `ms1dg` G2 WARNs at 180 lines / 23KB and
FAULTs past the cap. Continuation pages have no budget — they are read on purpose, not on load.

## 3 · Where a note's index line goes

A note's index line belongs to **the store that holds the note**. Writing a line into store A for a note
that lives only on the seat leaves a reader with a hook it cannot open — sixteen such lines exist today
and are Fork B in the audit. Until he rules, a line naming a note its own store lacks says so:
`— (seat)` at the end of the hook.

## 4 · When a page is born, and what a compaction may do

A compaction is triggered by the loaded page approaching the cap, never by tidiness. It may:
shorten a hook; pack several closed, point-in-time notes onto one line `[MINE]`; move a whole section to
a continuation page; lift long hooks verbatim into the archive note.

It may **never** drop an entry, and it may never shorten a hook without the long form landing verbatim
somewhere a reader can reach. The rule that O2 cost us: **paste the generated lift file; never retype
it.** Nine of fifty-four went missing on 09-12 to hand-composition, caught only by re-deriving the set
and diffing.

Three checks close a compaction, all cheap:
- link sets identical before and after (`grep -o '](…)' | sort -u | diff`);
- every shortened hook present verbatim in the archive (diff the generated lift against the archive);
- `ms1dg` green on G2, G2b, G3, G8.

## 5 · What a hook is for

A hook is a *retrieval cue*, not a summary: enough to know whether to open the note. When a hook is
shortened, the index says so once, at the top, so a reader knows a short hook is not the whole fact.
The loaded page currently carries that line.

## 6 · Packing `[MINE]`

Closed, point-in-time notes may ride several to a line, joined by ` · `. Live rules, standing
instructions and anything a session might act on directly stay one per line. This is my invention of
2026-09-12 and is Fork A — it parses correctly for every tool in the house (all of them extract
`](target.md)` rather than reading lines), but he has not blessed the shape.

## 7 · What never enters the index

Content. The index carries pointers and cues; the fact lives in the note. A narrative inside the index
is what drove the 09-04 compaction, and the archive note exists to hold what gets lifted out.
