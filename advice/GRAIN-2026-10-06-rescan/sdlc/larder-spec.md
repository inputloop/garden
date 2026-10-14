# GSUS Tech Kit — Boot Stick Spec Sheet (draft v0.5)

Name: **Larder** (settled). Check for trademark/project collisions before printing labels.

## 1. Concept in one sentence
A credit-card-footprint USB boot stick that turns any reclaimed laptop into a durable, persistent, encrypted Linux workstation for crisis-feeding organizers — with an on-board secure element for node identity, an on-board LoRa radio for Reticulum mesh, and an offline public-domain library.

The **host laptop** runs the OS. The stick contributes storage, identity, radio, and a status display.

## 2. Threat model (settled)
| Adversary | What they can do | What stops them |
|-----------|------------------|-----------------|
| Seizure of the stick | Plug it in, image the flash | LUKS2 (argon2id) persistence; key = secure-element key **and** user PIN. Without the PIN the stick is an ordinary Debian Live image with an unreadable blob. |
| Seizure of stick + laptop | Same, plus cold-boot tricks | Persistence auto-locks on host sleep/lid-close; no swap; RAM wipe on shutdown. |
| Brute-forcing the PIN | Try PINs | Secure element lockout after 8 bad PINs (identity stays, persistence becomes unrecoverable without the paper seed). |
| Tampering / supply chain | Swap the image | Signed image + signed setup script; write-protect switch on the OS partition; e-ink shows image signature short-hash at boot. |
| Network observer | Watch traffic | Reticulum/LXMF end-to-end encrypted; WireGuard to chapter server; Tor available but not forced. |

Not a goal: plausible deniability, amnesia. Goal: **durable, persistent, secure**. Files survive; nothing readable leaks.

## 3. Physical
| Item | Spec |
|------|------|
| Footprint | 85.6 × 54.0 mm (ID-1) |
| Thickness | **10 mm target, 12 mm budget, 15 mm ceiling.** 10 mm is achievable only with *mid-mount* (PCB-straddling) USB-A and USB-C receptacles and an edge-mount SMA. Through-hole USB-A (5.7 mm tall on a 1.6 mm board + 2×1.5 mm shell) lands at ~10.3 mm; plan 12 mm if using standard parts. Tallest components: USB-A receptacle (5.7), ESP32-S3 module (3.1), SMA jack body (6.35 across flats — must be edge-mounted, not vertical). |
| Shell | 3D-printed PETG/ASA, two-part, screwed not snapped (durability); non-metallic over antenna |
| Host connection | USB-A male on a **6–8 cm captive pigtail** (USB 3.x). Rigid plug rejected: 86 mm of leverage on a laptop port is the most likely field failure. Pigtail also lets the stick sit flat on the table, which makes the port layout below work. |

### Port map (reconciled, final for v1)
| Face | Contents | Why |
|------|----------|-----|
| 1 (short end) | Pigtail exit + strain relief; recessed reset pinhole | Host cable leaves one end |
| 2 (top) | e-paper display, 2× status LEDs | Readable while it sits on the table |
| 3 (short end, opposite host) | **USB-C power in (5 V/3 A)**, USB-C data (f), USB-A data (f) | All outbound cabling at the far end from the host cable, so cables leave in two directions and never cross the display. 13.1 + 9 + 9 mm + spacing fits in 54 mm. Power port nearest the corner, keyed by a colored bezel. |
| 4 (bottom) | Regulatory label, rubber feet | — |
| 5 (long edge) | **SMA antenna jack** (edge-mount), positioned at the face-3 end | Farthest from the laptop chassis metal; whip stands vertical when the stick lies flat. Chip antenna fallback pad on the same edge. |
| 6 (long edge) | Write-protect slide switch; **helper-module header** (4-pin, keyed, under a small hatch) | Reachable without moving cables |

Power on face 5 (original sketch) works too, but puts a cable on the same edge as the antenna whip. Grouping power with the data ports on face 3 is cleaner and frees face 5 for the radio.

| Item | Spec |
|------|------|
| Audio jack | **Dropped from v1.** The standalone-with-a-display use case needs an SoC and is a different product. Keep a no-load footprint for a 3.5 mm TRS UART console if you want one later. |
| Display | 1.02" e-paper, 128×80, SPI, **optional module on its own header** (board must work without it). Shows: node name/short hash, lock state, mesh peers, radio state, write-protect state, power source, boot image hash, last reset code. Pictorial "pantry" mode: a shelf of up to 5 jars, one per active room — sealed while locked, lid off when unlocked, one drop per new message, per-room overflow threshold in settings, spill sprite on overflow; peers shown as a lantern count. Partial refresh per drop; full refresh on lock/unlock only. |
| Indicators | Green = power/unlocked; amber = radio TX / fault |
| Switches | Write-protect slide switch (OS partition). Reset pinhole: hold 5 s = **soft reset** (see §6). No hardware hard-wipe. |

## 4. Electrical / logic
```
Pigtail USB-A male (host)
   └── USB 3 hub IC (4-port)
         ├── Flash controller + NAND (boot volume, 128 GB)
         ├── ESP32-S3 (native USB, CDC-ACM) ── SX1262 LoRa module ── SMA
         │                                ├── e-paper (SPI)
         │                                ├── ATECC608B secure element (I2C)
         │                                └── LEDs, WP switch sense, reset
         ├── downstream USB-A (f)
         └── downstream USB-C (f)
Power: host VBUS  OR  USB-C 5 V/3 A → ideal-diode OR-ing → 3.3 V buck; ESP32 reads which source is live and only enables downstream port power on external input.
```

| Block | Part class | Notes |
|-------|-----------|-------|
| Hub | USB 3.x 4-port hub IC | Downstream port power switches (current-limited) |
| Storage | 128 GB NAND + USB 3 flash controller (or soldered pre-built module for the class build) | EFI 512 MB / OS squashfs RO / LUKS2 persistence / media (ZIMs) |
| Radio MCU | ESP32-S3-WROOM-1 | RNode firmware fork |
| Radio | SX1262 pre-certified module, 902–928 MHz | Inherit FCC ID; SMA to included 915 MHz whip |
| Secure element | ATECC608B | Identity key generated on-chip; PIN-gated; 8-try lockout |
| Display | 1.02" e-paper | Refresh only on state change |
| Power | OR-ing controller + buck + TVS on every port | Budget below |

### Power budget (5 V)
| Load | Typical | Peak |
|------|---------|------|
| Flash | 150 mA | 300 mA |
| ESP32-S3 | 60 mA | 120 mA |
| SX1262 TX | — | 120 mA |
| e-paper | — | 30 mA |
| Hub | 60 mA | 100 mA |
| **Stick alone** | ~270 mA | ~670 mA → fits USB 3 host; on USB 2 host firmware caps radio TX power |
| Downstream ports | — | 1000 mA → **external USB-C power required**, enforced in firmware |

## 5. Software stack
| Layer | Choice |
|-------|--------|
| OS | Debian Live stable, amd64 (+ i386 image for old machines), XFCE |
| Boot | GRUB, UEFI + legacy; shim for Secure Boot |
| Disk | OS squashfs behind write-protect; LUKS2 persistence unlocked by ATECC608B + PIN |
| Identity | Secure element → Reticulum identity, SSH key (`ssh-keygen` at provisioning, private key lives on-chip), LUKS keyslot |
| Network | Reticulum (`rns`) with RNode + TCP + I2P interfaces; WireGuard to chapter server; Tor optional |
| Chat | NomadNet / Sideband (LXMF). **Bridging:** an LXMF bot on the chapter server relays chosen channels to Matrix / Discord (and Fluxer, if it exposes a bot API) via a matterbridge-style relay. Bridge is one-way-by-default (mesh → chat platforms) and opt-in per conversation; nothing on Discord reaches the mesh unless a facilitator enables it. |
| Files | Nextcloud desktop client (chapter server). **Offline editing:** LibreOffice or Collabora Office desktop on the stick. **Collaborative editing:** Collabora Online (CODE) on the pantry box as Nextcloud Office. Same engine both places, so no format drift. OnlyOffice not used (second engine). |
| Library | Kiwix desktop, ZIMs on media partition (Gutenberg, Wikipedia subset, first-aid, food-safety, gardening). Kiwix-serve also runs on the chapter server so members can pull new ZIMs over LAN. |
| Optional | QGIS, FreeCAD, KiCad via post-boot script |
| Provisioning | One signed image + signed `larder-setup` script + YAML config. Verified on first boot; hash shown on e-ink. |

## 6. Reset semantics
**Soft reset** (pinhole, 5 s, e-ink confirms): clears browser profile, saved passwords/autofill, NomadNet/Sideband conversation history, WireGuard/session tokens, shell history. **Keeps** documents, Nextcloud sync folder, library, and node identity.

**Hard wipe** exists only as a software command (`larder-wipe`) requiring the PIN; it destroys the LUKS header. Recovery only via the paper seed printed at provisioning.

### Reset attestation
Every soft reset increments a monotonic counter in the secure element and produces a signed record: counter, timestamp, OS image hash, identity fingerprint. The e-ink shows a 6-character code derived from it; Larder settings shows the full record; the chapter server can verify the signature. Members verify a wipe by counter + code, and verify identity by comparing the fingerprint on the e-ink to the paper seed and the chapter registry.

### Remote guidance (no KVM)
Learner-initiated screen share (software, over WireGuard or Reticulum), session-scoped, ended by the learner. Enabled only while a removable **helper module** (signed capability certificate on a keyed 4-pin header) is seated, and only for helper identities on the chapter's known list. Remove the module → the secure element refuses to sign a remote-assist session. Prototype: a jumper. No HID emulation, no video capture hardware, ever.

### Message expiry
- Per-message TTL set by the sender; honored by Larder clients (not enforceable on other LXMF clients — say so in the guide).
- Per-room default enforced locally on each stick: chapter rooms 14 days, direct messages 30 days, adjustable.
- Server archive retention (below) is a separate, third window.

### Message recall (default **on for facilitators, off for members**, per-member toggle)
- Client encrypts its chat history to the identity key on the secure element and pushes the blob to the member's Nextcloud folder on a schedule.
- Retention window on the server (default 30 days); older blobs auto-delete.
- Two factors to restore: PIN unlocks the identity on the stick; a TOTP code from the member's authenticator app (seed enrolled at provisioning, held by phone + pantry box, never the stick) is verified by the pantry box before it releases the blob. A second FIDO2 key may stand in for the phone.
- After a soft reset: PIN → TOTP → **Restore history** → pull blob → decrypt on-stick.
- Six wrong TOTP codes freeze the archive until a facilitator clears it; facilitators can freeze any member's archive on request.
- Restored messages are re-verified against each sender's LXMF signature and marked verified; unverifiable messages are shown separately, not silently merged.
- The e-ink and the status panel show "archive: on/off" so a member knows before a scare whether recall exists.
- Not recoverable: delivered messages never archived. Propagation nodes on the pantry box hold messages only until fetched.
- Trade-off stated plainly in the user guide: anything recoverable after a scare is recoverable by anyone holding the PIN.

## 7. Cost (qty 25) — ~$60–75 BOM
Hub + flash ~$22 · ESP32-S3 ~$4 · SX1262 module ~$8 · ATECC608B ~$1 · e-paper ~$6 · SMA + whip ~$4 · connectors/passives/power ~$8 · PCB ~$5 · shell + pigtail ~$5.

## 8. Chapter server automations (pantry box)
Nextcloud built-ins only; no custom app server.
| Flow | Wiring |
|------|--------|
| Public-domain media request | Forms → Flow webhook → fetch script pulls ZIM/Gutenberg bundle into "Library inbox" share → kiwix-serve reindexes → LXMF bot posts "new title available" |
| Mutual aid / file request | Forms → Tables row → Deck card → LXMF bot mirrors new cards to the chapter room (one way) |
| Geospatial (gleaning, drop points, needs) | Forms (cross-street, not address) → self-hosted Nominatim/Photon geocode → PostGIS (encrypted volume) → QGIS on the stick as a PostGIS layer over WireGuard. Share schema with NextTime where it fits. |

Data-minimization rules for forms about people: collect cross-street not address, mesh handle not phone, auto-delete rows after the need closes, never a third-party geocoder.

## 9. Regulatory
Pre-certified radio module (inherit FCC ID; use an antenna on its approved list or one with lower gain). "Contains FCC ID" label on face 4.

---

# To-Do List

## Phase 0 — Decisions (done / remaining)
- [x] Threat model
- [x] Base distro: Debian Live
- [x] Port map, thickness ceiling, no KVM, no audio jack, pigtail
- [x] Chat layer: Reticulum/LXMF + server-side bridge
- [x] Reset = soft reset only
- [x] Name: Larder
- [ ] Define class deliverable: COTS proof-of-concept vs. custom PCB vs. both

## Phase 1 — Software proof on a plain USB stick (2–3 weeks)
- [ ] Debian Live build: XFCE, LibreOffice, Nextcloud client, Kiwix, `rns`, NomadNet, Sideband, WireGuard
- [ ] RO squashfs + LUKS2 persistence; PIN unlock (software-only stand-in for the SE)
- [ ] Boot on 3+ reclaimed laptops (BIOS-only, UEFI, Secure Boot)
- [ ] `larder-setup` script + config; sign image and script
- [ ] Soft-reset script (`larder-soft-reset`) — enumerate exactly which paths it clears
- [ ] Curate initial ZIM set; measure size
- [ ] Document minimum laptop specs

## Phase 2 — Hardware proof with off-the-shelf parts (2–3 weeks)
- [ ] LilyGO/Heltec board flashed with RNode firmware
- [ ] Nitrokey/SoloKey as secure-element stand-in
- [ ] Powered hub + stick + RNode + token = functional Larder, ugly
- [ ] Prove: boot → unlock with token+PIN → LoRa link between two kits → NomadNet message
- [ ] Prove bridge: LXMF bot on a test server → Matrix room → Discord channel
- [ ] Measure current draw; confirm budget
- [ ] LoRa range test, whip vs. chip antenna, laptop-adjacent

## Phase 3 — Custom PCB (4–6 weeks)
- [ ] KiCad schematic per §4
- [ ] Flash path decision (discrete vs. soldered module)
- [ ] Layout in 85.6 × 54 mm; mid-mount connectors; SMA edge-mount on face 5; antenna keep-out
- [ ] Stack-up check: confirm ≤10 mm, else re-plan at 12 mm
- [ ] Order 5 boards; assemble 2
- [ ] Firmware: RNode fork + e-paper status + WP/reset handling + VBUS-source detection + downstream power gating
- [ ] Shell in FreeCAD; print; iterate port alignment and pigtail strain relief
- [ ] Bring-up checklist: hub → flash → serial → SE → radio → display

## Phase 4 — Provisioning & docs (2 weeks)
- [ ] Provisioning: on-chip keygen, paper seed, PIN set, optional chapter-server registration
- [ ] Soft reset + hard wipe tested end to end
- [ ] Reset attestation: SE counter, signed record, e-ink code, server-side verify
- [ ] History archive: encrypt-to-identity, push to Nextcloud, retention, TOTP-gated restore + re-verify, facilitator freeze
- [ ] Message expiry: per-message TTL, per-room defaults
- [ ] Helper module: header footprint, capability cert format, jumper prototype, screen-share path
- [ ] Pantry box: CODE (Nextcloud Office), Forms/Flow/Tables/Deck wiring per §8, Nominatim + PostGIS
- [ ] User guide; facilitator guide (chapter server, bridge config, peer approval)
- [ ] Reproducible image build in the repo

## Phase 5 — Chapter pilot
- [ ] 5 units, one chapter, two weeks; collect failures
- [ ] Revise to v1.0
