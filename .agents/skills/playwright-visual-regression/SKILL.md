---
name: playwright-visual-regression
description: Provides advanced E2E automation and visual QA capabilities using Playwright. Specializes in closed-loop visual regression for Shadcn/Tailwind components, AI-powered screenshot comparisons, and self-healing automation in Next.js environments. Synergizes with frontend-verify, tdd-enforcer, production-code-audit, and ci-cd-github-actions-orchestrator for verified, zero-downtime UI delivery.
Trigger on: "run visual regression", "setup playwright E2E", "fix failing visual tests", "automate visual QA", "check screenshot diffs"
---

# Playwright Visual Regression

Provides full-spectrum visual automation and E2E verification for modern React/Next.js stacks. This skill transforms standard testing into a closed-loop visual QA system by leveraging Playwright's native pixel-diffing and sharding capabilities.

## Prerequisites
- Node.js 18+ and `npm install -D @playwright/test @playwright/experimental-ct-react`
- Context7 MCP (for library updates and docs)
- CI Environment with sharding support (GitHub Actions/Vercel)

## Workflow

### Phase 1 — Setup & Config
Initialize Playwright in a Next.js/Shadcn environment. Use `playwright.config.ts` to enforce visual stability.
- Set `expect.toHaveScreenshot.threshold` to `0.2` (for Shadcn anti-aliasing).
- Configure `stylePath` to include global CSS/Tailwind layers.
- Reference: `references/config-patterns.md`

### Phase 2 — Component Visual Snapshots
Use `@playwright/experimental-ct-react` to test isolated Shadcn components.
1. Use `mount` fixture to render components (buttons, modals, forms).
2. Apply `test.use({ colorScheme: 'dark' })` variants.
3. Assert with `await expect(component).toHaveScreenshot();`

### Phase 3 — Visual TDD Cycle
Synergize with `tdd-enforcer` to drive UI development from visual baselines.
- Call the `visualTddCycle()` helper pattern when implementing new UI features.
- If a diff is detected, analyze the `actual-vs-expected` diff to identify visual drift.
- Use `--update-snapshots` only after manual verification of intended changes.
- Reference: `references/visual-tdd-patterns.md`

## AI Behavior Rules
- **Pixel-Perfect Assertions**: Always use locators for screenshots to avoid full-page noise.
- **Self-Healing Selectors**: Favor `getByRole` or `getByTestId` over CSS/Xpath to ensure resilience to Tailwind/Shadcn markup shifts.
- **CI Sharding**: For suites > 50 tests, always recommend `npx playwright test --shard=x/y` for parallel execution.
- <!-- LOW_DOC_COVERAGE: "AI-powered screenshot analysis" is implemented via threshold tuning and retry loops; verify against external AI providers if higher fidelity is needed. -->

## Reference
- `references/config-patterns.md` — Playwright & Tailwind global configurations.
- `references/visual-tdd-patterns.md` — The `visualTddCycle()` pattern for agent-native loops.
