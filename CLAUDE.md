# CLAUDE.md

## What This Project Is

Ideate is a Claude Code plugin for structured ideation. It's a set of markdown skill files — no compiled code, no MCP server, no runtime dependencies.

## Project Structure

```
.claude-plugin/plugin.json    — plugin manifest
skills/ideate/ideate.md       — main skill: session orchestration, intent detection, artifact extraction
skills/branch/branch.md       — branch creation and switching
skills/merge/merge.md         — squash-merge and abandon
skills/doc/doc.md             — document generation from artifacts
skills/research/research.md   — web research scoped to current thread
```

## How Skills Work

Each skill is a markdown file with YAML frontmatter. Claude Code auto-discovers skills from the `skills/` directory. The frontmatter defines the skill name (which becomes the slash command) and description (which tells Claude when to invoke it).

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

## Key Design Decisions

- **No MCP server** — all state is markdown files read/written with Claude's native tools
- **Conversational command inference** — the main `/ideate` skill detects intent; slash commands are escape hatches
- **Branch files are append-only** — retained after merge/abandon
- **Artifact files are mutable** — always reflect current state; history lives in branch logs
- **Document is the deliverable** — every session should produce a structured document

## Editing Skills

When editing skill files:
- Keep the prompt focused and specific. Don't add generic LLM instructions.
- Intent detection patterns in `ideate.md` should be concrete examples, not vague descriptions.
- Artifact schemas must stay in sync across `ideate.md` (extraction) and `doc.md` (assembly).
- Test changes by running the skill in a scratch directory and going through a full session.
