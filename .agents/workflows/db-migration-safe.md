# Workflow: db-migration-safe
# Trigger: /workflow db-migration-safe [source-db] [target-db]
# Architecture: Single L2 domain agent, sequential with mandatory gates

## Phase 1 — Dependency Scan
Recursive scan of repository for all references to source DB connector.
Output Artifact: affected file list with dependency map.
STOP: Human approves scope before any schema work begins.

## Phase 2 — Schema Diff Generation
Draft new schema using Prisma (per known-gotchas.md: always Prisma).
Output Artifact: Implementation Plan with full schema diff.
STOP: Human approves schema before writes.

## Phase 3 — ORM Update
migration-guard Rule activates via glob. Agent executes schema writes.

## Phase 4 — Migration Execution
Agent runs npx prisma migrate dev via MCP shell.
Autonomous error loop: max 3 cycles.

## Phase 5 — Browser Sub-Agent Verification
Browser Sub-Agent navigates login flow, submits synthetic credentials,
verifies JWT generation and redirect.

## Phase 6 — Walkthrough
Diffs + migration output + browser verification screenshots written to known-gotchas.md.
