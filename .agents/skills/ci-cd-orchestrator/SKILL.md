---
name: ci-cd-orchestrator
description: Orchestrates hybrid CI/CD pipelines across Vercel, Docker, and Terraform. Implements an "agent-native" loop to generate, validate, and trigger matrixed GitHub Actions workflows via the REST API. Synergizes with `production-code-audit`, `terraform-infrastructure`, `playwright-visual-regression`, and `semantic-versioning` to enforce high-quality, automated delivery gates.
Trigger on: "setup github actions", "deploy to vercel", "build docker image", "run terraform plan", "trigger orchestrator run", "configure CI/CD", "add deployment gate".
Requires: GitHub Personal Access Token (PAT) with `repo` and `actions:write` scopes, Vercel API tokens, Docker registry credentials.
---

# CI/CD Orchestrator

Provides a Unified Command Center for repository automation, bridging the gap between agentic planning and production deployment.

## Prerequisites

- **GitHub Secrets:** Ensure `VERCEL_TOKEN`, `VERCEL_ORG_ID`, `VERCEL_PROJECT_ID`, and `GH_PAT` (for cross-repo or API dispatch) are configured.
- **Tools:** GitHub CLI (`gh`) or `curl` for API dispatch.

## Workflow

### Phase 1 — Pipeline Generation
1. **Analyze Diff:** Use `git diff` to identify modified components (Frontend, Backend, Infra, Tests).
2. **Select Template:** Load a base YAML from `references/workflow-templates.md`.
3. **Generate Matrix:** Use the matrix strategy to parallelize gates based on the diff:
    - **Lint/TDD:** Run for all modified JS/TS/Go files.
    - **Production Audit:** Trigger `production-code-audit` for modified logic.
    - **Visual Regression:** Trigger `playwright-visual-regression` shards for UI changes.
4. **Validation:** Run `python3 scripts/validate_workflow.py` to ensure YAML compliance.

### Phase 2 — Agent-Native Dispatch
1. **Triggering:** Use the `workflow_dispatch` event via the GitHub API to launch the pipeline. 
   - *Example REST Call:* `POST /repos/{owner}/{repo}/actions/workflows/{id}/dispatches`
2. **Payload:** Send task-specific JSON to the `matrix-config` input.
3. **Synergy Routing:**
    - **Frontend:** Trigger Vercel `--prebuilt` deployment.
    - **Backend:** Build and Push Docker images to registry.
    - **Infra:** Execute `terraform plan` and wait for `approval` to `apply`.

### Phase 3 — Convergence & Release
1. **Gate Verification:** Check the run status. Wait for:
    - ✅ `production-audit` == "success"
    - ✅ `playwright-visual-regression` == "success"
    - ✅ `unit-tests` == "success"
2. **Semantic Release:** Only after ALL gates pass, trigger the `semantic-versioning` skill to bump version, generate changelog, and push the Git tag.

## Reference
- `references/workflow-templates.md` — Canonical YAML for Vercel, Docker, and Matrix jobs.
- `references/api-orchestration.md` — REST API patterns for Antigravity-to-CI communication.
- `references/security-gates.md` — Checklist for `production-code-audit` and TDD integration.

## AI Behavior Rules
- **NEVER** commit a CI workflow without first running `validate_workflow.py`.
- **ALWAYS** include a `workflow_dispatch` trigger in generated YAMLs to allow agentic control.
- **NEVER** trigger a Vercel/Docker production deployment if the `production-audit` gate has failed.
- **USE** `concurrency` groups to prevent overlapping deployments to the same environment.
- **RESTRICT** OIDC roles to the minimum required permissions per repository.
