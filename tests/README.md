# Ideate Integration Tests

## Overview

Integration tests for the Ideate plugin. Tests use a **fixture-in / assert-structure-out** pattern: each test pre-constructs `.ideate/` filesystem state, invokes a skill via `claude -p` with the skill content prepended to the prompt, and asserts structural invariants on the output.

Tests do **not** assert prose content — only file existence, required field presence, and status values. This makes them resilient to LLM rephrasing.

## Prerequisites

- `claude` CLI installed and authenticated
- Run from the repo root (skill files are resolved relative to `plugin/`)

## Running Tests

```bash
# Run all scenarios (Tier 1 + Tier 2)
bash tests/run-all.sh

# Run Tier 1 only (faster, ~$1-2, ~2 min)
bash tests/run-all.sh tier1
```

## Test Tiers

**Tier 1 — Core contract** (run pre-release or pre-merge):
- `01-cold-start` — fresh `.ideate/` structure created correctly
- `02-resume-session` — existing session not overwritten
- `03-branch-from-brief` — branch skill reads fork-brief, creates branch file
- `04-merge-from-brief` — merge skill squash-merges branch to main.md
- `05-abandon-from-brief` — abandon does NOT write to main.md
- `06-doc-generation` — output file created, session marked complete

**Tier 2 — Edge cases** (run weekly or on main merges):
- `07-stale-fork-brief` — stale fork-brief.md deleted on startup
- `08-merge-from-main` — graceful response when already on main
- `09-branch-already-exists` — switches to existing branch, no duplicate
- `10-empty-branch-merge` — warns about empty branch, no silent write
- `11-doc-regeneration` — second doc run overwrites, not duplicates

**Tier 3 — Manual runbooks** (before major version bumps):
- `runbook/full-lifecycle.md` — complete multi-turn session
- `runbook/intent-detection.md` — conversational signal routing

## Cost

Each `claude -p` invocation costs ~$0.10–0.30 and takes 10–30 seconds.
- Tier 1 (6 tests): ~$1–2, ~2 min
- Tier 1 + Tier 2 (11 tests): ~$2–4, ~5 min

Do not run the full suite on every commit.

## Structure

```
tests/
  lib/
    setup.sh       — temp dir creation, assert_file_exists, assert_grep, etc.
    fixtures.sh    — .ideate/ state factories (fixture_active_session, fixture_with_branch, etc.)
  scenarios/       — automated test scripts (01–11)
  runbook/         — manual test scripts
  run-all.sh       — test runner
```
