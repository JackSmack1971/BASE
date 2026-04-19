---
name: frontend-verify
description: >
  L3 worker for UI fidelity verification and automated browser quality assurance.
  Specializes in using the Browser Sub-Agent for visual regression, accessibility (A11y) audits, and E2E interaction testing.
  Captures screenshots, recordings, and performance metrics to validate frontend integrity.
  Does NOT activate for backend-only logic, database schema changes, or purely internal CLI tool development.
version: 1.1.0
scope: workspace
alwaysApply: false
token_budget: 550
parent: none
---

## Goal
Verify that all UI/UX components meet visual fidelity, accessibility, and interactive requirements via native browser sub-agent validation.

## Phase Sequence
1. **Environment Initialization**: Spin up the local development server (e.g., `npm run dev`) and verify endpoint readiness. Generate a task sub-list for the Browser Sub-Agent including specific URL paths and viewport targets (mobile/desktop).
2. **Synthetic Interaction Execution**: Direct the Browser Sub-Agent to perform critical user flows (e.g., Submit Form, Navigate Dashboard, Trigger Modal). Assert that all state transitions occur without hydration errors or console failures.
3. **Visual & A11y Audit**: Capture high-resolution screenshots and screen recordings of the affected flows. Run automated accessibility audits (Lighthouse/Axe) and record violation counts.
4. **Verification Artifact Synthesis**: Generate a Walkthrough Artifact that embeds browser recordings, before/after comparison screenshots, and the A11y status report. Highlight any visual regressions discovered.

## Constraints
- Browser recordings are NON-NEGOTIABLE for any PR that touches UI components. Diffs alone are insufficient.
- All interactive elements MUST be verified for keyboard focus and ARIA compliance.
- Does NOT activate for: Server-side rendering (SSR) logic that has no visual output, or background job workers.
- HALT if the dev server fails to start or if the Browser Sub-Agent encounters a blocking network error.

## Context This Worker Needs
- Correct local dev server URI and port configuration.
- Specific CSS selectors or test-ids for robust interaction targeting.
- Known visual state baseline (if available).

## Output Artifact
- Type: Walkthrough
- Required fields: Browser Recording URI, Side-by-Side Screenshots, A11y Violation Score.

## MCP Tools Required
- browser_subagent: used for all visual interactions, screenshot capture, and recording generation.
- run_command: used for starting/stopping the local development server and build tools.
- view_file: used for checking component implementation and associated CSS/styling rules.
