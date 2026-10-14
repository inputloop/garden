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

"""The byte boundary: one platform is one reader.

On 2026-09-14 this suite was GREEN on GNU/Linux and FOURTEEN tests were RED on
Avalon.  I could not see it -- the mount was down, `device_bash` still is, and
I had been treating a clean container run as evidence.  It was data.

All fourteen were one fault in two flavours:

    text-mode WRITE   Python turns "\\n" into "\\r\\n" on Windows.  The worst
                      instance computed ``hashlib.sha256(b"x\\n")`` and then
                      called ``write_text("x\\n")`` -- hashing two bytes and
                      writing three.  That is not a Windows quirk.  That is a
                      test asserting about bytes it did not write, which is the
                      same family as every other finding in this tree today.

    text-mode READ    Python decodes with the LOCALE codec on Windows (cp1252),
                      so the first em-dash in a source file raised
                      UnicodeDecodeError 4205 bytes in and took an unrelated
                      test with it.

THE GUARD IS IN A THIRD LANGUAGE, per the house rule: when something gets past
the tests, add coverage with a spec and an implementation separate from both
the work under test and the prior tests.  The work is Python; the tests are
Python; so ``bin/bytes-lint.awk`` is awk.  It reads the source as text and
knows nothing about Python, which is precisely why it cannot inherit the blind
spot that let this through -- a Python checker written by the same hand would
have "known" that write_text writes what you give it.

WHAT THIS CANNOT DO, said plainly.  It is a lint, not a Windows run.  It proves
every text/bytes boundary NAMES its encoding and newline; it does not prove the
suite passes on Avalon.  Until a shell there is reachable again, a green run
here remains one reader, and the honest word for that is DATA.
"""

import shutil
import subprocess
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
LINT = ROOT / "bin" / "bytes-lint.awk"

NAIVE = '''from pathlib import Path
import subprocess
def f(p):
    s = Path(p).read_text()
    Path(p).write_text("x\\n")
    Path(p).write_text(
        "a value split "
        "across lines",
        encoding="utf-8")
    subprocess.run(["x"], text=True)
    open(p, "w").write("y")
'''

CLEAN = '''from pathlib import Path
import subprocess
def f(p):
    s = Path(p).read_text(encoding="utf-8")
    Path(p).write_text("x\\n", encoding="utf-8", newline="")
    subprocess.run(["x"], text=True, encoding="utf-8")
    open(p, "w", encoding="utf-8").write("y")
'''


@unittest.skipIf(shutil.which("awk") is None, "no awk on this host")
class EveryBoundaryNamesItsBytes(unittest.TestCase):

    def _tmp(self):
        """`TestCase.enterContext` is Python 3.11+.

        Caught by running this suite on a stock 3.10 rather than by reading it
        -- the same shape as every other finding in this file: an assumption
        about the environment that only a second environment can see. `mkdtemp`
        plus `addCleanup` is the same guarantee and works from 3.2 on.
        """
        import tempfile as _tf
        d = Path(_tf.mkdtemp(prefix="bytes-lint-"))
        self.addCleanup(shutil.rmtree, d, True)
        return d

    def _run(self, *args):
        return subprocess.run(["awk", "-f", str(LINT), *args],
                              capture_output=True, text=True,
                              encoding="utf-8", timeout=120)

    def _py_files(self):
        out = []
        for d in ("tests", "polygram"):
            out += [str(p) for p in sorted((ROOT / d).rglob("*.py"))]
        return out

    def test_the_whole_tree_is_clean(self):
        r = self._run(*self._py_files())
        self.assertEqual(
            r.returncode, 0,
            "A text/bytes boundary does not say what it means. On Windows "
            "this code handles different bytes than it does here, and a green "
            "run on GNU/Linux will not tell you.\n" + r.stderr)

    def test_the_lint_can_go_red(self, ):
        d = self._tmp()
        (d / "bad.py").write_text(NAIVE, encoding="utf-8", newline="")
        r = self._run(str(d / "bad.py"))
        self.assertEqual(r.returncode, 1, "PROVE-RED FAILED: lint stayed quiet")
        for code in ("B1", "B2", "B3", "B4"):
            self.assertIn(code, r.stderr, f"{code} never fired")

    def test_it_finds_a_call_split_across_lines(self):
        """The one a line-at-a-time checker misses, and the shape real code
        takes once a call gets long enough to wrap."""
        d = self._tmp()
        (d / "bad.py").write_text(NAIVE, encoding="utf-8", newline="")
        r = self._run(str(d / "bad.py"))
        self.assertIn(":6: B2", r.stderr,
                      "the multi-line write_text on line 6 has encoding= but "
                      "no newline=, and must still be caught")

    def test_it_stays_quiet_on_correct_code(self):
        """A lint that fires on everything says nothing."""
        d = self._tmp()
        (d / "ok.py").write_text(CLEAN, encoding="utf-8", newline="")
        r = self._run(str(d / "ok.py"))
        self.assertEqual(r.returncode, 0, r.stderr)

    def test_the_lints_own_prove_red(self):
        d = self._tmp()
        (d / "ok.py").write_text(CLEAN, encoding="utf-8", newline="")
        r = self._run("-v", "prove_red=1", str(d / "ok.py"))
        self.assertEqual(r.returncode, 0, r.stderr)
        self.assertIn("prove-red PASS", r.stdout)


class TheFixesThemselves(unittest.TestCase):
    """Named regressions for the exact call sites Avalon went red on."""

    def test_the_spaced_file_test_hashes_what_it_writes(self):
        src = (ROOT / "tests" / "test_plugin.py").read_text(encoding="utf-8")
        i = src.index("a file with spaces.txt")
        window = src[max(0, i - 400):i + 400]
        self.assertIn('newline=""', window,
                      "this test computes sha256(b'x\\n') and must therefore "
                      "write exactly those bytes; without newline='' Windows "
                      "writes three and check.sh reports CHANGED")

    def test_the_import_walk_reads_utf8(self):
        src = (ROOT / "tests" / "test_plugin.py").read_text(encoding="utf-8")
        self.assertNotIn("ast.parse(p.read_text(),", src,
                         "cp1252 raised UnicodeDecodeError on the first "
                         "em-dash and took this test out entirely")


if __name__ == "__main__":
    unittest.main()
