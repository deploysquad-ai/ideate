---
name: ideate.branch
description: Create a new ideation branch or switch to an existing one. Use when the user wants to explicitly branch to explore a tangent, or switch between branches. Arguments — branch name (optional for creation, required for switching).
context: fork
---

## Startup

1. Read `.ideate/fork-brief.md` to get `Topic`, `Why`, `Current thread`, `What we know so far`, and `Key questions`.
2. Read `.ideate/session.md` for current session state.
3. Delete `.ideate/fork-brief.md`.
4. Use the brief's `What we know so far` and `Key questions` as the branch's opening context — write it to the branch file under `## Context` (see Create a New Branch below).

# Branch — Create or Switch Branches

This skill handles explicit branch operations. Most branching happens conversationally through the main `/ideate` skill's intent detection, but this command provides precision when needed.

## Usage

- `/ideate.branch <name>` — create a new branch with this name, or switch to it if it exists
- `/ideate.branch` — with no argument, list all branches and their statuses

## Create a New Branch

1. Read `.ideate/session.md` to confirm the session is active.
2. Slugify the branch name: lowercase, replace spaces with hyphens, strip special characters.
3. Check if `.ideate/branches/<branch-name>.md` already exists. If it does, switch to it instead (see below).
4. Read `.ideate/main.md` and relevant artifacts to build scoped context for the branch.
5. Create `.ideate/branches/<branch-name>.md`:

```
# Branch: <branch-name>
Status: active
Created from: <current branch — usually "main">
---

## Context
<A scoped summary of the relevant context from the current thread. This should be 2-5 sentences capturing what's relevant to this branch's topic — NOT a copy of the entire main thread.>
```

6. Update `.ideate/session.md` — set `Active branch: <branch-name>`.
7. Tell the user: "Created branch `<branch-name>`. We're now exploring this topic in isolation — nothing here touches the main thread until you merge."
8. Continue the conversation scoped to the branch topic.

## Switch to an Existing Branch

1. Read `.ideate/session.md` to confirm the session is active.
2. Read `.ideate/branches/<branch-name>.md` to verify it exists and check its status.
3. If status is `merged` or `abandoned`, warn: "Branch `<name>` was already <merged/abandoned>. Want to reopen it, or create a new one?"
4. Update `.ideate/session.md` — set `Active branch: <branch-name>`.
5. Read the branch file to restore context. Summarize where the branch left off.
6. Tell the user: "Switched to branch `<branch-name>`. Here's where we left off: <summary>."

## List Branches

If invoked with no argument:
1. Read all files in `.ideate/branches/`.
2. For each, read the first few lines to get the name and status.
3. Present a table:

```
Branch              Status      Commits
payment-models      active      3
auth-approach       merged      5
dark-mode           abandoned   2
```

4. Ask: "Switch to one, or create a new branch?"

## Committing to a Branch

While on a branch, the main `/ideate` skill handles committing key actions. A commit is appended to the branch file when:
- A significant direction is explored
- A decision is reached
- An artifact is identified or updated
- Research findings are recorded

Commit format — append to the branch file:

```
## Commit <n>
<Description of what happened in this action — not the raw conversation, but the meaningful outcome.>
```

Not every conversational turn is a commit. Only inflection points — moments where the direction, understanding, or artifact set changed.

## Return to Main Context

When the user signals they are done with this branch (signals: "I'm done", "let's go back", "save this", "that's enough for now"), write the final commit to the branch file, then say exactly:

> "Branch `<slug>` saved. Run `/ideate` to return to the main thread, or `/ideate.merge` to bring these conclusions back."

Do not continue the conversation after this message. The main context resumes by re-reading `session.md`.
