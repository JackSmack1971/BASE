---
name: migration-guard
description: "Database migration safety protocols for schema change operations"
alwaysApply: false
globs:
  - "**/migrations/**"
  - "**/*.migration.ts"
  - "**/prisma/schema.prisma"
token_budget: 500
---

## Migration Safety Protocol
1. **Validation**: Run `npx prisma migrate diff --from-schema-datasource ...` to detect destructive changes.
2. **Backup**: Verify local or cloud backup presence (e.g., Neon Branching or AWS Snapshot).
3. **Staging**: Migration must pass on a staging clone before production.
4. **Prisma First**: Always use Prisma Migrate for schema changes. Never bypass via raw SQL runner.

## CLI Safety Examples
- Detect drops: `grep -i "DROP COLUMN" migration.sql` -> HALT if found.
- Verify drift: `npx prisma migrate status` -> MUST be "synchronized".

## Guardrails
- HALT if `DROP INDEX` or `DROP COLUMN` is detected without migration path in Implementation Plan.
- REQUIRED: Approval from EM via Implementation Plan for ALL production schema shifts.
- Any change to `schema.prisma` requires immediate ORM client regeneration.
