<!-- SPDX-License-Identifier: CC-BY-SA-4.0 -->
# 3. Design: the software side of Larder

Garden team, 2026-10-06. Stage 3 of 6. The pick (`1-IDEATION.md`) is Debian 13 "trixie" built with
live-build from lists generated out of one Org file, with a first-run shell in two forms and an author's
edition as an overlay. The prototype is in `4-BUILD/`. Everything described here is either built there and
tested by `5-TEST/lr1ck`, or says plainly that it is described and not built.

## Scope

In: the package lists and build flags for five profiles; the first-run shell; the dispatcher both shell
forms call; the author's edition (a book gate, a draft permission notice, a stamp); the tests.

Out, because the spec puts them elsewhere or they need hardware: the secure element and the PIN unlock,
the LoRa radio and its firmware, the e-ink display, the write-protect switch, LUKS persistence, the
chapter server's services, reset and recall, and the `larder-*` programs themselves.

## Architecture

```
  recipes.org                  the one source (Org). Prose and code blocks together.
     |                         Edit this. Never edit out/.
     |--- reader one:  bin/lr1tg  (POSIX awk, strict subset)
     |--- reader two:  Emacs org-babel-tangle                   they must give the same bytes
     v                                                          (lr1ck B4; B5 changes the source
  out/                                                           and watches both move)
     PROFILE.packages   PROFILE.lbflags        for each of the five profiles
     addon-firmware.packages   addon-mesh.external   fullsink.external
     profiles.txt   choices.txt   author.packages
     |
     |   NOT RUN HERE:  lb config <flags>;  cp PROFILE.packages config/package-lists/larder.list.chroot;
     |                  lb build        ->  one hybrid ISO per profile (Debian 13, amd64)
     v
  the stick's operating system (read-only image, the spec's persistence and keys on top)
     |
     |   first boot (autostart not built):
     |       desktop profiles:  firefox-esr --kiosk file:///usr/share/larder/first-run.html
     |       console profiles:  emacs-nox -nw -Q -l larder-first-run.el -f larder-first-run
     v
  the first-run shell     two forms, one list: both read choices.txt, both start bin/lr1op
     |    shell/first-run.html        links  larder:ID   (the handler for larder: is not built)
     |    shell/larder-first-run.el   buttons
     v
  bin/lr1op                 the one dispatcher:  --list | ID | --run ID
     v
  a program the choice names:  kiwix-desktop, lowriter, foliate, mpv, mousepad  (all in Debian)
                               larder-setup, larder-close, larder-assist, larder-notice  (not built)

  author's edition (an overlay, not a sixth profile):
     desktop or fullsink  +  author.packages  +  five author choices
     +  author/books.org gated by bin/lr1bk  +  author/PERMISSION-NOTICE.md (a draft)
     +  bin/lr1st, which stamps a fan work only if the notice is in force AND the author's signature verifies

  5-TEST/lr1ck   reads all of the above, plus evidence/ (Debian's signed index, live-build's own option list,
                 Debian's file lists), and can plant faults in a copy and show itself catching them
```

Two properties drive the shape. First, the shell, dispatcher, tests and author overlay do not depend on the
base: only the lists and flags are Debian-specific (my judgement, not a test), so a change of base is a rewrite of
two kinds of generated file. Second, two forms of the shell cannot offer different things, because they
read one file and hand every click to one program, and a test compares four readers of that rule.

## The five profiles

A profile is a union of package groups. Each package is in exactly one group, so a duplicate is a mistake the
test can see. All five are Debian 13 amd64. The numbers are lines of package names in `out/PROFILE.packages`
(comment lines not counted); `lr1ck` check E2 compares this table to the files.

| profile | for whom | shell | groups | packages | firmware |
|---|---|---|---|---|---|
| minimal | a shell that boots, unlocks and joins a network | emacs | boot core token console vtmouse | 34 | off |
| desktop | the everyday desktop for members and new organizers | html | boot core token console xfce access apps apps-more media | 62 | off |
| homelab | a headless chapter server ("pantry box") | emacs | boot core token console vtmouse onion server | 51 | off |
| hardened | the desktop with fewer parts and more guards | html | boot core token console xfce access apps hardening onion | 72 | off |
| fullsink | everything in this file, including what some will not want | html | every group, including firmware | 113 | on |

In words:

- **minimal.** A text console with Emacs, Git and tmux, the console mouse daemon, the tools for a smart card
  or security key, WireGuard and SSH. It boots, unlocks and joins a network, and nothing else. For a person or
  a chapter that wants the smallest thing to audit.
- **desktop.** The profile most people get. XFCE, a browser, a word processor, a spreadsheet, a PDF viewer,
  slides, mail, the Nextcloud client, the offline library (Kiwix), an on-screen keyboard and a screen reader, one
  media player. Its first-run shell is the HTML page.
- **homelab.** The chapter's server, headless: containers, a web server, a database with geographic
  extensions, a library server, monitoring, virtual machines, a tool that bans addresses after repeated failures, Tor and I2P. Its shell is the
  Emacs frame on a console. Several of these start by themselves when installed (risk R5).
- **hardened.** The desktop without slides, mail or media, plus mandatory access control, a firewall, a USB
  policy tool, audit, sandboxing, a password vault and Tor. The extra guards are only packages: this prototype
  writes no configuration for them, so some (the firewall, the USB policy) may guard nothing until someone
  configures them. I did not check which defaults Debian ships. I say so because the name promises more than
  the lists deliver.
- **fullsink.** Every group, including the firmware list and the tools for making things (QGIS, FreeCAD,
  KiCad, GIMP and others). It is the only profile built from `main` and `non-free-firmware`, and the only one
  that carries the mesh add-on list.

The groups, each a block in `recipes.org`: `boot` (kernel, initramfs, encrypted-disk plumbing, free
firmware only), `core` (shell tools, network, WireGuard, GnuPG, SSH), `token` (smart-card and FIDO2 tools,
the software stand-in for the secure element), `console` (Emacs without a window system, Git, tmux),
`vtmouse` (the mouse on the Linux console), `xfce`, `access`, `apps`, `apps-more`, `media`, `hardening`,
`onion`, `server`, `maker`, `author`, `emacs-gui` and `firmware`.

### Build flags

Each profile has a `.lbflags` file: `lb config` options, one per line. Every profile says
`--distribution trixie --architecture amd64 --binary-image iso-hybrid --debian-installer none
--uefi-secure-boot enable --firmware-chroot false --firmware-binary false`. They differ in
`--archive-areas` (`main`; `fullsink` adds `non-free-firmware`), `--apt-recommends` (true for `desktop` and
`fullsink`, false for the other three) and `--iso-volume`. Every option name is checked against live-build's
own list from the version in trixie. No `lb config` or `lb build` was run.

### The two add-ons, kept out of the four free profiles on purpose

- **Firmware**: ten packages from Debian's `non-free-firmware` component (Wi-Fi, graphics, microcode). A
  builder adds `out/addon-firmware.packages` as a second list and widens `--archive-areas`. Many reclaimed
  laptops will not reach Wi-Fi without it, and the FSF does not list Debian as a free distribution partly for
  this reason†. It is its own file so it is chosen knowingly.
- **Mesh** (Reticulum): not in Debian. `out/addon-mesh.external` lists four rows with a licence and a standing:
  `rns` and `lxmf` (the Reticulum License, restricted), `nomadnet` (GPL-3.0, free) and `sideband` (CC BY-NC-SA
  4.0, restricted). A free profile never carries it. How the rows would be installed (`pip` or a flatpak at
  provisioning) is an assumption I did not try.

## The first-run flow

What a newcomer meets, in plain words, and what is and is not built.

1. The stick boots and the computer starts the first-run shell by itself. *Not built:* autologin and the
   launcher that starts it. Described: on a desktop profile the browser opens the page full screen; on a
   console profile Emacs opens its frame in a terminal.
2. One window, titled "Welcome", says "Pick one. You can come back to this page whenever you like." and shows a
   short list of large choices, each a label and one plain sentence. On `desktop` there are six:
   - **Look around first.** Nothing you do here is kept when you turn the computer off.
   - **Make my private space.** You choose a PIN. Your files stay on this stick, locked.
   - **Join my group.** Connect to your group's server, using the file a facilitator gave you.
   - **Open the library.** Read books and guides without the internet.
   - **Write a document.** Open a word processor.
   - **Ask for help.** Someone you trust can see your screen, only while you allow it. You can stop at any time.

   The console profiles show the first three and the last (no library or word processor: no desktop).
3. A mouse is enough. On the page each choice is a link at least 4.5 rem tall (the three colour buttons
   3 rem); in Emacs each is a button that follows a click, and on the bare Linux console `gpm` makes the
   mouse work (not tried on a real console). Tab and Return also work; no one needs them.
4. The colours follow the computer's own light or dark setting. Three buttons, "Follow my computer", "Light"
   and "Dark", override it, and each works whatever was chosen before. Light is the complete default; dark
   follows the system unless light was chosen, and a person who chose dark gets it either way. Contrast is
   measured, not looked at (see Accessibility). The Emacs frame does not follow the system setting (Emacs 29
   has no portable way to ask); it shows Light, Dark and "Emacs default" buttons on a graphical display and
   none on a text terminal, where the terminal's colours govern.
5. A click hands the choice's id to `bin/lr1op`, which looks it up in `choices.txt` and starts the program. If the
   program is not installed it says so in words (exit 127). If the choice is not offered on this edition it says
   "is not offered on this edition" (exit 4). The Emacs frame shows that line under the buttons.
6. Nothing on the page contacts the internet: it has no outside address, script, stylesheet, font or image, a
   Content-Security-Policy that allows nothing else, and says so in its footer.
7. The person can close the window at any time and come back to it.

Not built and so not shown to work: the `larder:` link handler (the page's links need one; risk R6), every
`larder-*` program, and the start-up itself. The page and the frame were run against the dispatcher with stand-ins
(a stand-in for the page's DOM; Emacs in batch mode), not on a screen.

### How the two forms stay the same

`out/choices.txt` has one row per choice: `id|edition|profiles|needs|label|plain words|command`. A choice is offered
when its edition is `base` or the stick's own edition and its profiles are `*` or include the stick's profile.
Four readers of that rule must agree for every profile and edition: the dispatcher (shell), an independent awk
statement of the rule, the Emacs frame (Lisp) and the page's own script (JavaScript on a stand-in DOM). The
page's text is written by hand and checked against `choices.txt` (ids, order, labels, words). `needs` is a
package that must be in every profile offering the choice, and each program a choice starts must be a file in that
package according to Debian's own file lists.

## The author's edition

For the author of the Dragaera books (Corwin's father, Steven Brust). It is `desktop` (or `fullsink`) plus
`author.packages` (an e-book reader and a converter), plus five more choices that appear only on that edition:
**Read a book**, **Listen to a book**, **Write a fan work**, **Mark my story by permission**, **Read the
permission notice**.

It carries no Dragaera text, no book, no audio and no cover; `lr1ck` fails if an e-book, audio or document file
is found, or if `author/` holds anything but the notice and the book list. What it does carry, in `4-BUILD/author/`:

- **The book gate** (`books.org`, `bin/lr1bk`). One row per title and per right, because a publisher holds a print
  licence for a time and a number of copies, not the rights, and the author holds the rest unless he sold it
  (audio usually sold). A row may be marked `yes` only when the right is text, audio or other; "sold by author"
  is `no`; and someone is named and a date given. Anything else is refused with a line number. The shipped list
  has two placeholder rows and lets none through. Jon collects the texts; whether each right is sold is the
  author's and his counsel's to say, and nobody here guesses it.
- **The permission notice** (`PERMISSION-NOTICE.md`). A draft in plain words for the author and his counsel. It is
  headed STATUS: DRAFT, SIGNED: no, "not legal advice", and "grants nothing". It sets out seven clauses (who may
  write and share, what is not allowed, the mark, that the author does not read fan works, how it is taken back,
  works made with AI help, and that it covers only what he owns) and a list of questions, the first of which is
  whether a standing permission is what he means by a written OK.
- **The mark.** Two lines: "Published by permission of {AUTHOR} under permission notice v{VERSION}. {AUTHOR}
  has not read, reviewed or endorsed this work." The second line is there so that "by permission" cannot be
  taken to mean he approved the story.
- **The stamp** (`bin/lr1st`). It prints the mark around a finished fan work, and it refuses unless the
  notice says STATUS: IN FORCE and the author's detached signature on the notice verifies against his key ring.
  The status line is text anyone can edit; the signature is the gate. The shipped draft is refused; a
  throwaway key in the tests shows success, a notice edited after signing refused, an unsigned notice refused
  and a signature from some other key refused.

### How this model could be wrong

The notice is a standing permission: given once for a class of works. The author's proposal, not yet ratified,
is that anything derived from his works is published only with his written OK. A standing permission is not
that. If he means each work, the notice and stamp are the wrong part and the answer is a request process.
`2-ANALYSIS.md` R7 says so, and the first question in the notice asks him.

## Accessibility

Light is a complete default on `:root`. Dark is in `@media (prefers-color-scheme:dark)` under
`:root:not([data-theme="light"])` and again under `:root[data-theme="dark"]`, and the two dark sets are identical
(a test compares them). `html{color-scheme:light dark}` and an explicit body background are set. Every colour
names the Modus theme value it copies, and a test reads Emacs's own copy and compares. Contrast is measured for
all 30 pairs in the three palettes: body text at 7:1, secondary text and links at 4.5:1, borders and the focus ring
at 3:1; the thinnest margin over its floor is secondary text on the card in the light palette, at about 7.1:1 against a floor of 4.5. Two programs (awk
and node) compute the ratios separately and must agree. Not measured: how it looks, scroll, zoom, a screen reader.

## Interfaces assumed from the spec, not built

- `larder-setup`: the spec's signed provisioning script (`larder-spec.md:95`); the choices "Make my private space"
  and "Join my group" call it with `persistence` and `chapter`.
- `larder-soft-reset` and `larder-wipe`: named in the spec; no choice calls them in this prototype.
- `larder-close`, `larder-assist`, `larder-notice`: this prototype's own placeholders for behaviour the spec describes
  without a name (end the amnesic session, learner-initiated screen share with a helper module, show the permission
  notice). They are not in the spec.
- `lr1op --run` exits 127 and says so when any of them is absent.

## What is described and not built

- The autostart of the shell (a desktop launcher or a systemd user unit) and the `larder:` link handler.
- A hook to switch off services that Debian enables at install (risk R5).
- Any `lb config` or `lb build`, and so any image, boot, or Secure Boot behaviour.
- Source for every copy handed out, or a written offer (risk R13).
- The secure element, the PIN, persistence, reset and recall: the rest of the spec.
