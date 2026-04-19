# Dependency Graph — Master Integration

## Module Map:
- .agent/rules -> L0/L2 routing
- .agent/skills -> L3 workers
- .agent/workflows -> L1 orchestrators
- .gemini/antigravity/knowledge -> Durable memory

## Coupling Status:
- Strictly decoupled. No reverse coupling from Skills to Workflows (DAG Rule).
