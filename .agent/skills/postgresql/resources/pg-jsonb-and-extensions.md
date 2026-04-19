# PostgreSQL JSONB and Extensions

PostgreSQL is a multi-modal database. This resource covers advanced features like JSONB and the extension ecosystem.

## JSONB Guidance

`JSONB` stores binary-format JSON, allowing for fast searches and indexing.

### Searching JSONB
- **Containment (`@>`)**: `WHERE attrs @> '{"status": "active"}'`
- **Existence (`?`)**: `WHERE attrs ? 'verified'`
- **Indexing**: Use **GIN** indexes for high-performance searches across all attributes.

### Best Practices
1. **Prefer JSONB over JSON**: JSONB is stored in a structured format that facilitates indexing.
2. **Schema-on-Read**: Use JSONB only for optional or highly variable attributes. Keep primary business data in standard columns.
3. **Generated Columns**: For frequently queried JSONB fields, use a stored generated column with a B-tree index.
4. **Validation**: Use `CHECK` constraints to ensure the JSONB data follows a specific structure if needed.

## Essential Extensions

| Extension | Purpose |
|-----------|---------|
| **pgvector** | Vector similarity search for embeddings (AI/ML). |
| **PostGIS** | Industry-standard geospatial support and queries. |
| **TimescaleDB** | Time-series automation, partitioning, and compression. |
| **pg_trgm** | Fuzzy text search and trigram-based `LIKE` acceleration. |
| **pgcrypto** | Cryptographic functions (e.g., password hashing). |
| **pgaudit** | Comprehensive audit logging for all database activity. |
| **citext** | Case-insensitive text type (alternative to expression indexes). |
