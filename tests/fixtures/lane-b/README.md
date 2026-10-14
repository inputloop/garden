# tests/fixtures/lane-b

Fixtures for lane B of the extension edition (2026-10-10).

- `tavern/config.json` -- a made-up Tavern settings file for `tests/tavernface-tests.sh` rows F5 and
  F6. Every value is invented: the join code, ids and address are not any real Tavern's. It plants
  an agent `aaa` under a second owner (bryant), sorted first, which must never be picked, and an
  agent `wayne` of the same owner whose model is not claude.
- The persona-ledger fixtures are built by `tests/persona-ledger-tests.sh` in a scratch folder at
  run time (see `tests/persona-ledger-SPEC.txt`), so no sheet-shaped file sits here to be served.

Authored by Mentat (for Corwin; claude-opus-5-5).
Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
SPDX-License-Identifier: CC-BY-SA-4.0
