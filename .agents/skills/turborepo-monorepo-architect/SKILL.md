---
name: turborepo-monorepo-architect
description: High-leverage monorepo orchestration for large agent-orchestrated codebases. Enforces moderate modularity, shared UI tokens, and cross-package TDD with high-performance caching.
Trigger on: "set up a monorepo", "migrate to turborepo", "add a new package", "orchestrate cross-package tests", "share tailwind config", "fix workspace boundaries", "optimize build caching", "run monorepo self-healing audit"
---

# turborepo-monorepo-architect

Synergizes with: tailwind-design-system, shadcn, frontend-verify, tdd-enforcer, refactor-legacy, semantic-versioning, and playwright-visual-regression for scalable, cache-optimized full-stack delivery.

## Prerequisites
- Node.js project using `pnpm` (recommended), `npm`, or `yarn` workspaces.
- `turbo` package installed as a root devDependency.
- File structure: `apps/` (deployables) and `packages/` (shared logic/configs).

## Core Workflows

### 1. Workspace Plumbing & Setup
Enforce the "Thin Apps, Thick Packages" philosophy to maintain moderate modularity.
- **Root Setup:** Initialize `turbo.json` with a base pipeline (build, lint, test, dev).
- **Package Registration:** Ensure every sub-folder in `apps/*` and `packages/*` has a valid `package.json` with a name prefixed by `@repo/` or similar.
- **Dependency Linking:** Use `workspace:*` protocols for internal dependencies to ensure the latest local versions are always resolved.

### 2. Shared UI Token Pipeline
Integrates directly with `tailwind-design-system` and `shadcn` for visual consistency.
- **Shared Config:** Create `@repo/tailwind-config` package exporting a base preset.
- **Consumer Injection:** Use the `presets` field in app-level `tailwind.config.ts` and explicitly path the `content` array to include `packages/ui` source files.
- **v4 Optimization:** In Tailwind v4, utilize `@theme` in a shared CSS package and `@source "../../packages/ui/src/**/*.tsx"` for zero-config scanning.

### 3. Orchestrated Cross-Package TDD
Scales `tdd-enforcer` behavior across the dependency graph.
- **Pipeline Logic:** Configure `turbo.json` so `test` depends on `^build` (ensuring internal deps are built/ready).
- **Caching:** Defined `inputs` (source code, configs) and `outputs` (test results, coverage reports) to skip redundant work.
- **Execution:** Invoke `turbo run test` to run all workspace tests in parallel with cache-aside performance.

### 4. Monorepo Self-Healing & Maintenance
Autonomous quality gates for agent-heavy environments.
- **Prune & Audit:** After every significant build or test run, execute `turbo prune` and a dependency audit to identify "phantom dependencies."
- **Drift Detection:** Run `syncpack list-mismatches` to identify library version drift across workspaces and suggest corrective interactive updates.
- **Documentation RAG:** Integrate a task in `turbo.json` that invokes `vector-rag-pgvector` to index source code changes across all packages, keeping the agent's mental model current.

## AI Behavior Rules
- **NEVER** install application-level dependencies (react, lodash) in the root; always "Install Where Used."
- **ALWAYS** verify `pnpm-workspace.yaml` or `package.json#workspaces` before creating a new package.
- **STRICTLY** enforce that the UI library ships source code (TSX/JSX), not generated CSS, to allow tree-shaking at the app level.
- **AUTOMATICALLY** suggest a refactor if logic starts duplicating across `apps/` instead of moving to a shared `packages/` workspace.
- **ONLY** recommend migrating to a monorepo once the codebase has 3+ apps or clear package duplication; never prematurely.
- **LOW_DOC_COVERAGE:** Verify specific Remote Cache provider configurations (e.g. Vercel vs. S3) against official docs before implementation.

## Self-Healing Pattern (Proactive)
```bash
# Recommended maintenance cycle
pnpm install && turbo run build test
# If success:
turbo prune --target=web && syncpack list-mismatches
```
