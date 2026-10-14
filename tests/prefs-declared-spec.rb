#!/usr/bin/env ruby
# prefs-declared-spec.rb -- declared keys, the three prefixes, the person writer rule and the
# seatkeeper "no", specified in Ruby (extension edition, A4; cards 06 and 22, agreement 6).
#
# SPEC (written before the code):
#   D1  a key the server does not know and no skill declares is refused at pref_set, and a row
#       for it in the file is reported under ignored: (never dropped, never applied).
#   D2  a key a skill declares in its SKILL.md front matter (preferences:) is accepted, and the
#       answer names that skill as its reader.
#   D3  skill.<s>.<k> is accepted only when the skill <s> itself declares it.
#   D4  person.<name>.* for a name that is neither the keeper nor a participant he named
#       (people.named) is refused, even with a consent row's id.
#   D5  person.corwin.* from another speaker's turn is refused at pref_set, and a hand-written row
#       of that kind is ignored at read.
#   D6  person.<named>.* is accepted on that person's own turn, on the keeper's turn, or with a
#       consent row's id.
#   D7  skill.seatkeeper.<hash> takes the value "no: <path>" only when the path hashes to the key;
#       pref_list reads it back as the path, in words.
#   D8  prefs.py (Python) and bin/pr1ef (awk) classify the fixture the same, row by row.
#   D9  with usage.capture on, a person.<other>.* row never reaches the frame; a seatkeeper "no"
#       is mirrored there as one pref row.
#   D10 pref_list quotes person.* rows in words (the session-open quote).
#   D11 people.named is changed only on the keeper's own turn.
#   D12 (F1, pass 2, P5 J4) room.<tavern>.* is written on the keeper's turn, or on the turn of a
#       participant he named who is in that room's turn (room=<tavern>); a stranger's turn, a named
#       participant in another room, or one with no room given is refused.
# Why Ruby: the work is Python and awk, and the earlier preference tests were Python; Corwin's rule
# (2026-09-14) puts the new spec in a third language.
#
# usage: ruby tests/prefs-declared-spec.rb ROOT   (ROOT holds polygram/, bin/pr1ef and skills/)
#        sh tests/prefs-declared-tests.sh [--prove-red]   plants the faults this spec must catch.
# Exit 0 green, 1 red, 2 kit broken.
#
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
require "json"
require "open3"
require "tmpdir"
require "fileutils"
require "digest"

root = File.expand_path(ARGV[0] || (warn "usage: ruby prefs-declared-spec.rb ROOT"; exit 2))
fx = File.join(__dir__, "fixtures", "lane-a")
soft = File.join(fx, "declared", "soft")
$red = 0
def ok(id, what); puts("ok   #{id} #{what}"); end
def bad(id, what, why); $red += 1; puts("FAIL #{id} #{what} -- #{why}"); end
def check(id, what, cond, why); cond ? ok(id, what) : bad(id, what, why); end

# line -> what the rule says about the fixture row (see the fixture's "why" column)
WANT = { 2 => "applied", 3 => "applied", 4 => "ignored", 5 => "applied", 6 => "ignored",
         7 => "ignored", 8 => "applied", 9 => "ignored", 10 => "applied", 11 => "ignored",
         12 => "applied", 13 => "ignored", 14 => "applied", 15 => "applied", 16 => "ignored",
         17 => "ignored" }.freeze
seat_hash = ->(p) { Digest::SHA256.hexdigest(p.tr("\\", "/").sub(%r{(.)/\z}, '\1'))[0, 12] }

Dir.mktmpdir("prefs-declared") do |t|
  file = File.join(t, "prefs.tsv")
  FileUtils.cp(File.join(fx, "prefs-declared.tsv"), file)
  frame = File.join(t, "fr"); File.write(frame, "")
  env = { "MENTCACHED_PREFS" => file, "MENTCACHED_SEAT" => File.join(t, "seat"), "MENTCACHED_FRAME" => frame,
          "MENTCACHED_STATS" => "", "MENTCACHED_KEEPER" => "corwin", "PYTHONDONTWRITEBYTECODE" => "1",
          "SOFT_SKILLS" => soft }
  FileUtils.mkdir_p(File.join(t, "seat"))

  py, st = Open3.capture2e(env, "python3", "-m", "polygram.mcp.prefs", "--classify", file, chdir: root)
  (warn "kit broken: #{py}"; exit 2) unless st.success?
  dirs = [soft, File.join(root, "SOFT-SKILLS"), File.join(root, "skills")].join(":")
  aw, st = Open3.capture2e(env, "sh", File.join(root, "bin", "pr1ef"), "--file", file, "--skills", dirs,
                           "--source", File.join(root, "polygram", "mcp", "prefs.py"), "--tsv")
  (warn "kit broken: #{aw}"; exit 2) unless st.success?
  parse = ->(s) { s.lines.map { |l| l.chomp.split("\t", -1) }.reject(&:empty?) }
  pyrows, awrows = parse.(py), parse.(aw)
  got = pyrows.to_h { |r| [r[0].to_i, r[2]] }
  wrong = WANT.reject { |n, s| got[n] == s }
  check("D1-D7 read", "the server classifies all #{WANT.size} fixture rows as the rule says", wrong.empty?,
        wrong.map { |n, s| "line #{n} want #{s} got #{got[n].inspect}" }.join("; "))
  check("D8", "Python and awk agree row by row", pyrows == awrows,
        (pyrows - awrows).inspect + " vs " + (awrows - pyrows).inspect)

  drive = <<~PY
    import json, sys
    sys.path.insert(0, sys.argv[1])
    from polygram.mcp import mentcached
    srv = mentcached.build(by="ruby")
    for name, args in json.loads(sys.argv[2]):
        try:
            print(json.dumps(srv.call(name, args)))
        except Exception as e:  # a refusal is an answer here
            print(json.dumps({"error": str(e)}))
  PY
  File.write(File.join(t, "drive.py"), drive)
  h = seat_hash.("/srv/garden/far")
  calls = [
    ["pref_set", { "key" => "usage.capture", "value" => "on", "turn" => "corwin" }],            # 0
    ["pref_set", { "key" => "answers.long", "value" => "yes", "turn" => "corwin" }],            # 1 D1
    ["pref_set", { "key" => "answers.short", "value" => "no", "turn" => "corwin" }],            # 2 D2
    ["pref_set", { "key" => "skill.quiet.colour", "value" => "x", "turn" => "corwin" }],        # 3 D3
    ["pref_set", { "key" => "skill.demo.colour", "value" => "x", "turn" => "corwin" }],         # 4 D3
    ["pref_set", { "key" => "person.stranger.a", "value" => "x", "turn" => "stranger",
                   "consent" => "consent-9" }],                                                  # 5 D4
    ["pref_set", { "key" => "person.corwin.a", "value" => "x", "turn" => "bryant" }],           # 6 D5
    ["pref_set", { "key" => "person.corwin.a", "value" => "x", "turn" => "corwin" }],           # 7 D6
    ["pref_set", { "key" => "person.bryant.a", "value" => "x", "turn" => "corwin" }],           # 8 D6 D9
    ["pref_set", { "key" => "person.bryant.b", "value" => "x", "turn" => "alfred",
                   "consent" => "consent-7" }],                                                  # 9 D6
    ["pref_set", { "key" => "skill.seatkeeper.000000000000", "value" => "no: /srv/garden/far",
                   "turn" => "corwin" }],                                                        # 10 D7
    ["pref_set", { "key" => "skill.seatkeeper.#{h}", "value" => "no: /srv/garden/far",
                   "turn" => "corwin" }],                                                        # 11 D7 D9
    ["pref_set", { "key" => "people.named", "value" => "corwin, bryant, alfred", "turn" => "bryant" }], # 12 D11
    ["pref_list", {}],                                                                           # 13 D7 D10
    ["pref_set", { "key" => "room.garden.quiet", "value" => "on", "turn" => "corwin" }],        # 14 D12
    ["pref_set", { "key" => "room.garden.quiet", "value" => "on", "turn" => "stranger",
                   "room" => "garden" }],                                                        # 15 D12
    ["pref_set", { "key" => "room.garden.quiet", "value" => "off", "turn" => "bryant",
                   "room" => "garden" }],                                                        # 16 D12
    ["pref_set", { "key" => "room.garden.quiet", "value" => "off", "turn" => "bryant",
                   "room" => "other" }],                                                         # 17 D12
    ["pref_unset", { "key" => "room.garden.quiet", "turn" => "bryant" }],                       # 18 D12
  ]
  out, st = Open3.capture2e(env, "python3", File.join(t, "drive.py"), root, JSON.generate(calls))
  (warn "kit broken: #{out}"; exit 2) unless st.success?
  r = out.lines.map { |l| JSON.parse(l) }
  (warn "kit broken: #{out}"; exit 2) unless r.size == calls.size && r[0]["error"].nil?
  err = ->(i) { r[i]["error"] }
  check("D1", "an undeclared key is refused at pref_set", err.(1), r[1].inspect)
  check("D2", "a declared key is accepted and names its reader", !err.(2) && r[2]["say"].to_s.include?("demo"), r[2].inspect)
  check("D3", "skill.<s>.<k> needs <s>'s own declaration", err.(3) && !err.(4), [r[3], r[4]].inspect)
  check("D4", "an unknown person is refused, consent id or not", err.(5), r[5].inspect)
  check("D5", "person.corwin.* from another turn is refused", err.(6), r[6].inspect)
  check("D6", "own turn, the keeper's turn and a consent id are accepted", !err.(7) && !err.(8) && !err.(9),
        [r[7], r[8], r[9]].inspect)
  check("D7 write", "a seatkeeper no whose path does not hash to the key is refused; the right one lands",
        err.(10) && !err.(11), [r[10], r[11]].inspect)
  lst = r[13]
  dec = (lst["declined"] || []).find { |d| d["key"] == "skill.seatkeeper.#{h}" }
  check("D7 read-back", "pref_list reads the no back as the path, in words",
        dec && dec["path"] == "/srv/garden/far" && lst["say"].to_s.include?("/srv/garden/far"),
        "declined #{lst['declined'].inspect}")
  check("D10", "pref_list quotes person rows in words", lst["say"].to_s.include?("person.corwin.answers"),
        lst["say"].to_s[0, 200])
  rows = File.readlines(frame, chomp: true).map { |l| l.split("\t", -1) }
  keys = rows.select { |c| c[1] == "pref" }.map { |c| c[7] }
  check("D9", "a person.<other> row stays out of the frame; the seatkeeper no is mirrored",
        !keys.any? { |k| k.to_s.start_with?("person.bryant.") } && keys.include?("skill.seatkeeper.#{h}"),
        "pref rows in the frame: #{keys.inspect}")
  check("D11", "people.named changes only on the keeper's turn", err.(12), r[12].inspect)
  check("D12", "room.<tavern> rows: the keeper, or a named participant in that room; nobody else",
        !err.(14) && err.(15) && !err.(16) && err.(17) && err.(18), r[14..18].inspect)
end
if $red.zero? then puts "GREEN prefs-declared: 14/14"; exit 0 end
puts "RED prefs-declared: #{$red} failing"; exit 1
