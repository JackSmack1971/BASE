---
name: agent-self-improvement-meta
description: Closed-loop self-improvement layer for the BASE agent framework. Orchestrates Audit → Propose → Verify → PR cycles using Mastra to evolve skills, documentation, and prompts autonomously while staying strictly within AGENTS.md guardrails.
Trigger on: "run self-improvement", "evolve skills", "meta-evolve", "improve agent OS", "fix doc rot autonomously", "self-healing meta loop"
---

# agent-self-improvement-meta

Synergizes with: documentation-rot-guard, vector-rag-pgvector, turborepo-monorepo-architect, refactor-legacy, tdd-enforcer, prompt-engineering, and semantic-versioning for true agentic self-evolution.

This skill implements the meta-layer logic for the BASE framework. It is responsible for monitoring the repository's health (via RAG indexing and link integrity audits) and autonomously proposing evolution sequences that resolve documented rot or complexity.

## AI Behavior Rules

- **LOW_DOC_COVERAGE**: Mastra 2026 graph patterns and simple-git PR creation may evolve; always verify latest API in `references/self-improvement-patterns.md` before production runs.
- **AUTHORITY_BOUNDARY**: Strictly limit autonomous changes to `.agents/skills/**` and related rule/reference files. Never modify application source code in `apps/` or `packages/` without explicit human intervention.
- **SAFE_PR_LOOP**: All evolution cycles MUST terminate in a Pull Request rather than a direct commit to `main`.
- **TDD_ENFORCEMENT**: Every self-healing proposal must be verified against the corresponding BDD spec/audit before the PR is submitted.
- **SYNERGY_PROTOCOL**: Utilize `vector-rag-pgvector` to identify conceptual overlap before proposing skill merges.

## Execution Steps

### 1. Repository Audit (Detection)
Run the `meta-evolve` task via Turborepo to trigger the documentation and prompt health scan.
Execute: npx turbo run docs-rot-audit

### 2. Evolution Proposal (Generation)
If the audit identifies issues (Broken Links, Semantic Drift > 0.4), invoke the `evolve.ts` script to generate a fix proposal.
Execute: node .agents/skills/agent-self-improvement-meta/scripts/evolve.js --dry-run

### 3. Verification Gate (Validation)
The Mastra workflow will automatically re-run the verification suite against the proposed changes in a temporary branch.

### 4. PR Submission (Delivery)
If verification passes, the workflow uses `simple-git` to push the feature branch and generate a PR link for human review.

## References
- [self-improvement-patterns.md](file:///c:/Users/click/Desktop/BASE_PROJECT/.agents/skills/agent-self-improvement-meta/references/self-improvement-patterns.md)
