# Sample Simple Pipeline Config

```json
{
  "status": "CONFIG_WRITTEN",
  "depth": "SIMPLE",
  "total_score": 2,
  "scores": { "novelty": 1, "contention": 0, "scope": 1 },
  "token_budget": 3000,
  "dialectic_enabled": false,
  "red_team_enabled": false,
  "audience": {
    "expertise": "novice",
    "assumed_knowledge": ["Bitcoin", "Wallets"],
    "must_explain": ["Multi-sig", "Cold storage"],
    "jargon_policy": "define-all"
  },
  "topic": "Basic security best practices for new crypto users in 2026.",
  "conflict_handling": {},
  "config_path": "pipeline_config.json"
}
```
