produced-by: claudewin sub-agent B (LENS run, stage 2 contrast) · B reads A · 2026-10-08
licence: CC-BY-SA-4.0 · inputs: A-topoforge-narrative.md, B-garden-pony-registry.md (both read in full).
Bryant's files untouched. Section numbers like "A 4.3" / "B G1" point into those two notes.

# C — the registry designer reads TopoForge

## 1. SHARED SPINE

S1  Never let a reader claim what the source did not say.
    A: sentences only from facts; GAPS listed by fixed rules; banned judgement words (A 4.2-4.3).
    B: a "Tools:" line only from the node's run log; agent-written receipt lines removed (B G1, L5).
    One mechanism? NO. One spec? YES, partly. A's facts are a pure function of a file: anyone can
    rebuild them. B's receipts record an event that only one machine saw: no peer can rebuild them.
    What both can share is the LINE GRAMMAR (A 6: `KIND key=value ...`) and the rule "a claim line is
    written by the instrument and never by the reader". The checks differ: A rebuilds the facts and
    diffs them. B can only look the receipt up in the log of the machine that ran it.
S2  Stable identity riding in a field old readers already carry.
    A: `data.tf_ref` survives draw.io/Visio because `data` does (A O1, 4.1).
    B: a shared tool is a drop tagged #tool. Its identity is the drop's sha256 (B G3, G4).
    One mechanism? NO: see SEAM T-1 below. A shared written rule can cover both: "new meaning goes
    into a field that the oldest reader already keeps and passes along unchanged; prove it with a round
    trip through the oldest reader". The two round trips are Visio 2010 (A) and a stock 2.3.1 node
    ingesting the events (B K4).
S3  Test kits that rebuild facts in a second language, with prove-red.
    A: jq + sh diff of facts against the export's own fenced block. B: sh + curl + awk against a live
    scratch node. One kit? NO: A is offline, B needs a running node. They can share one output
    contract: case lines "Kn PASS|FAIL words", "AGREE n facts" / "DISAGREE", and "KIT BROKEN" when
    prove-red stays green. That is a 10-line spec both runners can follow.
S4  Values that look like the user's but are not.
    A: MAYBE_DEFAULT (auto labels, auto VLAN 10). B: the tags on a tool card are the author's claims,
    and "assumed" tags are guesses (B L2). They are the same kind of problem, and in both the document
    must say so in words. The labels differ (GAP kind vs tag column), so they share the idea and not
    the code.

## 2. TRANSFERS B -> A

T1  Strip forged claim lines at the source. In B, receipt-shaped lines an agent writes are removed at
    the node (B G1). In A, the user's own words go into the same Markdown as the facts: notes,
    `data` values and labels. A multi-line `notes` value holding a fenced block tagged ```facts, or a
    line "### Gaps", would forge structure. The AI reader would take it as TopoForge's, and A's
    `sed -n '/^```facts$/,/^```$/p'` takes the first match. Concrete fix: (a) in the facts block and
    sentences, escape newlines in user values (`\n`) as well as quotes. (b) The export writes one
    random fence word per export (```facts-k3qa) and check.sh reads only that word, which it takes
    from the document's header line. (c) Add a fixture `forge.json` whose notes hold a fake facts
    block.
    Falsifier: feed forge.json through A's current spec. If check.sh still says AGREE on the right
    facts and the sentences show the notes as one quoted line, T1 is not needed.
T2  Bind the story to its source by hash, as B binds approval to bytes (B G4). The Markdown header
    carries the sha256 of the exported JSON and of the facts block. An AI reader given story.md plus
    a PNG from a later edit can then be told "these may not match". Today nothing ties story.md to
    the picture.
    Falsifier: if the export always writes story.md, JSON and PNG together in one action and the
    user can never pair them otherwise, the hash adds only noise. Check this by asking Bryant how
    people actually send drawings.

## 3. TRANSFERS A -> B

T3  Give each tool card a FACT/GAPS narrative, so no one invents what a tool can do. Built by fixed
    rule from the card and registry only:
    FACTS: argv, sha12, input mode (stdin|none), timeout, scratch cwd, "runs as <OS user> on
    <host>", and which agents may run it here, in which scope.
    GAPS: "what the program reads, writes or reaches on the network: not known to Tavern". Also
    "tags are the author's claims" and "changed since approved", where true.
    Banned words on the card and in the resident's tool list: safe, sandboxed, read-only, harmless,
    secure. These are judgements the registry cannot observe (A 4.2's list, extended). The same
    block goes on the registry page (B L6), into the resident's system prompt (B L7) and into
    tavern_tools for MCP agents.
    Falsifier: give one Ollama resident a tool whose GAP says network reach is unknown, and ask it
    4 times (4 is invented) "can t1 reach the internet?". If it answers yes or no instead of
    "unknown", the wording fails and needs a stronger form.
T4  Write receipts in A's fact grammar. The visible line stays in plain words, followed by a fact
    line: `RUN tool=t1 sha=abcdef123456 run=r-4a1c agent=alpha exit=0 out=<sha12>`. B's kit can then
    work like A's: awk pulls every RUN line from /api/export, `tavern.py`'s tool_log export gives the
    reference set, and the kit diffs them. AGREE means every receipt has a log entry. Extra RUN lines
    are forgeries.
    Falsifier: if Tavern's text rendering or the 16,000-char cap (T:189) ever cuts or rewrites a RUN
    line, the diff gives false DISAGREEs. Fixture: a reply right at the cap.
T5  A's change list (A 5) goes on the registry page as "what changed since you approved it". Diff
    the card's fact lines old vs new, e.g. "argv changed" vs "program bytes changed". Today B only
    says "changed".
    Falsifier: if program-byte changes are almost all of the changes in practice, the diff is a
    one-line "program changed" every time and adds nothing over B as written.

## 4. TENSIONS (named, not resolved)

T-1 SEAM "identity". In A, tf_ref is a NAME that must survive edits: rename a shape and it keeps
    its ref. In B, the sha256 is CONTENT: change one byte and it is a new tool by design. The same
    word, "stable identity", means opposite things. A shared glossary must keep both senses.
T-2 SEAM "fact". A's facts can be rebuilt from the file anywhere. B's receipts are witnessed once,
    by one machine, and are trusted only as far as its signature. Calling both "facts" would let a
    reader think a peer can re-check a tool run. It cannot.
T-3 SEAM "gap" vs "not carried out". A's GAP means "unknown, ask". B's "Not carried out" means
    "refused". A reader seeing both in one room may take either for the other.
T-4 Consent. A writes tf_ref into the user's model by itself (one unasked undo step, A 5, its own
    [MINE] note). B's spine is "nothing changes without the owner's approval". Both are Corwin's
    tools, so the house rule for a tool editing a user's data needs one answer, and this note does
    not give it.
T-5 Editability of the carrier. A's `data` field can be edited by the user, who can break or forge
    a ref. B's drop note is signed and fixed once sent. Same pattern, different strength. A's kit
    should test a hand-edited duplicate tf_ref.
T-6 Judgement words. A bans them. B's MATCH tags are judgements by design: "seen doing well",
    "avoid". If T3 lands, the tool card holds both: banned words in FACT/GAPS, judgement tags in
    the ranking section, and the page must keep them visibly apart.

## 5. LENS (B's side)

a (mine): the two streams are one idea, "the instrument writes the claims and the reader only
  quotes", applied to a file in A and to an event in B. Invented.
b (ascribed to Corwin, no quoted words, invented): he will want the shared part as one small spec
  both kits obey, and the difference (rebuildable vs witnessed) said in plain words.
c (his pull on mine): A's GAP list made me see that B's registry page shows what a tool IS but
  never what Tavern does NOT know about it. That is the T3 hole. Invented.
d (my pull on his): forged structure in user text (T1) is the same attack as a resident writing
  "Searched:". A should test for it. Invented.
persona/inverse: a network designer wants the story to say "protected"; a resident wants its tool
  list to say "safe". The strict auditor, who wants only what was observed, is the reader both
  designs serve. Invented.
principles reframe: claims a person can trace to a line, and gaps said out loud, keep the freedom
  to study real. A reader cannot study what an instrument smoothed over. Invented.
