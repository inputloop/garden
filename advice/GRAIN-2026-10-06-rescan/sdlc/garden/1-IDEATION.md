<!-- SPDX-License-Identifier: CC-BY-SA-4.0 -->
<!-- produced-by: lens · subject: larder-spec.md · sha256: c73329874a9363e4b1f5c83898c25cd919610eab171392bd44a0e4fcf49cc381 · 2026-10-06 -->
# 1. Ideation: seven ways to build the software side, and the one picked

Garden team, 2026-10-06. Stage 1 of 6. The subject pinned in the line above is the Larder spec, because
the pick has to serve what the spec asks for.

## How to read this, and the order the work really went in

The research came before this ideation. I read the three briefing files, then the four relevant files
on Corwin's computer (the door-images design and LENS, the Guix recipe, the Emacs-as-app note) and the
LENS and seams skills, then looked up facts on the web (Debian's 32-bit status, the FSF's list,
Debian Libre Live, the Reticulum licences) and checked every package name against Debian's signed
index. Only then did I write the approaches. So the list below is not a blind brainstorm: the facts had
already narrowed it, and the approaches that need facts I did not look up (the small-and-old one, A7)
are thin on purpose.

Notation. OBSERVED is what I read, with its source or the command. JUDGED is my reading. The dagger
mark (see seams) sits on a claim that rests on one source; its count is in `6-REVIEW.md`. When a
number is invented it is one of the house set 4, 9 or 17, and it says so. A concern says whose it is
in words, and has a falsifier in `2-ANALYSIS.md`.

## What the group needs (OBSERVED)

- The stick must turn reclaimed laptops into a persistent encrypted workstation (`larder-spec.md:6`),
  and Phase 1 says to boot it on three or more of them: BIOS-only, UEFI and Secure Boot
  (`larder-spec.md:156`). Minimum laptop specs are still to be written down (`:160`).
- The spec already lists the base: "Debian Live stable, amd64 (+ i386 image for old machines), XFCE"
  (`:86`), "GRUB, UEFI + legacy; shim for Secure Boot" (`:87`), and ticks "Base distro: Debian Live" as
  decided (`:146`). The brief asks us to argue the base anyway: "GNU Guix, Arch (or an Arch derivative),
  or Debian, argued from the group's needs" (`PROBLEM.md:14`).
- Phase 1 names the software: XFCE, LibreOffice, Nextcloud client, Kiwix, `rns`, NomadNet, Sideband,
  WireGuard (`larder-spec.md:154`).
- The shop's rules that bear on the choice: the reader's environment governs and nothing is hidden
  (`garden-context.md:65`); say what was not checked (`:63`); "Guix on laptops often needs non-free
  Wi-Fi firmware; Arch is not FSF-free; Parabola is the free Arch derivative" (`:36-37`).
- Corwin's order of work: "build the free-software distro first, without the Dragaera content"
  (`garden-context.md:14`).
- A newcomer sees one window, plain choices, and needs only a mouse (`PROBLEM.md:11`).

## Seven approaches

The first four differ in the base. A5 and A6 differ in what is delivered. A7 differs in the age of the
hardware it aims at. The shell has its own short list after them.

### A1. Debian 13 "trixie" with live-build and canned package lists (the spec's own default)

One text list per profile and one set of `lb config` flags; `lb build` makes a hybrid ISO that boots
from a stick.
- Good for: the group's actual list (Kiwix, Nextcloud client, LibreOffice, WireGuard are all in Debian
  main; checked by name against the signed index, 2026-10-06). A signed boot chain comes with it:
  live-build installs `shim-signed` and the signed GRUB when asked for Secure Boot (read in the
  live-build source, not run†). Debian 13.7 is current stable; end of regular support 2028-08-09,
  end of long-term support 2030-06-30 (debian.org/releases†).
- Costs: not on the FSF's list. The FSF says "Until 2022, Debian GNU/Linux came fairly close to
  qualifying as a free distro" and names firmware offered by the Debian 12 installer and the `contrib`
  repository (gnu.org/distros/common-distros†). Debian's own official live images carry non-free
  firmware since Debian 12; I found this in a Debian Libre announcement and a forum thread, not on a
  Debian page. trixie "is no longer supported" on 32-bit x86: "there is no official kernel and no Debian
  installer for i386 systems" (Debian 13 release notes, issues page), which contradicts the spec's
  i386 line. The Reticulum stack the spec lists is not in Debian main (names and descriptions searched).
- Falls over if: the free (main-only) profile cannot get the group's laptops onto a network and the
  group will not accept a firmware add-on; or too many of its laptops are 32-bit only.

### A2. GNU Guix System image (the door reader Corwin already built)

A declared operating system in Scheme, built with `guix system image`.
- Good for: the free-software position. Guix System is on the FSF's list (gnu.org/distros/free-distros,
  read by me; also in Corwin's LENS board 4). One file declares the whole system, which suits a shop
  that writes literate recipes: `c4-door.scm` is about thirty lines and inherits Guix's installer.
  Corwin's door-images note records that Guix ships images for i686 as well as x86_64 (his LENS board 1,
  quoting the Guix 1.5.0 release post; I did not read that post†). That would cover the 32-bit
  laptops that trixie cannot.
- Costs: his own board 3: on Guix "many laptops' Wi-Fi needs non-free firmware, which Guix does not
  ship", so "a door that opens onto no network fails the person it was built for." Secure Boot:
  a 2022 guix-devel message says Guix does not yet have complete Secure Boot support: "we currently do
  not have 100% secure boot"†. It may be out of date. Whether the Reticulum stack and Kiwix are packaged
  for Guix, I did not check.
- Falls over if: the group's laptops need Secure Boot and Guix still cannot support it; or volunteers
  will not touch Scheme.

### A3. An Arch-derived image with archiso ("based on Arch Linux")

A profile of `releng` plus the group's files, as in Corwin's second door reader.
- Good for: current software, one monthly ISO, and the existence proof that organisations put a door on
  Arch (SteamOS; his LENS board 2).
- Costs: it cannot be called free: "Arch has no policy against distributing nonfree software through
  their normal channels, and nonfree blobs are shipped with their kernel" (gnu.org, common-distros,
  read by me, and his board 4). The name rule: "based on Arch Linux", no Arch logo (his board 4). A
  rolling release makes a stick that sits in a drawer go stale. Secure Boot on Arch's ISO: I tried the
  Arch wiki and was refused (an access-denied page), so I do not know.
- Falls over if: the movement's position matters more to the group than reach, or if the stick must be
  trusted after two years in a drawer.

### A4. A "free by construction" derivative: Parabola, or the Debian Libre Live Images

Take someone else's free build instead of making ours free.
- Parabola GNU/Linux-libre is on the FSF's list and is "based on Arch" (gnu.org). Its front page says
  images are provided for armv7h, i686 and x86_64†. Whether it is alive is unclear: my read of its
  front page showed no dates, and Corwin's note found no dated news newer than 2022-11-08 (his board 4).
- Debian Libre Live Images (Simon Josefsson; first amd64 ISOs November 2025): "run and install Debian
  GNU/Linux without non-free software", built with live-build, amd64 only, unofficial, and "calibrate
  your expectations" (his blog and a news write-up). A reviewer reported no Wi-Fi support and no
  repositories configured†. It says nothing about Secure Boot.
- Good for: the movement's position with the least work for us.
- Falls over if: the project is not maintained, or we cannot get a laptop onto a network with it.

### A5. No image of our own: stock Debian Live plus a signed provisioning script

Hand out Debian's own live stick and add Larder by running the spec's signed `larder-setup`
(`larder-spec.md:95`) on first boot.
- Good for: nothing to build, host or sign except the script; Debian signs the image.
- Costs: apt installs need a network, so it fails the offline case, and the official image carries
  non-free firmware, so no free profile can be offered. Five profiles become five scripts.
- Falls over if: the group needs a stick that works with no network on first boot (it does: the library
  is offline).

### A6. Recipes only: publish the source, ship no image

The Org file and its tools are the product; each chapter builds its own stick.
- Good for: the group never distributes a binary, so the GPL duty to carry source or a written offer
  with every copy (Corwin's board 5, GPLv3 section 6) falls on whoever builds; no image to keep signed.
- Costs: the people who most need a stick are the least able to run a build. In practice someone must
  build, so A6 is the source form of whichever of A1 to A4 is chosen, not a rival to it.

### A7. Small and old first: a RAM-booting minimal system for 32-bit laptops (not researched)

Aim the first stick at the oldest machines and grow up from there. I looked up none of the candidates
(Alpine, antiX, Tiny Core, Debian bookworm i386, Guix i686). I list it because A1 loses the 32-bit
laptops the spec asked for and the group has not counted how many it has (`2-ANALYSIS.md`, unknown U1).
Nothing below depends on it.

### The first-run shell: four ways

- S1. An HTML page shown full screen by the browser. Light, no framework, easy to make accessible, the
  system's light or dark setting is a few lines of CSS. Needs a window system and a browser.
- S2. An Emacs frame: kiosk, one window, mouse first (Corwin's note `EMACS-AS-APP`, stage 1: "a
  chrome-less frame ... mouse-first ... type-to-specify"). Works on a text console with `gpm`. The note's
  hazard applies: the falsifier is that it must RUN, "not just render".
- S3. Both, chosen by what the profile has: the page where there is a desktop, the Emacs frame where
  there is only a console.
- S4. A native toolkit program (Python with GTK, say). A "heavy framework" the brief rules out.

## The LENS pass

No canon in reach (`CANON.md` and `PRINCIPLES.md` are not among the six files I may read), so the
principles step below uses the order in the LENS skill as a quoted snapshot, not my own.

```
LENS · the choice of base and delivery for the Larder software side · 2026-10-06
a  my view:            Debian trixie with live-build and canned lists, the free profiles main-only,
                       firmware and the Reticulum stack as labelled opt-ins, an HTML page where there
                       is a desktop and an Emacs frame where there is not.
b  the view I ascribe: Corwin (the keeper) wants a base the movement can hand out without a footnote,
                       a literate recipe, nothing phoning home, a mouse-first Emacs surface, and
                       status that says what was not run. He built Guix and Arch doors first and
                       would read a Debian pick as the compromise it is.
c  their pull on mine: (what in a is there because of b) firmware is its own list and the four free
                       profiles stop at main; every profile's build flags say so; the Reticulum row
                       carries a standing column; the console shell is Emacs; the page follows the
                       system theme and measures its contrast; two readers tangle the recipe.
d  my pull on theirs:  (what in b is there because of me) I wrote "the compromise it is" into his view.
                       His own words only say that Guix on laptops often needs non-free firmware and
                       that Arch is not FSF-free (garden-context.md:36-37); they do not rank Debian.
                       I am the one who treats the FSF's list as a cost of this pick. I also assumed
                       he cares about 32-bit laptops because the spec does; his notes are silent.
persona / inverse:     see below
principles reframe:    see below
notes: written (this section); one run of the persona pass, see the caution below
```

### The second four: two people's views, held apart

The brief asks for a base and the spec has already chosen one, so two people's views are being weighed:
Brigidt, who wrote the spec (the notes call her Brigidt, also written Bridget), and Corwin. These are my
construals, not the people. Where I have no words of theirs, the line says invented.

```
b.A   Brigidt, as I construe her: Debian Live is settled because it boots on the widest range of
      reclaimed hardware with the least surprise, and "durable, persistent, secure" beats purity.
      (her words: larder-spec.md:19, :86, :87, :146)
b.B   Corwin, as I construe him: the base should be one the movement can hand out whole, and where
      that costs reach (firmware, Secure Boot) the cost is named, not hidden; he has already built the
      Guix and the Arch door and left the firmware fork open to himself.
      (his words: garden-context.md:36-37, :63, :65; door-images LENS board 3 and 4, lines 102-146)
b.AB  where they meet, named: both can live with Debian if "free by default" is a real, tested thing
      (a main-only profile) and the cost to reach is a separate, labelled list. That meeting point is
      checkable: `lr1ck` B9 and B10 fail if a free profile holds a non-free firmware package.
```

Parties with no words of their own in my packet. The skill's form has two parties; these extra lines
are my extension and are marked invented so they are not read as findings.

```
b.D   the author (Steven Brust), as I construe him: wants readers to publish fan work without his reading
      it, and wants a written OK before anything derived from his books goes out. These two pull apart
      (see 2-ANALYSIS risk R7). (his words: reported by Corwin at garden-context.md:8-13 and :22-25;
      none are his own)  invented in the sense that he has said none of this to me.
b.N   a newcomer holding the stick: wants to be told in plain words what each button does and to be able
      to stop. (their words: invented)
```

### Persona, then its inverse

The persona is the shop's own voice: simple tools for simple jobs, evidence from two readers, honest
status (`garden-context.md:50-66`).
- The persona would put the pick like this: Debian, because live-build is shell and lists; a free
  profile that stays free by a test; firmware as its own file; every claim that two readers can check
  gets checked by two.
- The inverse persona is the person who inherits this in two years: a volunteer who has never seen the
  repository and wants the cheapest thing that keeps working. It says: you have built a literate Org
  source, two tanglers, a 700-line test script, an Emacs shell, a web page and an author overlay for a
  stick that does not yet boot. A reader has to hold six languages in their head to change one package:
  sh, awk, Org, Emacs Lisp, JavaScript and HTML with CSS. Simple for whom?
- Finding (the persona could not have written this line): the pipeline is easy for its author and may be
  expensive for its maintainers. Falsifier, with an invented number: give the repository to someone who
  has not seen it; if they cannot add one package, see the test go green, and see it go red for a typo
  in under 17 minutes (17 is invented), the pipeline is too heavy and A5/A6's plain files win.

Caution from the skill: a persona shows reasons, not decisions, and I ran this pass once. I cite the
reasons; I do not claim they moved the pick beyond the noise of a rerun.

### Principles reframe

Order, quoted from the skill: universalism and egalitarianism first, then the four freedoms, then the
software-freedom movement, then the wider scientific and technical community.

1. The free profiles are main-only, and firmware is a separate opt-in.
   - Universalism and egalitarianism: a free-only default puts a stick in a person's hand that cannot
     reach a network on their machine; a firmware-on default hides a choice from the person least able
     to check it. Neither default is fair to everyone, so the stick offers both lists and says which is
     which.
   - The four freedoms: firmware you cannot study or change falls short of freedom 1 and freedom 3; the
     person should know when they take it.
   - The movement: the FSF does not list Debian partly for this reason (gnu.org†), so the free profile
     is a way to hand out the movement's position without claiming Debian is on its list.
   - The technical community: a laptop that cannot reach Wi-Fi is a hardware fact, and a firmware list
     is the usual fix.
2. The Reticulum stack is an add-on with a "standing" column, not a package in a profile.
   - Egalitarianism: a licence that limits use by field ("shall not be used in any kind of system which
     includes amongst its functions the ability to purposefully do harm to human beings"†, and no use to
     make a machine-learning training set†) treats users unequally by what they do.
   - The four freedoms: a limit on what you may run it for is a limit on freedom 0, whatever its aim.
   - The movement: such licences are not free software licences. Sideband is under CC BY-NC-SA 4.0†,
     which forbids commercial use; NomadNet is GPL-3.0†.
   - The technical community: the stack is not in Debian, so it cannot be a `.deb` in the list in any case.
3. The author's permission notice is a draft with questions, and the stamp refuses without a signature.
   - Egalitarianism: an author and fans are not equal parties; the notice has to be readable by the
     weaker one, so it is in plain words.
   - The four freedoms: the author's rights are his; nothing in the code grants one.
   - The movement and the community: share-alike terms exist so that permission cannot be taken back
     on works already shared (the Creative Commons FAQ says its licences "are not revocable"†); a
     custom notice is a different instrument, and which one the author wants is his to say.
4. The tests can fail on purpose (`--prove-red`).
   - The technical community: a check that has never been seen failing has not been shown to check.

## An inversion of the whole task: how to make this fail

The persona pass flips a voice. This flips the goal.
- Ship an image nobody booted and call it ready. (The prototype boots nothing and says so.)
- Pick the base for the label on the box. (The pick below is argued from the group's laptops, and the
  base is the one part of this I would change first if those laptops disagree.)
- Put a stranger's licence in a package list without reading it. (The mesh stack is kept out of every
  profile for this reason.)
- Treat a draft permission notice as a grant. (The stamp tool will not stamp without a signature.)
- Make a pipeline so clever that only its author can change it. (The inverse persona's finding above.)
- Count a test that has never gone red as passing. (`--prove-red` plants faults on a copy and each must be caught.)

## The pick

**A1 for the base and the delivery; S3 for the shell.** Debian 13 "trixie", built with live-build from
five lists and five sets of flags generated from one Org file. A page where there is a desktop, an
Emacs frame where there is only a console. A4's idea survives as the shape of the four free profiles
(main only, firmware off). A2 and A3 are kept as named alternatives in `2-ANALYSIS.md`; I built neither.

Why, from the group's needs:
1. Reclaimed laptops that need Secure Boot. The one signed boot chain I have evidence for is Debian's
   (read in live-build's source, not run†). Guix's is reported incomplete†; Arch's I could not read.
2. A stick that works unattended for years. Debian stable is the slowest of the four to change; its end
   date, 2028-08-09†, is a real cost: the pick has an end of life in about 22 months, 2030-06-30 with
   long-term support.
3. The software the spec names. Kiwix, the Nextcloud client, LibreOffice and WireGuard are in Debian
   main. The Reticulum stack is not (names and descriptions searched). I did not check Guix or Arch, so
   I cannot say it is better there.
4. The movement's position. The pick is Debian, which the FSF does not list; the free profiles, a firmware
   file kept apart and a standing column on the Reticulum row exist to make that cost visible and
   small, and a Guix image remains the way to hand out the movement's position whole. This is the
   point where I most expect Corwin to disagree.
5. Who will keep it alive. live-build is shell and lists; the spec's Phase 1 expects Debian; Scheme
   would be a new skill for volunteers. The inverse persona above says this is the weakest of the five.
6. Corwin's order of work: free-software distro first; the author's edition is an overlay on the
   desktop profile, not a different base.

What would reverse the pick is in `2-ANALYSIS.md` ("What would prove the pick wrong"). What I did not
do: build or boot anything, try A2 or A3, or count the group's 32-bit laptops.
