#!/bin/sh
# gtmode-tests - with FORGEJO_TOKEN set, git goes HTTPS-with-token and never runs SSH; without it,
# SSH as configured.  A local HTTP stand-in (python3, stdlib) records what git actually sends.
# Copyright (C) 2026 Corwin.  SPDX-License-Identifier: GPL-3.0-or-later
# usage: sh tests/gtmode-tests.sh [--prove-red]
set -u
here=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
d=${TMPDIR:-/tmp}/gtmode-t.$$; mkdir -p "$d"; trap 'kill $srv 2>/dev/null; rm -rf "$d"' EXIT
pass=0 fail=0
ok()  { pass=$((pass+1)); printf 'ok   %s\n' "$1"; }
bad() { fail=$((fail+1)); printf 'FAIL %s\n' "$1"; }
has() { case $1 in *"$2"*) true;; *) false;; esac; }
check() { if (eval "$2") 2>/dev/null; then ok "$1"; else bad "$1"; fi; }

cat > "$d/srv.py" <<'PY'
import http.server, sys
log = open(sys.argv[2], 'a')
class H(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        log.write('%s %s\n' % (self.path, self.headers.get('Authorization', '-'))); log.flush()
        self.send_response(401); self.send_header('WWW-Authenticate', 'Basic realm=x'); self.end_headers()
    def log_message(self, *a): pass
http.server.HTTPServer(('127.0.0.1', int(sys.argv[1])), H).serve_forever()
PY
port=$((20000 + $$ % 20000)); : > "$d/req.log"
python3 "$d/srv.py" "$port" "$d/req.log" & srv=$!; sleep 1

# a fake ssh that records that it was called
printf '#!/bin/sh\necho called >> %s/ssh.log\nexit 1\n' "$d" > "$d/fakessh"; chmod +x "$d/fakessh"
git init -q "$d/r"; git -C "$d/r" remote add upstream "ssh://forgejo@127.0.0.1:$port/corwin/as4ce"
git init -q "$d/s"; git -C "$d/s" remote add upstream "forgejo@127.0.0.1:corwin/as4ce"

run() {  # $1 dir, $2 token ('' = unset); prints GT_MODE|GT_URL|probe
  ( cd "$1" && if [ -n "$2" ]; then FORGEJO_TOKEN=$2; export FORGEJO_TOKEN; else unset FORGEJO_TOKEN; fi
    GIT_SSH_COMMAND=$d/fakessh; export GIT_SSH_COMMAND; GT_BASE=http://127.0.0.1:$port/
    . "$here/bin/gtmode"; printf '%s|%s|%s\n' "$GT_MODE" "$GT_URL" "$(gt_probe)" )
}
tokenrun() { : > "$d/ssh.log"; : > "$d/req.log"; run "$1" "$2"; }

out=$(tokenrun "$d/r" sekrit)
check 'token set: mode is TOKEN'                      "case '$out' in TOKEN*) true;; *) false;; esac"
check 'token set: ssh:// rewritten to http(s)://host/path' 'has "$out" "|http://127.0.0.1:$port/corwin/as4ce|"'
check 'token set: SSH never ran'                      "[ ! -s '$d/ssh.log' ]"
want=$(printf 'corwin:sekrit' | base64)
check 'token set: git sent Basic corwin:<token>'      "grep -q 'Basic $want' '$d/req.log'"
check 'token set: probe says no (stand-in refuses), not a hang' "case '$out' in *'|no:'*) true;; *) false;; esac"
check 'token never lands in git config'              "! git -C '$d/r' config --list | grep -q sekrit"

out=$(tokenrun "$d/s" sekrit)
check 'token set, scp-form URL: rewritten too' 'has "$out" "TOKEN|http://127.0.0.1:$port/corwin/as4ce|"'
check 'token set, scp-form URL: SSH never ran'        "[ ! -s '$d/ssh.log' ]"

# nested: the card sources gtmode, then bin/release sources it again in a child sh
: > "$d/ssh.log"; : > "$d/req.log"
nest=$( cd "$d/r"; FORGEJO_TOKEN=sekrit; export FORGEJO_TOKEN GIT_SSH_COMMAND=$d/fakessh GT_BASE=http://127.0.0.1:$port/
        . "$here/bin/gtmode"; sh -c ". '$here/bin/gtmode'; echo \$GT_MODE; git ls-remote upstream HEAD >/dev/null 2>&1; true" )
check 'sourced twice (card, then bin/release): still TOKEN' '[ "$nest" = TOKEN ]'
check 'sourced twice: SSH never ran'                  "[ ! -s '$d/ssh.log' ]"
check 'sourced twice: the request still reached HTTP' "[ -s '$d/req.log' ]"

out=$(tokenrun "$d/r" '')
check 'no token: mode is SSH'                         "case '$out' in SSH*) true;; *) false;; esac"
check 'no token: nothing reached HTTP'                "[ ! -s '$d/req.log' ]"
check 'no token: the check used YOUR ssh command, not a stricter one' "grep -q called '$d/ssh.log'"
check 'no token: a failed check says why (not a bare no)' 'has "$out" "|no: "'
: > "$d/ssh.log"
out=$( cd "$d/r"; unset FORGEJO_TOKEN GIT_SSH_COMMAND; git config core.sshCommand "$d/fakessh"
       . "$here/bin/gtmode"; gt_probe; git config --unset core.sshCommand )
check 'no token: core.sshCommand is honoured too'   "grep -q called '$d/ssh.log'"   # sb:allow -- a test label ('no token:'), not a token
check 'no token: the check never adds BatchMode'     "! grep -v '^ *#' '$here/bin/gtmode' | grep -q BatchMode"

if [ "${1:-}" = --prove-red ]; then   # plant: a gtmode that forgets to switch SSH off must go red
  sed 's/GIT_SSH_COMMAND=false //; s/export GIT_CONFIG_COUNT=[^ ]*/export GIT_CONFIG_COUNT=0/' "$here/bin/gtmode" > "$d/gtmode.bad2"
  : > "$d/ssh.log"
  ( cd "$d/r"; FORGEJO_TOKEN=x; export FORGEJO_TOKEN; GIT_SSH_COMMAND=$d/fakessh; export GIT_SSH_COMMAND
    . "$d/gtmode.bad2"; git ls-remote upstream HEAD >/dev/null 2>&1 )
  if [ -s "$d/ssh.log" ]; then ok 'prove-red: a gtmode that leaves SSH on IS caught by the SSH-never-ran check'
  else bad 'prove-red: the planted fault did not reach SSH, so that check cannot fail'; fi
  # plant 2: the pre-fix gtmode (no GT_ACTIVE guard) loses the rewrite when sourced twice
  sed 's/if \[ "${GT_ACTIVE:-}" = 1 \]; then :; else/if false; then :; else/; s/GIT_CONFIG_COUNT=0 git/git/' \
    "$here/bin/gtmode" > "$d/gtmode.old"; : > "$d/req.log"
  ( cd "$d/r"; FORGEJO_TOKEN=sekrit; export FORGEJO_TOKEN GT_BASE=http://127.0.0.1:$port/
    . "$d/gtmode.old"; sh -c ". '$d/gtmode.old'; git ls-remote upstream HEAD >/dev/null 2>&1; true" )
  if [ ! -s "$d/req.log" ]; then ok 'prove-red: the pre-fix double-source IS caught by the reached-HTTP check'
  else bad 'prove-red: the pre-fix double-source still reached HTTP, so that check cannot fail'; fi
fi
printf 'TOTAL pass=%d fail=%d\n' "$pass" "$fail"; [ "$fail" -eq 0 ]
