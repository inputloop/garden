# Commit drafts — Free All Hopefuls drill, 2026-07-08 (host-only; never git the mount)

## AS4CE0001

```
Free All Hopefuls drill: Batch S verified, Batch D decided (#111 executed)

Batch S: all in-mount signatures verified GOOD vs pinned key
(CLAUD_QA_HOLD.md, GRAMMARY.md, labels.tsv, PLOT.md,
skills/{skilltank,project-memory}/SKILL.md). Earlier BAD verdicts were
stale sandbox mount reads, not signature failures.

Batch D, per CONTRAST2 + keeper's box decisions:
- remove stub skills: handoff, posix, shell-tooling, reward-critique-blend
  (folds ride pmo #112-#115)
- move skills/concise -> tests/fixtures/concise (fixture, not rack)
- QA-3 stays gated (family/third-party review still required)
- signing idiom adopted: machine-parsed files take detached/manifest
  signatures, never clearsign

advice/: four dated decision records (stub-litter, qa3, signing-idiom,
lift-no4c). claud-qa-hold/: this draft.
```

## Avalon (F:/claude/projects/Avalon)

```
lift.sh: remove dead blanket NO4C block; ruled semantics take effect

The old "semantics provisional" park (any NO4C mention) ran after the
ruled RAISED/MENTIONED split (SEMAPHORES 1.0, ruled 2026-07-08), so
MENTIONED files printed "NOTE ... lifting" then parked anyway. Remove the
dead block, fix indent, update the header comment. Fail-closed before and
after; behavior change is only that MENTIONED now lifts with a NOTE, as
ruled. Patch record: stage/lift.sh-no4c-dead-block.patch.

Pending alongside: re-sign bin/lift.sh (detached); MANIFEST regen rides
pmo #116.
```

## pmo ledger (if versioned)

```
pmo: #111 DONE (stub-litter disposition executed); add #112-#116 follow-ups
```
