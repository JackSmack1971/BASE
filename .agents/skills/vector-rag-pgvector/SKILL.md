---
name: implementing-vector-rag-pgvector
description: Provides Postgres-native vector search and RAG patterns using pgvector, pgvector-node, and Prisma. Implements hybrid Reciprocal Rank Fusion (RRF) search with Google Gemini text-embedding-004. Synergizes with prisma-expert, postgresql, and context-compact for persistent agent memory. Trigger on: "setup pgvector rag", "search with hybrid RRF", "implement vector search", "store gemini embeddings", "agent memory layer". Requires pgvector extension and @google-cloud/aiplatform.
---

# Implementing Vector RAG with pgvector

Provides patterns for building a Postgres-native knowledge base and agent memory layer using `pgvector`, Gemini embeddings, and Prisma.

## Prerequisites

- **Postgres Extension:** `pgvector` must be installed on the database server.
- **Node.js Libraries:**
  ```bash
  npm install @google-cloud/aiplatform pgvector prisma
  ```
- **Environment:** `GOOGLE_APPLICATION_CREDENTIALS` or ADC must be configured for Gemini.

## Workflow

### Step 1 — Schema & Migrations
Define vector columns in `schema.prisma` using the `Unsupported("vector")` type. Create custom migrations to enable the extension and add HNSW indexes.

```prisma
model Document {
  id        String   @id @default(uuid())
  content   String
  embedding Unsupported("vector(768)")?
  metadata  Json?
  @@map("documents")
}
```

**Migration SQL:**
```sql
CREATE EXTENSION IF NOT EXISTS vector;
CREATE INDEX ON "documents" USING hnsw (embedding vector_cosine_ops);
```

### Step 2 — Generating Embeddings
Use `text-embedding-004` (Task: `RETRIEVAL_DOCUMENT`) to generate 768-dimensional vectors.

```typescript
const [response] = await client.predict({
  endpoint,
  instances: [{ 
    content: text, 
    task_type: 'RETRIEVAL_DOCUMENT' 
  }],
});
const vector = response.predictions[0].embeddings.values;
```

### Step 3 — Hybrid RRF Search
Execute a hybrid search combining Semantic (Vector) + Keyword (TSVECTOR) using Reciprocal Rank Fusion (RRF).

```typescript
const results = await prisma.$queryRaw`
  WITH semantic_search AS (
    SELECT id, ROW_NUMBER() OVER (ORDER BY embedding <=> ${vector}::vector) AS rank
    FROM documents ORDER BY embedding <=> ${vector}::vector LIMIT 50
  ),
  keyword_search AS (
    SELECT id, ROW_NUMBER() OVER (ORDER BY ts_rank_cd(to_tsvector('english', content), plainto_tsquery('english', ${query})) DESC) AS rank
    FROM documents WHERE to_tsvector('english', content) @@ plainto_tsquery('english', ${query})
    LIMIT 50
  )
  SELECT id, 
    COALESCE(1.0 / (60 + s.rank), 0.0) + COALESCE(1.0 / (60 + k.rank), 0.0) AS rrf_score
  FROM semantic_search s
  FULL OUTER JOIN keyword_search k ON s.id = k.id
  ORDER BY rrf_score DESC LIMIT 10;
`;
```

## Reference
- `references/sql-templates.md` — Detailed SQL for HNSW tuning and complex RRF joins.

## AI Behavior Rules
- **Constant $k=60$:** Always use $k=60$ in RRF calculations unless explicitly overridden.
- **Self-Healing Upsert:** If vector length mismatch occurs, verify vs `text-embedding-004` defaults (768) and warn/correct the Prisma schema if stale.
- **Dimension Check:** Validating dimension count (768 for text-embedding-004) before executing `$executeRaw` to prevent database-level crashes.
- **Retrieval Awareness:** Use `RETRIEVAL_QUERY` for search queries and `RETRIEVAL_DOCUMENT` for storage to maintain accuracy.
- **Log Confidence:** Always output the `rrf_score` of top results when debugging retrieval failure.
