#!/usr/bin/env ruby
# test_boundary_secrets.rb -- the secrets check at this repo's three outbound boundaries, from Ruby
# (the boundaries are sh and make; C4's checkers are awk and Perl; their kits are Python and JavaScript).
#
# Copyright (C) 2026 Corwin Brust <corwin@bru.st>.  Authored by Mentat (for Corwin).
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU
# General Public License as published by the Free Software Foundation, either version 3 of the License,
# or (at your option) any later version.  SPDX-License-Identifier: GPL-3.0-or-later
#
# Spec (Corwin 2026-09-26: "token and secrets checks MUST occur at each state that is considered by the
# user/system as its boundary"). Each boundary stops on a secret-shaped line, names it by file, line and
# kind, never prints the secret itself, and says nothing extra when all is clean:
#   B1  skill-sign.sh bundle refuses a skill carrying a secret-shaped line; no .skill is written
#   B2  ...and bundles a clean skill with no secrets chatter on stdout
#   B3  bin/release stops at the secrets gate when a tracked file carries one
#   B4  ...and passes that gate, saying so in one line, when none does
#   B5  make dist scans before anything is minted: sb1rn is the first command of the dist recipe
#   B6  the secret is printed by none of the above
#   B7  bin/release --accept-secret=WHY passes the gate on the record; a bare --accept-secret is refused
#   B8  SKILL_SIGN_ACCEPT_SECRET=WHY bundles, and writes <name>.skill.SECRETS-ACCEPTED beside the bundle
# usage: ruby tests/test_boundary_secrets.rb [--prove-red]      needs C4 (C4_ROOT, /f/claude/c4 or ~/mnt/c4)
require 'fileutils'; require 'tmpdir'; require 'open3'; require 'digest'

HERE = File.expand_path('..', __dir__)
C4 = [ENV['C4_ROOT'], '/f/claude/c4', File.join(Dir.home, 'mnt', 'c4')].compact.find { |d| File.file?(File.join(d, 'bin', 'sb1rn')) }
abort 'SKIP: C4 (bin/sb1rn) not found' unless C4
$pass = 0; $fail = 0
def ok(msg, cond, detail = '') = (cond ? ($pass += 1; puts "ok   #{msg}") : ($fail += 1; puts "FAIL #{msg}#{detail.empty? ? '' : ' -- ' + detail}"))
def sh(cmd, dir, env = {}) = Open3.capture2e({ 'C4_ROOT' => C4 }.merge(env), *cmd, chdir: dir)
TOK = 'gh' + 'p_' + ('aB3dE5fG7hJ9kL1mN3pQ5rS7tU9vW1xY3zA5bC' * 2)[0, 36]   # built, never written whole
SIGN = File.join(HERE, 'skills', 'skill-sign', 'scripts', 'skill-sign.sh')

Dir.mktmpdir('bsec.') do |t|
  # ---- B1 / B2: skill-sign bundle ----
  %w[dirty clean].each do |n|
    d = File.join(t, 'sk', n); FileUtils.mkdir_p(d)
    File.write(File.join(d, 'SKILL.md'), "---\nname: #{n}-skill\ndescription: a test skill.\n---\n# #{n}\n")
    File.write(File.join(d, 'notes.md'), n == 'dirty' ? "line one\nkey #{TOK}\n" : "nothing here\n")
    File.write(File.join(d, '.signature.asc'), "not checked by bundle\n")
  end
  out, st = sh(['sh', SIGN, 'bundle', File.join(t, 'sk', 'dirty')], t)
  ok 'B1 a skill with a secret-shaped line is refused', !st.success? && out.include?('secret-shaped text would travel'), out
  ok 'B1 ...named by file, line and kind', out.include?('HIT dirty-skill/notes.md:2 github-token'), out
  ok 'B1 ...and no .skill is written', !File.exist?(File.join(t, 'dirty-skill.skill'))
  ok 'B6 bundle: the secret is not printed', !out.include?(TOK[4, 20])
  out, st = sh(['sh', SIGN, 'bundle', File.join(t, 'sk', 'clean')], t)
  ok 'B2 a clean skill bundles', st.success? && File.exist?(File.join(t, 'clean-skill.skill')), out
  ok 'B2 ...with no secrets chatter', !out.include?('sb:') && !out.include?('sb1rn'), out
  out, st = sh(['sh', SIGN, 'bundle', File.join(t, 'sk', 'dirty')], t, { 'SKILL_SIGN_ACCEPT_SECRET' => 'a fixture' })
  side = File.join(t, 'dirty-skill.skill.SECRETS-ACCEPTED')
  ok 'B8 SKILL_SIGN_ACCEPT_SECRET bundles and records the reason beside the bundle',
     st.success? && File.exist?(File.join(t, 'dirty-skill.skill')) && File.exist?(side) && File.read(side).include?('a fixture') && File.read(side).include?('notes.md:2 github-token'), out
  ok 'B8 ...the record never holds the secret', File.exist?(side) && !File.read(side).include?(TOK[4, 20])

  # ---- B3 / B4: bin/release on a scratch repo (never this one) ----
  if system('git --version', out: File::NULL)
    r = File.join(t, 'r'); v = '1.2.3'; top = "polygram-curation-#{v}"
    %w[bin polygram tests skills/a dist].each { |x| FileUtils.mkdir_p(File.join(r, x)) }
    FileUtils.cp(File.join(HERE, 'bin', 'release'), File.join(r, 'bin')); FileUtils.cp(File.join(HERE, 'bin', 'gtmode'), File.join(r, 'bin'))
    File.write(File.join(r, 'polygram', '__init__.py'), "__version__ = \"#{v}\"\n")
    File.write(File.join(r, 'NEWS'), "Version #{v} (2026-09-26)\n\n* a thing\n")
    File.write(File.join(r, 'tests', 'test_ok.py'), "import unittest\nclass T(unittest.TestCase):\n    def test_ok(self):\n        pass\n")
    File.write(File.join(r, '.gitignore'), "dist/\n__pycache__/\n")
    File.write(File.join(r, 'skills', 'a', 'SKILL.md'), "# a skill\n")
    mint = lambda do
      stage = File.join(t, 'stage'); FileUtils.rm_rf(stage); FileUtils.mkdir_p(File.join(stage, top, 'skills', 'a'))
      man = "# polygram dist manifest\nname: #{top}\nversion: #{v}\n\n# sha256  origin  path\n" \
            "#{Digest::SHA256.file(File.join(r, 'skills', 'a', 'SKILL.md')).hexdigest}  workspace  skills/a/SKILL.md\n"
      File.write(File.join(r, 'dist', "#{top}.MANIFEST"), man); File.write(File.join(stage, top, 'MANIFEST'), man)
      FileUtils.cp(File.join(r, 'skills', 'a', 'SKILL.md'), File.join(stage, top, 'skills', 'a'))
      system('tar', '-czf', File.join(r, 'dist', "#{top}.tar.gz"), top, chdir: stage)
      system('zip', '-qr', File.join(r, 'dist', "#{top}.zip"), top, chdir: stage)
    end
    g = ->(*a) { system('git', '-C', r, '-c', 'user.name=t', '-c', 'user.email=t@t', '-c', 'commit.gpgsign=false', *a, out: File::NULL, err: File::NULL) }
    g.('init', '-q'); mint.(); g.('add', '-A'); g.('commit', '-qm', 'one')
    out, st = sh(['sh', 'bin/release', v], r)
    ok 'B4 a clean tree passes the secrets gate, in one line', out.include?('GATE   ok  no secret-shaped text in the tracked files (sb1rn)'), out
    File.write(File.join(r, 'polygram', 'cfg.py'), "# settings\nGH = '#{TOK}'\n"); g.('add', '-A'); g.('commit', '-qm', 'two')
    out, st = sh(['sh', 'bin/release', v], r)
    ok 'B3 a tracked secret-shaped line stops the release', !st.success? && out.include?('secret-shaped text in what the tag would publish'), out
    ok 'B3 ...named by file, line and kind', out.include?('HIT polygram/cfg.py:2 github-token'), out
    ok 'B3 ...before the tests gate runs', !out.include?('running the Python tests'), out
    ok 'B6 release: the secret is not printed', !out.include?(TOK[4, 20])
    out, st = sh(['sh', 'bin/release', v, '--accept-secret=a public test fixture'], r)
    ok 'B7 --accept-secret=WHY passes the secrets gate, on the record', out.include?('GATE   --  secret-shaped text accepted: a public test fixture (recorded in the tag message)') && !out.include?('secret-shaped text in what the tag would publish'), out
    out, st = sh(['sh', 'bin/release', v, '--accept-secret'], r)
    ok 'B7 ...a bare --accept-secret (no reason) is refused', !st.success? && out.include?('needs a reason'), out
  else
    puts 'SKIP: no git for B3/B4'
  end

  # ---- B5: make dist, read rather than run (a real dist mints and signs) ----
  mk = File.read(File.join(HERE, 'Makefile'), encoding: 'UTF-8'); recipe = mk[/^dist:\n((?:\t.*\n)+)/, 1].to_s
  first = recipe.lines.map(&:strip).reject { |l| l.start_with?('@#') }.first.to_s
  ok 'B5 the first command of make dist is the sb1rn scan', first.include?('sb1rn') && recipe.index('sb1rn') < recipe.index('rl2bp start'), first
  ok 'B5 ...and a hit stops the build (exit 1)', recipe[/sb1rn[^\n]*\n[^\n]*exit 1/m] ? true : false

  if ARGV.include?('--prove-red')
    before = $fail; ok 'PLANTED: must fail', false
    puts($fail > before ? 'PASS: harness went red' : 'FAIL: could not go red')
    # the deeper proof: a skill-sign whose scan is cut out must fail B1
    cut = File.join(t, 'skill-sign-cut.sh'); File.write(cut, File.read(SIGN, encoding: 'UTF-8').sub('if [ -n "$sbrn" ]; then', 'if false; then'))
    FileUtils.cp(File.join(File.dirname(SIGN), 'check.sh'), t) rescue nil
    o, s = sh(['sh', cut, 'bundle', File.join(t, 'sk', 'dirty')], t)
    red = s.success?   # the cut copy bundles the secret: exactly what B1 exists to catch
    puts((red ? 'PASS' : 'FAIL') + ': a skill-sign with its scan cut out bundles the secret, which B1 would catch')
    exit($fail == before + 1 && red ? 0 : 1)
  end
end
puts "TOTAL pass=#{$pass} fail=#{$fail}"; exit($fail.zero? ? 0 : 1)
