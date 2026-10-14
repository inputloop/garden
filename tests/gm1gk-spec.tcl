#!/usr/bin/env tclsh
# gm1gk-spec.tcl GM1GK -- the Tcl spec for bin/gm1gk's LOOK line and spelling list (F1, pass 2).
# Tcl, because the gauge is sh + awk (+ an inline python3 for pyspellchecker) and its first suite is sh.
# SPEC (written before the code; P6 O7/O8/J8):
#   G5  gm1gk stays a gauge: it exits 0 whatever it finds; when any count is not zero it prints one
#       line starting "LOOK:", and with every count zero it prints none.
#   G6  when python3 can import spellchecker, the unknown lower-case words are printed BY NAME per
#       file, minus GRAMMARY's own headwords; when it cannot, "spelling NOT CHECKED", never "clean".
# Exit 0 green, 1 red, 77 when pyspellchecker is absent for the G6 name row (NOT CHECKED).
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
set gm [lindex $argv 0]
set tmp [file join [expr {[info exists ::env(TMPDIR)] ? $::env(TMPDIR) : "/tmp"}] gm1gk-tcl-[pid]]
file mkdir $tmp
set fails 0; set skipped 0
proc check {ok what} {
  global fails
  if {[uplevel 1 [list expr $ok]]} { puts "  PASS  $what" } else { puts "  FAIL  $what"; incr fails }
}
proc put {name body} { global tmp; set f [file join $tmp $name]; set h [open $f w]; puts -nonewline $h $body; close $h; return $f }
proc run {args} {
  global gm
  set env {}; set rest {}
  foreach a $args { if {[string match *=* $a]} { lappend env $a } else { lappend rest $a } }
  set code [catch {exec env {*}$env sh $gm {*}$rest} out opts]
  if {$code} { set ec [lindex [dict get $opts -errorcode] 2]; if {$ec eq ""} { set ec 0 } } else { set ec 0 }
  return [list $ec $out]
}
set clean "# G\n\n## New words\n\n### seat\n- **What it is:** a folder that holds a seat.\n- **Whose word:** the shop's.\n"
set g  [put G.md $clean]
set g2 [put G2.md "$clean\n### planted word\n- **What it is:** no owner named.\n"]
set g3 [put G3.md "$clean\n### spell\n- **What it is:** the gardne word, and a spell.\n- **Whose word:** Corwin's.\n"]
set w  [put W.md "# words\n\n- **seat**\n"]

lassign [run GM1GK_PYTHON=/nonexistent/python3 $g $w] ec out
check {$ec == 0 && ![regexp -line {^LOOK:} $out]} "G5 every count zero: no LOOK line, exit 0"
lassign [run GM1GK_PYTHON=/nonexistent/python3 $g2 $w] ec out
check {$ec == 0 && [regexp -line {^LOOK: 1 entr} $out]} "G5 a miss prints one LOOK line, and the gauge still exits 0"
check {[string match "*spelling NOT CHECKED*pip install pyspellchecker*" $out]} "G6 no spellchecker: spelling NOT CHECKED, with the install line"

if {[catch {exec python3 -c "import spellchecker"}]} {
  puts "  NOT CHECKED  G6 the unknown words by name (no pyspellchecker here)"; set skipped 1
} else {
  lassign [run LC_ALL=C $g3 $w] ec out
  check {$ec == 0 && [regexp -line {spelling \(pyspellchecker\): 1 lower-case word\(s\) in G3.md it does not know.*: gardne$} $out]} \
    "G6 the unknown word is printed by name (gardne), per file"
  check {![regexp {: [^\n]*\mspell\M[^\n]*$} [lindex [regexp -inline -line {^gm1gk: spelling.*G3.md.*$} $out] 0]]} \
    "G6 a GRAMMARY headword (spell) is left out of the list"
  check {[regexp -line {^LOOK: .*1 spelling word} $out]} "G5 a spelling word to read prints the LOOK line"
}
# G7: --kit (the kit's gauge leg) exits 1 after a LOOK line and 0 without one: a gauge's 1 is LOOK.
lassign [run GM1GK_PYTHON=/nonexistent/python3 --kit $g2 $w] ec out
lassign [run GM1GK_PYTHON=/nonexistent/python3 --kit $g $w] ec0 out0
check {$ec == 1 && $ec0 == 0} "G7 --kit exits 1 after a LOOK line (the kit shows LOOK) and 0 with none (got $ec, $ec0)"
file delete -force $tmp
if {$fails} { exit 1 }
if {$skipped} { exit 77 }
exit 0
