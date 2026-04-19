# Workflow: full-stack-feature
# Trigger: /workflow full-stack-feature [description]
# Architecture: L1 Orchestrator spawning 3 L2 domain agents

## Phase 1 — Task List Generation
Manager View generates Task List Artifact with three parallel tracks:
- Agent Alpha: Backend schema + API layer
- Agent Beta: Frontend component + state management
- Agent Gamma: E2E test suite (Playwright)
STOP: Human reviews scope and track isolation before agents spawn.

## Phase 2 — File Ownership Declaration
Each agent declares owned files in Task List before any writes.
Shared API contracts frozen. No agent modifies declared files of another.

## Phase 3 — Implementation Plan Consolidation
Three agents consolidate proposed changes into singular Implementation Plan Artifact.
STOP: Human reviews via Google Docs-style commenting interface.

## Phase 4 — Parallel Execution
Agents execute in isolated workspaces. MCP tools handle file writes.

## Phase 5 — Browser Sub-Agent Verification
Browser Sub-Agent spins up local dev server, navigates to affected UI flows,
executes synthetic user interactions, captures visual state.

## Phase 6 — Walkthrough Generation
Consolidated Walkthrough Artifact: code diffs + before/after screenshots + browser recording.
