# PostgreSQL Performance and Evolution

This resource provides patterns for optimizing workloads and evolving your database schema safely.

## Workload-Specific Designs

### Update-Heavy Tables
- **Separate Columns**: Move frequently updated columns to a separate table to minimize heap bloat.
- **Fillfactor**: Set `fillfactor = 90` to leave space for HOT (Heap-Only Tuple) updates.
- **Index Stability**: Avoid indexing columns that change frequently.

### Insert-Heavy Tables
- **Minimize Indexes**: Every index slows down inserts.
- **Batching**: Use `COPY` or multi-row `INSERT` for high-throughput ingests.
- **Unlogged Tables**: Use `UNLOGGED` for transient staging data.

### UPSERT Patterns
Use `ON CONFLICT` to handle "insert if not exists" logic efficiently.
```sql
INSERT INTO users (email, name)
VALUES ('user@example.com', 'Alice')
ON CONFLICT (email) DO UPDATE SET name = EXCLUDED.name;
```

## Safe Schema Evolution

PostgreSQL supports Transactional DDL (you can `ROLLBACK` an `ALTER TABLE`).

### Best Practices:
1. **Concurrent Indexing**: Use `CREATE INDEX CONCURRENTLY` to avoid locking writes.
2. **Nullable Defaults**: Adding a column with a constant default is fast; volatile defaults (e.g., `now()`) trigger table rewrites.
3. **Identity vs Serial**: Use `GENERATED ALWAYS AS IDENTITY` for modern surrogate keys.
4. **Constraint Deferral**: Use `DEFERRABLE INITIALLY DEFERRED` for circular dependencies.
5. **Validation**: Test migration impact in a staging environment with production-like data volume.
