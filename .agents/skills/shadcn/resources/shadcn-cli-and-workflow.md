# shadcn/ui CLI and Workflow Reference

This resource provides a guide to the CLI commands and project lifecycle for shadcn/ui.

## Key CLI Commands

| Action | Command |
|--------|---------|
| **Init** | `npx shadcn@latest init --preset <code|name>` |
| **Info** | `npx shadcn@latest info --json` |
| **Add** | `npx shadcn@latest add <component>` |
| **Docs** | `npx shadcn@latest docs <component>` |
| **Search** | `npx shadcn@latest search <registry> -q "query"` |
| **Diff** | `npx shadcn@latest add <component> --diff <file>` |

## The "Smart Merge" Workflow

When updating existing components while preserving local changes:

1. **Check Diff**: `npx shadcn@latest add <component> --dry-run` to see affected files.
2. **Review Changes**: `npx shadcn@latest add <component> --diff <file>` to see upstream updates.
3. **Merge**: Manually apply upstream improvements (accessibility, fixes) to your local custom component.
4. **Never Overwrite**: Avoid using `--overwrite` unless you have explicitly backed up or the user approved.

## Project Context Fields
- **`isRSC`**: Affects `"use client"` directive usage.
- **`tailwindVersion`**: `v3` uses `tailwind.config.js`; `v4` uses `@theme` in CSS.
- **`iconLibrary`**: Determines if you import from `lucide-react`, `tabler`, etc.
- **`packageManager`**: Use the correct runner: `npx`, `pnpm dlx`, or `bunx`.

## Adding third-party Components
When adding components from community registries (e.g. `@magicui`):
- **Check Aliases**: Verify imports use the project's `@/` or `~/` prefix.
- **Check Icons**: Swap any default `lucide-react` icons for the project's `iconLibrary`.
