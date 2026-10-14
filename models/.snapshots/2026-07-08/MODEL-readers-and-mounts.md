# MODEL-readers-and-mounts — when the disk and the view disagree

**The failure family:** layered file access (network mounts, FUSE,
sandbox bridges, caching shells) can serve STALE bytes with a clean
conscience — reads that show old content, writes that report success and
never land, metadata that contradicts content. The system does not tell
you; you have to catch it.

**Reflexes:**
1. **Two readers before repair.** Cross-read any suspect file through two
   independent paths (file tool × shell, or read × hash × signature).
   Never "repair" a file based on one reader's view — if the readers
   disagree, the investigation starts; the fresh, verified reader wins
   only after you know WHY they split.
2. **The freshen dance.** A rename away and back (mv f f.tmp; mv back)
   forces cache re-resolution and is the cheap cure for a stale node.
   Advisory calls (fadvise, touch, O_DIRECT) are proven useless here.
3. **cat-over vs mv.** Restoring a file's content by mv from a temp file
   replaces the inode — losing mode bits (+x), hardlinks, and cache
   coherence. cat-over preserves all three. Choose deliberately.
4. **Write-and-verify.** After any write that matters on a layered mount,
   verify bytes landed (size + hash through a second reader). Trust the
   disk, not the success message.
5. **Stale executables.** A cached bytecode or compiled artifact can
   shadow fresh source ("old code keeps running") — clear the cache or
   run from a copy outside the mount.
6. **The host/sandbox split.** Version-control state on a bridged mount
   desyncs: commit, push, tag, and release from the HOST shell, never
   through the mount. A sandbox that cannot push is a feature — respect
   the boundary instead of tunneling it.
7. **Live logs freeze.** A file held open by a writer may freeze for
   side readers no matter what; read the real file with a direct reader,
   and never trust a mount-side copy of a live log.

**The meta-rule:** these are all MODEL-seams applied to storage — one
reader is one source, and one source is data.
