# Project linkage — polygram (AS4CE0001)

This Cowork project is governed by Corwin's in-house **PMO** supervisor.

| | |
|---|---|
| PMO key | `polygram` |
| PMO ledger | `F:\claude\projects\pmo` (`projects.tsv`, `todos.tsv`) (keeper-only) |
| Publish target | `ssh://forgejo@code.bru.st/corwin/as4ce` (git remote `upstream`) (keeper-only) |
| Public source | https://code.bru.st/corwin/vibrobeast (anyone) |

## How status is tracked

Project status and TODOs live in the PMO ledger, **not** in this repo. Drive
them through the `pmo` skill (or `pmo-list` / `pmo-add` / `pmo-done` /
`pmo-prio` + `pmo-report` in `F:\claude\projects\pmo\bin`) (keeper-only). Never hand-edit
PMO's generated `README.md` / `index.html`.

To see this project's open items: `pmo-list polygram` (keeper-only).

## Commit / publish

**Commits: Claude, from the linked computer's shell** (since 2026-10-04, his "take command of the git
repository"). Each commit is one coherent change, authored `Corwin Brust <corwin@bru.st>` with the
Co-Authored-By line the keeper asked for, and written into ChangeLog first. No link to a vendor's
session pages goes into a commit or any work product unless he asks (his rule of 2026-10-05;
`SOFT-SKILLS/public-stage` dropped the session trailer the same day, ChangeLog 2026-10-05). Git reads carry
`--no-optional-locks`; git writes need the session's delete permission on this folder, asked once.
The old note here ("running git against the Windows mount desyncs writes") described a 2026-06-27
sandbox and no longer holds (model.md v19, Constraints).

**Pushes.** Since 2026-10-04 the linked computer's shell carries a dedicated key Corwin set up for
code.bru.st, and Claude may push with it; his words of 2026-10-05 allow pushes to private projects (on
2026-10-08 the build loop pushed to private inputloop repositories). Making something public, and
`sh bin/release VERSION --push` (a signed tag, a release page), stay his. (Corrected 2026-10-10: this
section said the session had no key; study S2 of the extension spell, B4, found it stale.)

## Note on the publish URL

The git remote is `…/corwin/as4ce`; PMO's `projects.tsv` publish column has been
reconciled to match (it previously read `…/corwin/polygram`, an assumed URL).
