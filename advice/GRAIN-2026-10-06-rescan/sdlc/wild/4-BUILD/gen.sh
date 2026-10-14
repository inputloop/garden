#!/bin/sh
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2026 the Larder software contributors
#
# gen.sh -- turn recipes.conf into out/ (package lists, first-run pages, the
# larder-open launcher). POSIX sh + awk. No network, no root, no packages.
#   gen.sh [-r RECIPES] [-t TEMPLATE_DIR] [-o OUTDIR]
#   FREE_ONLY=1 gen.sh    leave out every package flagged nff (non-free firmware)
# Output is built in a staging directory and moved into place only if every
# check in gen.awk passed, so a bad recipe never leaves a half-written out/.
set -eu
LC_ALL=C
export LC_ALL

here=$(cd "$(dirname "$0")" && pwd)
recipes=$here/recipes.conf
tpl=$here
out=$here/out
while getopts r:t:o: opt; do
    case $opt in
        r) recipes=$OPTARG ;;
        t) tpl=$OPTARG ;;
        o) out=$OPTARG ;;
        *) echo "usage: gen.sh [-r RECIPES] [-t TEMPLATE_DIR] [-o OUTDIR]" >&2; exit 64 ;;
    esac
done

case $out in
    ''|*\'*|*\"*|*\\*) echo "gen.sh: unsafe output path" >&2; exit 64 ;;
esac
[ -r "$recipes" ] || { echo "gen.sh: cannot read $recipes" >&2; exit 66; }

out=${out%/}
stage=$(mktemp -d "$out.stage.XXXXXX")
trap 'rm -rf "$stage"' EXIT

awk -v out="$stage" -v tpl="$tpl" -v free_only="${FREE_ONLY:-0}" \
    -f "$here/gen.awk" "$recipes"

chmod 755 "$stage" "$stage/larder-open"
rm -rf "$out"
mv "$stage" "$out"
echo "gen.sh: wrote $out" >&2
