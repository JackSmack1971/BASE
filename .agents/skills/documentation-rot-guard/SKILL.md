---
name: documentation-rot-guard
description: Detects documentation rot using semantic drift (pgvector + ast-grep) and generates draft fixes for TypeScript/Next.js/Turborepo codebases. Proactive CI gate with bidirectional sync.
Trigger on: "check documentation rot", "audit docs", "fix doc drift", "run docs consistency check", "self-documenting codebase", "detect stale docs"
---

# documentation-rot-guard

Synergizes with: vector-rag-pgvector, turborepo-monorepo-architect, refactor-legacy, tdd-enforcer, prompt-engineering, context-compact, and semantic-versioning for a truly self-maintaining codebase.

## Trigger Phrases
- "check documentation rot"
- "audit the technical documentation"
- "fix semantic drift between code and docs"
- "run documentation consistency check"
- "self-documenting codebase scan"

## Prerequisites
- `vector-rag-pgvector` skill active and indexed.
- `TypeDoc` installed for project metadata extraction.
- `ast-grep` (sg) for structural code-comment audits.
- Monorepo structure managed by `turborepo-monorepo-architect`.

## Core Workflows

### 1. Structural Audit (ast-grep)
Find "syntactic rot" where documentation comments no longer match the code structure.
- **Param Mismatch:** Use `ast-grep` rules (relational `has` + `precedes`) to identify functions where JSDoc `@param` tags do not match the actual function signature.
- **Missing Docs:** Surface public exports (classes, methods, interfaces) in `packages/` that lack any documentation.
- **Broken References:** Run `markdown-link-check` across the `apps/` and `packages/` directories to catch stale internal links.

### 2. Semantic Drift Scoring (pgvector)
Find "conceptual rot" where the intent of the documentation has drifted from the code's implementation.
- **Extraction:** Run `typedoc --json` to extract project reflections.
- **Drift Calculation:** Compare the embeddings of the current code implementation against the stored vectors of the READMEs/API references using **Vector Distance (Cosine Similarity)**.
- **Confidence Scoring:** High distance (>0.25) indicates "Critical Rot." The agent flags these for bidirectional review.

### 3. Bidirectional Sync & Draft Generation
Resolve discrepancies without premature auto-applying.
- **Human-in-the-Loop:** For every drift, ask: *"Did you mean to update the API behavior (code update) or the description (docs update)?"*
- **Drafting (.docs-fix/):** Create a shadowed `.docs-fix/` directory containing the proposed markdown diffs or updated JSDoc blocks.
- **PR Readiness:** Prepare a structured audit report summarizing confidence scores and proposed changes, ready for a PR review.

### 4. Proactive CI Gating (Turborepo)
Turns documentation maintenance into a hard quality gate.
- **Incremental Audit:** Use `turbo run docs-rot-audit --affected` to only scan packages touched in the current Branch/PR.
- **Failure Gate:** Configure the `turbo.json` task to exit with code 1 if a "Critical Rot" score (>0.35) is detected, blocking the merge until the docs are synced.

## AI Behavior Rules
- **NEVER** apply fixes directly to production source files; always output to `.docs-fix/` or a temporary PR branch.
- **ALWAYS** treat the code as the source of truth for parameter renames, but treat the spec/ADR as truth for business logic requirements.
- **STRICTLY** check the `vector-rag-pgvector` index before reporting a drift to ensure the "Rot" isn't just an indexing delay.
- **ONLY** recommend a docs rewrite if the drift score is consistently high across multiple related symbols.
- **LOW_DOC_COVERAGE:** Storybook-specific AST resolution may vary by framework; verify `.stories.tsx` patterns manually if confidence is low.

## Turborepo Integration Pattern
Add this task to your root `turbo.json` for proactive gating:
```json
"docs-rot-audit": {
  "dependsOn": ["^build", "index-rag"],
  "inputs": ["src/**/*.ts", "src/**/*.tsx", "README.md", "docs/**/*.md"],
  "cache": true
}
```
