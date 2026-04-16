# CLAUDE.md

## What This Project Is

Ideate is a Claude Code plugin for structured ideation. It's a set of markdown skill files — no compiled code, no MCP server, no runtime dependencies.

## Project Structure

```
.claude-plugin/plugin.json         — plugin manifest
.claude-plugin/marketplace.json    — marketplace distribution metadata
skills/ideate/SKILL.md             — main skill: session orchestration, intent detection, artifact extraction
skills/branch/SKILL.md             — branch creation and switching
skills/merge/SKILL.md              — squash-merge and abandon
skills/doc/SKILL.md                — document generation from artifacts
skills/research/SKILL.md           — web research scoped to current thread
```

## How Skills Work

Each skill lives in `skills/<skill-name>/SKILL.md` with YAML frontmatter. Claude Code auto-discovers `SKILL.md` files from subdirectories of `skills/`. The frontmatter defines the skill name (which becomes the slash command) and description (which tells Claude when to invoke it).

## Session Data Contract

When a user runs `/ideate`, the plugin creates a `.ideate/` directory in the user's working directory:

```
.ideate/
  session.md       — session metadata (project name, status, active branch)
  main.md          — append-only log of squash-merged conclusions
  branches/        — one file per branch (append-only commit logs)
  artifacts/       — one file per artifact (mutable, edited in place)
  output/          — generated documents
```

All skills read from and write to this directory. This is the shared contract.

## Artifact Types

Six types: `feature`, `decision`, `constraint`, `persona`, `goal`, `module`. Each has a defined schema in the main ideate skill. Artifacts are stored as `<Type> - <Name>.md` in `.ideate/artifacts/`.

**Feature artifacts are versioned and reconciled at merge.** When `/ideate:merge` runs on a branch targeting a feature, it rewrites the canonical `Feature - <Name>.md` to reflect the branch's decisions and writes a per-version refinement file named `Feature - <Name>.v<N>.refinements.md`. The canonical file is the single source of truth for the feature's current state; refinement files preserve the per-merge change history. See `skills/merge/SKILL.md` for the reconciliation flow and refinement file schema.

## Key Design Decisions

- **No MCP server** — all state is markdown files read/written with Claude's native tools
- **Conversational command inference** — the main `/ideate` skill detects intent; slash commands are escape hatches
- **Branch files are append-only** — retained after merge/abandon
- **Artifact files are mutable** — always reflect current state; history lives in branch logs
- **Document is the deliverable** — every session should produce a structured document

## Editing Skills

When editing skill files:
- Keep the prompt focused and specific. Don't add generic LLM instructions.
- Intent detection patterns in `skills/ideate/SKILL.md` should be concrete examples, not vague descriptions.
- Artifact schemas must stay in sync across `skills/ideate/SKILL.md` (extraction) and `skills/doc/SKILL.md` (assembly).
- Test changes by running the skill in a scratch directory:
  ```bash
  mkdir /tmp/ideate-test && cd /tmp/ideate-test && git init
  # Then invoke /ideate in that directory with the plugin loaded
  ```

## Adding a New Skill

1. Create `skills/<skill-name>/SKILL.md` with YAML frontmatter (`name`, `description`).
2. No changes to `plugin.json` needed — skills are auto-discovered from `skills/*/SKILL.md`.
3. The skill name in frontmatter becomes the slash command (`/skill-name`).

## Plugin Validation

Check manifest validity before publishing:
```bash
cat .claude-plugin/plugin.json      # plugin metadata
cat .claude-plugin/marketplace.json # marketplace source field must be "." for root-level plugins
```
