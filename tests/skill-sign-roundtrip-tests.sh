#!/bin/sh
# skill-sign-roundtrip-tests.sh -- receive-and-verify, end to end: sign -> bundle -> unbundle ->
#   verify must pass with the tool's own helpers riding along, and any change to what was signed
#   must go red.  | --prove-red
# Copyright (C) 2026 Corwin Brust <corwin@bru.st>. Authored by Mentat (for Corwin).
# This program is free software: you can redistribute it and/or modify it under the terms of the
# GNU General Public License as published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.  SPDX-License-Identifier: GPL-3.0-or-later
#
# Why (audit N1, 2026-09-27): no shipped .skill passed unbundle + verify -- bundle adds check.sh and
# SAYS-SO after the manifest is signed, and verify counted them as a changed tree. Throwaway key in a
# scratch GNUPGHOME; never Corwin's key, never this garden's files (reads only the tool).
# usage: sh tests/skill-sign-roundtrip-tests.sh [--prove-red]
#   SKILL_SIGN_SH=path  run against another copy of skill-sign.sh (how a mutant is tried)
#   --prove-red         expects the two tamper legs (one flipped byte, one planted file) to verify
#                       GREEN, and passes only if exactly those two report FAIL.
set -u
root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
SIGN=${SKILL_SIGN_SH:-$root/skills/skill-sign/scripts/skill-sign.sh}
for b in gpg zip unzip; do command -v "$b" >/dev/null 2>&1 || { echo "SKIP: no $b"; exit 77; }; done
[ -f "$SIGN" ] || { echo "FAIL: no skill-sign.sh at $SIGN"; exit 1; }
t=$(mktemp -d 2>/dev/null) || { t=${TMPDIR:-/tmp}/ssrt.$$; mkdir -p "$t"; }
trap 'rm -rf "$t"' EXIT INT TERM
pass=0; fail=0
ok()  { pass=$((pass+1)); echo "ok   $1"; }
bad() { fail=$((fail+1)); echo "FAIL $1 -- $2"; }
red=0; [ "${1:-}" = --prove-red ] && red=1
tamper_rc=1; [ $red = 1 ] && tamper_rc=0     # planted wrong expectation: tampering "verifies"

GNUPGHOME="$t/g"; mkdir -m 700 "$GNUPGHOME"; export GNUPGHOME
gpg --batch --passphrase '' --quick-gen-key 'roundtrip throwaway <rt@example.invalid>' default default never >/dev/null 2>&1 \
  || { echo 'FAIL: throwaway key generation'; exit 1; }
PUB_SIGN_KEY=$(gpg --batch --list-secret-keys --with-colons 2>/dev/null | awk -F: '$1=="fpr"{print $10; exit}'); export PUB_SIGN_KEY

# The secrets checker: the real one when this host has C4, else none, passed on the record.
SB1RN=''; for c in "${C4_ROOT:-}" /f/claude/c4 "$HOME/mnt/c4"; do
  [ -n "$c" ] && [ -f "$c/bin/sb1rn" ] && { SB1RN=$c/bin/sb1rn; break; }; done
export SB1RN
[ -n "$SB1RN" ] || { export SKILL_SIGN_ACCEPT_SECRET='roundtrip test: no sb1rn on this host'; echo "# no sb1rn here: bundling on the record"; }

mk() { # mk DIR NAME -- a lint-clean skill with a script, a data file and an .arc/ that must not travel
  mkdir -p "$1/scripts" "$1/data" "$1/.arc/2026-09"
  printf -- '---\nname: %s\ndescription: >-\n  A small skill used only to test signing. Use it when a test needs a signable skill with a\n  valid description and nothing else.\n---\n# %s\n\nBody.\n' "$2" "$2" > "$1/SKILL.md"
  printf 'echo hi\n' > "$1/scripts/tool.sh"; printf 'data\n' > "$1/data/x.txt"; printf 'history\n' > "$1/.arc/2026-09/old"
}
# rt SRC_DIR NAME -- sign, bundle, unbundle into $t/in/NAME; sets $U (the unbundled dir)
rt() {
  o=$(sh "$SIGN" sign "$1" 2>&1) || { bad "sign $2" "$o"; return 1; }
  mkdir -p "$t/out" "$t/in"
  o=$(cd "$t/out" && sh "$SIGN" bundle "$1" 2>&1) || { bad "bundle $2" "$o"; return 1; }
  rm -rf "$t/in/$2"
  o=$(cd "$t/in" && sh "$SIGN" unbundle "$t/out/$2.skill" 2>&1) || { bad "unbundle $2" "$o"; return 1; }
  U=$t/in/$2
}
v() { o=$(sh "$SIGN" verify "$1" 2>&1); rc=$?; }

# 1. the round trip itself
mk "$t/src/rt-skill" rt-skill
if rt "$t/src/rt-skill" rt-skill; then
  v "$U"
  [ $rc -eq 0 ] && echo "$o" | grep -q 'signature valid' && ok "bundle -> unbundle -> verify: signature valid" || bad roundtrip "rc=$rc $o"
  echo "$o" | grep -q 'helper (not covered by the signature): check.sh -- same bytes' && echo "$o" | grep -q 'helper (not covered by the signature): SAYS-SO -- same bytes' \
    && ok "...the helpers bundle added are reported apart, as not signed" || bad helpers "$o"
  [ -f "$U/check.sh" ] && [ ! -e "$U/.arc" ] && ok "...check.sh rode along; .arc/ did not" || bad contents "$(ls -a "$U")"
  o=$(cd "$U" && sh check.sh 2>&1); rc=$?
  [ $rc -eq 0 ] && ok "...check.sh inside the unpacked bundle agrees (no gpg)" || bad checksh "rc=$rc $o"

  # 2. tamper legs, each on a fresh copy
  cp -Rp "$U" "$t/flip"; printf 'X' >> "$t/flip/scripts/tool.sh"; v "$t/flip"
  [ $rc -eq $tamper_rc ] && ok "one byte added to a signed file: verify rc=$tamper_rc" || bad "flipped byte (want rc=$tamper_rc)" "rc=$rc $o"
  cp -Rp "$U" "$t/extra"; printf 'echo planted\n' > "$t/extra/scripts/extra.sh"; v "$t/extra"
  [ $rc -eq $tamper_rc ] && ok "a planted extra file: verify rc=$tamper_rc" || bad "planted file (want rc=$tamper_rc)" "rc=$rc $o"
  cp -Rp "$U" "$t/helper"; printf '# tampered\n' >> "$t/helper/check.sh"; v "$t/helper"
  [ $rc -eq 1 ] && echo "$o" | grep -q 'check.sh -- DIFFERS from the copy beside this verifier' && ok "a tampered helper check.sh: rc=1, DIFFERS, do not run it" || bad helpertamper "rc=$rc $o"
  cp -Rp "$U" "$t/extrahelper"; printf 'echo planted\n' > "$t/extrahelper/data/check.sh"; v "$t/extrahelper"
  [ $rc -eq 1 ] && echo "$o" | grep -q 'TREE CHANGED' && ok "a check.sh planted below the root is no helper: TREE CHANGED" || bad deephelper "rc=$rc $o"
fi

# 3. a skill that ships its OWN root check.sh: listed in the manifest, so covered like any file
mk "$t/src/own-check" own-check; printf 'echo mine\n' > "$t/src/own-check/check.sh"
if rt "$t/src/own-check" own-check; then
  v "$U"
  [ $rc -eq 0 ] && ! echo "$o" | grep -q 'helper (not covered by the signature): check.sh' && ok "a skill's own check.sh is signed, not a helper" || bad owncheck "rc=$rc $o"
  printf '# tampered\n' >> "$U/check.sh"; v "$U"
  [ $rc -eq 1 ] && echo "$o" | grep -q 'TREE CHANGED' && ok "...and tampering with it is TREE CHANGED" || bad owntamper "rc=$rc $o"
fi

if [ $red = 1 ]; then
  [ $fail -eq 2 ] && { echo "PASS: harness correctly went red on both tamper legs under a planted bad expectation"; exit 0; }
  echo "FAIL: harness did not go red on exactly the two tamper legs (fail=$fail)"; exit 1
fi
echo "TOTAL pass=$pass fail=$fail"; [ $fail -eq 0 ]
