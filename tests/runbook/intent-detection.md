# Manual Test: Intent Detection

## Purpose
Verify that the ideate orchestrator correctly detects and routes intents from conversational signals.

## Prerequisites
- Ideate plugin installed
- An active session with `.ideate/session.md` (`Status: active`, `Active branch: main`)

## Branch Intent Signals

Test each phrase. After each, verify Claude offers to branch or branches immediately.

| Input | Expected behavior |
|-------|-------------------|
| "Let's explore what happens if we go B2B instead" | Offers to branch or branches |
| "What if users could export to CSV?" | Offers to branch |
| "I'm curious about the pricing angle" | Offers to branch |
| "Could we think about an offline mode?" | Offers to branch |
| "What about the enterprise use case?" | Offers to branch |

**Verify for each:**
- [ ] Claude does not silently ignore the divergence
- [ ] Claude either branches immediately (explicit signal) or asks first (ambiguous signal)
- [ ] Branch file created with correct slug after confirmation

---

## Merge Intent Signals

With an active branch (not main), test each phrase:

| Input | Expected behavior |
|-------|-------------------|
| "OK let's go back to main" | Invokes merge |
| "Let's merge this" | Invokes merge |
| "I think we have something here" | Invokes merge |
| "Let's reconnect this to the main idea" | Invokes merge |

**Verify for each:**
- [ ] Branch merged and `Status: merged` set
- [ ] Conclusion written to `main.md`
- [ ] `Active branch: main` restored

---

## Abandon Intent Signals

| Input | Expected behavior |
|-------|-------------------|
| "This isn't going anywhere" | Confirms before abandoning |
| "Let's drop this thread" | Confirms before abandoning |
| "This was a dead end" | Confirms before abandoning |

**Verify:**
- [ ] Claude ALWAYS asks for confirmation before abandoning
- [ ] After confirmation, branch marked `abandoned`
- [ ] Nothing written to `main.md`

---

## Document Intent Signals

| Input | Expected behavior |
|-------|-------------------|
| "Let's generate the doc" | Invokes doc skill |
| "Write this up" | Invokes doc skill |
| "Give me the deliverable" | Invokes doc skill |
| "I'm ready for the output" | Invokes doc skill |

---

## Non-Triggering Phrases (Regression Test)

These should NOT trigger any sub-skill:

| Input | Expected: no skill invoked |
|-------|---------------------------|
| "What do you think about monetization?" | Normal conversational reply |
| "Can you elaborate on that point?" | Normal conversational reply |
| "That's interesting, tell me more" | Normal conversational reply |
