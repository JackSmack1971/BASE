# Security & Quality Gates

This reference defines the "Iron Gates" that every production-bound deployment must pass.

## 1. Production Code Audit Gate
- **Tool:** `.agent/skills/production-code-audit`
- **Condition:** MUST run on every PR affecting `src/backend`, `prisma/`, or `api/` routes.
- **Rules:**
    - Zero critical vulnerabilities (OWASP Top 10).
    - Compliance with `GEMINI.md` and `AGENTS.md` project-specific constraints.
    - No performance regressions in hot-path logic.

## 2. Playwright Visual Regression Gate
- **Tool:** `.agent/skills/playwright-visual-regression`
- **Condition:** MUST run on every PR affecting `src/components`, `src/app`, or `index.css`.
- **Shard Policy:** For large PRs (>20 components), split into 4+ shards to maintain <5min CI feedback.

## 3. TDD & Coverage Gate
- **Tool:** Vitest / Jest
- **Condition:** Coverage MUST NOT drop by >0.5% in any PR. 
- **Requirement:** New logic MUST match the `test-driven-development` skill's Iron Law: "No production code without a failing test first."

## 4. Convergent Release Gate
- **Policy:** The `semantic-versioning` skill handles the final stage.
- **Trigger:** Only after gates 1, 2, and 3 are successfully verified across the entire matrix.
- **Outcome:** A new Git tag is pushed, triggering the Vercel production edge-deployment of the audited codebase.
