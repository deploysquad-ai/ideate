# Manual Test: Full Lifecycle

## Purpose
Verify the complete `/ideate` flow end-to-end across multiple conversation turns. Cannot be automated because it requires multi-turn conversation and intent detection.

## Prerequisites
- Ideate plugin installed and loaded in Claude Code
- A fresh scratch directory with git initialized

## Setup
```bash
mkdir /tmp/ideate-lifecycle && cd /tmp/ideate-lifecycle && git init
```

## Steps

### 1. Cold Start
Invoke: `/ideate`
Input: "A tool that helps developers track their decision log during a project"

**Verify:**
- [ ] `.ideate/session.md` created with `Active branch: main`
- [ ] `.ideate/main.md` created with `# Main Thread`
- [ ] Claude asks a probing question (does not dump a form)

---

### 2. Conversational Development
Continue the conversation across 3–5 turns. Explore the idea naturally.

**Verify after 2–3 turns:**
- [ ] Claude asks one question at a time (not multiple stacked)
- [ ] Claude surfaces at least one tension or ambiguity
- [ ] At least one artifact gets extracted (Claude announces: "I captured that as a [Type] artifact: '...'")
- [ ] Artifact file exists in `.ideate/artifacts/` with correct schema headers
- [ ] Artifact indexed in `session.md` under `## Artifact Index`

---

### 3. Branch
Say something like: "What if we made it open source — would that change the monetization model?"

**Verify:**
- [ ] Claude asks "Want to branch here?"
- [ ] After confirming: `.ideate/branches/open-source.md` (or similar slug) created
- [ ] `Active branch: open-source` in `session.md`
- [ ] `.ideate/fork-brief.md` does NOT exist (was consumed)

---

### 4. Explore Branch
Have 2–3 turns on the branch topic.

**Verify:**
- [ ] Branch file gains `## Commit N` entries at inflection points (not every turn)

---

### 5. Merge
Say: "OK, let's bring this back to the main thread."

**Verify:**
- [ ] Claude invokes `/ideate.merge`
- [ ] Branch file now says `Status: merged`
- [ ] `main.md` has `## Merge: open-source` section with a conclusion paragraph
- [ ] `Active branch: main` in `session.md`

---

### 6. Document
Say: "I think we're ready — let's generate the document."

**Verify:**
- [ ] File written to `.ideate/output/`
- [ ] Document contains sections derived from artifacts
- [ ] Document includes merged conclusions from `main.md`
- [ ] `Status: complete` in `session.md`

---

## Cleanup
```bash
rm -rf /tmp/ideate-lifecycle
```
