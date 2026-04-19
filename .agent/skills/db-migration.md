---
name: db-migration
description: >
  L3 worker for database schema changes, ORM migrations, and data safety protocols.
  Specializes in Prisma/Drizzle workflows, migration diffing, and destructive change auditing.
  Handles schema validation, shadow database synchronization, and ORM client regeneration.
  Does NOT activate for general API routing, UI component development, or pure local dev environment configuration.
version: 1.1.0
scope: workspace
alwaysApply: false
token_budget: 600
parent: none
---

## Goal
Execute a complete, production-safe database schema migration with mandatory audit checkpoints and zero-downtime considerations.

## Phase Sequence
1. **Discovery & Diffing**: Analyze current schema state vs. proposed changes using `npx prisma migrate diff`. Map all affected tables, columns, and indexes. Identify potential destructive operations (e.g., `DROP COLUMN`, `RENAME TABLE`) that could lead to data loss.
2. **Implementation Planning**: Generate a detailed Implementation Plan Artifact. This document must include the full schema diff, a risk assessment score (Low/Medium/High), and explicit verification commands for the staging environment. 
3. **Execution Gate**: STOP. Await human approval on the Implementation Plan. Ensure a verified pre-migration backup exists for the target environment before proceeding with the write operation.
4. **ORM Synchronization**: Execute `npx prisma migrate dev` (for local/dev) or `prisma migrate deploy` (for production). Immediately follow with `npx prisma generate` to synchronize the type-safe ORM client and run existing integration tests to verify logic parity.

## Constraints
- NEVER run production-tier migrations without a verified backup checkpoint established within the last 4 hours.
- HALT immediately if unmapped Prisma data types or custom SQL extensions are detected in the diff.
- Does NOT activate for: SQL-only environments without a supported ORM, or purely cosmetic README/documentation updates.
- All migrations MUST be idempotent and support rollbacks via `prisma migrate resolve`.

## Context This Worker Needs
- Reference schema file: typically `prisma/schema.prisma` or `drizzle.config.ts`.
- Current migration directory state and shadow database availability.
- Target environment constraints (e.g., Neon connection pooling vs. local SQLite).

## Output Artifact
- Type: Implementation Plan | Walkthrough
- Required fields: Schema Diff (Side-by-side), Risk Assessment, Verification Command, ORM Sync Status.

## MCP Tools Required
- run_command: used for `npx prisma` CLI interactions, client generation, and test suite execution.
- view_file: used for auditing the schema.prisma file and individual migration SQL files.
- grep_search: used for tracing where schema models are coupled with backend services.
