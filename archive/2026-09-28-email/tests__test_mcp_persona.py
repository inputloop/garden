# tier: smoke
# polygram -- tests for persona's root resolution and citer identity.
# Copyright (C) 2026 Corwin <mplscorwin@gmail.com>.  GPL-3.0-or-later.
#
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
"""Coverage for the 2026-09-24 fix: persona_list answered NOTVISIBLE on a real desktop
install where mentcached's seat_mode answered SEATED from the same environment.

Two escapes let that through undetected:

  1. persona._root() defaulted to ``Path.cwd() / "memory" / "persona"``.  cwd is decided
     by whatever spawns the MCP process, not by Corwin, so the default essentially never
     pointed at the seat mentcached itself resolves to. Neither tests/mcp-smoke.pl (which
     asserts persona_list does not crash, never where it looked) nor any test module here
     exercised the *value* of the resolved root, only that a call answered at all.
  2. persona.build() minted a citer identity from ``os.getpid()`` -- the exact bug
     mentcached.DEFAULT_BY was introduced to fix -- so even a correctly-rooted persona
     store would have scored every seam's buoyancy at parity across restarts.

These tests pin persona's root to mentcached's own DEFAULT_SEAT (imported, not copied, so
the two cannot drift apart again), pin the "we may create a path we chose, never a path
Corwin named" rule from mentcached onto persona's first write, and pin the stable citer
default.  Third language (Perl, in mcp-smoke.pl) already covers the desktop-shaped spawn;
this is the direct, fast, in-process spec.

``mentcached.DEFAULT_SEAT`` is read at CALL time by ``persona._root()`` (an attribute
lookup on the shared module object, not a value copied at persona's import time) but it is
itself computed once, at ``mentcached``'s own import time, from ``Path.home()`` -- so these
tests patch the attribute directly (``mock.patch.object``) rather than mutate ``$HOME``,
which a module already imported by an earlier test in this same process would not see.
"""

from __future__ import annotations

import os
import tempfile
import unittest
from pathlib import Path
from unittest import mock

from polygram.mcp import mentcached, persona, store as S
from polygram.mcp.rpc import ToolError


class _CleanEnv(unittest.TestCase):
    """No persona/mentcached env var leaks in from the runner's own shell, and
    mentcached.DEFAULT_SEAT points at a fresh temp dir for the duration of the test."""

    ENV_KEYS = ("PERSONA_ROOT", "PERSONA_JAIL", "PERSONA_BY", "PERSONA_SHEETS",
                "MENTCACHED_SEAT", "MENTCACHED_JAIL", "MENTCACHED_BY",
                "MENTCACHED_PREFS", "SOFT_SKILLS")

    def setUp(self):
        self._saved = {k: os.environ.get(k) for k in self.ENV_KEYS}
        for k in self.ENV_KEYS:
            os.environ.pop(k, None)
        self._td = tempfile.TemporaryDirectory()
        self.addCleanup(self._td.cleanup)
        self.default_seat = Path(self._td.name) / ".mentcached" / "seat"
        # the host's real ~/.mentcached/prefs.tsv must not leak in (it names real sheets)
        os.environ["MENTCACHED_PREFS"] = str(Path(self._td.name) / "prefs.tsv")
        patcher = mock.patch.object(mentcached, "DEFAULT_SEAT", self.default_seat)
        patcher.start()
        self.addCleanup(patcher.stop)

    def tearDown(self):
        for k, v in self._saved.items():
            if v is None:
                os.environ.pop(k, None)
            else:
                os.environ[k] = v


class DefaultRootMirrorsMentcached(_CleanEnv):
    def test_unset_env_resolves_under_mentcacheds_own_default_seat(self):
        """The bug, pinned directly: no env set anywhere -- the real desktop shape."""
        root, jail, ours = persona._root()
        self.assertEqual(root, self.default_seat / "persona")
        self.assertTrue(ours, "an un-set default is ours to create")

    def test_mentcached_seat_env_set_is_theirs_not_ours(self):
        """MENTCACHED_SEAT is a value a person set -- deriving from it is deriving from a
        path Corwin named, so persona must not auto-create under it either, mirroring
        mentcached's own 'you chose it -> we will not invent a substitute' rule."""
        seat = Path(self._td.name) / "elsewhere-seat"
        os.environ["MENTCACHED_SEAT"] = str(seat)
        root, _jail, ours = persona._root()
        self.assertEqual(root, seat / "persona")
        self.assertFalse(ours, "a seat Corwin named is not a default we invented")

    def test_persona_root_env_overrides_everything_and_is_theirs(self):
        named = Path(self._td.name) / "corwin-named-this"
        os.environ["PERSONA_ROOT"] = str(named)
        os.environ["MENTCACHED_SEAT"] = str(Path(self._td.name) / "ignored-seat")
        root, _jail, ours = persona._root()
        self.assertEqual(root, named)
        self.assertFalse(ours, "a path Corwin named is never auto-created")

    def test_unexpanded_template_var_is_treated_as_unset(self):
        os.environ["MENTCACHED_SEAT"] = "${MENTCACHED_SEAT}"
        root, _jail, ours = persona._root()
        self.assertEqual(root, self.default_seat / "persona")
        self.assertTrue(ours)


class FirstWriteSelfSeatsLikeMentcached(_CleanEnv):
    """Reproduces Corwin's exact reported state: mentcached's seat already exists and is
    SEATED (a prior session used it), but nothing has ever written a persona sheet, so
    ``seat/persona`` has never been created. persona_list must show that honestly
    (NOTVISIBLE, not a crash and not an invented empty-but-SEATED store), and a real write
    must self-heal it -- exactly as seat_append does for mentcached.
    """

    def setUp(self):
        super().setUp()
        self.default_seat.mkdir(parents=True)

    def test_persona_list_is_honest_before_any_write(self):
        # 2026-09-25: this said NOTVISIBLE (the store dir not created yet). Superseded: the root is
        # ours, under a seat that exists and is writable, so it IS reachable -- SEATED -- and the
        # "store is empty, created on first persona_mutate" line says the rest. Corwin, 09-24:
        # "no idea why I would want anything other than to have the work we already did show up."
        srv = persona.build()
        out = srv.call("persona_list", {})
        self.assertEqual(out["mode"], S.SEATED)
        self.assertEqual(out["count"], 0)
        self.assertIn("created on the first persona_mutate", out["say"])
        self.assertFalse((self.default_seat / "persona").exists(), "listing never creates the root")

    def test_mentcached_agrees_its_own_seat_is_seated_the_whole_time(self):
        """The asymmetry that made this bug invisible: prove it is gone."""
        self.assertEqual(mentcached.build().call("seat_mode", {})["mode"], S.SEATED)
        self.assertEqual(persona.build().call("persona_list", {})["mode"], S.SEATED)
        # ^ 2026-09-25: the two servers now agree (was NOTVISIBLE before any write; see above).
        # What must NOT be true any more is persona resolving somewhere else entirely.
        root, _jail, ours = persona._root()
        self.assertTrue(str(root).startswith(str(self.default_seat)))
        self.assertTrue(ours)

    def test_a_real_write_self_heals_it_and_later_reads_see_it(self):
        srv = persona.build()
        out = srv.call("persona_mutate", {
            "name": "test-sheet",
            "entry": "a first line, in no particular voice",
            "evidence": "this test file",
            "would_change": "if the default seat truly were not writable",
        })
        self.assertEqual(out["mode"], S.SEATED)

        listed = persona.build().call("persona_list", {})
        self.assertEqual(listed["mode"], S.SEATED)
        self.assertEqual(listed["count"], 1)
        self.assertEqual(listed["personas"][0]["seam"], "test-sheet")

        read = persona.build().call("persona_read", {"name": "test-sheet"})
        self.assertTrue(read["found"])

        self.assertTrue((self.default_seat / "persona").is_dir())

    def test_a_path_corwin_named_is_never_auto_created_even_when_notvisible(self):
        # persona._mutate only auto-creates via st.ensure(create=True, ...) when the
        # resolved root is OURS (see _root()); for a root Corwin named, st.append()'s own
        # internal st.ensure() (no create=True) is what refuses, and that refusal is a
        # bare store.StoreError -- persona._mutate does not wrap it, the same as
        # mentcached._append does not wrap it for the equivalent "theirs" case.
        os.environ["PERSONA_ROOT"] = str(Path(self._td.name) / "typo-prone-path")
        srv = persona.build()
        with self.assertRaises(S.StoreError):
            srv.call("persona_mutate", {
                "name": "test-sheet",
                "entry": "should never land",
                "evidence": "this test file",
                "would_change": "if this assertion is wrong",
            })
        self.assertFalse((Path(self._td.name) / "typo-prone-path").exists())


class CiterIdentityIsStable(_CleanEnv):
    """head_stamp's "@X" suffix is shipdate.host() -- the machine, not the citer -- so
    these read the citer identity from where it is actually recorded: the "by:" front
    matter field of the generation file itself (store.append() writes ``by=self.by``
    verbatim into ``dl2.Note``, and dl2.render_note prints it as ``by: <value>``)."""

    def _written_by(self, mutate_result):
        from polygram.mcp import dl2
        f = (self.default_seat / "persona" / "notes" / dl2.slugify("test-sheet")
             / mutate_result["file"])
        return dl2.parse_note(f.read_text(encoding="utf-8")).by

    def test_default_by_is_not_pid_shaped(self):
        """mentcached's own lesson, backported: buoyancy needs a citer identity that
        survives a restart, or every seam's citers list is a world of one forever."""
        self.assertEqual(persona.DEFAULT_BY, mentcached.DEFAULT_BY)
        self.assertNotIn(str(os.getpid()), persona.DEFAULT_BY)

    def test_build_uses_the_stable_default_when_nothing_overrides_it(self):
        self.default_seat.mkdir(parents=True)
        out = persona.build().call("persona_mutate", {
            "name": "test-sheet",
            "entry": "line one",
            "evidence": "this test file",
            "would_change": "if citer identity were pid-shaped again",
        })
        self.assertEqual(self._written_by(out), persona.DEFAULT_BY)

    def test_persona_by_env_still_overrides_the_default(self):
        os.environ["PERSONA_BY"] = "corwin"
        self.default_seat.mkdir(parents=True)
        out = persona.build().call("persona_mutate", {
            "name": "test-sheet",
            "entry": "line one",
            "evidence": "this test file",
            "would_change": "if PERSONA_BY were ignored",
        })
        self.assertEqual(self._written_by(out), "corwin")


if __name__ == "__main__":
    unittest.main()


class ShelfServesTheSheetsAlreadyWritten(_CleanEnv):
    """2026-09-24, Corwin: 'no idea why I would want anything other than to have the work we
    already did show up.'  A fresh install's generation store is empty; the sheets in
    h/persona must still be listed, resolved and read -- read-only, never copied."""

    def setUp(self):
        super().setUp()
        self.shelf = Path(self._td.name) / "h" / "persona"
        self.shelf.mkdir(parents=True)
        (self.shelf / "CHARACTER-2026-09-06-mentat.md").write_text(
            "---\n# CHARACTER SHEET -- Mentat\nactor: system (software)\n", encoding="utf-8", newline="\n")
        (self.shelf / "PERSONA-gw7.md").write_text(
            "# PERSONA -- gw7\nactor: host (a system actor)\n", encoding="utf-8", newline="\n")
        (self.shelf / "ROSTER.md").write_text("# not a sheet\n", encoding="utf-8", newline="\n")
        os.environ["PERSONA_SHEETS"] = str(self.shelf)
        self.srv = persona.build()

    def test_names_come_from_the_file_name(self):
        self.assertEqual(persona._stem_name(Path("CHARACTER-2026-09-05-shopgarden.md")), "shopgarden")
        self.assertEqual(persona._stem_name(Path("PERSONA-gw7.md")), "gw7")

    def test_list_shows_the_shelf_while_the_store_is_empty(self):
        r = self.srv.call("persona_list", {})
        self.assertEqual(r["count"], 2)
        self.assertEqual(sorted(x["name"] for x in r["personas"]), ["gw7", "mentat"])
        self.assertTrue(all(x["source"] == "shelf" for x in r["personas"]))
        self.assertIn("created on the first persona_mutate", r["say"])
        self.assertFalse((self.default_seat / "persona").exists(), "listing never creates the store")

    def test_read_and_resolve_reach_a_shelf_sheet(self):
        r = self.srv.call("persona_read", {"name": "gw7"})
        self.assertTrue(r["found"])
        self.assertIn("actor: host", r["note"])
        r = self.srv.call("persona_resolve", {"name": "Mentat"})
        self.assertEqual(r["resolved"], "mentat")
        self.assertEqual(r["source"], "persona-mcp (shelf)")

    def test_an_absent_name_is_still_a_fault_not_a_mint(self):
        r = self.srv.call("persona_read", {"name": "nobody"})
        self.assertFalse(r["found"])
        self.assertIn("Refusal 1", r["say"])

    def test_the_pref_outranks_the_env(self):
        other = Path(self._td.name) / "other"
        other.mkdir()
        (other / "PERSONA-solo.md").write_text("# PERSONA -- solo\n", encoding="utf-8", newline="\n")
        Path(os.environ["MENTCACHED_PREFS"]).write_text(
            "ts\tkey\tvalue\tby\twhy\n"
            f"2026-09-24T00:00:00Z\tpersona.sheets\t{other}\ttest\t\n", encoding="utf-8", newline="\n")
        r = persona.build().call("persona_list", {})
        self.assertEqual([x["name"] for x in r["personas"]], ["solo"])

    def test_a_journal_rides_beside_its_sheet_never_over_it(self):
        # 2026-09-25: was "a chained sheet shadows the shelf copy". Superseded: ingest-writing's
        # step 6 mutates CORWIN through persona_mutate, and the first mutation must not hide the
        # model itself. The sheet is what the name means; the generations are its journal.
        self.srv.call("persona_mutate", {"name": "gw7", "entry": "a loaf", "evidence": "test",
                                         "would_change": "test"})
        r = self.srv.call("persona_list", {})
        self.assertEqual(r["count"], 2)
        self.assertEqual(r["shadowed"], [])
        row = {x["name"]: x for x in r["personas"]}["gw7"]
        self.assertEqual(row["source"], "shelf+journal")
        self.assertEqual(row["journal"]["gens"], 1)
        got = self.srv.call("persona_read", {"name": "gw7"})
        self.assertIn("actor: host", got["note"], "the sheet, not the journal entry")
        self.assertEqual(got["journal"]["generations"], 1)
        self.assertIn("a loaf", got["journal"]["head"])
        self.assertEqual(self.srv.call("persona_read", {"name": "gw7", "gen": 1})["gen"], 1)


class OneRuleFindsEveryKind(_CleanEnv):
    """2026-09-24: 'make sure that everyone can be found by the same systemic means.'  A file
    is a sheet by what its own first lines say, never by its name; drift between copies is
    reported, never resolved."""

    def _w(self, d: Path, name: str, text: str) -> Path:
        d.mkdir(parents=True, exist_ok=True)
        f = d / name
        f.write_text(text, encoding="utf-8", newline="\n")
        return f

    def setUp(self):
        super().setUp()
        base = Path(self._td.name)
        self.a, self.b = base / "a", base / "b"
        self._w(self.a, "ILUNGA.md", "---\n# CHARACTER SHEET -- ILUNGA\nactor: fiction (an author)\n")
        self._w(self.a, "pub.ITEM.md", "---\n# ITEM SHEET -- pub\nactor: place (a word)\n")
        self._w(self.a, "MERLIN.md", "---\nname: MERLIN\nstatus: SYNTHETIC INSTRUMENT -- a test-persona\n---\n")
        self._w(self.a, "CORWIN.md", "---\nname: CORWIN\ndescription: a persona model\n---\n")
        self._w(self.a, "NOTE.md", "---\nname: note\nstatus: NOTE for Model This Book\n---\n")
        self._w(self.a, "CORWIN-SECRET.md", "---\nname: CORWIN-SECRET\ndescription: a persona model\n---\n")
        self._w(self.a, "ROSTER.md", "# The character sheets -- a roster\n")
        self._w(self.b, "ILUNGA.md", "---\n# CHARACTER SHEET -- ILUNGA\nactor: fiction (an author)\n")
        self._w(self.b, "CORWIN.md", "---\nname: CORWIN\ndescription: a persona model, older\n---\n")
        os.environ["PERSONA_SHEETS"] = os.pathsep.join([str(self.a), str(self.b)])
        self.r = persona.build().call("persona_list", {})

    def test_every_kind_is_found_by_its_own_words(self):
        got = {x["name"]: (x["kind"], x["actor"]) for x in self.r["personas"]}
        self.assertEqual(got, {"ilunga": ("sheet", "fiction"), "pub-item": ("sheet", "place"),
                               "merlin": ("sheet", "synthetic"), "corwin": ("model", "person-model")})

    def test_the_project_title_and_a_roster_are_not_sheets(self):
        names = {x["name"] for x in self.r["personas"]}
        self.assertNotIn("note", names)
        self.assertNotIn("roster", names)

    def test_a_secret_is_never_served(self):
        self.assertIsNone(persona.classify(self.a / "CORWIN-SECRET.md"))
        self.assertFalse(any("SECRET" in x["file"] for x in self.r["personas"] + self.r["copies"]))

    def test_copies_are_reported_and_drift_is_named_not_resolved(self):
        agree = {c["name"]: c["bytes_agree"] for c in self.r["copies"]}
        self.assertEqual(agree, {"ilunga": True, "corwin": False})
        self.assertEqual(self.r["drift"], ["corwin"])
        self.assertIn("DIFFERING for: corwin", self.r["say"])
        first = {x["name"]: x["file"] for x in self.r["personas"]}["corwin"]
        self.assertTrue(first.startswith(str(self.a)), "the earlier root wins the name")


class ARenameLeavesNoSilentTwin(_CleanEnv):
    """2026-09-25: gw7's sheet was renamed gh7 by a name: line; a stale copy in another tree kept
    serving as "gw7" -- a new persona, silently. Same file name, two served names, is a SPLIT."""

    def setUp(self):
        super().setUp()
        base = Path(self._td.name)
        self.a, self.b = base / "a", base / "b"
        for d in (self.a, self.b):
            d.mkdir(parents=True)
        (self.a / "PERSONA-gw7.md").write_text("# PERSONA -- gh7\nname: gh7\nactor: host\n", encoding="utf-8", newline="\n")
        (self.b / "PERSONA-gw7.md").write_text("# PERSONA -- gw7\nactor: host\n", encoding="utf-8", newline="\n")
        (self.a / "MERLIN.md").write_text("---\nname: MERLIN\nstatus: SYNTHETIC -- a test-persona\n---\n\n# MERLIN -- the control\n", encoding="utf-8", newline="\n")
        os.environ["PERSONA_SHEETS"] = os.pathsep.join([str(self.a), str(self.b)])
        self.r = persona.build().call("persona_list", {})

    def test_the_stale_twin_is_named_as_a_split(self):
        self.assertEqual(self.r["split"], ["PERSONA-gw7.md: gh7 / gw7"])
        self.assertIn("SPLIT", self.r["say"])

    def test_no_split_when_the_twins_agree_on_the_name(self):
        (self.b / "PERSONA-gw7.md").write_text("# PERSONA -- gh7\nname: gh7\nactor: host\n", encoding="utf-8", newline="\n")
        r = persona.build().call("persona_list", {})
        self.assertEqual(r["split"], [])
        self.assertNotIn("SPLIT", r["say"])

    def test_a_sheet_with_no_heading_takes_its_first_h1_as_title(self):
        t = {x["name"]: x["title"] for x in self.r["personas"]}
        self.assertEqual(t["merlin"], "MERLIN -- the control")


class ModeWordTellsTheTruth(_CleanEnv):
    """2026-09-25: persona served sixteen sheets while every answer said NOTVISIBLE."""

    def test_our_default_root_under_a_real_seat_reads_seated_before_first_write(self):
        self.default_seat.mkdir(parents=True)
        r = persona.build().call("persona_refusals", {})
        self.assertEqual(r["mode"], S.SEATED)
        self.assertFalse((self.default_seat / "persona").exists(), "reading never creates the root")

    def test_our_default_root_with_no_seat_at_all_stays_notvisible(self):
        r = persona.build().call("persona_refusals", {})
        self.assertEqual(r["mode"], S.NOTVISIBLE)

    def test_a_named_root_that_is_absent_stays_notvisible(self):
        self.default_seat.mkdir(parents=True)
        os.environ["PERSONA_ROOT"] = str(self.default_seat / "named-by-corwin")
        r = persona.build().call("persona_refusals", {})
        self.assertEqual(r["mode"], S.NOTVISIBLE)
