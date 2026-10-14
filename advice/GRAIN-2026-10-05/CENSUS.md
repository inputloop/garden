# The census: the users gate over the public forge, 2026-10-05

*For Corwin. All five weaves asked for this independently, and it informs S08. The commits read are
the public copies: what the forge serves to anyone, anonymously, over HTTPS.*

## The answer

**108 public commits in 11 public repositories.** The census found:
- 38 vendor session trailers, in 9 of the repositories;
- card-games' two stray files;
- one credit link in field-comic's template (`template/COMIC-2026-08-18-lab-edition.html`), which
  credits Claude (Anthropic) with a link to the vendor's site. That is a judgment for you (S39),
  not a false positive.

Nothing else: no secret, no local path, no other misnamed or instrument file.

Stopping privacy and provenance findings at every non-local level (S08) would have stopped those
pushes and almost nothing else. With the app setting off (S01), it would rarely fire again.

## By repository

| repository | public | commits | findings |
|---|---|---|---|
| card-game.el | yes | 54 | 1 LINK, 1 AIMED, 1 MISNAMED |
| drift | yes | 8 | 8 LINK |
| egad | yes | 7 | 6 LINK |
| field-comic | yes | 6 | 7 LINK (6 trailers, 1 credit) |
| for-bryant | yes | 2 | 2 LINK |
| kid-glove | yes | 6 | 6 LINK |
| mini-c4-game | yes | 7 | 7 LINK |
| persona-engine | yes | 1 | 1 LINK |
| persona-shelf | yes | 1 | 1 LINK |
| vibrobeast | yes | 3 | none |
| c4fn | yes | 13 | none |
| as4ce (the garden), org-c4, ghostwheel-nodes, gw-survey, pmo.sh | no (an anonymous fetch is refused) | | not read here |

**for-bryant is public.** I read its public copy for secrets, local paths and personal contacts and
found none. The parcels in `out/` are ignored by git, so they never went up.

## How

- Every check was run at the `users` level, so that every finding prints as a flag.
- The registry was a temporary one matching everything. Nothing was installed and nothing was
  pushed.
- Over the mount, the private trees were too slow to finish within the shell's time limit. They
  carry the same trailer, which matters less there.

---
*Version 1.0.0: first edition on 2026-10-05; spine: 2026-10-05.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4:
https://creativecommons.org/licenses/by-sa/4.0/; Mentat (for Corwin; claude-opus-5-5)
