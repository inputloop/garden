#!/usr/bin/bash
# Copyright (C) 2026 Corwin Brust <corwin@bru.st>
# Authored by Mentat (for Corwin).
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
# thread - render a message thread (journal/threads/<id>/NNN-FROM.md) to one
# static HTML page. sh + awk only; no network, no build step, no JS required.
#
# A thread is a directory. A message is a file: NNN-FROM.md, with a small
# header block (--- key: value --- ) and a markdown-lite body. Order is the
# filename; the sequence IS the thread, so nothing can silently reorder.
#
#   thread.sh journal/threads/garden-tales-001 > site/threads/garden-tales-001.html
#   thread.sh -i journal/threads > site/threads/index.html      (thread index)
#
# Law it keeps: escape first, then mark up (a message is data, not markup);
# every message shows its own provenance header; unsigned is SAID, not implied.
# A clearsigned message is read through its armor, and its pill says "clearsigned (not verified
# here)": this tool never checks a signature, so it never says "signed".
# Unknown flags are rejected loudly - a parsed flag is not a behavior.
set -u
me=$(basename "$0")
mode=thread
case ${1:-} in
  -i) mode=index ; shift ;;
  -h|--help) echo "Usage: $me [-i] DIR" ; exit 0 ;;
  -*) echo "$me: unknown option: $1" ; echo "Usage: $me [-i] DIR" ; exit 2 ;;
esac
test $# -ge 1 || { echo "Usage: $me [-i] DIR" ; exit 2 ; }
dir=${1%/}
test -d "$dir" || { echo "$me: no such directory: $dir" ; exit 3 ; }

head_html () {   # $1 = page title
  cat <<HTML
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>$1 · Grader's Tales</title>
<style>
  :root{ --bg:#0f1117; --panel:#171a23; --ink:#eef1f7; --muted:#b9c0cf;
    --line:#2a2f3d; --accent:#ffcf4d; --accent-ink:#1a1400; --link:#9cc2ff;
    --them:#7ee2a8; --us:#9cc2ff; --radius:14px; --maxw:48rem; }
  @media (prefers-color-scheme: light){
    :root{ --bg:#f6f7fb; --panel:#fff; --ink:#15181f; --muted:#475067;
      --line:#dde1ea; --accent:#7a5400; --accent-ink:#fff; --link:#1c4fb3;
      --them:#0c6e39; --us:#1c4fb3; } }
  *{box-sizing:border-box}
  body{margin:0;background:var(--bg);color:var(--ink);
    font:16px/1.7 system-ui,-apple-system,Segoe UI,Roboto,sans-serif}
  a{color:var(--link)}
  a:focus-visible{outline:3px solid var(--accent);outline-offset:2px}
  header{padding:2.5rem 1.25rem 1.25rem;border-bottom:1px solid var(--line)}
  .wrap{max-width:var(--maxw);margin-inline:auto}
  h1{font-size:clamp(1.6rem,5vw,2.4rem);margin:.2rem 0}
  .tag{color:var(--muted);margin:.2rem 0 0}
  main{padding:1.25rem}
  article{max-width:var(--maxw);margin:1.5rem auto;background:var(--panel);
    border:1px solid var(--line);border-left:4px solid var(--them);
    border-radius:var(--radius);padding:1rem 1.25rem}
  article.us{border-left-color:var(--us)}
  .hdr{display:flex;flex-wrap:wrap;gap:.5rem 1rem;align-items:baseline;
    border-bottom:1px solid var(--line);padding-bottom:.5rem;margin-bottom:.75rem}
  .who{font-weight:700}
  .meta{color:var(--muted);font-size:.85rem}
  .pill{display:inline-block;font-size:.72rem;letter-spacing:.06em;
    text-transform:uppercase;background:var(--accent);color:var(--accent-ink);
    padding:.1rem .5rem;border-radius:999px;font-weight:700}
  blockquote{margin:1rem 0;padding:.3rem 0 .3rem 1rem;
    border-left:3px solid var(--accent);color:var(--muted);font-style:italic}
  code{font-family:ui-monospace,SFMono-Regular,Menlo,monospace;font-size:.92em;
    background:var(--bg);padding:.1rem .3rem;border-radius:4px}
  pre{background:var(--bg);border:1px solid var(--line);border-radius:8px;
    padding:.8rem;overflow:auto}
  footer{color:var(--muted);font-size:.85rem;text-align:center;
    padding:2rem 1.25rem;border-top:1px solid var(--line)}
</style>
</head>
<body>
<header><div class="wrap">
  <p class="tag"><a href="../index.html">&larr; Grader's Tales</a></p>
  <h1>$1</h1>
  <p class="tag">A thread between gardens. Method travels; cases don't.</p>
</div></header>
<main>
HTML
}

foot_html () {
  cat <<'HTML'
</main>
<footer>Rendered by <code>bin/thread.sh</code> · the sequence is the filenames;
nothing here can silently reorder. Unsigned messages say so.</footer>
</body>
</html>
HTML
}

# ---- index mode ------------------------------------------------------------
if test "$mode" = index ; then
  head_html "Threads"
  for t in "$dir"/*/ ; do
    test -d "$t" || continue
    id=$(basename "$t")
    n=$(ls "$t" | grep -c '^[0-9].*\.md$' || true)       # messages only: NNN-FROM.md, as rendered
    # the subject is message data: escape it here too (2026-09-28: it reached the index raw)
    sub=$(sed -n 's/^subject:[[:space:]]*//p' "$t"/*.md | head -1 | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')
    printf '<article><div class="hdr"><span class="who">%s</span>' "$id"
    printf '<span class="meta">%s message(s)</span></div>' "$n"
    printf '<p>%s</p><p><a href="%s.html">Read the thread &rarr;</a></p></article>\n' \
      "$sub" "$id"
  done
  foot_html
  exit 0
fi

# ---- thread mode -----------------------------------------------------------
id=$(basename "$dir")
head_html "$id"
# A clearsigned message (2026-09-28): strip the OpenPGP armor -- the BEGIN PGP SIGNED MESSAGE line
# and its Hash: headers up to the first blank line, and the BEGIN..END PGP SIGNATURE block -- and
# undo dash-escaping ("- " at a line's start) before parsing. This tool does NOT verify the
# signature, and its pill says exactly that (use gpg --verify for the verdict).
unarmor () {
  awk '{ sub(/\r$/, "") }                                   # CRLF files read as LF
       NR==1 && /^-----BEGIN PGP SIGNED MESSAGE-----[[:space:]]*$/ { cs=1; hdr=1; next }
       cs && hdr { if ($0 ~ /^[[:space:]]*$/) hdr=0; next }
       cs && /^-----BEGIN PGP SIGNATURE-----/ { sig=1; next }
       sig { if ($0 ~ /^-----END PGP SIGNATURE-----/) sig=0; next }
       cs { sub(/^- /, "") }
       { print }' "$1"
}
for f in "$dir"/[0-9]*.md ; do
  test -r "$f" || continue
  cs=0; head -1 "$f" | grep -q '^-----BEGIN PGP SIGNED MESSAGE-----' && cs=1
  unarmor "$f" | awk -v cs="$cs" -v fn="$(basename "$f" .md)" '
    function esc(s){ gsub(/&/,"\\&amp;",s); gsub(/</,"\\&lt;",s)
                     gsub(/>/,"\\&gt;",s); return s }             # escape FIRST
    function inl(s){ s=esc(s)
      # POSIX awk has no capture backreferences: wrap with & then strip the
      # markers. Order matters - code, then bold, then italic.
      gsub(/`[^`]+`/,"<code>&</code>",s);       gsub(/`/,"",s)
      gsub(/\*\*[^*]+\*\*/,"<strong>&</strong>",s); gsub(/\*\*/,"",s)
      gsub(/\*[^*]+\*/,"<em>&</em>",s);         gsub(/\*/,"",s)
      return s }
    BEGIN{ inhdr=0; done=0; para=0; quote=0 }
    NR==1 && /^---[[:space:]]*$/ { inhdr=1; next }
    NR==1 {   # 2026-09-28: a message with no header still gets its own article, its provenance
              # from the filename (NNN-FROM.md) and a pill that says what is missing
      seq=fn; sub(/-.*/,"",seq); who=fn; sub(/^[^-]*-/,"",who); opened=1
      printf "<article>\n<div class=\"hdr\"><span class=\"who\">%s</span>", esc(who)
      printf "<span class=\"meta\">#%s &middot; from the filename</span>", esc(seq)
      if (cs == 1) printf "<span class=\"pill\">no header</span><span class=\"pill\">clearsigned (not verified here)</span>"
      else printf "<span class=\"pill\">no header (unsigned)</span>"
      printf "</div>\n" }
    inhdr && /^---[[:space:]]*$/ {
      inhdr=0; opened=1
      cls = (h["from"] ~ /Vibrobeast/) ? " class=\"us\"" : ""
      printf "<article%s>\n<div class=\"hdr\">", cls
      printf "<span class=\"who\">%s</span>", esc(h["from"])
      printf "<span class=\"meta\">%s &middot; #%s", esc(h["date"]), esc(h["seq"])
      if (h["in-reply-to"] != "") printf " &middot; in reply to %s", esc(h["in-reply-to"])
      printf "</span>"
      if (cs == 1) printf "<span class=\"pill\">clearsigned (not verified here)</span>"
      else if (h["status"] ~ /DRAFT|unsigned/) printf "<span class=\"pill\">unsigned</span>"
      printf "</div>\n"
      if (h["subject"] != "") printf "<p class=\"meta\"><em>%s</em></p>\n", esc(h["subject"])
      next }
    inhdr { k=$0; sub(/:.*/,"",k); v=$0; sub(/^[^:]*:[[:space:]]*/,"",v); h[k]=v; next }
    /^sentinel:/ { next }                                    # ledger furniture
    /^[[:space:]]*$/ { if(para){print "</p>"; para=0} if(quote){print "</blockquote>"; quote=0} next }
    /^>[[:space:]]?/ { line=$0; sub(/^>[[:space:]]?/,"",line)
      if(!quote){ if(para){print "</p>"; para=0}; print "<blockquote>"; quote=1 }
      print inl(line); next }
    /^#{1,6}[[:space:]]/ { if(para){print "</p>"; para=0}
      lvl=index($0," "); t=$0; sub(/^#+[[:space:]]+/,"",t)
      printf "<h3>%s</h3>\n", inl(t); next }
    { if(!para){ print "<p>"; para=1 }
      print inl($0) }
    END{ if(para) print "</p>"; if(quote) print "</blockquote>"; if(opened) print "</article>" }
  '
done
foot_html
