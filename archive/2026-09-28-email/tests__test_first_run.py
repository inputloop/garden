# tier: smoke
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

"""What a stranger gets, on a machine that is not the author's.

An audit of the minted plugin, run as somebody with none of this project's
context, found that it was DEAD ON ARRIVAL: the bundle shipped
``MENTCACHED_SEAT`` as an unexpanded ``${MENTCACHED_SEAT}``, so a first
"remember this" answered NOTVISIBLE, and the only escape -- ``seat_open`` with
``create: true`` -- built a store at ``<wherever the host started the
process>/memory``.  Launched from ``/``, that is ``/memory``.

Three faults, and the third is not a bug at all:

  1. The default was RELATIVE, so the store's location was decided by the host's
     choice of working directory rather than by anyone.
  2. The citer identity defaulted to the PROCESS ID, so every restart minted a
     new consumer -- and since buoyancy ranks each seam against the worlds that
     cite it, a store full of worlds-of-one scores everything at parity and the
     orthogonality is silently gone.
  3. A seam with no ASCII alphanumerics raised ``ValueError``.  Japanese,
     Chinese, Korean, Cyrillic, Greek, Hebrew, Arabic and Thai users could not
     name a note in their own language.  That is not an encoding bug; it is
     this store deciding whose memory is welcome, which is store rule 4 in a
     different costume.

THE RULE THAT CAME OUT OF FIXING (1), because it resolves a real tension:

    We may create a path WE chose.  We may never create a path YOU chose.

``store.mode()`` answers NOTVISIBLE for a missing seat on purpose -- a typo and
a first run look identical from inside, and guessing wrong means serving an
empty store as though it were somebody's memory.  That rule is right.  But it
only bites when the USER named the path.  When nobody said, the server picked,
and there is no typo to be wrong about.
"""

import os
import shutil
import tempfile
import unicodedata
import unittest
from pathlib import Path

from polygram.mcp import dl2, mentcached
from polygram.mcp import store as _store


class AStrangerOnAFreshMachine(unittest.TestCase):

    # THE FRESH MACHINE IS FAKED THROUGH EVERY NAME THE PLATFORM READS. Setting HOME alone
    # was enough on Linux and NOTHING on Windows: Path.home() there reads USERPROFILE (then
    # HOMEDRIVE+HOMEPATH) and ignores HOME, so every host run of this file on avalon wrote its
    # fixtures -- "my first note", "s" -- into the keeper's REAL seat, C:\Users\corwi\.mentcached
    # \seat, three generations deep before anyone looked (2026-09-23, found because the "first"
    # note came back as gen 3). _server() below refuses to build unless the default seat really
    # resolves under this temp home, so the next platform quirk fails loud instead of writing.
    _HOME_VARS = ("HOME", "USERPROFILE", "HOMEDRIVE", "HOMEPATH")

    def setUp(self):
        self.home = Path(tempfile.mkdtemp(prefix="stranger-"))
        self.addCleanup(shutil.rmtree, self.home, True)
        self._env = {k: os.environ.get(k) for k in
                     ("MENTCACHED_SEAT", "MENTCACHED_JAIL", "MENTCACHED_BY", *self._HOME_VARS)}
        os.environ["HOME"] = str(self.home)
        os.environ["USERPROFILE"] = str(self.home)
        drive, tail = os.path.splitdrive(str(self.home))
        os.environ["HOMEDRIVE"], os.environ["HOMEPATH"] = drive, tail or str(self.home)
        for k in ("MENTCACHED_SEAT", "MENTCACHED_JAIL", "MENTCACHED_BY"):
            os.environ.pop(k, None)
        self.addCleanup(self._restore)

    def _restore(self):
        for k, v in self._env.items():
            if v is None:
                os.environ.pop(k, None)
            else:
                os.environ[k] = v

    def _server(self):
        import importlib
        importlib.reload(mentcached)
        # The guard. A seat outside this test's home is somebody's real memory; refuse to touch it.
        seat = Path(mentcached.DEFAULT_SEAT)
        try:
            seat.relative_to(self.home)
        except ValueError:
            self.fail(f"REFUSING to build a server: the default seat resolves to {seat}, outside "
                      f"this test's home {self.home}. Writing there would put test fixtures into "
                      "a real seat (it did, on Windows, until 2026-09-23). Path.home() on this "
                      "platform reads a variable this setUp does not set.")
        return mentcached.build()

    def test_the_default_seat_is_absolute_and_not_the_cwd(self):
        """Where the host starts a subprocess is not a decision anyone made."""
        seat, _jail, ours = mentcached._roots()
        self.assertTrue(seat.is_absolute(), f"{seat} is relative")
        self.assertTrue(ours, "nobody set MENTCACHED_SEAT, so it is ours")
        self.assertNotIn("memory", seat.parts[:1])
        self.assertNotEqual(seat.parent, Path.cwd(),
                            "a store next to wherever the process started is a "
                            "store placed by accident")

    def test_an_unexpanded_variable_counts_as_nobody_having_said(self):
        """A host that did not substitute is not a user who typed braces."""
        for literal in ("${MENTCACHED_SEAT}", "%MENTCACHED_SEAT%", "$MENTCACHED_SEAT"):
            os.environ["MENTCACHED_SEAT"] = literal
            _seat, _jail, ours = mentcached._roots()
            self.assertTrue(ours, f"{literal!r} must fall back to the default")

    def test_a_first_note_just_works(self):
        srv = self._server()
        r = srv.call("seat_append", {
            "seam": "my first note", "text": "hello",
            "source": "me", "would_change": "nothing yet"})
        self.assertEqual(r.get("gen"), 1, r)
        back = srv.call("seat_read", {"seam": "my first note"})
        self.assertIn("hello", back["note"])

    def test_a_seat_the_user_named_is_never_created_for_them(self):
        """The typo case. This is the half that must NOT be convenient."""
        typo = self.home / "Documnets" / "memory"
        os.environ["MENTCACHED_SEAT"] = str(typo)
        srv = self._server()
        self.assertEqual(srv.call("seat_mode", {})["mode"], _store.NOTVISIBLE)
        with self.assertRaises(Exception):
            srv.call("seat_append", {"seam": "x", "text": "y",
                                     "source": "me", "would_change": "z"})
        self.assertFalse(typo.exists(),
                         "a path the USER named must never be conjured: it "
                         "might be their real memory, mistyped")

    def test_the_mode_says_which_of_the_two_it_is(self):
        srv = self._server()
        m = srv.call("seat_mode", {})
        self.assertEqual(m["mode"], _store.NOTVISIBLE)
        self.assertIn("chosen_by", m)
        self.assertIn("first note will create it", m["say"])

    def test_the_citer_is_stable_across_restarts(self):
        a, b = self._server(), self._server()
        a.call("seat_append", {"seam": "s", "text": "x", "source": "m",
                               "would_change": "y"})
        a.call("seat_cite", {"seam": "s", "where": "t"})
        b.call("seat_cite", {"seam": "s", "where": "t"})
        row = b.call("seat_buoyancy", {})["queue"][0]
        self.assertEqual(
            row["citers"], [mentcached.DEFAULT_BY],
            "two launches must be ONE consumer. A per-process citer makes "
            "every seam a world of one, which scores everything at parity and "
            "silently removes the orthogonality buoyancy exists for.")
        for c in row["citers"]:
            self.assertNotRegex(c, r"\d{3,}",
                                "a process id is a timestamp wearing an identity")


class EveryLanguageIsWelcome(unittest.TestCase):
    """Store rule 4 does not stop at the ASCII boundary."""

    SEAMS = {
        "japanese": "設計メモ",
        "cyrillic": "заметка о проекте",
        "greek": "σημείωση",
        "hebrew": "הערה",
        "arabic": "ملاحظة",
        "thai": "บันทึก",
        "korean": "설계 노트",
        "emoji-only": "🌍🔧",
    }

    def test_a_note_can_be_named_in_any_script(self):
        seat = Path(tempfile.mkdtemp(prefix="i18n-")) / "seat"
        self.addCleanup(shutil.rmtree, seat.parent, True)
        srv = mentcached.build(by="t", seat=seat, jail=None)
        srv.call("seat_open", {"create": True})
        for tag, seam in self.SEAMS.items():
            with self.subTest(tag):
                srv.call("seat_append", {"seam": seam, "text": f"body for {tag}",
                                         "source": "me", "would_change": "x"})
                back = srv.call("seat_read", {"seam": seam})
                self.assertIn(f"body for {tag}", back["note"])

    def test_the_real_name_survives_in_full(self):
        """The handle is ASCII; the NAME is not touched."""
        seat = Path(tempfile.mkdtemp(prefix="i18n2-")) / "seat"
        self.addCleanup(shutil.rmtree, seat.parent, True)
        srv = mentcached.build(by="t", seat=seat, jail=None)
        srv.call("seat_open", {"create": True})
        srv.call("seat_append", {"seam": "設計メモ", "text": "x",
                                 "source": "me", "would_change": "y"})
        raw = next((seat / "notes").rglob("g*.md")).read_text(encoding="utf-8")
        self.assertIn("seam: 設計メモ", raw,
                      "the handle may be ASCII; the user's own name for their "
                      "note must appear unaltered in the bytes")

    def test_handles_are_stable_and_distinct(self):
        seen = {}
        for tag, seam in self.SEAMS.items():
            h = dl2.slugify(seam)
            self.assertEqual(h, dl2.slugify(seam), "must be deterministic")
            self.assertRegex(h, r"^n-[0-9a-f]{12}$")
            self.assertNotIn(h, seen,
                             f"{tag} collides with {seen.get(h)}")
            seen[h] = tag

    def test_the_handle_is_normalisation_stable(self):
        """NFC and NFD of one name are one seam, not two."""
        nfc = unicodedata.normalize("NFC", "café-note")
        nfd = unicodedata.normalize("NFD", "café-note")
        self.assertNotEqual(nfc, nfd, "the two forms differ as bytes")
        self.assertEqual(dl2.slugify(nfc), dl2.slugify(nfd),
                         "a seam that forks between macOS and GNU/Linux is a "
                         "seam that silently loses half its history")
        self.assertEqual(dl2.slugify(nfc), "cafe-note",
                         "and the accented letter folds to its base rather "
                         "than vanishing: cafe-note, never caf-note")

    def test_an_empty_name_is_still_refused(self):
        for blank in ("", "   ", "\t\n"):
            with self.assertRaises(ValueError):
                dl2.slugify(blank)


if __name__ == "__main__":
    unittest.main()
