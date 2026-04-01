#!/usr/bin/env bash
# Tier 2: Running doc twice produces one output file, not two
set -uo pipefail
source "$(dirname "$0")/../lib/setup.sh"
source "$(dirname "$0")/../lib/fixtures.sh"

TESTDIR=$(create_temp_dir "11-doc-regeneration")
trap "cleanup $TESTDIR" EXIT

fixture_with_completed_doc "$TESTDIR"
cd "$TESTDIR"

PROMPT=$(skill_prompt "ideate.doc" "Generate the document from the session artifacts and main thread conclusions.")

# First run
echo "$PROMPT" | claude -p --allowedTools "Read,Write,Edit,Glob,Bash" > /dev/null

FIRST_COUNT=$(ls .ideate/output/ 2>/dev/null | wc -l | tr -d ' ')

# Reset session status to active so the second run doesn't refuse to regenerate
sed -i.bak 's/Status: complete/Status: active/' .ideate/session.md && rm -f .ideate/session.md.bak

# Second run
echo "$PROMPT" | claude -p --allowedTools "Read,Write,Edit,Glob,Bash" > /dev/null

SECOND_COUNT=$(ls .ideate/output/ 2>/dev/null | wc -l | tr -d ' ')

if [ "$SECOND_COUNT" -gt "$FIRST_COUNT" ]; then
  echo "  FAIL: second doc run created extra files (${FIRST_COUNT} -> ${SECOND_COUNT})" >&2
  ls .ideate/output/ >&2
  exit 1
fi

# Still exactly one output file after two runs
if [ "$SECOND_COUNT" -lt 1 ]; then
  echo "  FAIL: no output file after second run" >&2
  exit 1
fi
