# SQL Templates & Configuration Patterns

## HNSW Index Tuning

HNSW (Hierarchical Navigable Small Worlds) is the recommended index type for high-performance agent memory.

### Creation with Parameters
```sql
CREATE INDEX ON documents 
USING hnsw (embedding vector_cosine_ops)
WITH (
  m = 16,             -- Max connections per node (default: 16)
  ef_construction = 64 -- Candidate list size during build (default: 64)
);
```

### Search Accuracy vs Speed
To increase recall at query time (at slight latency cost), adjust `ef_search`:
```sql
SET hnsw.ef_search = 100; -- Session-level setting
```

---

## Detailed RRF Implementation

Reciprocal Rank Fusion (RRF) is significantly more robust than score normalization when combining vector distance (0 to 2) with full-text scoring (`ts_rank`, any positive range).

### Multi-Column RRF Join
Use this pattern when your "Keyword Search" and "Vector Search" are performed on different column sets or tables.

```sql
WITH semantic_search AS (
  SELECT id, content, ROW_NUMBER() OVER (ORDER BY embedding <=> ${vector}::vector) AS rank
  FROM documents 
  ORDER BY embedding <=> ${vector}::vector 
  LIMIT 50
),
keyword_search AS (
  SELECT id, content, ROW_NUMBER() OVER (ORDER BY ts_rank_cd(to_tsvector('english', content), plainto_tsquery('english', ${query})) DESC) AS rank
  FROM documents 
  WHERE to_tsvector('english', content) @@ plainto_tsquery('english', ${query})
  ORDER BY ts_rank_cd(to_tsvector('english', content), plainto_tsquery('english', ${query})) DESC
  LIMIT 50
)
SELECT 
  COALESCE(s.id, k.id) AS id,
  COALESCE(s.content, k.content) AS content,
  COALESCE(1.0 / (60 + s.rank), 0.0) + COALESCE(1.0 / (60 + k.rank), 0.0) AS rrf_score
FROM semantic_search s
FULL OUTER JOIN keyword_search k ON s.id = k.id
ORDER BY rrf_score DESC 
LIMIT 10;
```

---

## Prisma Unsupported Type Handling

Prisma allows introspection of vector types as `Unsupported`. When writing raw SQL, use type casting to ensure Postgres knows how to handle the data.

### Insert / Upsert with Raw SQL
```typescript
await prisma.$executeRaw`
  INSERT INTO documents (id, content, embedding)
  VALUES (${id}, ${content}, ${vector}::vector)
  ON CONFLICT (id) DO UPDATE SET
    content = EXCLUDED.content,
    embedding = EXCLUDED.embedding;
`;
```

---

## Google Gemini text-embedding-004 Configuration

### Dimension Mapping
| Dimension | Storage (Per Vector) | Accuracy Impact |
|-----------|-----------------------|-----------------|
| 768       | ~3 KB                | 100% (Baseline) |
| 512       | ~2 KB                | ~98%            |
| 256       | ~1 KB                | ~95%            |

### Task Type Best Practices
- **RETRIEVAL_QUERY**: Use for short search strings.
- **RETRIEVAL_DOCUMENT**: Use for long chunks/articles stored in DB.
- **SEMANTIC_SIMILARITY**: Use for pair-wise comparison (e.g., deduplication).
