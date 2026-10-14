values-baseline has no source under the lab's skills folder; the only copy reachable this pass was the read-only installed cache at `/root/.claude/skills/synced/8460b5c5-7709-448e-a1b9-45577b5e1670_948346fb-5634-4a0d-bbc2-9a649c945411/values-baseline/SKILL.md`.
So this part ships a patch instead of a full file: nothing was applied, and the installed copy is untouched — this is for the keeper's hand.
Apply it from the directory that contains `values-baseline/`: `patch -p0 < PATCH-2026-09-11-values-baseline-hold-not-harm.diff` (verified clean against the 2026-09-09 installed copy).
It adds a "HOLD is not HARM" subsection inside the fenced-loss section, and a falsifiers-plus-off-switch section just above the provenance footer; nothing existing is deleted or reworded.
Falsifier: `grep -c "HOLD, not HARM" values-baseline/SKILL.md` prints 1 after applying (it prints 0 before).
If the patch does not apply cleanly, the installed skill has moved since 2026-09-11 — re-cut it against the current file rather than forcing it.
