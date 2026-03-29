# Concepts

## The Branching Model

Ideate uses a git-inspired branching model for conversations:

- **Main thread** — the core ideation context. Conclusions from branches merge here.
- **Branches** — isolated explorations of tangents. Each branch has its own commit log.
- **Merge** — squash-merges the branch's conclusion back to main. The branch history is retained but only the conclusion transfers.
- **Abandon** — discards a branch. Nothing goes to main. The branch file is kept for reference.

### Why Branching?

Ideas don't arrive linearly. You think of something, want to explore it, realize it's a dead end, and come back. Without branching, every tangent pollutes your main thread — making it hard to remember what you actually decided vs. what you were just exploring.

Branching gives you permission to explore without commitment. Merge when something sticks. Abandon when it doesn't.

### The PR Analogy

Think of each branch as a pull request. You explore, discuss, and iterate on the branch. The commits are the messy work-in-progress. When you merge, you squash — only the conclusion (the clean summary) goes to main. All the back-and-forth stays on the branch for reference but doesn't clutter the main narrative.

## Artifacts

Artifacts are structured pieces of information extracted from the conversation. Ideate supports six types:

| Type | What It Captures |
|---|---|
| **Feature** | Something the product does |
| **Decision** | A choice that was made, with context and rationale |
| **Constraint** | A technical, business, or design limit |
| **Persona** | Who uses this product and what they need |
| **Goal** | What success looks like |
| **Module** | A functional subsystem of the product |

### How Extraction Works

Artifacts are extracted in two ways:
1. **Conversationally** — Ideate recognizes when you've described something that fits a type and suggests capturing it.
2. **Explicitly** — You say "mark this as a feature" or "capture that as a decision."

### Mutable Artifacts

Each artifact is a single file in `.ideate/artifacts/`. If a branch discussion updates an existing artifact, the file is edited in place — it always reflects the latest state. The history of changes lives in the branch commit logs, not the artifact file.

### Provenance

Every artifact records where it was extracted:
```
Extracted from: payment-models, commit 3
Updated from: pricing-tiers, commit 2
```

This lets you trace back to the conversation that produced the artifact.

## Session Lifecycle

1. **Start** — run `/ideate`, provide a project name, begin talking
2. **Explore** — discuss ideas on main, branch off for tangents, merge conclusions back
3. **Extract** — artifacts are captured as ideas solidify
4. **Generate** — run `/ideate.doc` to produce the structured document
5. **Iterate** — update artifacts, merge more branches, regenerate the document

There's no formal "end" to a session. It's complete when you have the document you need.

## The .ideate/ Directory

All session state lives in `.ideate/` in your working directory. It's designed to be:
- **Hidden** — dot-prefixed so it doesn't clutter your project
- **Readable** — everything is Markdown, inspectable with any text editor
- **Portable** — commit it to git if you want version control, or `.gitignore` it if you don't
- **Deletable** — remove `.ideate/` to start completely fresh
