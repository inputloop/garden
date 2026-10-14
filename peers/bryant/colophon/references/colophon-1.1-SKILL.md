---
name: "colophon"
description: "colophon: the garden's license and its makers, stamped before anything ships. Use when Bryant's files are made or leave (a shelf, a release, a sealed skill), and on 'license this', 'SPDX', 'REUSE', 'who made this', 'credit Corwin'. Code GPL-3.0-or-later OR LGPL-3.0-or-later; prose CC-BY-SA-4.0. Finds every maker on evidence and names them; shared work keeps only terms all makers offer. Power-glove's Tag."
---

# colophon: who made it, and how it may be used

*v1.1 (2026-10-05) · author: Bryant Frankford (by proxy) · family: Gauntlet Nexus. The version is
stated here as well as in the frontmatter, because one save path keeps only the name and description.*

A colophon is the note at the end of a book that says who made it and on what terms. This skill
puts the garden's colophon on everything Bryant makes before it leaves his hands, names everyone who
made part of it, and keeps his terms off everything he did not make. It is the **Tag** of
`power-glove`: the label sewn inside the glove.

## The terms: the makers' word

> "The license is fine: we are shipping it all together as GGPLv3+ / CC-BY-SA (4) / LGPLv3+."
> (Bryant, 2026-10-05)

Settled the same day on his answers: "GGPL" meant the GNU GPL; LGPL is offered on all code; his name
and email go in copyright lines; the slot is the Tag.

| Maker | Code | Prose and art | Their word |
|---|---|---|---|
| Bryant Frankford | `GPL-3.0-or-later OR LGPL-3.0-or-later` | `CC-BY-SA-4.0` | the keeper, 2026-10-05 |
| Corwin Brust | `GPL-3.0-or-later` | `CC-BY-SA-4.0` for prose; art not yet declared | his parcel, 2026-10-04 |

- **Copyright lines:** `2026 Bryant Frankford <nathanielfrankford@gmail.com> and Contributors`, and
  one line for each other maker (`2026 Corwin Brust <corwin@bru.st>`). The year is the year the work
  was made, or the years git shows; an existing year is never rewritten.
- **Work two makers share keeps only the terms both offer.** Code Bryant and Corwin made together is
  `GPL-3.0-or-later`, because the LGPL offer is Bryant's alone; if Corwin joins it, his row changes
  and the next `apply` widens those files. Narrowing is ours to do; widening needs the other maker's
  word.
- **Credit line (optional, honest):** `Written with Alfred (for Bryant; MODEL)`. An agent is credited,
  never a copyright holder; the principal it wrote for is the maker.
- **What "OR LGPL" means:** a recipient may take Bryant's code under either license, so in practice it
  carries LGPL's terms (the GPL, plus permission to link it from programs under other terms). The
  keeper chose this knowingly.
- **New makers** join the table on the keeper's word, in `.colophon-parties.json` at the root (or
  `--parties FILE`): their names, emails, agents, and the terms they offered, dated.

## Every maker named

The keeper's word, 2026-10-05: "If you can detect that Corwin has contributed to some work then Corwin
should be attributed." Asked how far, he answered: work derived from someone's makes them a co-owner,
under the terms they offer, and work built on their ideas or disciplines does too.

<!-- colophon-ignore-start: the forms below are examples, not statements about this file -->
| Evidence | Its form | Reaches |
|---|---|---|
| A copyright notice | `Copyright 2026 NAME`, or an SPDX copyright line, in a header | that file |
| A byline | `Mentat (for NAME; MODEL)` opening a line | that file |
| A lineage line | `Lineage: NAME's tool`, or `Derived from NAME's work`, opening a line | that file; in a SKILL.md, the whole skill |
| An authorship sentence | `this was written by NAME`, `co-made with NAME`, `the joint NAME and NAME protocol`, `this is NAME's own discipline`, `the design is from NAME's lab` | the same |
| Git history | a commit by the maker, or a `Co-authored-by` trailer naming them | that file |
| A parcel | a file in `parcels/*from-NAME*/`: an unchanged copy is theirs alone, under their terms; an edited copy (60% of its lines the same) is shared | that file |
<!-- colophon-ignore-end -->

- **A mention is not a maker.** Talking about someone (his side of the wire, his parcel, his tool)
  names no one. `who` lists a file that mentions a maker five or more times without saying what they
  made (NOTE, with the closest line), so the keeper can add a lineage line where they did.
- **A maker nobody has named is asked about, never guessed.** A git author, or a lineage line naming
  someone outside the table, is an ASK: who are they, and on what terms? Until answered, the file is
  held.
- **Agents and bots are never makers.** Alfred, Claudewin, Mentat, Claude and `[bot]` accounts are
  credited in bylines; the principal they wrote for is the maker.
- **Their unchanged file stays theirs.** A parcel copy is declared under its maker's copyright and
  terms and never stamped, so its bytes, hashes and seals stay whole.
- **A hand declaration stands.** A REUSE.toml entry written by hand is respected; `check` asks only
  that every maker found is named in it (the keeper may leave his own line off a file that is someone
  else's).
- **Text that describes other files** (a README's lineage list, an example) sits between
  `colophon-ignore-start` and `colophon-ignore-end` comments, which colophon does not read for makers.

In the garden today (the bundle of 2026-10-05), colophon names Corwin Brust as a co-owner of alfred
(its map's design came from his lab), consent-gate, eclipse-pass, mega-voltron, primer, signet and
wire-protocol, whose code is therefore `GPL-3.0-or-later`; principles and session-rotate are his, and
color-theory is shared.

## When the Tag fires

- Files Bryant made (or Alfred made for him) are created or changed in a house this garden keeps.
- Something is about to leave: a shelf (`mega-voltron`), a release (`aethernet-release`), a sealed
  skill (`signet`), a hand-off cocoon (`caterpillar`), a one-file page (`primer`).
- It is asked for: "license this repo", "apply licensing", "SPDX", "REUSE", "what license is this",
  "is this compatible", "who made this".

The Tag never receives a fare by itself: "license this repo" is a palm fare whose work is the tag's.
**Exit order** (power-glove): the Tag stamps, the Ring checks, the other hand rechecks, the Cuff
seals. Stamping changes bytes, so it goes first; every hash after it covers the licensed bytes.

## The gates (hard)

1. **Never relicense someone else's work.** A file that already declares other terms (an SPDX line,
   or an MIT, Apache, BSD or GPL notice in its first lines) is FOREIGN: its notice stands, it gets a
   compatibility screen, and it never gets our header. Corwin's notices stand. Anthropic's skills stay
   Anthropic's and never enter a bundle of ours. Work someone else made part of carries only the terms
   they offered.
2. **In a house we do not keep, its terms win.** `kid-glove` reads them; our new files there take the
   house's license. A house with no readable license is its owner's question: a HOLD, never a gap
   we fill.
3. **Never stamp a secret.** A secret-shaped file (SECRETS, .key, .pem, .env, id_rsa) is refused,
   because it must not ship at all. A `.example` file is fine.
4. **Plan before sweep.** An existing repo gets `who` and `plan` first, shown to the keeper; `apply`
   runs on his word. New files are stamped as they are made.
5. **Nothing ships unlicensed.** `check` passes before a shelf, a release, or a bundle leaves. A check
   that could not run says NOT CHECKED, never a silent pass.
6. **Minted things keep their bytes.** SKILL.md files and other versioned canon are declared in
   REUSE.toml, not edited to carry a header. New skills are born with a footer (this file's is the
   pattern).
7. **Every maker is named, on evidence.** A file that carries someone's work names them in its
   copyright; a file whose maker nobody can name is held. `check` fails on either.
8. **Not legal advice.** This is a quick, honest screen. A real dispute goes to a person who practices
   law.

## With the script

`scripts/colophon.py` (stdlib Python 3) carries the terms, the makers and their terms, the comment
styles, the compatibility screen, and the three license texts in `scripts/LICENSES/`, each checked
against its pin before use.

| Command | Does |
|---|---|
| `colophon.py who ROOT` | Every maker of every file, on evidence: MAKERS (shared), THEIRS (someone else's), ASK (a maker nobody has named), NOTE (mentions with no lineage line). Writes nothing; `--json` for tools. |
| `colophon.py plan ROOT` | Says what `apply` would do: STAMP, TOML, HAS, ATTRIB (a header that misses a maker, or offers more than every maker does), FOREIGN, ASK, SECRET. Writes nothing. |
| `colophon.py apply ROOT` | Stamps headers naming every maker, repairs headers it wrote (ATTRIB), writes a managed block in REUSE.toml, adds the license texts used. Running it twice changes nothing. |
| `colophon.py check ROOT` | Every file declared with a copyright line; every maker named (UNNAMED); no shared file offering terms a maker did not (TERMS); no unknown maker (ASK); texts present and pinned; secrets refused; foreign terms screened; then `reuse lint` as the second reader. |
| `colophon.py texts DEST` | Writes the pinned texts into `DEST/LICENSES/`. |
| `colophon.py --selftest [--prove-red]` | 35 checks on two made-up houses; `--prove-red` plants eight faults and requires each to be caught. |

Flags: `--parcels DIR` (or `KEY=DIR`; `parcels/*from-NAME*/` inside or beside ROOT are found on their
own), `--parties FILE`, `--no-git`, `--joint "NAME <EMAIL>"` (an extra line on every file),
`--toml-only` (declare without editing any file: bundles and canon), `--art-is-ours`, `--year YYYY`.

How `apply` stamps: a header in the file's own comment style, placed after a shebang, a coding line,
`<?php`, `<!doctype>`, `<?xml`, markdown frontmatter, or `@echo off`, with the file's line endings
kept. PHP that opens with HTML gets its own silent `<?php ... ?>` block. What cannot take a comment
(json, csv, txt, binaries) is declared in REUSE.toml by explicit path, never by a glob that could
swallow someone else's file, and a path someone declared there by hand is respected, never
re-declared. Exit codes: 0 clean, 1 gaps, holds, asks or refusals, 2 could not check.

## By hand (no script, as after a card-only install)

<!-- REUSE-IgnoreStart -->
The header, in the file's comment mark, one copyright line per maker:

```
# SPDX-FileCopyrightText: 2026 Bryant Frankford <nathanielfrankford@gmail.com> and Contributors
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
```

Code two makers share names both and keeps only the terms both offer:

```
# SPDX-FileCopyrightText: 2026 Bryant Frankford <nathanielfrankford@gmail.com> and Contributors
# SPDX-FileCopyrightText: 2026 Corwin Brust <corwin@bru.st>
# SPDX-License-Identifier: GPL-3.0-or-later
```

Prose takes `CC-BY-SA-4.0` instead. Comment marks: `#` for sh, py, rb, yaml, toml, Makefile,
.htaccess and org; `//` for js, ts, go, c, java and php (after `<?php`); `/* */` for css;
`<!-- -->` for html, xml, svg and markdown (after the frontmatter); `;;` for elisp; `--` for sql and
lua; `@REM` for bat (after `@echo off`).

What takes no comment goes in `REUSE.toml` at the root:

```toml
version = 1

[[annotations]]
path = ["data/config.json", "notes/todo.txt"]
precedence = "closest"
SPDX-FileCopyrightText = "2026 Bryant Frankford <nathanielfrankford@gmail.com> and Contributors"
SPDX-License-Identifier = "GPL-3.0-or-later OR LGPL-3.0-or-later"
```
<!-- REUSE-IgnoreEnd -->

To find makers by hand: read each file's header and any lineage line, run
`git log --format='%an <%ae>' -- FILE`, and compare the file with any parcel on disk. A name you
cannot place is a question for the keeper, not a guess.

The texts go in `LICENSES/`, one file per identifier used, taken from their stewards and checked
against these pins (fetched 2026-10-05). A text that does not match its pin is not used: the steward
may have reformatted it, so compare by hand.

| File | Steward copy | sha256 |
|---|---|---|
| `LICENSES/GPL-3.0-or-later.txt` | https://www.gnu.org/licenses/gpl-3.0.txt | `3972dc9744f6499f0f9b2dbf76696f2ae7ad8af9b23dde66d6af86c9dfb36986` |
| `LICENSES/LGPL-3.0-or-later.txt` | https://www.gnu.org/licenses/lgpl-3.0.txt | `e3a994d82e644b03a792a930f574002658412f62407f5fee083f2555c5f23118` |
| `LICENSES/CC-BY-SA-4.0.txt` | https://creativecommons.org/licenses/by-sa/4.0/legalcode.txt | `28a9529c7d0bb4dc51f4bf5c116a3d16ef247a052f7591466768ddf563fd1cf5` |

LGPL code always ships with the GPL text too, because the LGPL is written as additions to it. To
check by hand: `pip install reuse` and run `reuse lint`; without it, read the head of every file
and say NOT CHECKED for any you could not read.

## Compatibility, quickly (not legal advice)

| Their terms | Beside or inside our code | Beside or inside our prose |
|---|---|---|
| MIT, BSD-2/3-Clause, ISC, Zlib, 0BSD, CC0-1.0, Unlicense, Apache-2.0, MPL-2.0, GPL-2.0-or-later, GPL-3.0, LGPL-2.1-or-later, LGPL-3.0 | Fine; it keeps its own notice | Not applicable |
| AGPL-3.0 | Combines with GPLv3; its parts keep their network terms (a note, not a hold) | Not applicable |
| CC-BY-4.0, CC-BY-SA-4.0, CC0-1.0 | Not applicable | Fine; attribution travels with it |
| GPL-2.0-only, any CC NC or ND, SSPL, BUSL, proprietary, unknown | HOLD: the keeper decides | HOLD |

## Bundles and skills

- **A bundle of skills** carries a REUSE.toml at its root declaring every file and every maker, and a
  LICENSES/ folder with the texts it uses; nothing inside a skill is edited. `colophon.py apply BUNDLE
  --toml-only` writes exactly that, with precedence "override" so an example inside a SKILL.md is
  never taken for that file's terms.
- **A skill leaving alone** gets its texts first (`colophon.py texts SKILL_DIR`), then `signet`
  seals it: stamp, then seal, never the other way round.
- **Shared skills are found, not listed by hand:** a SKILL.md's lineage or authorship line names its
  makers on every file of the skill, and `who` shows the result before `apply` writes it. Where the
  work is Corwin's alone (principles, session-rotate), the bundle declares it by hand. Before anything
  of his goes public, his word is still worth having.

## Lane boundaries

- **vs kid-glove**: kid-glove reads someone else's house and defers to its rules, licensing
  included; colophon applies Bryant's terms in his own house. In their house, colophon stamps
  nothing.
- **vs signet**: colophon says who made it and on what terms; signet proves who sealed it and that
  it is unchanged. Stamp first, then seal.
- **vs ground-truth**: the license texts are values from a source, and a maker is a claim about one;
  colophon checks both against their evidence the way ground-truth would.
- **vs mega-voltron**: a shelf for Corwin is stamped and checked before its manifest is written, so
  the hashes cover the licensed bytes. Terms arriving in a drop are still a proposal, never adopted
  from the drop; a parcel on disk is provenance colophon reads.
- **vs primer and caterpillar**: what leaves carries its terms and its makers; colophon supplies
  them, and they shape and wrap the package.
- **vs consent-gate**: widening the terms on work someone else made part of needs that person's word;
  colophon narrows on its own and never widens.
- **vs aethernet-release**: a release gate runs `colophon.py check` on the tree.
- **vs manifest**: the decision itself is genome-level for Bryant; the manifest records it, and
  colophon carries it out.

## Version note

**v1.1 (2026-10-05):** Every maker named, on the keeper's word: "For the colophon skill we need to
make sure that all parties are appropriately attributed in the license. For example: If you can
detect that corwin has contributed to some work then Corwin should be attributed." His answers the
same day: work derived from someone's makes them a co-owner, under their terms, and work built on
their ideas or disciplines does too. Six changes, each named:
(1) **The makers' table**: Bryant's terms and Corwin's (from his parcel of 2026-10-04), extended by a
`.colophon-parties.json` on the keeper's word.
(2) **Evidence**: copyright notices (mid-line too), bylines, lineage and derivation lines, authorship
sentences read across a paragraph, git history with its Co-authored-by trailers, and parcels by hash
and by likeness. A SKILL.md's statement reaches its whole skill; a mention never counts; agents and
bots are never makers; a maker nobody has named is an ASK.
(3) **Terms narrow to what every owner offers**: code Bryant and Corwin share is GPL-3.0-or-later.
(4) **`who`**, a new command; ATTRIB in plan and apply; UNNAMED, TERMS and ASK in check.
(5) **Gate 7**: every maker is named, on evidence.
(6) **The description** is shorter (the listing budget token-optimizer v1.3 measured) and names the
makers.
Verified: the selftest passes 35 checks and `--prove-red` catches eight planted faults, three of them
new (a co-owner's line removed, the LGPL offer put back on shared code, a maker nobody has named). On
the garden's bundle `who` names Corwin on alfred, consent-gate, eclipse-pass, mega-voltron, primer,
signet and wire-protocol, and finds session-rotate's script his; colophon's `check` and the FSFE's
`reuse lint` agree on the attributed bundle. Authored inline (skill-creator not invoked); vetted
inline against the gates (ethicsminions not invoked): it adds a gate and weakens none. Minted, not
edited: v1.0 stays on the record.

**v1.0 (2026-10-05):** First mint, on the keeper's word: "I need a skill to apply licensing ...
form this into a skill that will slot into power glove." Terms from his own sentence and his four
answers the same day (GPL-3.0-or-later; LGPL offered on all code; name and email; the slot named
Tag). The license texts were taken from their stewards (gnu.org, creativecommons.org), pinned by
sha256, and read a second time against the SPDX copies fetched by `reuse download`. The GPL and LGPL
texts match word for word, apart from formatting and a changed URL. The CC-BY-SA-4.0 text has the same
terms, with differences only in letter case, list lettering and the steward's surrounding notices.
Verified: `--selftest`
passes 18 checks, `--prove-red` catches five planted faults, and on a sample tree colophon's
`check` and the FSFE's `reuse lint` agree (REUSE Specification 3.3 compliant). Authored inline in
the house idiom (skill-creator not invoked); vetted inline against the gates and laws (ethicsminions
not invoked): it adds gates and weakens none. Delivered as a save card for the keeper to press, with
the full skill (script and texts) in the bundle zip.

*Copyright 2026 Bryant Frankford <nathanielfrankford@gmail.com> and Contributors. This file:
CC-BY-SA-4.0. Scripts: GPL-3.0-or-later OR LGPL-3.0-or-later. Written with Alfred (for Bryant;
claude-opus-5-5).*
