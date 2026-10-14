<!-- SPDX-License-Identifier: CC-BY-SA-4.0 -->
<!-- Copyright (C) 2026 the Larder software contributors -->
# 3. Design

## Shape in one picture

```
                         recipes.conf   (the one source: groups, profiles, surfaces, choices)
                              |
                          gen.sh + gen.awk     checks everything, writes into a staging
                              |                directory, moves it into place only on success
        +---------------------+----------------------------------------------------+
        |                     |                                                    |
 out/<profile>.packages  out/<profile>.pip   out/<profile>.areas / .preferences    |
        |                     |                       |                            |
  live-build              image hook:           lb config --archive-areas /        |
  config/package-lists    pip --require-hashes  config/apt/preferences             |
  (glue strips '#')       from vendored wheels  (negative pins)                    |
                                                                                   |
                        out/<profile>.firstrun.html   out/<profile>.firstrun.el   out/larder-open
                        /usr/share/larder/firstrun/   (same directory)            /usr/bin, and the
                        shown in a kiosk browser      shown in one Emacs frame    handler of larder:
```

Everything left of the pictured line is what `4-BUILD/` produces and `5-TEST/` checks. The live-build tree that consumes it is **not** built here (C2).

Three rules hold the design together.

1. **Presence is a list, absence is a pin.** A profile says what it includes (groups) and what it forbids (`deny`). The generator refuses a profile that does both.
2. **A button exists only if its program does.** Each choice names the package it needs. A page shows a choice only if its profile carries that package. A choice with a fallback (same id twice) shows once, for the first alternative the profile can serve.
3. **A link carries a name, never a command.** `larder://library` selects one arm of a generated `case` statement. Anything else exits 64. Run commands may use only `[a-z0-9 ._=-]`.

## The five profiles

Counts are packages **named** in the recipes, the number the generator writes (the test suite checks this table against the generator, check G12). They are not installed size: `xfce4` and `libreoffice-*` pull hundreds more. The four PyPI names are the same in all five (the mesh stack).

| Profile | For whom | Groups | First-run surface | Debian packages | PyPI |
|---------|----------|--------|-------------------|-----------------|------|
| `minimal` | An old or low-memory laptop. The smallest stick that still unlocks, gets online and reaches the mesh. | core, mesh, xlite | Emacs frame | 26 | 4 |
| `desktop` | Most members. The stack in spec section 5: XFCE, LibreOffice, Kiwix, Nextcloud client, Tor and I2P for Reticulum's interfaces. | core, mesh, xfce, office, library, files, privacy | HTML page | 33 | 4 |
| `homelab` | The organizer running the chapter's pantry box on a reclaimed machine: containers, Postgres/PostGIS, kiwix-serve, restic, sshd. | core, mesh, xlite, library, privacy, server | Emacs frame | 41 | 4 |
| `hardened` | Members who expect a seized laptop or a hostile network. `desktop` plus AppArmor, usbguard, nftables, auditd, mat2, keepassxc; and pins that keep bluez, avahi, cups and sshd out. | core, mesh, xfce, office, library, files, privacy, hardening | HTML page | 43 | 4 |
| `fullsink` | A builder's test bed and a library stick: every group, including QGIS, FreeCAD and KiCad. Not a safe default, and **not hardened**: it holds what `hardened` forbids. | all | HTML page, and the Emacs frame | 62 | 4 |

Why `hardened` keeps LibreOffice and Firefox: a profile that removes what organizers need gets abandoned for `desktop`, and then nobody is hardened. It is a posture, not a diet. Why `hardened` is a superset of `desktop`: the check "hardened holds everything desktop holds" is easy to run and easy to understand (G06).

## Buttons per profile

Ten at most, and setup first (check F04).

| Profile | Buttons shown | Missing, and why |
|---------|---------------|------------------|
| `minimal` | setup, guide, network, chat, editions, close, shutdown (7) | docs, library, files: no LibreOffice, Kiwix or Nextcloud client |
| `desktop`, `hardened`, `fullsink` | all ten | none |
| `homelab` | the seven above plus library (8) | docs, files |

`network` and `chat` are served by fallbacks: with `network-manager-gnome` the button opens its editor, without it `xterm -e nmtui`; with Sideband it opens Sideband, otherwise `xterm -e nomadnet`.

## First-run flow

What a newcomer sees, and what runs.

1. **Boot.** Stick in, BIOS or UEFI menu, GRUB, kernel. If the LUKS2 persistence partition exists, the unlock prompt comes first (spec section 2; software stand-in is a passphrase). Not in this prototype.
2. **Autologin.** `live-config` logs in a plain user. The session starts `larder-kiosk` (not built): it reads the profile's first surface and runs either `firefox-esr --kiosk file:///usr/share/larder/firstrun/index.html` or `emacs -Q --fullscreen -l larder-firstrun.el -f larder-firstrun` under matchbox.
3. **One window, ten buttons or fewer, meant to fit one screen at 1366x768 (not rendered here, U6).** Big text, each button with one plain sentence beneath. The first button says "Set up this stick".
4. **A click.** Browser: the link `larder://chat` goes to the registered handler `larder-open %u`. Emacs: the button starts `larder-open larder://chat`. Same program either way.
5. **`larder-open`.** Strips `larder://` and one trailing `/`, rejects anything not `[a-z][a-z0-9-]*`, looks the name up, tries each alternative in order, `exec`s the first whose program is installed. Unknown name: exit 64. Nothing installed: exit 69.
6. **Setup first.** `larder-setup --first-run` (the spec's signed setup script; not built) names the node and sets the PIN. This is the one step that needs a keyboard; a mouse alone chooses, a keyboard types the PIN.
7. **Leaving.** "Close this and use the laptop" ends the kiosk and shows the XFCE desktop (or a terminal on `minimal`). "Lock and shut down" locks persistence and powers off.

Failure paths I know about and have not closed: a click that fails does nothing the newcomer can see (R7 in 2-ANALYSIS.md); an Emacs frame closed by accident needs the session to restart it.

## Interfaces the prototype assumes (stubs)

Provided by a `larder-tools` package (flagged `local` in the recipes, built by the group, not by Debian): `larder-setup`, `larder-guide`, `larder-editions`, `larder-close`, `larder-shutdown`, `larder-kiosk`, the `larder-open.desktop` file that registers the URL scheme, and `fanmark`. In this prototype only `larder-open` (generated), `fanmark` and `render-edition.sh` exist.

## The author edition

**Rule: one OS image for everyone; an edition is data.** The spec's partitions are EFI, a read-only OS squashfs, LUKS2 persistence and a media partition. The author's books and notice go on the media partition; the squashfs, and so the signed hash on the e-ink, is the same on every stick. That keeps a single image to sign and verify, and keeps the author's non-free books out of the OS image, so they are plainly an aggregate with the GPL software and not part of it.

```
/media/larder/editions/<slug>/
    edition.conf       author, titles, contact, notice version, legal-review flag
    PERMISSION.md      the rendered notice
    books/             the author's own books (not under any licence in this repo)
```

**Flow.** The author (or whoever builds the stick) fills `edition.conf`, runs `render-edition.sh`, and drops the books beside it. A newcomer clicks "Books & extras on this stick" (`larder-editions`, not built), reads, and writes a fan work in any editor. To publish, `fanmark -e /media/larder/editions/<slug> work.md > marked.md` puts the by-permission mark above and below it, and the work goes wherever the writer posts it.

**The mark carries a hash.** The mark line lives in the notice, with `{ID}` in it. `fanmark` fills `{ID}` with the first 12 hex digits of the SHA-256 of the notice. Anyone can fetch the author's published notice, hash it, and see which text the work relied on. If a stick's notice has been edited, its marks carry a different id, which no published notice matches.

**Three fuses.** The notice renders with a DRAFT banner until `LEGAL_REVIEW=yes`. `fanmark` refuses a draft notice (exit 3) unless `FANMARK_ALLOW_DRAFT=1`. `render-edition.sh` refuses unresolved placeholders and unsafe values (a value cannot contain `| & \ { }`).

**What the notice says, short.** Grant (anyone, any form, free of charge, not exclusive); Mark (must open every copy; no mark, no permission); Not read (the author does not read or accept fan works; if one arrives, any idea in it may be used without credit or payment); No money (and no AI training); Yours and mine (you keep what you add, you get nothing in the Books, no brand use of titles, covers or the author's name); Changes (apply to later works; marked works keep the permission they were marked under). About 350 words.

## Licences

| What | Licence |
|------|---------|
| Scripts, awk, templates for HTML, Emacs Lisp and the launcher, `recipes.conf`, `edition.conf`, everything generated from them | GPL-3.0-or-later |
| `PERMISSION.md.in` (the template) and these six documents | CC-BY-SA-4.0 |
| The author's books, and the author's filled-in notice once the author owns it | not ours; not covered by anything here |
| Debian, Reticulum, Sideband, firmware | their own licences; two of those are not free (2-ANALYSIS.md R2, R4) |

Each file has an SPDX line, and G09 and A05 check it.

## Not designed here

The live-build tree and its glue; the `larder-tools` package; the LUKS2 and secure-element unlock; locking on lid close; the reset and wipe commands; message recall; the hardware. All are in the spec and none are on the software-side list in PROBLEM.md. Hardening beyond packages (kernel parameters, sysctl, masked services) is also not here; see R5.

## How to run what exists

```
cd 4-BUILD && sh gen.sh                  # writes 4-BUILD/out/
sh author/render-edition.sh author/edition.conf author/PERMISSION.md.in /tmp/ed
sh 5-TEST/run-tests.sh                   # the suite
sh 5-TEST/run-tests.sh --self-test       # plant faults, demand the suite catches them
```
