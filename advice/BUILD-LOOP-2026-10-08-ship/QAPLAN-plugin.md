status: QAPLAN · 2026-10-08 · task plugin · run from $HOME/mnt (the device shell)
CHECK: cd AS4CE0001 && sh bin/tp2mt --check >/dev/null
CHECK: cd AS4CE0001 && sh tests/tp2mt-tests.sh | tail -1 | grep -q 'fail=0'
CHECK: cd AS4CE0001 && sh tests/tavernface-tests.sh >/dev/null
CHECK: cd AS4CE0001 && sh bin/pn1ck check polygram >/dev/null
CHECK: cd AS4CE0001 && test -f tests/launch-cmd-tests.sh && sh tests/launch-cmd-tests.sh >/dev/null
CHECK: cd AS4CE0001 && test -f tests/c4face-tests.sh && sh tests/c4face-tests.sh >/dev/null
WARN: cd AS4CE0001 && test -z "$(find polygram -name __pycache__ -newer releases/1.0.3)"
Rungs: TOWER the checks above; LADDER no hand edits (launch.cmd finds python/node; status tools in plain
words); SIGNAGE tavernface/c4face status say what is off and why; ROOF tp2mt claims + pn1ck; PEERING
GIZA host (Windows without msys python on PATH) — run on GIZA by Corwin, declared; REMOTES Bryant's
tavern.py byte-for-byte; DOME refusals explained. `make dist` itself (6.5 min) runs on avalon by Corwin.
manifest: none owed
