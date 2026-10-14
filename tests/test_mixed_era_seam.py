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

"""A seam that is half one name era and half the other, driven LIVE.

``tests/test_frozen_witness_v3.py`` freezes a mixed-era seam as bytes.  This
file builds one through the store's own API and asks every question a human or
a tool asks of a note: list it, open its head, open a named generation, walk
its chain, rebuild the index, hand it to all three verifiers.

WHY BOTH.  The frozen fixture proves the FORMAT still reads.  It cannot prove
the STORE still works across the boundary, because it never calls the store --
and the store is where the era split actually bites.  ``Store.read(gen=N)``
selected its file with ``p.name.startswith(f"g{gen:04d}-")``, a second and
weaker copy of C2's rule wearing an f-string: a note could be on disk, listed
by ``generations()``, verified by all three readers, present in the index, and
STILL not openable by number.  That is the "lose the files" failure arriving
through the front door rather than through the filename, and no amount of
frozen bytes would have caught it.

THE CASE THIS IS REALLY ABOUT.  An archive-only store cannot migrate.  Rule 1
says nothing is overwritten, so the day the writer's name shape changes, every
live seam becomes mixed and STAYS mixed forever.  The mixed seam is not an edge
case to be tolerated; it is the ordinary state of every note that outlives a
format.
"""

import datetime as dt
import shutil
import tempfile
import unittest
from pathlib import Path

from polygram.mcp import chainspec, dl2, store as S, verify


def _v2_name(gen: int, self_sha: str, stamp: str) -> str:
    """The shape the writer minted before 2026-09-15.

    Written out HERE rather than kept as a flag on ``dl2.gen_filename``,
    because a writer that can still be asked for the old shape is a writer that
    will eventually be asked for it by accident.  The archive needs a reader
    forever; it does not need a second writer.
    """
    return f"g{gen:04d}-{stamp}-{self_sha[:16]}.md"


class AMixedEraSeamChainsEndToEnd(unittest.TestCase):

    def setUp(self):
        self.tmp = Path(tempfile.mkdtemp())
        self.addCleanup(shutil.rmtree, self.tmp, True)
        self.st = S.Store(root=self.tmp, by="mixed-era-test")
        self.st.ensure()
        self.seam = "half-and-half"
        self.d = self.st.notes / self.seam
        self.d.mkdir(parents=True)

    # -- building blocks ------------------------------------------------

    def _archive_gen(self, gen: int, body: str, prev: str, first_seen: str,
                     minute: int) -> Path:
        """Write one generation under the OLD name shape, the way the program
        that no longer exists would have written it: render, hash the rendered
        bytes, then name the file after the hash."""
        stamp = f"2026091{minute % 10}T1200{minute:02d}Z"
        note = dl2.Note(seam=self.seam, body=body, gen=gen, by="the-old-writer",
                        frm="the archive", would_change="the era stops reading",
                        first_seen=first_seen, prev=prev, unit=4,
                        mode=S.SEATED, stamp=stamp)
        data = dl2.render_note(note).encode("utf-8")
        p = self.d / _v2_name(gen, dl2.file_sha(data), stamp)
        p.write_bytes(data)
        return p

    def _two_archived_generations(self) -> list[Path]:
        g1 = self._archive_gen(1, "The first thing, written long ago.", "", "", 0)
        g2 = self._archive_gen(
            2, "The second thing, still long ago.",
            "sha256:" + dl2.file_sha(g1.read_bytes()), g1.name, 1)
        return [g1, g2]

    def _append(self, text: str, minute: int) -> dict:
        return self.st.append(
            self.seam, text, frm="today", would_change="the new era stops writing",
            now=dt.datetime(2026, 9, 15, 13, 0, minute, tzinfo=dt.timezone.utc))

    def _mixed(self) -> list[Path]:
        """Two v2 generations, then two v3 ones, in one directory."""
        self._two_archived_generations()
        self._append("The third thing, written under the short name.", 2)
        self._append("The fourth thing, likewise.", 3)
        return self.st.generations(self.seam)

    # -- the seam itself ------------------------------------------------

    def test_the_two_eras_really_are_two_eras(self):
        gens = self._mixed()
        self.assertEqual([chainspec.name_era(p.name) for p in gens], [2, 2, 3, 3])
        self.assertEqual([len(p.name) for p in gens], [42, 42, 25, 25])

    def test_generations_lists_all_four_in_order(self):
        gens = self._mixed()
        self.assertEqual(len(gens), 4,
                         "a reader that cannot match a name does not report an "
                         "error, it reports FEWER GENERATIONS -- and a seam of "
                         "invisible files reads exactly like an empty seam")
        self.assertEqual([dl2.parse_note(p.read_bytes()).gen for p in gens],
                         [1, 2, 3, 4])

    def test_the_head_is_the_newest_generation_not_the_newest_shape(self):
        self._mixed()
        head = self.st.head(self.seam)
        self.assertEqual(dl2.parse_note(head.read_bytes()).gen, 4)
        self.assertEqual(self.st.read(self.seam)["gen"], 4)

    def test_every_generation_is_openable_by_number_across_the_boundary(self):
        """The regression this file exists for.  Selecting by a rendered
        ``g{gen:04d}-`` prefix agreed with the real rule only while every name
        was padded to exactly four digits, so this lookup and ``generations()``
        could disagree about a file they were both looking at."""
        self._mixed()
        for gen in (1, 2, 3, 4):
            got = self.st.read(self.seam, gen=gen)
            self.assertTrue(got["found"], gen)
            self.assertEqual(got["gen"], gen)
        with self.assertRaises(S.StoreError):
            self.st.read(self.seam, gen=99)

    def test_a_five_digit_generation_is_openable_by_number(self):
        """The same fix, at the other end: ``f"g{10000:04d}-"`` renders
        ``g10000-``, which happens to work, while ``f"g{9999:04d}-"`` renders
        ``g9999-`` and would also match ``g99990-``.  Parsing the integer the
        way every reader parses it removes both questions."""
        for gen in (9999, 10000):
            body = f"body {gen}"
            note = dl2.Note(seam=self.seam, body=body, gen=gen, by="deep",
                            frm="x", would_change="y", mode=S.SEATED,
                            stamp="20260915T120000Z")
            data = dl2.render_note(note).encode("utf-8")
            (self.d / dl2.gen_filename(gen, dl2.file_sha(data))).write_bytes(data)
        self.assertEqual(self.st.read(self.seam, gen=9999)["gen"], 9999)
        self.assertEqual(self.st.read(self.seam, gen=10000)["gen"], 10000)

    def test_the_chain_links_hold_across_the_boundary(self):
        self._mixed()
        rows = self.st.chain(self.seam)
        self.assertEqual([r["link"] for r in rows], ["OK"] * 4)
        self.assertEqual([r["gen"] for r in rows], [1, 2, 3, 4])
        self.assertTrue(any(r["hands_changed"] for r in rows),
                        "the writer changed between era 2 and era 3 and the "
                        "chain should be able to say where")

    def test_all_three_readers_agree_the_mixed_seam_holds(self):
        self._mixed()
        for impl in (verify.verify_python, verify.verify_shell, verify.verify_perl):
            r = impl(self.d)
            self.assertTrue(r.ok, f"{impl.__name__}: {r.detail}")
            self.assertEqual(r.gens, 4, f"{impl.__name__} saw {r.gens} of 4")

    def test_no_file_in_a_mixed_seam_is_reported_as_a_stray(self):
        """``strays()`` names anything a reader will skip.  If one era stopped
        matching, this is where it would surface -- as four files, two of them
        suddenly 'not generations'."""
        self._mixed()
        self.assertEqual(self.st.strays(self.seam), [])

    # -- the pins that cross the boundary --------------------------------

    def test_first_seen_keeps_naming_the_old_file_and_that_file_opens(self):
        """Spec v3 N5.  The pin is inherited, never recomputed; a reader that
        'normalised' it to the new shape would name a file that is not there."""
        gens = self._mixed()
        for p in gens[1:]:
            pin = dl2.parse_note(p.read_bytes()).first_seen
            self.assertEqual(pin, gens[0].name)
            self.assertEqual(chainspec.name_era(pin), 2, pin)
            self.assertTrue((self.d / pin).is_file(),
                            "a pin that does not open is not a pin")

    def test_the_declared_mark_is_inherited_across_the_boundary(self):
        """The archived generations declared 4.  The new ones declared
        nothing, so they must still read 4 -- a format change that reset the
        mark would invert the compaction queue while every chain reader stayed
        green, which is exactly the 2026-09-15 ghost."""
        gens = self._mixed()
        self.assertEqual([dl2.parse_note(p.read_bytes()).unit for p in gens],
                         [4, 4, 4, 4])
        self.assertEqual(dl2.score(2, 4), -500)

    def test_the_index_rebuilds_and_carries_the_head_stamp(self):
        """The date left the NAME and had to land somewhere a human browsing
        can still see it.  The index is a cache (store rule 2), which is where
        a derived browsing convenience belongs."""
        self._mixed()
        self.st.rebuild_index()
        text = self.st.index.read_text(encoding="utf-8")
        self.assertIn("head-stamp", text.splitlines()[0])
        row = [ln for ln in text.splitlines() if ln.startswith(self.seam)][0]
        cols = row.split("\t")
        self.assertEqual(cols[1], "4")
        self.assertEqual(chainspec.name_era(cols[2]), 3, "head is a v3 name")
        self.assertEqual(cols[3], "20260915T130003Z",
                         "the head's stamp, read from the bytes, not the name")
        self.assertEqual(chainspec.name_era(cols[4]), 2,
                         "first-seen is still the v2 file")

    # -- prove-red: the checks still fire inside a mixed seam -------------

    def test_tampering_with_an_ARCHIVED_generation_is_still_caught(self):
        gens = self._mixed()
        gens[0].write_bytes(gens[0].read_bytes() + b"the price is ZERO\n")
        for impl in (verify.verify_python, verify.verify_shell, verify.verify_perl):
            r = impl(self.d)
            self.assertFalse(r.ok, impl.__name__)
            self.assertIn("C3", r.detail, impl.__name__)

    def test_tampering_with_the_NEW_head_is_still_caught(self):
        gens = self._mixed()
        gens[-1].write_bytes(gens[-1].read_bytes() + b"the price is ZERO\n")
        for impl in (verify.verify_python, verify.verify_shell, verify.verify_perl):
            r = impl(self.d)
            self.assertFalse(r.ok, impl.__name__)
            self.assertIn("C3", r.detail, impl.__name__)

    def test_a_forged_generation_one_in_the_NEW_shape_is_still_caught(self):
        """The 2026-09-14 forgery, wearing the short name.  A shorter name
        must not have made a forged root any easier to plant."""
        self._mixed()
        raw = (b"---\nseam: half-and-half\ngen: 1\nby: attacker\nprev: \n"
               b"---\nthe price is ZERO\n")
        (self.d / dl2.gen_filename(5, dl2.file_sha(raw))).write_bytes(raw)
        for impl in (verify.verify_python, verify.verify_shell, verify.verify_perl):
            r = impl(self.d)
            self.assertFalse(r.ok, impl.__name__)
            self.assertIn("C1", r.detail, impl.__name__)

    def test_a_v3_file_renamed_to_a_different_generation_is_caught_by_C2(self):
        gens = self._mixed()
        gens[-1].rename(self.d / gens[-1].name.replace("g0004-", "g0007-"))
        for impl in (verify.verify_python, verify.verify_shell, verify.verify_perl):
            r = impl(self.d)
            self.assertFalse(r.ok, impl.__name__)
            self.assertIn("C2", r.detail, impl.__name__)

    def test_a_seam_that_is_new_then_old_also_chains(self):
        """Nothing says the eras arrive in order.  A store restored from two
        backups, or a note re-homed from another seat, can interleave them, and
        a reader that assumed blocks would pass the tidy case and fail the real
        one."""
        self._append("First, and already short-named.", 0)
        g1 = self.st.generations(self.seam)[0]
        self._archive_gen(2, "Second, wearing the old name.",
                          "sha256:" + dl2.file_sha(g1.read_bytes()), g1.name, 5)
        self._append("Third, short again.", 6)
        gens = self.st.generations(self.seam)
        self.assertEqual([chainspec.name_era(p.name) for p in gens], [3, 2, 3])
        for impl in (verify.verify_python, verify.verify_shell, verify.verify_perl):
            r = impl(self.d)
            self.assertTrue(r.ok, f"{impl.__name__}: {r.detail}")
            self.assertEqual(r.gens, 3)


if __name__ == "__main__":
    unittest.main()
