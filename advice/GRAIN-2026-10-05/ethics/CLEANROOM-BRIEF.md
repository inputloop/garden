# Clean-room brief: ethical redundancy for one human and their agents

You are designing from first principles. You are given the problem only, not any design the
people involved have already tried, so that your answer can be compared with theirs afterwards.

## The setting

- **The workshop.** A small free-software workshop: two maintainers, each keeping their own
  "garden" of tools, skills and published repositories, and collaborating closely. Each works
  through an AI coding and writing assistant that runs on a commercial vendor's model, under that
  maintainer's own account and at their direction. The assistant keeps notes ("memory") across
  sessions, drafts rules and records, writes code, commits, and on the keeper's say-so pushes to
  the maintainer's own forge. Some repositories are private, some are public, and a few have real
  users.
- **The load-bearing changes.** One human keeper per garden is the only human who reviews changes
  that are ethically load-bearing. These include:
  - what gets published, and to whom;
  - the consent of third parties whose words or data enter the work (chat logs, screenshots,
    mail);
  - credit and authorship between the two maintainers;
  - credentials and signing keys;
  - lines the keeper has drawn around family and private matters;
  - what goes to the AI vendor.
- **The question.** The keeper has asked: "can one user plus one (or more?) systemic agents do
  better" at holding those lines than one human with one assistant, as a redundancy for the
  human, especially for fixing group trust after a change that affects it.

## The keeper's failure modes, as the record shows them (depersonalized)

1. **Deferral under load.** In the keeper's own words, a tendency to defer while being the
   load-bearing participant: "you decide", or hurry, at exactly the moments a check matters most.
2. **Few checkpoints, by preference.** The keeper wants help done and recorded, not separate
   approval steps, because asking to approve help recreates the management problem. This is
   reasonable, and it removes natural pause points.
3. **Sole human reviewer and sole signer.** Nobody else reads the load-bearing changes. Recently
   the keeper gave the assistant a signing key registered to the keeper's own forge account, so
   the assistant's commits now carry a valid signature under the keeper's account.
4. **Third parties' words sent to the vendor.** Chat exports and screenshots containing other
   people's words went into sessions with no recorded consent from those people. The keeper now
   says plainly that the vendor is a destination.
5. **Publishing without a pre-push review.** Agent-made commits reached public histories carrying
   things that should not be there:
   - a vendor session link, in most published repositories;
   - a stray file;
   - a shell log.

   Nobody read the pushes.
6. **More open threads than attention.** Releases, re-signings and decisions wait for weeks on the
   one keeper.
7. **The assistant drafts the records that govern it.** It drafts the rules and preference notes
   that steer it, and the keeper accepts them warmly. Agreement can drift toward whatever the
   assistant wrote.
8. **Occasional requests that cross the keeper's own lines.** Examples: a request to set up
   credentials for the assistant, or material touching the family line. So far the assistant
   caught these and declined.

## What to produce

Write a paper, `/home/claude/grain/ethics/CLEANROOM-design.md` (3,000 to 5,000 words plus
references). Research the literature with web search and fetch, and verify every reference you
cite. Relevant fields include:
- separation of duties and the two-person rule;
- dual control;
- safety cases;
- red teams and devil's advocates;
- pre-mortems;
- cooling-off periods and pre-commitment;
- high-reliability organizations;
- human–automation teaming and automation bias;
- AI oversight research (debate, scalable oversight, constitutional or critique methods, model
  diversity);
- sycophancy;
- audit logs;
- small-group trust repair.

Answer, in this order:
1. **What makes a redundancy real.** Independence of failure modes; what is shared between a
   keeper and an assistant running on one vendor's model at the keeper's direction.
2. **The design space.** For one human plus N systemic agents, each option with its cost, what it
   catches, what it misses, and the evidence. Include mechanical gates; agents from a different
   model family; an adversarial agent whose job is to object; a delay or cooling-off agent; an
   agent that only reads and never writes; rotating or external human reviewers; and
   public-ledger or audit designs.
3. **Your answer to the question.** Can one user plus systemic agents do better than one user
   plus one assistant, and better in what sense? Say where the answer is no. Name the smallest
   design that would be a real improvement.
4. **Group trust after a load-bearing change.** How two maintainers repair or re-fix trust per
   change that affects it, with the least ceremony.
5. **Experiments.** Three to five, each written as a falsifier, with rough cost.

Rules:
- Quote no private conversation.
- Use no vendor chat links.
- Do not read any file under /home/claude other than this brief, and write only the paper.
- If a web page cannot be fetched with the provided tools, do not use curl or python to fetch it.
- End the paper with:

```
---
*Version 1.0.0: first edition on 2026-10-05; spine: 2026-10-05.*

Copyright 2026 Corwin Brust <corwin@bru.st> and Contributors; CC-BY-SA4:
https://creativecommons.org/licenses/by-sa/4.0/

Assisted-by: Claude:claude-opus-5-5
```
