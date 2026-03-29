# Getting Started

## Installation

```bash
claude plugin add ideate
```

## Your First Session

1. Open your terminal and navigate to any directory:
   ```bash
   mkdir my-project && cd my-project
   ```

2. Start an ideation session:
   ```
   /ideate
   ```

3. Ideate will ask what you're building. Just start talking:
   > "I'm thinking about a tool that helps freelancers track time and send invoices. Something simple — not like Harvest or FreshBooks, more like a command-line thing that just works."

4. Ideate will ask probing questions, help you explore different angles, and extract artifacts as your ideas solidify.

## Branching

When you want to explore a tangent:
> "Let's dig into the invoicing part separately"

Ideate creates a branch. Everything you discuss stays isolated until you're ready to merge back:
> "OK, I think we've figured out the invoicing model. Let's go back to main."

## Extracting Artifacts

As ideas take shape, Ideate captures them:
> Ideate: "It sounds like you're describing a constraint — no cloud dependency, everything runs locally. Should I capture that?"

You can also be explicit:
> "Mark that as a feature — recurring invoice templates"

## Generating the Document

When you're ready for the deliverable:
```
/ideate.doc
```

Ideate assembles all artifacts and conclusions into a structured Markdown document at `.ideate/output/`.

## Resuming a Session

Next time you enter the same directory and run `/ideate`, it will detect the existing session and offer to resume.

## What Gets Created

Ideate stores everything in `.ideate/` — a hidden directory in your project:

```
.ideate/
  session.md        — project name, status, active branch
  main.md           — chronological log of merged conclusions
  branches/         — one file per branch with commit history
  artifacts/        — one file per extracted artifact
  output/           — your generated document
```

Everything is plain Markdown. You can read it, edit it, or delete it with any tool.
