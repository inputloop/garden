#!/bin/sh
# release-gates-tests.sh -- bin/release's gates, on a scratch repo (never this one). | --prove-red
# Copyright (C) 2026 Corwin Brust <corwin@bru.st>. Authored by Mentat (for Corwin).
# This program is free software: you can redistribute it and/or modify it under the terms of the
# GNU General Public License as published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.  SPDX-License-Identifier: GPL-3.0-or-later
# The order a real cut takes: make dist (which writes tracked files), THEN commit, THEN release.
# The old timestamp gate could never pass in that order; the content gate must.
set -u
here=$(cd "$(dirname "$0")/.." && pwd)
command -v git >/dev/null 2>&1 || { echo "SKIP: no git"; exit 0; }
t=$(mktemp -d 2>/dev/null) || { t=${TMPDIR:-/tmp}/relg.$$; mkdir -p "$t"; }
trap 'rm -rf "$t"' EXIT INT TERM
pass=0; fail=0
ok()  { pass=$((pass+1)); echo "ok   $1"; }
bad() { fail=$((fail+1)); echo "FAIL $1 -- $2"; }
R="$t/r"; V=1.2.3; top="polygram-curation-$V"
mkdir -p "$R/bin" "$R/polygram" "$R/tests" "$R/skills/a" "$R/dist"
cp "$here/bin/release" "$here/bin/gtmode" "$R/bin/"
printf '__version__ = "%s"\n' "$V" > "$R/polygram/__init__.py"
printf 'Version %s (2026-09-25)\n\n* a thing\n' "$V" > "$R/NEWS"
printf 'import unittest\nclass T(unittest.TestCase):\n    def test_ok(self):\n        pass\n' > "$R/tests/test_ok.py"
printf 'dist/\n__pycache__/\n' > "$R/.gitignore"
printf '# a skill\n' > "$R/skills/a/SKILL.md"
mint() {   # a hand-rolled mint: MANIFEST + both archives carrying it
  rm -rf "$t/stage"; mkdir -p "$t/stage/$top/skills/a"
  { printf '# polygram dist manifest\nname: %s\nversion: %s\n\n# sha256  origin  path\n' "$top" "$V"
    printf '%s  workspace  skills/a/SKILL.md\n' "$(sha256sum < "$R/skills/a/SKILL.md" | cut -d' ' -f1)"
    printf '%s  installed  skills/elsewhere/SKILL.md\n' "$(printf x | sha256sum | cut -d' ' -f1)"; } > "$R/dist/$top.MANIFEST"
  cp "$R/dist/$top.MANIFEST" "$t/stage/$top/MANIFEST"; cp "$R/skills/a/SKILL.md" "$t/stage/$top/skills/a/"
  ( cd "$t/stage" && tar -czf "$R/dist/$top.tar.gz" "$top" && python3 -c 'import sys,zipfile,os
z=zipfile.ZipFile(sys.argv[1],"w")
for d,_,fs in os.walk(sys.argv[2]):
    [z.write(os.path.join(d,f)) for f in fs]' "$R/dist/$top.zip" "$top" ); }
g() { git -C "$R" -c user.name=t -c user.email=t@t -c commit.gpgsign=false "$@" >/dev/null 2>&1; }
g init; mint; g add -A; g commit -m one      # the real order: mint first, then commit
o=$(cd "$R" && sh bin/release "$V" 2>&1); rc=$?
[ $rc -eq 0 ] && echo "$o" | grep -q 'artifacts built from this tree: 1 rows match' && echo "$o" | grep -q '1 rows from outside the repo' && ok "mint, then commit, then release: the gates pass (the timestamp gate never could)" || bad order "rc=$rc $o"
printf '# changed\n' >> "$R/skills/a/SKILL.md"; g commit -am two
o=$(cd "$R" && sh bin/release "$V" 2>&1); rc=$?
[ $rc -ne 0 ] && echo "$o" | grep -q 'built from a different tree than this one: skills/a/SKILL.md' && ok "a source changed after the mint: refused, naming the file" || bad stale "rc=$rc $o"
mint; cp "$R/dist/$top.tar.gz" "$t/keep.tgz"; printf '# changed again\n' >> "$R/skills/a/SKILL.md"; g commit -am three; mint; cp "$t/keep.tgz" "$R/dist/$top.tar.gz"
o=$(cd "$R" && sh bin/release "$V" 2>&1); rc=$?
[ $rc -ne 0 ] && echo "$o" | grep -q 'the tar.gz does not carry this MANIFEST' && ok "archives from two different mints: refused" || bad mixed "rc=$rc $o"
mint; sed -i "s/^version: $V\$/version: 9.9.9/" "$R/dist/$top.MANIFEST"
o=$(cd "$R" && sh bin/release "$V" 2>&1); rc=$?
[ $rc -ne 0 ] && echo "$o" | grep -q "MANIFEST is not for $V" && ok "a MANIFEST for another version: refused" || bad ver "rc=$rc $o"
mint; printf 'dirt\n' > "$R/untracked.txt"
o=$(cd "$R" && sh bin/release "$V" 2>&1); rc=$?
[ $rc -ne 0 ] && echo "$o" | grep -q 'work tree not clean' && ok "a dirty tree: refused first" || bad dirty "rc=$rc $o"
# red tests: refused with the failures NAMED and the log kept; --accept-red=WHY lets his choice through
rm -f "$R/untracked.txt"
printf 'import unittest\nclass R(unittest.TestCase):\n    def test_red(self):\n        self.fail("planted")\n' > "$R/tests/test_red.py"; g add -A; g commit -m red
o=$(cd "$R" && sh bin/release "$V" 2>&1); rc=$?
[ $rc -ne 0 ] && echo "$o" | grep -q 'FAIL: test_red' && echo "$o" | grep -q 'polygram-release-tests.log' && echo "$o" | grep -q -- '--accept-red' && [ -s "$R/.git/polygram-release-tests.log" ] && ok "red tests: refused, the failing test named, the full log kept, the way through offered" || bad red "rc=$rc $o"
o=$(cd "$R" && sh bin/release "$V" --accept-red="host quirk, read the log" 2>&1); rc=$?
[ $rc -eq 0 ] && echo "$o" | grep -q 'red accepted: host quirk' && ok "red tests + --accept-red=WHY: goes on, saying so" || bad accred "rc=$rc $o"
o=$(cd "$R" && sh bin/release "$V" --accept-red 2>&1); rc=$?
[ $rc -ne 0 ] && echo "$o" | grep -q 'needs a reason' && ok "--accept-red with no reason: refused (the choice goes on the record)" || bad accnoreason "rc=$rc $o"
g rm -q tests/test_red.py; g commit -m unred
# --apply then --push: the second run must RESUME at publish, never die on "tag exists"
if command -v gpg >/dev/null 2>&1; then
  export GNUPGHOME="$t/gnupg"; mkdir -p "$GNUPGHOME"; chmod 700 "$GNUPGHOME"
  gpg --batch --passphrase '' --quick-gen-key 'Test <t@t>' default default never >/dev/null 2>&1
  rm -f "$R/untracked.txt"; mint; g add -A; g commit -m four
  for f in "$R/dist/$top.tar.gz" "$R/dist/$top.zip" "$R/dist/$top.MANIFEST"; do gpg --batch --armor --detach-sign --output "$f.asc" "$f" >/dev/null 2>&1; done
  g tag -a "v$V" -m t
  o=$(cd "$R" && FORGEJO_TOKEN= sh bin/release "$V" --push 2>&1); rc=$?
  echo "$o" | grep -q 'exists and all three signatures verify -- resuming at publish' && echo "$o" | grep -q 'tag push failed (git push upstream' && ok "--push after --apply resumes at publish, over SSH with no token (it stops only at the push here: the scratch repo has no remote)" || bad resume "rc=$rc $o"
  git init -q --bare "$t/up.git"; g remote add upstream "$t/up.git"
  o=$(cd "$R" && sh bin/release "$V" --push 2>&1); rc=$?
  [ $rc -eq 0 ] && echo "$o" | grep -q 'pushed over SSH' && git -C "$t/up.git" rev-parse -q --verify "refs/tags/v$V" >/dev/null && ! echo "$o" | grep -qi 'token not set' && ok "no token, a reachable upstream: the signed tag is pushed and that IS the release; nothing asks for a token" || bad sshpush "rc=$rc $o"
  # token set, the release-page API unreachable: the tag is up, so it is a published release with a warning
  o=$(cd "$R" && FORGEJO_TOKEN=x FORGEJO_API=http://127.0.0.1:9/api sh bin/release "$V" --push 2>&1); rc=$?
  [ $rc -eq 0 ] && echo "$o" | grep -q 'published: signed tag' && echo "$o" | grep -q 'release page was not made' && echo "$o" | grep -q 'Retry just the page' && ok "token set, release page fails after the tag is up: reported as published + page not made, with the retry line" || bad pagefail "rc=$rc $o"
  gpg --batch --yes --armor --detach-sign --output "$R/dist/$top.MANIFEST.asc" "$R/NEWS" >/dev/null 2>&1   # a signature over the wrong file
  o=$(cd "$R" && sh bin/release "$V" --push 2>&1); rc=$?
  [ $rc -ne 0 ] && echo "$o" | grep -q 'resumes only when all three .asc verify' && ok "...but a signature that no longer verifies is refused" || bad badsig "rc=$rc $o"
  # the reason lands in the tag message
  g tag -d "v$V"; gpg --batch --yes --armor --detach-sign --output "$R/dist/$top.MANIFEST.asc" "$R/dist/$top.MANIFEST" >/dev/null 2>&1
  printf 'import unittest\nclass R(unittest.TestCase):\n    def test_red(self):\n        self.fail("planted")\n' > "$R/tests/test_red.py"; g add -A; g commit -m red2
  fpr=$(gpg --list-secret-keys --with-colons 2>/dev/null | awk -F: '/^fpr/{print $10; exit}')
  o=$(cd "$R" && GIT_COMMITTER_NAME=t GIT_COMMITTER_EMAIL=t@t RELEASE_PIN=$fpr sh bin/release "$V" --apply --no-sign-tag --accept-red="windows only, see log" 2>&1); rc=$?
  m=$(git -C "$R" tag -l -n99 "v$V")
  [ $rc -eq 0 ] && echo "$m" | grep -q "keeper's choice: windows only, see log" && echo "$m" | grep -q 'test_red' && ok "--accept-red: the reason and the failing test are in the tag message" || bad redtag "rc=$rc $o // $m"
  # 2026-09-26 honest boundaries: a secret passed on the record lands in the tag message, beside its hits
  g tag -d "v$V"; g rm -q tests/test_red.py
  printf "# settings\nGH = '%s_%s'\n" ghp aB3dE5fG7hJ9kL1mN3pQ5rS7tU9vW1xY3zA5bC > "$R/polygram/cfg.py"; g add -A; g commit -m sec
  o=$(cd "$R" && GIT_COMMITTER_NAME=t GIT_COMMITTER_EMAIL=t@t RELEASE_PIN=$fpr sh bin/release "$V" --apply --no-sign-tag --accept-secret="a public test fixture" 2>&1); rc=$?
  m=$(git -C "$R" tag -l -n99 "v$V")
  [ $rc -eq 0 ] && echo "$m" | grep -q "secret-shaped text, by the keeper's choice: a public test fixture" && echo "$m" | grep -q 'HIT polygram/cfg.py:2 github-token' && ! echo "$m" | grep -q 'aB3dE5fG7hJ9kL1mN3pQ5' && ok "--accept-secret: the reason and the hit (never the secret) are in the tag message" || bad sectag "rc=$rc $o // $m"
else echo "SKIP: no gpg for the resume cases"; fi
if [ "${1:-}" = --prove-red ]; then
  before=$fail; [ -f "$R/dist/never-minted.MANIFEST" ] && ok PLANTED || bad "PLANTED (must FAIL)" x >/dev/null
  [ $fail -gt $before ] && { echo "PASS: harness correctly went red under a planted bad expectation"; exit 0; }
  echo "FAIL: harness could not go red"; exit 1
fi
echo "TOTAL pass=$pass fail=$fail"; [ $fail -eq 0 ]
