# Skills Reference

## /ideate

**Start or resume an ideation session.**

Usage: `/ideate`

When invoked in a directory without `.ideate/`, creates a new session. When `.ideate/` exists, offers to resume or start fresh.

The main skill remains active throughout the session — facilitating conversation, detecting intent (branching, merging, research), and extracting artifacts as ideas solidify. Most operations happen through natural conversation rather than explicit commands.

### What It Creates
- `.ideate/session.md` — session metadata
- `.ideate/main.md` — main branch log
- `.ideate/branches/` — branch directory
- `.ideate/artifacts/` — artifact directory
- `.ideate/output/` — output directory

### What It Reads
- `session.md` on every turn for session state
- `main.md` when context about past decisions is needed
- Artifact files when checking for duplicates or providing context

### What It Writes
- `session.md` (creates, updates active branch)
- `main.md` (creates)
- Artifact files in `.ideate/artifacts/` (creates, updates)

---

## /ideate.branch

**Create or switch branches.**

Usage:
- `/ideate.branch <name>` — create branch or switch to existing
- `/ideate.branch` — list all branches

When creating a branch, Ideate summarizes the relevant context from the current thread and starts a scoped conversation. When switching, it reads the branch file and resumes from the last commit.

### What It Reads
- `session.md` for current state
- `main.md` for context scoping
- Branch files in `.ideate/branches/`

### What It Writes
- New branch file in `.ideate/branches/`
- Updates `session.md` (active branch)

---

## /ideate.merge

**Squash-merge or abandon the current branch.**

Usage:
- `/ideate.merge` — merge current branch to main
- `/ideate.merge abandon` — abandon current branch

On merge, compresses the branch into a conclusion (one paragraph + artifact list), writes it to both the branch file (as a merge commit) and `main.md`, then switches back to main.

On abandon, marks the branch as abandoned and switches to main. Nothing goes to `main.md`.

### What It Reads
- `session.md` for active branch
- Active branch file for full history

### What It Writes
- Branch file (final commit + status update)
- `main.md` (append merge summary — merge only)
- `session.md` (switch to main)

---

## /ideate.doc

**Generate the session document.**

Usage: `/ideate.doc`

Reads all artifacts and the main log, assembles a structured Markdown document grouped by artifact type, and writes it to `.ideate/output/`. Flags unconfirmed (draft) artifacts and warns about missing sections.

Regenerable — run again after changes to get an updated document.

### What It Reads
- `session.md` for project name
- All files in `.ideate/artifacts/`
- `main.md` for the narrative arc

### What It Writes
- `.ideate/output/<project-name>.md`
- Updates `session.md` status to `complete`

---

## /ideate.research

**Research similar products and prior art.**

Usage:
- `/ideate.research <topic>` — research a specific topic
- `/ideate.research` — research current branch topic or project

Uses web search to find relevant external context. Synthesizes findings in the context of the current thread rather than dumping raw results. If on a branch, records findings as a commit.

Does NOT auto-extract artifacts from research — you decide what's worth keeping.

### What It Reads
- `session.md` for current context
- Active branch file (if on a branch)

### What It Writes
- Branch file (appends research commit — branch only)
