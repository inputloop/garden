#!/bin/sh
# c4face-tests.sh -- C4's own MCP server, served from the person's C4 tree by the vibrobeast plugin;
# spec in tests/c4face-SPEC.txt (read that first).  POSIX sh + awk, testing Python (and a JS fixture).
# tier: smoke
# usage: sh tests/c4face-tests.sh [--prove-red] [--no-mint]       (from anywhere)
# Exit 0 green, 1 red, 2 kit broken.
# Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
# Written by Mentat (for Corwin; claude-opus-5-5).
set -u
here=$(cd "$(dirname "$0")/.." && pwd) || exit 2
PY=${PYTHON:-python3}
PYABS=$(command -v "$PY") || { echo "KIT BROKEN: no $PY"; exit 2; }
command -v node >/dev/null 2>&1 || { echo "KIT BROKEN: no node here; c4face's proxy cannot be tested"; exit 2; }
NODEDIR=$(dirname "$(command -v node)")
export PYTHONDONTWRITEBYTECODE=1
# A machine that really has F:/claude/c4 (the author's) must still be able to test "nothing found".
export C4FACE_GUESS=0
# c4face is OFF until asked (QA1 row 14); the checks of what it does when on say C4_ON=1, and C9/C10
# check the switch itself with C4_ON unset.
export C4_ON=1
unset C4_ROOT MENTCACHED_PREFS MENTCACHED_SEAT POLYGRAM_DIST VIBROBEAST_NODE PYTHONPATH 2>/dev/null
T=$(mktemp -d 2>/dev/null) || exit 2
trap 'rm -rf "$T"' EXIT INT TERM
FIX=$here/tests/fixtures/c4face/c4
[ -f "$FIX/mcp/c4-mcp.js" ] || { echo "KIT BROKEN: no fixture at $FIX"; exit 2; }
cp -R "$FIX" "$T/c4fix" || exit 2
red=0; MINT=1; MODE=run
for a in "$@"; do case $a in --prove-red) MODE=red ;; --no-mint) MINT=0 ;; *) echo "unknown argument $a"; exit 2 ;; esac; done
pass() { echo "PASS $*"; }
fail() { echo "FAIL $*"; red=$((red+1)); }

INIT='{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"t","version":"0"}}}'
LIST='{"jsonrpc":"2.0","id":2,"method":"tools/list"}'
call() { printf '{"jsonrpc":"2.0","id":%s,"method":"tools/call","params":{"name":"%s","arguments":%s}}' "$1" "$2" "$3"; }
# rpc ROOT HOME SERVER LINES... -> responses on stdout (env from the caller, e.g. C4_ROOT=...)
rpc() {
  r=$1; h=$2; s=$3; shift 3
  printf '%s\n' "$@" | (cd "$r" && HOME=$h USERPROFILE=$h PYTHONPATH=$r timeout 60 "$PYABS" -m polygram.mcp "$s" 2>"$h/stderr")
}
# the tool names in the id-2 answer, space-separated, in order
names() { awk '/"id": *2,/' | grep -o '"name": *"[^"]*"' | awk -F'"' '$4 != "c4-fixture" && $4 != "c4face" && $4 != "c4-work-surface" {print $4}' | tr '\n' ' ' | sed 's/ $//'; }
fresh() { d=$T/h.$1; mkdir -p "$d"; printf '%s' "$d"; }

c1() {  # ROOT -> 0 green
  h=$(fresh c1.$$.$2)
  out=$(rpc "$1" "$h" c4face "$INIT" "$LIST" "$(call 3 c4_status '{}')")
  nm=$(printf '%s\n' "$out" | names)
  [ "$nm" = c4_status ] || { echo "  lists [$nm]"; return 1; }
  st=$(printf '%s\n' "$out" | awk '/"id": *3/')
  for w in 'NO C4 TREE FOUND' 'c4.root' 'pref_set' 'looked_in' 'Nothing to edit by hand'; do
    printf '%s' "$st" | grep -q "$w" || { echo "  status does not say: $w"; return 1; }
  done
  [ -z "$(ls -A "$h" | grep -v '^stderr$')" ] || { echo "  it wrote in the home folder: $(ls -A "$h")"; return 1; }
}
c4() {  # ROOT -> 0 green
  h=$(fresh c4.$$.$2)
  o=$(rpc "$1" "$h" mentcached "$INIT" "$(call 3 pref_set "{\"key\":\"c4.root\",\"value\":\"$T/c4fix\",\"why\":\"C4\"}")")
  printf '%s' "$o" | grep -q "c4.root = " || { echo "  pref_set c4.root did not take: $(printf '%s' "$o" | tail -1 | cut -c1-200)"; return 1; }
  got=$(cd "$1" && HOME=$h PYTHONPATH=$1 "$PYABS" -c 'from polygram.mcp import c4face as c; f=c.find_c4(); print(str(f["dir"])+"|"+f["from"])' 2>&1)
  [ "$got" = "$T/c4fix|preference c4.root" ] || { echo "  got [$got]"; return 1; }
}
c7() {  # ROOT -> 0 green
  cp -R "$T/c4fix" "$T/c4bad.$2"
  printf "const h = require('http');\n" >> "$T/c4bad.$2/lib/c4-model.js"
  h=$(fresh c7.$$.$2)
  out=$(C4_ROOT=$T/c4bad.$2 rpc "$1" "$h" c4face "$INIT" "$LIST" "$(call 3 c4_status '{}')")
  nm=$(printf '%s\n' "$out" | names)
  [ "$nm" = c4_status ] || { echo "  a C4 that asks for http was started anyway: lists [$nm]"; return 1; }
  st=$(printf '%s\n' "$out" | awk '/"id": *3/')
  for w in 'NOT STARTED' 'lib/c4-model.js line 4: require of http' 'made again'; do
    printf '%s' "$st" | grep -q "$w" || { echo "  status does not say: $w"; return 1; }
  done
}

c9() {  # ROOT -> 0 green: with C4_ON unset and no c4.on, OFF: one tool, says how to ask, runs no node
  h=$(fresh c9.$$.$2)
  out=$(env -u C4_ON C4_ROOT=$T/c4fix sh -c 'printf "%s\n" "$@"' x "$INIT" "$LIST" "$(call 3 c4_status '{}')" \
        | (cd "$1" && env -u C4_ON HOME=$h USERPROFILE=$h C4_ROOT=$T/c4fix PYTHONPATH=$1 timeout 60 "$PYABS" -m polygram.mcp c4face 2>"$h/stderr"))
  nm=$(printf '%s\n' "$out" | names)
  [ "$nm" = c4_status ] || { echo "  off by default, yet lists [$nm]"; return 1; }
  st=$(printf '%s\n' "$out" | awk '/"id": *3/')
  for w in 'OFF' 'c4.on' 'pref_set' 'Nothing to edit by hand' 'tripwire, not'; do
    printf '%s' "$st" | grep -q "$w" || { echo "  status does not say: $w"; return 1; }
  done
  ! grep -q 'c4face: serving' "$h/stderr" || { echo "  it started node while off"; return 1; }
}
c10() {  # ROOT -> 0 green: pref_set c4.on on (asked of Claude, never hand-edited) turns it on
  h=$(fresh c10.$$.$2)
  o=$(rpc "$1" "$h" mentcached "$INIT" "$(call 3 pref_set '{"key":"c4.on","value":"on","why":"C4"}')")
  printf '%s' "$o" | grep -q "c4.on = " || { echo "  pref_set c4.on did not take: $(printf '%s' "$o" | tail -1 | cut -c1-200)"; return 1; }
  got=$(cd "$1" && env -u C4_ON HOME=$h PYTHONPATH=$1 "$PYABS" -c 'from polygram.mcp import c4face as c; print(c.is_on())' 2>&1)
  [ "$got" = True ] || { echo "  is_on after pref_set: [$got]"; return 1; }
}
# The evasions QA1 (rows 14; P8, F13) and QA2 (row 7: names and strings spelled with \u, \u{}, \x and
# octal escapes, and process[`env`]) named, and their cousins: each, planted into a copy of the
# fixture -- once into mcp/c4-mcp.js and once into lib/c4-model.js -- must stop C4 from starting.
EVASIONS='require(`fs`);
const m = "fs"; require(m);
const r = require; r("fs");
require("module").createRequire(__filename)("fs");
process.binding("fs");
process["binding"]("fs");
process.dlopen({}, "x.node");
process.mainModule.require("fs");
require("os");
require("vm");
require("worker_threads");
require("module");
require("inspector");
require("node:fs");
require("child_process");
require("../lib/other.js");
module.require("fs");
import("fs");
eval("1");
new Function("return 1")();
globalThis.process;
({}).constructor.constructor("return 1")();
const t = `${require("fs")}`;
const re = /"/; require("net");
requir\u0065("fs");
\u0072equire("fs");
require("\x66s");
require("\u{66}s");
require("f\163");
require(`\x66s`);
x["\x63onstructor"]("return 1");
x["\u0063onstructor"];
pr\u{6f}cess.env;
process.\u0065nv;
process[`env`];
process["\u0065nv"];
ev\u{61}l("1");
g\u006cobalThis.x;
const u = `${requir\u0065("fs")}`;
a\x62c;'
# ... and what must NOT stop it: the words in comments and strings, and the shapes C4 uses.
CLEAN='// require("fs") and import("x") in a comment
/* eval(require("child_process")) */
const s = "we never eval or import anything";
process.stderr.write("x");
if (typeof module === "object" && module.exports) module.exports = {};
const e = "caf\u00e9 \n \"q\" \\";
process.stderr.write("\u0041");
const g = /\u0041/;'
c11() {  # ROOT -> 0 green
  printf '%s\n' "$EVASIONS" > "$T/ev.$2"; printf '%s\n' "$CLEAN" > "$T/cl.$2"
  (cd "$1" && PYTHONPATH=$1 "$PYABS" - "$T/c4fix" "$T/ev.$2" "$T/cl.$2" "$T/w.$2" <<'EOF'
import shutil, sys
from pathlib import Path
from polygram.mcp import c4face as c
fix, ev, cl, w = sys.argv[1:5]
bad = 0
def planted(where, line):
    d = Path(w); shutil.rmtree(d, ignore_errors=True); shutil.copytree(fix, d)
    f = d / where
    f.write_text(f.read_text(encoding="utf-8") + line + "\n", encoding="utf-8")
    return c.guard(d)
for line in Path(ev).read_text(encoding="utf-8").splitlines():
    for where in ("mcp/c4-mcp.js", "lib/c4-model.js"):
        if not planted(where, line):
            print(f"  MISSED in {where}: {line}"); bad += 1
for line in Path(cl).read_text(encoding="utf-8").splitlines():
    for where in ("mcp/c4-mcp.js", "lib/c4-model.js"):
        h = planted(where, line)
        if h:
            print(f"  FALSE ALARM in {where}: {line} -> {h[0]}"); bad += 1
sys.exit(1 if bad else 0)
EOF
  )
}

if [ $MODE = red ]; then
  for k in a b c d e f; do cp -R "$here/polygram" "$T/r$k" || exit 2; mkdir -p "$T/R$k"; mv "$T/r$k" "$T/R$k/polygram"; done
  find "$T" -name __pycache__ -type d -exec rm -rf {} + 2>/dev/null
  # (a) the guard made to pass everything
  awk '/^def guard\(c4: Path\) -> list\[str\]:/ {print; print "    return []"; next} {print}' "$here/polygram/mcp/c4face.py" > "$T/Ra/polygram/mcp/c4face.py"
  cmp -s "$T/Ra/polygram/mcp/c4face.py" "$here/polygram/mcp/c4face.py" && { echo "KIT BROKEN: plant a changed nothing"; exit 2; }
  c7 "$T/Ra" ra >/dev/null && { echo "FAIL: a guard that passes everything did not turn C7 red"; exit 1; }
  echo "RED  C7 under a guard that passes everything (as it must)"
  # (b) the c4.root preference ignored
  sed 's/("preference c4.root", _pref("c4.root"))/("preference c4.root", "")/' "$here/polygram/mcp/c4face.py" > "$T/Rb/polygram/mcp/c4face.py"
  cmp -s "$T/Rb/polygram/mcp/c4face.py" "$here/polygram/mcp/c4face.py" && { echo "KIT BROKEN: plant b changed nothing"; exit 2; }
  c4 "$T/Rb" rb >/dev/null && { echo "FAIL: ignoring c4.root did not turn C4 red"; exit 1; }
  echo "RED  C4 under an ignored c4.root preference (as it must)"
  # (c) a second tool on the status server
  awk '/^    return srv$/ && !done {print "    @srv.tool(\"c4_extra\", \"planted\")"; print "    def _x(_a):"; print "        return {}"; done=1} {print}' "$here/polygram/mcp/c4face.py" > "$T/Rc/polygram/mcp/c4face.py"
  cmp -s "$T/Rc/polygram/mcp/c4face.py" "$here/polygram/mcp/c4face.py" && { echo "KIT BROKEN: plant c changed nothing"; exit 2; }
  c1 "$T/Rc" rc >/dev/null && { echo "FAIL: a second tool did not turn C1 red"; exit 1; }
  echo "RED  C1 under a second status tool (as it must)"
  # (d) the guard put back to the first build's regex (the one QA1 broke): C11 must go red
  awk '/^def scan_js\(src: str, allow_libs: bool\):/ {print; print "    import re as _r"; print "    g = _r.compile(r\"\"\"require\\(\\s*[\x27\"](?:node:)?(net|http|https|http2|dgram|tls|dns|child_process|cluster|worker_threads|fs|fs/promises)[\x27\"]\\s*\\)|\\bimport\\s*\\(\"\"\")"; print "    libs = _r.findall(r\"\"\"[\x27\"]lib[\x27\"]\\s*,\\s*[\x27\"]([A-Za-z0-9_.-]+\\.js)[\x27\"]\"\"\", src)"; print "    return [m.group(0) for m in g.finditer(src)], libs"; next} {print}' "$here/polygram/mcp/c4face.py" > "$T/Rd/polygram/mcp/c4face.py"
  cmp -s "$T/Rd/polygram/mcp/c4face.py" "$here/polygram/mcp/c4face.py" && { echo "KIT BROKEN: plant d changed nothing"; exit 2; }
  out=$(c11 "$T/Rd" rd) && { echo "FAIL: the old regex guard did not turn C11 red"; exit 1; }
  n=$(printf '%s\n' "$out" | grep -c MISSED)
  [ "$n" -gt 0 ] || { echo "KIT BROKEN: plant d went red for another reason: $out"; exit 2; }
  echo "RED  C11 under the first build's regex guard: $n planted evasion(s) missed (as it must)"
  # (e) on by default again
  awk '/^def is_on\(\) -> bool:/ {print; print "    return True"; next} {print}' "$here/polygram/mcp/c4face.py" > "$T/Re/polygram/mcp/c4face.py"
  cmp -s "$T/Re/polygram/mcp/c4face.py" "$here/polygram/mcp/c4face.py" && { echo "KIT BROKEN: plant e changed nothing"; exit 2; }
  c9 "$T/Re" re >/dev/null && { echo "FAIL: on by default did not turn C9 red"; exit 1; }
  echo "RED  C9 under on-by-default (as it must)"
  # (f) escapes no longer decoded (FOLD-QA2 row 7): C11 must go red, by MISSED evasions
  awk '/^def js_unescape\(raw: str, ident: bool = False\) -> str:/ {print; print "    return raw"; next} {print}' "$here/polygram/mcp/c4face.py" > "$T/Rf/polygram/mcp/c4face.py"
  cmp -s "$T/Rf/polygram/mcp/c4face.py" "$here/polygram/mcp/c4face.py" && { echo "KIT BROKEN: plant f changed nothing"; exit 2; }
  out=$(c11 "$T/Rf" rf) && { echo "FAIL: a lexer that does not decode escapes did not turn C11 red"; exit 1; }
  n=$(printf '%s\n' "$out" | grep -c MISSED)
  [ "$n" -gt 0 ] || { echo "KIT BROKEN: plant f went red for another reason: $out"; exit 2; }
  echo "RED  C11 under a lexer that does not decode escapes: $n planted evasion(s) missed (as it must)"
  echo "PROVE-RED PASS: all six plants went red"; exit 0
fi

# --- run -------------------------------------------------------------------
if msg=$(c1 "$here" run); then pass "C1 nothing found: one tool, c4_status, says so and how to ask; writes nothing"; else fail "C1"; echo "$msg"; fi

h=$(fresh c2)
out=$(C4_ROOT=$T/c4fix rpc "$here" "$h" c4face "$INIT" "$LIST")
nm=$(printf '%s\n' "$out" | names)
if [ "$nm" = c4_fixture_probe ] && printf '%s' "$out" | grep -q '"c4-fixture"'; then pass "C2 proxied: the fixture's own initialize and tools/list come through"
else fail "C2 lists [$nm]"; tail -3 "$h/stderr"; fi

REAL=""
for c in "${C4_REAL:-}" "$here/../c4" "$here/../../c4" "$HOME/mnt/c4"; do
  [ -n "$c" ] && [ -f "$c/mcp/c4-mcp.js" ] && [ -f "$c/lib/c4-model.js" ] && { REAL=$(cd "$c" && pwd); break; }
done
if [ -n "$REAL" ]; then
  h=$(fresh c3)
  out=$(C4_ROOT=$REAL rpc "$here" "$h" c4face "$INIT" "$LIST" "$(call 3 c4_fragments '{}')")
  nm=$(printf '%s\n' "$out" | names)
  case " $nm " in
    *" c4_fragments "*" c4_diagram_new "*)
      if printf '%s\n' "$out" | awk '/"id": *3/' | grep -q '"result"'; then pass "C3 the real C4 tree ($REAL): C4's own tools, and c4_fragments answers"
      else fail "C3 c4_fragments did not answer"; printf '%s\n' "$out" | tail -1 | cut -c1-200; fi ;;
    *) fail "C3 the real C4 tree lists [$nm]"; tail -3 "$h/stderr" ;;
  esac
else echo "SKIP C3 no real C4 tree reachable from here (set C4_REAL to one)"; fi

if msg=$(c4 "$here" run); then pass "C4 set by asking Claude: pref_set c4.root, then found by the preference"; else fail "C4"; echo "$msg"; fi

mkdir -p "$T/x/AS4CE/AS4CE0001/seat"; cp -R "$T/c4fix" "$T/x/c4"
h=$(fresh c5)
got=$(cd "$here" && HOME=$h MENTCACHED_SEAT=$T/x/AS4CE/AS4CE0001/seat PYTHONPATH=$here "$PYABS" -c 'from polygram.mcp import c4face as c; f=c.find_c4(); print(str(f["dir"])+"|"+f["from"])' 2>&1)
if [ "$got" = "$T/x/c4|a c4 folder near MENTCACHED_SEAT" ]; then pass "C5 found two folders above the seat, as on the author's machine"
else fail "C5 got [$got]"; fi

h=$(fresh c6)
got=$(cd "$here" && HOME=$h C4_ROOT=$T/c4fix PATH=/nonexistent PYTHONPATH=$here "$PYABS" -c 'from polygram.mcp import c4face as c; s=c.status(); print(s["state"]+"|"+s.get("say","")+"|"+s.get("node",""))' 2>&1)
case $got in
  "C4 FOUND, BUT NO NODE|"*nodejs.org*) pass "C6 no node: says C4 FOUND, BUT NO NODE and where to get one" ;;
  "ON|"*) echo "SKIP C6 a node outside PATH was found on this host (${got##*|}); cannot hide it" ;;
  *) fail "C6 got [$got]" ;;
esac

if msg=$(c7 "$here" run); then pass "C7 a C4 that asks for http is not started; c4_status says which file and module"; else fail "C7"; echo "$msg"; fi

if msg=$(c9 "$here" run); then pass "C9 off until asked: with no c4.on, one tool says OFF, how to ask, and runs no node"; else fail "C9"; echo "$msg"; fi
if msg=$(c10 "$here" run); then pass "C10 asked of Claude: pref_set c4.on on turns it on"; else fail "C10"; echo "$msg"; fi
if msg=$(c11 "$here" run); then pass "C11 each planted evasion (40, in c4-mcp.js and in a lib) stops C4; comments, strings and C4's own shapes do not"; else fail "C11"; echo "$msg"; fi

n=$(grep -cE '^[[:space:]]*(import|from)[[:space:]]+(urllib|http|requests|ftplib|smtplib|asyncio|ssl|socket)\b' "$here/polygram/mcp/c4face.py")
[ "$n" = 0 ] && pass "C8 c4face.py imports no network library" || fail "C8 $n network import(s) in c4face.py"

if [ $MINT = 1 ]; then
  m=$T/mint; mkdir -p "$m/out"
  if (cd "$here" && PYTHONPATH=$here "$PYABS" -c '
import sys, zipfile
from pathlib import Path
from polygram import dist, plugin
root = Path(".").resolve(); out = Path(sys.argv[1])
res = plugin.mint_plugin(out / "out", dist.collect(root / "skills", include_workspace=True), source_root=root, launch="python")
zipfile.ZipFile(res.archive).extractall(out / "inst")
' "$m" >"$m/log" 2>&1); then
    i=$m/inst; bad=""
    [ -f "$i/servers/polygram/mcp/c4face.py" ] || bad="$bad missing:c4face.py"
    awk '/"c4face": \{/ {f=1} f && /servers\/launch.py/ {ok=1} f && /^    }/ {f=0} END {exit !ok}' "$i/.mcp.json" || bad="$bad mcp.json"
    (cd "$m" && env -u PYTHONPATH HOME=$m "$PYABS" "$i/servers/launch.py" --list 2>&1 | grep -q '^c4face ') || bad="$bad launch-list"
    [ -z "$(find "$i" -name __pycache__ 2>/dev/null)" ] || bad="$bad pycache"
    [ -z "$bad" ] && pass "M1 a real mint ships c4face, wires it through launch.py, lists it; no __pycache__" || fail "M1:$bad"
  else fail "M1 mint failed"; tail -5 "$m/log"; fi
else echo "SKIP M1 (--no-mint)"; fi

if [ "$red" -eq 0 ]; then echo "GREEN c4face"; exit 0; fi
echo "RED c4face: $red failing"; exit 1
