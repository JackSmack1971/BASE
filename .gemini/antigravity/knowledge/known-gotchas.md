# Known Gotchas — Curated Session Learnings

- **Context Window Middle Zone**: Attention accuracy collapses in the middle 40-60% of any context window. Keep critical rules in AGENTS.md.
- **KV Cache Invalidation**: Sub-300 token hyper-atomic skills cause constant cache mutation. Enforce 300-token floor.
- **Prisma Error Loops**: `npx prisma migrate dev` can fail on drift. Always plan a 3-cycle recovery loop.
