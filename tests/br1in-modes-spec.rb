#!/usr/bin/env ruby
# br1in-modes-spec.rb BR1IN -- the "modes of work" lines br1in extracts, against fixtures shaped like
# the four C6 found wrong (review pass 3, C6 section d).  The work is sh + awk and br1in's other tests
# are sh and Ruby; the fault got past them, so this spec is new (Corwin, 2026-09-14: a fault that got
# past the tests earns a new spec).  Run by tests/br1in-modes-tests.sh; needs zip and sha256sum.
# SPEC (F3, pass 3, C6 d):
#   BM1 "A quoted trigger is a quote, not two apostrophes: an apostrophe inside a word (agent's,
#        Bryant's, can't) never opens or closes one."
#   BM2 "'the run' matches as words: a heading 'What the runner does NOT need to cover' is not a loop,
#        and a heading 'The run' still is."
#   BM3 "The title heading (the one '# ' line) is not a gate, a loop or a hand-back; a '## Hard gates'
#        heading still is a gate."
#   BM4 "The description's trigger sentence ends at '. ' or at the end, not at the dot inside a name
#        such as index.php."
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
require 'tmpdir'
require 'open3'
require 'fileutils'

br1in = ARGV[0] or abort 'usage: br1in-modes-spec.rb BR1IN'
fixd = File.expand_path('fixtures/lane-d/br1in', __dir__)
$pass = 0; $fail = 0
def ok(m) = ($pass += 1; puts "ok   #{m}")
def bad(m, why) = ($fail += 1; puts "FAIL #{m} -- #{why}")

SKILLS = {
  'parallax' => ["Read another agent's gardens, and when another agent's work arrives, say 'look twice' before Bryant's merge.",
                 "## The run\n\nBody.\n\n## Hard gates\n\nBody.\n"],
  'aetherflow-runner' => ['Run aetherflow rules.',
                          "## What the runner does NOT need to cover\n\nBody.\n\n## Two hard boundaries\n\nBody.\n"],
  'connector-forge' => ["Use when a connector can't authenticate -- Cloudflare 403 or 'token expired' appears.",
                        "## Steps\n\nBody.\n"],
  'aethernet-relay' => ['Operate the relay. Use when deploying index.php or reading relay errors. Not the client.',
                        "## Hand-back\n\nBody.\n"],
}
TITLES = { 'aetherflow-runner' => 'aetherflow-runner -- the seam that makes rules run' }

Dir.mktmpdir('br1in-modes') do |d|
  w = File.join(d, 'w', 'pack', 'skills'); FileUtils.mkdir_p(w)
  SKILLS.each do |n, (desc, body)|
    FileUtils.mkdir_p(File.join(w, n))
    File.write(File.join(w, n, 'SKILL.md'),
               "---\nname: #{n}\ndescription: #{desc}\n---\n\n# #{TITLES.fetch(n, n)}\n\n#{body}")
  end
  drop = File.join(d, 'from', '2026-02-01'); FileUtils.mkdir_p(drop)
  pk = File.join(d, 'w', 'pack')
  sums = Dir.glob('**/*', base: pk).select { |f| File.file?(File.join(pk, f)) }.sort.map do |f|
    o, = Open3.capture2('sha256sum', File.join(pk, f)); "#{o.split.first}  #{f}\n"
  end
  File.write(File.join(pk, 'SHA256SUMS'), sums.join)
  system('zip', '-q', '-r', '-X', File.join(drop, 'pack-2026-02-01.zip'), 'pack', chdir: File.join(d, 'w')) or abort 'zip failed'
  o, = Open3.capture2('sha256sum', 'pack-2026-02-01.zip', chdir: drop)
  File.write(File.join(drop, 'SHA256SUMS'), o)
  out = File.join(d, 'out')
  log, st = Open3.capture2e('sh', br1in, '--no-also', '--counterparts', File.join(fixd, 'counterparts.tsv'),
                            '--ours', File.join(fixd, 'ours', 'skills'), '--out', out, drop)
  md = File.join(out, '2026-02-01.md')
  unless File.file?(md)
    bad('br1in ran', "rc=#{st.exitstatus} #{log[0, 400]}"); puts "TOTAL pass=#{$pass} fail=#{$fail}"; exit 1
  end
  sec = {}
  cur = nil
  File.foreach(md) do |l|
    if l =~ /^### (\S+) \(/ then cur = $1; sec[cur] = []
    elsif cur && l.start_with?('- extracted, not judged: ') then sec[cur] << l.sub('- extracted, not judged: ', '').chomp
    elsif l.start_with?('#') then cur = nil
    end
  end
  q = ->(n) { (sec[n] || []).find { |x| x.start_with?('trigger (quoted') } || '' }
  loops = ->(n) { (sec[n] || []).find { |x| x.start_with?('loop (headings)') } || '' }
  gates = ->(n) { (sec[n] || []).find { |x| x.start_with?('gates (headings)') } || '' }
  all = ->(n) { (sec[n] || []).join(' / ') }

  (q.('parallax') == "trigger (quoted in the description): 'look twice'") ?
    ok("BM1 parallax: the one quote is found; agent's / Bryant's pair nothing") : bad('BM1 parallax', q.('parallax').inspect)
  (q.('connector-forge') == "trigger (quoted in the description): 'token expired'") ?
    ok("BM1 connector-forge: can't opens no quote") : bad('BM1 connector-forge', q.('connector-forge').inspect)
  (!loops.('aetherflow-runner').include?('runner')) ?
    ok("BM2 'What the runner does NOT need to cover' is not a loop") : bad('BM2 runner', loops.('aetherflow-runner').inspect)
  (loops.('parallax').include?('The run')) ?
    ok("BM2 a 'The run' heading is still a loop") : bad('BM2 the run', loops.('parallax').inspect)
  (!all.('aetherflow-runner').include?('the seam that makes rules run')) ?
    ok('BM3 the title heading is not a gate, loop or hand-back') : bad('BM3 title', all.('aetherflow-runner').inspect)
  (gates.('parallax').include?('Hard gates')) ?
    ok("BM3 a '## Hard gates' heading is still a gate") : bad('BM3 gates', gates.('parallax').inspect)
  (all.('aethernet-relay').include?('trigger (description): Use when deploying index.php or reading relay errors') &&
   !all.('aethernet-relay').include?('Not the client')) ?
    ok('BM4 the trigger sentence runs past index.php and stops at ". "') : bad('BM4 index.php', all.('aethernet-relay').inspect)
end
puts "TOTAL pass=#{$pass} fail=#{$fail}"
exit($fail.zero? ? 0 : 1)
