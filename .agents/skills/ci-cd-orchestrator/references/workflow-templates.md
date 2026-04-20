# Workflow Templates

Use these canonical blocks when generating or modifying GitHub Actions.

## 1. Hybrid Orchestrator (Main)
```yaml
name: Agent Orchestrator Run
on:
  workflow_dispatch:
    inputs:
      matrix_config:
        description: 'JSON matrix of services to test/deploy'
        required: true
        default: '{"service": ["frontend", "api"], "env": ["staging"]}'

jobs:
  gatekeep:
    runs-on: ubuntu-latest
    strategy:
      fail-fast: false
      matrix: ${{ fromJSON(github.event.inputs.matrix_config) }}
    steps:
      - uses: actions/checkout@v4
        with: { fetch-depth: 0 }

      - name: Production Audit
        if: matrix.service == 'api'
        run: npx @agent/production-code-audit .

      - name: Visual Regression
        if: matrix.service == 'frontend'
        uses: ./.agent/skills/playwright-visual-regression
        with: { shard: ${{ matrix.shard || 1 }} }

  deploy-frontend:
    needs: gatekeep
    if: success() && contains(github.event.inputs.matrix_config, 'frontend')
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Vercel Deploy
        run: vercel deploy --prebuilt --prod --token=${{ secrets.VERCEL_TOKEN }}

  deploy-infra:
    needs: gatekeep
    if: success() && contains(github.event.inputs.matrix_config, 'infra')
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Terraform Apply
        run: terraform apply -auto-approve
```

## 2. Docker Build-Push (Synergy)
```yaml
  build-docker:
    runs-on: ubuntu-latest
    steps:
      - uses: docker/setup-buildx-action@v3
      - uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: ${{ secrets.DOCKER_REGISTRY }}/${{ github.repository }}:latest
          cache-from: type=gha
          cache-to: type=gha,mode=max
```

## 3. Semantic Versioning Gate
```yaml
  release:
    needs: [deploy-frontend, deploy-infra]
    runs-on: ubuntu-latest
    permissions: { contents: write }
    steps:
      - uses: actions/checkout@v4
        with: { fetch-depth: 0 }
      - name: Semantic Release
        run: npx semantic-release
```
