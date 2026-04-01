#!/usr/bin/env bash
# Tier 1: Branch from fork-brief creates branch file, updates session, deletes brief
set -uo pipefail
source "$(dirname "$0")/../lib/setup.sh"
source "$(dirname "$0")/../lib/fixtures.sh"

TESTDIR=$(create_temp_dir "03-branch-from-brief")
trap "cleanup $TESTDIR" EXIT

SLUG="payment-models"
fixture_with_fork_brief "$TESTDIR" "branch" "$SLUG"
cd "$TESTDIR"

skill_prompt "ideate.branch" "A fork-brief.md exists. Process it and create the branch." \
  | claude -p --allowedTools "Read,Write,Edit,Glob,Bash" > /dev/null

assert_file_exists ".ideate/branches/$SLUG.md"
assert_grep "Status: active" ".ideate/branches/$SLUG.md"
assert_grep "Created from:" ".ideate/branches/$SLUG.md"
assert_grep "## Context" ".ideate/branches/$SLUG.md"
assert_grep "Active branch: $SLUG" ".ideate/session.md"
assert_file_not_exists ".ideate/fork-brief.md"
