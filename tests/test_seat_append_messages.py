# tier: smoke
# Copyright (C) 2026 Corwin Brust <corwin@bru.st>.  Authored by Mentat (for Corwin).
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free Software Foundation,
# either version 3 of the License, or (at your option) any later version.  It is distributed
# WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
"""seat_append's refusal explains the field that is actually missing (2026-09-27; the plugin audit
found a missing 'seam' answered with why 'source' matters)."""
import shutil
import tempfile
import unittest
from pathlib import Path

from polygram.mcp import mentcached, store as _store

FULL = {"seam": "s", "text": "t", "source": "me", "would_change": "a later note"}


class SeatAppendSaysWhichField(unittest.TestCase):
    def setUp(self):
        d = Path(tempfile.mkdtemp(prefix="seatmsg-"))
        self.addCleanup(shutil.rmtree, d, True)
        seat = d / "seat"
        _store.Store(root=seat, by="t").ensure(create=True, make_parents=True)
        self.srv = mentcached.build(by="test", seat=seat)

    def _refusal(self, missing):
        args = dict(FULL); args[missing] = ""
        with self.assertRaises(Exception) as cm:
            self.srv.call("seat_append", args)
        return str(cm.exception)

    def test_each_missing_field_gets_its_own_reason(self):
        for k, word in (("seam", "thread"), ("text", "note itself"),
                        ("source", "fact from a guess"), ("would_change", "revise")):
            msg = self._refusal(k)
            self.assertIn(f"needs {k!r}", msg)
            self.assertIn(word, msg, f"{k}: {msg}")

    def test_a_missing_seam_is_not_told_about_source(self):
        self.assertNotIn("'source' is what", self._refusal("seam"))

    def test_a_full_note_still_lands(self):
        self.assertEqual(self.srv.call("seat_append", FULL).get("gen"), 1)


if __name__ == "__main__":
    unittest.main()
