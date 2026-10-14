# Draft 2 of the four game books — recovered 2026-09-13, having been reported lost

**Read this before believing anything else about draft 2.**

Earlier the same day I wrote, in three places, that this draft no longer existed: that a session had
edited the shelf in place and the middle version was gone. That was **wrong**, and it was wrong in the
specific way worth naming — I checked the one place I expected it to be (`.eclipse-increments/`), did
not find it, and reported absence as fact. I never looked in `book/`, where Corwin had zipped the whole
shelf at three points in the round.

The correct statement is the one I should have made: *I cannot see draft 2 in the increments tree.* The
receipt, not the conclusion.

## Where it came from

`book/book-20260913-1217.zip` — a full `book/` snapshot Corwin took at 2026-09-13 00:22, whose `games/`
files are dated 00:07–00:14. Extracted here verbatim; `MANIFEST.sha256` covers the twelve content files.

## The three drafts are genuinely three

Byte identity, `BOOK-*.md`, first 16 hex of sha256:

| book | draft 1 | draft 2 | draft 3 |
|---|---|---|---|
| 1 · commons at the table | `4ba4593b8e864dc2` | `b47e925a688fbdd9` | `579a32f52e71fe77` |
| 2 · six sides and a pencil | `d01e066678136c70` | `40955af7fcd8bf5a` | `73b27c242c2fba44` |
| 3 · the flagged book | `cc9b15eaeaf40eb1` | `68c24cd320b75516` | `0304e0b2f643b555` |
| 4 · make it out alive | `2f07087a02ec2811` | `9539ce1dc055e260` | `be596acdd3d29ef8` |

Draft 1 is byte-identical to `book/book-20260912.zip`. Draft 3 is byte-identical to
`book/book-20260913-1147.zip` and to the live shelf.

## What draft 2 is

The second pass: written after Solberg-Maas's editorial read (`EDITORIAL-2026-09-13-second-read.md`,
included here), in the four authors' mutated voices. It is the draft Bridget did **not** grade — her
grades are on draft 1 — and the draft that draft 3 was cut from.

## What survives of the original complaint

The park discipline still needed writing, and `bin/hb1ck --park` still earns its place: it FAULTs on any
shelf file whose current bytes match no parked copy, and it FAULTed on all of draft 3 before draft 3 was
parked. What changed is the severity of the incident, not the rule. **A draft that exists only inside a
keeper's ad-hoc zip is recoverable but not findable**, which is most of the harm and all of the reason
to park deliberately.

Nothing here is signed. Draft 1's twelve signatures cover draft 1's bytes and travel with them.
