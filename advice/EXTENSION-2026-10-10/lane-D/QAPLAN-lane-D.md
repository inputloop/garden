# QA PLAN — Lane D (written before the build, 2026-10-10)

QA-1, the machine (every pass runs all of it):
1. `dash -n` (or `sh -n`) on bin/st1dt, bin/rd1ck, bin/qg1ck, bin/br1in; `shellcheck` if present (it
   is not, checked with `which shellcheck`: then NOT CHECKED, said so).
2. Each tool's own `--prove-red` passes (it plants its faults and shows them red).
3. tests/st1dt-tests.sh and its `--prove-red`: a hidden `.gate` two levels up is found; `.keys/x`,
   `a.secret`, `Z/note`, `.patternwalk/t.log` never named, only counted; no file written.
4. tests/rd1ck-spec.rb (Ruby) via tests/rd1ck-tests.sh and `--prove-red`: blank road 1 -> road 2
   READ; a fenced road prints FENCED and is never read; recorded outage fixtures; never "absent".
5. tests/qg1ck-spec.tcl (Tcl) via tests/qg1ck-tests.sh and `--prove-red`: 0.18 red, 0.17 passes, an
   unglossed tree word moves the count.
6. tests/br1in-tests.sh and `--prove-red`: fixture zip passes; one flipped byte goes red; output inside
   a drop refused; NEW / UNCHANGED / CHANGED / DROPPED on fixtures. tests/br1in-noedit-spec.rb (Ruby):
   the drop's bytes and mtimes are the same after a run. tests/br1in-real-tests.sh: rediscovers S1's
   facts on the real drops (or says NOT CHECKED when the drops are not mounted).
7. Baseline `python3 -m polygram.mcp --prove-red` before and after (no lane-D file touches it).

QA-2, the models: the words report of br1in is read back cold by the local model (gemma4:12b-8k) with
three fixed questions whose answers the oracle (the TSV) computes: which skills changed in r2, in r3,
and whether any file was written into a drop. Optional; skipped and said so if the bridge does not
answer.

Authored by Mentat (for Corwin; claude-opus-5-5).
Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
SPDX-License-Identifier: CC-BY-SA-4.0
