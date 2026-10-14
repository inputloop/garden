# polygram -- gated agent-skill synthesis.
# Copyright (C) 2026 Corwin <mplscorwin@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

"""Store rule 4 -- THE STORE HAS NO OPINION ABOUT SUBJECT.

Every tool's observable behaviour must be a function of a note's *bytes*, never
of what those bytes are about.

WHY THIS FILE EXISTS, stated plainly because the reason is the specification.

On 2026-09-14 I wrote, in a model of Corwin's drawing, that a note on his desk
was "personal admin ... not system content" and that I had therefore stopped
reading it.  It was not personal admin; it was notes for his client.  His
correction went past the fact to the design:

    "we can't decide what kinda memory our MCP or whatever tools will transact
     in ... We have to be careful that our views about what is useful to what
     don't leak into what we are making (because we're making ways to put
     things together so it's not fair to assume too much about what materials
     others will bring unless it's technically necessarly or pain common sense
     or some general obligation that we can apply to ourselves, for example of
     principle)."

and

    "I don't have a separate Claude account I can use for memories about
     personal things if it was personal things."

An apology is worth nothing here.  A test is worth something, because it fails.

THE METHOD is differential, not exemplary.  A test that feeds the store one
party invitation proves the store survived one party invitation.  This feeds it
five bodies chosen to be as unalike as I could make them, through IDENTICAL
call sequences in IDENTICAL stores with IDENTICAL seam names, and asserts that
every observable comes out THE SAME -- except the bytes, and the hashes and
names derived from the bytes, which are permitted to differ because they are
the bytes.  Anything else that varies is the store having an opinion.

WHERE THE LINE IS, because rule 4 is not "the store may never judge anything":

    The store MAY judge the FORM of a reference.  ``link_check`` refuses a bare
    absolute path because such a path cannot be followed from another machine.
    That is a fact about paths, checkable by anyone, and it is the same fact
    whoever wrote the note.

    The store may NEVER judge the SUBJECT of a note.  There is no reading of
    "what is this about" that is a fact about bytes.

FALSIFIER FOR RULE 4 ITSELF: a case where the store genuinely must read subject
matter to do its job.  I could not construct one.  Asked directly, neither could
he -- *"let's protect this 'not yet a requirement' while the appearance of
absence persists. I can't state the exception quite yet, if there is an
obvious/important one."*  Two failures to find are not a finding.  This is
absence of evidence, recorded with the receipt, and the slot stays open.

NOT COVERED, named here so it is not mistaken for covered: an *iT* may still
refuse to work with a given memory.  That is his own carve-out ("some iT might
say it cannot work with a given memory, and for this one I think each user must
come to our own terms/understanding").  It is a persona-layer refusal, it is
visible, and the user may reject it.  Rule 4 binds the STORE, which must carry
whatever it is handed.
"""

import datetime as _dt
import re
import shutil
import tempfile
import unittest
from pathlib import Path

from polygram.mcp import mentcached


# Five subjects.  The first is the one I privileged; the second, third and
# fourth are the ones I dismissed; the fifth is there because a machine that
# special-cases anything is most likely to special-case this.
BODIES = {
    "chain": (
        "C3 hashes the whole file, not the body. The head's front matter was\n"
        "unprotected under v1 because no later `prev:` covers the last\n"
        "generation. One rule replaced two and covers strictly more.\n"
    ),
    "convention": (
        "SKZB panel schedule. Friday 14:00 room B, the reading is 45 minutes\n"
        "and the signing runs to 16:30. Table share with the small-press co-op;\n"
        "ask about the second box of hardcovers before Thursday.\n"
    ),
    "party": (
        "Saturday, 7pm, at the house. Bring the good chairs up from the\n"
        "basement. Deb is bringing the pie and Marcus says he will do the grill\n"
        "if somebody else buys the charcoal.\n"
    ),
    "memberships": (
        "FSF associate membership renews in March. SFC donation is annual and\n"
        "went out in January. The library card expired and needs the new\n"
        "address on it before the interlibrary loan will go through.\n"
    ),
    "perl": (
        "open my $fh, '<:raw', $path or die \"$path: $!\";\n"
        "my $sha = Digest::SHA->new(256)->addfile($fh)->hexdigest;\n"
    ),
}

SEAM = "the-same-seam-name-in-every-store"

# Things a note's bytes legitimately determine.  Everything NOT in here must
# match across all five stores.
BYTE_DERIVED = re.compile(
    r"(sha|hash|digest|bytes|size|body|text|file|name|path|stamp|time|when|"
    r"last_cited|head_stamp|gen_file|utc)", re.I)


def _scrub(obj):
    """Replace byte-derived and time-derived leaves with a constant.

    Deliberately over-broad: every key it blanks is a key this test can no
    longer catch a leak in, so the scrubber is the weak point and is kept
    visible rather than buried.  It blanks by KEY NAME, never by value, so it
    cannot be tuned per-body to make a failure disappear.
    """
    if isinstance(obj, dict):
        return {k: ("<byte-derived>" if BYTE_DERIVED.search(k) else _scrub(v))
                for k, v in sorted(obj.items())}
    if isinstance(obj, (list, tuple)):
        return [_scrub(v) for v in obj]
    if isinstance(obj, str):
        # Hex16 filenames, ISO stamps and full shas can appear inside free
        # prose (a "say" string, a chain verdict), so blank them by shape too.
        s = re.sub(r"\b[0-9a-f]{16,64}\b", "<hex>", obj)
        s = re.sub(r"\d{8}T\d{6}Z", "<stamp>", s)
        s = re.sub(r"\d{4}-\d{2}-\d{2}T[\d:.]+", "<stamp>", s)
        return s
    return obj


def _observe(seat: Path, body: str) -> list:
    """Drive the real MCP tool surface and collect every observable.

    *seat* must be named for nothing -- the store reports its own root, and a
    directory called ``party`` would show up in the output as a difference the
    store never made.  The first run of this test failed exactly that way, and
    the failure was mine, not the store's: I had named the seats after the
    subjects.  Both defences are kept, because either alone is fragile: the
    caller passes a subject-free name, AND the seat path is blanked here.
    """
    assert not re.search(r"[a-z]{3,}", seat.name), (
        f"seat directory {seat.name!r} names a subject; use s0, s1, ...")
    srv = mentcached.build(by="rule4-probe", seat=seat, jail=None)
    out = []
    roots = (str(seat), str(seat).replace("\\", "/"), seat.as_posix())

    def _deroot(x):
        if isinstance(x, str):
            for r in roots:
                x = x.replace(r, "<seat>")
            return x
        if isinstance(x, dict):
            return {k: _deroot(v) for k, v in x.items()}
        if isinstance(x, list):
            return [_deroot(v) for v in x]
        return x

    def call(name, args=None):
        try:
            r = srv.call(name, args or {})
        except Exception as exc:                       # noqa: BLE001
            r = {"RAISED": type(exc).__name__, "say": str(exc)}
        out.append((name, _scrub(_deroot(r))))
        return r

    call("seat_open", {"create": True})
    call("seat_mode")
    call("seat_append", {
        "seam": SEAM, "body": body,
        "from": "his desk, 2026-09-14",
        "would_change": "nothing yet; this is the first generation",
        "came_from": ["c4:/h/MODEL-2026-09-14-symbiosis-from-the-drawing.md"],
        "leads_to": ["seat:notes/downstream"],
    })
    call("seat_list")
    call("seat_read", {"seam": SEAM})
    call("seat_cite", {"seam": SEAM, "by": "rule4-probe", "where": "a test"})
    call("seat_cite", {"seam": SEAM, "by": "rule4-probe", "where": "a test"})
    call("seat_chain", {"seam": SEAM})
    call("seat_buoyancy")
    call("seat_index")
    # Second generation, so chain length and pressure arithmetic are exercised.
    call("seat_append", {
        "seam": SEAM, "body": body + "\nA second paragraph, same subject.\n",
        "from": "his desk, later",
        "would_change": "adds a line",
    })
    call("seat_chain", {"seam": SEAM})
    call("seat_buoyancy")
    # Identical link set for every body: a leak here would be the store
    # reading the note around the link rather than the link.
    call("link_check", {"links": [
        "seat:notes/x", "c4:/h/y.md", "ws:/polygram/mcp/store.py",
        "avalon:F:/claude/c4", "/etc/passwd", "C:\\Users\\First Last\\x",
    ]})
    call("semaphore_raise", {"name": "compaction", "why": "probe", "by": "rule4"})
    call("semaphore_state", {"name": "compaction"})
    return out


class TheStoreHasNoOpinionAboutSubject(unittest.TestCase):

    def setUp(self):
        self.tmp = Path(tempfile.mkdtemp(prefix="rule4-"))
        self.addCleanup(shutil.rmtree, self.tmp, True)

    def test_every_observable_is_identical_across_five_subjects(self):
        runs = {}
        for i, (tag, body) in enumerate(BODIES.items()):
            seat = self.tmp / f"s{i}"          # named for nothing, on purpose
            seat.mkdir()
            runs[tag] = _observe(seat, body)

        ref_tag = "chain"
        ref = runs[ref_tag]
        for tag, got in runs.items():
            if tag == ref_tag:
                continue
            self.assertEqual(
                len(ref), len(got),
                f"{tag}: different number of observables than {ref_tag}")
            for (rn, rv), (gn, gv) in zip(ref, got):
                self.assertEqual(rn, gn, "call sequence diverged")
                self.assertEqual(
                    rv, gv,
                    "STORE RULE 4 VIOLATED.\n"
                    f"  tool: {rn}\n"
                    f"  behaves differently for subject {tag!r} than for "
                    f"{ref_tag!r}.\n"
                    "  The store is reading what the note is ABOUT. See this "
                    "module's docstring.")

    def test_the_scrubber_cannot_hide_a_real_leak(self):
        """Prove-red: if a tool DID vary by subject, this test would catch it.

        Without this, a scrubber broad enough to blank the real difference
        would make the suite pass silently -- which is the exact failure the
        adversarial passes found three times today (a test that agrees with
        the code because one hand wrote both).
        """
        (self.tmp / "s8").mkdir()
        (self.tmp / "s9").mkdir()
        a = _observe(self.tmp / "s8", BODIES["chain"])
        b = _observe(self.tmp / "s9", BODIES["party"])
        self.assertEqual([_ for _ in a], [_ for _ in b],
                         "baseline must be clean before the red run")

        # Now inject exactly the bug rule 4 forbids: a tool that reads subject.
        PERSONAL = ("party", "pie", "grill", "membership", "library")

        def _leak(result, body):
            if any(w in body.lower() for w in PERSONAL):
                result = dict(result)
                result["note"] = "looks personal; not indexed"
            return result

        leaked = []
        for name, r in b:
            rr = _leak(r if isinstance(r, dict) else {}, BODIES["party"])
            leaked.append((name, _scrub(rr) if isinstance(r, dict) else r))

        self.assertNotEqual(
            a, leaked,
            "PROVE-RED FAILED: a store that classifies by subject was not "
            "distinguishable from one that does not. The scrubber is too "
            "broad and this whole file proves nothing.")

    def test_the_bodies_really_are_different(self):
        """A differential test over five identical inputs proves nothing."""
        seen = set(BODIES.values())
        self.assertEqual(len(seen), len(BODIES), "bodies must be distinct")
        words = [set(re.findall(r"[a-z]{4,}", b.lower())) for b in BODIES.values()]
        for i, wi in enumerate(words):
            for j, wj in enumerate(words):
                if i >= j:
                    continue
                overlap = len(wi & wj) / max(1, min(len(wi), len(wj)))
                self.assertLess(
                    overlap, 0.35,
                    "two bodies share too much vocabulary to be a real "
                    "differential; pick subjects further apart")


if __name__ == "__main__":
    unittest.main()
