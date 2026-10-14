<!-- SPDX-License-Identifier: CC-BY-SA-4.0 -->
# Larder garden prototype

A small, runnable prototype for the Larder spec: one literate source (`recipes.org`) that
generates the package lists and build flags for five profiles, the first-run shell in two forms (a
single HTML page and an Emacs Lisp frame), and an author-edition overlay whose permission notice is
a draft for the author and his counsel. It needs no network and no root. It does not build an image.

It is a prototype for a reviewer to read and run, not a product. Design and reasoning are in
`../3-DESIGN.md`; risks and unknowns in `../2-ANALYSIS.md`; the honest self-review in `../6-REVIEW.md`.

## What is here

| path | what it is |
|------|------------|
| `recipes.org` | the one source: package groups, five profiles, build flags, choices, author overlay. Edit this, never `out/`. |
| `bin/lr1tg`, `bin/lr1tg.awk` | reader one: a strict POSIX-awk tangler for the subset of Org the recipes use. |
| `out/` | the generated files, committed so a reviewer can read them without running anything. |
| `shell/first-run.html` | the first-run page for the graphical profiles. One file, no network, light and dark. |
| `shell/larder-first-run.el` | the first-run frame for the console profiles (Emacs, mouse first). |
| `bin/lr1op` | the one dispatcher both shells call when a choice is clicked. |
| `author/PERMISSION-NOTICE.md` | the author edition's permission notice. A draft. It grants nothing. |
| `author/books.org`, `bin/lr1bk` | the per-title, per-right gate for what may ever go on an author's stick (placeholders only). |
| `bin/lr1st` | the stamp: prints the "by permission" mark only if the notice is in force AND the author's signature verifies. |

The five profiles are `minimal`, `desktop`, `homelab`, `hardened` and `fullsink`; what is in each is
in `out/*.packages` and described in `recipes.org` under "The five profiles".

## Run it

```sh
sh bin/lr1tg -C /tmp/larder-out recipes.org   # reader one; writes the same files under /tmp/larder-out/out
sh ../5-TEST/lr1ck                            # all the checks (dash or bash --posix)
sh ../5-TEST/lr1ck --prove-red                # plant faults on a copy; each must be caught
sh ../5-TEST/lr1ck --list                     # what each check is
```

`lr1ck` uses Emacs, node, gpg and awk when they are present, and says `SKIP ... NOT CHECKED` and
exits 2 when one is missing. A missing tool is never a pass. Exit codes: 0 pass, 1 fail,
2 not checked, 3 stopped unexpectedly (it prints a line to paste into a session).

To try the dispatcher by hand: `LARDER_PROFILE=hardened bin/lr1op --list`.

## Status

- The lists, flags and choices are generated, and two independent readers (the awk tangler and
  Emacs's own `org-babel-tangle`) produce the same bytes.
- Every package name was looked up in the Debian 13.7 package index, checked through its signed
  release file (`../5-TEST/evidence/PROVENANCE.txt`). That proves the names exist in the component
  named. It does not prove they install together.
- Every program a first-run choice starts (other than the unbuilt `larder-*` ones and our own `lr1st`) is a
  file in the package that choice needs, according to Debian's own file lists (check B17). That check
  caught a real mismatch in the first draft: `libreoffice` is shipped by `libreoffice-common`, not by
  the word processor package, so the choice now starts `lowriter`.
- The `larder-*` commands are **not built**. The spec names `larder-setup`, `larder-soft-reset` and
  `larder-wipe`; `larder-close`, `larder-assist` and `larder-notice` are this prototype's own placeholders
  for behaviour the spec describes without a name. The first-run choices name them; `bin/lr1op --run` exits 127 and says so when one is
  absent. The two shells are tested against the dispatcher, not against those programs.
- The author-edition notice is a draft. It carries no Dragaera text and no book content, and the
  stamp refuses to run until a real signature on a notice marked in force verifies.

## Licences

Code (`bin/`, `shell/`, `../5-TEST/lr1ck` and the other test code): GPL-3.0-or-later.
Text and data (`recipes.org`, `out/`, `author/`, this file, fixtures, evidence): CC-BY-SA-4.0.
Each file carries one SPDX line saying which. The SPDX line on the permission notice covers its
drafting only; it grants nothing in any work of the author.

The mesh add-on lists software whose licence is not free (see `out/addon-mesh.external`, column
"standing"). Nothing from it is copied into this prototype.

## What was not checked

- Nothing here was ever **booted**. No image, virtual machine or real laptop ran any of it.
- No **ISO** was built and no live-build was run. The flags were compared with live-build's own list
  of option names, not run.
- The package lists were not used for an **apt** install: names exist in the index, but dependency
  resolution, maintainer scripts, conflicts and disc size were not tried.
- The HTML page was run on a stand-in for the DOM, not in a real **browser**; how it looks, how it
  scrolls, whether the `larder:` link opens anything, and how it behaves with a real mouse, a
  screen reader or at other zoom levels are not checked. The Emacs frame ran in batch mode, not on a
  screen or a console with `gpm`.
- Which services a built image starts at boot was not checked. Debian packages normally enable the
  daemons they ship when installed (read in the maintainer scripts of `tor` and `gpm`, not run). There
  is no hook here to switch any off, so `tor` in `hardened` and the daemons in `homelab` would start.
- Only one awk was used (mawk 1.3.4) and one Org (9.6.15 in Emacs 29.3). **gawk**, busybox awk and
  other Org versions are not checked.
- The Reticulum licence conclusions come from licence texts read on the web on the day of writing;
  they were not checked with the project or a lawyer.
