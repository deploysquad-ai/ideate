# Style and Conventions

## Skill Files
- Each skill is a single `SKILL.md` file in `plugin/skills/<skill-name>/SKILL.md`
- YAML frontmatter required: `name` (becomes slash command) and `description` (tells Claude when to invoke)
- Keep prompts focused and specific — no generic LLM instructions
- Intent detection patterns should be concrete examples, not vague descriptions

## Artifact Schemas
- Must stay in sync across `skills/ideate/SKILL.md` (extraction) and `skills/doc/SKILL.md` (assembly)
- Six artifact types: `feature`, `decision`, `constraint`, `persona`, `goal`, `module`
- Files named: `<Type> - <Name>.md` in `.ideate/artifacts/`

## Branch/Session Files
- Branch files are **append-only** — retained after merge/abandon
- Artifact files are **mutable** — always reflect current state; history lives in branch logs
- Session metadata in `.ideate/session.md`

## Key Design Decisions
- No MCP server — all state is markdown files read/written with Claude's native tools
- Conversational command inference — `/ideate` detects intent; slash commands are escape hatches
- Document is the deliverable — every session should produce a structured document

## Plugin Manifest
- `plugin/.claude-plugin/plugin.json` — plugin metadata
- `.claude-plugin/marketplace.json` — marketplace source field must be `"./plugin"` (not `"."`)
