# PostgreSQL Core Rules and Gotchas

This resource outlines the fundamental principles and common pitfalls of PostgreSQL schema design.

## Core Rules

### Primary Keys
- **Prefer**: `BIGINT GENERATED ALWAYS AS IDENTITY`.
- **UUID**: Use only when global uniqueness or opacity is required (distributed systems).
- **Surrogate Keys**: Most tables benefit from a surrogate key, but time-series/log data may use natural keys.

### Normalization
- **Standard**: Always normalize to **3NF** first to eliminate redundancy.
- **Denormalization**: Only denormalize for proven, high-ROI read performance gains.

### Naming Conventions
- **Identifiers**: PostgreSQL lowercases unquoted names. Use `snake_case` for all tables and columns.
- **Quoting**: Avoid double-quoting identifiers (`"MyColumn"`) as it forces case-sensitivity everywhere.

## PostgreSQL "Gotchas"

| Issue | Logic | Solution |
|-------|-------|----------|
| **FK Indexes** | Postgres does NOT auto-index foreign keys. | Manually add indexes to all FK columns. |
| **Unique NULLs** | `UNIQUE` allows multiple NULL values by default. | Use `UNIQUE (...) NULLS NOT DISTINCT` (PG15+). |
| **Silent Coercion** | Overflow errors are strict (no silent truncation). | Ensure column widths (NUMERIC/VARCHAR) match data. |
| **Sequence Gaps** | Rollbacks and crashes create gaps in IDs. | This is normal; do not try to "fix" or re-order IDs. |
| **MVCC Bloat** | Updates/Deletes leave "dead tuples" behind. | Design tables with low churn; ensure AUTOVACUUM is healthy. |
| **Clustering** | Tables are heaps; rows are in insertion order. | Use `CLUSTER` for specific order (one-off action). |
