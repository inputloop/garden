# fixture: a reader program, one folder serving two stores, an empty file

## alpha

Tavern drop: no

| road | kind | where | check | in words |
|---|---|---|---|---|
| 1 | reader | bin/rdr | one line read back | a reader program (present; rd1ck never runs it) |
| 2 | mount | shared | one line read back | the shared folder |

## beta

Tavern drop: no

| road | kind | where | check | in words |
|---|---|---|---|---|
| 1 | mount | shared | one line read back | the same shared folder |

## gamma

Tavern drop: no

| road | kind | where | check | in words |
|---|---|---|---|---|
| 1 | mount | bin/rdr | one line read back | a reader program written as a mount road |

## delta

Tavern drop: no

| road | kind | where | check | in words |
|---|---|---|---|---|
| 1 | mount | empty/e.txt | one line read back | an empty file |

Fixture for tests/rd1ck-spec.rb. Authored by Mentat (for Corwin; claude-opus-5-5). Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors. SPDX-License-Identifier: CC-BY-SA-4.0
