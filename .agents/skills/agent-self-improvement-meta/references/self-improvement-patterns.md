# Agentic Self-Improvement Design Patterns

This guide documents the design patterns for the BASE Meta-Layer, specifically focusing on the 2026 Mastra graph-workflow implementations for autonomous skill evolution.

## 1. The Reflective Loop Pattern
Instead of a single-pass prompt, the Meta-Layer uses a 3-stage reflective loop for proposal generation.

1. **PROPOSE**: LLM generates a fix for the identified rot.
2. **CRITIQUE**: A second agent (or a separate node) audits the proposal against `AGENTS.md` guardrails.
3. **REVISE**: The first agent incorporates the critique to finalize the change.

## 2. Status-Aware Workflow Graph (Mastra)
Workflows are defined as state machines to ensure recoverability and deterministic execution.

```typescript
// Pattern: Workflow Reification
const evolutionWorkflow = createWorkflow({
  name: 'skill-evolution',
  triggerSchema: z.object({ targetSkill: z.string() }),
});

evolutionWorkflow
  .step(auditStep)
  .then(proposalStep)
  .then(verificationStep)
  .branch(({ context }) => {
    return context.verifyOutput.success ? 'PR_STEP' : 'LOG_FAILURE';
  })
  .commit();
```

## 3. Pull Request (PR) Isolation Protocol
To maintain safety, every evolution cycle must follow the **Worktree Isolation Protocol**.

### a) Feature Branch Naming
Patterns for automated branch names:
- `meta/fix-doc-rot/[skill-name]/[date]`
- `meta/opt-prompt/[skill-name]/[date]`

### b) Git Operations with `simple-git`
```javascript
const git = require('simple-git')();
await git.checkoutLocalBranch(branchName);
await git.add('.');
await git.commit('meta(evolve): fix documentation rot in [skill-name]');
await git.push('origin', branchName);
```

## 4. Synergy Handlers (Hooks)
The `evolve.ts` core contains hooks for different improvement triggers:

### Hook A: Documentation Sync
- Trigger: `docs-rot-audit` exit code 1.
- Handler: `healDocumentationRot()`.
- Strategy: Use `vector-rag-pgvector` to find current ground truth and re-link.

### Hook B: Prompt Optimization
- Trigger: `opentelemetry-expert` error span density > threshold.
- Handler: `optimizePrompt()`.
- Strategy: Multi-variate prompt testing against BDD specs.

### Hook C: Refactor Cascades
- Trigger: `simplification-cascades` score < threshold.
- Handler: `rearchitectSkill()`.
- Strategy: `refactor-legacy` AST-driven file merging.
