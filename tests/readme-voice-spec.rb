# readme-voice-spec.rb -- the minted README opens plain, names the partners once, and unpacks its
# terms before it leans on them.  The work is Python (polygram/plugin.py) and its README tests are
# Python and awk (tests/test_plugin.py, tests/readme-count-spec.awk), so this spec is Ruby.
# usage: ruby readme-voice-spec.rb README.md
# SPEC (turn 2, lane T, 2026-10-10; Corwin, 08:10: in a long document "we can work our voices in
#       gradually and in drops and dabs over the body of the work as the context grows less general"):
#   R1 "Before the first '## ' heading, the README names Corwin Brust and Bryant Frankford in one
#       paragraph with the word together, and says what the plugin is in its first sentence."
#   R2 "The phrase 'the author' appears nowhere (the two partners are named, not distanced)."
#   R3 "MCP and stdio are each unpacked in bold (**MCP**, **stdio**) before any other use of the word."
#   R4 "No retired bracket tag, no 'the instrument', no mid-text 'Mentat (for Corwin'."
#   R5 "A quotation of Corwin's in the body names him on the same or the line before."
# Prints ok/FAIL rows and TOTAL; exit 1 on any FAIL.  Reads only.
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
$pass = 0; $fail = 0
def ok(m) = ($pass += 1; puts "ok   #{m}")
def bad(m) = ($fail += 1; puts "FAIL #{m}")
lines = File.read(ARGV[0], encoding: "utf-8").lines.map(&:chomp)
head = lines.take_while { |l| !l.start_with?("## ") }
paras = head.join("\n").split(/\n\s*\n/)
if paras.any? { |p| p.include?("Corwin Brust") && p.include?("Bryant Frankford") && p.include?("together") } &&
   (paras.find { |p| !p.start_with?("#") } || "").start_with?("vibrobeast is a plugin")
  ok "R1 the opening says what it is, then names both partners, together"
else bad "R1 the opening does not say what it is and name Corwin Brust and Bryant Frankford together" end
hits = lines.each_index.select { |i| lines[i].downcase.include?("the author") }
hits.empty? ? ok("R2 'the author' nowhere") : bad("R2 'the author' at line(s) #{hits.map { |i| i + 1 }.join(',')}")
%w[MCP stdio].each do |w|
  first = lines.index { |l| l =~ /\b#{w}\b/ }
  if first && lines[first].include?("**#{w}**") && lines[first].index("**#{w}**") <= lines[first].index(w) - 2
    ok "R3 #{w} is unpacked at its first use (line #{first + 1})"
  else bad "R3 #{w}'s first use (line #{first ? first + 1 : '-'}) is not its bold unpacking" end
end
fence = false; dev = []
lines.each_with_index do |l, i|
  if l =~ /^\s*(```|~~~)/ then fence = !fence; next end
  next if fence
  t = l.gsub(/`[^`]*`/, "")
  dev << i + 1 if t =~ /\[(HIS|DOMAIN|SKILL|PLATFORM|MINE)\]/ || t.downcase.include?("the instrument") ||
                 (t.include?("Mentat (for Corwin") && i < lines.size - 8)
end
dev.empty? ? ok("R4 no tag, no 'the instrument', no mid-text byline") : bad("R4 a device at line(s) #{dev.join(',')}")
qs = lines.each_index.select { |i| lines[i] =~ /(?<!\*)\*"[^"]+"\*(?!\*)/ }
unnamed = qs.reject { |i| lines[i].include?("Corwin") || (i > 0 && lines[i - 1].include?("Corwin")) }
if qs.empty? then bad "R5 no quotation of Corwin's in the body"
elsif unnamed.empty? then ok "R5 #{qs.size} quotation(s), each named"
else bad "R5 unnamed quotation at line(s) #{unnamed.map { |i| i + 1 }.join(',')}" end
puts "TOTAL pass=#{$pass} fail=#{$fail}"
exit($fail > 0 ? 1 : 0)
