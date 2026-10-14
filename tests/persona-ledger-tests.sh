#!/bin/sh
# persona-ledger-tests.sh -- the persona ledger (persona_ledger in polygram/mcp/persona.py);
# spec in tests/persona-ledger-SPEC.txt (read that first).  POSIX sh builds the fixture and runs
# the ledger; tests/persona-ledger-spec.awk checks what it printed.
# tier: smoke
# usage: sh tests/persona-ledger-tests.sh [--prove-red]     (from the AS4CE0001 root, or anywhere)
# Exit 0 green, 1 red, 2 kit broken.
#
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
set -u
here=$(cd "$(dirname "$0")/.." && pwd) || exit 2
PY=${PYTHON:-python3}
command -v "$PY" >/dev/null 2>&1 || { echo "KIT BROKEN: no $PY"; exit 2; }
command -v awk >/dev/null 2>&1 || { echo "KIT BROKEN: no awk"; exit 2; }
export PYTHONDONTWRITEBYTECODE=1
unset PERSONA_ROOT PERSONA_JAIL MENTCACHED_PREFS MENTCACHED_SEAT PYTHONPATH 2>/dev/null
T=$(mktemp -d 2>/dev/null) || exit 2
trap '[ -n "${KEEP:-}" ] || rm -rf "$T"' EXIT INT TERM
SPEC=$here/tests/persona-ledger-spec.awk

sha() { if command -v sha256sum >/dev/null 2>&1; then sha256sum "$1" | awk '{print $1}'
        else shasum -a 256 "$1" | awk '{print $1}'; fi; }

# --- the fixture: three served sheets, one person model, a twin that differs -------------
fx=$T/fx; mkdir -p "$fx/r1" "$fx/r2" "$T/home/.mentcached"
{
  printf '# CHARACTER SHEET -- alpha\nactor: system\n\nA fixture sheet.\n'
  i=5; while [ $i -le 20 ]; do printf 'filler line %s\n' $i; i=$((i+1)); done
  printf 'SECRETFACT-QX7: a third party fact the ledger must never print\n\n'
  printf '## Whose inverse I carry\n\n'
  printf -- "- beta : alpha knows the floor line beta keeps\n"
  printf -- "- ghostqx : a name no sheet is\n"
  printf -- "- pmx : PMWORD-QX7 what alpha knows about the person model\n\n"
  printf '## Later\n\nmore body\n\n*Version 1.0: fixture.*\n'
} > "$fx/r1/CHARACTER-alpha.md"
printf '# CHARACTER SHEET -- beta\nactor: place\n\nbody\n\n*Version 2.0: fixture.*\n' > "$fx/r1/CHARACTER-beta.md"
printf '# CHARACTER SHEET -- beta\nactor: place\n\nbody, an older edition\n\n*Version 1.9: fixture.*\n' > "$fx/r2/CHARACTER-beta.md"
printf -- '---\nname: PMX\ndescription: a persona model of a real person, a fixture\nversion: 0.1\n---\n\nbody\n' > "$fx/r1/PM.md"
printf -- '---\nname: VB\nstatus: a persona model, honest that it is a tool, not a person\nversion: 0.2 \302\267 2026-10-10 \302\267 more\n---\n\nbody\n' > "$fx/r2/VB.md"
# L9: the same line twice, and a second claim between the same pair, from one hand
printf 'alpha -> beta : PROPWORD-QX7 proposed by a review\n\nalpha -> beta : PROPWORD-QX7 proposed by a review\n\nalpha -> beta : PROPTWO-QX7 a second claim\n\nAuthored by Mentat (for Corwin; claude-opus-5-5).\n' > "$T/prop.md"
SHA_A=$(sha "$fx/r1/CHARACTER-beta.md"); SHA_B=$(sha "$fx/r2/CHARACTER-beta.md")

# run ROOT -> the ledger on stdout (exit status of the CLI)
run() {
  (cd "$1" && HOME=$T/home PERSONA_SHEETS="$fx/r1:$fx/r2" PYTHONPATH=$1 \
     "$PY" -m polygram.mcp persona --ledger --proposed "$T/prop.md")
}
# check ROOT -> the awk rows; exit 0 green
check() {
  run "$1" > "$T/ledger.md" 2>"$T/err" || { echo "RED  CLI: the ledger did not run: $(head -3 "$T/err")"; return 1; }
  awk -v base="$fx" -v nsheets=3 -v diverged=beta -v sha_a="$SHA_A" -v sha_b="$SHA_B" \
      -v ghost=ghostqx -v secret=SECRETFACT-QX7 -v pmname=pmx -v pmword=PMWORD-QX7 \
      -v propword=PROPWORD-QX7 -f "$SPEC" "$T/ledger.md"
}

if [ "${1:-}" = --prove-red ]; then
  P=$here/polygram/mcp/persona.py
  plant() {  # NAME SED-EXPR ROW -> 0 when that row went red
    d=$T/plant-$1; mkdir -p "$d"; cp -r "$here/polygram" "$d/" 2>/dev/null || exit 2
    find "$d" -name __pycache__ -type d -exec rm -rf {} + 2>/dev/null
    sed "$2" "$P" > "$d/polygram/mcp/persona.py"
    cmp -s "$P" "$d/polygram/mcp/persona.py" && { echo "KIT BROKEN: plant ($1) changed nothing"; exit 2; }
    out=$(check "$d"); case $out in *"RED  $3 "*) echo "RED  $3 under plant ($1), as it must"; return 0;; esac
    echo "KIT BROKEN: plant ($1) did not turn $3 red"; printf '%s\n' "$out"; exit 2
  }
  plant a 's/"same bytes" if t\["sha256"\] == r\["sha256"\] else "DIVERGED"/"same bytes"/' L4
  plant b 's/^                if t not in shelf:$/                if False:/' L3
  plant c 's/^    if row.get("kind") != "model":$/    if True:/' L6
  plant e 's/^        k = e\["_key"\] #guard:dedupe$/        k = id(e)/' L9
  plant d 's/^    md += \["", "## Edges in the sheets", ""\]$/    md += [Path(x["file"]).read_text() for x in sheets.values()] + ["", "## Edges in the sheets", ""]/' L5
  echo "PROVE-RED PASS: all five plants went red"; exit 0
fi

out=$(check "$here"); rc=$?
printf '%s\n' "$out"
# the tool face: listed, and read-only (no file appears in the sheet folders)
before=$(find "$fx" -type f | sort | tr '\n' ' ')
(cd "$here" && HOME=$T/home PERSONA_SHEETS="$fx/r1:$fx/r2" PYTHONPATH=$here "$PY" -c '
from polygram.mcp import persona
s = persona.build()
assert "persona_ledger" in [t.name for t in s.tools], "no persona_ledger tool"
r = s.call("persona_ledger", {"proposed": []})
assert r["sheets"] == 3 and "## Sheets" in r["markdown"], r.get("say")
') >/dev/null 2>"$T/err2" && [ "$before" = "$(find "$fx" -type f | sort | tr '\n' ' ')" ] \
  && echo "PASS T1 persona_ledger is a listed tool and writes nothing" \
  || { echo "RED  T1 persona_ledger tool: $(tail -2 "$T/err2")"; rc=1; }
if [ "$rc" -eq 0 ]; then echo "GREEN persona-ledger: 10/10"; exit 0; fi
echo "RED persona-ledger"; exit 1
