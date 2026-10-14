<!-- SPDX-License-Identifier: CC-BY-SA-4.0 -->
# 2. Analysis: constraints, risks, unknowns, and what would prove the pick wrong

Garden team, 2026-10-06. Stage 2 of 6. The pick is in `1-IDEATION.md`: Debian 13 "trixie" with
live-build and canned lists, an HTML page where there is a desktop, an Emacs frame where there is only
a console, the author's edition as an overlay.

Notation is the same as stage 1. OBSERVED is what I read, with where. JUDGED is my reading. The dagger
mark sits on a claim that rests on one source. Each risk names whose concern it is in words and has a
falsifier: what would show it is not a problem, or that it is. A risk that says "not done" means the
prototype did not run that falsifier. Numbers 4, 9 and 17 are the house set and are invented; each says so.

## Constraints

- K1. Offline first. The library is offline and the first boot may have no network (`larder-spec.md:93`).
  The prototype itself uses no network and no root (`PROBLEM.md:33-34`).
- K2. Reclaimed laptops of mixed age: BIOS-only, UEFI and Secure Boot (`larder-spec.md:156`). Minimum
  specs are not yet written (`:160`).
- K3. Persistence is encrypted and PIN-gated, the OS image is read-only, and nothing readable leaks
  (`larder-spec.md:10-19`, `:88`). None of that is in this prototype; it constrains what must not be
  in the way of it (no swap, no daemon that writes secrets).
- K4. A newcomer needs only a mouse (`PROBLEM.md:11`). Every visual follows the system's light or dark
  setting, with an override that works both ways, and contrast is measured (`garden-context.md:44-48`).
- K5. Licences: code GPL-3.0-or-later, text CC-BY-SA-4.0, one SPDX line per file (`PROBLEM.md:34-35`).
  `garden-context.md` says code `GPL-3.0-or-later OR LGPL-3.0-or-later`; I followed the brief and the
  shop's practice of the plain form (a one-line change per file if the shop wants the other).
- K6. No Dragaera text anywhere; the permission notice is a draft for the author and his counsel,
  not a grant (`garden-context.md:26-27`).
- K7. No packages installed, no image built, no network in the build.
- K8. House rules: POSIX shell and awk first; two readers where one would be data; prove-red with exit
  codes 0, 1, 2, 3; say what was not checked (`garden-context.md:50-66`).
- K9. Nothing phones home and nothing is hidden from the person using it (`garden-context.md:65-66`).

## Risks

### R1. The spec asks for a 32-bit image and trixie has none
- Whose concern: the group's, from the spec line for old machines (written by Brigidt).
- OBSERVED: `larder-spec.md:86` says "amd64 (+ i386 image for old machines)". Debian's 13 release notes:
  "From trixie, i386 is no longer supported as a regular architecture: there is no official kernel and
  no Debian installer for i386 systems." The official live page: "Currently only images for 64-bit PC
  (amd64) are provided."
- JUDGED: on this base the 32-bit laptops are not served. The prototype says `--architecture amd64`.
  The options are a bookworm i386 build (a second build with its own end of life, which I did not look
  up), a Guix image (Corwin's note says Guix ships i686 images†), or the small-and-old route A7.
- Falsifier: count the reclaimed laptops the group has that are 32-bit only (unknown U1). If none of
  nine (9 is invented), the risk is gone. If more than four of them (4 is invented), trixie is the wrong
  base for this group's hardware.
- Status: handled only by saying so; not counted.

### R2. The Reticulum stack is not in Debian, and its licences carry conditions
- Whose concern: Corwin's (freedom 0 and the movement), the group's (stick sales and the
  non-commercial clause), and counsel's.
- OBSERVED: I searched the names and descriptions in the trixie main index (amd64 and all) for
  Reticulum, LXMF, NomadNet, Sideband and RNode: no match. The upstream `LICENSE` files, read on
  2026-10-06 from each project's master branch: Reticulum and LXMF carry the "Reticulum License", an
  MIT-style grant plus "The Software shall not be used in any kind of system which includes amongst
  its functions the ability to purposefully do harm to human beings" and a bar on use "in the creation
  of an artificial intelligence, machine learning or language model training dataset"†. Sideband is
  CC BY-NC-SA 4.0†. NomadNet is GPL-3.0†. The spec lists all of them inside the Debian Live build
  (`larder-spec.md:154`).
- JUDGED: a condition on what the software may be used for is a condition on freedom 0, whatever its
  aim. Whether selling a stick that carries Sideband is "commercial" is a legal question I am not
  answering. The stack can only arrive by `pip` or a flatpak at provisioning; I assumed that and did not
  try it.
- Falsifier: read the licence at the tag a build would actually install (I read master), and ask the
  licensor. If the installed version is under a standard free licence with no use conditions, the risk
  is gone.
- Status: kept out of the four free profiles; carried as `out/addon-mesh.external` with a "standing"
  column (free or restricted) and present in `fullsink` only. Not installed; not tried.

### R3. Firmware, and the FSF's position on Debian
- Whose concern: Corwin's (he speaks for the FSF "on behalf, not as it": door-images LENS, board 4) and
  a newcomer whose laptop will not reach Wi-Fi without firmware.
- OBSERVED: the FSF's common-distros page: "Until 2022, Debian GNU/Linux came fairly close to
  qualifying as a free distro", then names firmware offered by the Debian 12 installer, the `contrib`
  repository, and non-free plug-ins suggested by Debian's Firefox†. Debian's official media have carried
  non-free firmware since Debian 12 (a Debian Libre Live announcement and a forum thread, not a Debian
  page). The ten firmware names I list are in `non-free-firmware`, checked against the signed index.
  Corwin's own note: "on Guix the home user meets a second lack ... many laptops' Wi-Fi needs non-free
  firmware".
- JUDGED: the right default is not mine to set. The four free profiles are main-only with firmware
  switched off in the build flags, and firmware is a separate list; a laptop that needs it needs the
  add-on or `fullsink`.
- Falsifier: boot `desktop` on four laptops (4 is invented) and count the ones that reach a network. If
  fewer than three do, the free default fails this group's hardware and firmware belongs in `desktop`.
- Status: not done. `lr1ck` B9 and B10 fail if a free profile ever holds a non-free firmware name.

### R4. Secure Boot is claimed, not shown
- Whose concern: the group's (`larder-spec.md:87`, `:156`).
- OBSERVED: live-build's own source installs `shim-signed` and the signed GRUB when `--uefi-secure-boot`
  is `auto` or `enable` (read, not run†; PROVENANCE item 2). The flags say `enable`. A 2022 guix-devel
  message says Guix lacks complete Secure Boot support†. I could not read the Arch wiki's page on it
  (an access-denied page).
- JUDGED: a signed chain from Debian does not mean it boots on a given laptop (key databases, vendor
  quirks), and what the stick adds to the squashfs sits outside the signature.
- Falsifier: the spec's own test: boot on three or more laptops covering BIOS-only, UEFI and Secure Boot.
- Status: not done.

### R5. Packages start daemons by themselves
- Whose concern: the group's threat model (a network observer, and Tor "optional", `larder-spec.md:90`)
  and Corwin's "nothing is hidden from the person using it".
- OBSERVED: the `postinst` of `tor` and of `gpm` (each .deb's sha256 matched the signed index; the
  scripts were read, not run) calls `deb-systemd-helper enable` on a first install ("was-enabled
  defaults to true, so new installations run enable")†. My first draft of the recipe said Tor was
  "available but not started for anyone"; that was wrong and is corrected. The `homelab` list holds
  `nginx`, `postgresql`, `prometheus-node-exporter`, `i2pd`, `fail2ban` and `libvirt-daemon-system`;
  `hardened` holds `tor`.
- JUDGED: after a build these services will be enabled unless a hook switches them off. The prototype
  has no hooks. For `homelab` that may be intended; for `hardened` it is not.
- Falsifier: boot the built image; `systemctl list-unit-files --state=enabled` and `ss -ltn` must match a
  written allow-list for the profile. Any extra listener fails.
- Status: not done; the next step is a generated per-profile list of services to disable.

### R6. The `larder:` links in a kiosk browser
- Whose concern: a newcomer's (invented: I have no words from one) and the mouse-alone promise.
- OBSERVED: each button on the page is a link to `larder:ID`. A browser needs a registered handler for a
  custom scheme. That handler is not built.
- JUDGED: Firefox may ask the person to confirm opening an outside program, or do nothing. I did not
  test it, and I believe but did not check that `firefox-esr --kiosk` exists.
- Falsifier: boot the image and click each button once. Any dialog, or any button that starts nothing,
  fails "plain choices, mouse alone".
- Status: not done.

### R7. The author's permission model: a standing notice against a written OK
- Whose concern: the author's and his counsel's; Corwin's as managing partner.
- OBSERVED: Corwin described to his father "publishing with a 'by permission' watermark, so readers can
  have authorized fan fiction without Dad reading any of it" (`garden-context.md:12-13`). The terms from
  the 08-01 call, and a proposal that is not yet ratified: anything containing or derived from his works
  publishes only with his written OK (`:22-25`). The Creative Commons FAQ says "CC licenses are not
  revocable"† and that a licensor "may stop distributing under the CC license at any time, but anyone
  who has access to a copy of the material may continue to redistribute it". Amazon's licensed
  fan-fiction programme Kindle Worlds opened in May 2013 and was shut in August 2018†.
- JUDGED: a permission given once for a class of works is not a written OK for each work. If "written OK"
  means each, the standing notice is the wrong instrument. If it means a standing OK, the author accepts
  works he has not read, and the mark must not say he did; the draft's second line says he did not. A
  custom notice is not a Creative Commons licence, so the CC FAQ is an analogy and not an authority.
- Falsifier: ask him the first question in the notice's list. If the answer is "I want to see each
  one", the model is wrong and the notice should become a request process.
- Status: the notice is a draft with questions for counsel; nothing signs or stamps anything.

### R8. Rights have to be checked per title and per right
- Whose concern: the author's, his counsel's, and any publisher's contract.
- OBSERVED: publishers hold print licences, not the rights; the author holds every other right unless he
  sold it (audio usually sold; one audiobook he self-produced) (`garden-context.md:19-21`). The gate
  `lr1bk` lets a row through only when the right is text, audio or other, "sold by author" is `no`,
  and someone and a date are named. The shipped list has two placeholder rows and lets none through.
- JUDGED: the gate checks that a person wrote "no" and who they are. It cannot know the truth.
- Falsifier: counsel checks two real titles against two rows. Any disagreement means the process needs
  work, not the code.
- Status: placeholders only; no title is named.

### R9. The mark could be read as the author's endorsement
- Whose concern: the author's.
- OBSERVED: the mark is two lines: "Published by permission of {AUTHOR} under permission notice
  v{VERSION}. {AUTHOR} has not read, reviewed or endorsed this work."
- JUDGED: the second line is the point; "by permission" alone could mean he approved the story.
- Falsifier: show the mark to four readers (4 is invented) with no context and ask whether the author read
  the story. One "yes" fails it.
- Status: not done.

### R10. Two readers that share more than they should
- Whose concern: the shop's (the seams doctrine).
- OBSERVED: the awk tangler and Emacs's `org-babel-tangle` are separate programs and `lr1ck` B5 changes the
  recipe and watches both move. Only mawk 1.3.4 and Org 9.6.15 were run. The page script was run on a
  hand-made stand-in for the DOM, not a browser. The Emacs frame was run in batch mode only.
- JUDGED: the awk reader accepts a strict subset of Org on purpose and refuses the rest, so agreement
  means "the subset agrees", not "Org agrees about everything".
- Falsifier: run the checks under gawk and busybox awk and under a second Org version. If the readers
  then differ, reader one is wrong or the subset leaked.
- Status: not done.

### R11. The pipeline may be too heavy for the people who inherit it
- Whose concern: a volunteer maintainer's (invented: the inverse persona of stage 1).
- OBSERVED: changing one package touches Org, sh, awk and a test script; changing a choice also touches
  Emacs Lisp, JavaScript and HTML with CSS.
- JUDGED: easy for the author, possibly costly for the next person.
- Falsifier: someone who has not seen the repository adds one package, sees the test go green and sees it
  go red for a typo, in under 17 minutes (17 is invented). Longer, and plain files win.
- Status: not done.

### R12. The evidence goes stale
- Whose concern: whoever maintains the lists.
- OBSERVED: package names were checked against the Debian 13.7 index of 2026-09-12 and the programs
  against that release's file lists. `lr1ck` checks the lists against that frozen copy.
- JUDGED: after a point release a renamed package passes this test and fails the build. The test cannot
  see this without a network.
- Falsifier: repeat the fetches in `PROVENANCE.txt` against a newer index and compare.
- Status: not done.

### R13. Every copy handed out carries a duty to supply its source
- Whose concern: the group as the distributor; Corwin raised it for the door images.
- OBSERVED: his board 5 quotes GPLv3 section 6: object code on a physical medium goes "accompanied by
  the Corresponding Source fixed on a durable physical medium customarily used for software
  interchange" or "a written offer, valid for at least three years" (door-images LENS, lines 148-170).
- JUDGED: this prototype carries neither a source medium nor an offer. It is one more thing a first batch
  needs.
- Falsifier: take one built stick from the first batch and ask where its source or its offer is. No
  answer fails.
- Status: not built.

## Unknowns

- U1. How many of the group's reclaimed laptops are 32-bit only. Find out by counting; ask each chapter.
- U2. How many are BIOS-only, UEFI, or Secure Boot, and which of them boot this image. Find out by the
  three-laptop boot test.
- U3. Whether `lb build` with these lists succeeds (dependency conflicts, image size). Find out by a
  build in a trixie virtual machine.
- U4. Whether a Firefox kiosk opens `larder:` links without a dialog (R6).
- U5. What the author wants: a standing permission or a look at each work; which rights he holds in
  which titles. Counsel's and his to answer.
- U6. Whether the Reticulum licences at the installed version carry the same conditions, and whether the
  non-commercial clause reaches the sale of sticks (R2).
- U7. What I did not check on the rival bases: whether Guix or Arch package the Reticulum stack or Kiwix,
  Secure Boot on Arch's ISO (refused), and whether Parabola is alive (its front page shows no dates†,
  and Corwin's note found no dated news after 2022-11-08).
- U8. Names and marks: the spec asks for a check of "Larder" before labels are printed
  (`larder-spec.md:3`), and I did not look at the rules for calling a derived image after Debian.
- U9. Whether Corwin will accept Debian as the base, given the FSF's position. This is the pick's largest
  social risk and the first thing I would ask him.

## What would prove the pick wrong

Each line is a measurable event. None has happened; none was tried.

- P1. Hardware. On nine of the group's laptops (9 is invented), if more than four (4 is invented) cannot
  boot amd64 trixie because they are 32-bit only or have dead hardware, trixie is the wrong base. Look at
  Guix's i686 image or at A7.
- P2. The free default. On four laptops (4 is invented), if fewer than three reach a network with `desktop`
  as generated, the free default fails this group. The choice then is firmware in `desktop`, or Guix.
- P3. Secure Boot. If Debian's signed chain does not boot on the Secure Boot laptops of the three-laptop
  test, the base is wrong in the spec's own terms.
- P4. Upkeep. If the 17-minute test (17 is invented) fails, the Org and two-reader pipeline is too heavy
  and plain files replace it.
- P5. The movement. If Corwin or the group rules that the stick must be a distribution the FSF lists, Guix
  (A2) wins whatever else is true. The pick is cheap to reverse in one respect: the lists and flags are the
  only Debian-specific files. The page, the Emacs frame, the dispatcher, the tests and the author overlay do
  not depend on the base. That is my judgement, not a test.
- P6. The author. If he wants to see each work, the notice and the stamp are the wrong part. The base is
  unaffected.
- P7. Cost. If getting one image to boot takes more than nine hours of fixing (9 is invented) after the
  first `lb build`, the cheaper path may be A5 or A6.

## What this analysis does not claim

The prototype boots nothing and builds nothing, so none of P1 to P3 is tested. The facts here come from
reading: the three briefing files, four files of Corwin's, the web, and the signed Debian index.
`6-REVIEW.md` says which came from the web.
