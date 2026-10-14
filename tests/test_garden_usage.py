"""garden-usage: whatis.sh says what a thing is, in one sentence, from what the garden already knows.

Copyright (C) 2026 Corwin Brust <corwin@bru.st>.  Authored by Mentat (for Corwin).
SPDX-License-Identifier: GPL-3.0-or-later  (or, at your option, any later version)
Run: python3 -m unittest tests.test_garden_usage
"""
import json, os, shutil, subprocess, tempfile, unittest

HERE = os.path.dirname(os.path.abspath(__file__))
SKILL = os.path.join(os.path.dirname(HERE), 'skills', 'garden-usage')


def skill_md(name, desc, block=False):
    d = ('description: >-\n  ' + desc) if block else ('description: ' + desc)
    return '---\nname: %s\n%s\n---\n# %s\n' % (name, d, name)


class WhatIs(unittest.TestCase):
    def setUp(self):
        self.t = tempfile.mkdtemp(prefix='gu.')
        self.skills = os.path.join(self.t, 'skills'); os.makedirs(self.skills)
        shutil.copytree(SKILL, os.path.join(self.skills, 'garden-usage'))
        for n, d, b in (('eclipse-pass', 'Stress-test a claim until the weak parts break. More text.', True),
                        ('usage', 'A skill that happens to be named usage.', False)):
            os.makedirs(os.path.join(self.skills, n))
            with open(os.path.join(self.skills, n, 'SKILL.md'), 'w', encoding='utf-8') as f: f.write(skill_md(n, d, b))
        self.c4 = os.path.join(self.t, 'c4'); os.makedirs(os.path.join(self.c4, 'c'))
        os.makedirs(os.path.join(self.c4, 'Z', 'chat', 'IDEA'))
        with open(os.path.join(self.c4, 'c', 'skillnames'), 'w', encoding='utf-8') as f:
            f.write('# header\neclipse-pass\tkeep-the-losers\tstress-test-claims\tmoon-bite\n')
        with open(os.path.join(self.c4, 'c', 'names'), 'w', encoding='utf-8') as f:
            f.write('usage\tus1ct\tbin/us1ct\treal token usage, grouped by skill\n')
        with open(os.path.join(self.c4, 'Z', 'chat', 'IDEA', 'i-0001'), 'w', encoding='utf-8') as f:
            f.write('An idea that names should be readable by strangers.\n\nsource: x 00\n')

    def tearDown(self):
        shutil.rmtree(self.t, ignore_errors=True)

    def run_(self, *a, c4=True):
        env = dict(os.environ, GARDEN_SKILLS=self.skills, C4_ROOT=self.c4 if c4 else os.path.join(self.t, 'none'),
                   GARDEN_SOFT=os.path.join(self.t, 'SOFT-SKILLS'))
        p = subprocess.run(['sh', os.path.join(self.skills, 'garden-usage', 'scripts', 'whatis.sh')] + list(a),
                           capture_output=True, text=True, encoding='utf-8', env=env)
        return p.returncode, p.stdout + p.stderr

    def test_pet_name_resolves_to_its_skill_with_the_first_sentence(self):
        rc, out = self.run_('moon-bite')
        self.assertEqual(rc, 0, out)
        self.assertIn('label eclipse-pass', out)
        self.assertIn('Stress-test a claim until the weak parts break.', out)
        self.assertNotIn('More text', out, 'more than the first sentence was given')

    def test_a_tool_by_its_coded_name(self):
        rc, out = self.run_('us1ct')
        self.assertIn('is a TOOL', out); self.assertIn('What it does: real token usage', out)

    def test_a_word_with_two_meanings_is_a_seam_not_a_choice(self):
        rc, out = self.run_('usage')
        self.assertIn('SEAM: "usage" means 2 things', out)
        self.assertIn('is a SKILL', out); self.assertIn('is a TOOL', out)

    def test_an_entity_by_its_file_name(self):
        rc, out = self.run_('i-0001')
        self.assertIn('is an ENTITY (IDEA). An idea that names should be readable by strangers.', out)

    def test_unknown_names_the_closest_and_exits_1(self):
        rc, out = self.run_('moonbit')
        self.assertEqual(rc, 1); self.assertIn('not known here', out); self.assertIn('moon-bite', out)

    def test_json_is_valid(self):
        rc, out = self.run_('moon-bite', '--json')
        d = json.loads(out); self.assertEqual(d['meanings'][0]['name'], 'eclipse-pass')

    def test_a_simple_install_with_no_c4_still_answers_for_installed_skills(self):
        rc, out = self.run_('eclipse-pass', c4=False)
        self.assertEqual(rc, 0, out); self.assertIn('Stress-test a claim', out)
        rc, out = self.run_('moon-bite', c4=False)
        self.assertEqual(rc, 1, 'a pet name should not resolve without the register')

    def test_a_soft_skill_is_answered_with_the_line_that_reads_it(self):
        # ERRATA E3 (2026-09-29): garden-usage did not route to soft skills.
        d = os.path.join(self.t, 'SOFT-SKILLS', 'build-loop'); os.makedirs(d)
        with open(os.path.join(d, 'SKILL.md'), 'w', encoding='utf-8') as f: f.write(skill_md('build-loop', 'A counted build discipline. More.', True))
        rc, out = self.run_('build-loop', c4=False)
        self.assertEqual(rc, 0, out); self.assertIn('is a SOFT SKILL', out)
        self.assertIn('soft_skill_read build-loop', out); self.assertIn('A counted build discipline.', out)
        rc, out = self.run_('--list', c4=False)
        self.assertIn('(soft) A counted build discipline.', out)
        os.makedirs(os.path.join(self.skills, 'build-loop'))
        with open(os.path.join(self.skills, 'build-loop', 'SKILL.md'), 'w', encoding='utf-8') as f: f.write(skill_md('build-loop', 'Installed now.'))
        rc, out = self.run_('build-loop', c4=False)
        self.assertNotIn('soft_skill_read', out, 'an installed skill is not sent to the soft reader')

    def test_the_soft_roots_without_garden_soft(self):
        # M2's mutants (2026-09-29): each fallback root is found when GARDEN_SOFT is not set
        def mk(root, n):
            d = os.path.join(root, n); os.makedirs(d)
            with open(os.path.join(d, 'SKILL.md'), 'w', encoding='utf-8') as f: f.write(skill_md(n, 'Soft %s. More.' % n))
        home = os.path.join(self.t, 'home'); env0 = dict(os.environ, GARDEN_SKILLS=self.skills, C4_ROOT=os.path.join(self.t, 'none'), HOME=home)
        for k in ('GARDEN_SOFT', 'SOFT_SKILLS', 'MENTCACHED_SEAT'): env0.pop(k, None)
        mk(os.path.join(self.t, 'envsoft'), 'via-env'); mk(os.path.join(home, '.mentcached', 'SOFT-SKILLS'), 'via-home')
        mk(os.path.join(self.t, 'seatdir', 'SOFT-SKILLS'), 'via-seat'); mk(os.path.join(self.t, 'SOFT-SKILLS'), 'via-beside')
        env = dict(env0, SOFT_SKILLS=os.path.join(self.t, 'envsoft'), MENTCACHED_SEAT=os.path.join(self.t, 'seatdir', 'seat'))
        for n in ('via-env', 'via-home', 'via-seat', 'via-beside'):
            p = subprocess.run(['sh', os.path.join(self.skills, 'garden-usage', 'scripts', 'whatis.sh'), n],
                               capture_output=True, text=True, encoding='utf-8', env=env)
            self.assertIn('soft_skill_read ' + n, p.stdout, n + ': ' + p.stdout + p.stderr)

    def test_list(self):
        rc, out = self.run_('--list')
        self.assertIn('eclipse-pass', out); self.assertIn('garden-usage', out)


if __name__ == '__main__':
    unittest.main()
