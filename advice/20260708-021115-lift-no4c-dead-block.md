---
candidate: avalon-lift-no4c
decision: APPLY
recorded: 2026-07-08T02:11:15
drill: free-all-hopefuls
---

# Drill finding + fix: lift.sh NO4C dead block (Avalon)

Found during the Free All Hopefuls drill sweep: bin/lift.sh (Avalon)
carried BOTH the ruled NO4C logic (RAISED parks / MENTIONED notes,
SEMAPHORES 1.0, ruled 2026-07-08) AND the old blanket "semantics
provisional" block after it — so every MENTIONED file printed
"NOTE … lifting" then parked anyway. The 22:06 CDT signature was GOOD on
those bytes: signed, but the ruling was dead code. Fail-closed → no
exposure, over-parking only.

Corwin at the box: "#1 LGTM tyvm" → patch applied (dead block removed,
indent fixed, header comment updated). Patch record:
Avalon/stage/lift.sh-no4c-dead-block.patch. Syntax-checked + semantics
smoke-tested (RAISED→PARK, MENTIONED→NOTE+lift) on true bytes.

**Pending keeper:** re-sign bin/lift.sh (detached, per adopted idiom);
MANIFEST row rides pmo #116.
