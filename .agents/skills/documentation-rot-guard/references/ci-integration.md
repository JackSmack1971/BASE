## Pre-Push/CI Hook Pattern
Integrate this into your GitHub Actions or Husky hooks for proactive guarding:

```bash
# Proactive scan on affected packages
npx turbo run docs-rot-audit --affected --filter=...

# Result Audit
if [ -d ".docs-fix" ]; then
  echo "❌ Documentation Rot Detected. Review proposals in .docs-fix/"
  exit 1
fi
```

## Self-Documenting Loop
1.  Developer changes `@repo/api` internal logic.
2.  `turbo run docs-rot-audit --affected` fails in CI.
3.  Agent generates a draft PR with updated `README.md` and `@repo/api` JSDoc in `packages/api/.docs-fix/`.
4.  Developer reviews, approves, and docs are synced in one commit.
