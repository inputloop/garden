# Copyright (C) 2026 Corwin Brust <corwin@bru.st>
# Authored by Mentat (for Corwin).
# SPDX-License-Identifier: GPL-3.0-or-later
# This file is part of polygram.  polygram is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.  It is
# distributed WITHOUT ANY WARRANTY; see <https://www.gnu.org/licenses/>.
"""Tests for the dist (archive minting) pipeline and local externs."""

import hashlib
import shutil
import subprocess
import tarfile
import tempfile
import unittest
import zipfile
from pathlib import Path

from polygram import dist
from polygram.externs import Extern, Manifest


def _make_skill(root: Path, name: str, *, with_tool: bool = True) -> Path:
    d = root / name
    d.mkdir(parents=True)
    (d / "SKILL.md").write_text(f"---\nname: {name}\n---\n# {name}\n",
                                encoding="utf-8", newline="")
    if with_tool:
        (d / "tool.py").write_text("print('hi')\n", encoding="utf-8", newline="")
    return d


class TestDiscoverCollect(unittest.TestCase):
    def setUp(self):
        self.tmp = Path(tempfile.mkdtemp())
        self.ws = self.tmp / "ws_skills"
        self.inst = self.tmp / "installed"
        self.ws.mkdir()
        self.inst.mkdir()

    def test_discover_skips_non_skill_and_dotdirs(self):
        _make_skill(self.ws, "alpha")
        (self.ws / "not-a-skill").mkdir()        # no SKILL.md
        (self.ws / ".hidden").mkdir()
        found = dist.discover(self.ws, "workspace")
        self.assertEqual([s.name for s in found], ["alpha"])

    def test_collect_family_filter(self):
        _make_skill(self.ws, "color-theory")
        _make_skill(self.inst, "mentat-skill")   # in family
        _make_skill(self.inst, "docx")           # NOT in family
        skills = dist.collect(self.ws, [self.inst], family_only=True)
        names = {s.name for s in skills}
        self.assertIn("mentat-skill", names)
        self.assertNotIn("docx", names)
        self.assertIn("color-theory", names)

    def test_collect_all_installed(self):
        _make_skill(self.inst, "docx")
        skills = dist.collect(self.ws, [self.inst], family_only=False)
        self.assertIn("docx", {s.name for s in skills})

    def test_collect_sources_only_skips_workspace(self):
        # red before 2026-09-11: the workspace skill always rode along
        _make_skill(self.ws, "color-theory")
        _make_skill(self.inst, "mentat-skill")
        skills = dist.collect(self.ws, [self.inst], family_only=True,
                              include_workspace=False)
        self.assertEqual([s.name for s in skills], ["mentat-skill"])

    def test_collect_only_names_scopes_every_root(self):
        _make_skill(self.ws, "color-theory")
        _make_skill(self.ws, "posix")
        _make_skill(self.inst, "mentat-skill")
        _make_skill(self.inst, "docx")           # not family, but named
        skills = dist.collect(self.ws, [self.inst], family_only=True,
                              names=("posix", "docx"))
        self.assertEqual([s.name for s in skills], ["docx", "posix"])

    def test_collect_default_unchanged(self):
        _make_skill(self.ws, "color-theory")
        _make_skill(self.inst, "mentat-skill")
        self.assertEqual([s.name for s in dist.collect(self.ws, [self.inst])],
                         ["color-theory", "mentat-skill"])

    def test_workspace_wins_collision(self):
        _make_skill(self.ws, "sandboxer")        # also a family name
        _make_skill(self.inst, "sandboxer")
        skills = dist.collect(self.ws, [self.inst], family_only=True)
        match = [s for s in skills if s.name == "sandboxer"]
        self.assertEqual(len(match), 1)
        self.assertEqual(match[0].origin, "workspace")


class TestMint(unittest.TestCase):
    def setUp(self):
        self.tmp = Path(tempfile.mkdtemp())
        self.ws = self.tmp / "skills"
        self.ws.mkdir()
        _make_skill(self.ws, "alpha")
        _make_skill(self.ws, "beta")
        self.skills = dist.collect(self.ws)
        self.out = self.tmp / "dist"

    def test_mint_both_formats(self):
        r = dist.mint(self.out, self.skills, name="curation", version="9.9")
        names = {a.name for a in r.artifacts}
        self.assertEqual(names, {"curation-9.9.tar.gz", "curation-9.9.zip"})
        for a in r.artifacts:
            self.assertTrue(a.is_file())
            self.assertIn(a.name, r.checksums)
        self.assertTrue(r.manifest.is_file())

    def test_archive_layout_and_manifest(self):
        r = dist.mint(self.out, self.skills, name="curation", version="9.9")
        tgz = self.out / "curation-9.9.tar.gz"
        with tarfile.open(tgz) as tar:
            members = tar.getnames()
        self.assertIn("curation-9.9/MANIFEST", members)
        self.assertIn("curation-9.9/skills/alpha/SKILL.md", members)
        zf = self.out / "curation-9.9.zip"
        with zipfile.ZipFile(zf) as z:
            self.assertIn("curation-9.9/skills/beta/tool.py", z.namelist())
        # manifest carries a sha256 per packaged file
        self.assertIn("skills/alpha/SKILL.md", r.checksums)
        self.assertEqual(len(r.checksums["skills/alpha/SKILL.md"]), 64)

    def test_single_format(self):
        r = dist.mint(self.out, self.skills, version="1", formats=("zip",))
        self.assertEqual([a.suffix for a in r.artifacts], [".zip"])

    def test_empty_raises(self):
        with self.assertRaises(ValueError):
            dist.mint(self.out, [], version="1")

    def test_bad_format_raises(self):
        with self.assertRaises(ValueError):
            dist.mint(self.out, self.skills, formats=("rar",))

    def test_record_advice(self):
        r = dist.mint(self.out, self.skills, name="curation", version="9.9")
        advice_dir = self.tmp / "advice"
        p = dist.record_advice(advice_dir, r)
        self.assertTrue(p.is_file())
        text = p.read_text(encoding="utf-8")
        self.assertIn("Dist mint: curation-9.9", text)
        self.assertIn("alpha", text)


class TestLocalExtern(unittest.TestCase):
    def setUp(self):
        self.tmp = Path(tempfile.mkdtemp())
        self.externs_dir = self.tmp / "externs"
        self.externs_dir.mkdir()

    def _manifest_with_local(self):
        m = Manifest(self.tmp / "externs.json")
        e = m.add("savane", "")
        e.kind = "local"
        e.frozen = True
        return m, e

    def test_local_snapshot_ok(self):
        m, _ = self._manifest_with_local()
        snap = self.externs_dir / "savane"
        snap.mkdir()
        (snap / "forensics.md").write_text("note\n", encoding="utf-8", newline="")
        problems = m.reconcile(self.externs_dir)
        self.assertEqual(problems, [])

    def test_local_missing_dir_flagged(self):
        m, _ = self._manifest_with_local()
        problems = m.reconcile(self.externs_dir)
        self.assertTrue(any("savane" in p for p in problems))

    def test_local_never_synced(self):
        from polygram.externs import sync
        _, e = self._manifest_with_local()
        state, _detail = sync(e, self.externs_dir)
        self.assertEqual(state, "local")

    def test_kind_roundtrips_through_save_load(self):
        m, _ = self._manifest_with_local()
        m.save()
        m2 = Manifest.load(m.path)
        self.assertEqual(m2.get("savane").kind, "local")


if __name__ == "__main__":
    unittest.main()


class TestSkillBundles(unittest.TestCase):
    def setUp(self):
        self.tmp = Path(tempfile.mkdtemp())
        self.ws = self.tmp / "skills"
        self.ws.mkdir()
        d = _make_skill(self.ws, "gamma")
        # plant cruft that must NOT ship
        (d / "#SKILL.md#").write_text("autosave\n", encoding="utf-8", newline="")
        (d / "SKILL.md~").write_text("backup\n", encoding="utf-8", newline="")
        (d / "scratch.tmp").write_text("tmp\n", encoding="utf-8", newline="")
        (d / "__pycache__").mkdir()
        (d / "__pycache__" / "x.pyc").write_text("bytecode\n", encoding="utf-8", newline="")
        # sed -i mkstemp stray (the 0.5.3 mint residue) + editor residue
        (d / "sedx44W4d").write_text("stray\n", encoding="utf-8", newline="")
        (d / ".SKILL.md.swp").write_text("vimswap\n", encoding="utf-8", newline="")
        (d / ".#SKILL.md").write_text("lock\n", encoding="utf-8", newline="")
        # legit content that must survive the stray filter
        (d / "sediments").write_text("keep me\n", encoding="utf-8", newline="")
        self.skills = dist.collect(self.ws)
        self.out = self.tmp / "dist"

    def test_skill_bundle_folder_rooted_and_clean(self):
        r = dist.mint(self.out, self.skills, version="1", formats=("skill",))
        self.assertEqual([b.name for b in r.bundles], ["gamma.skill"])
        with zipfile.ZipFile(r.bundles[0]) as z:
            names = z.namelist()
        self.assertIn("gamma/SKILL.md", names)            # folder-rooted
        self.assertIn("gamma/tool.py", names)
        # cruft excluded
        self.assertFalse(any("#SKILL.md#" in n for n in names))
        self.assertFalse(any(n.endswith("~") for n in names))
        self.assertFalse(any(n.endswith(".tmp") for n in names))
        self.assertFalse(any("__pycache__" in n or n.endswith(".pyc")
                             for n in names))

    def test_tmp_strays_excluded_real_words_kept(self):
        r = dist.mint(self.out, self.skills, version="1", formats=("skill",))
        with zipfile.ZipFile(r.bundles[0]) as z:
            names = z.namelist()
        self.assertFalse(any(n.endswith("sedx44W4d") for n in names))
        self.assertFalse(any(n.endswith(".swp") for n in names))
        self.assertFalse(any(".#" in n for n in names))
        self.assertIn("gamma/sediments", names)  # no false positive

    def test_rel_is_posix_and_mixed_sep_tolerant(self):
        base = self.tmp / "skills" / "gamma"
        self.assertEqual(dist._rel(base / "SKILL.md", base), "SKILL.md")
        self.assertEqual(dist._rel(base / "sub" / "x.py", base), "sub/x.py")
        # backslashes never survive into arcnames/manifest paths
        self.assertNotIn("\\", dist._rel(base / "sub" / "x.py", base))

    def test_is_tmp_stray_unit(self):
        self.assertTrue(dist._is_tmp_stray("sedx44W4d"))
        self.assertTrue(dist._is_tmp_stray("sedAB12cd"))
        self.assertTrue(dist._is_tmp_stray(".README.md.swp"))
        self.assertTrue(dist._is_tmp_stray(".#SKILL.md"))
        self.assertFalse(dist._is_tmp_stray("sediments"))   # all-lower word
        self.assertFalse(dist._is_tmp_stray("sedation"))    # wrong length
        self.assertFalse(dist._is_tmp_stray("SKILL.md"))
        self.assertFalse(dist._is_tmp_stray("sed"))

    def test_skill_bundle_checksum_recorded(self):
        r = dist.mint(self.out, self.skills, version="1", formats=("skill",))
        self.assertEqual(len(r.checksums["gamma.skill"]), 64)

    def test_a_retired_skills_old_bundle_is_moved_aside_not_left_installable(self):
        # 2026-09-25: shell-tooling.skill sat in dist/ after the skill left the rack.
        self.out.mkdir(parents=True, exist_ok=True)
        (self.out / "retired-one.skill").write_bytes(b"old")
        r = dist.mint(self.out, self.skills, version="1", formats=("skill",))
        self.assertFalse((self.out / "retired-one.skill").exists())
        self.assertTrue((self.out / ".retired-bundles" / "retired-one.skill").exists())
        self.assertEqual([p.name for p in r.retired], ["retired-one.skill"])
        self.assertTrue((self.out / "gamma.skill").exists())   # the rack's own bundle stays

    def test_a_second_retirement_of_the_same_name_keeps_both(self):
        self.out.mkdir(parents=True, exist_ok=True)
        (self.out / ".retired-bundles").mkdir()
        (self.out / ".retired-bundles" / "retired-one.skill").write_bytes(b"older")
        (self.out / "retired-one.skill").write_bytes(b"old")
        r = dist.mint(self.out, self.skills, version="1", formats=("skill",))
        kept = sorted(p.name for p in (self.out / ".retired-bundles").iterdir())
        self.assertEqual(len(kept), 2, kept)
        self.assertEqual((self.out / ".retired-bundles" / "retired-one.skill").read_bytes(), b"older")

    def test_format_all_yields_three_kinds(self):
        r = dist.mint(self.out, self.skills, name="c", version="2",
                      formats=dist.ALL_FORMATS)
        suffixes = sorted(a.suffix for a in r.artifacts)
        self.assertEqual(suffixes, [".gz", ".zip"])
        self.assertEqual([b.suffix for b in r.bundles], [".skill"])


class TestHexNoiseGuard(unittest.TestCase):
    """ffcc00-style hex tokens scraped from externs must never be candidates."""

    def _note(self, tmp, name, body):
        p = tmp / f"{name}.md"
        p.write_text(body, encoding="utf-8", newline="")
        from polygram import memory
        return memory.parse_note(p)

    def test_hex_token_excluded(self):
        from polygram import memory
        tmp = Path(tempfile.mkdtemp())
        notes = [
            self._note(tmp, "a", "# A\nstyle fill #ffcc00 here\n"),
            self._note(tmp, "b", "# B\nanother #ffcc00 mention\n"),
        ]
        cands = memory.candidates(notes, threshold=2)
        self.assertNotIn("ffcc00", [c.label for c in cands])

    def test_real_letter_word_kept(self):
        from polygram import memory
        tmp = Path(tempfile.mkdtemp())
        # 'facade' is 6 hex letters but has no digit -> must NOT be treated as noise
        notes = [
            self._note(tmp, "a", "# A\nthe #facade pattern\n"),
            self._note(tmp, "b", "# B\nmore #facade\n"),
        ]
        cands = memory.candidates(notes, threshold=2)
        self.assertIn("facade", [c.label for c in cands])


class TestExternCandidateScope(unittest.TestCase):
    """#50: externs feed candidates only via their own memory/ notes."""

    def _ws(self):
        from polygram import config
        root = Path(tempfile.mkdtemp())
        ws = config.Workspace(root).ensure()
        return ws

    def test_arbitrary_extern_docs_do_not_surface(self):
        from polygram import review
        from polygram.externs import Manifest
        ws = self._ws()
        ext = ws.externs / "thirdparty"
        (ext / "docs").mkdir(parents=True)
        # two stray docs carrying a repeated tag, like a cloned repo's diagrams
        (ext / "docs" / "a.md").write_text("# A\nstyle fill #beaded thing\n", encoding="utf-8", newline="")
        (ext / "README.md").write_text("# R\nanother #beaded mention\n", encoding="utf-8", newline="")
        items = review.build(ws, Manifest(ws.externs_manifest), threshold=2)
        self.assertNotIn("beaded", [it.candidate.label for it in items])

    def test_extern_memory_notes_still_surface_and_annotate(self):
        from polygram import review
        from polygram.externs import Manifest
        ws = self._ws()
        ext = ws.externs / "upstream"
        (ext / "memory").mkdir(parents=True)
        (ext / "memory" / "n.md").write_text(
            "# Real upstream skill :SKILL:\nnotes #upstreamthing\n", encoding="utf-8", newline="")
        m = Manifest(ws.externs_manifest); m.add("upstream", "http://x/u.git"); m.save()
        items = review.build(ws, m, threshold=2)
        labels = [it.candidate.label for it in items]
        self.assertIn("upstreamthing", labels)
        it = review.find(items, "upstreamthing")
        self.assertIsNotNone(it.extern)
        self.assertEqual(it.extern.name, "upstream")


class TestDistVersionAlias(unittest.TestCase):
    """dist --version is an alias for --dist-version (scoped, not global)."""

    def test_alias_parses(self):
        from polygram import cli
        args = cli.build_parser().parse_args(["dist", "--version", "0.5.4"])
        self.assertEqual(args.dist_version, "0.5.4")

    def test_long_flag_still_works(self):
        from polygram import cli
        args = cli.build_parser().parse_args(["dist", "--dist-version", "9"])
        self.assertEqual(args.dist_version, "9")

    def test_global_version_untouched(self):
        from polygram import cli, __version__
        import io, contextlib
        buf = io.StringIO()
        with contextlib.redirect_stdout(buf), self.assertRaises(SystemExit) as cm:
            cli.build_parser().parse_args(["--version"])
        self.assertEqual(cm.exception.code, 0)
        self.assertIn(__version__, buf.getvalue())


class TestDefaultSkillsSource(unittest.TestCase):
    """#47: dist falls back to $POLYGRAM_SKILLS_SOURCE when no flag is given."""

    def test_env_fallback_parsed(self):
        import os
        from polygram import cli
        old = os.environ.get("POLYGRAM_SKILLS_SOURCE")
        try:
            os.environ["POLYGRAM_SKILLS_SOURCE"] = os.pathsep.join(["/a/skills", "/b/skills"])
            self.assertEqual(cli._default_skills_sources(), ["/a/skills", "/b/skills"])
            os.environ["POLYGRAM_SKILLS_SOURCE"] = ""
            self.assertEqual(cli._default_skills_sources(), [])
        finally:
            if old is None:
                os.environ.pop("POLYGRAM_SKILLS_SOURCE", None)
            else:
                os.environ["POLYGRAM_SKILLS_SOURCE"] = old


class TestSkillBundleManifestAndTemplate(unittest.TestCase):
    """2026-09-04 (PMO #184/#185): every .skill bundle carries a hash-only
    manifest, not only the aggregate archives -- and the check.sh/SAYS-SO
    bundle template, when present, rides along too. See dist.py's module
    docstring and skill-sign.sh's tiered `verify`.
    """

    def setUp(self):
        self.tmp = Path(tempfile.mkdtemp())
        self.ws = self.tmp / "skills"
        self.ws.mkdir()
        self.out = self.tmp / "dist"

    def test_unsigned_skill_gets_synthesized_manifest_no_signature(self):
        _make_skill(self.ws, "delta")
        skills = dist.collect(self.ws)
        r = dist.mint(self.out, skills, version="1", formats=("skill",))
        with zipfile.ZipFile(r.bundles[0]) as z:
            names = z.namelist()
            man_text = z.read("delta/.skill-manifest").decode("utf-8")
        self.assertIn("delta/.skill-manifest", names)
        self.assertNotIn("delta/.signature.asc", names)
        # every staged file has an entry: sorted, "sha256  ./path" lines
        lines = man_text.splitlines()
        self.assertTrue(lines, "manifest must not be empty")
        for ln in lines:
            digest, _, path = ln.partition("  ")
            self.assertEqual(len(digest), 64)
            self.assertTrue(path.startswith("./"))
        self.assertEqual(lines, sorted(lines))
        self.assertIn("./SKILL.md", man_text)
        self.assertIn("./tool.py", man_text)

    def test_manifest_hashes_match_plain_sha256(self):
        d = _make_skill(self.ws, "epsilon")
        skills = dist.collect(self.ws)
        r = dist.mint(self.out, skills, version="1", formats=("skill",))
        with zipfile.ZipFile(r.bundles[0]) as z:
            man_text = z.read("epsilon/.skill-manifest").decode("utf-8")
        entries = {}
        for ln in man_text.splitlines():
            h, _, p = ln.partition("  ")
            entries[p] = h
        # tool.py is hashed as raw bytes -- must match a plain sha256
        expect = hashlib.sha256((d / "tool.py").read_bytes()).hexdigest()
        self.assertEqual(entries["./tool.py"], expect)

    def test_skill_md_canonicalization_matches_awk_reference(self):
        """Cross-check dist.py's python canonicalization against
        skill-sign.sh's own awk implementation -- same file in, same hash
        out, or a later `skill-sign.sh sign` would disagree with a mint
        that never touched the content (prove-a-promise round trip)."""
        if shutil.which("awk") is None:
            self.skipTest("no awk on PATH")
        d = self.ws / "zeta"
        d.mkdir()
        # trailing whitespace, CRLF, and trailing blank lines -- exactly
        # what canonicalization exists to strip
        (d / "SKILL.md").write_bytes(b"---\r\nname: zeta   \r\n---\r\n# zeta\t\n\n\n")
        skills = dist.collect(self.ws)
        [skill] = skills
        canon = dist._canonical_skill_md_bytes(skill.path / "SKILL.md")
        awk_prog = (
            '{ sub(/\\r$/, ""); sub(/[ \\t]+$/, ""); a[NR] = $0 }'
            ' END { n = NR; while (n > 0 && a[n] == "") n--;'
            ' for (i = 1; i <= n; i++) print a[i] }'
        )
        awk_out = subprocess.run(
            ["awk", awk_prog, str(d / "SKILL.md")],
            capture_output=True, check=True,
        ).stdout
        self.assertEqual(canon, awk_out)

    def test_already_signed_skill_manifest_untouched(self):
        """A skill with a real (gpg-backed) .skill-manifest on disk must
        ride through the bundle byte-for-byte -- dist.py never overwrites
        someone's signature-covered manifest with its own synthesized
        one."""
        d = _make_skill(self.ws, "eta")
        original = (
            "deadbeef" * 8 + "  ./SKILL.md\n" + "cafebabe" * 8 + "  ./tool.py\n"
        )
        (d / ".skill-manifest").write_text(original, encoding="utf-8", newline="")
        (d / ".signature.asc").write_text(
            "-----BEGIN PGP SIGNATURE-----\nstub\n", encoding="utf-8", newline="")
        skills = dist.collect(self.ws)
        r = dist.mint(self.out, skills, version="1", formats=("skill",))
        with zipfile.ZipFile(r.bundles[0]) as z:
            names = z.namelist()
            man_text = z.read("eta/.skill-manifest").decode("utf-8")
            sig_text = z.read("eta/.signature.asc").decode("utf-8")
        self.assertIn("eta/.skill-manifest", names)
        self.assertIn("eta/.signature.asc", names)
        self.assertEqual(man_text, original)  # untouched, not resynthesized
        self.assertEqual(sig_text, "-----BEGIN PGP SIGNATURE-----\nstub\n")

    def test_bundle_carries_check_sh_and_says_so_template(self):
        _make_skill(self.ws, "theta")
        skills = dist.collect(self.ws)
        r = dist.mint(self.out, skills, version="1", formats=("skill",))
        with zipfile.ZipFile(r.bundles[0]) as z:
            names = z.namelist()
        # only true if the real template exists in this checkout -- it
        # does (skills/skill-sign/scripts/check.sh + SAYS-SO) -- so assert
        # it rode along rather than silently accepting its absence.
        self.assertTrue(
            dist._TEMPLATE_DIR.is_dir(),
            "expected skills/skill-sign/scripts to exist in this checkout",
        )
        self.assertIn("theta/check.sh", names)
        self.assertIn("theta/SAYS-SO", names)

    def test_template_never_clobbers_skill_owned_files(self):
        d = _make_skill(self.ws, "iota")
        (d / "check.sh").write_text("#!/bin/sh\necho mine\n", encoding="utf-8", newline="")
        skills = dist.collect(self.ws)
        r = dist.mint(self.out, skills, version="1", formats=("skill",))
        with zipfile.ZipFile(r.bundles[0]) as z:
            check_text = z.read("iota/check.sh").decode("utf-8")
        self.assertIn("echo mine", check_text)

    def test_cold_unpack_check_sh_passes_clean_then_goes_red(self):
        """House proof: unpack a minted, UNSIGNED bundle into an empty dir
        with nothing from the source tree in scope, run check.sh cold --
        clean passes, a corrupted byte goes red. Same proof check.sh's own
        --prove-red makes, exercised here from outside the tool."""
        if shutil.which("sh") is None:
            self.skipTest("no sh on PATH")
        _make_skill(self.ws, "kappa")
        skills = dist.collect(self.ws)
        r = dist.mint(self.out, skills, version="1", formats=("skill",))

        cold = self.tmp / "cold-unpack"
        cold.mkdir()
        with zipfile.ZipFile(r.bundles[0]) as z:
            z.extractall(cold)
        skilldir = cold / "kappa"
        self.assertTrue((skilldir / "check.sh").is_file())
        self.assertTrue((skilldir / ".skill-manifest").is_file())
        self.assertFalse((skilldir / ".signature.asc").exists())

        clean = subprocess.run(
            ["sh", "check.sh"], cwd=skilldir, capture_output=True, text=True, encoding="utf-8"
        )
        self.assertEqual(clean.returncode, 0, clean.stdout + clean.stderr)
        self.assertIn("OK       ./SKILL.md", clean.stdout)
        self.assertIn("OK       ./tool.py", clean.stdout)
        # the one 64-hex summary line
        hexlines = [
            ln for ln in clean.stdout.splitlines()
            if len(ln) == 64 and all(c in "0123456789abcdef" for c in ln)
        ]
        self.assertEqual(len(hexlines), 1)

        with open(skilldir / "tool.py", "a", encoding="utf-8") as f:
            f.write("# corrupted\n")
        red = subprocess.run(
            ["sh", "check.sh"], cwd=skilldir, capture_output=True, text=True, encoding="utf-8"
        )
        self.assertNotEqual(red.returncode, 0)
        self.assertIn("CHANGED  ./tool.py", red.stdout)

    def test_check_sh_prove_red_self_test(self):
        """check.sh's own --prove-red, run against a real signed skill in
        this checkout (eclipse-pass) via a scratch copy -- per
        prove-red-discipline: every harness ships a way to demonstrate
        itself going red."""
        if shutil.which("sh") is None:
            self.skipTest("no sh on PATH")
        repo = Path(__file__).resolve().parents[1]
        source = repo / "skills" / "eclipse-pass"
        if not (source / ".skill-manifest").is_file():
            self.skipTest("skills/eclipse-pass is not signed in this checkout")
        scratch = self.tmp / "prove-red-scratch"
        shutil.copytree(source, scratch)
        shutil.copy(dist._TEMPLATE_DIR / "check.sh", scratch / "check.sh")
        r = subprocess.run(
            ["sh", "check.sh", "--prove-red"], cwd=scratch,
            capture_output=True, text=True, encoding="utf-8",
        )
        self.assertEqual(r.returncode, 0, r.stdout + r.stderr)
        self.assertIn("PASS:", r.stdout)
