# Ideate Plugin — Project Overview

## Purpose
Ideate is a Claude Code plugin for structured ideation. It's a set of markdown skill files — no compiled code, no MCP server, no runtime dependencies. It helps users turn conversations into structured project briefs using git-like branching, artifact extraction, and document generation.

## Tech Stack
- **Language**: Markdown only (SKILL.md files with YAML frontmatter)
- **No compiled code**, no MCP server, no runtime dependencies
- **Plugin format**: Claude Code plugin (`.claude-plugin/plugin.json`)
- **Version**: 0.1.0
- **License**: MIT
- **Author**: DeploySquad (hi@deploysquad.ai)

## Project Structure
```
plugin/                          — installable plugin directory
  .claude-plugin/plugin.json    — plugin manifest
  skills/ideate/SKILL.md        — main skill: session orchestration, intent detection, artifact extraction
  skills/branch/SKILL.md        — branch creation and switching
  skills/merge/SKILL.md         — squash-merge and abandon
  skills/doc/SKILL.md           — document generation from artifacts
  skills/research/SKILL.md      — web research scoped to current thread
.claude-plugin/marketplace.json  — marketplace distribution metadata (source: "./plugin")
docs/                            — documentation (getting-started, concepts, skills-reference, examples)
assets/brand/                    — logo and brand assets
CHANGELOG.md
```

## How Skills Work
- Each skill lives in `plugin/skills/<skill-name>/SKILL.md` with YAML frontmatter
- Claude Code auto-discovers `SKILL.md` files from subdirectories of `skills/`
- The frontmatter `name` field becomes the slash command (e.g., `/ideate`, `/branch`, `/merge`, `/doc`, `/research`)
- No changes to `plugin.json` needed when adding new skills

## Session Data Contract
When `/ideate` runs, it creates `.ideate/` in the user's working directory:
```
.ideate/
  session.md       — session metadata (project name, status, active branch)
  main.md          — append-only log of squash-merged conclusions
  branches/        — one file per branch (append-only commit logs)
  artifacts/       — one file per artifact (mutable, edited in place)
  output/          — generated documents
```

## Artifact Types
Six types: `feature`, `decision`, `constraint`, `persona`, `goal`, `module`
Stored as `<Type> - <Name>.md` in `.ideate/artifacts/`
