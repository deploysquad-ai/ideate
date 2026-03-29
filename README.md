# Ideate

**Turn conversations into structured project briefs.**

Ideate is a [Claude Code](https://claude.ai/code) plugin for the early, exploratory phase of software projects. Describe your idea conversationally — ramble, pivot, ask questions — while Ideate helps you explore tangents via git-like branching, extracts structured artifacts (features, decisions, constraints, personas), and produces a shareable document as the session's deliverable.

## Install

```bash
claude plugin add ideate
```

## Quick Start

1. Navigate to your project directory
2. Run `/ideate`
3. Start describing your idea

Ideate will guide you through the ideation process, suggest branches when you want to explore tangents, extract artifacts as ideas solidify, and generate a structured document when you're ready.

## How It Works

### Branching

When your thinking diverges, Ideate creates a branch — an isolated thread where you can explore a tangent without polluting the main conversation. Like a git branch, you can merge it back (keeping the conclusions) or abandon it (keeping nothing).

```
Main thread: "Building a payments platform..."
  └── Branch: payment-models
      ├── Commit 1: Exploring freemium vs flat-rate
      ├── Commit 2: User leaning toward freemium
      └── Commit 3 — Merge: "Freemium with usage-based pricing"
  └── Branch: auth-approach
      ├── Commit 1: Considering OAuth vs email/password
      └── Commit 2 — Merge: "OAuth2 via Google/GitHub only"
```

### Artifact Extraction

As ideas solidify, Ideate extracts them into typed artifacts:

- **Features** — what the product does
- **Decisions** — what was decided and why
- **Constraints** — technical or business limits
- **Personas** — who uses this
- **Goals** — what success looks like
- **Modules** — functional subsystems

Artifacts are stored as individual markdown files in `.ideate/artifacts/` — human-readable, diffable, and always reflecting the latest state.

### Document Generation

Run `/ideate.doc` to assemble all artifacts and merged conclusions into a structured Markdown document. This is the deliverable — the thing you hand off, share, or act on.

## Commands

| Command | Purpose |
|---|---|
| `/ideate` | Start or resume a session |
| `/ideate.branch <name>` | Create or switch branches |
| `/ideate.merge` | Merge current branch to main |
| `/ideate.doc` | Generate the session document |
| `/ideate.research <topic>` | Research similar products and prior art |

Most of the time, you won't need explicit commands — Ideate detects your intent conversationally and acts accordingly.

## Session Data

Ideate stores session state in a `.ideate/` directory in your working directory. It's all markdown — you can browse, edit, or delete it with any text editor.

```
.ideate/
  session.md        — session metadata
  main.md           — merged conclusions
  branches/         — branch history
  artifacts/        — extracted artifacts
  output/           — generated documents
```

## Documentation

- [Getting Started](docs/getting-started.md)
- [Concepts](docs/concepts.md) — branching model, artifacts, session lifecycle
- [Skills Reference](docs/skills-reference.md) — detailed command documentation
- [Example: Payments Platform](docs/examples/payments-platform.md) — full session walkthrough

## Contributing

Ideate is open source under the MIT License. See [CLAUDE.md](CLAUDE.md) for development instructions.

## License

MIT
