#!/bin/sh
# Run this on your own machine (where git works on the real filesystem) to put
# polygram under version control. The sandbox couldn't init git directly on the
# mounted Windows folder.
set -eu
cd "$(dirname "$0")"
git init
git add -A
git commit -m "polygram v0.1.0: gated agent-skill synthesis (stdlib only, 9 tests passing)"
echo "polygram is now version-controlled. Add a remote with: git remote add origin <url>"
