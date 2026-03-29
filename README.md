<p align="center">
  <img src="assets/brand/logo-mark.svg" alt="ideate" width="480">
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT License"></a>
  <img src="https://img.shields.io/badge/version-0.1.0-green.svg" alt="Version 0.1.0">
  <img src="https://img.shields.io/badge/Claude_Code-plugin-8A2BE2.svg" alt="Claude Code Plugin">
</p>

---

<table>
<tr>
<th width="50%">What's in your head</th>
<th width="50%">What Ideate produces</th>
</tr>
<tr>
<td>

*"So it's like a payments thing... maybe freemium? Or flat rate. Actually we need OAuth first. Wait, who's even using this — developers? Small businesses? Both? And there's a compliance thing someone mentioned..."*

</td>
<td>

```markdown
# Payments Platform — Project Brief

## Goals
- Launch MVP in Q3 targeting SMB merchants

## Personas
- Small business owner (non-technical)
- Developer integrating via API

## Features
- Freemium tier with usage-based pricing
- OAuth2 via Google/GitHub
- Merchant dashboard with real-time analytics

## Decisions
- Freemium over flat-rate (validated via branch)
- OAuth-only, no email/password (security)

## Constraints
- PCI DSS compliance required at launch
```

</td>
</tr>
</table>

## Install

```bash
claude plugin add ideate
```

Then navigate to any project directory and run `/ideate`.

## See It In Action

```
You:  I want to build a payments platform for small businesses

  Ideate: Got it. I've started a session for "Payments Platform."
  What kind of businesses are you targeting?

You:  Mostly restaurants and retail. But I'm torn on the pricing model —
      should it be freemium or flat monthly?

  Ideate: That's worth exploring. I'll branch into "pricing-model" so we
  can think through this without losing the main thread.

  [branch: pricing-model]

You:  Freemium makes sense for acquisition, but flat-rate is simpler...
      actually, what if we do freemium with usage-based pricing above
      a threshold?

  Ideate: That's a strong hybrid. I'm extracting this as a decision:
  ✓ Decision — "Freemium with usage-based pricing"
  Ready to merge this back?

You:  Yeah, merge it.

  Ideate: Merged. I also noticed a feature forming — extracting:
  ✓ Feature — "Tiered pricing engine"
  Back on main. What about authentication?
```

No special syntax. No forms. Just talk through your idea — Ideate handles the structure.

## How It Works

<table>
<tr>
<td width="33%" align="center">
<h3>Branch</h3>
<p>Explore tangents in isolation. Like git branches for your thinking — merge the conclusions, abandon the dead ends.</p>
</td>
<td width="33%" align="center">
<h3>Extract</h3>
<p>As ideas solidify, Ideate pulls out typed artifacts: features, decisions, constraints, personas, goals, and modules.</p>
</td>
<td width="33%" align="center">
<h3>Document</h3>
<p>Run <code>/ideate.doc</code> to assemble everything into a structured brief you can hand off, share, or build from.</p>
</td>
</tr>
</table>

### Branching model

When your thinking diverges, Ideate creates a branch — an isolated thread where you can explore without polluting the main conversation.

```
Main thread: "Building a payments platform..."
  └── pricing-model
  │   ├── Exploring freemium vs flat-rate
  │   ├── Landed on freemium with usage tiers
  │   └── ✓ Merged → Decision + Feature extracted
  └── auth-approach
      ├── OAuth vs email/password
      └── ✓ Merged → "OAuth2 via Google/GitHub only"
```

### Artifact types

| Type | What it captures |
|---|---|
| **Feature** | What the product does |
| **Decision** | What was decided and why |
| **Constraint** | Technical or business limits |
| **Persona** | Who uses this |
| **Goal** | What success looks like |
| **Module** | Functional subsystems |

Artifacts are stored as individual markdown files in `.ideate/artifacts/` — human-readable, diffable, always current.

## Commands

| Command | Purpose |
|---|---|
| `/ideate` | Start or resume a session |
| `/ideate.branch <name>` | Create or switch branches |
| `/ideate.merge` | Merge current branch to main |
| `/ideate.doc` | Generate the session document |
| `/ideate.research <topic>` | Research similar products and prior art |

Most of the time you won't need these — Ideate detects your intent conversationally.

## Session Data

All state lives in `.ideate/` as plain markdown. Browse it, edit it, or delete it with any text editor.

```
.ideate/
  session.md        — session metadata
  main.md           — merged conclusions
  branches/         — branch history (append-only)
  artifacts/        — extracted artifacts (mutable, always current)
  output/           — generated documents
```

## Why This Exists

The gap between "I have an idea" and "here's a document someone else can act on" is where most projects lose momentum. You either skip straight to building (and discover missing requirements later) or spend days writing specs that nobody reads.

Ideate fills that gap. Talk through your idea like you would with a coworker. Walk away with a structured brief.

## Documentation

- [Getting Started](docs/getting-started.md)
- [Concepts](docs/concepts.md) — branching, artifacts, session lifecycle
- [Skills Reference](docs/skills-reference.md) — detailed command docs
- [Example: Payments Platform](docs/examples/payments-platform.md) — full walkthrough

## Contributing

Ideate is open source under the MIT License. See [CLAUDE.md](CLAUDE.md) for development guidelines.

## License

MIT
