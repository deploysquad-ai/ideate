#!/usr/bin/env bash
# Tier 1: Cold start creates correct .ideate/ directory structure
set -uo pipefail
source "$(dirname "$0")/../lib/setup.sh"
source "$(dirname "$0")/../lib/fixtures.sh"

TESTDIR=$(create_temp_dir "01-cold-start")
trap "cleanup $TESTDIR" EXIT

fixture_empty_dir "$TESTDIR"
cd "$TESTDIR"

skill_prompt "ideate" "I want to start a new ideation session. My idea is: A tool for tracking personal finances." \
  | claude -p --allowedTools "Read,Write,Edit,Glob,Bash" > /dev/null

assert_dir_exists ".ideate"
assert_dir_exists ".ideate/branches"
assert_dir_exists ".ideate/artifacts"
assert_dir_exists ".ideate/output"
assert_file_exists ".ideate/session.md"
assert_file_exists ".ideate/main.md"
assert_grep "Status: active" ".ideate/session.md"
assert_grep "Active branch: main" ".ideate/session.md"
assert_grep "# Main Thread" ".ideate/main.md"
assert_file_not_exists ".ideate/fork-brief.md"
