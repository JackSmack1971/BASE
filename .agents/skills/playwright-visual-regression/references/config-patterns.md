# Playwright & Tailwind Configuration

Optimized configuration for UI-heavy Shadcn/Tailwind projects.

## `playwright.config.ts` Boilerplate

```typescript
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: 'html',
  use: {
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    // Global color scheme for visual consistency
    colorScheme: 'light',
  },
  expect: {
    toHaveScreenshot: {
      // Allows for slight anti-aliasing differences in Tailwind
      maxDiffPixelRatio: 0.05,
      threshold: 0.2,
    },
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'Mobile Safari',
      use: { ...devices['iPhone 12'] },
    },
  ],
});
```

## CSS Layering
Ensure your Playwright tests load the same Tailwind layers as your dev server by configuring `stylePath` in your component testing setup to point to `globals.css`.
