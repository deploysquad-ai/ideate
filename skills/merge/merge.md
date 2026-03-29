---
name: ideate.merge
description: Squash-merge the current branch back to main, or abandon it. Compresses branch exploration into a conclusion with extracted artifacts. Use when the user is done exploring a tangent and wants to bring conclusions back to the main thread.
---

# Merge — Squash-Merge or Abandon a Branch

This skill handles merging a branch's conclusions back to the main thread, or abandoning a branch that didn't lead anywhere.

## Usage

- `/ideate.merge` — merge the current branch back to main
- `/ideate.merge abandon` — abandon the current branch

## Pre-Merge Checks

1. Read `.ideate/session.md` to get the active branch.
2. If `Active branch` is `main`, there's nothing to merge. Say: "You're already on main — no branch to merge."
3. Read the active branch file from `.ideate/branches/<branch-name>.md`.
4. If the branch has no commits beyond the initial context, warn: "This branch has no commits yet. Want to abandon it, or keep exploring?"

## Squash Merge

1. **Read the full branch file** to understand everything that was explored.
2. **Compose the conclusion.** Summarize the branch into:
   - A one-paragraph summary of what was explored and what was decided
   - A list of artifacts extracted or updated during this branch
3. **Write the merge commit** — append to the branch file:

```
## Commit <n> — Merge
**Conclusion:** <one paragraph summary of what was decided>
**Artifacts:** [[<Type> - <Name>]], [[<Type> - <Name>]], ...
```

4. **Update the branch status** — change the `Status:` line in the branch file header from `active` to `merged`.
5. **Append to main.md:**

```
## Merge: <branch-name>
<The conclusion paragraph from step 2>
Artifacts: [[<Type> - <Name>]], [[<Type> - <Name>]], ...
```

6. **Update session.md** — set `Active branch: main`.
7. **Tell the user:**
   > "Merged branch `<branch-name>` back to main.
   > **Conclusion:** <summary>
   > **Artifacts captured:** <list>
   > We're back on the main thread."
8. **Continue on main** — read `main.md` to have the full context of all merged conclusions.

## Abandon

1. **Confirm with the user:** "Abandon branch `<branch-name>`? Nothing from it will go to main."
2. If confirmed:
   - Append a final commit to the branch file:
   ```
   ## Commit <n> — Abandoned
   Branch abandoned by user. No conclusions merged to main.
   ```
   - Update branch status to `abandoned`.
   - Update `session.md` to set `Active branch: main`.
   - Check `.ideate/artifacts/` for any artifacts whose `Extracted from` references this branch and no other branch. Flag them to the user: "These artifacts were only extracted on the abandoned branch: <list>. Keep them or delete them?"
3. **Continue on main.**

## Empty Branch Merge

If you're asked to merge a branch that explored things but didn't reach a clear conclusion:

Say: "This branch explored <topic> but didn't reach a clear conclusion. I can either:
1. **Summarize what was learned** — merge the key findings even without a firm decision
2. **Abandon it** — drop it and move on

Which do you prefer?"

If they choose to summarize, compose a conclusion that honestly states what was explored without claiming a decision was made: "Explored X and Y approaches. Leaning toward X but no firm decision. Key considerations: ..."
