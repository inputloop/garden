status: QAPLAN · 2026-10-08 · task topoforge · run from $HOME/mnt
CHECK: cd projects/topoforge && sh tests/run.sh >/dev/null
CHECK: cd projects/topoforge && sh tests/prove-red.sh >/dev/null
CHECK: cd projects/topoforge && sh bin/verify.sh >/dev/null
CHECK: cd projects/topoforge && grep -q 'GPL-3.0-or-later OR LGPL-3.0-or-later' index.html
WARN: cd projects/topoforge && test -f tests/browser/RESULT.txt && grep -q '^GREEN' tests/browser/RESULT.txt
Rungs: TOWER kit; LADDER browser keyboard + axe scan (cloud, declared: RESULT.txt lands here);
SIGNAGE story panel says it is a text alternative and gaps are unknown; ROOF forged-label fixture;
PEERING draw.io/vsdx quirks listed for Bryant; Visio 2010 live (avalon, Corwin) declared; REMOTES Bryant
first in AUTHORS; DOME the story says "unknown" rather than inventing.
manifest: none owed
CHECK: cd projects/topoforge && $HOME/rv/bin/reuse lint >/dev/null
# 2026-10-08 pass 2: CHECK reuse lint ADDED (the check was missing, not the work: FOLD-QA2 row 1). $HOME/rv is the device venv.
