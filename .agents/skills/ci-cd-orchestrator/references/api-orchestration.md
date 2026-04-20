# API Orchestration

Use these patterns to trigger workflows directly from the Master Antigravity planning loop.

## 1. REST API Trigger (`curl`)
To trigger a `workflow_dispatch` event, send a POST request to the GitHub API.

```bash
curl -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${{ secrets.GH_PAT }}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/actions/workflows/WORKFLOW_FILE_OR_ID/dispatches \
  -d '{"ref":"main","inputs":{"matrix_config":"{\"service\":[\"api\"],\"env\":[\"staging\"]}"}}'
```

## 2. GitHub CLI Trigger (`gh`)
If the runner or local environment has `gh` installed, use this more readable syntax:

```bash
gh workflow run WORKFLOW_NAME \
  --ref main \
  -f matrix_config='{"service":["api"], "env":["staging"]}'
```

## 3. Monitoring Runs
Use the `gh run list` and `gh run watch` commands to monitor the status of the triggered workflow.

```bash
# Get ID of the last run
run_id=$(gh run list --workflow WORKFLOW_FILE --limit 1 --json databaseId --jq '.[0].databaseId')

# Watch until completion
gh run watch $run_id
```

## Matrix Configuration Protocol
For agentic runs, always format the `matrix_config` input as a JSON string containing:
- `service`: List of affected services (e.g., `["frontend", "auth-api", "db"]`).
- `shard`: (Optional) Shard index for parallel testing.
- `audit_depth`: (Optional) `low`, `medium`, or `high` for the `production-code-audit` gate.
