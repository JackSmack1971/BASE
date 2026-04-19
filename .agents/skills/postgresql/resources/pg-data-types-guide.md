# PostgreSQL Data Types Guide

Choosing the correct data type is the most impactful decision in schema design.

## Recommended Types

| Category | Type | Note |
|----------|------|------|
| **IDs** | `BIGINT GENERATED ALWAYS AS IDENTITY` | Preferred over SERIAL. |
| **UUIDs** | `UUID` | Use for distributed systems. |
| **Strings** | `TEXT` | Faster/cleaner than `VARCHAR(N)`. |
| **Money** | `NUMERIC(p, s)` | Never use floating point for currency. |
| **Time** | `TIMESTAMPTZ` | Always include timezone information. |
| **Boolean** | `BOOLEAN` | Use `NOT NULL` unless tri-state needed. |
| **Large Text** | `TEXT` | Automatically TOASTed if >2KB. |

## Advanced Types

### JSONB
- **Usage**: Semi-structured data, optional attributes.
- **Search**: Supports containment (`@>`) and existence (`?`) queries.
- **Index**: Use **GIN** indexes for high performance.

### Arrays
- **Usage**: Ordered lists (e.g., tags).
- **Index**: Use **GIN** with containment operators.
- **Constraint**: Avoid using arrays for relationships; use junction tables.

### Range Types
- **Types**: `daterange`, `tstzrange`, `numrange`.
- **Logic**: Prevents overlaps (e.g., scheduling) via `EXCLUDE` constraints.

### Network & Geography
- **Network**: `INET` (IP), `CIDR` (Ranges).
- **Geography**: `POINT`, `POLYGON`. Use **PostGIS** for advanced spatial work.

## 🚫 Types to Avoid
- `timestamp` (without timezone): Use `timestamptz`.
- `char(n)` / `varchar(n)`: Use `text`.
- `money`: Use `numeric`.
- `serial`: Use `identity columns`.
- `timetz`: Unreliable; use `timestamptz`.
