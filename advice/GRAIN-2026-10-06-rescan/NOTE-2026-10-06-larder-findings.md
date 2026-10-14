# Larder v0.5: five things to check before Phase 0 closes

For Bridget, from Corwin's shop, 2026-10-06. Two teams worked on the software side of the stick
tonight, independently. Both picked Debian 13 (trixie) with live-build as the base, as your spec
does. Along the way they found five things the spec should account for. None is a reason to change
course; each is a decision to make on purpose.

1. **There is no i386 in Debian 13.** trixie ships no 32-bit PC kernel or installer, so the spec's
   "i386 image for old machines" cannot be built on trixie. Two options:
   - drop 32-bit machines;
   - build that one image on Debian 12, which has long-term support until mid-2028.
2. **The mesh stack's licences.** Reticulum, LXMF and NomadNet use a custom licence with
   conditions on use, including no-harm and no-AI-training clauses. Sideband is CC BY-NC-SA, a
   non-commercial licence. None of the four is in Debian.
   - Selling sticks with Sideband on them may conflict with its terms.
   - Worth a read by whoever advises the group, before the bill of materials turns into a price.
3. **Debian starts Tor (and i2pd) at boot when they are installed.** That clashes with the spec's
   "Tor available but not forced". The image needs those services masked by default, with a
   one-click way to turn them on.
4. **`usbguard`, if used in a hardened image, blocks new USB devices by default**, and that
   includes the stick's own radio (the ESP32). It needs an allow rule for that device.
5. **Sideband may not run on Debian 13's Python version.** This comes from one team reading the
   project page, and is not verified. Worth a test before it is the default chat client.

The teams also prototyped the five recipe profiles (minimal, desktop, homelab, hardened, fullsink),
a first-run page and its tests. Corwin will share those once he has picked between the two
approaches.

One question back: **what licence is the spec itself under?** We'd like to quote it correctly.

*Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA-4.0.*
