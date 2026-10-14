# polygram -- seat_mode quotes the preferences in force at session open (F1, pass 2).
# SPEC (P5 J7, cards 06/12): seat_mode's status line quotes prefs.quote(): the person and room rows
# in force and every seatkeeper "no", in words. With turn=<name>, that person sees their own
# person.<name>.* rows and never a third party's.
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
from __future__ import annotations

import os
import tempfile
import unittest
from pathlib import Path

from polygram.mcp import mentcached, prefs


class SeatOpenQuote(unittest.TestCase):
    def setUp(self):
        self.td = tempfile.TemporaryDirectory(); self.addCleanup(self.td.cleanup)
        root = Path(self.td.name)
        self._env = dict(os.environ)
        self.addCleanup(lambda: (os.environ.clear(), os.environ.update(self._env)))
        pf = root / "prefs.tsv"; pf.write_text(prefs.HEADER + "\n", encoding="utf-8", newline="\n")
        os.environ.update(MENTCACHED_PREFS=str(pf), MENTCACHED_KEEPER="corwin",
                          MENTCACHED_FRAME=str(root / "no-such-dir" / "fr"),   # named: never created
                          MENTCACHED_STATS=str(root / "spans.tsv"))
        (root / "spans.tsv").write_text("", encoding="utf-8", newline="\n")
        prefs.set_("people.named", "corwin, bryant", "t", "", turn="corwin")
        prefs.set_("person.corwin.answers", "short", "t", "", turn="corwin")
        prefs.set_("person.bryant.tone", "dry", "t", "", turn="bryant")
        h, _ = prefs.seat_hash("/srv/far")
        prefs.set_(f"skill.seatkeeper.{h}", "no: /srv/far", "t", "", turn="corwin")
        self.srv = mentcached.build(by="t", seat=root / "seat", jail=None)

    def test_session_open_quotes_rows_and_nos(self):
        say = self.srv.call("seat_mode", {})["say"]
        self.assertIn("Preferences in force:", say)
        self.assertIn("person.corwin.answers = short", say)
        self.assertIn("you said no to seating /srv/far", say)

    def test_a_person_sees_only_their_own_rows(self):
        say = self.srv.call("seat_mode", {"turn": "bryant"})["say"]
        self.assertIn("person.bryant.tone = dry", say)
        self.assertNotIn("person.corwin.answers", say)
        self.assertIn("you said no to seating /srv/far", say)


if __name__ == "__main__":
    unittest.main()
