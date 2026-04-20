## Canonical turbo.json Configuration
```json
{
  "$schema": "https://turbo.build/schema.json",
  "tasks": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": [".next/**", "!.next/cache/**", "dist/**"]
    },
    "lint": {
      "dependsOn": ["^build"]
    },
    "test": {
      "dependsOn": ["^build"],
      "inputs": ["src/**/*.test.ts", "src/**/*.test.tsx", "vitest.config.ts"]
    },
    "dev": {
      "cache": false,
      "persistent": true
    },
    "index-rag": {
      "dependsOn": ["build"],
      "cache": false
    }
  }
}
```

## Shared Tailwind Config Package (@repo/tailwind-config)
```javascript
// packages/tailwind-config/tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        brand: "#0070f3",
      },
    },
  },
  plugins: [require("@tailwindcss/typography")],
};
```

## Consumer App tailwind.config.ts
```typescript
import sharedConfig from "@repo/tailwind-config";

export default {
  presets: [sharedConfig],
  content: [
    "./src/**/*.{ts,tsx}",
    "../../packages/ui/src/**/*.{ts,tsx}",
  ],
};
```
