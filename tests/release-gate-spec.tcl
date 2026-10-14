# release-gate-spec.tcl -- bin/release's prose gates and the NEWS-lag gauge, specified in Tcl.
# The work (bin/release) and its earlier tests (tests/release-gates-tests.sh) are sh; four mints
# (1.0.2-1.0.5) went out with no NEWS entry, so this spec is in a third language.
# Run by tests/release-gate-tests.sh; RELEASE names the script under test, LC1CK the licence check.
# SPEC (2026-10-10, lane C task C2, written before the code):
#   S1 "No NEWS entry and no reason line refuses the release."
#   S2 "A reason line lands in NEWS, in plain words, as that version's entry."
#   S3 "A retired bracket tag in shipped prose refuses the release; a tag quoted in backticks is a
#       mention, not a use; the reason line passes it on the record."
#   S4 "A code licence on prose in what ships refuses the release (bin/lc1ck); the reason line passes it."
#   S5 "The NEWS-lag gauge prints __version__ beside the top NEWS heading, counts minted versions
#       newer than it, and never fails."
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later

set release $env(RELEASE)
set lc1ck $env(LC1CK)
set pass 0; set fail 0
proc ok {m} { global pass; incr pass; puts "ok   $m" }
proc bad {m why} { global fail; incr fail; puts "FAIL $m -- $why" }
proc wfile {p body} { file mkdir [file dirname $p]; set f [open $p w]; puts -nonewline $f $body; close $f }
proc rfile {p} { set f [open $p r]; set s [read $f]; close $f; return $s }

# a scratch garden: bin/release + bin/lc1ck, a version, NEWS, releases/, and shipped prose
proc garden {news} {
  global release lc1ck
  set d [file join [expr {[info exists ::env(TMPDIR)] ? $::env(TMPDIR) : "/tmp"}] "rgspec.[pid].[clock clicks]"]
  file mkdir $d/bin $d/polygram $d/releases $d/dist/vibrobeast/skills/a
  file copy $release $d/bin/release
  file copy $lc1ck $d/bin/lc1ck
  wfile $d/polygram/__init__.py "__version__ = \"1.0.3\"\n"
  wfile $d/NEWS $news
  foreach r {1.0.1 1.0.2 1.0.3} { wfile $d/releases/$r "start x\n" }
  wfile $d/dist/vibrobeast/skills/a/SKILL.md "# a\n\nPlain prose.\n\nSPDX-License-Identifier: CC-BY-SA-4.0\n"
  return $d
}
proc run {d args} {
  set rc 0
  if {[catch {exec sh $d/bin/release {*}$args 2>@1} out opts]} {
    set rc [lindex [dict get $opts -errorcode] 2]
    if {$rc eq ""} { set rc 1 }
  }
  return [list $rc $out]
}
set head "polygram NEWS -- user-visible changes\n\n"
set older "Version 1.0.1 (unreleased)\n\n- older things.\n"

# S1
set d [garden "$head$older"]
lassign [run $d --prose-gates] rc out
if {$rc != 0 && [string match "*NEWS has no entry for 1.0.3*" $out]} { ok "S1 no NEWS entry and no reason line: refused, and it says why" } else { bad S1 "rc=$rc $out" }

# S2
lassign [run $d --prose-gates {--news-reason=a quiet mint to test the bridge}] rc out
set n [rfile $d/NEWS]
if {$rc == 0 && [regexp {\nVersion 1\.0\.3 \(\d{4}-\d\d-\d\d\)\n} $n]} { ok "S2 a reason line passes and writes a dated Version 1.0.3 entry" } else { bad S2a "rc=$rc $out" }
if {[string match "*by the keeper's choice*a quiet mint to test the bridge*" $n]} { ok "S2 the reason lands in NEWS in plain words" } else { bad S2b $n }
if {[string first "Version 1.0.3" $n] < [string first "Version 1.0.1" $n]} { ok "S2 the new entry sits above the older ones" } else { bad S2c $n }
lassign [run $d --prose-gates] rc out
if {$rc == 0} { ok "S2 once written, the entry satisfies the gate with no reason line" } else { bad S2d "rc=$rc $out" }

# an entry with no date after the version still counts (the old grep wanted a trailing space)
set d2 [garden "${head}Version 1.0.3\n\n- things.\n\n$older"]
lassign [run $d2 --prose-gates] rc out
if {$rc == 0} { ok "S1 a bare \"Version 1.0.3\" heading counts as the entry" } else { bad S1b "rc=$rc $out" }

# S3
wfile $d2/dist/vibrobeast/skills/a/NOTES.md "# n\n\nA reading \[MINE\] stands until he rules.\n"
lassign [run $d2 --prose-gates] rc out
if {$rc != 0 && [string match "*retired bracket tag*" $out] && [string match "*NOTES.md:3*" $out]} { ok "S3 a planted bare \[MINE\] refuses, naming file and line" } else { bad S3a "rc=$rc $out" }
lassign [run $d2 --prose-gates {--news-reason=the footer re-mint is next}] rc out
if {$rc == 0 && [string match "*retired bracket tag line(s) accepted*" $out]} { ok "S3 the reason line passes it, on the record" } else { bad S3b "rc=$rc $out" }
wfile $d2/dist/vibrobeast/skills/a/NOTES.md "# n\n\nThe old tag `\[MINE\]` is retired.\n\n```\n\[HIS\] inside a fence\n```\n"
lassign [run $d2 --prose-gates] rc out
if {$rc == 0} { ok "S3 a tag quoted in backticks or inside a code fence is a mention: passes" } else { bad S3c "rc=$rc $out" }

# S4
wfile $d2/dist/vibrobeast/skills/a/LIC.md "# l\n\nprose\n\nSPDX-License-Identifier: GPL-3.0-or-later\n"
lassign [run $d2 --prose-gates] rc out
if {$rc != 0 && [string match "*licence fault*" $out] && [string match "*LIC.md:5*" $out]} { ok "S4 a planted GPL line on a .md refuses through lc1ck, naming file and line" } else { bad S4a "rc=$rc $out" }
lassign [run $d2 --prose-gates {--news-reason=held for the re-mint}] rc out
if {$rc == 0 && [string match "*licence fault(s) accepted*" $out]} { ok "S4 the reason line passes it, on the record" } else { bad S4b "rc=$rc $out" }

# S5
set d3 [garden "$head$older"]
lassign [run $d3 --gauge] rc out
if {$rc == 0 && [string match "*__version__ is 1.0.3*top NEWS heading is 1.0.1*2 minted version(s) newer than it: 1.0.2 1.0.3*" $out]} { ok "S5 the gauge says 1.0.3 beside 1.0.1 and counts 2 newer mints" } else { bad S5a "rc=$rc $out" }
wfile $d3/NEWS "nothing here\n"
lassign [run $d3 --gauge] rc out
if {$rc == 0 && [string match "*top NEWS heading is none*" $out]} { ok "S5 with no heading at all the gauge still says, and exits 0" } else { bad S5b "rc=$rc $out" }

foreach x [list $d $d2 $d3] { file delete -force $x }
puts "TOTAL pass=$pass fail=$fail"
exit [expr {$fail == 0 ? 0 : 1}]
