"""skill-sign: leave a current signature alone, and say so only where it was asked for.

Copyright (C) 2026 Corwin Brust <corwin@bru.st>.  Authored by Mentat (for Corwin).
SPDX-License-Identifier: GPL-3.0-or-later  (or, at your option, any later version)

Corwin, 2026-09-26: "avoid resign when the signature is the newest asset ... when invoking over
several paths ... we ought avoid extra messaging unless the build was (or shop is) gauged to as to
require it, a call for signing a single skill is a stronger signal we want a message when we did no
work."  Written in Python against a shell tool: a second language checks the first.
Run: python3 -m unittest tests.test_skill_sign_noop   (skips cleanly with no gpg on PATH)
"""
import hashlib, os, shutil, subprocess, tempfile, time, unittest

HERE = os.path.dirname(os.path.abspath(__file__))
TOOL = os.path.join(os.path.dirname(HERE), 'skills', 'skill-sign', 'scripts', 'skill-sign.sh')

SKILL = """---
name: {n}
description: >-
  A small skill used only to test signing. Use it when a test needs a signable skill with a
  valid description and nothing else.
---
# {n}

Body text.
"""


def sha(p):
    return hashlib.sha256(open(p, 'rb').read()).hexdigest()


@unittest.skipUnless(shutil.which('gpg') and shutil.which('sha256sum'), 'needs gpg and sha256sum')
class SignNoop(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.t = tempfile.mkdtemp(prefix='ssn.')
        cls.env = dict(os.environ, GNUPGHOME=os.path.join(cls.t, 'g'))
        cls.env.pop('SKILL_SIGN_VERBOSE', None)
        os.makedirs(cls.env['GNUPGHOME'], mode=0o700)
        subprocess.run(['gpg', '--batch', '--pinentry-mode', 'loopback', '--passphrase', '',
                        '--quick-gen-key', 'T <t@t>', 'ed25519', 'sign', 'never'],
                       env=cls.env, capture_output=True, check=True)
        out = subprocess.run(['gpg', '--list-secret-keys', '--with-colons'], env=cls.env,
                             capture_output=True, text=True, encoding='utf-8').stdout
        cls.env['PUB_SIGN_KEY'] = [l.split(':')[9] for l in out.splitlines() if l.startswith('fpr')][0]

    @classmethod
    def tearDownClass(cls):
        shutil.rmtree(cls.t, ignore_errors=True)

    def skill(self, n):
        d = os.path.join(self.t, n); os.makedirs(d, exist_ok=True)
        open(os.path.join(d, 'SKILL.md'), 'w', encoding='utf-8').write(SKILL.format(n=n))
        return d

    def sign(self, *dirs, env=None):
        e = dict(self.env, **(env or {}))
        p = subprocess.run(['sh', TOOL, 'sign'] + list(dirs), env=e, capture_output=True, text=True, encoding='utf-8')
        return p.returncode, p.stdout + p.stderr

    def test_1_single_current_skill_says_so_and_keeps_the_signature(self):
        d = self.skill('s-one')
        rc, out = self.sign(d); self.assertEqual(rc, 0, out); self.assertIn('signed', out)
        before = sha(os.path.join(d, '.signature.asc'))
        time.sleep(1.1)
        rc, out = self.sign(d)
        self.assertEqual(rc, 0, out)
        self.assertIn('already signed and current -- the signature is newer than every file', out)
        self.assertEqual(before, sha(os.path.join(d, '.signature.asc')), 'a current signature was remade')

    def test_2_touched_not_edited_is_current(self):
        d = self.skill('s-touch'); self.sign(d)
        time.sleep(1.1); os.utime(os.path.join(d, 'SKILL.md'))        # newer than the signature, same bytes
        rc, out = self.sign(d)
        self.assertIn('touched, not edited', out)

    def test_3_an_edit_is_signed(self):
        d = self.skill('s-edit'); self.sign(d)
        before = sha(os.path.join(d, '.signature.asc'))
        time.sleep(1.1); open(os.path.join(d, 'SKILL.md'), 'a', encoding='utf-8').write('More.\n')
        rc, out = self.sign(d)
        self.assertEqual(rc, 0, out); self.assertIn(': signed', out)
        self.assertNotEqual(before, sha(os.path.join(d, '.signature.asc')))

    def test_4_a_sweep_is_quiet_about_no_ops_and_counts_them(self):
        a, b = self.skill('s-a'), self.skill('s-b'); self.sign(a); self.sign(b)
        time.sleep(1.1)
        rc, out = self.sign(a, b)
        self.assertNotIn('already signed and current --', out)
        self.assertIn('2 already signed and current; nothing to do for them', out)

    def test_5_a_gauged_shop_hears_every_no_op(self):
        a, b = self.skill('s-c'), self.skill('s-d'); self.sign(a); self.sign(b)
        rc, out = self.sign(a, b, env={'SKILL_SIGN_VERBOSE': '1'})
        self.assertEqual(out.count('already signed and current --'), 2, out)

    def test_6_force_re_signs(self):
        d = self.skill('s-force'); self.sign(d)
        p = subprocess.run(['sh', TOOL, 'sign', '-f', d], env=self.env, capture_output=True, text=True, encoding='utf-8')
        self.assertIn(': signed', p.stdout + p.stderr)

    def test_7_a_signature_that_does_not_verify_is_not_current(self):
        d = self.skill('s-bad'); self.sign(d)
        open(os.path.join(d, '.skill-manifest'), 'a', encoding='utf-8').write('tampered\n')   # sig no longer verifies
        time.sleep(1.1); os.utime(os.path.join(d, '.signature.asc'))
        rc, out = self.sign(d)
        self.assertIn(': signed', out, 'a signature that fails to verify was treated as current')


if __name__ == '__main__':
    unittest.main()
