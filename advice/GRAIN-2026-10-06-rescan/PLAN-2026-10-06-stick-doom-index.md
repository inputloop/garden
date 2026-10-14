# The stick, Dad's Miracle Shot, and the index: what to do next

A plan for Corwin, 2026-10-06. It draws on:
- tonight's intake of Bryant's export;
- the BEFORE GRAIN;
- the wild-and-garden run;
- a six-agent sweep of F:\claude, D:\projects, G:\dist, org-c4, H:\ta, H:\pub, the San Diego backup
  and SAVANNAH (names only where it mattered).

Judgments are marked as mine. Where a fact has one witness, it says so.

## How I worked your instructions

- **The intake came first:** dm1rd and the context file, then the BEFORE reads. That way the
  garden's skills could be measured against a baseline.
- **Your mid-turn messages changed course four times:**
  - Dad's fences: audited and dropped.
  - Rights: corrected.
  - Journaling: designed separately; the entry comes last.
  - "See all the work": the sweep.
- **The local gemma was used where bias was trickiest:**
  - as the second scorer of the calibration;
  - as the blind reviewer of the paired run;
  - as the reader that keeps unconsented words at home.
- **The order of work:**
  - Ideas v0 were sketched before reading.
  - The prior list (H:\ta\SLIDES-catalogue, 64 slides) was found at the midpoint.
  - Both are merged in `IDEAS-2026-10-06-presentations.md`.

## 1. The stick (Brigidt's goal; the Larder software)

**Recommendation (mine, from two independent teams that converged): base it on Debian 13 (trixie),
built with live-build, from one recipe file.**
- That matches Brigidt's spec.
- It is what both tonight's teams picked independently. Neither was told her choice was fixed.
- The Guix and Arch door images (09-27) stay what they were designed as: *readers* of the C4 door,
  and an FSF-free edition for people who want one. They are not the organizers' stick.

**Send Bridget these five spec findings now. They are time-sensitive, because her v0.5 still lists
Phase 0 as open:**
1. **There is no i386 in Debian 13** (no kernel, no installer). The spec's i386 image cannot exist
   on trixie.
   - Decide: drop 32-bit machines, or ship bookworm for them until mid-2028.
2. **The mesh stack's licences.**
   - Reticulum, LXMF and NomadNet carry use conditions: no-harm and no-AI-training clauses.
   - Sideband is CC BY-NC-SA. Selling sticks with Sideband on them may breach its terms.
   - None of them is in Debian.
   - *(From upstream licence files, read by both teams; not by counsel.)*
3. **Debian starts `tor` and `i2pd` at boot** when they are installed (their `postinst`). That
   contradicts "Tor available but not forced". The recipe must mask them.
4. **`usbguard`'s default deny would lock out the stick's own radio.** The hardened profile needs an
   allow rule for the ESP32 by its serial.
5. **Sideband may not run on Debian 13's Python.** *(One team, from the project page; unverified.)*

**The recipes** take the best of both teams:
- From wild:
  - a button appears only if its program exists;
  - the author edition is data, so the signed OS image hash never changes.
- From garden:
  - free by default, but each profile states what leaving the mesh out costs the group, and the
    group chooses;
  - the light/dark pattern;
  - exit 2 for NOT CHECKED.
- The suite is attacked by mutation, not only by planted faults.
- Five profiles:
  - **minimal**: boot, files, browser;
  - **desktop**: plus office, Nextcloud client, and the mesh if the group accepts its terms;
  - **homelab**: plus WireGuard and server tools;
  - **hardened**: plus usbguard with the radio's allow rule, no Tor by default;
  - **fullsink**: everything, for builders.

**The kiosk shell, the "simplified Electron": org-c4 is the thing.** It was the most worked project
in the sweep.
- **org-httpd** is an Emacs-native HTTP/SSE server, with `c4-api.js` in the browser.
  - ERT 217/218; API 119/119.
  - It grew from orgvm.
  - It binds loopback on purpose, which is exactly right for a kiosk.
- **The design:**
  - Emacs serves the first-run page to a local browser in kiosk mode.
  - On a console-only machine, the mouse-first Emacs frame from EMACS-AS-APP stands in.
- **The theme** comes from egad's Modus tokens.
- **Packages:** the ghostwheel ELPA in G:\dist (24/24, unsigned, unpublished) is the channel for
  the stick's Emacs packages.
- **The mood-rich organiser** already exists inside `egad/hello/hello-egad.org`:
  - AGENDA is open, MOOD is closed until opt-in, TRACKS replays.
  - Checks O1–O9.
  - It can ship on the stick as a local app first.
  - Syncing to gw33 waits for orgvm's jail. Its own README admits unscrubbed document names.

**Order (each step runs before the next is built):**
- **S1, the free distro without Dragaera content** (your own first step):
  - the recipe file, the generator, the suite;
  - one image built and booted on a real laptop.
- **S2, the first run:** org-httpd and the page; the console frame.
- **S3, the Larder hardware** (Brigidt):
  - secure element, LUKS, RNode, e-ink;
  - this is where her spec's real work is.
- **S4, the author edition overlay** (section 2).

**Two fixes found on the way:**
- `dist/mirror-heads.sh` reads UTC ledger stamps as local time: 21/25 under America/Chicago, 25/25
  under UTC.
- org-c4's `.build.env` sits in pushed history (commit c115ef7, on bru and sr.ht).
  - Rotate the key if it is live.
  - Nobody opened the file tonight.

## 2. Dad's Miracle Shot

**What Dad wants, in his and your words:**
- to know "in time" whether a move home can happen, before **12 December** (his licence and
  insurance date);
- a down payment from capitalizing his works, with a mortgage that fits Social Security and Patreon;
- "The convention sounds like a hoot, whether it makes any money or not."

**What is real today:**
- **The omnibus.** Ben (ZOE) bought the print rights back from Tor; the contract was signed 10-02,
  with $7,500 to Tor this week. Ace needs nothing. Ben's next steps: "our own contract" (ZOE with
  Dad), and a BackerKit launch page.
- **The convention.** It opens two revenue lines:
  - supporting members (one-time);
  - sustaining members (recurring, kept small so it doesn't compete with his Patreon).

  Open: hotel, publications and the ops lead. Dee, DD-B and Kelsy are in the Beyond Conventions
  structure. There is a hard 31 December platform deadline.
- **The stick (the Project of Doom):**
  - the description he heard and liked;
  - Jon collecting texts and audio;
  - S1 above.

**The arithmetic of 12 December (mine; BackerKit's published timing):**
- After a successful BackerKit campaign, charging starts within 24 hours.
- Funds reach the bank typically within 14 days: a 7-day hold plus Stripe's own wait.
- For money to land by 12 December, a campaign must **end by about 28 November**. A 30-day
  campaign would have to **launch by about 29 October**.
- Dad's own rule puts the ZOE–Dad contract, read by his counsel, before anything goes wide. So
  counsel has about two weeks.
- **Cash to Dad by 12 December is unlikely.** The money is ZOE's to fund the print run first, and
  Dad's share depends on a contract not yet written.
- **What can exist by 12 December is a signal:**
  - a signed contract;
  - a live campaign with a pledge count;
  - an open pre-registration with member counts.

**The Miracle Shot, as I'd frame it:** *one counsel engagement, three instruments, justified by
software he has seen run.*
- **The counsel review Dad must do anyway** (the ZOE contract) also reads:
  1. **the stick edition's terms and the by-permission fan-works notice**, in two layers. The
     fan-facing face is wild's clarity. The terms Dad and counsel settle are garden's per-title
     gate and signature stamp, under the face.
  2. **the convention's "per dollar" sheet:** what part of each dollar goes to Steven, the monthly
     overhead, what Patreon supporters get. These are your own open questions from the Signal
     thread.
- **The working software that justifies the spend**, shown at the next meeting with Dad and
  Bryant:
  - S1 booted on a real laptop;
  - Bryant's one-shot Jhereg game built from C4 and one file;
  - the notice rendering on the stick.
- **The order that serves 12 December:**
  - **This week:** counsel booked for the ZOE contract.
  - **Within two weeks:**
    - S1 booted;
    - the meeting;
    - Dad's per-title list (sold or not, per right; Jon's collection says what files exist).
  - **By about 29 October:** the campaign live, with the stick as an add-on or perk. That needs
    counsel's word on the notice first, or the perk ships without the books.
  - **By mid-November:** convention pre-registration open with supporting and sustaining tiers.

**How likely it is to serve Dad's interest (mine, and bold, as you asked):**
- **Likely (about 60%):** the effort gives him something to decide on by 12 December. That means a
  signed contract, a live campaign and early member counts, *if* counsel is booked this week.
- **Unlikely (under 10%):** money in hand by 12 December that covers a down payment.
- **The stick on its own will not move the decision.** Its job is to make the campaign and the
  convention feel like his world in your hands. It is also the proof that the governance you two
  care about works for him.
- **Naming rights are a real card.** You said VIBROBEAST is as close as the shop comes to a brand.
  A Dragaera-named edition is something the shop could offer Dad, if he can live with the software
  being free.

**Dates for the agenda, not for chat** (your wish: a mobile view backed by Emacs, not Claude
reminders):

| date | what |
|---|---|
| 12 Dec 2026 | Dad's decision date |
| 31 Dec 2026 | Beyond Conventions platform deadline (PMO #221); the audiobook-enrolment date in the PMO ledger |
| 25–28 Mar 2027 | Minicon 60, Minneapolis: a natural first table for the stick |

The `hello-egad` organiser's AGENDA is the right home for these. It is one more reason to put it
on the stick early.

## 3. The FOSS-involvement index and the ideas marketplace

**Where you and Bryant are:**
- Bryant saw marketability in the Law of Complexity conversation.
- The "ideas marketplace" (a baseline you might someday see yourselves in) came before the index
  idea.
- You take any argument about it to him, not to me. So this section only maps the idea against
  his lessons.

**GIVEN/THEN, tightened against the Law of Complexity:**
- **L1 (failure lives on the links):** measure involvement by *links that carry state*. Count
  cross-project contributions that landed, and co-signed artifacts. Do not count members or
  commits.
- **L2 (coupling density lacks a metric):** the index *is* the missing metric. Dependency edges
  between projects, read from public forges, are what his §5 item 5 asks for.
- **L5 and L8 (agents interpolate; two readers agreeing is evidence):** an edge counts only when
  two independent readers of public data agree on it. Tonight's census of 11 public repos and the
  MELPA recipe check are small instances.
- **The volumetric trap** (your own CALLED SHOT Track 3) is the stock-market analogy's risk. Prices
  invite gaming the way volumetric measures do.

**The proposition, stated:** GIVEN two independent readers of public forge and registry data agree
that project A's work landed in project B, THEN that is one verified edge. The index is a ledger
of verified edges, not a price.

The marketplace is where an idea links to the edges it would create. Prices wait until value has
a second reader.

**The parts already built:**
- `SAVANNAH/crawlright/`: polite public-GNU-data fetch, reusable as it is;
- `bin/pv1tl`: provenance timelines;
- the census method;
- `dm1rd`: for consented chat.

**Card for the shelf:** card-games on MELPA is the first verified "production". The recipe is in
melpa/melpa master, pointing at code.bru.st.

## 4. Licences, decomposed (one line per source)

| source | SPDX (as known) | where it comes from |
|---|---|---|
| Corwin's and the shop's code | `GPL-3.0-or-later OR LGPL-3.0-or-later` | TERMS v2 draft; house.env |
| Corwin's and the shop's text | `CC-BY-SA-4.0` | house.env; his 10-04 word |
| Bryant's work | `GPL-3.0-or-later`, `CC-BY-SA-4.0`, `LGPL-3.0-or-later` | his answer, 10-05 10:24 PM |
| Larder spec (Brigidt) | **not stated** | ask her before any of it is quoted or shipped |
| Debian packages | per package | each package's `copyright` file |
| Reticulum, LXMF, NomadNet | `LicenseRef-Reticulum` (custom; not DFSG) | upstream LICENSE files |
| Sideband | `CC-BY-NC-SA-4.0` | upstream LICENSE |
| GNU Guix door | `GPL-3.0-or-later` | c4-door.scm |
| card-games | `GPL-3.0-or-later` | its headers |
| Dad's books and audio | all rights reserved; per title, per right | the rights audit; his counsel |

## 5. Alignment with Bryant, and where you differ

**In step (from the record):**
- the three licences;
- consent to the vendor;
- "send me everything – I'll decide";
- credit that survives a split;
- the bumper cars, and "no secrets travel";
- two readers as evidence: his L8, and the convergence he named.

**Tonight's paired run measured his "pragmatic or essential" and found it right.**

**Still open, his to answer or yours to raise with him:**
- the marketability of the ideas marketplace;
- whether the weekly ledger starts (you called it a great suggestion; he said "if it helps");
- the users gate ("optional for now").

## 6. Questions only someone else can answer

- **Bridget:**
  - 32-bit machines;
  - the mesh licences;
  - the spec's licence.
- **Dad, with counsel:**
  - a standing permission, or a written OK for each work;
  - per title, which rights are sold.
- **You:**
  - whether the stick's first profile ships the mesh;
  - the two SAVANNAH data points to dodge, named (my guesses are in the hand-back);
  - whether org-c4's key is live.

---
*Version 1.0.0: first edition on 2026-10-06; spine: 2026-10-06.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4:
https://creativecommons.org/licenses/by-sa/4.0/; Mentat (for Corwin; claude-opus-5-5)
