#!/usr/bin/env python3
"""scan_candidates.py - surface skill-shaped patterns in memory (and an
optional transcript), cross-check them against the skills you already have,
and label each: NEW skill / ENHANCE an existing one / LEAVE as memory.

SkillTank notices; it does not author. The closing hand-off points at
skill-creator to actually build or extend.

  python3 scan_candidates.py --memory DIR [--skills DIR]
                             [--transcript FILE] [--min-cluster N]

stdlib only. Exit 0 always (advisory); prints a ranked report.
"""
import argparse, os, re
from collections import defaultdict, Counter

STOP = set("""a an the and or but of to in on for with at by from as is are was
were be been being this that these those it its they them their there here i you
we he she him her his my our your me us do does did done doing have has had not no
yes so if then than too very can will would should could may might must just about
into over under out up down off only also more most some any each per via etc eg ie
vs use used uses using when what which who whom how why where note notes memory skill
skills thing things make made making one two get got like need needs needed want
wants now next still keep keeps kept built build drafted draft added add half
standalone applied apply yields finding edit edits class same but""".split())

# Generic English function words and common low-signal verbs/connectors, kept
# SEPARATE from the domain-tuned STOP above so that list stays legible. These
# carry no theme signal in any corpus; folding them in cuts tokenizer noise
# (rows like 'own', 'self', 'because', 'while', 'never') without touching
# domain terms (desync, mount, trigger, description, recovery, ...). Tune the
# domain-tuned set above; tune generic noise here.
STOP_EXTRA = set("""own self itself themselves myself ourselves yourself himself
herself whose every either neither none nobody anyone everyone someone anything
everything something nothing because while never ever always often sometimes
usually whether through before after again once above below between both few all
other another such around along across behind beyond within without upon toward
towards against during since until although though unless however therefore thus
hence instead rather already yet even almost nearly quite really simply merely
mainly mostly partly fully wholly part parts way ways lot lots kind kinds sort
sorts bit bits run runs running ran work works working worked load loads loading
loaded go goes going went gone come comes coming came take takes taking took taken
give gives giving gave given see sees seeing saw seen know knows knowing knew known
say says saying said look looks looking looked find finds found show shows showing
showed shown mean means meant let lets letting put puts putting call calls calling
called turn turns turning turned try tries trying tried able don doesn isn
aren wasn weren didn hasn haven hadn wont wouldn couldn shouldn cant cannot
key place live green pre mid home org super words directly stays moves closed
confirm confirmed verified pushed installed passing""".split())
STOP |= STOP_EXTRA

# Words about the working MEDIUM itself. In a memory corpus written by/with an
# AI assistant, these appear everywhere and never name a capability — a theme
# of 'claude' is like a theme of 'typing'. Kept separate because they are only
# noise in THIS kind of corpus; a different deployment might tune differently.
STOP_AMBIENT = set("claude anthropic cowork chatbot llm".split())
STOP |= STOP_AMBIENT

WIKILINK = re.compile(r"\[\[([a-z0-9][a-z0-9-]*)\]\]")
TOKEN = re.compile(r"[a-z][a-z0-9+#.]{2,}")
STEP = re.compile(r"(\(\d+[.)]\s)|(^\s*\d+[.)]\s)|(\bhow to apply\b)|(\bfirst\b[^.\n]*\bthen\b)|(\bstep \d)", re.I | re.M)

def parse_note(text):
    name = desc = ntype = ""; body = text
    m = re.match(r"^---\s*\n(.*?)\n---\s*\n(.*)$", text, re.S)
    if m:
        fm, body = m.group(1), m.group(2)
        for line in fm.splitlines():
            s = line.strip()
            if s.startswith("name:"): name = s.split(":",1)[1].strip()
            elif s.startswith("description:"): desc = s.split(":",1)[1].strip().strip('"')
            elif s.startswith("type:"): ntype = s.split(":",1)[1].strip()
    return name, desc, ntype, body

def tokens(*chunks):
    out = []
    for c in chunks:
        c = re.sub(r"`[^`]*`", " ", c.lower())     # drop inline code
        c = re.sub(r"\[\[[^\]]*\]\]", " ", c)        # drop wikilinks
        c = c.replace("-", " ").replace("_", " ")    # split slugs/compounds
        for t in TOKEN.findall(c):
            t = t.strip(".#+")
            if len(t) >= 3 and t not in STOP: out.append(t)
    return out

def load_notes(d):
    notes = []
    for fn in sorted(os.listdir(d)):
        if not fn.endswith(".md") or fn.upper() == "MEMORY.MD": continue
        text = open(os.path.join(d, fn), encoding="utf-8", errors="replace").read()
        name, desc, ntype, body = parse_note(text)
        links = set(WIKILINK.findall(text))
        text_toks = set(tokens(name, desc, body))
        link_toks = set(tokens(*links))
        notes.append(dict(file=fn, name=name or fn[:-3], type=ntype,
                          links=links, procedural=bool(STEP.search(body)),
                          text_toks=text_toks, toks=text_toks | link_toks))
    return notes

def load_skills(d):
    terms = set(); names = []
    if d and os.path.isdir(d):
        for root, _, files in os.walk(d):
            if "SKILL.md" in files:
                name, desc, _, _ = parse_note(open(os.path.join(root, "SKILL.md"),
                                    encoding="utf-8", errors="replace").read())
                nm = name or os.path.basename(root)
                names.append(nm); terms |= set(tokens(nm, desc))
    return terms, names

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--memory", required=True)
    ap.add_argument("--skills", default="")
    ap.add_argument("--transcript", default="")
    ap.add_argument("--min-cluster", type=int, default=3)
    ap.add_argument("--max-frac", type=float, default=0.7,
                    help="drop themes present in more than this fraction of "
                         "notes — ambient context, not a theme (default 0.7)")
    ap.add_argument("--top", type=int, default=25,
                    help="show at most N candidates (0 = all; default 25)")
    a = ap.parse_args()

    notes = load_notes(a.memory)
    skill_terms, skill_names = load_skills(a.skills)

    df = defaultdict(list)                       # token -> notes containing it
    for n in notes:
        for t in n["toks"]: df[t].append(n)
    # ceiling: a token in (nearly) every note is ambient context — 'the project',
    # 'the repo' — it cannot discriminate a capability. Floor stays min-cluster.
    ceil = max(a.min_cluster, int(a.max_frac * len(notes))) if notes else 0
    ambient = sorted(t for t, ns in df.items()
                     if len(ns) >= a.min_cluster and len(ns) > ceil)
    themes = {t: ns for t, ns in df.items() if a.min_cluster <= len(ns) <= ceil}

    refs = Counter()                             # wikilink centrality
    for n in notes: refs.update(n["links"])

    # group themes that cover the SAME note-set -> one cluster, rest are aliases
    exact = defaultdict(list)
    for t, ns in themes.items():
        exact[frozenset(n["file"] for n in ns)].append(t)

    # then fold NEAR-duplicate note-sets (Jaccard >= 0.8) into the larger one:
    # 'git' over 8 notes and 'mount' over 7 of the same 8 are one conversation,
    # not two candidates. Greedy, largest-first, so the anchor set is stable.
    groups = {}                                  # anchor fileset -> terms
    for fs in sorted(exact, key=lambda s: (-len(s), sorted(s))):
        for anchor in groups:
            j = len(fs & anchor) / len(fs | anchor)
            if j >= 0.8:
                groups[anchor] += exact[fs]; break
        else:
            groups[fs] = list(exact[fs])

    text_df = {t: sum(1 for n in notes if t in n["text_toks"]) for t in themes}
    byfile = {n["file"]: n for n in notes}
    cands = []
    for fileset, terms in groups.items():
        ns = [byfile[f] for f in sorted(fileset)]
        # representative: prefer a term that names an existing skill, else the
        # one with the most real (non-link) textual support, then longest.
        rep = sorted(terms, key=lambda t: (t in skill_terms, text_df[t], len(t)))[-1]
        aliases = sorted([t for t in terms if t != rep],
                         key=lambda t: (-text_df[t], t))[:5]
        proc = sum(1 for n in ns if n["procedural"])
        factual = sum(1 for n in ns if n["type"] in ("user", "reference"))
        hub = max(refs.get(t, 0) for t in terms)
        score = len(ns)*2 + proc*3 + hub
        if rep in skill_terms:
            label, why = "ENHANCE", f"theme maps to a skill you already have"
        elif proc == 0 and factual > len(ns) - factual:
            label, why = "LEAVE-AS-MEMORY", "looks like recurring facts, not a procedure"
        else:
            label, why = "NEW", "recurring procedure no existing skill covers"
        cands.append(dict(rep=rep, aliases=aliases, notes=ns, proc=proc, hub=hub,
                          score=score, label=label, why=why))
    cands.sort(key=lambda c: (-c["score"], c["rep"]))

    out = ["SkillTank — candidate scan", "=" * 60,
           f"memory notes: {len(notes)}   existing skills: "
           f"{', '.join(skill_names) or '(none given)'}",
           f"clustered themes ({a.min_cluster}..{ceil} notes): {len(cands)}", ""]
    if ambient:
        out += [f"ambient (in >{ceil}/{len(notes)} notes, suppressed): "
                f"{', '.join(ambient[:8])}"
                + (f", +{len(ambient)-8} more" if len(ambient) > 8 else ""), ""]
    if not cands:
        out.append("No clustered themes yet — nothing to promote. Keep noting.")
    shown = cands if a.top <= 0 else cands[:a.top]
    for c in shown:
        files = ", ".join(sorted(n["name"] for n in c["notes"]))
        akapart = f"   aka: {', '.join(c['aliases'])}" if c["aliases"] else ""
        out += [f"[{c['label']}] '{c['rep']}'  (score {c['score']}, "
                f"{len(c['notes'])} notes, {c['proc']} procedural, hub {c['hub']}){akapart}",
                f"    why: {c['why']}",
                f"    evidence: {files}", ""]
    if len(cands) > len(shown):
        out.append(f"(…{len(cands) - len(shown)} lower-scoring candidates "
                   f"suppressed — rerun with --top 0 for all)\n")

    if a.transcript and os.path.isfile(a.transcript):
        lines = [l.strip() for l in open(a.transcript, encoding="utf-8",
                 errors="replace") if len(l.strip()) > 12]
        out += ["-" * 60, "Transcript: repeated steps (>=3x) — possible automation:"]
        for line, cnt in Counter(lines).most_common(10):
            if cnt >= 3: out.append(f"    {cnt}x  {line[:70]}")
        out.append("")

    out += ["-" * 60, "Gate before promoting any candidate (skill-vs-memory):",
            "  1. Does it ship what memory can't — a runnable script/resource,",
            "     or a self-triggering description? If only prose, keep it memory.",
            "  2. Is the need RECURRING, or was this a one-off?",
            "  3. One capability — new skill, or ENHANCE/merge an existing one?",
            "     Reference when only sometimes shared.", "",
            "Need time to READ a candidate before deciding? Park it at HOLD —",
            "that is what HOLD is for. Never REJECT to buy reading time:",
            "REJECT is durable in the advice ledger; diligence is not a defect.", "",
            "To build a NEW skill or ENHANCE one, hand off to: skill-creator."]
    print("\n".join(out))

if __name__ == "__main__":
    main()
