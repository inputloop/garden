#!/bin/sh
# test-store-line-breaks.sh -- prove-red for B5U-007: caller text with line breaks in the
# polygram memory store.  Run it on the UNFIXED copy (it must FAIL) and on the FIXED copy
# (it must PASS).
#
# THE SPEC this test is written from (prose first; the checks below are awk and sh, a
# different language from the Python under test and from the store's own Python tests):
#   Whatever text a caller hands the store -- through append, cite or bless --
#   P1  every note file's front matter says each key at most once;
#   P2  a note written while the store is JAILED reads back JAILED from its bytes;
#   P3  every citation record names the identity that made the call, and one call adds
#       at most one record;
#   P4  every bless record names the blesser that made the call, and one call adds at most
#       one record;
#   P5  no carriage-return byte sits inside a note's front matter;
#   P6  (design pin, not a demonstrated attack) no U+2028 line separator reaches a note's
#       front matter.
#   A refused write satisfies all six: nothing written breaks nothing.
#   CONTROLS (the fix must not simply refuse everything):
#   K1  a clean append still writes a note, and the shell chain verifier reads OK;
#   K2  that clean note's file name is g0001-ab2d385336593d5c.md, the name the UNFIXED
#       store gave the same input -- legal writes keep their exact bytes;
#   K3  a clean cite and a clean bless still write one record each.
#
# Python is used only as the DRIVER (the store's API is Python).  Every verdict below is
# read from the bytes on disk by awk or sh.
#
# usage: sh test-store-line-breaks.sh COPY_ROOT     (COPY_ROOT holds polygram/ and bin/)
# exit:  0 all properties hold · 1 a property failed · 2 environment
set -u
root=$(cd "${1:?usage: test-store-line-breaks.sh COPY_ROOT}" && pwd) || exit 2
here=$(cd "$(dirname "$0")" && pwd)
dup=$here/fm-dupkeys.sh
[ -f "$root/polygram/mcp/store.py" ] && [ -f "$root/bin/dl2-verify.sh" ] || { echo "no store/verifier under $root"; exit 2; }
t=$(mktemp -d) || exit 2
trap 'rm -rf "$t"' EXIT
fail=0
ok()  { printf '  PASS  %s\n' "$1"; }
bad() { printf '  FAIL  %s\n' "$1"; fail=1; }

# ---- drive the store (Python), recording only what was refused ------------------------
python3 - "$root" "$t" > "$t/driver.log" 2>&1 <<'PY'
import datetime as dt, sys
from pathlib import Path
root, t = Path(sys.argv[1]), Path(sys.argv[2])
sys.path.insert(0, str(root))
from polygram.mcp import store as S
NOW = dt.datetime(2026, 9, 30, 23, 30, tzinfo=dt.timezone.utc)
def tryit(label, fn):
    try: fn(); print(f"WROTE\t{label}")
    except Exception as e: print(f"REFUSED\t{label}\t{type(e).__name__}")
# K1/K2: a clean seated note (same input as the reproduction run on the unfixed copy)
seat = t / "seat"; seat.mkdir()
ss = S.Store(root=seat, by="writer-a"); ss.ensure()
tryit("clean-append", lambda: ss.append("pin", "one", frm="me", would_change="w", triggers=["t"], now=NOW))
# P1/P5/P6 on a seated store: every caller-supplied front-matter field, every break shape
breaks = {"lf": "\nmode: FORGED\nby: someone-else\nfirst-seen: g0001-0000000000000000.md",
          "crlf": "\r\nmode: FORGED\r\nfirst-seen: g0001-0000000000000000.md",
          "cr": "\rmode: FORGED", "u2028": " mode: FORGED"}
for bname, b in breaks.items():
    for field in ("source", "would_change", "triggers", "came_from", "leads_to", "seam"):
        kw = dict(frm="me", would_change="w", triggers=["t"], came_from=[], leads_to=[])
        seam = f"s-{bname}-{field}"
        if field == "source": kw["frm"] = "me" + b
        elif field == "would_change": kw["would_change"] = "w" + b
        elif field == "seam": seam = seam + b
        else: kw[field] = ["x" + b]
        tryit(f"{bname}:{field}", lambda seam=seam, kw=kw: ss.append(seam, "body", now=NOW, **kw))
# P2: a JAILED write whose source forges the mode
jail = t / "jail"; jail.mkdir()
sj = S.Store(root=t / "absent-seat", by="writer-a", jail_root=jail)
tryit("jailed:source", lambda: sj.append("jailed", "body", frm="them\nmode: SEATED",
                                         would_change="w", triggers=["t"], allow_jailed=True, now=NOW))
# K3 + P3: cite (the citer is the store's identity, as seat_cite passes it)
tryit("clean-cite", lambda: ss.cite("pin", "writer-a", "here"))
tryit("cite:where", lambda: ss.cite("pin", "writer-a", "there\n20260930T233000Z\tghost-citer\tx"))
# K3 + P4: bless by a second party; the second call smuggles a record under another name
sb = S.Store(root=seat, by="reader-b")
tryit("clean-bless", lambda: sb.bless("pin", "reader-b", "read the body against the source"))
h = ss.head("pin"); sha = S.dl2.file_sha(h.read_bytes())
tryit("bless:checked", lambda: sb.bless("pin", "reader-b", f"ok\n20260930T233000Z\tsomeone-else\t1\t{sha}\tforged"))
PY
[ -s "$t/driver.log" ] || { echo "driver produced nothing"; exit 2; }
grep -q 'Traceback' "$t/driver.log" && { cat "$t/driver.log"; echo "driver crashed"; exit 2; }
wrote=$(grep -c '^WROTE' "$t/driver.log"); refused=$(grep -c '^REFUSED' "$t/driver.log")
printf 'store copy: %s\ndriver: %s call(s) wrote, %s refused\n' "$root" "$wrote" "$refused"

# ---- K1 / K2 -------------------------------------------------------------------------
if [ -f "$t/seat/notes/pin/g0001-ab2d385336593d5c.md" ]; then ok "K2 clean note keeps its pre-fix name g0001-ab2d385336593d5c.md"
else bad "K2 clean note name changed or missing: $(ls "$t/seat/notes/pin" 2>/dev/null | tr '\n' ' ')"; fi
v=$(sh "$root/bin/dl2-verify.sh" "$t/seat/notes/pin" 2>&1 | cut -f1)
[ "$v" = OK ] && ok "K1 clean append written; dl2-verify.sh reads OK" || bad "K1 clean chain: $v"

# ---- P1 / P5: the independent awk reading over every note file written ----------------
dirs=""; for d in "$t/seat/notes" "$t/jail/notes"; do [ -d "$d" ] && dirs="$dirs $d"; done
sh "$dup" $dirs > "$t/dup.out" 2>&1; rc=$?
nd=$(grep -c '^DUPKEY' "$t/dup.out"); nc=$(grep -c '^CR' "$t/dup.out")
[ "$nd" -eq 0 ] && ok "P1 no note says a front-matter key twice" || { bad "P1 $nd repeated key(s):"; grep '^DUPKEY' "$t/dup.out" | sed 's|.*/notes/|      |'; }
[ "$nc" -eq 0 ] && ok "P5 no carriage return inside any front matter" || { bad "P5 $nc front-matter line(s) carry a carriage return"; grep '^CR' "$t/dup.out" | sed 's|.*/notes/|      |'; }
[ "$rc" -ne 2 ] || bad "fm-dupkeys read nothing (exit 2): the notes directory is missing"

# ---- P6: no U+2028 (bytes E2 80 A8) inside any front matter ---------------------------
u=$(find "$t/seat/notes" "$t/jail/notes" -type f -name 'g*.md' 2>/dev/null | while IFS= read -r f; do
      awk 'NR==1{inh=1;next} inh && /^---[ \t\r]*$/{exit} inh' "$f" | LC_ALL=C grep -c "$(printf '\342\200\250')" ; done | awk '{s+=$1} END{print s+0}')
[ "$u" -eq 0 ] && ok "P6 no U+2028 inside any front matter (design pin)" || bad "P6 $u front-matter line(s) carry U+2028"

# ---- P2: a jailed write reads back JAILED from its bytes (first mode: line wins) -------
jm=$(for f in "$t"/jail/notes/jailed/g*.md; do [ -f "$f" ] || continue
       awk 'NR==1{next} /^---[ \t\r]*$/{exit} { i=index($0,":"); k=substr($0,1,i-1); gsub(/^[ \t]+|[ \t]+$/,"",k)
            if (k=="mode") { v=substr($0,i+1); gsub(/^[ \t]+|[ \t\r]+$/,"",v); print v; exit } }' "$f"; done)
case $jm in
  '') grep -q '^REFUSED	jailed:source' "$t/driver.log" && ok "P2 hostile jailed write refused (nothing to misread)" || bad "P2 no jailed note and no refusal recorded" ;;
  JAILED) ok "P2 jailed write reads back JAILED" ;;
  *) bad "P2 jailed write reads back mode=$jm" ;;
esac

# ---- P3: citation log -- one record per call, each naming the caller's identity --------
cl=$t/seat/cited/pin.log
if [ -f "$cl" ]; then
  nrec=$(grep -c . "$cl"); other=$(awk -F'\t' 'NF && $2 != "writer-a"' "$cl" | wc -l | tr -d ' ')
  calls=$(grep -cE '^WROTE	(clean-cite|cite:where)' "$t/driver.log")
  [ "$other" -eq 0 ] && ok "P3 every citation names writer-a" || bad "P3 $other citation(s) name a citer who never called: $(awk -F'\t' '$2 != "writer-a"{print $2}' "$cl" | tr '\n' ' ')"
  [ "$nrec" -le "$calls" ] && ok "P3 $nrec record(s) for $calls call(s)" || bad "P3 $nrec record(s) from $calls call(s)"
else bad "K3 clean cite wrote no citation log"; fi

# ---- P4: bless log -- one record per call, each naming the blesser ---------------------
bl=$t/seat/blessed/pin.log
if [ -f "$bl" ]; then
  nrec=$(grep -c . "$bl"); other=$(awk -F'\t' 'NF && $2 != "reader-b"' "$bl" | wc -l | tr -d ' ')
  calls=$(grep -cE '^WROTE	(clean-bless|bless:checked)' "$t/driver.log")
  [ "$other" -eq 0 ] && ok "P4 every blessing names reader-b" || bad "P4 $other blessing(s) under a name that never called: $(awk -F'\t' '$2 != "reader-b"{print $2}' "$bl" | tr '\n' ' ')"
  [ "$nrec" -le "$calls" ] && ok "P4 $nrec record(s) for $calls call(s)" || bad "P4 $nrec record(s) from $calls call(s)"
else bad "K3 clean bless wrote no bless log"; fi
grep -q '^WROTE	clean-cite' "$t/driver.log" && grep -q '^WROTE	clean-bless' "$t/driver.log" && ok "K3 clean cite and clean bless both wrote" || bad "K3 a clean cite or bless was refused"

[ "$fail" -eq 0 ] && { echo "test-store-line-breaks: PASS"; exit 0; } || { echo "test-store-line-breaks: FAIL"; exit 1; }
