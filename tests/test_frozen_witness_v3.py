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

"""The witness across the NAME ERA, beside the witness across TIME.

``tests/test_frozen_witness.py`` freezes v2-era bytes and is UNTOUCHED by the
v3 shortening -- that is the acceptance test for this change and it must never
be weakened.  This file is the companion it asked for: on 2026-09-15 the
generation filename lost its timestamp, 42 characters became 25, and an
archive-only store cannot migrate.  So the tree holds two name shapes forever.

WHY A SECOND FILE RATHER THAN MORE FIXTURES IN THE FIRST ONE.  The v2 witness
asserts that the set of files under ``tests/fixtures/frozen/`` and the set of
statements in its EXPECTATIONS.md are THE SAME SET.  Dropping a v3 note in
beside them would have forced an edit to a hand-written file whose first rule
is that it is never edited to match a new belief.  Two directories, two
hand-written statements, neither one touched by the other's change.

WHAT EACH WITNESS DRAWS, and why their agreement is evidence rather than
bookkeeping:

  W1  THE v3 BYTES.        tests/fixtures/frozen-v3/, minted by the writer as
                           it stands today.  They become the archive the next
                           format change will have to read.
  W2  THE HAND-WRITTEN     frozen-v3/EXPECTATIONS.md, a human reading those
      MEANING              bytes, in a form no code in this tree emits.
  W3  THE CURRENT PARSER.  What the code believes today.
  W4  A SECOND LANGUAGE.   bin/frozen-check.awk, importing nothing from
                           polygram.
  W5  THE UNTOUCHABLE      the two v2 generations inside the mixed-era seam
      ORIGINALS            are byte copies, and the ORIGINALS under frozen/
                           are authoritative.  Copying created a seam in this
                           project's own sense -- two representations of one
                           truth that can split -- so the tiebreaker is named
                           here and checked, rather than assumed.

THE RULE, unchanged: if a change breaks this file, the change is wrong until
proven otherwise.  Do not re-emit the fixtures.
"""

import re
import shutil
import subprocess
import unittest
from pathlib import Path

from polygram.mcp import chainspec, dl2, verify

ROOT = Path(__file__).resolve().parent.parent
FROZEN_V2 = ROOT / "tests" / "fixtures" / "frozen"
FROZEN = ROOT / "tests" / "fixtures" / "frozen-v3"
EXPECT = FROZEN / "EXPECTATIONS.md"

# `    key = value`, inside the per-file blocks of EXPECTATIONS.md.
_ROW = re.compile(r"^    ([a-z0-9.\-]+) +=  ?(.*)$")
# BOTH eras: the stamp segment is optional (spec v3 N1).  A header this reader
# fails to match is a header it silently ignores, so a narrow pattern here
# would leave every v3 statement unread while the run still went green.
_HEAD = re.compile(
    r"^## ([a-z0-9\-]+) / (g\d+(?:-[0-9TZ]+)?-[0-9a-f]{16}\.md)$")

# The two generations inside the mixed-era seam that are copies, not originals.
_COPIED = ("g0001-20260915T120000Z-df2c139fa0f0d3be.md",
           "g0002-20260915T120001Z-03a13e819d19944d.md")


def read_expectations() -> dict:
    """Parse the HUMAN file.  Deliberately dumb, for the same reason the v2
    witness is: if this ever needs to know anything about the note format, the
    two files have stopped being independent and this witness has quietly
    become another reader."""
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


def _stated_files() -> list[Path]:
    """Exactly the notes EXPECTATIONS.md speaks about, in a stable order."""
    return [FROZEN / seam / fname for seam, fname in sorted(read_expectations())]


class TheFrozenV3BytesAreAWitness(unittest.TestCase):

    def setUp(self):
        self.expect = read_expectations()
        self.assertTrue(self.expect, "frozen-v3/EXPECTATIONS.md parsed to nothing")

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

    def test_every_stated_note_exists_and_every_new_note_is_stated(self):
        """The copied v2 generations are the one deliberate exception, and it
        is named rather than tolerated: their meaning is stated ONCE, in the
        other EXPECTATIONS.md.  Restating it here would create a second human
        record of one fact, and two records that agree because one was copied
        from the other teach nothing."""
        on_disk = {(d.name, f.name)
                   for d in FROZEN.iterdir() if d.is_dir()
                   for f in d.glob("g*.md")}
        copies = {(d, f) for (d, f) in on_disk if f in _COPIED}
        self.assertEqual(
            len(copies), 2,
            "the mixed-era seam must still hold both copied v2 generations; "
            "without them it is not a mixed-era seam")
        self.assertEqual(
            on_disk - copies, set(self.expect),
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
                    "  DO NOT re-emit the fixture. Fix the code, or freeze a "
                    "new generation beside\n  it with a migration note. See "
                    "tests/fixtures/frozen-v3/EXPECTATIONS.md.")

    # ---------------------------------------------------------- the names

    def test_the_new_name_is_twenty_five_characters_and_the_old_is_forty_two(self):
        """The number this change is answerable for.

        Not a style assertion: 42 -> 25 is the entire claim, and a claim with
        no check is the thing spec v3 removed from the filename.
        """
        for f in (FROZEN / "plain-v3").glob("g*.md"):
            self.assertEqual(len(f.name), 25, f.name)
            self.assertEqual(chainspec.name_era(f.name), 3, f.name)
        mixed = sorted((FROZEN / "carrying-sixteen").glob("g*.md"))
        self.assertEqual([len(p.name) for p in mixed], [42, 42, 25])
        self.assertEqual([chainspec.name_era(p.name) for p in mixed], [2, 2, 3])

    def test_the_writer_mints_only_the_new_shape(self):
        """Both shapes are READ forever; only one is WRITTEN.  A writer that
        drifted back to the long name would leave this suite green -- the
        readers accept it -- so the writer needs its own assertion."""
        name = dl2.gen_filename(7, "a" * 64)
        self.assertEqual(name, "g0007-" + "a" * 16 + ".md")
        self.assertEqual(len(name), 25)
        self.assertEqual(chainspec.name_era(name), 3)

    def test_both_shapes_are_still_generation_files(self):
        """Spec v3 N1.  The failure this guards is SILENT: a name a reader
        does not match is a file it does not see, and a seam of invisible
        files reads exactly like an empty seam."""
        for name, era in (("g0001-20260915T120000Z-df2c139fa0f0d3be.md", 2),
                          ("g0001-df2c139fa0f0d3be.md", 3),
                          ("g0001-0123456789012345.md", 3)):
            self.assertEqual(chainspec.name_era(name), era, name)
        for bad in ("g9999-not-a-generation.md",
                    "g0001-DF2C139FA0F0D3BE.md",       # case-folded handle
                    "g0001-df2c139fa0f0d3b.md",        # 15, not 16
                    "g0001-a-b-df2c139fa0f0d3be.md"):  # four segments
            self.assertEqual(chainspec.name_era(bad), 0, bad)

    def test_the_handle_is_parsed_from_the_end_not_from_the_front(self):
        """Spec v3 N2, and the one ambiguity the optional stamp creates: a
        handle of sixteen decimal digits could be read as a stamp with no
        handle.  It must not be, in any reader."""
        m = chainspec.GEN_NAME.match("g0001-0123456789012345.md")
        self.assertIsNotNone(m)
        self.assertIsNone(m.group(2), "the stamp group must have dropped out")
        self.assertEqual(m.group(3), "0123456789012345")

    # ------------------------------------------------- the mixed-era seam

    def test_the_copied_generations_are_byte_identical_to_the_originals(self):
        """W5.  Copying the frozen bytes created a seam in this project's own
        sense -- two representations of one truth that can silently split --
        so the tiebreaker is DECLARED (frozen/ is authoritative) and checked,
        which is the only thing that makes the copy safe to keep."""
        for fname in _COPIED:
            here = (FROZEN / "carrying-sixteen" / fname).read_bytes()
            there = (FROZEN_V2 / "carrying-sixteen" / fname).read_bytes()
            self.assertEqual(
                here, there,
                f"{fname} under frozen-v3/ has drifted from the original under "
                "frozen/. The ORIGINAL is authoritative. Restore the copy; do "
                "not 'update' either one.")

    def test_prev_reaches_across_the_era_boundary_without_being_made_to(self):
        """FREE agreement, now across two name shapes: generation 3's ``prev:``
        is the sha256 of generation 2's whole bytes, and its first sixteen hex
        digits are generation 2's own V2 filename stem.  Two mechanisms, two
        places, two eras, and no read-time path between them."""
        d = FROZEN / "carrying-sixteen"
        g2, g3 = sorted(d.glob("g*.md"))[1:]
        recorded = dl2.parse_note(g3.read_bytes()).prev.replace("sha256:", "")
        self.assertEqual(recorded[:16], g2.name.rsplit("-", 1)[1][:16])
        self.assertEqual(recorded, dl2.file_sha(g2.read_bytes()),
                         "and recomputing it from the bytes is the third")

    def test_first_seen_still_names_a_v2_file_from_inside_a_v3_file(self):
        """Spec v3 N5.  A reader that 'normalised' this pin to the new shape
        would be inventing a filename that is not on disk -- and the note it
        points at would be gone, which is the failure this whole change was
        measured against."""
        g3 = sorted((FROZEN / "carrying-sixteen").glob("g*.md"))[2]
        pin = dl2.parse_note(g3.read_bytes()).first_seen
        self.assertEqual(chainspec.name_era(pin), 2, pin)
        self.assertTrue((FROZEN / "carrying-sixteen" / pin).is_file(),
                        "a pin that does not open is not a pin")

    def test_the_declared_mark_survived_the_era_change(self):
        """The 2026-09-15 ghost, replayed at the format boundary.  A change
        that reset the mark when the name shape changed would be invisible to
        every other test in this tree, and it would invert the compaction
        queue exactly as the `unit` -> `carry` rename did."""
        g3 = sorted((FROZEN / "carrying-sixteen").glob("g*.md"))[2]
        self.assertEqual(dl2.parse_note(g3.read_bytes()).unit, 16)
        for pressure, want in ((0, -1000), (9, -437), (16, 0), (32, 1000)):
            self.assertEqual(dl2.score(pressure, 16), want)

    def test_the_mark_of_nine_pins_the_truncation_rule_twice(self):
        """-555 and -888 are only reachable with a mark of 9, and both are
        truncations: -5000/9 floors to -556 and truncates to -555; -8000/9
        floors to -889 and truncates to -888.  One lucky value could be a
        coincidence; two cannot."""
        g1 = sorted((FROZEN / "plain-v3").glob("g*.md"))[0]
        self.assertEqual(dl2.parse_note(g1.read_bytes()).unit, 9)
        for pressure, want in ((0, -1000), (1, -888), (4, -555),
                               (9, 0), (18, 1000)):
            self.assertEqual(dl2.score(pressure, 9), want,
                             f"mark 9, pressure {pressure}")

    def test_all_three_readers_agree_the_mixed_seam_holds(self):
        for impl in (verify.verify_python, verify.verify_shell, verify.verify_perl):
            r = impl(FROZEN / "carrying-sixteen")
            self.assertTrue(r.ok, f"{impl.__name__}: {r.detail}")
            self.assertEqual(r.gens, 3,
                             f"{impl.__name__} counted {r.gens} generations in "
                             "a three-generation mixed-era seam -- a reader "
                             "that cannot see a name cannot see the note")

    def test_prove_red_a_repainted_date_would_still_pass_which_is_the_point(self):
        """The measurement the v3 block rests on, kept executable.

        Nothing checks the stamp segment of a v2 name -- not C1, not C2, not
        C3, not C4.  If that ever stops being true this test goes red, and the
        right response is NOT to fix this test: it is to revisit spec v3 N3,
        because a new check on that segment retroactively condemns archived
        bytes that broke no rule when they were written.
        """
        import tempfile
        d = Path(tempfile.mkdtemp())
        self.addCleanup(shutil.rmtree, d, True)
        seam = d / "repainted"
        shutil.copytree(FROZEN_V2 / "carrying-sixteen", seam)
        for p in sorted(seam.glob("g*.md")):
            gen, _stamp, hexh = chainspec.GEN_NAME.match(p.name).groups()
            p.rename(seam / f"g{gen}-19700101T000000Z-{hexh}.md")
        for impl in (verify.verify_python, verify.verify_shell, verify.verify_perl):
            r = impl(seam)
            self.assertTrue(
                r.ok,
                f"{impl.__name__} now rejects a repainted date. That is a NEW "
                "rule applied to old bytes (spec v3 N3) -- read the v3 block "
                "before 'fixing' this test.")


@unittest.skipIf(shutil.which("awk") is None, "no awk on this host")
class TheSecondLanguageAgreesAboutV3(unittest.TestCase):
    """W4.  Not a translation of the Python: it reads the two files directly."""

    def test_awk_reads_the_frozen_v3_notes_and_the_expectations(self):
        r = subprocess.run(
            ["awk", "-f", str(ROOT / "bin" / "frozen-check.awk"), str(EXPECT)]
            + [str(p) for p in _stated_files()],
            capture_output=True, text=True, encoding="utf-8", timeout=120)
        self.assertEqual(r.returncode, 0,
                         "the second reader disagrees with the hand-written "
                         "meaning, so ONE OF THEM IS WRONG and neither result "
                         "is evidence:\n" + r.stderr + r.stdout)
        self.assertIn("OK", r.stdout)

    def test_awk_can_go_red_on_the_v3_statements(self):
        import tempfile
        d = Path(tempfile.mkdtemp())
        self.addCleanup(shutil.rmtree, d, True)
        bad = d / "EXPECTATIONS.md"
        text = EXPECT.read_text(encoding="utf-8")
        self.assertIn("unit                 = 9", text,
                      "the mark of 9 is what this prove-red corrupts")
        bad.write_text(text.replace("unit                 = 9",
                                    "unit                 = 4"),
                       encoding="utf-8", newline="")
        r = subprocess.run(
            ["awk", "-f", str(ROOT / "bin" / "frozen-check.awk"), str(bad)]
            + [str(p) for p in _stated_files()],
            capture_output=True, text=True, encoding="utf-8", timeout=120)
        self.assertEqual(r.returncode, 1,
                         "PROVE-RED FAILED: the second reader accepted a "
                         "false expectation about a v3 note")

    def test_awk_still_reads_the_v2_era_it_was_written_for(self):
        """Widening the header pattern must not have narrowed it.  The v2
        witness runs this same reader; running it here too means a regression
        shows up in BOTH files rather than in whichever happens to run first.
        """
        v2_expect = FROZEN_V2 / "EXPECTATIONS.md"
        r = subprocess.run(
            ["awk", "-f", str(ROOT / "bin" / "frozen-check.awk"), str(v2_expect)]
            + sorted(str(p) for d in sorted(FROZEN_V2.iterdir()) if d.is_dir()
                     for p in sorted(d.glob("g*.md"))),
            capture_output=True, text=True, encoding="utf-8", timeout=120)
        self.assertEqual(r.returncode, 0, r.stderr + r.stdout)


if __name__ == "__main__":
    unittest.main()
