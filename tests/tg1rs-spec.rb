#!/usr/bin/env ruby
# tg1rs-spec.rb -- the C4QL tag resolver against tests/tg1rs-SPEC.txt (T1-T11), in Ruby, a second
# language beside the tool's sh+awk.  usage: ruby tests/tg1rs-spec.rb   (TG1RS_BIN overrides the tool)
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
require 'tmpdir'
require 'fileutils'
require 'open3'

here = File.expand_path('..', __dir__)
bin = ENV['TG1RS_BIN'] || File.join(here, 'bin', 'tg1rs')
$pass = 0; $fail = 0
def ck(name, cond, got = nil)
  if cond then $pass += 1; puts "ok   #{name}"
  else $fail += 1; puts "FAIL #{name}#{got ? " -- got: #{got.inspect}" : ''}" end
end

Dir.mktmpdir do |t|
  w = ->(rel, text) { p = File.join(t, rel); FileUtils.mkdir_p(File.dirname(p)); File.write(p, text) }
  w.('casts.tsv', [
    "# cast\ttable\tkey\tkind\tby",
    "gloss\t#{t}/gloss.tsv\t1:2:3\ttsv\t6",
    "tag\t#{t}/tags\t2\twords\t-",
    "note\tseat:notes\t-\tstore\t-",
    "mem\t#{t}/mem\t-\tfile\t-",
    "via\tcast:gloss\t-\tindirect\t-",
    "loop1\tcast:loop2\t-\tindirect\t-",
    "loop2\tcast:loop1\t-\tindirect\t-",
    "lost\t#{t}/nowhere.tsv\t1\ttsv\t-",
    "both\tcorwin bryant\t-\talias\t-",
    "known\tbryant corwin mentat\t-\tnames\t-",
    "h1\tcast:h2\t-\tindirect\t-", "h2\tcast:h3\t-\tindirect\t-", "h3\tcast:h4\t-\tindirect\t-",
    "h4\tcast:h5\t-\tindirect\t-", "h5\tcast:gloss\t-\tindirect\t-"].join("\n") + "\n")
  w.('gloss.tsv', "TABLE\tLETTER\tCOL\tWORD\tKIND\tSOURCE\n" \
     "m/g\tA\t1\tATOM\tstaple\tbryant\nm/g\tA\t2\tACCORD\tstaple\tboth\nm/g\tA\t3\tAPPEND\tstretched\tcorwin\nm/g\tB\t1\tBRIDGE\tstaple\tthe s1 notes\n")
  w.('tags', "A ÆTHERNET\nG GAUNTLET\n")
  w.('mem/foo.md', "---\nname: foo\nby: corwin\n---\nbody names bryant\n")
  w.('J/bryant/g0001-aaaa.md', "---\nseam: bryant\nleads-to: [[m/g:A:1]] [[m/g:A:3|g0002-x]]\n---\nbody [[m/g:A:2]]\n")
  w.('J/corwin/g0001-bbbb.md', "---\nseam: corwin\nleads-to: [[gloss:m/g:A:2]]\n---\n")
  w.('J/mentat/g0001-cccc.md', "---\nseam: mentat\nleads-to: [[two-columns]]\n---\n")
  w.('seat/notes/two-columns/g0001-dddd.md', "---\nseam: two-columns\ncame-from: [[persona:mentat|g0001-cccc.md]]\n---\nx\n")
  w.('seat/notes/solo/g0001-eeee.md', "---\nseam: solo\ncame-from: \n---\nx\n")
  w.('seat/cited/solo.log', "20261010T000000Z\tvibrobeast\there\n")
  w.('doc.md', "See [bryant (gloss)m/g:A:1] and [not a tag] and [mentat (nosuch)q].\n")
  env = { 'TG1RS_CASTS' => "#{t}/casts.tsv", 'TG1RS_JOURNALS' => "#{t}/J", 'MENTCACHED_SEAT' => "#{t}/seat" }
  run = ->(*args) { o, e, s = Open3.capture3(env, 'sh', bin, *args); [o, e, s.exitstatus] }
  ans = ->(tag) { o, = run.('resolve', tag); r = o.lines.reject { |l| l.start_with?('#') }.first.to_s.chomp.split("\t", -1); r }
  a = ->(tag) { ans.(tag)[0] }

  ck 'T7 LINKED: by column and journal both name the row', a.('[bryant (gloss)m/g:A:1]') == 'LINKED', ans.('[bryant (gloss)m/g:A:1]')
  ck 'T5/T6 alias "both" plus a cast-prefixed back link', a.('[corwin (gloss)m/g:A:2]') == 'LINKED', ans.('[corwin (gloss)m/g:A:2]')
  ck 'T7 FORWARD-ONLY (a body link is not leads-to)', a.('[bryant (gloss)m/g:A:2]') == 'FORWARD-ONLY', ans.('[bryant (gloss)m/g:A:2]')
  ck 'T7 BACK-ONLY with a |gen pin', a.('[bryant (gloss)m/g:A:3]') == 'BACK-ONLY', ans.('[bryant (gloss)m/g:A:3]')
  r = ans.('[mentat (gloss)m/g:A:1]')
  ck 'T7 GAP: row found, no link either way', r[0] == 'GAP' && r[4].include?('no link'), r
  r = ans.('[bryant (gloss)m/g:Z:9]')
  ck 'T4 GAP: no such row, names the table', r[0] == 'GAP' && r[4].include?('gloss.tsv'), r
  r = ans.('[bryant (nosuch)x]')
  ck 'T2 WORD: unknown cast, tag kept verbatim', r[0] == 'WORD' && r[4].include?('[bryant (nosuch)x]'), r
  ck 'T3 WORD: indirection past 4 hops', a.('[bryant (loop1)x]') == 'WORD', ans.('[bryant (loop1)x]')
  ck 'T3 four hops resolve', a.('[bryant (h2)m/g:A:1]') == 'LINKED', ans.('[bryant (h2)m/g:A:1]')
  ck 'T3 five hops answer WORD', a.('[bryant (h1)m/g:A:1]') == 'WORD', ans.('[bryant (h1)m/g:A:1]')
  ck 'T3 one indirect hop resolves', a.('[bryant (via)m/g:A:1]') == 'LINKED', ans.('[bryant (via)m/g:A:1]')
  r = ans.('[bryant (lost)x]')
  ck 'T4 GAP: table not reachable', r[0] == 'GAP' && r[4].include?('nowhere.tsv'), r
  ck 'T1 persona is case-blind', a.('[Bryant (gloss)m/g:A:1]') == 'LINKED', ans.('[Bryant (gloss)m/g:A:1]')
  ck 'T5/T6 store: came-from and journal', a.('[mentat (note)two-columns]') == 'LINKED', ans.('[mentat (note)two-columns]')
  ck 'T6 store: cited log is a back link', a.('[vibrobeast (note)solo]') == 'BACK-ONLY', ans.('[vibrobeast (note)solo]')
  ck 'T4 words table, key case-blind, no by column', a.('[mentat (tag)gauntlet]') == 'GAP', ans.('[mentat (tag)gauntlet]')
  ck 'T5 file kind: front-matter by', a.('[corwin (mem)foo]') == 'FORWARD-ONLY', ans.('[corwin (mem)foo]')
  r = ans.('[bryant (gloss)m/g:A:1]')
  ck 'T11 five tab-separated fields', r.length == 5, r
  o, _, s = run.('persona', 'bryant')
  rows = o.lines.reject { |l| l.start_with?('#') }
  ck 'T8 persona walk finds the leads-to facts', s == 0 && rows.size == 2 && rows.any? { |l| l.start_with?("LINKED\tbryant\t") } && rows.any? { |l| l.start_with?("BACK-ONLY\tbryant\t") }, o
  o, _, s = run.('scan', "#{t}/doc.md")
  rows = o.lines.reject { |l| l.start_with?('#') }
  ck 'T9 scan finds two tags and leaves other brackets alone', s == 0 && rows.size == 2 && rows[0].start_with?('LINKED') && rows[1].start_with?('WORD'), o
  o, _, s = run.('sweep')
  ck 'T10 sweep prints its counts in words', s == 0 && o =~ /^# counts: .*LINKED/, o
  ck 'T10 sweep takes only known persons from a prose column', !o.lines.any? { |l| l.split("\t")[1] == 'the' || l.split("\t")[1] == 's1' } && o.lines.any? { |l| l.start_with?("LINKED\tbryant\tgloss\tm/g:A:1") }, o
  before = Dir.glob("#{t}/**/*").map { |f| [f, File.mtime(f)] }.sort
  run.('sweep')
  ck 'T11 nothing written', Dir.glob("#{t}/**/*").map { |f| [f, File.mtime(f)] }.sort == before
end
puts "TOTAL pass=#{$pass} fail=#{$fail}"
exit($fail.zero? ? 0 : 1)
