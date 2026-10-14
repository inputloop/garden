# Project linkage — polygram (AS4CE0001)

This Cowork project is governed by Corwin's in-house **PMO** supervisor.

| | |
|---|---|
| PMO key | `polygram` |
| PMO ledger | `F:\claude\projects\pmo` (`projects.tsv`, `todos.tsv`) |
| Publish target | `ssh://forgejo@code.bru.st/corwin/as4ce` (git remote `upstream`) |

## How status is tracked

Project status and TODOs live in the PMO ledger, **not** in this repo. Drive
them through the `pmo` skill (or `pmo-list` / `pmo-add` / `pmo-done` /
`pmo-prio` + `pmo-report` in `F:\claude\projects\pmo\bin`). Never hand-edit
PMO's generated `README.md` / `index.html`.

To see this project's open items: `pmo-list polygram`.

## Commit / publish

Commits and pushes are done **by Corwin in his own shell** — the Cowork sandbox
can read the repo but cannot push to code.bru.st (SSH host-key verification
fails), and running git against the Windows mount desyncs writes. Claude
provides ready-to-paste commit commands at each commit point and waits for
confirmation; it does not push.

## Note on the publish URL

The git remote is `…/corwin/as4ce`; PMO's `projects.tsv` publish column has been
reconciled to match (it previously read `…/corwin/polygram`, an assumed URL).
