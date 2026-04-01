#!/usr/bin/env bash
# Tier 2: Merge when already on main — skill responds gracefully, no crash
set -uo pipefail
source "$(dirname "$0")/../lib/setup.sh"
source "$(dirname "$0")/../lib/fixtures.sh"

TESTDIR=$(create_temp_dir "08-merge-from-main")
trap "cleanup $TESTDIR" EXIT

fixture_active_session "$TESTDIR"  # Active branch: main
cd "$TESTDIR"

skill_prompt "ideate.merge" "Merge the current branch back to main." \
  | claude -p --allowedTools "Read,Write,Edit,Glob,Bash" > /dev/null 2>&1

# Should not have written a merge section — there's no branch to merge
assert_no_grep "## Merge:" ".ideate/main.md"

# main.md and session.md should be untouched
assert_grep "Status: active" ".ideate/session.md"
assert_grep "Active branch: main" ".ideate/session.md"
