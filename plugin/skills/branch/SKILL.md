---
name: ideate.branch
description: Create a new ideation branch or switch to an existing one. Use when the user wants to explicitly branch to explore a tangent, or switch between branches. Arguments — branch name (optional for creation, required for switching).
context: fork
---

# Startup

1. Check if `.ideate/fork-brief.md` exists. If it does, read it to get `Topic`, `Why`, `Current thread`, `What we know so far`, `Key questions`, and the target line (one of `Refines:`, `New feature:`, or `Target: TBD`), then continue to step 2. If it does not exist (skill was invoked directly, not via the main `/ideate` skill), skip steps 2–4 and proceed directly to the main skill body below.
2. Read `.ideate/session.md` for current session state.
3. Delete `.ideate/fork-brief.md`.
4. Use the brief's fields to populate the branch file — `What we know so far` goes into `## Context`, `Why` goes into `## Why`, `Key questions` goes into `## Key Questions`, and the target line is copied verbatim into the branch header (see Create a New Branch below).

# Branch — Create or Switch Branches

This skill handles explicit branch operations. Most branching happens conversationally through the main `/ideate` skill's intent detection, but this command provides precision when needed.

## Usage

- `/ideate.branch <name>` — create a new branch with this name, or switch to it if it exists
- `/ideate.branch` — with no argument, list all branches and their statuses

## Create a New Branch

1. Read `.ideate/session.md` to confirm the session is active.
2. Slugify the branch name: lowercase, replace spaces with hyphens, strip special characters.
3. Check if `.ideate/branches/<branch-name>.md` already exists. If it does, switch to it instead (see below).
4. If a fork brief was read in Startup (step 1), skip this step — the `## Why`, `## Context`, and `## Key Questions` sections are already composed from the brief. If no fork brief was present, read `.ideate/main.md` and relevant artifacts to build scoped context, and ask the user what they want to explore (to populate `## Why` and `## Key Questions`).
5. Create `.ideate/branches/<branch-name>.md`:

```
# Branch: <branch-name>
Status: active
Created from: <current branch — usually "main">
<target line>
---

## Why
<Why this branch was created — the trigger or motivation. From fork brief's `Why` field, or a 1-2 sentence explanation if created directly.>

## Context
<A scoped summary of the relevant context from the current thread. This should be 2-5 sentences capturing what's relevant to this branch's topic — NOT a copy of the entire main thread.>

## Key Questions
- <question 1>
- <question 2>
```

Where `<target line>` is exactly one of:
- `Refines: [[Feature - X]]`
- `New feature: <name>`
- `Target: TBD`

If no fork brief was present (skill invoked directly, not via the main `/ideate` skill), ask the user: "Does this branch refine an existing feature, create a new one, or is it exploratory? (Reply with a feature name, `new: <name>`, or `exploratory`.)" Then use the appropriate target line.

6. Update `.ideate/session.md` — set `Active branch: <branch-name>`.
7. Tell the user: "Created branch `<branch-name>`. Run `/clear` then `/ideate` to start exploring it with clean context — just the branch brief, no main thread baggage."
8. **Stop here.** Do not continue the conversation. The branch was created, the fork-brief was consumed, and session.md points to the new branch. The user needs to `/clear` so the next `/ideate` invocation loads only the branch context from files. Continuing in the same conversation defeats the purpose of branching — the entire main thread discussion stays in the context window.

## Switch to an Existing Branch

1. Read `.ideate/session.md` to confirm the session is active.
2. Read `.ideate/branches/<branch-name>.md` to verify it exists and check its status.
3. If status is `merged` or `abandoned`, warn: "Branch `<name>` was already <merged/abandoned>. Want to reopen it, or create a new one?"
4. Update `.ideate/session.md` — set `Active branch: <branch-name>`.
5. Tell the user: "Switched to branch `<branch-name>`. Run `/clear` then `/ideate` to load it with clean context."
6. **Stop here.** Same as branch creation — the user needs `/clear` to drop the current conversation context. The branch file has everything needed for the next session.

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

When the user signals they are done with this branch (signals: "I'm done", "let's go back", "save this", "that's enough for now" — at the end of the branch session, not mid-conversation), write the final commit to the branch file, then say exactly (substituting `<branch-slug>` with the slug from this session):

> "Branch `<branch-slug>` saved. Run `/ideate` to return to the main thread, or `/ideate.merge` to bring these conclusions back."

Do not continue the conversation after this message. The main context resumes by re-reading `session.md`.
