#!/bin/sh
# mkdrops.sh ROOT -- build the br1in fixture drops under ROOT (scratch, outside the tree).
#   ROOT/from/2026-01-01   pack zip: alpha v1.0, beta, delta; SHA256SUMS beside and inside
#   ROOT/from/2026-01-02   pack zip: alpha v1.1 (changed), beta (same); loose gamma.skill (new);
#                          delta gone (dropped); NOTE.txt not named by any sum
#   ROOT/fenced/c4/Z/from-bryant/2026-01-03   a fenced place holding zeta and SECRET.txt
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
set -eu
R=$1; mkdir -p "$R"; cd "$R"
w=$(mktemp -d "${TMPDIR:-/tmp}/mkdrops.XXXXXX"); trap 'rm -rf "$w"' EXIT
skill() { # dir name version desc heading
  mkdir -p "$1"; printf -- '---\nname: %s\ndescription: %s\n---\n\n# %s\n\n## %s\n\nBody.\n\n**%s (2026-01-01):** note.\n' \
    "$2" "$4" "$2" "$5" "$3" > "$1/SKILL.md"; }
pack() { # date
  (cd "$w/$1" && find pack -type f ! -name SHA256SUMS | sort | sed 's#^pack/##' | (cd pack && xargs sha256sum) > pack/SHA256SUMS \
     && zip -q -r -X "$R/from/$1/pack-$1.zip" pack); }
# drop 1
mkdir -p from/2026-01-01 "$w/2026-01-01"
skill "$w/2026-01-01/pack/skills/alpha" alpha v1.0 "Use when the alpha thing is asked: 'run alpha', 'alpha please'." "The loop"
skill "$w/2026-01-01/pack/skills/beta" beta v2.0 "Beta does beta work." "Hard gates"
mkdir -p "$w/2026-01-01/pack/skills/beta/scripts"; printf '#!/bin/sh\necho beta\n' > "$w/2026-01-01/pack/skills/beta/scripts/b.sh"
skill "$w/2026-01-01/pack/skills/delta" delta v0.1 "Delta, soon retired." "Hand-back"
pack 2026-01-01
(cd from/2026-01-01 && sha256sum pack-2026-01-01.zip > SHA256SUMS)
# drop 2
mkdir -p from/2026-01-02 "$w/2026-01-02"
skill "$w/2026-01-02/pack/skills/alpha" alpha v1.1 "Use when the alpha thing is asked: 'run alpha', 'alpha now'." "The loop"
printf '\n## What it hands back\n\nThe product.\n' >> "$w/2026-01-02/pack/skills/alpha/SKILL.md"
cp -R "$w/2026-01-01/pack/skills/beta" "$w/2026-01-02/pack/skills/beta"
pack 2026-01-02
skill "$w/g/gamma" gamma v1.0 "Gamma, new in drop two." "Boot order"
(cd "$w/g" && zip -q -r -X "$R/from/2026-01-02/gamma.skill" gamma)
printf 'A loose note that no sum names.\n' > from/2026-01-02/NOTE.txt
(cd from/2026-01-02 && sha256sum pack-2026-01-02.zip gamma.skill > SHA256SUMS)
# a fenced place: nothing here may be read
mkdir -p fenced/c4/Z/from-bryant/2026-01-03
skill fenced/c4/Z/from-bryant/2026-01-03/skills/zeta zeta v9.9 "ZETA-FENCED-MARKER must never be read." "Secret"
printf 'FENCED-SECRET-BYTES\n' > fenced/c4/Z/from-bryant/2026-01-03/SECRET.txt
# never-list material inside the drop itself: neither may be listed, hashed or opened
mkdir -p from/2026-01-02/.keys; printf 'KEYS-MARKER\n' > from/2026-01-02/.keys/k.txt
printf 'SECRET-MARKER\n' > from/2026-01-02/a.secret
