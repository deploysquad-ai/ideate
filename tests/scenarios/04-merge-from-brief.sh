#!/usr/bin/env bash
# Tier 1: Merge from fork-brief marks branch merged, appends to main.md, updates session
set -uo pipefail
source "$(dirname "$0")/../lib/setup.sh"
source "$(dirname "$0")/../lib/fixtures.sh"

TESTDIR=$(create_temp_dir "04-merge-from-brief")
trap "cleanup $TESTDIR" EXIT

SLUG="payment-models"
fixture_with_fork_brief "$TESTDIR" "merge" "$SLUG"
cd "$TESTDIR"

skill_prompt "ideate.merge" "A fork-brief.md exists with Operation: merge. Process it." \
  | claude -p --allowedTools "Read,Write,Edit,Glob,Bash" > /dev/null

assert_grep "Status: merged" ".ideate/branches/$SLUG.md"
assert_grep "$SLUG\|payment" ".ideate/main.md"
assert_grep "Active branch: main" ".ideate/session.md"
assert_file_not_exists ".ideate/fork-brief.md"
