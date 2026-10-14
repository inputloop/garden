#!/bin/sh
# verify_consent.sh — automate gates G1,G2,G3,G7 of the consent gate.
# G4 (dual-source fetch), G5 (per-party), G6 (prohibited-category judgment)
# are printed as MANUAL — the agent completes them with web_fetch + the record.
# Read-only. Never writes credentials anywhere. Exit 0 = auto-gates pass (pending
# manual); non-zero = a hard park.
set -eu
REC=""; SIG=""; ALLOW=""
while [ $# -gt 0 ]; do
  case "$1" in
    --record) REC="$2"; shift 2;;
    --sig) SIG="$2"; shift 2;;
    --allowed-signers) ALLOW="$2"; shift 2;;
    *) echo "usage: verify_consent.sh --record FILE [--sig FILE --allowed-signers FILE]" >&2; exit 2;;
  esac
done
[ -n "$REC" ] && [ -f "$REC" ] || { echo "PARK: no record"; exit 2; }

payload() { awk '/-----BEGIN CONSENT PAYLOAD-----/{f=1;next} /-----END CONSENT PAYLOAD-----/{f=0} f' "$REC"; }
field()   { payload | grep -E "^[[:space:]]*$1:" | head -1 | sed -E "s/^[[:space:]]*$1:[[:space:]]*//"; }

fail=0
note() { printf '  [%-4s] %-22s %s\n' "$1" "$2" "$3"; }

echo "verify_consent — $REC"
echo
echo " AUTO GATES:"

# G1 / G7 — blanket-grant scan over the whole record (case-insensitive, word-ish)
if grep -iE '\b(all|any|everything|whatever|full use|carte ?blanche|noconfirm)\b' "$REC" \
     | grep -ivE 'not blanket|ALL gates|no lift' >/dev/null; then
  note FAIL "G1/G7 specific" "blanket/override term found — auto-park"; fail=1
else
  note PASS "G1/G7 specific" "no blanket or override terms"
fi

# G2 — freshness: issued <= now <= expires, reconfirmed >= issued+600s
now=$(date +%s)
iso() { date -d "$1" +%s 2>/dev/null || echo ""; }
is=$(iso "$(field issued)"); ex=$(iso "$(field expires)"); rc=$(iso "$(field reconfirmed)")
if [ -z "$is" ] || [ -z "$ex" ]; then note FAIL "G2 fresh" "issued/expires unparseable"; fail=1
elif [ "$now" -lt "$is" ] || [ "$now" -gt "$ex" ]; then note FAIL "G2 fresh" "now outside [issued,expires]"; fail=1
elif [ -n "$rc" ] && [ $((rc - is)) -lt 600 ]; then note FAIL "G2 fresh" "reconfirmed < issued+10m (rushed)"; fail=1
else note PASS "G2 fresh" "within window; reconfirm gap ok"; fi

# G3 — payload sha256 binding + signature
calc=$(payload | sha256sum | cut -d' ' -f1)
stated=$(field payload_sha256)
if [ -n "$stated" ] && [ "$stated" != "<sha256 of this payload, BEGIN..END exclusive of the signature block>" ]; then
  [ "$calc" = "$stated" ] && note PASS "G3 sha-bind" "payload_sha256 matches" \
                          || { note FAIL "G3 sha-bind" "payload_sha256 MISMATCH"; fail=1; }
else note WARN "G3 sha-bind" "payload_sha256 not filled (template/unsigned)"; fi
if [ -n "$SIG" ] && [ -n "$ALLOW" ]; then
  if payload | ssh-keygen -Y verify -f "$ALLOW" -I "$(field principal)" -n consent-record -s "$SIG" >/dev/null 2>&1; then
    note PASS "G3 signature" "ssh-keygen -Y verify OK"
  else note FAIL "G3 signature" "signature verify FAILED"; fail=1; fi
else note WARN "G3 signature" "no --sig/--allowed-signers given (crypto check skipped)"; fi

echo
echo " MANUAL GATES (agent must complete before unblock):"
note TODO "G4 dual-source" "web_fetch both identity_urls; need 2/2 same key, independent origins"
note TODO "G5 per-party"   "each affected party out-of-scope OR own signed record; family parked"
note TODO "G6 prohibited"  "prohibited_category_decision explicit; agent-held => park-lift on record"
echo
if [ "$fail" -ne 0 ]; then echo "RESULT: CLAUD_QA_HOLD (parked) — an auto gate failed."; exit 1; fi
echo "RESULT: auto-gates PASS — pending G4/G5/G6. Action stays parked until those clear."; exit 0
