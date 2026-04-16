---
name: ideate.merge
description: Squash-merge the current branch back to main, or abandon it. Compresses branch exploration into a conclusion with extracted artifacts. Use when the user is done exploring a tangent and wants to bring conclusions back to the main thread.
context: fork
---

# Startup

1. Check if `.ideate/fork-brief.md` exists. If it does, read it to get `Operation` (merge or abandon), `Branch` slug, `Branched from`, and `Merge target`, then continue to step 2. If it does not exist (skill was invoked directly), skip step 2 and proceed to the main body below.
2. Delete `.ideate/fork-brief.md`.
3. If `Operation` is `abandon`, skip Pre-Merge Checks and Squash Merge — proceed directly to the `## Abandon` section. If `Operation` is `merge` or no fork brief was present, proceed with Pre-Merge Checks as normal.

# Merge — Squash-Merge or Abandon a Branch

This skill handles merging a branch's conclusions back to the main thread, or abandoning a branch that didn't lead anywhere.

## Usage

- `/ideate.merge` — merge the current branch back to main
- `/ideate.merge abandon` — abandon the current branch

## Pre-Merge Checks

1. If a fork brief was read in Startup, use the `Branch` slug from the brief. Also read `.ideate/session.md` to verify session state. If no fork brief was present, read `.ideate/session.md` to get the active branch.
2. If `Active branch` is `main`, there's nothing to merge. Say: "You're already on main — no branch to merge."
3. Read the active branch file from `.ideate/branches/<branch-name>.md`.
4. Check the branch header's `Status:` line. If it is already `merged`, warn: "Branch `<name>` is already merged. Continuing will produce a duplicate merge commit. Abort?" Abort by default; proceed only if the user explicitly confirms they want to continue.
5. If the branch has no commits beyond the initial context, warn: "This branch has no commits yet. Want to abandon it, or keep exploring?"

## Squash Merge

1. **Read the full branch file** to understand what was explored. Parse the header (the frontmatter block before the `---` separator) to find the target line: one of `Refines: [[Feature - X]]`, `New feature: <name>`, or `Target: TBD`.

2. **Resolve the reconciliation target.**
   - If the header has `Target: TBD`: ask the user — "This branch didn't declare a target feature. Based on what was explored, should it update an existing feature (reply with the feature name), create a new feature (reply `new: <name>`), or skip reconciliation (reply `skip`)?" Then proceed with the user's choice as `Refines`, `New feature`, or skip.
   - If `Refines: [[Feature - X]]` and `.ideate/artifacts/Feature - X.md` exists: read that file. Proceed to step 3.
   - If `Refines: [[Feature - X]]` and the file is missing: see Edge Cases.
   - If `New feature: Foo` and `.ideate/artifacts/Feature - Foo.md` does not exist: prepare an empty PRD template with name `Foo`. Proceed to step 3.
   - If `New feature: Foo` and the file already exists: see Edge Cases.
   - If user chose `skip` (from `Target: TBD` path): skip to step 6 (no reconciliation).

3. **Gather branch artifacts.** Scan `.ideate/artifacts/` for every file where the `Extracted from:` line references this branch slug. Collect Decision, Constraint, Persona, Goal, and Module artifacts. These are the reconciliation inputs along with the full branch log. If this scan yields zero artifacts, see the "Branch produced no decision/constraint artifacts" entry in the Edge Cases section before proceeding to step 4.

4. **Produce reconciled feature doc and refinement file (LLM pass).** With three inputs — current feature doc (or empty PRD template), full branch log, and the artifacts from step 3 — produce two outputs:

   **(a)** Updated `.ideate/artifacts/Feature - <Name>.md` following the PRD schema from the Feature artifact section of `skills/ideate/SKILL.md`. Rules:
   - Preserve existing content not affected by this branch — do not regenerate from scratch.
   - Fold branch decisions into `## Behavior`, `## Data / Schema`, `## Decisions`.
   - Close Open Questions this branch answered — move them into `## Decisions` with the answer, and remove from `## Open Questions`. Add new questions raised on this branch to `## Open Questions`.
   - If `Status:` was `draft`, change to `reconciled`. If already `reconciled`, leave as `reconciled`.
   - Bump `Version: v<N>`: for a greenfield new feature (no prior file), set to `v1`; otherwise read the current version and add 1.
   - Set `Last merged: <branch-slug> (<date>)`.
   - If no `Refined by:` field exists in the current feature doc (first reconciliation of a drafted feature), create the field and seed it with the original extraction as `  - v1: [[<thread from `Extracted from:`>]] (<date from `Extracted from:`>)` before appending the new v<N> line below.
   - Append a line under `Refined by:` — `  - v<N>: [[<branch-slug>]] (<date>)`.

   **(b)** New `.ideate/artifacts/Feature - <Name>.v<N>.refinements.md` following the Refinement File Schema (see below, after this section).

5. **Show the diff and refinement file to the user.** Present both:
   - A unified diff of `Feature - <Name>.md` (or the full content for a greenfield feature).
   - The full content of `Feature - <Name>.v<N>.refinements.md`.

   Ask exactly: "Approve, edit, or discard reconciliation?"

   Handle the response:
   - **Approve** → write both files to disk. Proceed to step 6.
   - **Edit** → user provides corrections (inline text, a replacement section, or specific fixes). Re-run step 4 with the corrections as an additional input. Loop back to step 5 to show the revised diff.
   - **Discard** → skip writing the feature doc and refinement file. Warn: "Feature - <Name> will not reflect this branch's decisions; it will be stale until a future merge reconciles it." Proceed to step 6 without reconciliation.

6. **Compose a squash conclusion — decisions only, not a retelling.** Write:
   - 2–4 sentences: what question was explored, what was decided, and why. Do not narrate the exploration journey or list what was considered step-by-step. Write it like a commit message, not a story.
   - A list of artifacts extracted or updated during this branch.

7. **Write the merge commit** — append to the branch file:

```
## Commit <n> — Merge
**Conclusion:** <one paragraph summary of what was decided>
**Reconciled:** [[Feature - <Name>]] → v<N>
**Refinement:** [[Feature - <Name>.v<N>.refinements]]
**Artifacts:** [[<Type> - <Name>]], [[<Type> - <Name>]], ...
```

   If reconciliation was skipped or discarded, omit the `Reconciled:` and `Refinement:` lines.

8. **Update the branch status** — change the `Status:` line in the branch file header from `active` to `merged`.

9. **Append to main.md:**

```
## Merge: <branch-name> (<date>)
<The 2–4 sentence squash conclusion from step 6 — decisions and rationale only>

Reconciled: [[Feature - <Name>]] → v<N>
Refinement: [[Feature - <Name>.v<N>.refinements]]
Artifacts: [[<Type> - <Name>]], [[<Type> - <Name>]], ...
```

   If reconciliation was skipped or discarded, omit the `Reconciled:` and `Refinement:` lines.

10. **Update session.md** — set `Active branch: main`.

11. **Tell the user.** If reconciliation occurred:
    > "Merged branch `<branch-name>` back to main.
    > **Conclusion:** <summary>
    > **Feature reconciled:** [[Feature - <Name>]] → v<N>. <N> decisions folded in, <M> questions closed, <K> added.
    > **Refinement file:** [[Feature - <Name>.v<N>.refinements]]
    > **Artifacts captured:** <list>
    > Run `/clear` then `/ideate` to continue on main with clean context — just the merged conclusions, no branch exploration history."

    If reconciliation was skipped or discarded:
    > "Merged branch `<branch-name>` back to main.
    > **Conclusion:** <summary>
    > **Artifacts captured:** <list>
    > Reconciliation was skipped — feature docs were not updated.
    > Run `/clear` then `/ideate` to continue on main with clean context."

12. **Stop here.** Do not continue the conversation. The merge is complete, main.md has the squash conclusion, and session.md points to main. The user needs to `/clear` so the next `/ideate` invocation loads only `session.md` + `main.md` — not the full branch discussions that are still in the context window.

## Refinement File Schema

Every reconciled merge writes a `.vN.refinements.md` sibling to the canonical feature file. Naming pattern:

```
.ideate/artifacts/
  Feature - <Name>.md                      ← canonical, always current
  Feature - <Name>.v1.refinements.md       ← what v0 → v1 changed (initial reconciliation from draft)
  Feature - <Name>.v2.refinements.md       ← what v1 → v2 changed
```

Refinement files are **append-once**: never modified after they're written. They are a per-version record of what a specific branch merge did to the feature.

Template — fill sections that apply, omit empty ones:

```markdown
# Feature - <Name> — Refinement v<N>

Merged from: [[<branch-slug>]]
Date: <ISO date>
Previous version: v<N-1>

## Summary
<1–2 sentences on what this refinement changed at a high level.>

## Changes

### Behavior — Added
- <new behavior>

### Behavior — Modified
- <behavior>: <before> → <after>

### Behavior — Removed
- <removed behavior>

### Decisions folded in
- [[Decision - X]]
- [[Decision - Y]]

### Constraints added
- [[Constraint - Z]]

### Open Questions — Resolved
- "<question text>" → [[Decision - X]]

### Open Questions — Added
- <new question>

## Diff
<unified diff of Feature - <Name>.md before → after this merge. For a greenfield v1, use the full contents of the new file as the diff.>
```

Omit `Previous version:` for a greenfield v1 refinement.

## Edge Cases

**Branch targets a non-existent feature.** Header has `Refines: [[Feature - X]]` but `Feature - X.md` does not exist in `.ideate/artifacts/`. Ask the user: "Branch targets [[Feature - X]] but no such file exists. Treat as a new feature and create it, or cancel the merge?" If the user chooses to create, proceed as if the target were `New feature: X`.

**Greenfield feature name collision.** Header has `New feature: Foo` but `Feature - Foo.md` already exists. Ask the user: "Feature - Foo already exists. Refine it instead (treat this branch as `Refines: [[Feature - Foo]]`), or cancel the merge so the branch target can be renamed?"

**User edited the feature doc manually between merges.** Reconciliation uses the current on-disk doc as its base, not a regeneration from scratch. Manual edits survive unless they contradict new branch decisions. When they do contradict, the conflict appears in the step 5 diff; the user resolves at the approve/edit/discard gate.

**Branch produced no decision/constraint artifacts** (pure exploration). Reconciliation is a near-no-op: the refinement file's Changes sections will all be empty. Before running step 4, check: if step 3 produced zero artifacts, ask the user: "This branch produced no decision or constraint artifacts. Skip reconciliation, or proceed anyway (refinement file will record only a version bump)?" Default to skip.

**Same branch merged twice.** Not expected (step 8 flips `Status:` to `merged`). If forced (user reopens a merged branch and runs merge again), detect status in the pre-merge checks and warn: "Branch `<name>` is already merged. Continuing will produce a duplicate merge commit. Abort?"

**`Target: TBD` and user picks skip.** Branch merges with no feature touched. The merge commit on the branch file, main.md entry, and final user message all omit the `Reconciled:` and `Refinement:` lines. No feature doc is updated.

## Abandon

1. **Confirm with the user** (if invoked directly, no fork brief): "Abandon branch `<branch-name>`? Nothing from it will go to main." If invoked via fork brief, skip this confirmation — it was already confirmed by the main `/ideate` skill before the brief was written.
2. If confirmed:
   - Append a final commit to the branch file:
   ```
   ## Commit <n> — Abandoned
   Branch abandoned by user. No conclusions merged to main.
   ```
   - Update branch status to `abandoned`.
   - Update `session.md` to set `Active branch: main`.
   - Check `.ideate/artifacts/` for any artifacts whose `Extracted from` references this branch and no other branch. Flag them to the user: "These artifacts were only extracted on the abandoned branch: <list>. Keep them or delete them?"
3. **Tell the user:**
   > "Branch `<branch-name>` abandoned. Run `/clear` then `/ideate` to continue on main with clean context."
4. **Stop here.** Same as merge — the user needs `/clear` to drop the branch exploration from the context window.

## Empty Branch Merge

If you're asked to merge a branch that explored things but didn't reach a clear conclusion:

Say: "This branch explored <topic> but didn't reach a clear conclusion. I can either:
1. **Summarize what was learned** — merge the key findings even without a firm decision
2. **Abandon it** — drop it and move on

Which do you prefer?"

If they choose to summarize, compose a conclusion that honestly states what was explored without claiming a decision was made: "Explored X and Y approaches. Leaning toward X but no firm decision. Key considerations: ..."

## Return to Main Context

**Regardless of invocation path (fork brief or direct):** After completing the merge or abandon, the conversation should stop. The user runs `/clear` then `/ideate` to continue on main with clean context.

Do not return a conclusion to a calling skill for it to continue with. Do not resume ideation in the same conversation. The files are the handoff — main.md has the squash conclusion, session.md points to main, and the next `/ideate` invocation will load only what's needed.
