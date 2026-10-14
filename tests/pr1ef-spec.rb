#!/usr/bin/env ruby
# pr1ef-spec.rb -- the preferences file, read by two readers that share no code, specified in Ruby
# (extension edition, A3).
#
# SPEC: a row is reported or applied, never dropped.
#   P1  every data row of the file appears in the server's classification (prefs.py), by line
#   P2  every data row appears in bin/pr1ef's (awk) classification, by line
#   P3  the two readers agree on every row: line, key and applied / superseded / ignored
#   P4  a row with no reader is reported: pref_list lists it under ignored:, with its line, and says so
#   P5  a "(unset)" row puts the key back to its default
#   P6  pref_unset appends one row (the file only grows) and answers with the default
# Why Ruby: the silent drop and the missing pr1ef both escaped before -- the work is Python and awk,
# the earlier tests Python -- so the spec is in a language that is neither (Corwin's rule, 2026-09-14).
#
# usage: ruby tests/pr1ef-spec.rb ROOT [FIXTURE]   (ROOT holds polygram/ and bin/pr1ef)
#        sh tests/pr1ef-tests.sh [--prove-red]      is the wrapper that plants a dropped row.
# Exit 0 green, 1 red, 2 kit broken.
#
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
require "json"
require "open3"
require "tmpdir"
require "fileutils"

root = ARGV[0] or (warn "usage: ruby pr1ef-spec.rb ROOT [FIXTURE]"; exit 2)
root = File.expand_path(root)
fixture = ARGV[1] || File.join(__dir__, "fixtures", "lane-a", "prefs-mixed.tsv")
$red = 0
def ok(id, what); puts("ok   #{id} #{what}"); end
def bad(id, what, why); $red += 1; puts("FAIL #{id} #{what} -- #{why}"); end

Dir.mktmpdir("pr1ef-spec") do |t|
  file = File.join(t, "prefs.tsv")
  FileUtils.cp(fixture, file)
  env = { "MENTCACHED_PREFS" => file, "MENTCACHED_SEAT" => File.join(t, "seat"),
          "MENTCACHED_STATS" => "", "PYTHONDONTWRITEBYTECODE" => "1", "SOFT_SKILLS" => File.join(t, "none") }
  FileUtils.mkdir_p(File.join(t, "seat"))

  # Ruby's own count of data rows: every non-blank line that is not the header
  want = File.readlines(file, chomp: true).each_with_index
             .reject { |ln, i| ln.strip.empty? || (i.zero? && ln.start_with?("ts\t")) }
             .map { |_, i| i + 1 }

  py, st = Open3.capture2e(env, "python3", "-m", "polygram.mcp.prefs", "--classify", file, chdir: root)
  (warn "kit broken: #{py}"; exit 2) unless st.success?
  aw, st = Open3.capture2e(env, "sh", File.join(root, "bin", "pr1ef"), "--file", file,
                           "--source", File.join(root, "polygram", "mcp", "prefs.py"), "--tsv")
  (warn "kit broken: #{aw}"; exit 2) unless st.success?
  parse = ->(s) { s.lines.map { |l| l.chomp.split("\t", -1) }.reject(&:empty?) }
  pyrows, awrows = parse.(py), parse.(aw)

  got = pyrows.map { |r| r[0].to_i }
  got == want ? ok("P1", "the server reports all #{want.size} rows") :
    bad("P1", "the server reports every row", "lines #{(want - got).inspect} missing")
  got = awrows.map { |r| r[0].to_i }
  got == want ? ok("P2", "pr1ef reports all #{want.size} rows") :
    bad("P2", "pr1ef reports every row", "lines #{(want - got).inspect} missing")
  pyrows == awrows ? ok("P3", "Python and awk agree row by row") :
    bad("P3", "Python and awk agree row by row", "python #{pyrows.inspect} vs awk #{awrows.inspect}")

  drive = <<~PY
    import json, sys
    sys.path.insert(0, sys.argv[1])
    from polygram.mcp import mentcached
    srv = mentcached.build(by="ruby")
    for name, args in json.loads(sys.argv[2]):
        print(json.dumps(srv.call(name, args)))
  PY
  File.write(File.join(t, "drive.py"), drive)
  calls = [["pref_list", {}], ["pref_unset", { "key" => "llamabridge.on", "why" => "spec" }], ["pref_list", {}]]
  before = File.size(file)
  out, st = Open3.capture2e(env, "python3", File.join(t, "drive.py"), root, JSON.generate(calls))
  (warn "kit broken: #{out}"; exit 2) unless st.success?
  l1, un, l2 = out.lines.map { |l| JSON.parse(l) }

  unknown_lines = File.readlines(file, chomp: true).each_with_index
                      .select { |ln, _| ln.split("\t")[1] == "nobody.reads.this" }.map { |_, i| i + 1 }
  listed = (l1["ignored"] || []).map { |r| r["line"] }
  if !unknown_lines.empty? && (unknown_lines - listed).empty? && l1["say"].include?("ignored")
    ok("P4", "the row with no reader is listed under ignored: (line #{unknown_lines.join(',')}) and said")
  else
    bad("P4", "the row with no reader is listed under ignored:", "listed #{listed.inspect}; say #{l1['say'][-160..]}")
  end
  tav = l1["prefs"].find { |r| r["key"] == "tavern.on" }
  tav && tav["value"] == "off" ? ok("P5", "an (unset) row puts tavern.on back to its default") :
    bad("P5", "an (unset) row is the default", tav.inspect)
  lla = l2["prefs"].find { |r| r["key"] == "llamabridge.on" }
  if File.size(file) > before && un["value"] == "off" && lla && lla["value"] == "off" &&
     File.read(file).start_with?(File.read(fixture))
    ok("P6", "pref_unset appended one row and answered the default")
  else
    bad("P6", "pref_unset appends and answers the default", "#{un.inspect} / #{lla.inspect}")
  end
end
if $red.zero? then puts "GREEN pr1ef: 6/6"; exit 0 end
puts "RED pr1ef: #{$red} failing"; exit 1
