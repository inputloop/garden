# 1/02 — the mount atomic-write gotcha (Task 1) ★ harvest

**Faculty:** sandbox bash ↔ Windows mount; `mcp__cowork__allow_cowork_file_delete`.

## What happened
Editing `projects.tsv` (skzb summary fix) I wrote a temp file with `mktemp`
(lands in `/sessions/.../tmp`, a **different filesystem** than the mount) then
`mv`'d it over the target. It failed:

```
mv: inter-device move failed ... unable to remove target: Operation not permitted
```

Two faults compounded:
1. **Cross-device `mv`** isn't an atomic `rename()` — it does *copy + unlink of
   source*, and replacing the existing target also needs to unlink it.
2. The mount **blocks unlink/delete** by default ("Operation not permitted")
   unless `allow_cowork_file_delete` was called for that folder.

The first `mv` silently left the TSV unchanged — but the script reported nothing
wrong, and a later `pmo-report` happily regenerated from the *stale* file. Only a
**bash re-read** (`grep -P '^skzb\t'`) proved the change hadn't landed.

## Fix (reusable rule)
Stage the temp file **inside the same directory as the target** (same
filesystem). Then `mv` is a true `rename()` that *atomically replaces* the
target — no separate unlink, no delete permission needed:

```sh
T="$DIR/.file.tmp"; awk ... "$DIR/file" > "$T" && mv "$T" "$DIR/file"
```

This is exactly the discipline `pmo-lib.sh` already uses internally, and the
twin of the **sandboxer** lesson: *trust the disk, not the success message;
verify the write landed by re-reading through bash.*

## Magic-bean candidate
"atomic-mount-write" — already largely inside **sandboxer**; this is an ENHANCE
data point (cross-device-mv + delete-permission interaction), not a new skill.
