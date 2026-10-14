#!/usr/bin/env ruby
# br1in-noedit-spec.rb BR1IN FIXROOT -- SPEC BR1 (tests/lane-d-SPEC.txt): br1in never writes into a drop.
# Snapshots every file and folder under FIXROOT/from (path, size, mtime, sha256), runs br1in twice
# (a normal run with --out outside, and a run with --out inside the drop, which must be refused
# with exit 3), snapshots again and compares. Written in Ruby because the work is sh+awk and the
# other br1in tests are sh (a second language catches what the first one shares with the work).
# Authored by Mentat (for Corwin; claude-opus-5-5).
# Copyright (C) 2026 Corwin Brust <corwin@bru.st> and Contributors.
# SPDX-License-Identifier: GPL-3.0-or-later OR LGPL-3.0-or-later
require 'digest'
require 'find'
require 'tmpdir'

br1in, root = ARGV
abort "usage: br1in-noedit-spec.rb BR1IN FIXROOT" unless br1in && root
drops = File.join(root, 'from')
drop  = File.join(drops, '2026-01-02')
fixd  = File.expand_path('fixtures/lane-d/br1in', __dir__)

def snap(dir)
  s = {}
  Find.find(dir) do |p|
    st = File.lstat(p)
    s[p] = [st.ftype, st.size, st.mtime.to_f, (st.file? ? Digest::SHA256.file(p).hexdigest : nil)]
  end
  s
end

before = snap(drops)
common = ['--no-also', '--counterparts', File.join(fixd, 'counterparts.tsv'),
          '--ours', File.join(fixd, 'ours', 'skills')]
fails = 0
Dir.mktmpdir('br1in-rb') do |t|
  system('sh', br1in, *common, '--out', File.join(t, 'out'), drop, out: File::NULL, err: File::NULL)
  system('sh', br1in, *common, '--out', File.join(drop, 'reports'), drop, out: File::NULL, err: File::NULL)
  code = $?.exitstatus
  if code == 3 then puts "  PASS  BR1 an --out inside the drop is refused (exit 3)"
  else puts "  FAIL  BR1 an --out inside the drop is refused (exit #{code})"; fails += 1 end
end
after = snap(drops)
if before == after
  puts "  PASS  BR1 the drops' bytes, sizes, mtimes and listing are unchanged (#{after.size} entries)"
else
  added   = after.keys - before.keys
  changed = (after.keys & before.keys).reject { |k| after[k] == before[k] }
  puts "  FAIL  BR1 the drops changed: #{added.size} added, #{changed.size} changed (#{(added + changed).first(3).join(', ')})"
  fails += 1
end
exit(fails.zero? ? 0 : 1)
