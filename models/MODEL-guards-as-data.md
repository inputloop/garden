# MODEL-guards-as-data — ship the tool, let the data hold the line

**Pattern:** tools ship GENERIC — small, readable, no policy baked in.
The protective guards (gates, pins, allowed paths, embargoes, pace
declarations) live in DATA the tool consults: sign-post files, pinned-key
directories, manifests, semaphores. A non-programmer can then adopt the
diligence by editing files, not by forking code — the access mission
applied to the guards themselves.

**The two hard requirements:**
1. **Doubly-confirmable.** Guard-bearing data must clear the two-source
   law before it GATES anything: signed by a pinned key, or confirmed by
   two independent feeders. Unsigned single-source guard-data may inform;
   it may never gate, lift, or park. ("Data, not semaphore.")
2. **Fail-closed, human-lifted.** A missing, unreadable, or unverifiable
   guard file means the restrictive default, not the permissive one. No
   timer ever lifts an embargo or a park — a human edits the sign.

**Absence-guards (the novel half):** most guards catch tampering — a
thing that changed. The rarer, more valuable guard catches ABSENCE — a
thing that should exist and doesn't: keep a signed MANIFEST of expected
files and sweep it (a listed path missing is a reportable event); classify
should-be-signed-but-isn't distinctly from broken; treat "the check that
should have run and didn't" as a finding.

**Change-inquiry stimulator:** when a proposed change would silently drop
or weaken a guard (removing a limit, adding egress, widening a path),
the system's job is to make the human INQUIRE — re-sign the charter,
don't quietly grow. Every limit you remove is capability someone gains
over you.

**Unattended operation:** anything that runs without its keeper needs a
signed charter naming exactly what it may read and write ("a channel this
charter does not name does not exist"), and an absent-mode that logs
quietly instead of asking questions into a void.
