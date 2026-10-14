# polygram -- gated agent-skill synthesis.
# Copyright (C) 2026 Corwin Brust <corwin@bru.st>
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

"""The witness across TIME, and the first one in this tree that is not a reader.

Corwin, 2026-09-15:

    "It isn't enough to have a second reader: we have to draw/consider
     different data from within the same set and reach the mutually supporting
     conclusion that information begins to show a signal strength."

That sharpens something this project had wrong.  Its three chain verifiers --
Python, POSIX sh, Perl -- read the SAME bytes and compute the SAME function.
They are a real instrument and they catch real faults, but they are
*implementation corroboration*: one reading, executed three ways.  They cannot
corroborate an INFERENCE, because they never make one.

WHAT THAT COST, measured on 2026-09-15.  Renaming the front-matter key `unit`
-> `carry`, applied correctly to all three sites in dl2.py, moved a stored seam
from

    unit=16  pressure=9  score_milli=-437   act=False
to
    unit=1   pressure=9  score_milli=+8000  act=True

inverting the compaction queue for every note whose author had declared a mark.
**All 207 tests passed.**  The three readers stayed green and were telling the
truth the whole time: C1-C4 check position, name, self-hash and link, and none
of them can see meaning.

The round-trip test that ought to have caught it is blind by construction:
`test_render_parse_round_trips_to_identity` asserts model->doc->model->doc is
identity, which is invariant under a consistent rename of the key on BOTH
sides.  It round-trips the pair through itself -- claim C9 ("agreement between
two things one hand made is not evidence") arriving one level down, and claim
C19 ("one platform is one reader") applied to time instead of platform.

THE WITNESSES HERE, and why they are witnesses rather than readers:

  W1  THE FROZEN BYTES.  Notes under tests/fixtures/frozen/, written by a
      version of this program that no longer exists.  They cannot be argued
      with and they cannot be updated to match a new belief.
  W2  THE HAND-WRITTEN EXPECTATIONS.  EXPECTATIONS.md, written by a human
      reading those bytes, in a form no code in this tree emits.  It states
      MEANING, which is the thing the chain readers structurally cannot.
  W3  THE CURRENT PARSER.  What the code believes today.
  W4  A SECOND LANGUAGE.  bin/frozen-check.awk reads the same two files
      without importing anything from polygram.

Each draws a DIFFERENT fact from the same set.  W1 has bytes, W2 has meaning,
W3 has an interpretation, W4 has an independent parse.  Their agreement is not
forced by any of them, and that is what makes it evidence.

FREE AGREEMENT vs FORCED AGREEMENT is the distinction the whole file turns on.
`prev:` in generation 2 records the sha256 of generation 1's whole bytes; the
first sixteen hex digits of that are, separately, generation 1's own filename
stem.  Two mechanisms, two places, no code path that makes one from the other
at read time.  When they agree, something has been learned.  Two values copied
from one source agreeing teaches nothing, however many languages do the
copying.

THE RULE: if a change breaks this file, the change is wrong until proven
otherwise.  Do not re-emit the fixtures.  Either fix the code, or freeze a NEW
generation beside the old one and write a migration note.  The old bytes stay.
A fixture you regenerate agrees with whatever you just did.
"""

import re
import shutil
import subprocess
import unittest
from pathlib import Path

from polygram.mcp import dl2

ROOT = Path(__file__).resolve().parent.parent
FROZEN = ROOT / "tests" / "fixtures" / "frozen"
EXPECT = FROZEN / "EXPECTATIONS.md"

# `    key = value`, inside the per-file blocks of EXPECTATIONS.md.
_ROW = re.compile(r"^    ([a-z0-9.\-]+) +=  ?(.*)$")
_HEAD = re.compile(r"^## ([a-z0-9\-]+) / (g\d+-[0-9TZ]+-[0-9a-f]{16}\.md)$")


def read_expectations() -> dict:
    """Parse the HUMAN file.  Deliberately dumb: if this ever needs to know
    anything about the note format, the two files have stopped being
    independent and this witness has quietly become another reader."""
    out, cur = {}, None
    for line in EXPECT.read_text(encoding="utf-8").splitlines():
        h = _HEAD.match(line)
        if h:
            cur = (h.group(1), h.group(2))
            out[cur] = {}
            continue
        m = _ROW.match(line)
        if m and cur:
            v = m.group(2).strip()
            out[cur][m.group(1)] = "" if v == "(empty)" else v
    return out


class TheFrozenBytesAreAWitness(unittest.TestCase):

    def setUp(self):
        self.expect = read_expectations()
        self.assertTrue(self.expect, "EXPECTATIONS.md parsed to nothing")

    def _facts(self, seam, fname):
        """W3: what the CURRENT parser makes of the frozen bytes."""
        p = FROZEN / seam / fname
        n = dl2.parse_note(p.read_bytes())
        return {
            "seam": n.seam, "gen": str(n.gen), "by": n.by, "from": n.frm,
            "triggers.count": str(len(n.triggers)),
            "triggers.first": n.triggers[0] if n.triggers else "",
            "first-seen": n.first_seen,
            "prev": n.prev,
            "prev.hex16": n.prev.replace("sha256:", "")[:16] if n.prev else "",
            "cited-at-write": str(n.cited_at_write),
            "unit": str(n.unit),
            "mode": n.mode,
            "body.first-word": n.body.split()[0] if n.body.split() else "",
            "filename.hex16": fname.rsplit("-", 1)[1][:16],
        }

    def test_every_frozen_file_has_expectations(self):
        on_disk = {(d.name, f.name)
                   for d in FROZEN.iterdir() if d.is_dir()
                   for f in d.glob("g*.md")}
        self.assertEqual(
            on_disk, set(self.expect),
            "a frozen file with no hand-written expectations is a file nobody "
            "is reading; a stated expectation with no file is a claim about "
            "nothing")

    def test_the_parser_agrees_with_the_hand_written_meaning(self):
        for (seam, fname), want in sorted(self.expect.items()):
            got = self._facts(seam, fname)
            for key, expected in sorted(want.items()):
                self.assertIn(key, got,
                              f"EXPECTATIONS.md states {key!r} for {fname} and "
                              "nothing checks it -- a silent hole")
                self.assertEqual(
                    got[key], expected,
                    f"\n{seam}/{fname}\n  {key}\n"
                    f"    the frozen bytes + a human reading them say: {expected!r}\n"
                    f"    the current parser says:                     {got[key]!r}\n"
                    "  These bytes were written by a version of this program "
                    "that no longer exists.\n"
                    "  DO NOT re-emit the fixture. Fix the code, or freeze a "
                    "new generation beside\n  it with a migration note. See "
                    "tests/fixtures/frozen/EXPECTATIONS.md.")

    def test_the_declared_mark_still_drives_the_arithmetic(self):
        """A mark that survives the parse but no longer reaches `score` has
        survived in name only."""
        table = [
            ("carrying-sixteen", 16, [(0, -1000), (9, -437), (16, 0), (32, 1000)]),
            ("plain-atom", 1, [(0, -1000), (1, 0), (2, 1000)]),
        ]
        for seam, unit, rows in table:
            fname = sorted(f.name for f in (FROZEN / seam).glob("g*.md"))[0]
            self.assertEqual(int(self._facts(seam, fname)["unit"]), unit)
            for pressure, want in rows:
                self.assertEqual(
                    dl2.score(pressure, unit), want,
                    f"{seam}: mark {unit}, pressure {pressure} must score "
                    f"{want}. -437 in particular witnesses the mark, the "
                    "arithmetic and the truncation rule in one number.")

    def test_prev_and_the_filename_agree_without_being_made_to(self):
        """FREE agreement: two mechanisms, two places, no read-time path
        between them. This is the shape that counts as evidence."""
        d = FROZEN / "carrying-sixteen"
        g1, g2 = sorted(d.glob("g*.md"))
        recorded = dl2.parse_note(g2.read_bytes()).prev.replace("sha256:", "")
        self.assertEqual(recorded[:16], g1.name.rsplit("-", 1)[1][:16],
                         "gen 2's prev: and gen 1's filename are two "
                         "independent records of one fact")
        self.assertEqual(recorded, dl2.file_sha(g1.read_bytes()),
                         "and recomputing it from the bytes is the third")

    def test_prove_red_the_ghost_would_be_caught_now(self):
        """The exact 2026-09-15 change, replayed against this witness.

        Without this, the file above proves only that today's parser agrees
        with today's fixture -- which is the failure it exists to prevent.
        """
        frozen = (FROZEN / "carrying-sixteen" /
                  sorted(f.name for f in (FROZEN / "carrying-sixteen").glob("g*.md"))[0])
        raw = frozen.read_bytes()
        self.assertIn(b"\nunit: 16\n", raw, "fixture no longer states the mark")

        # A parser that has been renamed out from under these bytes: the key it
        # now looks for is absent, so the forward-compat default takes over and
        # the mark reads 1. Simulated by renaming the key in a COPY of the
        # bytes -- equivalent, and it touches no shipped code.
        renamed = raw.replace(b"\nunit: 16\n", b"\ncarry: 16\n")
        n = dl2.parse_note(renamed)
        self.assertEqual(
            n.unit, 1,
            "the forward-compat default is what makes the ghost silent")
        self.assertNotEqual(
            dl2.score(9, n.unit), -437,
            "PROVE-RED FAILED: the renamed key still produced the frozen "
            "arithmetic, so this suite cannot see the fault it was written "
            "for and proves nothing")
        self.assertEqual(dl2.score(9, n.unit), 8000,
                         "and the wrong reading is not subtle -- it is the "
                         "compaction queue inverted")


@unittest.skipIf(shutil.which("awk") is None, "no awk on this host")
class TheSecondLanguageAgrees(unittest.TestCase):
    """W4. Not a translation of the Python: it reads the two files directly."""

    def test_awk_reads_the_frozen_notes_and_the_expectations(self):
        r = subprocess.run(
            ["awk", "-f", str(ROOT / "bin" / "frozen-check.awk"),
             str(EXPECT)] + sorted(str(p) for d in sorted(FROZEN.iterdir())
                                   if d.is_dir() for p in sorted(d.glob("g*.md"))),
            capture_output=True, text=True, encoding="utf-8", timeout=120)
        self.assertEqual(r.returncode, 0,
                         "the second reader disagrees with the hand-written "
                         "meaning, so ONE OF THEM IS WRONG and neither result "
                         "is evidence:\n" + r.stderr + r.stdout)
        self.assertIn("OK", r.stdout)

    def test_awk_can_go_red(self):
        import tempfile
        d = Path(tempfile.mkdtemp())
        self.addCleanup(shutil.rmtree, d, True)
        bad = d / "EXPECTATIONS.md"
        bad.write_text(EXPECT.read_text(encoding="utf-8")
                       .replace("unit                 = 16",
                                "unit                 = 4"),
                       encoding="utf-8", newline="")
        r = subprocess.run(
            ["awk", "-f", str(ROOT / "bin" / "frozen-check.awk"), str(bad)]
            + sorted(str(p) for dd in sorted(FROZEN.iterdir()) if dd.is_dir()
                     for p in sorted(dd.glob("g*.md"))),
            capture_output=True, text=True, encoding="utf-8", timeout=120)
        self.assertEqual(r.returncode, 1,
                         "PROVE-RED FAILED: the second reader accepted a "
                         "false expectation")


if __name__ == "__main__":
    unittest.main()
