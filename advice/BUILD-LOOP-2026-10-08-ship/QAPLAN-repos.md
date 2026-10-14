status: QAPLAN · 2026-10-08 · task repos · run from $HOME/mnt
CHECK: K=$(mktemp -d) && cp projects/.keys/id_ed25519 $K/key && chmod 600 $K/key && for r in topoforge tavern; do GIT_SSH_COMMAND="ssh -i $K/key -o IdentitiesOnly=yes -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=$K/kh" git ls-remote git@github.com:inputloop/$r.git | grep -q refs/heads/main || exit 1; done
Rungs: TOWER pushed and listable; LADDER README renders; SIGNAGE private stated in hand-back; ROOF no
secrets pushed (sb1rn over each tree before push); PEERING n/a (declined: GitHub is the peer, checked by
ls-remote); REMOTES Bryant flips visibility per his customs; DOME a refused push is said, not retried blindly.
manifest: none owed
# 2026-10-08 pass 3: CHECK rewritten (the check was wrong, not the work): key made from projects/.keys each run (row 23); vibrobeast moved to pending (waits on make dist and Corwin's choice of tree, FOLD-QA2 row 4).
