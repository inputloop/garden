status: QAPLAN · 2026-10-08 · task tavern · run from $HOME/mnt
CHECK: cd projects/garden-pony && sh tests/gp-check.sh >/dev/null
CHECK: cd projects/garden-pony && sh tests/gp-check.sh --prove-red >/dev/null
CHECK: cd projects/garden-pony && LC_ALL=C grep -c -P '[^\x00-\x7F]' tavern.py | grep -qx 0
CHECK: cd projects/garden-pony && awk 'length>1999{bad=1} END{exit bad}' tavern.py
WARN: cd projects/garden-pony && test -f tests/browser/RESULT.txt && grep -q '^GREEN' tests/browser/RESULT.txt
Rungs: TOWER selftest (47 s, run separately: too slow beside the rest; declared) + kit; LADDER browser
keyboard + axe; SIGNAGE tool cards FACTS/GAPS; ROOF receipts from run log only; PEERING stock 2.3.1 peer
(kit K7); REMOTES Bryant's history first in the repo; DOME refusals as "Not carried out:" lines.
manifest: none owed
CHECK: cd projects/garden-pony && $HOME/rv/bin/reuse lint >/dev/null
# 2026-10-08 pass 2: CHECK reuse lint ADDED (the check was missing, not the work: FOLD-QA2 row 1). $HOME/rv is the device venv.
