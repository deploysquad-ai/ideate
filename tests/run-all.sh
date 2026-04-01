#!/usr/bin/env bash
# Run all integration test scenarios
set -uo pipefail  # Note: no -e, scenario scripts handle their own exit codes

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/setup.sh"

TIER="${1:-all}"  # Pass "tier1" to run only Tier 1 scenarios

echo "Ideate Integration Tests"
echo "========================"

# Preflight: verify claude -p is functional
echo -n "Checking claude -p ... "
if ! bash -c 'echo "ping" | claude -p > /dev/null 2>&1'; then
  echo "FAIL"
  echo ""
  echo "ERROR: claude -p is not working. Common causes:"
  echo "  - An MCP server has an invalid or expired API key"
  echo "  - Network issues"
  echo "  - Run 'echo ping | claude -p' to see the error"
  exit 1
fi
echo "OK"
echo ""

TIER1_SCENARIOS=(
  "01 Cold start"                      "$SCRIPT_DIR/scenarios/01-cold-start.sh"
  "02 Resume active session"           "$SCRIPT_DIR/scenarios/02-resume-session.sh"
  "03 Branch from fork-brief"          "$SCRIPT_DIR/scenarios/03-branch-from-brief.sh"
  "04 Merge from fork-brief"           "$SCRIPT_DIR/scenarios/04-merge-from-brief.sh"
  "05 Abandon from fork-brief"         "$SCRIPT_DIR/scenarios/05-abandon-from-brief.sh"
  "06 Doc generation"                  "$SCRIPT_DIR/scenarios/06-doc-generation.sh"
)

TIER2_SCENARIOS=(
  "07 Stale fork-brief cleanup"        "$SCRIPT_DIR/scenarios/07-stale-fork-brief.sh"
  "08 Merge from main (graceful)"      "$SCRIPT_DIR/scenarios/08-merge-from-main.sh"
  "09 Branch already exists"           "$SCRIPT_DIR/scenarios/09-branch-already-exists.sh"
  "10 Empty branch merge warning"      "$SCRIPT_DIR/scenarios/10-empty-branch-merge.sh"
  "11 Doc regeneration no duplicates"  "$SCRIPT_DIR/scenarios/11-doc-regeneration.sh"
  "12 Ideation quality"               "$SCRIPT_DIR/scenarios/12-ideation-quality.sh"
  "13 Research intent from URL"        "$SCRIPT_DIR/scenarios/13-research-intent-url.sh"
)

echo ""
echo "Tier 1 — Core contract"
echo "----------------------"
i=0
while [ $i -lt ${#TIER1_SCENARIOS[@]} ]; do
  run_scenario "${TIER1_SCENARIOS[$i]}" "${TIER1_SCENARIOS[$((i+1))]}"
  i=$((i+2))
done

if [ "$TIER" != "tier1" ]; then
  echo ""
  echo "Tier 2 — Edge cases"
  echo "--------------------"
  i=0
  while [ $i -lt ${#TIER2_SCENARIOS[@]} ]; do
    run_scenario "${TIER2_SCENARIOS[$i]}" "${TIER2_SCENARIOS[$((i+1))]}"
    i=$((i+2))
  done
fi

report
