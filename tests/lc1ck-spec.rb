# lc1ck-spec.rb -- the licence check, specified in Ruby (the check is sh + awk; earlier licence tests
# were sh: tests/tp2mt-tests.sh).  Run by tests/lc1ck-tests.sh; LC1CK names the tool under test.
# SPEC (2026-10-10, lane C task C1, his ruling relayed for the fold):
#   "Writing ships CC-BY-SA-4.0; a prose file never carries a code licence; CC BY 4.0 appears only
#    beside the TA model (the Technology Architecture model)."
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
require 'tmpdir'
require 'open3'

TOOL = ENV.fetch('LC1CK')
$pass = 0; $fail = 0
def ok(m) = ($pass += 1; puts "ok   #{m}")
def bad(m, why) = ($fail += 1; puts "FAIL #{m} -- #{why}")

def run(*paths)
  out, st = Open3.capture2e('sh', TOOL, *paths)
  [out, st.exitstatus]
end

V2_TOS = <<~T
  # Terms of service

  - Writing and art -- prose, books -- under Creative Commons Attribution-ShareAlike 4.0
    International (CC-BY-SA-4.0).
  - Code under GPL-3.0-or-later OR LGPL-3.0-or-later.
  - The Technology Architecture (TA) model, which is written for companies, under Creative Commons
    Attribution 4.0 International (CC-BY-4.0), without ShareAlike.
T
V1_TOS = <<~T
  # Terms of service

  - Writing -- prose, books, papers, posts, persona sheets, terms of service and privacy
    policies -- under Creative Commons Attribution 4.0 International (CC BY 4.0).
  - Software under GPL-3.0-or-later.
T

Dir.mktmpdir do |d|
  w = ->(name, body) { p = File.join(d, name); File.write(p, body); p }

  tos = w.('TERMS-OF-SERVICE.md', V2_TOS)
  out, rc = run(tos)
  rc == 0 ? ok('a v2 ToS (BY-SA for writing, CC BY 4.0 only beside the TA model) passes') : bad('v2 tos', "rc=#{rc} #{out}")

  bad_tos = w.('PRIVACY.md', V1_TOS)
  out, rc = run(bad_tos)
  (rc == 1 && out.include?('PRIVACY.md') && out =~ /CC BY 4\.0/) ?
    ok('planted: "CC BY 4.0" for writing in a scratch privacy text is a FAULT, naming the file') :
    bad('v1 tos', "rc=#{rc} #{out}")
  (out =~ /does not name CC-BY-SA-4\.0/) ? ok('a ToS or privacy text that never names BY-SA is said so') : bad('no-sa', out)

  gpl_md = w.('notes.md', "# notes\n\nSome prose.\n\nSPDX-License-Identifier: GPL-3.0-or-later\n")
  out, rc = run(gpl_md)
  (rc == 1 && out =~ /notes\.md:5/ && out =~ /code licence on prose/) ?
    ok('planted: a GPL SPDX line on a scratch .md is a FAULT, with file and line') : bad('gpl md', "rc=#{rc} #{out}")

  fenced = w.('fenced.md', "# a skill\n\n```sh\n# SPDX-License-Identifier: GPL-3.0-or-later\necho hi\n```\n\nSPDX-License-Identifier: CC-BY-SA-4.0\n")
  out, rc = run(fenced)
  rc == 0 ? ok('a code licence inside a code fence is the code\'s, not the prose\'s: passes') : bad('fenced', "rc=#{rc} #{out}")

  short = w.('SKILL.md', "# s\n\nCopyright 2026 Corwin Brust; CC-BY-SA4: https://creativecommons.org/licenses/by-sa/4.0/ (scripts GPL-3.0-or-later)\n")
  out, rc = run(short)
  (rc == 0 && out =~ /1 footer\(s\) use the short spelling CC-BY-SA4/) ?
    ok('the minted footer\'s short spelling CC-BY-SA4 passes and is counted (its re-mint is a later task)') :
    bad('short', "rc=#{rc} #{out}")

  ta = w.('ta.md', "# TA\n\nThe TA model is under CC BY 4.0.\n")
  out, rc = run(ta)
  rc == 0 ? ok('CC BY 4.0 beside the TA model passes') : bad('ta', "rc=#{rc} #{out}")

  by_footer = w.('essay.md', "# essay\n\nSome prose.\n\nSPDX-License-Identifier: CC-BY-4.0\n")
  out, rc = run(by_footer)
  (rc == 1 && out =~ /essay\.md:5/) ? ok('a prose footer saying CC-BY-4.0 (not beside the TA model) is a FAULT') : bad('by footer', "rc=#{rc} #{out}")

  code = w.('tool.sh', "#!/bin/sh\n# SPDX-License-Identifier: GPL-3.0-or-later\n")
  out, rc = run(code)
  rc == 0 ? ok('a code licence on code is fine (only prose is judged)') : bad('code', "rc=#{rc} #{out}")

  sub = File.join(d, 'tree'); Dir.mkdir(sub)
  File.write(File.join(sub, 'a.md'), "x\n\nSPDX-License-Identifier: LGPL-3.0-or-later\n")
  out, rc = run(sub)
  (rc == 1 && out.include?('a.md')) ? ok('a folder is walked: a planted LGPL line on a .md inside it is found') : bad('dir', "rc=#{rc} #{out}")

  # SPEC F1-9 (pass 2, P6 O10): book/ (the person and persona sheets) is read REPORT-ONLY: a stale
  # licence line there is listed as OWED with file and line, "re-sign owed, his pen", and never
  # changes the exit status.
  bk = File.join(d, 'book'); Dir.mkdir(bk)
  File.write(File.join(bk, 'SHEET.md'), "# a sheet\n\nWriting here is CC-BY-4.0 (his old default).\n")
  out, rc = run('--book', bk, tos)
  (rc == 0 && out =~ /^OWED +\S*SHEET\.md:3 .*re-sign owed, his pen/ && out =~ /book: 1 sheet file\(s\) read; 1 line\(s\) owed/) ?
    ok('book/ is report-only: a stale licence line in a sheet is OWED (file:line, his pen), exit unchanged') :
    bad('book', "rc=#{rc} #{out}")

  # SPEC (F3, pass 3, C5b J2): the licence written out in full is the same fault as the short form.
  # A terms text whose Licenses bullet says "Creative Commons Attribution 4.0" (no ShareAlike, no
  # "International") or "CC BY 4.0" for writing is a FAULT with file and line, even when the TERMS
  # block below it names CC-BY-SA-4.0; "Creative Commons Attribution-ShareAlike 4.0" passes.
  long_tos = File.join(d, 'long'); Dir.mkdir(long_tos)
  lt = File.join(long_tos, 'TERMS-OF-SERVICE.md')
  File.write(lt, "# Terms\n\n## Licenses\n\n- Software: GPL.\n- Writing (books, sheets, notes): Creative Commons Attribution 4.0, with an additional permission\n  to quote without credit.\n\n" + V2_TOS)
  out, rc = run(lt)
  (rc == 1 && out =~ /TERMS-OF-SERVICE\.md:6 .*CC BY 4\.0 for writing/) ?
    ok('planted: "Creative Commons Attribution 4.0" spelled out for writing in a ToS is a FAULT at its line') :
    bad('long form', "rc=#{rc} #{out}")
  st = File.join(long_tos, 'PRIVACY.md')
  File.write(st, "# Privacy\n\nThis policy is writing, under CC BY 4.0.\n\n" + V2_TOS)
  out, rc = run(st)
  (rc == 1 && out =~ /PRIVACY\.md:3 .*CC BY 4\.0 for writing/) ?
    ok('planted: "CC BY 4.0" (spaces) for writing in a privacy text is a FAULT at its line') :
    bad('short spaced form', "rc=#{rc} #{out}")
  healed = File.join(d, 'healed'); Dir.mkdir(healed)
  ht = File.join(healed, 'TERMS-OF-SERVICE.md')
  File.write(ht, "# Terms\n\n- Writing (books, sheets, notes): Creative Commons Attribution-ShareAlike 4.0 (CC BY-SA 4.0).\n")
  out, rc = run(ht)
  rc == 0 ? ok('"Creative Commons Attribution-ShareAlike 4.0" spelled out passes') : bad('healed', "rc=#{rc} #{out}")

  out, rc = run(File.join(d, 'no-such-path'))
  (rc == 2 && out =~ /NOT CHECKED/) ? ok('a path that is not there: NOT CHECKED, exit 2, never "clean"') : bad('missing', "rc=#{rc} #{out}")
end

puts "TOTAL pass=#{$pass} fail=#{$fail}"
exit($fail == 0 ? 0 : 1)
