#!/usr/bin/env ruby
# rd1ck-spec.rb RD1CK -- the Ruby runner for bin/rd1ck (the roads checker), SPEC RD1-RD5 in
# tests/lane-d-SPEC.txt. Ruby, because the work is sh+awk (a second language reads the output).
# Fixtures: tests/fixtures/lane-d/roads/ (a mount root, road tables, and two recorded outages).
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
require 'open3'
rd = ARGV[0] or abort 'usage: rd1ck-spec.rb RD1CK'
fx = File.expand_path('fixtures/lane-d/roads', __dir__)
root = File.join(fx, 'root')
$fails = 0
def check(ok, what) ; puts "  #{ok ? 'PASS' : 'FAIL'}  #{what}" ; $fails += 1 unless ok ; end
def run(rd, table, root)
  out, err, st = Open3.capture3('sh', rd, '--table', table, '--root', root, '--seat', 'the test seat', '--trace')
  [out, err, st.exitstatus]
end

out, _err, code = run(rd, File.join(fx, 'blank-road-1.md'), root)
r1 = out.lines.find { |l| l.include?('road 1 (') } || ''
r2 = out.lines.find { |l| l.include?('road 2 (') } || ''
check(r1.include?('NOT REACHED') && r2.include?('READ at notes-two/n.txt') && out.include?('served by road 2') && code == 0,
      'RD4 with road 1 blank, road 2 answers READ (the fall-through is walked)')
check(r1.include?('seat: the test seat') && r1 =~ /parent listed: \S+ \(listed\)/ && r1.include?('request:'),
      'RD3 a NOT REACHED row names the seat, the parent folder it listed and the request')

out, err, _code = run(rd, File.join(fx, 'fenced-road.md'), root)
f1 = out.lines.find { |l| l.include?('road 1 (') } || ''
touched = err.lines.select { |l| l.start_with?('touch: ') && l.include?('/c4/Z') }
check(f1.include?('FENCED') && touched.empty? && !out.include?('FENCED-ROAD-MARKER') && out.include?('served by road 2'),
      "RD2 a road under a fenced path prints FENCED and is never touched (#{touched.size} touches)")

out, _err, _code = run(rd, File.join(fx, 'outage-sync-bridge.md'), root)
check(out.lines.grep(/road [12] \(mcp/).all? { |l| l.include?('NOT REACHED') && l.include?('request: ask the session to call') } &&
      out.include?('no road here is walkable by a shell'),
      'RD3 recorded outage (sync bridge down): each tool road is NOT REACHED with its request')

out, _err, code = run(rd, File.join(fx, 'outage-folder-not-connected.md'), root)
o1 = out.lines.find { |l| l.include?('road 1 (') } || ''
check(o1.include?('NOT REACHED') && o1.include?("parent listed: #{root} (listed)") && code == 1,
      'RD3 recorded outage (folder not connected): NOT REACHED names the root it listed; exit 1')

all = Dir[File.join(fx, '*.md')].map { |t| run(rd, t, root)[0] }.join + run(rd, File.expand_path('../conventions/ROADS.md', __dir__), root)[0]
check(all !~ /absent/i && all.lines.grep(/^  road /).all? { |l| l =~ /: (READ|NOT REACHED|FENCED|READER PRESENT, NOT READ|PRESENT, NOT READ)[ ;.]/ },
      'RD1 every road prints READ, NOT REACHED, FENCED, READER PRESENT, NOT READ or PRESENT, NOT READ, and never "absent"')

# SPEC RD6 (F1, pass 2, P5 O6/J5): READ only when a fact was actually read (one line read back);
# a reader program is READER PRESENT, NOT READ and never serves the store; an empty target is
# PRESENT, NOT READ. The reader program is never run.
out, _err, code = run(rd, File.join(fx, 'reader-and-shared.md'), root)
sect = ->(name) { out.split(/^\n/).find { |b| b.start_with?("#{name} (") } || '' }
a, g, d = sect.('alpha'), sect.('gamma'), sect.('delta')
check(a.lines.find { |l| l.include?('road 1 (') }.to_s.include?('READER PRESENT, NOT READ') &&
      a.include?('READ at shared (one line read back from shared/s.txt)') && a.include?('served by road 2') &&
      g.include?('READER PRESENT, NOT READ') && !g.include?('served by') && !out.include?('READER-RAN-MARKER'),
      'RD6 a reader program is READER PRESENT, NOT READ, is never run, and never serves the store')
check(d.include?('PRESENT, NOT READ') && !d.include?('served by') && code == 1,
      'RD6 a target that gives no line back is PRESENT, NOT READ, not READ (exit 1)')
# SPEC RD7: one folder serving two stores is said as one road, not two.
check(out =~ /one road serves two stores: shared served alpha and beta/,
      'RD7 one road serving two stores is named (one unmount closes both)')

tsv, _e, _s = Open3.capture3('sh', rd, '--table', File.join(fx, 'blank-road-1.md'), '--tsv')
rows = tsv.lines.reject { |l| l.start_with?('#') }.map { |l| l.chomp.split("\t") }
check(rows.size == 2 && rows[1][0] == 'notes' && rows[1][3] == 'notes-two/n.txt' && tsv.include?('edit the Markdown, never this'),
      'RD5 the Markdown table is the source; the TSV is minted from it')
exit($fails.zero? ? 0 : 1)
