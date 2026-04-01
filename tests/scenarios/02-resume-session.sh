#!/usr/bin/env bash
# Tier 1: Resume does not overwrite existing session.md
set -uo pipefail
source "$(dirname "$0")/../lib/setup.sh"
source "$(dirname "$0")/../lib/fixtures.sh"

TESTDIR=$(create_temp_dir "02-resume-session")
trap "cleanup $TESTDIR" EXIT

fixture_active_session "$TESTDIR"
cd "$TESTDIR"

skill_prompt "ideate" "Resume my session." \
  | claude -p --allowedTools "Read,Write,Edit,Glob,Bash" > /dev/null

# session.md should still exist and still say active
assert_file_exists ".ideate/session.md"
assert_grep "Status: active" ".ideate/session.md"
assert_grep "Active branch: main" ".ideate/session.md"
assert_grep "A marketplace for local artisans" ".ideate/session.md"

# .ideate directory should not be renamed/replaced
assert_dir_exists ".ideate"
# No backup directory should have been created (no start-fresh)
if ls -d .ideate.bak-* 2>/dev/null | grep -q .; then
  echo "  FAIL: start-fresh was triggered unexpectedly — backup dir created" >&2
  exit 1
fi
