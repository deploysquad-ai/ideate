#!/usr/bin/env bash
# Tier 2: Stale fork-brief.md is deleted on ideate startup
set -uo pipefail
source "$(dirname "$0")/../lib/setup.sh"
source "$(dirname "$0")/../lib/fixtures.sh"

TESTDIR=$(create_temp_dir "07-stale-fork-brief")
trap "cleanup $TESTDIR" EXIT

fixture_with_stale_fork_brief "$TESTDIR"
cd "$TESTDIR"

skill_prompt "ideate" "Resume my session." \
  | claude -p --allowedTools "Read,Write,Edit,Glob,Bash" > /dev/null

assert_file_not_exists ".ideate/fork-brief.md"
assert_file_exists ".ideate/session.md"
