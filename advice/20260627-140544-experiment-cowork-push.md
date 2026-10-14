---
kind: experiment
topic: git push from the Cowork sandbox
recorded: 2026-06-27
result: BLOCKED (SSH host-key verification failed)
---

# Experiment: can the Cowork sandbox commit/push polygram to code.bru.st?

**Setup.** From the session sandbox, against the AS4CE0001 mount, ran read-only
probes only (no writes to the mount): `git log` (readable), `git remote -v`,
and `git ls-remote upstream` to test reachability of
`ssh://forgejo@code.bru.st/corwin/as4ce`.

**Result.**
- Repo is *readable* from the sandbox (`git log` works).
- Remote is *unreachable*: `ls-remote` -> "Host key verification failed.
  fatal: Could not read from remote repository." No SSH known_hosts entry and
  no key/agent in the sandbox.

**Conclusion (for the forge/farm cycle).** Automated publish from a Cowork
session is not currently possible — it fails at the SSH trust layer, before the
known Windows-mount git-write hazard even matters. Commit **and** push stay a
manual step in Corwin's own shell. If automated publish is ever wanted, it needs
an SSH key + known_hosts inside the runtime, which is a separate decision.
