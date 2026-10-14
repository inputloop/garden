<!-- SPDX-License-Identifier: CC-BY-SA-4.0 -->
<!-- Copyright (C) 2026 the Larder software contributors -->
# 2. Analysis

Tags: **[web]** came from a page I fetched, named at the end of 6-REVIEW.md. **[mem]** is my own knowledge and I did not check it. **[obs]** I observed it by running something here.

## Constraints

**Given by the brief and the spec**
- C1. Five profiles: `minimal`, `desktop`, `homelab`, `hardened`, `fullsink`. One kiosk-style first-run shell, mouse-only, no heavy framework. One author edition.
- C2. The prototype runs in a plain Linux shell with no network and no root; it builds no ISO and installs nothing.
- C3. Code GPL-3.0-or-later, text CC-BY-SA-4.0, SPDX lines.
- C4. Spec: Debian Live, XFCE, amd64 **and i386**, signed image, read-only OS squashfs, LUKS2 persistence, a media partition, the application list in section 5.

**Chosen by me**
- C5. Debian 13 stable as the base (1-IDEATION.md).
- C6. Profile is fixed at build time. Runtime variation is data (an edition), never packages.
- C7. Shell and awk only for the generator and the tools, so a volunteer can read and change them.
- C8. Whatever Debian does not carry is labelled, not hidden (`pip:` entries in the recipes).

## What I checked

| Fact | Source | Result |
|------|--------|--------|
| Debian 13 has no i386 kernel, installer or regular i386 port | **[web]** debian.org/ports/i386 | Confirmed. The page recommends reinstalling as amd64 or retiring the hardware. |
| Debian 13 was released 2025-08-09; latest point release at fetch time 13.7 (2026-09-12); security support to 2028-08-09; LTS to 2030-06-30 | **[web]** endoflife.date/debian | Confirmed on that page. |
| Bookworm (12): security support ended 2026-07-11; LTS to 2028-06-30 | **[web]** endoflife.date, debian.org/releases | Confirmed. Whether LTS covers i386 for bookworm: **not found**. |
| Guix supports only hardware with free drivers and firmware | **[web]** guix.gnu.org manual, Hardware Considerations | Confirmed, quoted in 1-IDEATION.md. |
| Reticulum licence is MIT plus two extra clauses: no use in systems able to harm humans; no use in AI/ML training sets | **[web]** raw LICENSE of markqvist/Reticulum, "Copyright (c) 2016-2026" | Confirmed as quoted. |
| Sideband (PyPI `sbapp`, 2.2.0, 2026-10-01) is CC BY-NC-SA 4.0 with a grant to use binaries "so long as no payment or compensation is charged or received for such distribution or use"; uses Kivy; the page says Python 3.13 is not compatible with Kivy | **[web]** pypi.org/project/sbapp | Confirmed as quoted. |
| Debian's pool has source directories for `kiwix`, `kiwix-tools`, `nextcloud-desktop`, `matchbox-window-manager`, `i2pd`, `usbguard`, `mat2`, `torsocks`, and none for `rns`, `python-rns`, `reticulum`, `nomadnet`, `sideband`, `lxmf` | **[web]** deb.debian.org/debian/pool/main/... (a missing directory gives 404, an existing one a redirect; a made-up name gave 404) | Confirmed, with the limit that the pool holds every suite, so "present" does not say "in trixie", and "absent" covers only those spellings. |
| live-build negative apt pins keep a package out; package lists are `config/package-lists/*.list.chroot` | **[web]** live-manual, "Customizing package installation" | Confirmed. The same page says nothing on `#` comments in lists. |
| Debian 13's Python is 3.13 | **[mem]** | Not checked. |
| Debian 12 and later have a `non-free-firmware` archive area and the `firmware-*` and `*-microcode` packages are in it | **[mem]** | Not checked; the live-manual page I read does not mention it. |
| The other package names in `recipes.conf` exist in trixie | **[mem]** | Not checked. Run the check in R9. |
| The scripts run under `dash`; the el pages byte-compile clean and every button fires under Emacs 29.3 in batch mode | **[obs]** | 5-TEST/output-run.txt |

## Risks

Each has a way to find out that it has come true. A risk with no such test would be a mood, not a risk.

**R1. The base pick contradicts the spec on i386.** The spec wants "+ i386 image for old machines"; Debian 13 has none **[web]**.
*Falsifier:* count 32-bit-only machines in the group's actual pile. If they are more than a handful, either run a separate legacy track on bookworm (LTS to 2028-06-30 **[web]**; i386 coverage unknown) or accept losing them. If 64-bit machines cover nearly everyone, the pick stands and the spec line should be struck.

**R2. The mesh stack is not Debian and not DFSG-free.** Reticulum carries field-of-use restrictions; Sideband is non-commercial **[web]**. Debian's main archive cannot carry either (consistent with their absence from the pool **[web]**). They ride as `pip:` entries, which in the generator land in `<profile>.pip` as names only.
- Supply chain: pip at image-build time pulls from the network. Names are not pins. A real build must lock versions and hashes, vendor the wheels, and install offline.
- Distribution: the Sideband grant is for no-charge distribution. If the group charges members for sticks, even at cost, **I cannot say** whether that is "payment or compensation ... for such distribution". That is a question for the group and, if it matters, a lawyer. If it matters, ship NomadNet only and say why. The NomadNet licence I did not check.
- GPL: the OS and these two ship as an aggregate, not a combined work; nothing in the prototype links to them. That is my reading, not advice.
*Falsifier:* anyone with standing (the group, the Sideband author, counsel) says charging for the stick is a problem, or Reticulum's AI-training clause conflicts with how the group intends to use the radios.

**R3. Sideband may not run on trixie.** The project page says Python 3.13 is not compatible with Kivy **[web]**; trixie's Python is 3.13 **[mem]**. The first `chat` choice in `recipes.conf` is Sideband, the second is NomadNet in a terminal.
*Falsifier:* on a clean trixie chroot, `sbapp` installs and its window opens. If not, swap the two `choice chat` lines. One edit in one file is what the single source buys.

**R4. Freedom against firmware.** Reclaimed laptops often need non-free wifi firmware. Debian can carry it in `non-free-firmware`; the recipes flag it `nff`, `<profile>.areas` says whether the build needs that area, and `FREE_ONLY=1` removes all of it. Guix would have refused outright **[web]**.
*Falsifier:* build `FREE_ONLY=1`, boot the group's actual laptops, count how many get no network. That number is the price of the free-only variant.

**R5. `hardened` is only partly a package list.** Presence is a list. Absence is not: Recommends pull things back in. I use negative apt pins **[web]**, written to `<profile>.preferences`. Real hardening is also kernel parameters, sysctl and masked services, which the prototype does not carry. Separately, `usbguard` with a default-deny policy would block the stick's own radio unless the policy allow-lists it.
*Falsifier:* build `hardened`, boot it on the real stick, and see that the RNode enumerates; then `apt-get install --simulate` something that would Recommend `avahi-daemon` and see the pin hold.

**R6. A browser may not launch `larder://` links without a prompt.** The design registers a handler for the `larder:` scheme. How Firefox ESR in kiosk mode treats it, and whether policy can pre-approve it, I did not verify.
*Falsifier:* on Debian's Firefox ESR, a click on a button runs the action with no dialog. If not, `desktop` and `hardened` switch to the Emacs surface (a one-word change in the profile line), losing only looks.

**R7. A click can fail silently.** `larder-open` prints errors to stderr, which no newcomer sees. Exit 69 ("nothing installed can do that") would look like a dead button.
*Falsifier:* hand-test in 6-REVIEW.md. The fix is a visible message from `larder-close`-style helpers; not built.

**R8. The Emacs surface was tested only by calling `push-button`.** Real mouse-1 clicks on a real GUI frame, fullscreen under matchbox, and what happens when a newcomer presses keys, were not tested. No display exists here.

**R9. Package names come from memory.** The pool probe covers eight; the rest are unchecked **[mem]**. A typo would break the image build, not the prototype.
*Falsifier / check:* feed `apt-cache pkgnames` from a trixie machine to every `.packages` list; any name not in it is a bug. The test suite does not do this today.

**R10. The author notice is a template by non-lawyers.**
- Whether the "not read" and "any idea may be used" sentences hold depends on the author's jurisdiction. They exist because an author who reads fan work can later be accused of borrowing from it **[mem]**.
- Whether a publisher's contract already gives away the right to authorise derivative works is unknown to me. The notice cannot be used before someone checks.
- The mark is a condition, and a technical tool cannot enforce a condition: anyone can remove it. The remedy is the author's, not the stick's.
- Unmarked works are by definition outside the permission; I did not decide what the group does about them.
- The notice says no money and no AI training. These are choices of mine, as placeholders; the author decides.
- **CC-BY-SA wrinkle.** PROBLEM.md asks for CC-BY-SA-4.0 on all my text, including the mark sentence. Every fan work then carries a sentence of CC-BY-SA text. I believe one short sentence does not turn a whole work into an adaptation, but I am not sure. The cleanest cure is for the author to write and own their own mark sentence, which the design allows (the mark is read from the notice, not from the tool).
*Falsifier:* a lawyer reads the rendered notice and the publisher contract. The `LEGAL_REVIEW` switch exists so the stick says DRAFT until then.

**R11. GPL obligations when handing out sticks.** The stick carries GPL programs; whoever hands it out owes source or a written offer **[mem]**. The prototype does nothing about it.

**R12. Unknowns about boot.** Whether live-build's images boot under Secure Boot with Debian's signed shim, and how LUKS2 argon2id behaves on a 2 GB laptop, I neither read nor tested. Both are the spec's, not the software side's, but a profile that cannot boot is not a profile.

## Unknowns I could not close

- U1. How many members have 32-bit-only machines (R1).
- U2. Whether charging for a stick affects the Sideband grant (R2).
- U3. Size of `fullsink` and the other profiles on disk. I did not measure; `fullsink` pulls QGIS, FreeCAD and KiCad and may not fit a small stick.
- U4. Whether `#` comment lines survive in live-build package lists. The manual is silent. The glue should strip them with `grep -v '^#'`.
- U5. Whether an apt preferences file that holds only comments is accepted. I think so **[mem]**.
- U6. Real-screen layout: ten buttons at 1024x600. The page uses a grid that wraps; I did not render it.

## What would prove the pick wrong

Base (Debian 13 + live-build):
1. A large share of the group's laptops are 32-bit only **and** there is no one to run a legacy track. Then a base with i386 support wins.
2. Sideband and the Reticulum stack cannot run on trixie **and** cannot be fixed within a version pin. Then the base should be the one where they run (bookworm), and the support clock becomes the cost.
3. The group decides it cannot carry any non-free firmware **and** its laptops need it. Then no base works, not just this one.
4. A volunteer cannot rebuild the image from the repo in an afternoon. Then N4 and N8 fail whatever the base.

The recipe-and-generator model:
5. A real profile needs something a package list plus a deny list cannot say, in more than a handful of places. Then the list is the wrong unit, and a metapackage (approach F) or a declarative OS (B, E) pays for itself.
6. Someone adds a sixth profile and it takes more than editing one file. Then the single source is not single.

The first-run shell:
7. Newcomers, handed the stick, fail to reach the first button, or click and nothing visible happens (R7), in more than one test of five.

The author variant:
8. The author's lawyer or publisher will not accept a blanket permission, or the author wants approval. Then this variant is not the right design; approach 3 of the author list returns.
