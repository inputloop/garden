# tier: smoke
# polygram -- tests for the archive-only memory seat.
# Copyright (C) 2026 Corwin <mplscorwin@gmail.com>.  GPL-3.0-or-later.
#
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
"""The store's three rules, tested as properties rather than promised.

Each test class is one of the rules from ``polygram/mcp/store.py``:

  ArchiveOnly   nothing is ever overwritten, simplified or deleted
  IndexIsCache  every forward pointer is rebuildable from the bytes alone
  ModeIsSaid    the mode word is on every result, and a jailed write is stamped
"""

from __future__ import annotations

import os
import tempfile
import unittest
from pathlib import Path

from polygram.mcp import dl2, store as S, verify


class _Tmp(unittest.TestCase):
    def setUp(self):
        self._td = tempfile.TemporaryDirectory()
        self.root = Path(self._td.name) / "seat"
        self.st = S.Store(root=self.root, by="test").ensure(create=True)

    def tearDown(self):
        self._td.cleanup()

    def _note(self, seam="a-seam", text="body one", **kw):
        kw.setdefault("frm", "them")
        kw.setdefault("would_change", "a second source disagreeing")
        return self.st.append(seam, text, **kw)


class ArchiveOnly(_Tmp):
    def test_append_mints_a_new_generation_and_keeps_the_old(self):
        self._note(text="one")
        self._note(text="two")
        self._note(text="three")
        gens = self.st.generations("a-seam")
        self.assertEqual(len(gens), 3)
        bodies = [dl2.parse_note(p.read_text(encoding="utf-8")).body for p in gens]
        self.assertEqual(bodies, ["one", "two", "three"])

    def test_generation_files_are_opened_O_EXCL(self):
        """The archive rule is enforced by the kernel, not by our good manners.

        Force a name collision by pinning the filename generator, then write:
        the O_EXCL open must refuse rather than clobber.
        """
        self._note(text="one")
        d = self.st.notes / "a-seam"
        existing = sorted(d.iterdir())[0]
        before = existing.read_text(encoding="utf-8")
        real = dl2.gen_filename
        try:
            dl2.gen_filename = lambda *a, **k: existing.name
            with self.assertRaises(S.StoreError) as cm:
                self.st.append("a-seam", "two", frm="them", would_change="x")
            self.assertIn("never rewrites", str(cm.exception))
        finally:
            dl2.gen_filename = real
        self.assertEqual(existing.read_text(encoding="utf-8"), before,
                         "the existing generation was modified")

    def test_a_foreign_file_in_a_notes_dir_is_loud_and_names_itself(self):
        self._note(text="one")
        d = self.st.notes / "a-seam"
        (d / "g9999-not-a-generation.md").write_text("junk\n", encoding="utf-8", newline="")
        # Every reader IGNORES it -- the chain spec says so, and one stray file
        # must not stop every read of a seam. But ignored is not invisible.
        out = self.st.read("a-seam")
        self.assertTrue(out["found"])
        self.assertIn("g9999-not-a-generation.md", out["strays"])
        self.assertIn("move them out by hand", out["say"])
        from polygram.mcp import verify
        self.assertTrue(verify.verify_python(d).ok,
                        "a stray file must not break the chain")

    def test_no_write_mode_anywhere_in_the_module(self):
        """No code path in store.py opens an existing note for writing.

        Grep is a blunt instrument and that is the point: this catches a future
        edit that reaches for ``open(..., 'w')`` on a note, which is how an
        archive-only store stops being one.
        """
        src = Path(S.__file__).read_text(encoding="utf-8")
        for bad in ('"w")', "'w')", '"r+"', "'r+'"):
            for line in src.splitlines():
                if bad in line and "notes" in line:
                    self.fail(f"note opened for writing: {line.strip()}")

    def test_chain_is_tamper_evident(self):
        self._note(text="one")
        self._note(text="two")
        rows = self.st.chain("a-seam")
        self.assertEqual([r["link"] for r in rows], ["OK", "OK"])
        g1 = self.st.generations("a-seam")[0]
        g1.write_text(g1.read_text(encoding="utf-8") + "tampered\n", newline="")
        rows = self.st.chain("a-seam")
        self.assertEqual(rows[1]["link"], "BROKEN")

    def test_authorship_change_is_visible_without_being_announced(self):
        self._note(text="one")
        other = S.Store(root=self.root, by="another-session").ensure(create=True)
        other.append("a-seam", "two", frm="them", would_change="x")
        rows = self.st.chain("a-seam")
        self.assertFalse(rows[0]["hands_changed"])
        self.assertTrue(rows[1]["hands_changed"])
        # And the fence held without any fence code: gen 1's bytes are intact.
        self.assertEqual(dl2.parse_note(
            self.st.generations("a-seam")[0].read_text(encoding="utf-8")).by, "test")

    def test_first_seen_is_pinned_once_and_carried_forever(self):
        a = self._note(text="one")
        self._note(text="two")
        c = self._note(text="three")
        self.assertEqual(a["first_seen"], c["first_seen"])
        self.assertTrue(c["first_seen"].startswith("g0001-"))
        # ... and it is a filename a reader can actually open.
        self.assertTrue((self.st.notes / "a-seam" / c["first_seen"]).is_file())

    def test_generation_one_leaves_first_seen_empty_and_means_itself(self):
        """Under spec v2 the filename is the hash of the file, so first-seen on
        generation 1 would name the file it is written inside -- a value that
        changes the bytes it is derived from. Empty means 'this file', the API
        resolves it, and the pin a reader actually needs (on the head of a long
        chain) is written down from generation 2 onward."""
        self._note(text="one")
        g1 = self.st.generations("a-seam")[0]
        self.assertEqual(dl2.parse_note(g1.read_bytes()).first_seen, "",
                         "gen 1 must not try to name itself")
        self.assertEqual(self.st.read("a-seam")["first_seen"], g1.name,
                         "the API resolves the convention for the caller")
        self._note(text="two")
        g2 = self.st.generations("a-seam")[1]
        self.assertEqual(dl2.parse_note(g2.read_bytes()).first_seen, g1.name,
                         "gen 2 is where gen 1's name gets written down")

    def test_the_head_generations_front_matter_is_tamper_evident(self):
        """Spec v1 hashed only the body, so mode: JAILED could be edited to
        SEATED on the head and every reader still said OK -- while append()
        promised the word was stamped in the bytes forever."""
        self._note(text="one")
        self._note(text="two")
        head = self.st.head("a-seam")
        head.write_bytes(head.read_bytes().replace(b"mode: SEATED",
                                                   b"mode: JAILED "))
        for impl in (verify.verify_python, verify.verify_shell, verify.verify_perl):
            r = impl(self.st.notes / "a-seam")
            self.assertFalse(r.ok, impl.__name__)
            self.assertEqual(r.check, "C3 self", impl.__name__)


class IndexIsCache(_Tmp):
    def test_a_missing_citation_log_is_marked_not_silently_zero(self):
        """FINDING 6: rebuild_index read cited/ while claiming to rebuild from
        the notes alone, so deleting it reported every note as never cited --
        with no fault and a success message."""
        import shutil
        self._note(seam="one", text="x")
        for i in range(3):
            self.st.cite("one", "r", f"d{i}")
        self.assertEqual(self.st.read("one")["pressure"], 3)
        self.st.rebuild_index()
        self.assertIn("\t3\t", self.st.index.read_text(encoding="utf-8"))
        shutil.rmtree(self.st.cited)

        # The note was written BEFORE those citations, so its own bytes hold no
        # record of them. We cannot tell "never cited" from "log deleted", and
        # the store must not claim either.
        out = self.st.rebuild_index()
        self.assertEqual(out["degraded"], 0)
        self.assertEqual(out["no_log"], 1)
        self.assertIn("indistinguishable", out["no_log_say"])

        # Now make a note that DOES remember: cite, revise, then lose the log.
        self._note(seam="two", text="x")
        self.st.cite("two", "r", "d")
        import time; time.sleep(1.05)
        self._note(seam="two", text="revised")
        shutil.rmtree(self.st.cited)
        out = self.st.rebuild_index()
        self.assertEqual(out["degraded"], 1, "a known loss must be named")
        self.assertIn("gone or shorter", out["say"])
        self.assertIn("~", self.st.index.read_text(encoding="utf-8"))
        row = [r for r in self.st.buoyancy() if r["seam"] == "two"][0]
        self.assertIn("NOTVISIBLE", row.get("pressure_source", ""))

    def test_a_truncated_citation_log_is_proof_of_loss_not_a_zero(self):
        """An append-only log cannot shrink. If it has fewer lines than the
        head generation recorded seeing, lines were removed -- and max(0, ...)
        used to swallow that into an ordinary-looking pressure of 0."""
        self._note(seam="t", text="x")
        for i in range(7):
            self.st.cite("t", "r", f"d{i}")
        import time; time.sleep(1.05)
        self._note(seam="t", text="revised")           # records cited-at-write: 7
        log = self.st.cited / "t.log"
        log.write_text(log.read_text(encoding="utf-8").splitlines()[0] + "\n", newline="")   # truncate to 1
        self.assertEqual(self.st.read("t")["pressure"], -6,
                         "the negative IS the signal; it must not be clamped")
        out = self.st.rebuild_index()
        self.assertEqual(out["degraded"], 1)
        self.assertIn("!", self.st.index.read_text(encoding="utf-8"))

    def test_index_rebuilds_from_the_notes_alone(self):
        self._note(seam="one", text="x")
        self._note(seam="two", text="y")
        self.st.cite("one", "someone", "a document")
        before = self.st.rebuild_index()
        text_before = self.st.index.read_text(encoding="utf-8")
        self.st.index.unlink()
        self.assertFalse(self.st.index.exists())
        after = self.st.rebuild_index()
        self.assertEqual(before["seams"], after["seams"])
        self.assertEqual(text_before, self.st.index.read_text(encoding="utf-8"))

    def test_deleting_the_whole_index_dir_loses_nothing(self):
        self._note(seam="one", text="x")
        import shutil
        shutil.rmtree(self.st.index.parent)
        self.assertEqual(self.st.read("one")["found"], True)
        self.st.rebuild_index()
        self.assertIn("one", self.st.index.read_text(encoding="utf-8"))


class Pressure(_Tmp):
    def test_citing_moves_pressure_and_mints_nothing(self):
        self._note(seam="s", text="x")
        gens_before = len(self.st.generations("s"))
        self.assertEqual(self.st.read("s")["pressure"], 0)
        for i in range(3):
            self.st.cite("s", "reader", f"doc-{i}")
        self.assertEqual(self.st.read("s")["pressure"], 3)
        self.assertEqual(len(self.st.generations("s")), gens_before,
                         "a citation must never mint a generation")

    def test_a_new_generation_resets_pressure(self):
        self._note(seam="s", text="x")
        for i in range(4):
            self.st.cite("s", "reader", f"doc-{i}")
        self.assertEqual(self.st.read("s")["pressure"], 4)
        import time
        time.sleep(1.05)          # stamps are second-resolution
        self._note(seam="s", text="revised")
        self.assertEqual(self.st.read("s")["pressure"], 0)

    def test_buoyancy_orders_by_pressure(self):
        for seam in ("low", "high", "none"):
            self._note(seam=seam, text="x")
        self.st.cite("high", "r", "d")
        self.st.cite("high", "r", "d")
        self.st.cite("low", "r", "d")
        order = [r["seam"] for r in self.st.buoyancy()]
        self.assertEqual(order[0], "high")
        self.assertEqual(order[1], "low")
        self.assertEqual(order[2], "none")


class ModeIsSaid(_Tmp):
    def test_seated_store_says_seated(self):
        self.assertEqual(self.st.mode(), S.SEATED)
        self.assertEqual(self._note()["mode"], S.SEATED)

    def test_a_seat_that_does_not_exist_is_not_SEATED(self):
        """A typo and a first run look identical from here, so absence is not
        SEATED. Answering SEATED for MENTCACHED_SEAT=/f/claude/seaat created an
        empty store and served 'no note about that', which is worse than JAILED
        because JAILED says something is wrong."""
        td = Path(self._td.name)
        st = S.Store(root=td / "typoo", by="t")
        self.assertEqual(st.mode(), S.NOTVISIBLE)
        with self.assertRaises(S.StoreError) as cm:
            st.read("x")
        self.assertIn("create=true", str(cm.exception))
        st.ensure(create=True)
        self.assertEqual(st.mode(), S.SEATED)

    def test_an_unexpanded_env_var_is_not_a_path(self):
        """The plugin's .mcp.json contains the literal ${MENTCACHED_SEAT}; a
        host that does not expand it must not get a directory by that name."""
        st = S.Store(root=Path("${MENTCACHED_SEAT}"), by="t")
        self.assertEqual(st.mode(), S.NOTVISIBLE)
        with self.assertRaises(S.StoreError) as cm:
            st.ensure(create=True)
        self.assertIn("unexpanded", str(cm.exception))
        self.assertFalse(Path("${MENTCACHED_SEAT}").exists())

    def test_mode_does_not_mutate_root(self):
        """The bug the store's own prove-red caught: mode() must assign nothing."""
        td = Path(self._td.name)
        jail = td / "jail"
        jail.mkdir()
        st = S.Store(root=td / "gone" / "deeper" / "seat", by="t", jail_root=jail)
        before = st.root
        self.assertEqual(st.mode(), S.JAILED)
        self.assertEqual(st.mode(), S.JAILED, "the second call must agree")
        self.assertEqual(st.root, before, "mode() reassigned root")
        self.assertEqual(st.active, jail)

    def test_jailed_write_is_refused_then_stamped(self):
        td = Path(self._td.name)
        jail = td / "jail2"
        jail.mkdir()
        st = S.Store(root=td / "gone" / "deeper" / "seat", by="t", jail_root=jail)
        with self.assertRaises(S.Jailed):
            st.append("s", "x", frm="them", would_change="y")
        out = st.append("s", "x", frm="them", would_change="y", allow_jailed=True)
        self.assertEqual(out["mode"], S.JAILED)
        self.assertIn("mode: JAILED", st.read("s")["note"])

    def test_notvisible_refuses_everything_and_chooses_nothing(self):
        st = S.Store(root=Path("/nonexistent-root-xyz/seat"), by="t", jail_root=None)
        self.assertEqual(st.mode(), S.NOTVISIBLE)
        with self.assertRaises(S.StoreError) as cm:
            st.read("s")
        self.assertIn("NOTVISIBLE", str(cm.exception))
        self.assertIn("no fallback was chosen for you", str(cm.exception))


class Semaphores(_Tmp):
    def test_raise_is_cheap_lower_is_a_ceremony(self):
        sem = self.st.semaphore("main memory desync")
        sem.raise_("store A and the seat disagree", "test")
        self.assertEqual(sem.state()["state"], "RAISED")
        with self.assertRaises(S.StoreError):
            sem.lower("", "test")
        sem.lower("re-derived and diffed, 54/54", "test")
        self.assertEqual(sem.state()["state"], "LOWERED")

    def test_the_whole_history_survives_lowering(self):
        sem = self.st.semaphore("s")
        sem.raise_("one", "a")
        sem.lower("done", "b")
        sem.raise_("two", "c")
        self.assertEqual(len(sem.state()["log"]), 3)


class Locking(_Tmp):
    def test_a_held_lock_blocks_a_second_consumer(self):
        slug = "s"
        lock = self.st.locks / f"{slug}.lock"
        lock.parent.mkdir(parents=True, exist_ok=True)
        lock.write_text("someone-else\n", encoding="utf-8", newline="")
        with self.assertRaises(S.SemaphoreBusy):
            self.st.append(slug, "x", frm="them", would_change="y")

    def test_a_stale_lock_is_broken_and_the_write_proceeds(self):
        slug = "s"
        lock = self.st.locks / f"{slug}.lock"
        lock.parent.mkdir(parents=True, exist_ok=True)
        lock.write_text("dead-session\n", encoding="utf-8", newline="")
        old = 1
        os.utime(lock, (old, old))          # 1970: comfortably stale
        out = self.st.append(slug, "x", frm="them", would_change="y")
        self.assertEqual(out["gen"], 1)


class TwoReaders(_Tmp):
    def test_python_and_shell_agree_on_a_good_chain(self):
        self._note(seam="s", text="one")
        self._note(seam="s", text="two")
        d = self.st.notes / "s"
        a = verify.verify_python(d)
        b = verify.verify_shell(d)
        self.assertTrue(a.ok)
        self.assertEqual(a.key(), b.key())

    def test_python_and_shell_agree_on_a_broken_chain(self):
        self._note(seam="s", text="one")
        self._note(seam="s", text="two")
        d = self.st.notes / "s"
        g1 = sorted(d.iterdir())[0]
        g1.write_text(g1.read_text(encoding="utf-8") + "x\n", newline="")
        a = verify.verify_python(d)
        b = verify.verify_shell(d)
        self.assertFalse(a.ok)
        self.assertEqual(a.key(), b.key())

    def test_a_disagreement_stops_and_picks_no_winner(self):
        """Stub one reader into lying; the Verifier must raise, not choose."""
        self._note(seam="s", text="one")
        d = self.st.notes / "s"
        v = verify.Verifier(force_both=True)
        real = verify.verify_shell
        try:
            verify.verify_shell = lambda p: verify.ChainResult(  # type: ignore
                p.name, False, 99, "made-up.md", "shell", "lying on purpose")
            with self.assertRaises(verify.ChainSplit) as cm:
                v.verify(d)
            msg = str(cm.exception)
            self.assertIn("neither", msg)
            self.assertIn("python", msg)
            self.assertIn("shell", msg)
        finally:
            verify.verify_shell = real

    def test_all_three_readers_agree_and_the_result_names_them(self):
        self._note(seam="s", text="one")
        self._note(seam="s", text="two")
        r = verify.Verifier().verify(self.st.notes / "s")
        self.assertTrue(r.ok)
        self.assertEqual(r.by, "python+shell+perl")
        self.assertIn("3 independent readers agree", r.detail)

    def test_a_forged_generation_one_is_caught(self):
        """The 2026-09-14 finding, as a regression test: an appended file
        claiming gen: 1 re-rooted a real chain and both readers said OK."""
        self._note(seam="s", text="one")
        self._note(seam="s", text="two")
        d = self.st.notes / "s"
        body = "the price is ZERO"
        name = dl2.gen_filename(3, dl2.body_sha(body))
        (d / name).write_bytes(
            f"---\nseam: s\ngen: 1\nby: attacker\nprev: \n---\n{body}\n"
            .encode())
        for impl in (verify.verify_python, verify.verify_shell, verify.verify_perl):
            r = impl(d)
            self.assertFalse(r.ok, f"{impl.__name__} accepted a forged gen 1")
            self.assertIn("C1", r.detail, impl.__name__)

    def test_tampering_with_the_head_is_caught(self):
        """No prev: pointer can ever cover the last generation, and the head is
        the only generation seat_read ever serves."""
        self._note(seam="s", text="one")
        self._note(seam="s", text="two")
        d = self.st.notes / "s"
        head = self.st.head("s")
        head.write_bytes(head.read_bytes() + b"the price is ZERO\n")
        for impl in (verify.verify_python, verify.verify_shell, verify.verify_perl):
            r = impl(d)
            self.assertFalse(r.ok, f"{impl.__name__} accepted a tampered head")
            self.assertIn("C3", r.detail, impl.__name__)

    def test_a_partial_write_is_caught(self):
        """A write that died mid-body used to parse, chain and verify."""
        self._note(seam="s", text="the list price is 200 dollars, net 30")
        head = self.st.head("s")
        raw = head.read_bytes()
        head.write_bytes(raw[:len(raw) - 12])
        for impl in (verify.verify_python, verify.verify_shell, verify.verify_perl):
            self.assertFalse(impl(self.st.notes / "s").ok, impl.__name__)

    def test_generations_are_ordered_numerically_not_lexically(self):
        """g10000 sorts before g9999 as a string."""
        d = self.st.notes / "big"
        d.mkdir(parents=True)
        for gen in (9999, 10000):
            body = f"body {gen}"
            (d / dl2.gen_filename(gen, dl2.body_sha(body))).write_bytes(
                f"---\nseam: big\ngen: {gen}\nprev: \n---\n{body}\n".encode())
        names = [p.name for p in self.st.generations("big")]
        self.assertTrue(names[0].startswith("g9999-"), names)

    def test_the_swap_uses_both_implementations_over_a_run(self):
        for i in range(6):
            self._note(seam=f"s{i}", text="x")
        v = verify.Verifier(every=9)
        used = set()
        for i in range(6):
            r = v.verify(self.st.notes / f"s{i}")
            used.add(r.by)
        # First touch of each seam cross-checks, so every result names all three.
        self.assertEqual(used, {"python+shell+perl"})
        # Second pass: now they alternate.
        used2 = {v.verify(self.st.notes / f"s{i}").by for i in range(6)}
        self.assertTrue({"python", "shell", "perl"} & used2,
                        f"expected single-reader results on re-touch, got {used2}")

    def test_one_missing_reader_is_named_and_the_rest_still_agree(self):
        self._note(seam="s", text="x")
        real = verify._SHELL
        try:
            verify._SHELL = Path("/nonexistent/dl2-verify.sh")
            r = verify.Verifier().verify(self.st.notes / "s")
            self.assertEqual(r.by, "python+perl")
            self.assertIn("2 independent readers agree", r.detail)
            self.assertIn("shell", r.detail, "the missing reader must be named")
        finally:
            verify._SHELL = real

    def test_with_no_second_reader_the_result_says_DATA_NOT_PROOF(self):
        """The state that must never be silent: one reader left, and the result
        has to say so rather than reading like a verification."""
        self._note(seam="s", text="x")
        rs, rp = verify._SHELL, verify._PERL
        try:
            verify._SHELL = Path("/nonexistent/a.sh")
            verify._PERL = Path("/nonexistent/b.pl")
            r = verify.Verifier().verify(self.st.notes / "s")
            self.assertEqual(r.by, "python")
            self.assertIn("SINGLE READER", r.detail)
            self.assertIn("DATA not proof", r.detail)
            self.assertIn("shell", r.detail)
            self.assertIn("perl", r.detail)
        finally:
            verify._SHELL, verify._PERL = rs, rp


class Links(unittest.TestCase):
    def test_bare_absolute_path_faults(self):
        found = dl2.links_in("open /f/claude/c4/h/x.md now")
        self.assertEqual(found, [("bare", "/f/claude/c4/h/x.md")])
        self.assertEqual(dl2.check_link(*found[0])[0], "FAULT")

    def test_schemes_pass(self):
        for t in ("seat:/notes/a.md", "c4:/h/MODEL.md", "ws:/skills/x"):
            k, tgt = dl2.links_in(f"see {t} here")[0]
            self.assertEqual(dl2.check_link(k, tgt)[0], "OK", t)

    def test_named_host_is_pinned_not_faulted(self):
        k, tgt = dl2.links_in("see avalon:F:/claude/c4/h/x.md")[0]
        self.assertEqual(dl2.check_link(k, tgt)[0], "PINNED")

    def test_wikilinks_and_pinned_wikilinks(self):
        got = dl2.links_in("see [[two-columns]] and [[dl2|g0001-x-y]]")
        self.assertEqual(got, [("wiki", "two-columns"), ("wiki", "dl2|g0001-x-y")])

    def test_a_schemed_link_is_not_also_counted_as_bare(self):
        got = dl2.links_in("see c4:/h/x.md")
        self.assertEqual([k for k, _ in got], ["scheme"])


class NoteFormat(unittest.TestCase):
    def test_render_parse_round_trips_to_identity(self):
        """prove-a-promise: model -> doc -> model -> doc is identity."""
        n = dl2.Note(seam="s", body="hello\n\nworld", gen=2, by="me",
                     frm="them", would_change="x", triggers=["a", "b"],
                     first_seen="g0001-x-y.md", prev="sha256:" + "a" * 64,
                     came_from=["p"], leads_to=["q"], mode="SEATED",
                     stamp="20260914T000000Z")
        d1 = dl2.render_note(n)
        n2 = dl2.parse_note(d1)
        d2 = dl2.render_note(n2)
        self.assertEqual(d1, d2)
        self.assertEqual(n2.triggers, ["a", "b"])
        self.assertEqual(n2.prev, "sha256:" + "a" * 64)

    def test_unknown_keys_survive_an_older_reader(self):
        text = dl2.render_note(dl2.Note(seam="s", body="b", frm="them",
                                        would_change="w", stamp="20260914T000000Z"))
        text = text.replace("mode: NOTVISIBLE", "mode: NOTVISIBLE\nfuture-key: 42")
        n = dl2.parse_note(text)
        self.assertEqual(n.extra["future-key"], "42")
        self.assertIn("future-key: 42", dl2.render_note(n))

    def test_verdicts_match_pocket_mentat(self):
        base = dict(seam="s", body="b", stamp="20260914T000000Z")
        self.assertEqual(dl2.Note(**base, frm="", would_change="w").verdict(),
                         "UNSOURCED")
        self.assertEqual(dl2.Note(**base, frm="them", would_change="").verdict(),
                         "UNFALSIFIABLE")
        self.assertEqual(dl2.Note(**base, frm="a source", would_change="w").verdict(),
                         "UNNAMED-SOURCE")
        self.assertEqual(dl2.Note(**base, frm="a guess", would_change="w").verdict(),
                         "GUESS")
        self.assertEqual(dl2.Note(**base, frm="them", would_change="w").verdict(),
                         "NO-TRIGGERS")
        self.assertEqual(dl2.Note(**base, frm="them", would_change="w",
                                  triggers=["t"]).verdict(), "OK")

    def test_slug_collision_is_deliberate(self):
        self.assertEqual(dl2.slugify("Two Columns"), dl2.slugify("two-columns"))


if __name__ == "__main__":
    unittest.main()
