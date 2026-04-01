#!/usr/bin/env bash
# Programmatic .ideate/ state factories

fixture_empty_dir() {
  local dir="$1"
  # No .ideate/ — represents a fresh project before /ideate is run
  :
}

fixture_active_session() {
  local dir="$1"
  mkdir -p "$dir/.ideate/branches" "$dir/.ideate/artifacts" "$dir/.ideate/output"
  cat > "$dir/.ideate/session.md" << 'EOF'
# Session Metadata

Created: 2026-03-31T10:00:00Z
Status: active
Active branch: main
Idea: A marketplace for local artisans

## Thread History
- main (active)

## Artifact Index
(none yet)
EOF
  cat > "$dir/.ideate/main.md" << 'EOF'
# Main Thread

## Idea
A marketplace for local artisans

## Merged Conclusions
(none yet — conclusions are added here when branches are merged)
EOF
}

fixture_with_branch() {
  local dir="$1"
  local slug="${2:-payment-models}"
  fixture_active_session "$dir"
  # Update session to point to branch
  cat > "$dir/.ideate/session.md" << EOF
# Session Metadata

Created: 2026-03-31T10:00:00Z
Status: active
Active branch: $slug
Idea: A marketplace for local artisans

## Thread History
- main (active)
- $slug (active)

## Artifact Index
(none yet)
EOF
  cat > "$dir/.ideate/branches/$slug.md" << EOF
# Branch: $slug
Status: active
Created from: main
---

## Context
Exploring how sellers get paid on the marketplace. Three models under consideration: commission, subscription, and hybrid.

## Commit 1
Explored commission model (10-15% per transaction). Simple to implement. Sellers resist high percentage.

## Commit 2
Explored flat subscription ($29/mo). Predictable revenue. Excludes very small sellers who sell infrequently.
EOF
}

fixture_with_fork_brief() {
  local dir="$1"
  local operation="$2"
  local slug="${3:-payment-models}"

  if [ "$operation" = "branch" ]; then
    fixture_active_session "$dir"
    cat > "$dir/.ideate/fork-brief.md" << EOF
# Fork Brief

Operation: branch
Topic: $slug
Why: User wants to explore different payment models
Current thread: main
What we know so far: We are building a marketplace for local artisans. The core marketplace concept is solid. Now considering monetization.
Key questions: What payment model works best for artisans? Commission vs subscription vs hybrid?
EOF

  elif [ "$operation" = "merge" ]; then
    fixture_with_branch "$dir" "$slug"
    cat > "$dir/.ideate/fork-brief.md" << EOF
# Fork Brief

Operation: merge
Branch: $slug
Branched from: main
Merge target: main.md
EOF

  elif [ "$operation" = "abandon" ]; then
    fixture_with_branch "$dir" "$slug"
    cat > "$dir/.ideate/fork-brief.md" << EOF
# Fork Brief

Operation: abandon
Branch: $slug
Branched from: main
Merge target: main.md
EOF
  fi
}

fixture_with_artifacts() {
  local dir="$1"
  fixture_active_session "$dir"
  cat > "$dir/.ideate/artifacts/Feature - Seller Dashboard.md" << 'EOF'
# Feature - Seller Dashboard

Type: Feature
Status: draft
Extracted from: main (2026-03-31)

## Description
A dashboard where sellers can view their listings, sales history, and revenue.

## Rationale
Sellers need visibility into their performance to manage their storefronts effectively.

## Open Questions
- Should analytics be real-time or daily batch?
EOF
  cat > "$dir/.ideate/artifacts/Persona - Independent Artisan.md" << 'EOF'
# Persona - Independent Artisan

Type: Persona
Status: draft
Extracted from: main (2026-03-31)

## Description
A solo craftsperson who makes and sells handmade goods. Not tech-savvy. Sells part-time.

## Goals
- Reach more buyers without a physical storefront
- Keep overhead low

## Context
Currently sells at weekend markets. Wants online presence but struggles with existing platforms.
EOF
  # Update session artifact index
  cat > "$dir/.ideate/session.md" << 'EOF'
# Session Metadata

Created: 2026-03-31T10:00:00Z
Status: active
Active branch: main
Idea: A marketplace for local artisans

## Thread History
- main (active)

## Artifact Index
- [Feature] Seller Dashboard → artifacts/Feature - Seller Dashboard.md
- [Persona] Independent Artisan → artifacts/Persona - Independent Artisan.md
EOF
}

fixture_with_stale_fork_brief() {
  local dir="$1"
  fixture_active_session "$dir"
  # Create a stale fork-brief (as if a previous operation was interrupted)
  cat > "$dir/.ideate/fork-brief.md" << 'EOF'
# Fork Brief

Operation: branch
Topic: stale-topic
Why: This brief is stale and should be deleted on startup
Current thread: main
What we know so far: This brief was left over from a previous interrupted session.
Key questions: N/A
EOF
}

fixture_with_completed_doc() {
  local dir="$1"
  fixture_with_artifacts "$dir"
  # Add merged conclusions to main.md
  cat >> "$dir/.ideate/main.md" << 'EOF'

## Merge: payment-models
Explored three payment models for artisan sellers. Recommendation is a hybrid: 8% commission for sales under $500/mo, flat $19/mo subscription above that threshold. This keeps small sellers viable while providing predictable revenue at scale.
Artifacts: [[Feature - Seller Dashboard]], [[Persona - Independent Artisan]]
EOF
}
