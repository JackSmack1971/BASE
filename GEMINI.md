# GEMINI.md

## Available Skills

- **using-git-worktrees**: MUST BE USED before any feature branch work,
  implementation plan execution, or sub-agent dispatch requiring branch
  isolation. Located at .agents/skills/using-git-worktrees/.
  Trigger phrases: "set up worktree", "isolate branch", "create feature
  workspace", "before executing plan", "parallel agent setup".

- **writing-plans**: MUST BE USED before implementing any multi-step feature.
  Activated when the user says "write a plan", "create an implementation plan",
  "plan this feature", "plan before coding", or provides a spec asking for tasks.
  Located at `.agents/skills/writing-plans/`.

- **brainstorming**: MUST BE USED before any creative or design work.
  Enforces a design-first protocol with hard gates for approval.
  Located at `.agents/skills/brainstorming/`.

- **simplification-cascades**: MUST BE USED when the user asks to simplify,
  refactor duplicated logic, reduce special cases, or when complexity is
  spiraling. Executes a local codebase scan and returns a cascade score.
  Activated by: "simplify this", "too complex", "reduce duplication",
  "one more case", "same thing implemented multiple ways".

- Use **context-compact** (`.agents/skills/context-compact/`): MUST BE USED when context utilization reaches 70% or above, or when an HTTP 400 context overflow error occurs. It synthesized a durable mission trajectory into `session-state.md` and requires human approval of the compaction summary before resuming.
- Use **design-review** (`.agents/skills/design-review/`): MUST BE USED for any visual QA, design audit, "check if it looks good", "fix the UI", "design polish", or "AI slop" requests. Do NOT answer design review requests directly — invoke this skill. It uses the browser sub-agent, produces before/after screenshots, and commits each fix atomically.

- **changelog-generator** (`.agents/skills/changelog-generator/`): MUST BE USED for
  any request involving changelog creation, release note generation, commit summarization,
  or version documentation. Do NOT write changelog content manually before invoking this skill.

- **multi-agent-article-pipeline** (`.agents/skills/multi-agent-article-pipeline/`): MUST BE USED for generating long-form articles requiring multi-step research and adversarial review. Orchestrates the 4-skill production suite.

- **article-research-dialectic** (`.agents/skills/article-research-dialectic/`): MUST BE USED for adversarial research, thesis declaration, and conflict mapping.

- **article-qa-auditor** (`.agents/skills/article-qa-auditor/`): MUST BE USED for article drafting (@engineer) and quality auditing (@qa) with style guide enforcement.

- **article-red-team** (`.agents/skills/article-red-team/`): MUST BE USED for adversarial review and threat classification of article conclusions.

- **context7-skill-wizard** (`.agents/skills/context7-skill-wizard/`): MUST BE USED
  whenever the user requests skill generation, skill creation from documentation, or
  any Context7-backed skill package. Triggers: "build a skill", "skill wizard",
  "skill for [library]", "generate skill from docs", "context7 skill". Requires
  Context7 MCP connected.

- **playwright-visual-regression** (`.agents/skills/playwright-visual-regression/`): 
  MUST BE USED for visual QA, E2E browser automation, and "visual TDD" loops. 
  Triggers: "run visual regression", "setup playwright E2E", "fix failing visual tests", 
  "automate visual QA", "check screenshot diffs".

- **ci-cd-orchestrator** (`.agents/skills/ci-cd-orchestrator/`): 
  MUST BE USED for setting up, managing, or triggering GitHub Actions CI/CD workflows. 
  Triggers: "setup ci/cd", "run full pipeline", "deploy to production", "trigger workflow", 
  "orchestrate release", "agent run ci", "full deployment". 
  Integrates `production-code-audit`, `playwright-visual-regression`, and `terraform-infrastructure`.

- **vector-rag-pgvector** (`.agents/skills/vector-rag-pgvector/`): 
  MUST BE USED for implementing Postgres-native vector search, long-term agent memory, 
  and hybrid RRF (Reciprocal Rank Fusion) retrieval. 
  Triggers: "setup pgvector rag", "implement agent memory", "search with hybrid RRF", 
  "vector search setup", "rag patterns", "store gemini embeddings".
  Synergizes with `context-compact` for persistent session state storage.

- **turborepo-monorepo-architect** (`.agents/skills/turborepo-monorepo-architect/`): 
  High-leverage monorepo orchestration for large agent-orchestrated codebases. Enforces moderate modularity, shared UI tokens, and cross-package TDD with high-performance caching. 
  Triggers: "set up a monorepo", "migrate to turborepo", "add a new package", "orchestrate cross-package tests", "share tailwind config", "fix workspace boundaries", "optimize build caching", "run monorepo self-healing audit".

- **documentation-rot-guard** (`.agents/skills/documentation-rot-guard/`): 
  Detects documentation rot using semantic drift (pgvector + ast-grep) and generates draft fixes for TypeScript/Next.js/Turborepo codebases. Proactive CI gate with bidirectional sync. 
  Triggers: "check documentation rot", "audit docs", "fix doc drift", "run docs consistency check", "self-documenting codebase", "detect stale docs".


## Knowledge Items

- **pipeline-article-learnings**: Permanent artifact for autonomous trajectory storage.
  - Primary Script: `./scripts/pipeline_triage.sh --consolidate`
  - Target: `.gemini/antigravity/knowledge/pipeline_history.md`
