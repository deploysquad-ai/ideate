# Example: Payments Platform

This walkthrough shows a complete ideation session for a hypothetical payments platform, demonstrating branching, artifact extraction, merging, and document generation.

## Starting the Session

```
User: /ideate
Ideate: What are you building? Give me the elevator pitch — or just start thinking out loud.

User: I'm thinking about a payments platform. Developers integrate via API,
      merchants use a dashboard to manage transactions. We need to handle
      PCI compliance somehow.
```

Ideate begins facilitating, asking probing questions about the target market, scale, and differentiation.

## First Artifacts Extracted

As the conversation develops, Ideate captures:

- **Persona - Developer** — integrates payments via API
- **Persona - Merchant** — manages transactions through a dashboard
- **Constraint - PCI compliance** — all card data handling must be PCI DSS compliant

## Branching: Payment Models

```
User: Let's explore what pricing model works best — I'm torn between
      flat-rate and usage-based.

Ideate: Creating branch `payment-models`. We're now exploring pricing
        in isolation from the main thread.
```

On the branch, the conversation explores:
- Commit 1: Comparing flat-rate vs usage-based vs hybrid models
- Commit 2: Analyzing competitor pricing (Stripe, Square, Adyen)
- Commit 3: User decides on hybrid — base fee + transaction percentage

```
User: OK I think we've landed on hybrid. Let's go back to main.

Ideate: Merged branch `payment-models` back to main.
        Conclusion: Hybrid pricing — $29/mo base + 2.9% per transaction.
        Artifacts captured: Feature - Hybrid pricing, Decision - Pricing model
```

## Branching: Authentication

```
User: What if we sidebar on auth real quick?

Ideate: Creating branch `auth-approach`.
```

- Commit 1: Evaluating OAuth vs API keys vs both
- Commit 2: Decision — API keys for developers, OAuth for merchant dashboard

```
User: That's settled, merge it.
```

## Generating the Document

```
User: /ideate.doc

Ideate: Document generated at .ideate/output/payments-platform.md.
        Summary: 12 artifacts (8 confirmed, 4 draft).
        Note: No goals were explicitly captured — the document won't
        have a "what does success look like" section.
```

The generated document includes sections for Personas, Constraints, Decisions, Features, and Modules — all assembled from the artifacts extracted during the session.

## Session State After

```
.ideate/
  session.md                          # Status: complete
  main.md                             # 2 merged conclusions
  branches/
    payment-models.md                 # Status: merged, 3 commits
    auth-approach.md                  # Status: merged, 2 commits
  artifacts/
    Persona - Developer.md
    Persona - Merchant.md
    Constraint - PCI compliance.md
    Feature - Hybrid pricing.md
    Decision - Pricing model.md
    Decision - Auth approach.md
    ... (6 more artifacts)
  output/
    payments-platform.md              # The deliverable
```
