#!/bin/sh
# he2elpa -- an ELPA package into the sandbox, by DOWNLOAD-AND-EXTRACT (never package-install).
#
# DRAFT enhance for c4/bin/he2ma -- keeper to fold (as `he2ma --pkg NAME`) or keep as a sibling,
# then re-sign. Not signed here. GPL-3.0-or-later; holder Corwin Brust (he2ma family).
#
# WHY (measured 2026-09-02): he2ma proved `apt-get install` fails but download+`dpkg -x` works, and
# stopped at Emacs itself. The SAME wall is one rung up: in the sandbox Emacs 27.1, `package-install`
# FAILS -- "Failed to download 'gnu' archive" (its url.el/TLS can't reach elpa.gnu.org) -- while
#   curl https://elpa.gnu.org/packages/<pkg>-<ver>.tar   WORKS (200, ~2 MB in a moment),
#   tar -x                                                WORKS (into a dir we own).
# So the reliable, honest route for ELPA packages is the identical one: DOWNLOAD-AND-EXTRACT. It
# touches nothing outside a dir we made; removing the dir removes the package entirely.
#
# usage: he2elpa PKG [--prefix DIR] [--devel]
#   PKG        an ELPA package name, e.g. eev
#   --prefix   where to extract (default /tmp/c4elpa); set to a mount to survive a new sandbox
#   --devel    use the devel channel (elpa.gnu.org/devel) instead of stable
#
# On success prints the load-path line to eval -- the whole trick, same shape as he2ma's env block.
set -eu
LC_ALL=C; export LC_ALL

PKG=${1:?usage: he2elpa PKG [--prefix DIR] [--devel]}; shift
PREFIX=/tmp/c4elpa; BASE=https://elpa.gnu.org/packages
for a in "$@"; do
  case $a in
    --devel) BASE=https://elpa.gnu.org/devel ;;
    --prefix) PREFIX=__next__ ;;
    *) [ "$PREFIX" = __next__ ] && PREFIX=$a || { echo "he2elpa: bad arg: $a" >&2; exit 2; } ;;
  esac
done
[ "$PREFIX" = __next__ ] && { echo "he2elpa: --prefix needs a dir" >&2; exit 2; }

# 1. version: the datestamp/vector from archive-contents (the file package.el would have read)
VER=$(curl -fsS "$BASE/archive-contents" \
      | tr ')' '\n' | grep -iA1 "($PKG\$" | grep -oE '\[\([0-9]+' | grep -oE '[0-9]+' | head -1)
[ -n "${VER:-}" ] || { echo "he2elpa: no version for '$PKG' in $BASE/archive-contents" >&2; exit 3; }

# 2. download-and-extract (single-file .el packages ship as .el, multi-file as .tar)
mkdir -p "$PREFIX"; cd "$PREFIX"
DIR="$PREFIX/$PKG-$VER"
if curl -fsS -o "$PKG-$VER.tar" "$BASE/$PKG-$VER.tar" 2>/dev/null; then
  tar xf "$PKG-$VER.tar"
elif curl -fsS -o "$PKG-$VER.el" "$BASE/$PKG-$VER.el" 2>/dev/null; then
  mkdir -p "$DIR"; mv "$PKG-$VER.el" "$DIR/$PKG.el"
else
  echo "he2elpa: could not fetch $PKG-$VER.{tar,el} from $BASE" >&2; exit 4
fi

# 3. MUST -- what ran, and the recipe to use it
NEL=$(ls "$DIR"/*.el 2>/dev/null | wc -l | tr -d ' ')
echo "== HE2ELPA -- $PKG $VER -- $NEL .el into $DIR =="
echo "-- add to your sandbox-Emacs run (the whole trick) --"
echo "   --eval \"(add-to-list 'load-path \\\"$DIR\\\")\"  then  (require '$PKG)"
echo "   NOT PERSISTENT if PREFIX is under /tmp; pass --prefix on a mount to keep it."
