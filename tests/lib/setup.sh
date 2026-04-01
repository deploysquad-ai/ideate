#!/usr/bin/env bash
# Common test utilities: temp dir management and assertion helpers

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
PASS_COUNT=0
FAIL_COUNT=0
ERRORS=()

create_temp_dir() {
  local name="$1"
  local dir
  dir=$(mktemp -d "/tmp/ideate-test-${name}-XXXXXX")
  git init -q "$dir"
  echo "$dir"
}

cleanup() {
  local dir="$1"
  if [ -d "$dir" ] && [[ "$dir" == /tmp/ideate-test-* ]]; then
    rm -rf "$dir"
  fi
}

assert_file_exists() {
  local file="$1"
  if [ -f "$file" ]; then
    return 0
  else
    echo "  FAIL: expected file to exist: $file" >&2
    return 1
  fi
}

assert_file_not_exists() {
  local file="$1"
  if [ ! -f "$file" ]; then
    return 0
  else
    echo "  FAIL: expected file to NOT exist: $file" >&2
    return 1
  fi
}

assert_dir_exists() {
  local dir="$1"
  if [ -d "$dir" ]; then
    return 0
  else
    echo "  FAIL: expected directory to exist: $dir" >&2
    return 1
  fi
}

assert_grep() {
  local pattern="$1"
  local file="$2"
  if grep -qi "$pattern" "$file" 2>/dev/null; then
    return 0
  else
    echo "  FAIL: pattern '$pattern' not found in $file" >&2
    return 1
  fi
}

assert_no_grep() {
  local pattern="$1"
  local file="$2"
  if ! grep -qi "$pattern" "$file" 2>/dev/null; then
    return 0
  else
    echo "  FAIL: pattern '$pattern' should NOT be in $file" >&2
    return 1
  fi
}

run_scenario() {
  local name="$1"
  local script="$2"
  echo -n "  $name ... "
  if bash "$script" 2>/tmp/ideate-test-stderr; then
    echo "PASS"
    PASS_COUNT=$((PASS_COUNT + 1))
  else
    echo "FAIL"
    FAIL_COUNT=$((FAIL_COUNT + 1))
    ERRORS+=("$name")
    cat /tmp/ideate-test-stderr >&2
  fi
}

report() {
  echo ""
  echo "Results: $PASS_COUNT passed, $FAIL_COUNT failed"
  if [ ${#ERRORS[@]} -gt 0 ]; then
    echo "Failed:"
    for e in "${ERRORS[@]}"; do
      echo "  - $e"
    done
    exit 1
  fi
}

skill_prompt() {
  local skill_name="$1"
  local instruction="$2"
  # Map skill name to directory: ideate.branch -> branch, ideate.merge -> merge, etc.
  local skill_dir
  skill_dir="${skill_name#ideate.}"  # strip "ideate." prefix if present
  cat "$REPO_ROOT/plugin/skills/$skill_dir/SKILL.md"
  echo ""
  echo "---"
  echo ""
  echo "$instruction"
  echo ""
  echo "Important: After completing all steps, if .ideate/fork-brief.md still exists, delete it by running: rm .ideate/fork-brief.md"
}
