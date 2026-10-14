"""bin/ck1sk, read from a second spec in a second language (the first is its own sh self-test).

Spec: the key of a check is a function of (name, the content `git add -A` would commit, the salt) and nothing else:
  K1 committing does not change it;  K2 editing a tracked file does;  K3 adding an untracked file does;
  K4 an ignored file does not;       K5 a different name or salt does;  K6 the real index is untouched.
"""
import os, subprocess, tempfile, unittest

CK = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), 'bin', 'ck1sk')

def sh(*a, cwd, env=None):
    e = dict(os.environ, **(env or {}))
    return subprocess.run(a, cwd=cwd, env=e, capture_output=True, text=True, encoding='utf-8', check=True).stdout.strip()

class Ck1skKey(unittest.TestCase):
    def setUp(self):
        self.d = tempfile.TemporaryDirectory(); self.r = self.d.name
        for c in (['git', 'init', '-q'], ['git', 'config', 'user.email', 't@t.invalid'], ['git', 'config', 'user.name', 't']):
            sh(*c, cwd=self.r)
        open(os.path.join(self.r, 'a'), 'w', encoding='utf-8').write('one\n'); open(os.path.join(self.r, '.gitignore'), 'w', encoding='utf-8').write('junk\n')
        sh('git', 'add', '-A', cwd=self.r); sh('git', 'commit', '-qm', 'a', cwd=self.r)
    def tearDown(self): self.d.cleanup()
    def key(self, name='n', salt=''): return sh('sh', CK, 'key', name, cwd=self.r, env={'CK1SK_SALT': salt})
    def test_commit_keeps_key(self):
        open(os.path.join(self.r, 'b'), 'w', encoding='utf-8').write('two\n'); k = self.key()
        sh('git', 'add', '-A', cwd=self.r); sh('git', 'commit', '-qm', 'b', cwd=self.r)
        self.assertEqual(k, self.key())
    def test_edits_change_key(self):
        k = self.key()
        open(os.path.join(self.r, 'a'), 'w', encoding='utf-8').write('changed\n'); k2 = self.key(); self.assertNotEqual(k, k2)
        open(os.path.join(self.r, 'new'), 'w', encoding='utf-8').write('x\n'); self.assertNotEqual(k2, self.key())
    def test_ignored_and_names(self):
        k = self.key(); open(os.path.join(self.r, 'junk'), 'w', encoding='utf-8').write('noise\n'); self.assertEqual(k, self.key())
        self.assertNotEqual(k, self.key('other')); self.assertNotEqual(k, self.key(salt='py3.13'))
    def test_real_index_untouched(self):
        open(os.path.join(self.r, 'new'), 'w', encoding='utf-8').write('x\n'); self.key()
        self.assertIn('?? new', sh('git', 'status', '--porcelain', cwd=self.r))

if __name__ == '__main__':
    unittest.main()
