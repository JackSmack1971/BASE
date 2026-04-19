---
name: postgresql
description: "Design a PostgreSQL-specific schema. Covers best-practices, data types, indexing, constraints, performance patterns, and advanced features"
risk: unknown
source: community
---

# PostgreSQL Table Design

## Overview

Design high-performance, maintainable schemas specifically for PostgreSQL. This skill covers data type selection, indexing strategies, and advanced features like partitioning and RLS.

## 📚 Resources

| Resource | Description |
|----------|-------------|
| [Core Rules & Gotchas](file:///c:/workspaces/antigravity-meta/.agents/skills/postgresql/resources/pg-core-rules-and-gotchas.md) | surrogate keys, normalization, and PITR pitfalls. |
| [Data Types Guide](file:///c:/workspaces/antigravity-meta/.agents/skills/postgresql/resources/pg-data-types-guide.md) | Deep-dive into IDs, numeric types, and specialized storage. |
| [Indexing & Partitioning](file:///c:/workspaces/antigravity-meta/.agents/skills/postgresql/resources/pg-indexing-and-partitioning.md) | B-tree, GIN, GiST indexes and range/list partitioning. |
| [Performance Patterns](file:///c:/workspaces/antigravity-meta/.agents/skills/postgresql/resources/pg-performance-and-evolution.md) | Update-heavy vs. Insert-heavy design and safe migrations. |
| [JSONB & Extensions](file:///c:/workspaces/antigravity-meta/.agents/skills/postgresql/resources/pg-jsonb-and-extensions.md) | Managing semi-structured data and using pgvector/PostGIS. |

## Core Workflow

### 1. Data Modeling & Invariants
Choose correct data types (e.g., `TIMESTAMPTZ`, `BIGINT`) and enforce invariants with constraints.

### 2. Indexing Strategy
Implement indexes for actual access paths (PKs, FKs, frequent filters).
> See [Indexing & Partitioning](file:///c:/workspaces/antigravity-meta/.agents/skills/postgresql/resources/pg-indexing-and-partitioning.md).

### 3. Advanced Features
Utilize JSONB for flexible attributes and partitioning for large-scale data.
> See [JSONB & Extensions](file:///c:/workspaces/antigravity-meta/.agents/skills/postgresql/resources/pg-jsonb-and-extensions.md).

### 4. Evolution
Execute safe, transactional DDL changes.
> See [Performance Patterns](file:///c:/workspaces/antigravity-meta/.agents/skills/postgresql/resources/pg-performance-and-evolution.md).

## Recommended Data Types
- **IDs**: `BIGINT GENERATED ALWAYS AS IDENTITY`
- **Time**: `TIMESTAMPTZ`
- **Currency**: `NUMERIC(p, s)`

## Related Skills
- `database-architect`: High-level data architecture.
- `database-optimizer`: SQL tuning.

## Summary
Design PostgreSQL schemas that are reliable, performant, and scalable from day one.
