#!/bin/sh
# launch-cmd-tests.sh -- servers\launch.cmd finds Python by itself on Windows; spec in
# tests/launch-cmd-SPEC.txt (read that first).  POSIX sh + awk, testing a batch file and Python.
# tier: smoke
# usage: sh tests/launch-cmd-tests.sh [--prove-red] [--no-mint]   (from anywhere)
# Exit 0 green, 1 red, 2 kit broken.  This checks TEXT, not behaviour: no cmd.exe runs here.
# Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
# Written by Mentat (for Corwin; claude-opus-5-5).
set -u
here=$(cd "$(dirname "$0")/.." && pwd) || exit 2
SRC=$here/polygram/launch.cmd
[ -f "$SRC" ] || { echo "KIT BROKEN: no $SRC"; exit 2; }
PY=${PYTHON:-python3}
export PYTHONDONTWRITEBYTECODE=1
T=$(mktemp -d 2>/dev/null) || exit 2
trap 'rm -rf "$T"' EXIT INT TERM
MODE=run; MINT=1
for a in "$@"; do case $a in --prove-red) MODE=red ;; --no-mint) MINT=0 ;; *) echo "unknown argument $a"; exit 2 ;; esac; done

# text FILE -> one "FAIL Ln ..." line per broken rule on stdout; nothing when all hold
text() {
  f=$1
  # L1 ASCII: delete the allowed bytes; anything left is not allowed
  n=$(LC_ALL=C tr -d '\011\012\015\040-\176' < "$f" | wc -c | tr -d ' ')
  [ "$n" = 0 ] || echo "FAIL L1 $n byte(s) that are not tab, CR, LF or printable ASCII"
  # L2 CRLF on every line, the last one too
  LC_ALL=C awk 'BEGIN{RS="\n"} { if ($0 !~ /\r$/) bad++ } END { exit bad>0 }' "$f" \
    || echo "FAIL L2 a line ends without CR (not CRLF)"
  [ "$(tail -c 2 "$f" | od -An -c | tr -d ' ')" = '\r\n' ] || echo "FAIL L2 the last line does not end CRLF"
  # everything else reads the file with CRs stripped
  tr -d '\015' < "$f" > "$T/lf"
  LC_ALL=C awk '
    function code(s) { return s !~ /^[ \t]*(rem([ \t]|$)|::)/ }
    { L[NR] = $0 }
    NR == 1 && $0 != "@echo off" { print "FAIL L3 the first line is not @echo off" }
    NR > 1 && code($0) && /(^|[ \t&(])echo[ .(]/ && $0 !~ /^>&2 echo / { print "FAIL L3 line " NR " echoes to stdout: " $0 }
    code($0) && /where / && $0 !~ /where [a-z0-9]+ (2\^>nul|>nul 2>&1)/ { print "FAIL L3 line " NR ": where without its output to nul" }
    code($0) && /-c "import sys; sys.exit/ && $0 !~ />nul 2>&1/ { print "FAIL L3 line " NR ": the probe does not send its output to nul" }
    # L4 order (code lines only)
    code($0) && $0 == "if defined VIBROBEAST_PYTHON call :VB_TRY_EXE \"%VIBROBEAST_PYTHON%\" named" { s1 = s1 ? -1 : NR }
    code($0) && $0 == "call :VB_TRY_PYLAUNCHER" { s2 = s2 ? -1 : NR }
    code($0) && index($0, "(\x27where python3 2^>nul\x27)") { s3 = s3 ? -1 : NR }
    code($0) && index($0, "(\x27where python 2^>nul\x27)") { s4 = s4 ? -1 : NR }
    code($0) && index($0, "for %%R in (ucrt64 mingw64 clang64) do") && index($0, "\"C:\\msys64\\%%R\\bin\\python3.exe\"") { s5 = s5 ? -1 : NR }
    code($0) && index($0, "for %%R in (ucrt64 mingw64 clang64) do") && index($0, "\"C:\\msys64\\%%R\\bin\\python.exe\"") { s6 = s6 ? -1 : NR }
    code($0) && index($0, "(\"%LOCALAPPDATA%\\Programs\\Python\\Python3*\")") { s7 = s7 ? -1 : NR }
    code($0) && index($0, "(\"%ProgramFiles%\\Python3*\")") { s8 = s8 ? -1 : NR }
    code($0) && /^>&2 echo .*no Python 3\.10 or newer was found.*python\.org.*restart Claude/ { s9 = s9 ? -1 : NR; s9x = NR + 1 }
    $0 == ":VB_RUN" { run = NR }
    $0 == ":VB_TRY_EXE" { te = NR }
    # L7 quoting
    code($0) && index($0, "%*") { print "FAIL L7 line " NR " uses %*: " $0 }
    code($0) && /^set / && $0 !~ /^set "[A-Za-z_][A-Za-z0-9_]*=/ { print "FAIL L7 line " NR " is not a set \"NAME=value\": " $0 }
    code($0) && /call :VB_TRY_EXE / && $0 !~ /call :VB_TRY_EXE "[^"]+"( named)?$/ { print "FAIL L7 line " NR ": an unquoted :VB_TRY_EXE argument" }
    code($0) && /call :VB_TRY_EXE / && / named$/ { named++ }
    code($0) && /launch\.py/ { runline = runline ? -1 : NR; rl = $0 }
    # L8 labels
    code($0) && match($0, /^:[A-Za-z_][A-Za-z0-9_]*$/) { lab[substr($0, 2)] = 1 }
    { s = $0; while (code(s) && match(s, /(goto|call) :[A-Za-z_][A-Za-z0-9_]*/)) { t = substr(s, RSTART, RLENGTH); sub(/^(goto|call) :/, "", t); want[t] = NR; s = substr(s, RSTART + RLENGTH) } }
    # L9 credit
    /^rem / && /Bryant Frankford/ { cb = 1 }
    $0 == "rem Copyright 2026 Bryant Frankford <nathanielfrankford@gmail.com> and Corwin Brust <corwin@bru.st>" { cc = 1 } /^rem / && /Tavern-Setup/ { ct = 1 } /^rem / && /:TVL_FIND/ && /:TVL_TRY/ { cf = 1 }
    END {
      n = split("s1 s2 s3 s4 s5 s6 s7 s8 s9", k, " ")
      v[1]=s1; v[2]=s2; v[3]=s3; v[4]=s4; v[5]=s5; v[6]=s6; v[7]=s7; v[8]=s8; v[9]=s9
      for (i = 1; i <= n; i++) {
        if (v[i] == 0) print "FAIL L4 step " i " is missing"
        else if (v[i] < 0) print "FAIL L4 step " i " appears more than once"
        else if (i > 1 && v[i-1] > 0 && v[i] < v[i-1]) print "FAIL L4 step " i " comes before step " i-1
        if (v[i] > 0 && run && v[i] > run) print "FAIL L4 step " i " is after :VB_RUN"
      }
      if (s9 > 0 && L[s9x] != "exit /b 1") print "FAIL L4 the not-found sentence is not followed by exit /b 1"
      # L5: inside :VB_TRY_EXE, the WindowsApps skip precedes the exist test, the probe and the set
      wa = ex = pr = sp = gp = 0
      for (i = te; te && i <= NR && !(i > te && L[i] ~ /^exit \/b 0$/ && L[i-1] ~ /^set "VB_PY=/); i++) {
        if (!wa && L[i] == "if not \"%VB_CAND:\\WindowsApps\\=%\"==\"%VB_CAND%\" exit /b 0") wa = i
        if (!ex && L[i] ~ /^if not exist "%VB_CAND%" exit \/b 0$/) ex = i
        if (!pr && index(L[i], "\"%VB_CAND%\" -c \"import sys; sys.exit(0 if sys.version_info >= (3, 10) else 3)\"")) pr = i
        if (!sp && L[i] == "set \"VB_PY=%VB_CAND%\"") sp = i
        if (!gp && L[i] == "if \"%~2\"==\"named\" goto :VB_PROBE") gp = i
      }
      if (!te) print "FAIL L5 no :VB_TRY_EXE"
      else if (!wa) print "FAIL L5 :VB_TRY_EXE does not skip \\WindowsApps\\"
      else {
        if (!ex || ex < wa) print "FAIL L5 the exist test is missing or comes before the WindowsApps skip"
        if (!pr || pr < wa) print "FAIL L5 the probe is missing or comes before the WindowsApps skip"
        if (!sp || sp < pr) print "FAIL L5 VB_PY is set before the probe (or never)"
        if (!gp || gp > wa) print "FAIL L5 the named skip is missing or comes after the WindowsApps line"
      }
      if (named != 1) print "FAIL L5 " named+0 " call(s) pass named; only the VIBROBEAST_PYTHON one may"
      # L6
      py = 0; for (i = 1; i <= NR; i++) if (index(L[i], "py -3 -c \"import sys; print(sys.executable if sys.version_info >= (3, 10) else \x27\x27)\"")) py = 1
      if (!py) print "FAIL L6 the py -3 capture does not ask for 3.10 or newer"
      if (!pr) print "FAIL L6 the probe does not ask for 3.10 or newer"
      # L10 too old said plainly: an older Python that runs is remembered (exit 3 only), and the
      # last words then say "too old", 3.10, what to install, restart Claude -- never re-mint/JSON
      ol = to = 0
      for (i = 1; i <= NR; i++) {
        if (L[i] == "if \"%errorlevel%\"==\"3\" set \"VB_OLD=%VB_CAND%\"") ol = 1
        if (L[i] ~ /^>&2 echo .*too old.*Python 3\.10 or newer.*python\.org.*restart Claude/) to = i
        if (L[i] ~ /^>&2 echo / && tolower(L[i]) ~ /re-mint|remint|json|edit the/) print "FAIL L10 line " i " asks the person to re-mint or edit: " L[i]
      }
      if (!ol) print "FAIL L10 an older Python that runs is not remembered in VB_OLD"
      if (!to) print "FAIL L10 no too-old sentence (too old, 3.10, python.org, restart Claude)"
      else if (L[to+1] != "exit /b 1") print "FAIL L10 the too-old sentence is not followed by exit /b 1"
      # L7 run line and VB_HERE
      if (runline <= 0 || rl != "\"%VB_PY%\" -B \"%VB_HERE%launch.py\" \"%~1\"") print "FAIL L7 the run line is not exactly \"%VB_PY%\" -B \"%VB_HERE%launch.py\" \"%~1\" (got: " rl ")"
      h = 0; for (i = 1; i <= NR; i++) if (L[i] == "set \"VB_HERE=%~dp0\"") h = 1
      if (!h) print "FAIL L7 VB_HERE is not set from %~dp0 in a quoted set"
      for (t in want) if (!(t in lab)) print "FAIL L8 line " want[t] " goes to :" t ", which is not a label"
      if (!(cb && ct && cf)) print "FAIL L9 the credit to Bryant Frankford (Tavern-Setup, :TVL_FIND/:TVL_TRY) is missing"
      if (!cc) print "FAIL L9 the copyright line does not name Bryant Frankford first, then Corwin Brust"
    }' "$T/lf"
}

# plant FILE NAME RULE -- edit a copy in place (CRLF kept unless the plant is about it)
plant() {
  c=$T/plant.cmd; cp "$SRC" "$c"
  case $2 in
    order)    LC_ALL=C awk 'BEGIN{ORS="\n"} /^if defined VIBROBEAST_PYTHON call/ {held=$0; next} {print} /^call :VB_TRY_PYLAUNCHER\r?$/ && held {print held; held=""}' "$c" > "$c.x" ;;
    winapps)  LC_ALL=C grep -v 'WindowsApps\\=' "$c" > "$c.x" ;;
    lf)       tr -d '\015' < "$c" > "$c.x" ;;
    ascii)    LC_ALL=C awk 'NR==2 {sub(/start one/, "start \303\266ne")} {print}' "$c" > "$c.x" ;;
    unquoted) LC_ALL=C sed 's/^"%VB_PY%" -B/%VB_PY% -B/' "$c" > "$c.x" ;;
    stdout)   LC_ALL=C sed 's/^>&2 echo vibrobeast: starting/echo vibrobeast: starting/' "$c" > "$c.x" ;;
    star)     LC_ALL=C sed 's/launch\.py" "%~1"/launch.py" %*/' "$c" > "$c.x" ;;
    label)    LC_ALL=C sed 's/^call :VB_TRY_PYLAUNCHER/call :VB_TRY_PYLAUNCH/' "$c" > "$c.x" ;;
    floor)    LC_ALL=C sed 's/version_info >= (3, 10) else 3)/version_info >= (3, 8) else 3)/' "$c" > "$c.x" ;;
    copyr)    LC_ALL=C sed 's/^rem Copyright 2026 Bryant Frankford <nathanielfrankford@gmail.com> and /rem Copyright 2026 /' "$c" > "$c.x" ;;
    oldmsg)   LC_ALL=C sed '/too old/s/ then restart Claude\./ then re-mint the plugin with it./' "$c" > "$c.x" ;;
  esac
  mv "$c.x" "$c"
  cmp -s "$c" "$SRC" && { echo "KIT BROKEN: the $2 plant changed nothing"; return 2; }
  out=$(text "$c")
  if printf '%s\n' "$out" | grep -q "^FAIL $3 "; then echo "ok   red: $2 is caught by $3"; return 0; fi
  echo "MISSED $2 (expected $3): ${out:-the checks stayed green}"; return 1
}

# twin MAKEFILE -> 0 when its dist recipe mints dist/posix (launch python) beside a cmd mint (M5)
twin() {
  awk '/^dist:/ {d=1; next} d && /^[^\t#]/ {d=0} d && /grep -q .*"command": "cmd".* dist\/vibrobeast\/\.mcp\.json/ {g=1}
       d && g && /--launch python --out dist\/posix/ {ok=1} END {exit !ok}' "$1"
}

if [ $MODE = red ]; then
  grep -v -e '--out dist/posix' "$here/Makefile" > "$T/Makefile.plant"
  cmp -s "$T/Makefile.plant" "$here/Makefile" && { echo "KIT BROKEN: the posix-twin plant changed nothing"; exit 2; }
  if twin "$T/Makefile.plant"; then echo "MISSED the posix twin removed from make dist (expected M5)"; exit 1; fi
  echo "ok   red: the posix twin removed from make dist is caught by M5"
  miss=0; total=0
  for p in "order L4" "winapps L5" "lf L2" "ascii L1" "unquoted L7" "stdout L3" "star L7" "label L8" "floor L6" "oldmsg L10" "copyr L9"; do
    set -- $p; total=$((total+1))
    plant "$SRC" "$1" "$2"; rc=$?
    [ $rc = 2 ] && exit 2
    [ $rc = 0 ] || miss=$((miss+1))
  done
  [ $miss = 0 ] && { echo "PASS: --prove-red, every planted fault went red ($total of $total)"; exit 0; }
  echo "FAIL: --prove-red, $miss of $total plants stayed green"; exit 1
fi

red=0
out=$(text "$SRC")
if [ -z "$out" ]; then echo "PASS L1-L10 polygram/launch.cmd: ASCII, CRLF, quiet, the order, never the Store stub, 3.10+, quoting, labels, credit, too old said plainly"
else printf '%s\n' "$out"; red=1; fi

command -v "$PY" >/dev/null 2>&1 || { echo "KIT BROKEN: no $PY for the mint checks"; exit 2; }
# M1 + M2: the JSON shape and validate(), from the Python that writes them
(cd "$here" && "$PY" - "$T" > "$T/m.json" 2> "$T/m.err") <<'PY'
import json, sys
from pathlib import Path
from polygram import plugin
t = Path(sys.argv[1])
print(json.dumps(plugin._mcp_json("python3", list(plugin.SERVERS), launch="cmd"), indent=2))
# M2: a fake tree with /s, then one with LF endings: validate must refuse both
root = t / "v"; (root / ".claude-plugin").mkdir(parents=True); (root / "servers").mkdir()
(root / ".claude-plugin" / "plugin.json").write_text(json.dumps({"name": "x", "mcpServers": "./.mcp.json"}))
src = Path("polygram/launch.cmd").read_bytes()
def v(args, data):
    (root / ".mcp.json").write_text(json.dumps({"mcpServers": {"m": {"command": "cmd", "args": args}}}))
    (root / "servers" / "launch.cmd").write_bytes(data)
    return plugin.validate(root)
good = ["/d", "/c", "${CLAUDE_PLUGIN_ROOT}\\servers\\launch.cmd", "m"]
sys.stderr.write("M2good %d\n" % len(v(good, src)))
sys.stderr.write("M2slash-s %d\n" % sum("/s" in p for p in v(["/d", "/s", "/c", good[2], "m"], src)))
sys.stderr.write("M2lf %d\n" % sum("CRLF" in p for p in v(good, src.replace(b"\r\n", b"\n"))))
PY
[ -s "$T/m.json" ] || { echo "KIT BROKEN: the mint's JSON could not be produced: $(tail -3 "$T/m.err")"; exit 2; }
m1=$(awk '
  /^    "[a-z0-9]+": \{$/ { n++; s=$1; gsub(/[":{]/, "", s); i=0; next }
  /"command": / { if ($0 !~ /"command": "cmd",$/) bad = bad " " s ":command" }
  /^        "/ { i++; a=$0; sub(/^ +/, "", a); sub(/,$/, "", a)
                 if (i==1 && a != "\"/d\"") bad = bad " " s ":arg1"
                 if (i==2 && a != "\"/c\"") bad = bad " " s ":arg2"
                 if (i==3 && a != "\"${CLAUDE_PLUGIN_ROOT}\\\\servers\\\\launch.cmd\"") bad = bad " " s ":arg3"
                 if (i==4 && a != "\"" s "\"") bad = bad " " s ":arg4"
                 if (i>4) bad = bad " " s ":extra" }
  /"\/s"/ { bad = bad " /s" }
  END { if (n < 6) bad = bad " only-" n "-servers"; print bad }' "$T/m.json")
[ -z "$m1" ] && echo "PASS M1 every server: cmd /d /c \${CLAUDE_PLUGIN_ROOT}\\servers\\launch.cmd NAME, no /s" || { echo "FAIL M1$m1"; red=1; }
grep -q '^M2good 0$' "$T/m.err" && grep -q '^M2slash-s [1-9]' "$T/m.err" && grep -q '^M2lf [1-9]' "$T/m.err" \
  && echo "PASS M2 validate() passes the good shape and refuses /s and LF endings" || { echo "FAIL M2 $(tr '\n' ' ' < "$T/m.err")"; red=1; }

if [ $MINT = 1 ]; then
  # M3 + M4: a real mint, launch cmd, plus the default one
  (cd "$here" && "$PY" - "$T" > "$T/mint.out" 2>&1) <<'PY'
import sys
from pathlib import Path
from polygram import dist, plugin
t = Path(sys.argv[1]) / "d"; t.mkdir()
sk = dist.collect(Path("skills"), include_workspace=True)
a = plugin.mint_plugin(t, sk, source_root=Path("."), name="vbcmd", launch="cmd")
b = plugin.mint_plugin(t, sk, source_root=Path("."), name="vbdef")
print("M3 launch=%s problems=%d validate=%d" % (a.launch, len(a.problems), len(plugin.validate(a.root))))
print("M3 default=%s" % b.launch)
PY
  if grep -q '^M3 launch=cmd problems=0 validate=0$' "$T/mint.out" && grep -q '^M3 default=python$' "$T/mint.out" \
     && cmp -s "$T/d/vbcmd/servers/launch.cmd" "$SRC" && grep -q '"command": "python3"' "$T/d/vbdef/.mcp.json"; then
    echo "PASS M3 a cmd mint ships launch.cmd byte for byte and validates; the default mint here is the python shape"
  else echo "FAIL M3 $(tr '\n' ' ' < "$T/mint.out")"; red=1; fi
  ci=$(cd "$T/d/vbcmd" && sh check-interpreter.sh 2>&1); rc=$?
  if command -v cmd.exe >/dev/null 2>&1; then
    [ $rc = 0 ] && echo "PASS M4 check-interpreter.sh ran the finder through cmd.exe here" || { echo "FAIL M4 rc=$rc $ci"; red=1; }
  else
    [ $rc = 2 ] && printf '%s' "$ci" | grep -q '^NOT CHECKED' && echo "PASS M4 check-interpreter.sh says NOT CHECKED (exit 2): no cmd.exe on this host" || { echo "FAIL M4 rc=$rc $ci"; red=1; }
  fi
  [ -z "$(find "$T/d" -name __pycache__ 2>/dev/null)" ] || { echo "FAIL M3 the mint left __pycache__"; red=1; }
  # M5 (QA1 row 15): a cmd mint says it is Windows-only where an installer reads, before the log does
  m5=""
  grep -q '"description": ".*Windows build: its servers start through cmd.exe.*dist/posix/vibrobeast.plugin' "$T/d/vbcmd/.claude-plugin/plugin.json" || m5="$m5 cmd-plugin.json"
  grep -q '^\*\*Made for Windows only\.\*\*' "$T/d/vbcmd/README.md" || m5="$m5 cmd-README"
  grep -q 'Windows build' "$T/d/vbdef/.claude-plugin/plugin.json" && m5="$m5 python-plugin.json-says-windows"
  grep -q 'Made for Windows only' "$T/d/vbdef/README.md" && m5="$m5 python-README-says-windows"
  # ... and make dist mints the other shape beside a Windows one (Makefile, read as text)
  twin "$here/Makefile" || m5="$m5 makefile-no-posix-twin"
  [ -z "$m5" ] && echo "PASS M5 a cmd mint says Windows-only (plugin.json, README); a python mint does not; make dist mints dist/posix beside it" || { echo "FAIL M5$m5"; red=1; }
else
  echo "SKIP M3 M4 M5 (--no-mint)"
fi
echo "NOT TESTED HERE: launch.cmd running under a real cmd.exe (see CARD-giza-launch.md)"
[ $red = 0 ] && { echo "launch-cmd-tests: GREEN"; exit 0; }
echo "launch-cmd-tests: RED"; exit 1
