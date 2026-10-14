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

"""Rule 5 (BLESS) and the SHIPBOARD DATE.  Both are Corwin's, 2026-09-15.

BLESS.  His instruction was three words -- *"The new rule: bless"* -- and the
word was already his: his own register page carries *"Keeper's pen to bless;
letters marked ? still need confirming."*  A bless is the moment a proposal
stops being a proposal, and the thing that makes it worth anything is that the
blesser is a SECOND party.  So rule 5 is the two-witness doctrine turned from
a habit into an access rule, and the refusal is the feature.

SHIPBOARD DATE.  *"When we put a date into a file (or filename) it should come
from a file ... having a running conception of shipboard date is potentially
quite helpful, and I also find it helpful to think about that date as I do the
high-water mark VERSION that a project -- or some other context! -- could
have."*

The host clock is a fact about the machine that happened to run the write, and
about nothing else.  This store already had a name for that distinction:
chainspec U1, the mark is DECLARED, NEVER INFERRED.  A date read off a clock
is inferred; a date read from a file is declared.  The clock keeps exactly one
job -- populating the file the first time -- and that leaves a receipt.
"""

import shutil
import tempfile
import unittest
from pathlib import Path

from polygram.mcp import mentcached, shipdate
from polygram.mcp import store as _store
from polygram.mcp.rpc import ToolError


class _Seat(unittest.TestCase):
    def seat(self):
        d = Path(tempfile.mkdtemp(prefix="bless-"))
        self.addCleanup(shutil.rmtree, d, True)
        return d / "seat"

    def store(self, by):
        return _store.Store(root=self._root, by=by,
                            jail_root=None).ensure(create=True)

    def setUp(self):
        self._root = self.seat()


class RuleFive(_Seat):

    def test_an_author_cannot_bless_their_own_work(self):
        """The refusal IS the rule. One witness signing twice is the exact
        failure the whole discipline exists to catch."""
        a = self.store("ada")
        a.append("s", "x", frm="me", would_change="y")
        with self.assertRaises(_store.StoreError) as cm:
            a.bless("s", "ada", "I read it carefully and it is fine")
        msg = str(cm.exception)
        self.assertIn("cannot bless", msg)
        self.assertIn("SECOND party", msg)
        self.assertEqual(a.blessings("s"), [], "nothing was written")

    def test_a_second_party_can(self):
        a = self.store("ada")
        a.append("s", "x", frm="me", would_change="y")
        b = self.store("bram")
        r = b.bless("s", "bram", "checked the sha against the chain by hand")
        self.assertEqual(r["author"], "ada")
        self.assertEqual(r["by"], "bram")
        rows = b.blessings("s")
        self.assertEqual(len(rows), 1)
        self.assertEqual(rows[0]["state"], "OK")

    def test_a_bless_must_say_what_was_checked(self):
        a = self.store("ada")
        a.append("s", "x", frm="me", would_change="y")
        b = self.store("bram")
        for empty in ("", "   ", "\t"):
            with self.assertRaises(_store.StoreError) as cm:
                b.bless("s", "bram", empty)
            self.assertIn("WHAT YOU CHECKED", str(cm.exception))

    def test_blessing_does_not_inherit_forward(self):
        """The whole point is that somebody looked at THESE bytes."""
        a = self.store("ada")
        a.append("s", "one", frm="me", would_change="y")
        b = self.store("bram")
        b.bless("s", "bram", "read generation 1 line by line")
        a.append("s", "two -- a revision nobody has read", frm="me",
                 would_change="y")
        rows = b.blessings("s")
        self.assertEqual([r["gen"] for r in rows], [1])
        head = a.generations("s")[-1]
        from polygram.mcp import dl2
        self.assertNotIn(dl2.file_sha(head.read_bytes()),
                         [r["sha"] for r in rows],
                         "the new head must NOT be blessed by inheritance")

    def test_a_blessing_of_bytes_that_are_gone_reads_STALE(self):
        """Not dropped. Somebody having blessed bytes that have since gone is
        worth more than a tidy list."""
        a = self.store("ada")
        a.append("s", "x", frm="me", would_change="y")
        b = self.store("bram")
        b.bless("s", "bram", "checked it")
        g = a.generations("s")[0]
        g.write_bytes(g.read_bytes() + b"tampered\n")
        rows = b.blessings("s")
        self.assertEqual(rows[0]["state"], "STALE")

    def test_blessing_mints_no_generation(self):
        """Endorsing a thing must not change the thing endorsed."""
        a = self.store("ada")
        a.append("s", "x", frm="me", would_change="y")
        before = [p.name for p in a.generations("s")]
        self.store("bram").bless("s", "bram", "checked it")
        self.assertEqual([p.name for p in a.generations("s")], before)

    def test_the_tool_refuses_the_author_too(self):
        seat = self._root
        ada = mentcached.build(by="ada", seat=seat, jail=None)
        ada.call("seat_open", {"create": True})
        ada.call("seat_append", {"seam": "s", "text": "x", "source": "me",
                                 "would_change": "y"})
        with self.assertRaises(ToolError):
            ada.call("seat_bless", {"seam": "s", "checked": "looks right"})
        bram = mentcached.build(by="bram", seat=seat, jail=None)
        r = bram.call("seat_bless", {"seam": "s", "checked": "re-ran the chain"})
        self.assertEqual(r["by"], "bram")

    def test_unblessed_is_reported_as_a_state_not_a_fault(self):
        seat = self._root
        s = mentcached.build(by="ada", seat=seat, jail=None)
        s.call("seat_open", {"create": True})
        s.call("seat_append", {"seam": "s", "text": "x", "source": "me",
                               "would_change": "y"})
        r = s.call("seat_blessings", {"seam": "s"})
        self.assertEqual(r["count"], 0)
        self.assertIn("not suspect", r["say"])


class TheShipboardDate(_Seat):

    def test_a_write_takes_its_date_from_the_file(self):
        st = self.store("ada")
        shipdate.advance(st.active, "20261101T000000Z", by="corwin",
                         why="the voyage begins")
        st.append("s", "x", frm="me", would_change="y")
        raw = st.generations("s")[0].read_text(encoding="utf-8")
        self.assertIn("stamp: 20261101T000000Z@", raw,
                      "the note's date must be the CONTEXT's date, not the "
                      "host clock's")

    def test_it_never_moves_backward(self):
        st = self.store("ada")
        shipdate.advance(st.active, "20261101T000000Z", by="c")
        with self.assertRaises(shipdate.ShipdateError) as cm:
            shipdate.advance(st.active, "20260101T000000Z", by="c")
        self.assertIn("high-water mark", str(cm.exception))
        self.assertEqual(shipdate.split_host(shipdate.read(st.active)[0])[0],
                         "20261101T000000Z")

    def test_reading_never_moves_it(self):
        st = self.store("ada")
        shipdate.advance(st.active, "20261101T000000Z", by="c")
        before = shipdate.path_for(st.active).read_bytes()
        for _ in range(5):
            shipdate.read(st.active)
            st.stamp()
        self.assertEqual(shipdate.path_for(st.active).read_bytes(), before,
                         "a thousand readers must get one answer")

    def test_the_clock_populates_once_and_leaves_a_receipt(self):
        st = self.store("ada")
        self.assertEqual(shipdate.read(st.active)[1], "UNSET")
        st.append("s", "x", frm="me", would_change="y")
        self.assertEqual(shipdate.read(st.active)[1], "file")
        logs = list(st.receipts.glob("*.log"))
        self.assertTrue(logs)
        self.assertIn("SHIPDATE", "".join(
            p.read_text(encoding="utf-8") for p in logs),
            "the clock's one legitimate use must be recorded, or it is not "
            "distinguishable from the clock being trusted")

    def test_two_writers_on_one_context_share_a_date(self):
        """The reason this exists. Two machines with skewed clocks used to
        produce different bytes for the same context."""
        seat = self._root
        a = _store.Store(root=seat, by="ada", jail_root=None).ensure(create=True)
        shipdate.advance(a.active, "20261225T000000Z", by="c")
        b = _store.Store(root=seat, by="bram", jail_root=None).ensure()
        self.assertEqual(a.stamp(), b.stamp())
        a.append("s1", "x", frm="m", would_change="y")
        b.append("s2", "x", frm="m", would_change="y")
        for s in ("s1", "s2"):
            self.assertIn("stamp: 20261225T000000Z@",
                          a.generations(s)[0].read_text(encoding="utf-8"))

    def test_a_malformed_date_file_does_not_deny_the_store(self):
        """Same lesson as the poisoned note: one bad file must not cost
        somebody everything else they have."""
        st = self.store("ada")
        shipdate.path_for(st.active).write_bytes(b"tuesday-ish\n")
        r = st.append("s", "x", frm="me", would_change="y")
        self.assertEqual(r["gen"], 1)
        self.assertIn("SHIPDATE", "".join(
            p.read_text(encoding="utf-8") for p in st.receipts.glob("*.log")))

    def test_only_ascii_digits(self):
        st = self.store("ada")
        for bad in ("2026１１０１T000000Z", "20261101T00000Z",
                    "20261101000000Z", "20261101T000000"):
            with self.assertRaises(shipdate.ShipdateError):
                shipdate.advance(st.active, bad, by="c")

    def test_the_tool_reads_and_advances(self):
        seat = self._root
        s = mentcached.build(by="ada", seat=seat, jail=None)
        s.call("seat_open", {"create": True})
        self.assertEqual(s.call("seat_date", {})["source"], "UNSET")
        r = s.call("seat_date", {"to": "20261101T000000Z", "why": "new leg"})
        self.assertTrue(r["moved"])
        self.assertTrue(s.call("seat_date", {})["date"].startswith("20261101T000000Z@"))
        with self.assertRaises(ToolError):
            s.call("seat_date", {"to": "20200101T000000Z"})


if __name__ == "__main__":
    unittest.main()


class TheStampSaysWhoseClock(unittest.TestCase):
    """His 2026-09-16 preference: *"UTC invariant affixed with hostname"*.

    Not decoration. A stamp says WHEN; the host says WHOSE CLOCK SAID SO.
    Without it, a date populated by a machine is indistinguishable from a date
    a person declared -- which is the whole distinction the shipboard date
    exists to keep, and it was missing from the format itself for one day.
    """

    def _seat(self):
        d = Path(tempfile.mkdtemp(prefix="host-"))
        self.addCleanup(shutil.rmtree, d, True)
        return d / "seat"

    def test_a_written_date_carries_a_host(self):
        seat = self._seat()
        st = _store.Store(root=seat, by="t", jail_root=None).ensure(create=True)
        st.stamp()
        s, _ = shipdate.read(st.active)
        stamp, host = shipdate.split_host(s)
        self.assertRegex(stamp, r"^\d{8}T\d{6}Z$")
        self.assertTrue(host, "a written date must say whose clock it was")
        self.assertEqual(shipdate.whose(st.active), host)

    def test_a_date_written_before_the_rule_still_reads(self):
        """Dates written before the host was required are still dates."""
        seat = self._seat()
        st = _store.Store(root=seat, by="t", jail_root=None).ensure(create=True)
        shipdate.path_for(st.active).write_bytes(b"20260101T000000Z\n")
        s, source = shipdate.read(st.active)
        self.assertEqual(source, "file")
        self.assertEqual(shipdate.split_host(s), ("20260101T000000Z", ""))
        self.assertEqual(shipdate.whose(st.active), "",
                         "no host recorded is reported as no host, never "
                         "guessed at from the machine reading it")

    def test_a_host_is_supplied_when_one_is_not_given(self):
        seat = self._seat()
        st = _store.Store(root=seat, by="t", jail_root=None).ensure(create=True)
        r = shipdate.advance(st.active, "20261225T000000Z", by="corwin")
        self.assertIn("@", r["date"], "somebody has to have been the clock")

    def test_the_host_is_ascii_and_short(self):
        h = shipdate.host()
        self.assertTrue(h.isascii() and h)
        self.assertNotIn(".", h, "the first label only, so a stamp stays short")
        self.assertRegex(h, r"^[A-Za-z0-9][A-Za-z0-9._-]*$")
