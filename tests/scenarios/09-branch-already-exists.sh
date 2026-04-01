#!/usr/bin/env bash
# Tier 2: Branching when branch already exists switches to it, doesn't create duplicate
set -uo pipefail
source "$(dirname "$0")/../lib/setup.sh"
source "$(dirname "$0")/../lib/fixtures.sh"

TESTDIR=$(create_temp_dir "09-branch-already-exists")
trap "cleanup $TESTDIR" EXIT

SLUG="payment-models"
# Create the branch file already
fixture_active_session "$TESTDIR"
cd "$TESTDIR"

cat > ".ideate/branches/$SLUG.md" << EOF
# Branch: $SLUG
Status: active
Created from: main
---

## Context
Already exists from a previous session.

## Commit 1
Initial exploration of payment models.
EOF

# Write a fork-brief asking to branch to the same slug
cat > ".ideate/fork-brief.md" << EOF
# Fork Brief

Operation: branch
Topic: $SLUG
Why: User wants to continue exploring payment models
Current thread: main
What we know so far: Marketplace for artisans. Payment models under consideration.
Key questions: Should we use commission or subscription?
EOF

skill_prompt "ideate.branch" "A fork-brief.md exists. Process it." \
  | claude -p --allowedTools "Read,Write,Edit,Glob,Bash" > /dev/null

# Should switch, not duplicate
BRANCH_COUNT=$(ls .ideate/branches/ | grep "$SLUG" | wc -l | tr -d ' ')
if [ "$BRANCH_COUNT" -ne 1 ]; then
  echo "  FAIL: expected 1 branch file for $SLUG, got $BRANCH_COUNT" >&2
  exit 1
fi

assert_grep "Active branch: $SLUG" ".ideate/session.md"
assert_file_not_exists ".ideate/fork-brief.md"
