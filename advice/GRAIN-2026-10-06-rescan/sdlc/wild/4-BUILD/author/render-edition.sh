#!/bin/sh
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2026 the Larder software contributors
#
# render-edition.sh EDITION_CONF TEMPLATE OUTDIR
# Fills the permission-notice template from an edition's conf and writes
# OUTDIR/PERMISSION.md. Until LEGAL_REVIEW=yes the notice opens with a DRAFT
# banner, and fanmark refuses to stamp works with a draft.
set -eu
LC_ALL=C
export LC_ALL

die() { echo "render-edition: $*" >&2; exit 1; }
[ "$#" -eq 3 ] || { echo "usage: render-edition.sh EDITION_CONF TEMPLATE OUTDIR" >&2; exit 64; }
conf=$1 tpl=$2 out=$3
[ -r "$conf" ] || die "cannot read $conf"
[ -r "$tpl" ] || die "cannot read $tpl"

val() {
    v=$(sed -n "s/^$1=//p" "$conf" | head -n 1)
    [ -n "$v" ] || die "$conf: $1 is missing or empty"
    case $v in
        *'|'*|*'&'*|*'\'*|*'{'*|*'}'*) die "$conf: $1 contains one of | & \\ { }" ;;
    esac
    printf '%s' "$v"
}
# One assignment per line: with several on one line only the last one's failure counts.
author=$(val AUTHOR)
titles=$(val TITLES)
contact=$(val CONTACT)
version=$(val VERSION)
review=$(val LEGAL_REVIEW)

mkdir -p "$out"
{
    if [ "$review" != yes ]; then
        echo '> **DRAFT: not reviewed by a lawyer. Do not publish with the books.**'
        echo
    fi
    sed -e '/^<!-- TEMPLATE NOTE/,/^-->$/d' \
        -e "s|{{AUTHOR}}|$author|g" -e "s|{{TITLES}}|$titles|g" \
        -e "s|{{CONTACT}}|$contact|g" -e "s|{{VERSION}}|$version|g" "$tpl"
} > "$out/PERMISSION.md.tmp"

if grep -q '{{' "$out/PERMISSION.md.tmp"; then
    rm -f "$out/PERMISSION.md.tmp"
    die "unresolved {{placeholder}} left in the template"
fi
mv "$out/PERMISSION.md.tmp" "$out/PERMISSION.md"
echo "render-edition: wrote $out/PERMISSION.md (LEGAL_REVIEW=$review)" >&2
