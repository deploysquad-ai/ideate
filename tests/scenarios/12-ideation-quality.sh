#!/usr/bin/env bash
# Tier 2: Ideation response contributes ideas, not just questions
set -uo pipefail
source "$(dirname "$0")/../lib/setup.sh"
source "$(dirname "$0")/../lib/fixtures.sh"

TESTDIR=$(create_temp_dir "12-ideation-quality")
trap "cleanup $TESTDIR" EXIT

fixture_active_session "$TESTDIR"
cd "$TESTDIR"

# Give a substantive idea with enough detail that the skill should contribute, not just ask
RESPONSE=$(skill_prompt "ideate" \
  "Resume my session. Here's what I'm thinking: I want to build a standardized manifest format for AI agents — like package.json but for skills and agents. This would enable a registry (like npm) where people can share and install agents regardless of which LLM they use. The manifest would declare inputs, outputs, and model requirements." \
  | claude -p --allowedTools "Read,Write,Edit,Glob,Bash" 2>/dev/null)

# Response should not be ONLY questions — it should contain substantive ideation.
# Count sentences that end with '?' vs total sentences.
QUESTION_LINES=$(echo "$RESPONSE" | grep -c '?' || true)
TOTAL_LINES=$(echo "$RESPONSE" | grep -c '[.!?]' || true)

# If every sentence is a question, that's the interviewer bug
if [ "$TOTAL_LINES" -gt 0 ] && [ "$QUESTION_LINES" -eq "$TOTAL_LINES" ]; then
  echo "  FAIL: response is entirely questions — no ideation contributed" >&2
  echo "  Response preview: $(echo "$RESPONSE" | head -5)" >&2
  exit 1
fi

# Response should be substantive (not a one-liner)
WORD_COUNT=$(echo "$RESPONSE" | wc -w | tr -d ' ')
if [ "$WORD_COUNT" -lt 30 ]; then
  echo "  FAIL: response too short to contain meaningful ideation ($WORD_COUNT words)" >&2
  exit 1
fi
