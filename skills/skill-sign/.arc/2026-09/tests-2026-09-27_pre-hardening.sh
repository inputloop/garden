#!/bin/sh
# tests.sh --- fixtures + expected verdicts for skill-sign.sh's tiered
# `verify` (2026-09-04) and its check.sh companion.
#
# Self-contained (prove-a-promise: opens itself, ships what it needs,
# proves itself): generates its own throwaway gpg key in a scratch
# GNUPGHOME, so tier-2 is exercised for real without touching Corwin's
# actual key or keyring. Nothing here reads or writes outside $tmp.
#
# usage:
#   sh tests.sh              run the fixture suite; exit 0 iff all pass
#   sh tests.sh --prove-red  plant a deliberately wrong expectation and
#                            confirm THIS suite reports it as a failure
#                            (prove-red-discipline: a green suite that
#                            can't go red is indistinguishable from one
#                            that isn't running)
#
# Copyright (C) 2026 Corwin <mplscorwin@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later

set -eu

here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SIGN="$here/skill-sign.sh"
CHECK="$here/check.sh"

# --prove-red: plant ONE deliberately wrong expectation (a rc this fixture
# can never actually produce) and confirm the suite reports it. Mirrors
# check.sh's own --prove-red one level up: proves THIS harness, not just
# the tool it tests, can go red.
prove_red=0
[ "${1:-}" = '--prove-red' ] && prove_red=1
nomanifest_want_rc=1
[ "$prove_red" = 1 ] && nomanifest_want_rc=99   # impossible -- forces a FAIL

pass=0
fail=0

# report NAME EXPECTED_RC ACTUAL_RC NEEDLE ACTUAL_OUTPUT
#   EXPECTED_RC may be a number, or "any" to skip the rc check.
#   NEEDLE may be empty to skip the substring check.
report() {
    name=$1; erc=$2; arc=$3; needle=$4; out=$5
    ok=1
    if [ "$erc" != any ] && [ "$arc" != "$erc" ]; then ok=0; fi
    if [ -n "$needle" ] && ! printf '%s' "$out" | grep -qF -- "$needle"; then
        ok=0
    fi
    if [ "$ok" = 1 ]; then
        pass=$((pass + 1))
        printf 'ok   %s\n' "$name"
    else
        fail=$((fail + 1))
        printf 'FAIL %s (rc=%s want=%s, looked for: %s)\n' \
            "$name" "$arc" "$erc" "$needle" >&2
        printf '     --- output ---\n%s\n     --------------\n' "$out" >&2
    fi
}

# _skill NAME -- makes $tmp/NAME with a SKILL.md + tool.sh, prints the path
_skill() {
    d="$tmp/$1"; mkdir -p "$d"
    printf -- '---\nname: %s\n---\n# %s\n' "$1" "$1" > "$d/SKILL.md"
    printf 'echo hi\n' > "$d/tool.sh"
    printf '%s' "$d"
}

# _verify DIR KEY -- verify DIR pinned against KEY; sets $RC and $OUT
_verify() {
    if OUT=$(PUB_SIGN_KEY="$2" sh "$SIGN" verify "$1" 2>&1); then RC=0
    else RC=$?; fi
}

tmp=$(mktemp -d) || { echo 'tests.sh: mktemp failed' >&2; exit 1; }
trap 'rm -rf "$tmp"' EXIT
GNUPGHOME="$tmp/gpghome"; mkdir -m 700 "$GNUPGHOME"; export GNUPGHOME

echo '# generating a throwaway signer key (never Corwin''s) ...'
gpg --batch --passphrase '' --quick-gen-key \
    'tests.sh throwaway <throwaway@example.invalid>' default default 0 \
    >"$tmp/genkey.log" 2>&1 \
  || { cat "$tmp/genkey.log" >&2; echo 'tests.sh: gpg key generation failed' >&2; exit 1; }
KEYID=$(gpg --batch --list-secret-keys --with-colons \
  | awk -F: '$1=="fpr"{print $10; exit}')
[ -n "$KEYID" ] || { echo 'tests.sh: could not read generated fingerprint' >&2; exit 1; }
echo "# throwaway key: $KEYID"
echo

# ---- fixture: no manifest at all -----------------------------------
d=$(_skill nomanifest)
_verify "$d" "$KEYID"
report 'no-manifest -> unsigned, cannot hash-check (rc=1)' \
    "$nomanifest_want_rc" "$RC" 'cannot even hash-check' "$OUT"

# ---- fixture: manifest present, no signature (TIER 1) ---------------
d=$(_skill tier1)
PUB_SIGN_KEY="$KEYID" sh "$SIGN" sign -f "$d" >/dev/null 2>&1
rm -f "$d/.signature.asc"
_verify "$d" "$KEYID"
report 'manifest only -> UNVERIFIED-AUTHOR, no gpg needed (rc=0)' \
    0 "$RC" 'UNVERIFIED-AUTHOR' "$OUT"

# same fixture, but prove tier 1 truly never touches gpg: point PATH at
# a directory with no gpg binary and confirm verify still succeeds.
noGpgPath="$tmp/no-gpg-path"; mkdir -p "$noGpgPath"
for b in sh sha256sum diff mktemp grep awk cat sed cut printf \
         find sort rm cp ln mkdir; do
    p=$(command -v "$b" 2>/dev/null) || continue
    ln -s "$p" "$noGpgPath/$b" 2>/dev/null || true
done
if OUT2=$(PATH="$noGpgPath" PUB_SIGN_KEY="$KEYID" sh "$SIGN" verify "$d" 2>&1)
then RC2=0; else RC2=$?; fi
report 'tier 1 works with NO gpg on PATH at all (rc=0)' \
    0 "$RC2" 'UNVERIFIED-AUTHOR' "$OUT2"

# ---- fixture: manifest + valid signature (TIER 2) --------------------
d=$(_skill tier2)
PUB_SIGN_KEY="$KEYID" sh "$SIGN" sign -f "$d" >/dev/null 2>&1
_verify "$d" "$KEYID"
report 'manifest + valid signature -> signature valid (rc=0)' \
    0 "$RC" 'signature valid' "$OUT"

# ---- fixture: tree changed since signing -----------------------------
d=$(_skill drift)
PUB_SIGN_KEY="$KEYID" sh "$SIGN" sign -f "$d" >/dev/null 2>&1
printf '\n# edited after signing\n' >> "$d/tool.sh"
_verify "$d" "$KEYID"
report 'tree changed after signing -> TREE CHANGED (rc=1)' \
    1 "$RC" 'TREE CHANGED' "$OUT"

# ---- fixture: signature present, wrong pinned key --------------------
d=$(_skill wrongkey)
PUB_SIGN_KEY="$KEYID" sh "$SIGN" sign -f "$d" >/dev/null 2>&1
_verify "$d" '0000000000000000000000000000000000000000'
report 'signed, but pinned to the wrong key -> SIGNATURE FAILED (rc=1)' \
    1 "$RC" 'SIGNATURE FAILED' "$OUT"

# ---- fixture: check.sh (tier-1 companion) agrees, cold ---------------
d=$(_skill checksh)
PUB_SIGN_KEY="$KEYID" sh "$SIGN" sign -f "$d" >/dev/null 2>&1
cp "$CHECK" "$d/check.sh"
if OUT=$(cd "$d" && sh check.sh 2>&1); then RC=0; else RC=$?; fi
report 'check.sh on a clean signed skill (rc=0)' 0 "$RC" 'OK       ./SKILL.md' "$OUT"

printf '\n%d passed, %d failed\n' "$pass" "$fail"

if [ "$prove_red" = 1 ]; then
    if [ "$fail" -ge 1 ]; then
        printf 'PASS: tests.sh correctly went red under a planted bad expectation\n'
        exit 0
    fi
    printf 'FAIL: tests.sh did NOT go red under a planted bad expectation (rc=99 for no-manifest)\n' >&2
    exit 1
fi

[ "$fail" -eq 0 ]
