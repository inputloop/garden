# peers/: what our peers need, rendered beside what we use

*Corwin's direction, 2026-10-05: keeping the garden shared means rendering what he needs, so he
can use it, and what our peers need, so they can see the improvements we make in their own context
and so we can prove we did not drop or change what they rely on. This shelf is the second half.*

- `peers/<peer>/<skill>/` holds a skill as we hand it back to that peer: their work, with our
  changes, under both names, with their own tests still passing on it. It is a skill folder in the
  usual shape (`SKILL.md`, `scripts/`, `references/`, `FROM`, `tests.sh`).
- Nothing here is in the vibrobeast plugin: `make dist` mints `skills/` and `SOFT-SKILLS/` only.
  A peer skill that we also want to wear graduates into `skills/` under its own name, by hand.
- Each folder's `FROM` says what it started from (with the hash of their bytes), and its
  `references/` keep their original text and the diff, so they can merge back what they want.

| peer | skill | what it is |
|---|---|---|
| bryant | colophon | his colophon 1.1 with the attribution ladder (c4 `man/attribution-ladder.md`) and no one's terms in its code; his selftest passes on it (36 checks), and `tests.sh` checks the changes (14, with 7 planted faults after a green control) |

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4:
https://creativecommons.org/licenses/by-sa/4.0/; Mentat (for Corwin; claude-opus-5-5)
