#!/bin/sh
# fm-dupkeys.sh -- a reading, not a verdict: which memory-note files say the same
# front-matter key twice.
#
# Why: the note writer (polygram store) wrote caller text into `key: value` lines
# without refusing line breaks, and the reader keeps the FIRST copy of a key.  So a
# value carrying "\nmode: SEATED" put a second `mode:` line above the real one and
# won.  The chain verifiers still say OK, because they hash whatever bytes were
# written.  The writer fix stops new ones; this reading finds any already written.
# A repeated key is never proof of an attack (a hand-edited note can repeat one);
# it is a place to look.  It never changes the chain's OK/BROKEN.
#
# Written from this prose, in awk, not from the Python or sh readers:
#   A note file opens with a line that is `---` (trailing blanks allowed).  Its front
#   matter runs to the next such line.  In it, a key is the text before the first
#   colon, blanks trimmed.  Report every key seen more than once, with the line
#   number of each repeat.  Also report any carriage-return byte inside the front
#   matter (a terminal shows the rest of that line over the start of it).
#
# usage:  sh fm-dupkeys.sh FILE_OR_DIR...     (a DIR is walked for g*.md)
#         sh fm-dupkeys.sh --prove-red
# output: DUPKEY<TAB>file<TAB>key<TAB>line   /   CR<TAB>file<TAB>line   /   last line
#         "# fm-dupkeys: N file(s) read, M finding(s)"
# exit:   0 no finding · 1 finding(s) · 2 nothing read (never reads as clean)
set -u
here=$(cd "$(dirname "$0")" && pwd)

scan() {
  awk '
    FNR == 1 { files++; inh = ($0 ~ /^---[ \t]*$/); delete seen; next }
    inh && /^---[ \t\r]*$/ { inh = 0; next }
    inh {
      if (index($0, "\r") > 0) { printf "CR\t%s\t%d\n", FILENAME, FNR; n++ }
      i = index($0, ":"); if (i == 0) next
      k = substr($0, 1, i - 1); gsub(/^[ \t]+|[ \t]+$/, "", k)
      if (k in seen) { printf "DUPKEY\t%s\t%s\t%d\n", FILENAME, k, FNR; n++ } else seen[k] = 1
    }
    END { printf "# fm-dupkeys: %d file(s) read, %d finding(s)\n", files, n + 0
          exit (files == 0 ? 2 : (n > 0 ? 1 : 0)) }' "$@"
}

prove_red() {
  t=$(mktemp -d) || exit 2; trap 'rm -rf "$t"' EXIT
  printf -- '---\nseam: a\nfrom: me\nmode: JAILED\n---\nbody\n' > "$t/g0001-clean.md"
  printf -- '---\nseam: a\nfrom: them\nmode: SEATED\nmode: JAILED\n---\nbody\nmode: body-lines-do-not-count\n' > "$t/g0002-dup.md"
  printf -- '---\nseam: a\nfrom: them\rmode: SEATED\nmode: JAILED\n---\nbody\n' > "$t/g0003-cr.md"
  fail=0
  r=$(scan "$t/g0001-clean.md"; echo "rc=$?")
  case $r in *"0 finding(s)"*rc=0) echo "  RED-OK  clean note: no finding, exit 0";; *) echo "  FAIL    clean note: $r"; fail=1;; esac
  r=$(scan "$t/g0002-dup.md"; echo "rc=$?")
  case $r in *"DUPKEY"*"mode"*"1 finding(s)"*rc=1) echo "  RED-OK  repeated mode: key found (and a body line was not counted)";; *) echo "  FAIL    repeated key: $r"; fail=1;; esac
  r=$(scan "$t/g0003-cr.md"; echo "rc=$?")
  case $r in *"CR"*rc=1) echo "  RED-OK  carriage return inside the front matter found";; *) echo "  FAIL    CR: $r"; fail=1;; esac
  r=$(scan /dev/null 2>/dev/null; echo "rc=$?")
  case $r in *rc=2) echo "  RED-OK  nothing read exits 2, never clean";; *) echo "  FAIL    empty input: $r"; fail=1;; esac
  [ "$fail" -eq 0 ] && echo "fm-dupkeys --prove-red: PASS" || echo "fm-dupkeys --prove-red: FAIL"
  return "$fail"
}

case ${1-} in
  --prove-red) prove_red ;;
  ''|-h|--help) sed -n '2,24p' "$0" | sed 's/^# \{0,1\}//'; exit 2 ;;
  *) for a in "$@"; do [ -e "$a" ] || { echo "# fm-dupkeys: I cannot see $a (no such file or directory); nothing was read"; exit 2; }; done
     list=$(for a in "$@"; do if [ -d "$a" ]; then find "$a" -type f -name 'g*.md'; else printf '%s\n' "$a"; fi; done | sort)
     [ -n "$list" ] || { echo "# fm-dupkeys: 0 file(s) read, 0 finding(s) -- nothing to read is not clean"; exit 2; }
     # newline-delimited; a path with a newline in it is not supported (said, not hidden)
     set -f; old=$IFS; IFS='
'; set -- $list; IFS=$old
     scan "$@" ;;
esac
