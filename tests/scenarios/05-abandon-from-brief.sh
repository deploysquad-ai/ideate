#!/usr/bin/env bash
# Tier 1: Abandon from fork-brief marks branch abandoned, does NOT write to main.md
set -uo pipefail
source "$(dirname "$0")/../lib/setup.sh"
source "$(dirname "$0")/../lib/fixtures.sh"

TESTDIR=$(create_temp_dir "05-abandon-from-brief")
trap "cleanup $TESTDIR" EXIT

SLUG="payment-models"
fixture_with_fork_brief "$TESTDIR" "abandon" "$SLUG"
cd "$TESTDIR"

# Record main.md content before
MAIN_BEFORE=$(cat .ideate/main.md)

skill_prompt "ideate.merge" "A fork-brief.md exists with Operation: abandon. Process it." \
  | claude -p --allowedTools "Read,Write,Edit,Glob,Bash" > /dev/null

assert_grep "Status: abandoned" ".ideate/branches/$SLUG.md"
assert_grep "Abandon\|abandon" ".ideate/branches/$SLUG.md"
assert_grep "Active branch: main" ".ideate/session.md"
assert_file_not_exists ".ideate/fork-brief.md"

# main.md should NOT have a merge section for this branch
assert_no_grep "## Merge: $SLUG" ".ideate/main.md"
