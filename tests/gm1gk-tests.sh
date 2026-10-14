#!/bin/sh
# gm1gk-tests.sh -- the GRAMMARY gauge counts, and never fails.  | --prove-red
# SPEC (2026-10-10, lane C task C4, written before the code):
#   G1 "Every entry has a 'Whose word' line; gm1gk counts the entries without one, and never fails."
#   G2 "A tree word with no GRAMMARY entry is counted, by name."
#   G3 "With no dictionary on the machine, spelling is said NOT CHECKED, never 'clean'."
#      (F1, pass 2: the dictionary is pyspellchecker; GM1GK_PYTHON=/nonexistent stands for "none")
#   G5, G6 (F1, pass 2) are in tests/gm1gk-spec.tcl: the LOOK line, and the spelling words by name.
#   G4 "--words prints one headword a line, minted from GRAMMARY (no labelled line is a headword)."
# The gauge is sh + awk; this test is sh with fixtures it writes.  --prove-red: a gm1gk with its
# miss counter cut out must make G1 red, and one that exits 1 on a miss must make the never-fails row red.
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
set -u
here=$(cd "$(dirname "$0")/.." && pwd)
t=$(mktemp -d); trap 'rm -rf "$t"' EXIT
cat > "$t/G.md" <<'G'
# G

## New words

### seat
- **What it is:** a folder.
- **Whose word:** the shop's.

### soft skill, spell
- **What it is:** two words.
- **Whose word:** Corwin's.

## Seed
*Whose word: the shop's.*

- **Mentat** -- the note discipline.
G
printf '# words\n\n- **seat** / **SEATED**\n- **spell**\n- **Mentat**\n' > "$t/W.md"
spec() { # spec GM1GK -> rows; returns the fail count
  G=$1; pass=0; fail=0
  ok()  { pass=$((pass+1)); echo "ok   $1"; }
  bad() { fail=$((fail+1)); echo "FAIL $1 -- $2"; }
  out=$(sh "$G" "$t/G.md" "$t/W.md"); grc=$?
  echo "$out" | grep -q '3 entries in G.md; 0 with no "Whose word" line' && ok "G1 the clean fixture: 3 entries (a heading naming two words is one entry), 0 without a Whose word line" || bad G1-clean "$out"
  { cat "$t/G.md"; printf '\n## Planted\n\n### planted word\n- **What it is:** no owner named.\n'; } > "$t/G2.md"
  out=$(sh "$G" "$t/G2.md" "$t/W.md"); grc=$?
  echo "$out" | grep -q '4 entries in G2.md; 1 with no "Whose word" line (planted word)' && ok "G1 a planted entry without Whose word moves the count to 1, by name" || bad G1-plant "$out"
  [ "$grc" -eq 0 ] && ok "G1 the gauge never fails: exit 0 with a miss" || bad G1-exit "rc=$grc"
  printf -- '- **swing**\n' >> "$t/W.md"
  out=$(sh "$G" "$t/G.md" "$t/W.md")
  echo "$out" | grep -q '1 of 4 tree words (W.md) have no entry in GRAMMARY: swing' && ok "G2 a planted tree word with no entry is counted, by name" || bad G2 "$out"
  out=$(GM1GK_PYTHON=/nonexistent/python3 sh "$G" "$t/G.md" "$t/W.md")
  echo "$out" | grep -q 'spelling NOT CHECKED' && ok "G3 no dictionary: spelling NOT CHECKED" || bad G3 "$out"
  out=$(sh "$G" --words "$t/G.md" | tr '\n' ' ')
  [ "$out" = "mentat seat soft skill spell " ] && ok "G4 --words: mentat, seat, soft skill, spell (no labelled line)" || bad G4 "got: $out"
  out=$(sh "$G" "$t/none.md"); grc=$?
  [ "$grc" -eq 2 ] && echo "$out" | grep -q 'NOT CHECKED' && ok "a GRAMMARY that is not there: NOT CHECKED, exit 2" || bad missing "rc=$grc $out"
  sed -i '$d' "$t/W.md"
  echo "TOTAL pass=$pass fail=$fail"; return $fail
}
spec "$here/bin/gm1gk"; rc=$?
# G5/G6 in Tcl (a second language); no tclsh here is NOT CHECKED (exit 77), never a pass
tcl() { tclsh "$here/tests/gm1gk-spec.tcl" "$1"; }
if command -v tclsh >/dev/null 2>&1; then tcl "$here/bin/gm1gk"; trc=$?
  [ $trc -eq 1 ] && rc=1; [ $trc -eq 77 ] && [ $rc -eq 0 ] && skip=1
else echo "gm1gk tests: G5/G6 NOT CHECKED (no tclsh here; install Tcl to check them)"; [ $rc -eq 0 ] && skip=1; fi
out=$(sh "$here/bin/gm1gk" "$here/GRAMMARY.md"); echo "live: $(echo "$out" | head -2 | tr '\n' ' ')"
if [ "${1:-}" = --prove-red ]; then
  sed 's/{ miss++; missing/{ missing/' "$here/bin/gm1gk" > "$t/a"
  if spec "$t/a" >"$t/o" 2>&1; then echo "FAIL prove-red: a gauge that never counts a miss passed"; rc=1
  else echo "ok   prove-red: a gauge that never counts a miss goes red ($(grep -c '^FAIL' "$t/o") FAIL rows)"; fi
  sed 's/^exit 0$/[ "$miss" -gt 0 ] \&\& exit 1; exit 0/' "$here/bin/gm1gk" > "$t/b"
  if spec "$t/b" >"$t/o" 2>&1; then echo "FAIL prove-red: a gauge that fails on a miss passed"; rc=1
  else echo "ok   prove-red: a gauge that fails on a miss goes red ($(grep '^FAIL' "$t/o" | cut -c1-40 | tr '\n' ' '))"; fi
  if command -v tclsh >/dev/null 2>&1; then
    sed '/#guard:look/s/^if /if false \&\& /' "$here/bin/gm1gk" > "$t/c"
    cmp -s "$here/bin/gm1gk" "$t/c" && { echo "FAIL prove-red: the look plant changed nothing"; rc=1; }
    if tcl "$t/c" >"$t/o" 2>&1; then echo "FAIL prove-red: a gauge with no LOOK line passed"; rc=1
    else echo "ok   prove-red: a gauge with no LOOK line goes red ($(grep -c 'FAIL' "$t/o") FAIL rows)"; fi
    sed "s/cut -f2 | sed 's\/^.\/: &\/')\"/cut -f2 | sed 's\/.*\/\/')\"/" "$here/bin/gm1gk" > "$t/d"
    cmp -s "$here/bin/gm1gk" "$t/d" && { echo "FAIL prove-red: the names plant changed nothing"; rc=1; }
    if tcl "$t/d" >"$t/o" 2>&1; then echo "FAIL prove-red: a gauge that prints only the spelling count passed"; rc=1
    else echo "ok   prove-red: a gauge that prints only the spelling count goes red ($(grep -c 'FAIL' "$t/o") FAIL rows)"; fi
  fi
fi
[ $rc -eq 0 ] && [ "${skip:-0}" -eq 1 ] && { echo "gm1gk tests: some rows NOT CHECKED here (exit 77)"; exit 77; }
exit $rc
