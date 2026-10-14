# Wild and garden: the same problem, with and without what we know

Lab notes, 2026-10-06. The paired run Corwin asked for: a "vanilla" approach (**wild**) and "our
way" (**garden**), taken across six stages, to see where skill and context help.

## The run

- **The problem:** the software side of a USB-distributable GNU/Linux for an organizing group. It
  had to ride on Brigidt's Larder stick spec, with:
  - five canned recipes (minimal, desktop, homelab, hardened, fullsink);
  - a kiosk-style first run;
  - an author's edition carrying their books and a "by permission" fan-works notice.
  - The task text is in `sdlc/PROBLEM.md`.
- **The two teams.** Both were Sonnet, the smallest vendor model tonight's reading GRAIN trusted.
  - **Wild** got the problem and the spec.
  - **Garden** also got `garden-context.md`: the shop's prior work (the door images, Emacs-as-app,
    egad, the accessibility default), Dad's terms and the rights picture, and the house rules
    (literate recipes with two readers, prove-red with exit codes, xx1yy names, SPDX). It was told
    to use the LENS and seams methods.
- **The six stages:** ideation, analysis, design, build, test, review. Each team wrote one file per
  stage plus a runnable prototype.
- **The reviewers:**
  - **Opus, open:** it cannot be blind, because the garden's vocabulary gives it away. It also ran
    both suites and its own mutation probe.
  - **The local gemma, blind:** it compared the two first-run pages and the two permission notices
    under randomized labels (`review/BLIND-KEY.tsv`).

## Results

| | wild | garden |
|---|---|---|
| Tokens / tool uses / minutes | 105k / 127 / 67 | 373k / 180 / 58 |
| Prototype size | ~680 lines, 3 languages | ~1,250 lines, 6 languages |
| Own suite | 35/35 pass; 27/27 planted faults caught | 42/42 pass; 40/40 planted faults caught |
| Regenerates its own outputs from one source | yes | yes, by two readers (awk and Emacs) that agree |
| Opus mutation probe (30 single-line deletions) | 2 survive | 10 survive, 2 of them real faults |
| Opus, per stage (ideation/analysis/design/build/test/review) | 4/4/4/4/5/5 | 4/4/3/3/4/4 |
| gemma blind, first-run page | 22/25 | **25/25, preferred** (theme-aware, plainer words) |
| gemma blind, author notice | **23/25, preferred** ("a functional notice") | 19/25 ("a workspace for the author and lawyer") |

The two teams converged on the base: Debian 13 with live-build. Each found real faults in the spec
that the other missed:

- **Both found:**
  - trixie has no i386 kernel or installer, so the spec's i386 image does not exist on that base;
  - Reticulum, LXMF, NomadNet and Sideband are not in Debian and are not DFSG-free. Reticulum
    carries no-harm and no-AI-training clauses, and Sideband is CC BY-NC-SA. **Charging for sticks
    may breach Sideband's terms.**
- **Only the garden found:** Debian enables `tor` and `i2pd` at boot (read in their `postinst`).
  That breaks the spec's "Tor available but not forced", and the wild team's `desktop` profile
  carried both.
- **Only the wild team found:**
  - Sideband may not run on Debian 13's Python;
  - `usbguard`'s default deny would lock out the stick's own radio;
  - a CC-BY-SA wrinkle in the watermark sentence.

## What the context changed, by stage

| stage | it helped | it hurt |
|---|---|---|
| Ideation | real prior art (the door images, Guix/Parabola, GPLv3 §6); LENS's inverse persona surfaced maintainer cost | LENS framing put "what Corwin would want" beside the spec author's needs; wild covered a wider technical span faster |
| Analysis | Dad's terms and the per-title rights picture produced the most consequential design change in either submission; reading `postinst` (the two-readers habit) found the Tor default | house numbers (4/9/17) as thresholds made arbitrary falsifiers look quantitative |
| Design | the light/dark pattern, a mouse-first console Emacs frame, a per-right book gate, a signature-gated stamp, free-by-default profiles | the free-software ranking pushed the mesh chat out of four of five profiles **without naming the cost** to the group; the two-readers rule kept a hand-written second page |
| Build | the literate source with two agreeing readers is real; package names checked against a signed index | 1.8× the size; six languages; `xx1yy` names a newcomer cannot read; inline script on the page |
| Test | exit 2 = NOT CHECKED, exit 3 = heal prompt; facts tested against external evidence | checks spent on ritual (head lines, dagger counts); 40 planted faults, each found by its own targeted check, proved weaker than wild's whole-suite plants plus a mutation sweep. The launch path, the one the context itself warned "must RUN", was untested |
| Review | observed/judged split; full disclosure | attention turned inward (Corwin's reaction, daggers) |

## What it means (bold, and labelled as mine)

1. **The garden's facts win and its rituals lose.** Context that carries *stakeholder facts and
   duties* changed the outcome where nothing else could:
   - who decides, and the rights title by title;
   - a draft that is not a grant;
   - the accessibility pattern;
   - GPLv3 §6;
   - the exit-2 rule.

   Context that carries *procedure* doubled the cost and found no product fault:
   - LENS head lines and dagger counts;
   - house numbers as thresholds;
   - naming schemes;
   - checks on documents.
2. **This is Bryant's rule, measured:** "if it's not pragmatic it better damn well be *essential*."
   Procedure earned its place where it caught faults (reading `postinst`, exit 2), and nowhere else.
3. **Values given as rankings displace needs unless they carry a price.** "Free first" was right as
   a default and wrong as a silent override of the group's core need, the mesh. The fix is a
   sentence, not a rule: *name what the value costs the people served, then choose.*
4. **Prove-red as ritual is weaker than prove-red as attack.** Planting one fault per check proves
   each check can fire. A blind mutation sweep proves the suite covers the code. The garden did the
   first; the wild team did both.
5. **The minimum effective context pack** for the next task like this:
   - stakeholder facts and who decides;
   - values as defaults with a duty to price them;
   - the accessibility pattern;
   - exit 2 = NOT CHECKED;
   - pointers to prior art and legal duties, given as facts.

   Leave out naming conventions, method procedures, house numbers and document-meta checks unless
   the task is *about* them.

## The two readers disagreed once, and that is information

On the author notice, Opus found the garden's draft "clearly safer for the author", while gemma
preferred the wild one as "a functional, reader-facing notice". Both are right about different
readers. The garden wrote for Dad and his counsel (which Dad's 08-01 terms require). The wild team
wrote for the fan. **Next:** a notice in two layers.
- A fan-facing face (wild's clarity).
- Beneath it, the terms Dad and counsel settle (garden's gates). Nothing ships until counsel has
  read both.

## Not checked

- Nothing was booted, built into an ISO, installed or clicked.
- The mesh licences were read from upstream files, not by counsel.
- Opus's scores are one reader. gemma saw only two artifact pairs.
- The garden team's context was written by me, from tonight's survey, so its quality is part of
  what was measured.

---
*Version 1.0.0: first edition on 2026-10-06; spine: 2026-10-06.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4:
https://creativecommons.org/licenses/by-sa/4.0/; Mentat (for Corwin; claude-opus-5-5)
