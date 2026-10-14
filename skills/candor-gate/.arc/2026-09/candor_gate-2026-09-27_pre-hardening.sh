#!/bin/sh
# Copyright (C) 2026 Corwin Brust <corwin@bru.st>
# Authored by Mentat (for Corwin).
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of vibrobeast.  vibrobeast is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
# candor-gate — vet an IMPORTED skill before it acts in a shop that did not
# author it. Read-only, stdlib/POSIX sh. Prints a per-check verdict and an
# overall PASS/HOLD. Provenance DEPTH is delegated to skill-sign (pin the
# fingerprint there); this scan flags the policy + load-safety surface.
#
# usage: candor_gate.sh PATH        (a skill dir containing SKILL.md, or a SKILL.md)
# exit:  0 = PASS (clears the gate)   1 = HOLD (a capability needs a decision)
#        2 = usage/read error
set -eu

DESC_LIMIT=1024   # platform hard cap on the frontmatter description

target=${1:-}
[ -n "$target" ] || { echo "usage: candor_gate.sh PATH (skill dir or SKILL.md)" >&2; exit 2; }
if [ -d "$target" ]; then md="$target/SKILL.md"; dir="$target"
else md="$target"; dir=$(dirname -- "$target"); fi
[ -r "$md" ] || { echo "candor-gate: cannot read $md" >&2; exit 2; }

name=$(sed -n 's/^name:[[:space:]]*//p' "$md" | head -1)
[ -n "$name" ] || name=$(basename -- "$dir")
hold=0
gov=0
if grep -qi 'candor-gate clause' "$md"; then gov=1; fi

say() { printf '  %-8s %s\n' "$1" "$2"; }
# A governed capability (a candor-gate clause is present) is not an open hold.
# Provenance is exempt: a clause cannot self-certify a signature.
flag() {
  if [ "$gov" -eq 1 ]; then
    say GOVERNED "$1"
  else
    say HOLD "$1"; hold=$((hold+1))
  fi
}

# extract the frontmatter description (folds a >-/| block into one line)
desc=$(awk '
  /^---[[:space:]]*$/ { d++; next }
  d==1 && /^description:/ { ind=1; s=$0; sub(/^description:[[:space:]]*/,"",s);
                           if (s ~ /^[>|][+-]?[[:space:]]*$/) s="";
                           if (s!="") buf=buf s " "; next }
  d==1 && ind==1 && /^[A-Za-z_][A-Za-z0-9_]*:/ { ind=0 }
  d==1 && ind==1 { t=$0; sub(/^[[:space:]]+/,"",t); buf=buf t " " }
  END { gsub(/[[:space:]]+/," ",buf); sub(/[[:space:]]+$/,"",buf); printf "%s", buf }
' "$md")
# strip a matching pair of surrounding YAML quotes so we count the VALUE,
# not the quote delimiters (an inline "..."/'...' description).
case $desc in
  \"*\") desc=${desc#\"}; desc=${desc%\"};;
  \'*\') desc=${desc#\'}; desc=${desc%\'};;
esac
dlen=$(printf '%s' "$desc" | wc -m | tr -d ' ')

printf '== candor-gate: %s ==\n' "$name"

# 1. Provenance — a signature present in the skill dir, else HOLD.
if find "$dir" \( -name '*.asc' -o -name '.signature.asc' \) 2>/dev/null | grep -q .; then
  say PASS "provenance: signature present (verify vs pinned fpr with skill-sign)"
else
  say HOLD "provenance: unsigned — verify against the authors pinned key first"
  hold=$((hold+1))
fi

# 2. Always-on engagement — opt-in required in a foreign shop.
if grep -Eqi 'always-on|self-engage|call yourself|every (substantive )?prompt|any time a prompt' "$md"; then
  flag "engagement: declares always-on — require OPT-IN per project in this shop"
else
  say PASS "engagement: not always-on"
fi

# 3. Auto-persist of person-facts — consent-gate before writing third-party data.
if grep -Eqi 'memory[- ]first|persist|biography|genome|for future reference' "$md" \
   && grep -Eqi 'person|people|pet|family|bond|friend|namesake|identity' "$md"; then
  flag "person-data: auto-persists person-facts — consent-gate third-party/family first"
else
  say PASS "person-data: no auto-persist of person-facts"
fi

# 4. Outward egress — consent-gate; forensic/entrusted/third-party never rides it.
if grep -Eqi 'ollama|llama[- ]bridge|curl|wget|https?://|network call|upload|egress|remote model' "$md"; then
  flag "egress: opens an outward path — consent-gate; keep forensic/entrusted/3p off it"
else
  say PASS "egress: no outward data path declared"
fi

# 5. Description length — platform cap; an over-long description will not load right.
if [ "$dlen" -gt "$DESC_LIMIT" ]; then
  say HOLD "description: ${dlen} chars > ${DESC_LIMIT} limit — trim before install"
  hold=$((hold+1))
elif [ "$dlen" -gt $((DESC_LIMIT - 80)) ]; then
  say NOTE "description: ${dlen} chars (near the ${DESC_LIMIT} limit)"
else
  say PASS "description: ${dlen} chars (<= ${DESC_LIMIT})"
fi

# 6. Dangling routes — delegation must not name skills that are not installed.
if grep -Eqi 'rout(e|ing)|delegat|hand it to|pipeline|subsystem' "$md"; then
  say NOTE "routes/delegates — confirm every named sibling skill is installed"
fi

if [ "$hold" -eq 0 ]; then
  printf '== verdict: PASS — clears the gate ==\n'
  exit 0
else
  printf '== verdict: HOLD — %d check(s) need a decision or a consent record ==\n' "$hold"
  exit 1
fi
