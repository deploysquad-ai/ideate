#!/bin/bash
# SessionStart hook for ideate context isolation.
# After /clear or compact, injects active ideation session state
# so Claude can resume without the user re-running /ideate manually.

INPUT=$(cat)
SOURCE=$(echo "$INPUT" | jq -r '.source // empty')

# Only act on clear or compact — not startup or resume
if [ "$SOURCE" != "clear" ] && [ "$SOURCE" != "compact" ]; then
  exit 0
fi

# Check for active ideation session
if [ ! -f ".ideate/session.md" ]; then
  exit 0
fi

# Read session metadata
STATUS=$(grep -m1 '^Status:' .ideate/session.md | sed 's/^Status: *//')
if [ "$STATUS" != "active" ]; then
  exit 0
fi

IDEA=$(grep -m1 '^Idea:' .ideate/session.md | sed 's/^Idea: *//')
BRANCH=$(grep -m1 '^Active branch:' .ideate/session.md | sed 's/^Active branch: *//')

# Build context injection
if [ "$BRANCH" = "main" ]; then
  cat <<EOF
[Ideation session resumed after /clear]
Session: "$IDEA"
Active thread: main

Invoke /ideate to resume. Context loading rules:
- Read session.md and main.md only
- Do NOT read branch files unless the user asks about a specific branch
- Do NOT ask "pick up where you left off?" — the user just /cleared to get clean context, they want to continue
EOF
else
  cat <<EOF
[Ideation session resumed after /clear]
Session: "$IDEA"
Active branch: $BRANCH

Invoke /ideate to resume. Context loading rules:
- Read session.md and branches/$BRANCH.md only
- Do NOT read main.md — the branch file has its own scoped context
- Do NOT read other branch files
- Do NOT ask "pick up where you left off?" — the user just /cleared to get clean context, they want to continue
EOF
fi

exit 0
