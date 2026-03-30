---
name: ideate.research
description: Research similar products, prior art, and competitive landscape for the current ideation topic. Use when the user wants external context to inform a decision or validate an assumption.
---

# Research — External Context for Ideation

This skill searches for similar products, prior art, and relevant information to ground the ideation session in reality.

## Usage

- `/ideate.research <topic>` — research a specific topic
- `/ideate.research` — research the current branch topic or overall project

## Research Process

1. **Determine the research scope.**
   - If a topic is provided, use it directly.
   - If on a branch, use the branch topic as the default scope.
   - If on main with no topic, ask: "What should I research? Some options: similar products, technical approaches, market landscape, or a specific question."

2. **Conduct the search.** Use the WebSearch tool to find relevant information. Run 2-3 searches with different angles:
   - Direct competitors or similar products
   - Technical approaches or architectural patterns
   - Market landscape or user expectations

3. **Synthesize findings.** Summarize what you found in the context of the current ideation thread. Don't dump raw search results — interpret them:
   - "There are 3 existing tools that do something similar: X, Y, Z. Here's how they differ from what you're describing..."
   - "The common technical approach for this is... but your constraint around X means you'd need to..."
   - "No direct competitors found — this appears to be a relatively unexplored space, though A and B solve adjacent problems."

4. **Flag relevant discoveries.** If research reveals something that should inform a decision or constraint, call it out:
   - "This research suggests a potential constraint: most payment APIs require PCI compliance. Should I capture that?"

5. **Record on branch.** If currently on a branch, append a commit to the branch file:

```
## Commit <n> — Research
**Topic:** <what was researched>
**Key findings:**
- <finding 1>
- <finding 2>
- <finding 3>
**Implications for this branch:** <how findings affect the current exploration>
```

6. **Do NOT auto-extract artifacts.** Research findings inform the conversation — they don't automatically become artifacts. If the user wants to capture something from the research, they'll say so (or you can suggest it).

## Research Scope

Keep research focused and relevant:
- **Do:** Search for similar products, technical approaches, market data, pricing models, user expectations
- **Do:** Look for prior art that validates or challenges the user's assumptions
- **Don't:** Conduct exhaustive market analysis — this is ideation, not due diligence
- **Don't:** Research implementation details (libraries, APIs) — that comes after ideation
- **Don't:** Spend more than 2-3 search queries per research request — summarize what you find and let the user decide if they need more
