#!/bin/sh
# readme-count-tests.sh -- runs tests/readme-count-spec.awk on the README polygram/plugin.py mints.
#   | --prove-red     | --gauge FILE...  (the prose-count gauge: counts, never fails)
# The facts (SERVERS, editions.FLOOR, prefs.KNOWN) are dumped by Python; the check is awk, so the two
# readers share no code.  A seventh server is planted: the README must change, and still pass.
# --prove-red: a typed "three servers", a hand-edit line, a dropped switch row, and a README that
# does not follow a seventh server must each go red.
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
set -u
here=$(cd "$(dirname "$0")/.." && pwd)
spec="$here/tests/readme-count-spec.awk"
PY=${PYTHON:-python3}
t=$(mktemp -d); trap 'rm -rf "$t"' EXIT
cd "$here" || exit 2
PYTHONDONTWRITEBYTECODE=1 $PY - "$t" <<'PYEOF' || { echo "FAIL could not mint the README facts"; exit 1; }
import sys
from pathlib import Path
from polygram import plugin as p
t = Path(sys.argv[1])
def facts(path, servers):
    f = p.readme_facts(servers)
    with open(path, "w", encoding="utf-8", newline="\n") as o:
        for n in f["servers"]: o.write(f"server {n}\n")
        for n in f["floor"]: o.write(f"floor {n}\n")
        for k, (d, _) in f["known"].items(): o.write(f"key {k}\t{d}\n")
six = dict(p.SERVERS)
seven = dict(six); seven["seventh"] = ("seventh", "A planted seventh server, for the test only.", False)
facts(t / "facts6", six); facts(t / "facts7", seven)
for shape in ("python", "cmd"):
    (t / f"README6-{shape}.md").write_text(p.readme_text("python3", shape, six), encoding="utf-8", newline="\n")
(t / "README7.md").write_text(p.readme_text("python3", "python", seven), encoding="utf-8", newline="\n")
PYEOF
pass=0; fail=0
ok()  { pass=$((pass+1)); echo "ok   $1"; }
bad() { fail=$((fail+1)); echo "FAIL $1 -- $2"; }
if [ "${1:-}" = --gauge ]; then shift; awk -v mode=gauge -f "$spec" "$t/facts6" "$@"; exit 0; fi
for shape in python cmd; do
  if out=$(awk -f "$spec" "$t/facts6" "$t/README6-$shape.md"); then ok "the minted README ($shape shape) passes: $(echo "$out" | grep -c '^ok') checks"
  else bad "README6-$shape" "$(echo "$out" | grep FAIL)"; fi
done
if cmp -s "$t/README6-python.md" "$t/README7.md"; then bad seventh "a seventh server left the README unchanged"
else ok "a planted seventh server changes the README ($(diff "$t/README6-python.md" "$t/README7.md" | grep -c '^>') line(s) new)"; fi
if out=$(awk -f "$spec" "$t/facts7" "$t/README7.md"); then ok "the seven-server README passes against seven servers (count word, row, no stale count)"
else bad seventh-pass "$(echo "$out" | grep FAIL)"; fi
if [ "${1:-}" = --prove-red ]; then
  red() { # red LABEL FACTS README
    if awk -f "$spec" "$2" "$3" >"$t/out" 2>&1; then bad "prove-red $1" "the spec passed"
    elif ! grep -q '^FAIL' "$t/out"; then bad "prove-red $1" "it failed without a FAIL row: $(head -2 "$t/out")"
    else ok "prove-red $1 goes red ($(grep -c '^FAIL' "$t/out") FAIL rows)"; fi; }
  red "a README that does not follow a seventh server" "$t/facts7" "$t/README6-python.md"
  sed 's/^    sh check-interpreter.sh$/    sh check-interpreter.sh (the three servers)/' "$t/README6-python.md" > "$t/r1"
  red "a typed \"three servers\" in shipped prose" "$t/facts6" "$t/r1"
  printf '\nOr edit the six command lines in .mcp.json by hand.\n' | cat "$t/README6-python.md" - > "$t/r2"
  red "an instruction to edit .mcp.json by hand" "$t/facts6" "$t/r2"
  grep -v '^| `tone.show` |' "$t/README6-python.md" > "$t/r3"
  red "a dropped switch row" "$t/facts6" "$t/r3"
  sed 's/^The floor is eight /The floor is seven /' "$t/README6-python.md" > "$t/r4"
  red "a floor line with the wrong count" "$t/facts6" "$t/r4"
fi
echo "TOTAL pass=$pass fail=$fail"
[ "$fail" -eq 0 ]
