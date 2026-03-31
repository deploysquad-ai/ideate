# Suggested Commands

## Plugin Validation
```bash
cat plugin/.claude-plugin/plugin.json      # check plugin manifest
cat .claude-plugin/marketplace.json        # check marketplace metadata (source must be "./plugin")
```

## Testing Skills
```bash
mkdir /tmp/ideate-test && cd /tmp/ideate-test && git init
# Then invoke /ideate in that directory with the plugin loaded
```

## Git
```bash
git status
git log --oneline
git diff
```

## File Inspection
```bash
cat plugin/skills/<skill-name>/SKILL.md   # read a skill file
ls plugin/skills/                          # list all skills
```

## No build, test, lint, or format commands — this is a markdown-only project.
