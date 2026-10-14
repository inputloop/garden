# Survey method (shared by every survey agent tonight)

You are surveying folders on Corwin's computer through the device shell
(`mcp__remote-devices__device_bash`; load it with ToolSearch "select:mcp__remote-devices__device_bash").
Each call is a fresh shell and must finish in under 170 seconds; split long work. In that shell the
folders are under `$HOME/mnt/` (names given in your task). Write paths in your report the way Corwin
types them (given in your task), never as `/sessions/...`.

## Goal
Corwin: "we are not quite seeing all of the work yet ... it is spread out and it is buried ... check
widely ... we must also check deeply." Find every **worked thing** at any depth, including
sub-products hidden inside other projects (he knows of one inside card-game). A worked thing is
anything with at least one of: tests or a check script, a README/DESIGN/MODEL/RECIPE, a build or
Makefile, generated outputs, a signed release, a prototype that runs.

For each worked thing record:
- path; one line on what it is; maturity (idea, design, prototype, tested, shipped); newest file date;
- which of tonight's threads it bears on, by tag:
  - T1 USB-distributable GNU/Linux: recipes, kiosk or first-run shell, Guix/Arch/Debian, Emacs or
    HTML as an app shell ("simplified Electron");
  - T2 Steven Brust's ("Dad", SKZB) work: the Project of Doom stick, books, the convention;
  - T3 orgvm, the mood-rich app, egad, ghostwheel hosts;
  - T4 a FOSS-involvement index, an "ideas marketplace", collaborative governance;
  - T5 presentations, talks, papers;
  - T6 routines: journaling, reformat-prompt, session-rotate, static models;
  - T7 C4 as CI/CD, releases, ELPA, signing;
- whether it is reachable from where the shop would look (a README or model links to it) or buried.

Also record **old instructions** you meet (prompts, CLAUDE.md files, RUNCARDs, "next-session"
prompts): quote the instruction (Corwin's words, at most 25 words) and judge it: *good and lost*,
*good and in use*, *stale*, or *troublesome* (one line of why).

## How
- Measure before reading: `find DIR -maxdepth N`, counts, sizes, dates. Then read READMEs, models,
  designs, headers, test names. Do not read large files whole; `head`, `grep -n` and `sed -n` are
  enough. Prefer breadth first, then go deep where the work is.
- Read-only. Write nothing on Corwin's computer.

## Never
- Never open a file whose name looks like a secret or key: `*.secret`, `*SECRET*`, `id_*`, `*.key`,
  `*.pem`, `.env`, anything named token or password, `.keys/`. List such paths at most.
- Never read chat logs: any `chatlog` folder, `DiscordChatExporter`, IRC logs.
- Leave out anyone's health, home or family details unless they are the work itself (Dad's books
  and convention are work).
- Quote no one but Corwin, and him for at most 25 words at a time.
- No web.

## Output
Write your inventory to the file your task names (under 1,800 words; tables welcome). Then reply
with a summary under 300 words: the five most important finds, anything buried that should not be,
and the old instructions that most deserve attention.
