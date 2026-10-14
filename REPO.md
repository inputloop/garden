# inputloop/garden: the garden (AS4CE0001: the vibrobeast plugin source, skills, soft skills, GRAMMARY), as a family cut

Each commit here is one cut made by C4's `bin/fm1ct`: the whole tracked tree as of a commit, less the rows of its
hold list (C4 `d/family/HOLDS.tsv`, the garden's `conventions/FAMILY-HOLDS.tsv`, each with a class, a source and the event that opens it)
and the keeper's own hold list. `KEPT-BACK.md` says what stayed out and why; `HOLDS-AT-CUT.tsv` is the list in
force; `MANIFEST.md` and `SHA256SUMS` say what was checked. `READ-FIRST.md` is written for the peer the cut
was first made for. The history of the source tree is not carried: holds apply to history too.

To add the next cut: `sh bin/fm1ct cut PEER --tree /f/claude/AS4CE/AS4CE0001 --out DIR` in C4, unzip, replace this tree with its
folder's contents (keep .git and this file), commit with the cut's name.
