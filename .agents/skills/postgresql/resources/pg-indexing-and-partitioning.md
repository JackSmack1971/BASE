# PostgreSQL Indexing and Partitioning

This resource provides strategies for optimizing data retrieval and managing large-scale tables.

## Indexing Strategies

| Index Type | Best Use Case | Operators |
|------------|---------------|-----------|
| **B-Tree** | Default; Equality and Range queries. | `=`, `<`, `>`, `ORDER BY` |
| **GIN** | JSONB, Arrays, Full-Text Search. | `@>`, `?`, `@@` |
| **GiST** | Ranges, Geometry, Exclusion. | `&&`, `@>`, `<<` |
| **BRIN** | Large, naturally ordered data. | Time-series, IDs. |

### Specialized Index Patterns
- **Covering Index**: `INCLUDE (col)` to allow index-only scans.
- **Partial Index**: `WHERE (condition)` to index only a subset of rows.
- **Expression Index**: `LOWER(email)` for case-insensitive lookups.
- **Concurrent Indexing**: `CREATE INDEX CONCURRENTLY` to avoid locking writes.

## Table Partitioning

Partitioning is recommended for tables exceeding **100M rows** to improve query planning and maintenance.

### Partitioning Types
- **RANGE**: Partitioning by time or numeric series (e.g., `PARTITION BY RANGE (created_at)`).
- **LIST**: Partitioning by discrete values (e.g., `PARTITION BY LIST (region)`).
- **HASH**: Evenly distributing rows across a fixed number of partitions (e.g., `PARTITION BY HASH (user_id)`).

### Declarative Partitioning
Use declarative partitioning (PostgreSQL 10+) or **TimescaleDB** (hypertables) for automated time-series management. Avoid legacy table inheritance.

### Limitations
- No global UNIQUE constraints (must include partition key).
- Primary keys must include the partition key.
