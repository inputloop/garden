# Garden context: what our shop already knows (for the garden team only)

## Who and what
- The organizing group is the GSUS technology team. Its hardware stick, Larder, was specified by
  Brigidt (also written Bridget; editor in our credits, and business manager of Beyond Conventions).
  Corwin Brust is on the tech team; Bryant Frankford is his co-author. The team already runs Nextcloud
  as its identity provider and has a GNU/Linux mutual-aid thread.
- The author variant is for Corwin's father, Steven Brust ("Steve" in our notes, "Steven" in public
  material), author of the Dragaera books. Corwin is managing partner of that work. Dad asked how
  "the Project of Doom" was going; Corwin's description to him: a Linux distro on a USB stick; pay
  more for a cooler-looking one; it carries his books; boot it with or without AI to play games or
  write Dragaera fan fiction; limited rights such as publishing with a "by permission" watermark, so
  readers can have authorized fan fiction without Dad reading any of it.
- Corwin's next steps for it: Jon collects book texts and audiobooks; **build the free-software
  distro first, without the Dragaera content**; then a one-hour meeting where Bryant makes a sample
  one-shot game from C4 plus one file.

## Rights and rules around the author variant (his and Dad's, not ours)
- Publishers hold print licences (a fixed number of copies for a fixed period), not the rights. Dad
  holds every other right in his works unless he sold it (audio usually sold; one audiobook he
  self-produced). For a digital edition the check is per title and per right: has Dad sold it?
- Dad's terms from the 08-01 call: what's ours stays ours; Dad's rights are his, including to sell;
  materials are shared internally with friends, and published more widely only with a signed
  contract Dad has taken to counsel. A proposal (not yet ratified): anything containing or derived
  from his works publishes only with his written OK.
- So the prototype ships **no Dragaera text**, and the permission notice is a **draft for Dad and
  his counsel**, not a grant.

## What we have already built that bears on this
- **Door images (2026-09-27, drafts):** `c4/writing/door-images/`. A Guix reader (`guix/c4-door.scm`,
  inherits Guix's `installation-os`, adds Emacs, Git, GnuPG, pinned with `guix time-machine
  --commit=v1.5.0`) and an Arch-based reader (an archiso profile from `releng`, named "based on Arch
  Linux", no Arch logo, `linux-firmware` omitted by default). Both booted in QEMU in a cloud
  workspace; neither is signed. Open forks: D1 firmware, D2 the name on the media, D3 source on a
  second medium or a written offer (GPLv3 section 6: every copy carries its source or a written
  offer). A CD cannot hold either image; "optical" means DVD. Guix on laptops often needs non-free
  Wi-Fi firmware; Arch is not FSF-free; Parabola is the free Arch derivative.
- **Emacs as an app (2026-08-05):** stage 1 is stock Emacs in a chrome-less, mouse-first frame;
  stage 2 a portable dump; stage 3 a kiosk single-window frame. Rule: "do NOT dump before the UX
  exists". Hazard: "Emacs as an OS" has a forty-year record of not arriving; the falsifier is that
  the thing must RUN, not merely render.
- **egad (2026-10-04):** a design system rooted in Emacs: Modus colour tokens with a contrast gate
  (7:1, 4.5:1, 3:1 floors); emitters for CSS, Org-HTML and Emacs themes.
- **Accessibility default (his strong preference, 2026-09-07):** every visual thing follows the
  reader's system light/dark setting, with a manual override that works both ways; measure contrast,
  never eyeball it. Pattern: a complete light palette on `:root`, dark tokens in
  `@media (prefers-color-scheme:dark){:root:not([data-theme="light"])}` and in
  `:root[data-theme="dark"]`, `html{color-scheme:light dark}`, an explicit body background.

## How this shop builds (house rules; apply them)
- **Simple tools for simple jobs:** POSIX sh and awk first; Python stdlib when the data is dense.
- **Literate recipes with markers:** one Org file holds the recipes; blocks are found by plain
  markers (`#+begin_src` with a `:tangle` path, or `# >>> name` / `# <<< name` lines) so an awk
  script can tangle them without Emacs. **Two readers:** where Emacs is available, `org-babel-tangle`
  must produce the same files as the awk tangler; agreement between the two is the evidence.
- **Prove-red:** every test script has `--prove-red`: a green control, then planted faults, each of
  which must be caught. Exit 0 pass; 1 fail; 2 NOT CHECKED (a precondition is missing, said loudly,
  never silently green); 3 stopped unexpectedly, printing a heal prompt ("paste this line and the
  command you ran into a session and ask it to find the cause, prove it red, then fix it").
- **Names:** house tools are named like `xx1yy` (two letters, a digit, two letters).
- **Licences:** code `GPL-3.0-or-later OR LGPL-3.0-or-later`; text `CC-BY-SA-4.0`; one SPDX line
  per file.
- **Minimum noise; honest status:** say what was not checked. Never claim an image boots unless it
  was booted.
- **Freedom of the user:** the reader's environment governs (system theme, keyboard or mouse);
  nothing phones home; nothing is hidden from the person using it.

## Files you may read on Corwin's computer (read-only), for detail
Use the device shell tool `mcp__remote-devices__device_bash` (load with ToolSearch). F:\claude is
`$HOME/mnt/claude` there. Read only these:
- `$HOME/mnt/claude/c4/writing/door-images/DESIGN-2026-09-27-door-image.md`
- `$HOME/mnt/claude/c4/writing/door-images/LENS-2026-09-27-guix-and-arch-as-doors.md`
- `$HOME/mnt/claude/c4/writing/door-images/guix/c4-door.scm`
- `$HOME/mnt/claude/c4/h/EMACS-AS-APP-for-bryant.md`
- `$HOME/mnt/claude/AS4CE/AS4CE0001/skills/lens/SKILL.md` (the LENS method: perspectives, inversion)
- `$HOME/mnt/claude/AS4CE/AS4CE0001/skills/seams/SKILL.md` (two representations of one truth)
Do not write anything there.
