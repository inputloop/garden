#!/bin/sh
# tavernface-tests.sh -- Bryant's Tavern in the vibrobeast plugin, off until asked; spec in
# tests/tavernface-SPEC.txt (read that first).  POSIX sh + awk, testing Python.
# tier: smoke
# usage: sh tests/tavernface-tests.sh [--prove-red]        (from the AS4CE0001 root, or anywhere)
# Exit 0 green, 1 red, 2 kit broken.
# Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
# Written by Mentat (for Corwin; claude-opus-5-5).
set -u
PIN=6ffaa56681406aa55073cb9c5ae296edd6659730ff8d73793c5655a77483e78c
here=$(cd "$(dirname "$0")/.." && pwd) || exit 2
PY=${PYTHON:-python3}
command -v "$PY" >/dev/null 2>&1 || { echo "KIT BROKEN: no $PY"; exit 2; }
export PYTHONDONTWRITEBYTECODE=1
unset TAVERN_ON TAVERN_DATA TAVERN_AS MENTCACHED_PREFS MENTCACHED_SEAT PYTHONPATH 2>/dev/null
T=$(mktemp -d 2>/dev/null) || exit 2
trap 'rm -rf "$T"' EXIT INT TERM
red=0
pass() { echo "PASS $*"; }
fail() { echo "FAIL $*"; red=$((red+1)); }

sha() {  # file -> hex
  if command -v sha256sum >/dev/null 2>&1; then sha256sum "$1" | awk '{print $1}'
  else shasum -a 256 "$1" | awk '{print $1}'; fi
}
INIT='{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"t","version":"0"}}}'
LIST='{"jsonrpc":"2.0","id":2,"method":"tools/list"}'
call() { printf '{"jsonrpc":"2.0","id":%s,"method":"tools/call","params":{"name":"%s","arguments":%s}}' "$1" "$2" "$3"; }
# rpc ROOT HOME SERVER LINES... -> responses on stdout
rpc() {
  r=$1; h=$2; s=$3; shift 3
  printf '%s\n' "$@" | (cd "$r" && HOME=$h PYTHONPATH=$r timeout 60 "$PY" -m polygram.mcp "$s" 2>"$h/stderr")
}
# tool names in the id-2 answer, one per line, in order
tools_of() { awk '/"id": 2,/ || /"id":2,/' | grep -o '"name": *"[^"]*"' | awk -F'"' '{print $4}'; }
names_line() { tools_of | tr '\n' ' ' | sed 's/ $//'; }

# --- V1 ------------------------------------------------------------------
v1() {  # root -> 0 green
  f=$1/polygram/mcp/tavern_upstream.py; n=$1/polygram/mcp/NOTICE-tavern
  [ -f "$f" ] || { echo "  no $f"; return 1; }
  got=$(sha "$f")
  [ "$got" = "$PIN" ] || { echo "  tavern_upstream.py is $got, pinned $PIN"; return 1; }
  awk -v p="$PIN" '$1=="sha256" && $2==p {ok=1} END {exit !ok}' "$n" || { echo "  NOTICE-tavern does not record $PIN"; return 1; }
  return 0
}
# --- F1 ------------------------------------------------------------------
f1() {  # root -> 0 green
  h=$T/f1.$$.$(date +%s%N 2>/dev/null || echo x); mkdir -p "$h"
  out=$(rpc "$1" "$h" tavernface "$INIT" "$LIST" "$(call 3 tavern_status '{}')")
  nm=$(printf '%s\n' "$out" | names_line)
  [ "$nm" = "tavern_status" ] || { echo "  off server lists: [$nm]"; return 1; }
  st=$(printf '%s\n' "$out" | awk '/"id": 3/')
  for w in OFF 'copied to the disk of every member' 'Ask Claude' 'pref_set' 'stock Tavern 2.3.1' 'patched build, 2.3.1+gp.1,' 'no tool registry' 'projects/garden-pony' 'github.com/inputloop/tavern'; do
    printf '%s' "$st" | grep -q "$w" || { echo "  status does not say: $w"; return 1; }
  done
  [ ! -e "$h/Tavern" ] && [ ! -e "$h/tavern-data" ] || { echo "  an off server made a Tavern folder"; return 1; }
  return 0
}

# --- F5 / F6 (lane B, 2026-10-10) ----------------------------------------
FIX=$here/tests/fixtures/lane-b/tavern/config.json
# tav_home HOME [gp] -> a home with tavern.on on, the fixture Tavern at ~/Tavern/tavern-data, and a
# tavern.py beside it: the vendored stock bytes, or (gp) the same with its VERSION line made gp.1
tav_home() {
  mkdir -p "$1/Tavern/tavern-data" "$1/.mentcached"
  cp "$FIX" "$1/Tavern/tavern-data/config.json"
  printf '{"port": 9, "token": "FIXTURE-TOKEN-NOT-REAL", "pid": 0}' > "$1/Tavern/tavern-data/agent.json"
  if [ "${2:-}" = gp ]; then
    sed 's/^VERSION = "2.3.1"$/VERSION = "2.3.1+gp.1"/' "$here/polygram/mcp/tavern_upstream.py" > "$1/Tavern/tavern.py"
  else cp "$here/polygram/mcp/tavern_upstream.py" "$1/Tavern/tavern.py"; fi
  printf 'ts\tkey\tvalue\tby\twhy\n2026-10-10T00:00:00Z\ttavern.on\ton\ttest\tF5\n' > "$1/.mentcached/prefs.tsv"
}
# st_of ROOT HOME -> status() as key=value lines (say, build, tavern, roads, as, as_from, all)
st_of() {
  (cd "$1" && HOME=$2 PYTHONPATH=$1 "$PY" -c '
import json
from polygram.mcp import tavernface as t
s = t.status()
for k in ("state", "say", "build", "tavern", "roads", "as", "as_from"):
    print(k + "=" + str(s.get(k, "")))
print("all=" + json.dumps(s))' 2>&1)
}
f5() {  # root -> 0 green
  h=$T/f5.$$.$(date +%s%N 2>/dev/null || echo x); tav_home "$h"
  o=$(st_of "$1" "$h")
  printf '%s\n' "$o" | grep -q '^build=stock 2.3.1' || { echo "  stock bytes not named stock 2.3.1: $(printf '%s' "$o" | grep '^build=')"; return 1; }
  printf '%s\n' "$o" | grep -q '^tavern=Genesis$' || { echo "  no tavern name"; return 1; }
  sy=$(printf '%s\n' "$o" | awk -F= '$1=="say" {sub(/^say=/, ""); print}')
  printf '%s' "$sy" | awk -v d="$h/Tavern/tavern-data" '{n=index($0, "Genesis"); a=index($0, d); exit !(n > 0 && a > n)}' \
    || { echo "  say does not put the name before the address: $sy"; return 1; }
  for w in 'need gp.1' 'Wire acts go direct' 'tool registry' 'receipts'; do
    printf '%s\n' "$o" | grep '^roads=' | grep -q "$w" || { echo "  roads do not say: $w"; return 1; }
  done
  for secret in FIXTURE-JOIN-CODE-NOT-REAL 00000000000000000000000000fixture 10.99.0.99 FIXTURE-TOKEN-NOT-REAL; do
    printf '%s' "$o" | grep -q "$secret" && { echo "  status printed a value it must not: $secret"; return 1; }
  done
  g=$T/f5g.$$; tav_home "$g" gp
  st_of "$1" "$g" | grep -q '^build=2.3.1+gp.1' || { echo "  a gp.1 tavern.py is not named gp.1"; return 1; }
  rm -f "$g/Tavern/tavern.py"
  st_of "$1" "$g" | grep '^build=' | grep -q 'no tavern.py' || { echo "  a missing tavern.py is not said"; return 1; }
  # the roads sentence rides on the OFF answer too
  e=$T/f5e.$$; mkdir -p "$e"
  st_of "$1" "$e" | grep '^roads=' | grep -q 'need gp.1' || { echo "  OFF answer lacks the roads sentence"; return 1; }
  return 0
}
f6() {  # root -> 0 green
  h=$T/f6.$$.$(date +%s%N 2>/dev/null || echo x); tav_home "$h"
  o=$(st_of "$1" "$h")
  printf '%s\n' "$o" | grep -q '^as=claudewin$' || { echo "  picked [$(printf '%s\n' "$o" | grep '^as=')], want claudewin (same owner, model claude, first by name)"; return 1; }
  printf '%s\n' "$o" | grep '^as_from=' | grep -q 'config.json' || { echo "  does not say the name came from config.json"; return 1; }
  # no agent of this owner with model claude -> claude
  "$PY" - "$h/Tavern/tavern-data/config.json" <<'PYEOF'
import json, sys
p = sys.argv[1]; c = json.load(open(p))
c["agents"] = {k: v for k, v in c["agents"].items() if k in ("aaa", "wayne")}
json.dump(c, open(p, "w"))
PYEOF
  st_of "$1" "$h" | grep -q '^as=claude$' || { echo "  with no same-owner claude agent the name is not claude"; return 1; }
  return 0
}

mode=${1:-}
if [ "$mode" = --prove-red ]; then
  cp -r "$here/polygram" "$T/a" 2>/dev/null || exit 2; mkdir -p "$T/ra"; mv "$T/a" "$T/ra/polygram"
  cp -r "$here/polygram" "$T/b" 2>/dev/null || exit 2; mkdir -p "$T/rb"; mv "$T/b" "$T/rb/polygram"
  find "$T" -name __pycache__ -type d -exec rm -rf {} + 2>/dev/null
  # (a) one byte planted in the vendored file
  printf '#' >> "$T/ra/polygram/mcp/tavern_upstream.py"
  if v1 "$T/ra" >/dev/null; then echo "KIT BROKEN: a planted byte did not turn V1 red"; exit 2; fi
  echo "RED  V1 under a planted byte (as it must)"
  # (b) the switch planted always-on
  awk '/^def is_on\(\) -> bool:/ {print; print "    return True"; next} {print}' \
      "$here/polygram/mcp/tavernface.py" > "$T/rb/polygram/mcp/tavernface.py"
  if f1 "$T/rb" >/dev/null; then echo "KIT BROKEN: an always-on switch did not turn F1 red"; exit 2; fi
  echo "RED  F1 under an always-on switch (as it must)"
  # (c) the scan list refuses a pinned file with a planted byte (pn1ck's own prove-red, then here)
  ( cd "$T/ra" && sh "$here/bin/pn1ck" unpinned polygram >/dev/null 2>&1 ) && { echo "KIT BROKEN: pn1ck listed files past a planted byte"; exit 2; }
  echo "RED  S1 under a planted byte: the scan list is refused (as it must)"
  # (d) the owner check planted away: any claude agent is picked
  cp -r "$here/polygram" "$T/rd" 2>/dev/null || exit 2; mkdir -p "$T/rdd"; mv "$T/rd" "$T/rdd/polygram"
  find "$T/rdd" -name __pycache__ -type d -exec rm -rf {} + 2>/dev/null
  sed 's/if v.get("owner", "") == owner and/if/' "$here/polygram/mcp/tavernface.py" > "$T/rdd/polygram/mcp/tavernface.py"
  cmp -s "$here/polygram/mcp/tavernface.py" "$T/rdd/polygram/mcp/tavernface.py" && { echo "KIT BROKEN: plant (d) found no owner check to remove"; exit 2; }
  if f6 "$T/rdd" >/dev/null; then echo "KIT BROKEN: a missing owner check did not turn F6 red"; exit 2; fi
  echo "RED  F6 under a missing owner check (as it must)"
  # (e) a status planted to print the join code (everything else unchanged)
  awk '{print} /^    say \+= ". Build: / {print "    say += \" \" + __import__(\"json\").loads((Path(f[\"dir\"]) / \"config.json\").read_text())[\"join_code\"]"}' \
      "$here/polygram/mcp/tavernface.py" > "$T/rdd/polygram/mcp/tavernface.py"
  cmp -s "$here/polygram/mcp/tavernface.py" "$T/rdd/polygram/mcp/tavernface.py" && { echo "KIT BROKEN: plant (e) found no say line"; exit 2; }
  why=$(f5 "$T/rdd"); case $why in *"must not: FIXTURE-JOIN-CODE"*) ;; *) echo "KIT BROKEN: the join-code plant did not turn F5 red for that reason: $why"; exit 2;; esac
  echo "RED  F5 under a status that prints the join code (as it must)"
  echo "PROVE-RED PASS: all five plants went red"; exit 0
fi

# --- run -------------------------------------------------------------------
if msg=$(v1 "$here"); then pass "V1 vendored bytes are Bryant's 2.3.1 ($PIN)"; else fail "V1"; echo "$msg"; fi
if msg=$(f1 "$here"); then pass "F1 off by default: one tool, says OFF, what it means, how to ask"; else fail "F1"; echo "$msg"; fi

# F2: on by asking Claude (pref_set through mentcached), no Tavern anywhere
h=$T/f2; mkdir -p "$h"
o=$(rpc "$here" "$h" mentcached "$INIT" "$(call 3 pref_set '{"key":"tavern.on","value":"on","why":"F2"}')")
if printf '%s' "$o" | grep -q "tavern.on = 'on'"; then
  out=$(rpc "$here" "$h" tavernface "$INIT" "$LIST" "$(call 3 tavern_status '{}')")
  nm=$(printf '%s\n' "$out" | names_line)
  if [ "$nm" = tavern_status ] && printf '%s' "$out" | grep -q 'NO TAVERN FOUND' && printf '%s' "$out" | grep -q 'Start Tavern'; then
    pass "F2 turned on by pref_set alone; no Tavern found -> one tool, says so and what to do"
  else fail "F2 on + no Tavern: lists [$nm]"; printf '%s\n' "$out" | tail -2; fi
else fail "F2 pref_set tavern.on did not take"; printf '%s\n' "$o" | tail -2; fi

# F3: found at the installer's place, served by Tavern's own face, closed port -> plain error
mkdir -p "$h/Tavern/tavern-data"
printf '{"port": 9, "token": "x", "pid": 0}' > "$h/Tavern/tavern-data/agent.json"
out=$(rpc "$here" "$h" tavernface "$INIT" "$LIST" "$(call 3 tavern_who '{}')")
nm=$(printf '%s\n' "$out" | names_line)
case " $nm " in
  *" tavern_say "*" tavern_read "*|*" tavern_read "*" tavern_say "*)
    if printf '%s' "$out" | awk '/"id": 3/' | grep -qi 'reach\|running'; then
      pass "F3 found ~/Tavern/tavern-data by itself; Tavern's face answers; no node -> plain error"
    else fail "F3 call with no node did not say so plainly"; printf '%s\n' "$out" | tail -1 | cut -c1-300; fi ;;
  *) fail "F3 on + Tavern found: lists [$nm]"; tail -3 "$h/stderr" ;;
esac

# F4: tavern.data and tavern.as preferences
mkdir -p "$h/elsewhere/td"; : > "$h/elsewhere/td/node.key"
printf '%s\t%s\t%s\t%s\t%s\n' 2026-10-08T00:00:00Z tavern.data "$h/elsewhere/td" test F4 2026-10-08T00:00:00Z tavern.as sage test F4 >> "$h/.mentcached/prefs.tsv"
rm -f "$h/Tavern/tavern-data/agent.json"
got=$(cd "$here" && HOME=$h PYTHONPATH=$here "$PY" -c 'from polygram.mcp import tavernface as t; s=t.status(); print(s["state"]+"|"+s.get("data","")+"|"+s.get("found_by","")+"|"+s.get("as",""))' 2>&1)
if [ "$got" = "ON|$h/elsewhere/td|preference tavern.data|sage" ]; then pass "F4 tavern.data wins the search; tavern.as names the agent"
else fail "F4 got [$got]"; fi

if msg=$(f5 "$here"); then pass "F5 names the build (stock 2.3.1 / gp.1 / missing), the Tavern's name before its address, the roads that need gp.1; prints no join code, id, ip or token"; else fail "F5"; echo "$msg"; fi
if msg=$(f6 "$here"); then pass "F6 tavern.as unset -> claudewin (same owner, model claude), never a second owner's agent; else claude"; else fail "F6"; echo "$msg"; fi

# M1: a real mint
m=$T/mint; mkdir -p "$m/out"
if (cd "$here" && PYTHONPATH=$here "$PY" -c '
import sys, zipfile
from pathlib import Path
from polygram import dist, plugin
root = Path(".").resolve(); out = Path(sys.argv[1])
res = plugin.mint_plugin(out / "out", dist.collect(root / "skills", include_workspace=True), source_root=root)
zipfile.ZipFile(res.archive).extractall(out / "inst")
' "$m" >"$m/log" 2>&1); then
  i=$m/inst; bad=""
  for f in tavernface.py tavern_upstream.py NOTICE-tavern; do [ -f "$i/servers/polygram/mcp/$f" ] || bad="$bad missing:$f"; done
  [ "$(sha "$i/servers/polygram/mcp/tavern_upstream.py" 2>/dev/null)" = "$PIN" ] || bad="$bad sha"
  awk '/"tavernface": \{/ {f=1} f && /CLAUDE_PLUGIN_ROOT}\/servers\/launch.py/ {ok=1} f && /tavernface/ {ok2=1} f && /^    }/ {f=0} END {exit !(ok && ok2)}' "$i/.mcp.json" || bad="$bad mcp.json"
  (cd "$i" && sh check.sh >"$m/check" 2>&1) || bad="$bad check.sh"
  (cd "$m" && env -u PYTHONPATH "$PY" "$i/servers/launch.py" --list 2>&1 | grep -q '^tavernface ') || bad="$bad launch-list"
  [ -z "$(find "$i" -name __pycache__ 2>/dev/null)" ] || bad="$bad pycache"
  awk '/^\| `tavernface` \|/ {f=1} f && /stock Tavern 2\.3\.1/ {a=1} f && /garden-pony/ {b=1} f && /inputloop\/tavern/ {c=1} f && /\|$/ && !/^\| `tavernface`/ {f=0} END {exit !(a && b && c)}' "$i/README.md" || bad="$bad README-stock-2.3.1"
  if [ -z "$bad" ]; then pass "M1 a real mint ships it, pinned, off, launched by launch.py; check.sh green; README says stock 2.3.1; no __pycache__"
  else fail "M1:$bad"; tail -5 "$m/check" 2>/dev/null; fi
else fail "M1 mint failed"; tail -5 "$m/log"; fi

# S1: make dist's secrets scan -- the pin is checked, then the vendored file is left out, nothing else
if (cd "$here" && sh bin/pn1ck check polygram 2>/dev/null) && \
   l=$(cd "$here" && sh bin/pn1ck unpinned polygram 2>/dev/null) && \
   ! printf '%s\n' "$l" | grep -q 'tavern_upstream.py$' && printf '%s\n' "$l" | grep -q 'tavernface.py$' && \
   printf '%s\n' "$l" | grep -q 'NOTICE-tavern$'; then
  pass "S1 the pin holds; only the pinned file is left out of the secrets scan"
else fail "S1 pn1ck check/unpinned"; fi

if [ "$red" -eq 0 ]; then echo "GREEN tavernface: 9/9"; exit 0; fi
echo "RED tavernface: $red failing"; exit 1
