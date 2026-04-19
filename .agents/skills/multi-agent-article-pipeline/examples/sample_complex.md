# Sample Complex Pipeline Config

```json
{
  "status": "CONFIG_WRITTEN",
  "depth": "COMPLEX",
  "total_score": 8,
  "scores": { "novelty": 3, "contention": 2, "scope": 3 },
  "token_budget": 8000,
  "dialectic_enabled": true,
  "red_team_enabled": true,
  "audience": {
    "expertise": "expert",
    "assumed_knowledge": ["EU AI Act", "GDPR", "Cross-border litigation"],
    "must_explain": [],
    "jargon_policy": "no-definitions"
  },
  "topic": "The extraterritorial enforcement of the EU AI Act on US-based decentralised compute networks: a 2026 outlook.",
  "conflict_handling": {
    "C1": "take position",
    "C2": "neutral"
  },
  "config_path": "pipeline_config.json"
}
```
