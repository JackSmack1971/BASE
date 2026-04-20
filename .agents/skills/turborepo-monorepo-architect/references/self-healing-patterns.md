## Pattern: The "Drift-Free" Agent
The agent monitors workspace consistency through these heuristic gates:

### Gate 1: Phantom Dependency Check
If an import is found from an internal package (e.g., `@repo/utils`) but is NOT listed in the `dependencies` of the current `package.json`, the agent must immediately flag a "Workspace Boundary Violation" and add the missing package.

### Gate 2: Version Sync Audit
Triggered when adding any external dependency.
```bash
pnpm syncpack list-mismatches
```
If mismatches exist (e.g. `zod@3.22` in `apps/web` but `zod@3.20` in `packages/api`), the agent should propose a resolution commit to unify at the highest stable version.

### Gate 3: RAG-Backed Documentation Indexing
Every `turbo run build` should be followed by a `turbo run index-rag`.
- **Purpose:** Update the `vector-rag-pgvector` embeddings with updated function signatures and API exports.
- **Synergy:** This ensures that subsequent planning sessions for other packages have 100% accurate context of what the monorepo provides.
