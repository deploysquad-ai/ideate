#!/usr/bin/env bash
# Tier 1: Doc generation writes output file and marks session complete
set -uo pipefail
source "$(dirname "$0")/../lib/setup.sh"
source "$(dirname "$0")/../lib/fixtures.sh"

TESTDIR=$(create_temp_dir "06-doc-generation")
trap "cleanup $TESTDIR" EXIT

fixture_with_completed_doc "$TESTDIR"
cd "$TESTDIR"

skill_prompt "ideate.doc" "A fork-brief.md may or may not exist. Generate the document from the session artifacts and main thread conclusions." \
  | claude -p --allowedTools "Read,Write,Edit,Glob,Bash" > /dev/null

# At least one file should exist in output/
OUTPUT_COUNT=$(ls .ideate/output/ 2>/dev/null | wc -l | tr -d ' ')
if [ "$OUTPUT_COUNT" -lt 1 ]; then
  echo "  FAIL: no output file generated in .ideate/output/" >&2
  exit 1
fi

# Output file should start with a heading
OUTPUT_FILE=$(ls .ideate/output/*.md 2>/dev/null | head -1)
assert_file_exists "$OUTPUT_FILE"
assert_grep "^#" "$OUTPUT_FILE"

# Session should be marked complete
assert_grep "Status: complete" ".ideate/session.md"
