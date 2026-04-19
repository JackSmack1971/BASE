# Architecture Decision Records (ADR)
# Final Directive: No verbatim tool output. Curated decisions only.

## ADR-001: Moderate Modularity Doctrine
- **Status**: Accepted
- **Context**: Simulation proves hyper-atomic and monolithic pipelines underperform.
- **Decision**: All skills must stay within 300-800 token budget.
- **Consequences**: Higher verification pass rate (85%), lower latency (185s).

## ADR-002: Prisma-First Migration
- **Status**: Accepted
- **Context**: Raw SQL migrations lead to desync with application ORM.
- **Decision**: All schema changes must go through Prisma Migrate.
