# Visual TDD Helper Patterns

Use these patterns to turn Playwright into a closed-loop visual QA system that talks to your other skills.

## The `visualTddCycle()` Pattern

When working in a TDD loop, use this sequence to ensure zero visual regression:

1. **Capture Baseline**: For a new component `Button.tsx`, create `Button.test.tsx` and run with `--update-snapshots`.
2. **Implement Logic**: Add props/state. Run visual tests. 
3. **Analyze Drift**: If `toHaveScreenshot()` fails:
   - Determine if it's "intended drift" (e.g., you changed the padding).
   - If unintended, roll back and fix styles.
4. **Agent Action**: As an agent, provide the diff analysis and ask: *"Visual drift of 15% detected in Shadcn Button. Is this intended (Update Baseline) or a regression (Fix Code)?"*
5. **Approval Loop**:
   - If user approves baseline update → run `npx playwright test --update-snapshots`.
   - Commit the new `.png` files following `semantic-versioning` rules.

## Self-Healing Locator Strategy

To synergize with `frontend-verify`, use resilient locators that survive re-styling:

```typescript
// ❌ Fragile: breaks if Tailwind classes change
await page.locator('.flex.items-center.bg-blue-500').click();

// ✅ Resilient: semantic role and accessible name
await page.getByRole('button', { name: /submit/i }).click();

// ✅ Visual Snapshot Target
const form = page.getByTestId('auth-form');
await expect(form).toHaveScreenshot('auth-form-baseline.png', {
  maxDiffPixelRatio: 0.1,
  mask: [page.locator('.dynamic-user-id')] // Mask dynamic content
});
```
