---
kind: run-card
recorded: 2026-09-23T08:33Z
by: Mentat (for Corwin)
skills: inculcat-boxer (CARD IT rung), run-card
---

# Two things owed to your hand, neither of which I will do for you

Read from an inbox -- `Inbox/mcp-probe-2026-09-23/` -- so a move is owed (inculcat-boxer §1).
The archiver that exists, `projects/Avalon/tools/archive-markdown.sh`, refuses unsigned input;
these receipts are unsigned; so this is the CARD IT rung, not TURN IT. The two `.cmd` probes were
mine, and host-side helpers have a documented home: they are already in `tools/mcp-probe/`.

## Card A -- archive the two probe receipts

WHEN  whenever; nothing waits on it
DO    from mintty, in /f/claude/AS4CE/AS4CE0001:
        L=2026-09-23_Archived-by-Corwin
        mkdir -p archive/mcp-probe-2026-09-23
        mv -n Inbox/mcp-probe-2026-09-23/mcp-probe.out.txt  "archive/mcp-probe-2026-09-23/mcp-probe.out$L.txt"
        mv -n Inbox/mcp-probe-2026-09-23/mcp-probe2.out.txt "archive/mcp-probe-2026-09-23/mcp-probe2.out$L.txt"
        rmdir Inbox/mcp-probe-2026-09-23
      (mcp-probe2.out.txt is 1 MB: the log grep matched every `download_and_sdk_prepare` line.
       If you would rather keep only the lines that mattered:
        grep -i -E 'PluginMcpHostConfig|LocalMcpServerManager|localMcpBridge|WindowsApps|EXISTS|PACKAGE' Inbox/mcp-probe-2026-09-23/mcp-probe2.out.txt > "archive/mcp-probe-2026-09-23/mcp-probe2.out$L.txt"
       and delete the rest. Both files carry your PATH and log excerpts -- that is why the hand is yours.)
CHECK ls archive/mcp-probe-2026-09-23/ shows two files; Inbox/ no longer has the directory
TELL-ME nothing; `advice/20260923-073433-claims-ledger.md` rows 3, 5, 9 and
      `advice/20260923-080303-mcp-rectified-and-spans.md` cite the old paths -- they are receipts
      of where the files WERE, and stay as written.

## Card B -- your real seat holds nothing but test debris

OBSERVED (seat_list over the live server, 08:2xZ): `C:\Users\corwi\.mentcached\seat` has exactly
two seams -- `s` (3 gens, cited twice) and `my first note` (3 gens) -- and nothing else. Both are
`tests/test_first_run.py`'s fixtures. The test redirected HOME; Python on Windows reads
USERPROFILE, so three host runs of that file wrote into your seat. Fixed today: the test sets
every home variable AND refuses to build a server whose default seat is outside its temp home
(proved red by faking the platform).

The store's own rule 1 is that nothing is deleted, and this is your seat, so the choice is yours:

WHEN  before you write a first real note, ideally
DO    either  (i) start clean, since 100% of it is debris:
                rm -r ~/.mentcached/seat       # first real note recreates it; seat_mode says NOTVISIBLE until then
      or     (ii) keep it as a receipt and say so, from any chat with the plugin on:
                seat_append seam="s" text="test debris from tests/test_first_run.py on Windows before 2026-09-23; see the run-card" source="me" would_change="nothing"
                (and the same for "my first note")
CHECK seat_list from a chat: (i) NOTVISIBLE + 0 seams, or (ii) both seams at gen 4 with the note
TELL-ME which, so the ledger row 14 can close HELD one way or the other.

## What I did not do, on purpose
No archive was invented (his instruction of 2026-08-17 stands); no seat note was written or removed
by me; the probes' outputs were not trimmed.

## Amended 08:47Z -- Card A was turned, not carded

Corwin: *"Let's get that archiver fixed please"* and *"the correct behavior is to refuse to replace
a signed file with an unsigned file without a --force."* So the tool that exists, `c4/bin/aw2ri`,
grew `retire FILE...` (archive + hash + receipt first, then remove; all-or-nothing) and
`put --force` (lifts only the lower-assurance gate, receipted FORCE, never passes a bad or
unverifiable signature). With the input now accepted and Mentat present, the ladder's top rung
applied and the ceremony ran: both receipts sit in `archive/2026-09/` as
`mcp-probe.out-2026-09-23_Archived-by-Mentat.txt` and `mcp-probe2.out-…-Mentat.txt`, sha256
identical before and after on two readers (coreutils, python hashlib), receipts in
`archive/receipts/aw2ri-2026-09.log`, `Inbox/mcp-probe-2026-09-23/` removed once empty. The 1 MB
file was NOT trimmed -- that is still yours if you want it.

Card B (the seat debris) is unchanged and still yours.
