---
name: shadcn
description: Manages shadcn/ui components and projects, providing context, documentation, and usage patterns for building modern design systems.
user-invocable: false
risk: safe
source: https://github.com/shadcn-ui/ui/tree/main/skills/shadcn
---

# shadcn/ui

## Overview

A framework for building high-quality UI components and design systems. Components are added as source code to the project via the CLI, allowing for full customization and ownership.

## 📚 Resources

| Resource | Description |
|----------|-------------|
| [Critical Rules](file:///c:/Users/click/Desktop/BASE_PROJECT/.agents/skills/shadcn/resources/shadcn-critical-rules.md) | Styling, forms, and composition rules. |
| [Patterns & Selection](file:///c:/Users/click/Desktop/BASE_PROJECT/.agents/skills/shadcn/resources/shadcn-patterns-and-selection.md) | Map of needs to components and code examples. |
| [CLI & Workflow](file:///c:/Users/click/Desktop/BASE_PROJECT/.agents/skills/shadcn/resources/shadcn-cli-and-workflow.md) | Initialization, adding components, and smart merging. |

## Core Principles

1. **Use existing components first**: Search the registry before writing custom UI.
2. **Compose, don't reinvent**: Build pages by composing Tabs, Cards, and Forms.
3. **Use semantic tokens**: Prefer `bg-primary` and `text-muted` over raw colors.
4. **Follow accessibility rules**: All overlays must have titles; use `asChild` for triggers.

## Quick CLI Reference

- **Refresh Context**: `npx shadcn@latest info`
- **Search Registry**: `npx shadcn@latest search`
- **Add Component**: `npx shadcn@latest add <component>`
- **View Docs**: `npx shadcn@latest docs <component>`

## Related Rules
- [Styling Rules](file:///c:/Users/click/Desktop/BASE_PROJECT/.agents/skills/shadcn/rules/styling.md)
- [Forms Rules](file:///c:/Users/click/Desktop/BASE_PROJECT/.agents/skills/shadcn/rules/forms.md)
- [Composition Rules](file:///c:/Users/click/Desktop/BASE_PROJECT/.agents/skills/shadcn/rules/composition.md)

## Summary
Build accessible, performant design systems through CLI-driven component composition and semantic styling.
