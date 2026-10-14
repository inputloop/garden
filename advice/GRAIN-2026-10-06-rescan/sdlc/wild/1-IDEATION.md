<!-- SPDX-License-Identifier: CC-BY-SA-4.0 -->
<!-- Copyright (C) 2026 the Larder software contributors -->
# 1. Ideation

## What the group needs (my reading of PROBLEM.md and larder-spec.md)

The yardstick for every approach below. Eight needs, each from the two inputs and nothing else:

| # | Need | Where it comes from |
|---|------|---------------------|
| N1 | Boots and gets online on old, mixed, reclaimed laptops (BIOS and UEFI, Secure Boot, wifi that wants firmware) | spec: "any reclaimed laptop", "3+ reclaimed laptops" |
| N2 | A newcomer uses it with a mouse in minutes | PROBLEM.md item 2 |
| N3 | Stays patched for years with no paid sysadmin | spec: "durable"; volunteers |
| N4 | Volunteers can rebuild and audit it from one small source tree | spec: signed image, reproducible build in the repo |
| N5 | The stack the spec names is installable: LibreOffice, Nextcloud client, Kiwix, WireGuard, Reticulum | spec section 5 |
| N6 | Five profiles come from one source, and a sixth is cheap | PROBLEM.md item 1 |
| N7 | Licences let the group hand sticks out; the author's books do not tangle with the OS | PROBLEM.md, GPL/CC lines |
| N8 | A small team of volunteers can keep it going | the group itself |

## Seven approaches to the whole job

**A. Debian stable + live-build; profiles are package lists generated from one recipe file.** Build time picks the profile. First-run page is generated per profile so it cannot show a button for something the profile lacks.

**B. GNU Guix System; profiles are Guix manifests or operating-system files.** `guix system image` builds the stick; first-run lives in Emacs, which Guix users already have. Best story for reproducibility.

**C. Arch (or an Arch derivative) with archiso; profiles are `packages.x86_64` files.** Newest packages, very small base, rolling.

**D. Stock Debian Live ISO, untouched; `larder-setup` installs a profile at first run.** No image pipeline at all: the stick is the stock ISO plus a script and an offline package folder. Profile chosen at runtime.

**E. NixOS live image; profiles are NixOS modules.** Declarative like Guix, with unfree firmware available behind a switch.

**F. Debian, but each profile is a metapackage in a signed local apt repository** (the Debian "pure blend" shape). A stick can later move from `desktop` to `hardened` with `apt`.

**G. Minimal base + every application as Flatpak or an OCI image on the media partition.** Profiles are lists of images; the base hardly matters.

### How they score (my judgement, not measured)

`+` helps, `0` neutral, `-` hurts. The reasons are in the notes under the table, and 2-ANALYSIS.md says which of them I am least sure of.

| | N1 | N2 | N3 | N4 | N5 | N6 | N7 | N8 |
|---|----|----|----|----|----|----|----|----|
| A Debian + live-build + recipes | + (i386 caveat) | 0 | + | + | 0 | + | 0 | + |
| B Guix System | - | 0 | 0 | + | ? | + | + | - |
| C Arch + archiso | 0 | 0 | - | 0 | ? | + | 0 | 0 |
| D Stock Debian Live + runtime install | + | 0 | + | - | 0 | + | 0 | + |
| E NixOS | 0 | 0 | 0 | + | ? | + | 0 | - |
| F Debian + signed metapackage repo | + | 0 | + | + | 0 | + | 0 | - |
| G Minimal base + Flatpak/OCI | + | 0 | 0 | - | + | 0 | - | 0 |

- **B, N1:** the Guix manual says it builds on Linux-libre, so "only hardware for which free software drivers and firmware exist is supported" (fetched from guix.gnu.org). A stick that cannot bring up the wifi on a reclaimed laptop fails the first need.
- **C, N3:** a stick that sleeps in a drawer for four months and then takes a rolling update is a partial-upgrade accident waiting. Arch has no official 32-bit port (my memory, unchecked).
- **D, N4:** the spec promises that the e-ink shows the image hash and that the OS partition is read-only. Installing a profile after boot changes the running system, so the hash stops describing it.
- **F, N8:** someone must host, sign and rotate keys for a repository. Good later, heavy now.
- **G, N7:** one licence per application, and the size doubles.
- **N5 `?`:** I did not find out whether Guix, Arch or Nix package the Reticulum tools. Debian does not (2-ANALYSIS.md, R2), so for Debian the cell is `0`, not `+`.

## The pick: A, with four borrowings

**Debian 13 "trixie" stable, built with live-build, one recipe file generating every profile's lists.** Reasons, tied to the needs:

1. **N1 and N3 decide it.** Debian has the firmware, the signed boot chain and the hardware coverage, and a support window from 2025-08-09 to 2028-08-09 with LTS after (fetched from endoflife.date). The spec had already settled on Debian Live. I re-argued it from the needs instead of inheriting it, and it holds, except for i386 (2-ANALYSIS.md, R1).
2. **N8.** I expect more volunteers to know Debian than Guix, Nix or Arch, and a stuck newcomer's search results to be mostly about Debian (my judgement; I did not measure either).
3. **N4 without Guix.** The source of truth is one text file, `recipes.conf`, and a generator of about 200 lines of awk. That is the part of Guix's idea worth having; it needs no Guix.

Borrowings, so the other approaches are not wasted: from **B** the single declarative file; from **F** the option to turn each generated list into a metapackage later (the list format already is the dependency list); from **D** `larder-setup` stays a runtime script for the per-person things (name, PIN) while the profile stays fixed at build time; from **G** the Python mesh stack ships as a hash-locked payload that sits beside the Debian packages and is clearly labelled as not Debian.

## The first-run shell: three ways

1. **An HTML page in a kiosk browser.** Mouse-only is natural, no framework, doubles as readable documentation. Needs a browser, which is heavy for a 2 GB laptop, and needs a way to launch apps from a link.
2. **An Emacs frame of buttons.** Light, launches programs directly, no URL scheme needed. Strange to a newcomer if they press keys.
3. **Both, generated from the same list.** **Picked.** `minimal` and `homelab` get the Emacs frame (small, no browser); `desktop` and `hardened` get the page; `fullsink` gets both. If the browser's link handling fails on real hardware, the Emacs frame is the fallback that needs nothing from the browser.

## The author variant: five ways

1. **Put the books under a Creative Commons licence.** Rejected: it grants far more than fan works (copying and commercial use, depending on the licence chosen) and cannot require a "by permission" mark.
2. **A bespoke short notice plus a stamping tool.** **Picked.** The notice is the grant; `fanmark` stamps works with a mark that carries a hash of the exact notice relied on.
3. **A submission registry where the author approves.** Rejected: the brief says the author does not read the works.
4. **"Ask me first" in a README.** The status quo most authors have; no one can rely on it.
5. **A separate edition image per author.** Rejected: every edition would have its own OS hash to sign and verify. Picked instead: the OS image is the same for everyone, and an edition is data on the media partition.
