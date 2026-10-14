# The problem (the same for both teams)

A volunteer organizing group wants a **USB-distributable GNU/Linux** it can hand to members and
new organizers. A hardware stick for the same group is already specified (`larder-spec.md`: a
Debian Live boot stick with a secure element and a LoRa radio). Your job is the **software side**
that could ride on that stick, or on any ordinary USB stick.

What is wanted:
1. **Canned recipes**: five profiles a builder can pick from: `minimal`, `desktop`, `homelab`,
   `hardened`, `fullsink` (everything).
2. **A kiosk-style first-run shell**: what a newcomer sees when the stick boots: one window, plain
   choices, works with a mouse alone. An HTML page, an Emacs frame, or both are acceptable; a heavy
   framework is not.
3. **A base**: GNU Guix, Arch (or an Arch derivative), or Debian, argued from the group's needs.
4. **One variant for an author**: an edition of the stick that carries an author's own books and a
   short permission notice letting readers publish fan works under a "by permission" watermark,
   without the author reading them first.

Work through six stages and write one file per stage in your folder:
1. `1-IDEATION.md`: at least five distinct approaches, then the one you pick and why.
2. `2-ANALYSIS.md`: constraints, risks, unknowns, and what would prove your pick wrong.
3. `3-DESIGN.md`: the architecture, a table of the five profiles, and the first-run flow.
4. `4-BUILD/`: a working prototype you can run in a plain Linux shell without network or root:
   - the recipes in one source file, from which each profile's package list is generated
     (`out/<profile>.packages`);
   - the first-run shell (an HTML page and/or an Emacs Lisp file);
   - the author variant's permission notice.
5. `5-TEST/`: a test script that checks the prototype, and that can show itself failing on purpose
   (plant a fault, show the test catch it). Run it and save the output.
6. `6-REVIEW.md`: your own honest review of the work: what is good, what is weak, what you did not
   check, and what you would do next.

Keep the prototype small: a few hundred lines in total is plenty. Do not build ISO images, do not
install packages, do not use the network for the build. Licence everything you write
GPL-3.0-or-later (code) and CC-BY-SA-4.0 (text), with SPDX lines.
