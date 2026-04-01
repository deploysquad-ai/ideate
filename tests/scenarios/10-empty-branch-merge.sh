#!/usr/bin/env bash
# Tier 2: Merging a branch with no commits prompts gracefully, does not write to main.md
set -uo pipefail
source "$(dirname "$0")/../lib/setup.sh"
source "$(dirname "$0")/../lib/fixtures.sh"

TESTDIR=$(create_temp_dir "10-empty-branch-merge")
trap "cleanup $TESTDIR" EXIT

SLUG="empty-branch"
fixture_active_session "$TESTDIR"
cd "$TESTDIR"

# Create a branch file with ONLY the initial context — no commits
cat > ".ideate/branches/$SLUG.md" << EOF
# Branch: $SLUG
Status: active
Created from: main
---

## Context
This branch has no commits beyond the initial context.
EOF

cat > ".ideate/session.md" << EOF
# Session Metadata

Created: 2026-03-31T10:00:00Z
Status: active
Active branch: $SLUG
Idea: A marketplace for local artisans

## Thread History
- main (active)
- $SLUG (active)

## Artifact Index
(none yet)
EOF

cat > ".ideate/fork-brief.md" << EOF
# Fork Brief

Operation: merge
Branch: $SLUG
Branched from: main
Merge target: main.md
EOF

RESPONSE=$(skill_prompt "ideate.merge" "A fork-brief.md exists with Operation: merge. Process it." \
  | claude -p --allowedTools "Read,Write,Edit,Glob,Bash" 2>/dev/null)

# Should warn about empty branch — not silently merge
if echo "$RESPONSE" | grep -qi "no commit\|no exploration\|nothing\|empty\|abandon"; then
  true
else
  echo "  FAIL: expected warning about empty branch, got: $(echo "$RESPONSE" | head -3)" >&2
  exit 1
fi

# main.md should NOT have gotten a merge entry
assert_no_grep "## Merge: $SLUG" ".ideate/main.md"
