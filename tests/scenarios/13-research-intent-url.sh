#!/usr/bin/env bash
# Tier 2: Sharing a URL triggers research intent (writes fork-brief with operation: research)
set -uo pipefail
source "$(dirname "$0")/../lib/setup.sh"
source "$(dirname "$0")/../lib/fixtures.sh"

TESTDIR=$(create_temp_dir "13-research-intent-url")
trap "cleanup $TESTDIR" EXIT

fixture_active_session "$TESTDIR"
cd "$TESTDIR"

# The ideate skill should detect research intent when a URL is shared.
# Since sub-skills aren't available in this test, the skill should either:
# 1. Write a fork-brief with Operation: research, or
# 2. Mention that the research skill isn't loaded
# Either outcome proves intent was detected.
RESPONSE=$(skill_prompt "ideate" \
  "Resume my session. Check out this project that's doing something similar: https://github.com/Yeachan-Heo/oh-my-claudecode — how does their approach compare to what we're building?" \
  | claude -p --allowedTools "Read,Write,Edit,Glob,Bash" 2>/dev/null)

# The skill should have recognized this as research intent.
# Check if fork-brief was written with research operation, OR if the response mentions research skill
if [ -f ".ideate/fork-brief.md" ]; then
  assert_grep "Operation: research" ".ideate/fork-brief.md"
elif echo "$RESPONSE" | grep -qi "research\|look.*up\|investigat"; then
  true
else
  echo "  FAIL: URL sharing did not trigger research intent" >&2
  echo "  Response preview: $(echo "$RESPONSE" | head -5)" >&2
  exit 1
fi
