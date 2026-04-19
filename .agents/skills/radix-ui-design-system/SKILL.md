---
name: radix-ui-design-system
description: "Build accessible design systems with Radix UI primitives. Headless component customization, theming strategies, and compound component patterns for production-grade UI libraries."
risk: safe
source: self
date_added: "2026-02-27"
---

# Radix UI Design System

## Overview

Build production-ready, accessible design systems using Radix UI primitives with full customization control and zero style opinions.

## 📚 Resources

| Resource | Description |
|----------|-------------|
| [Theming Strategies](file:///c:/workspaces/antigravity-meta/.agents/skills/radix-ui-design-system/resources/theming-strategies.md) | CSS Variables, Tailwind + CVA, and Animation patterns. |
| [Component Patterns](file:///c:/workspaces/antigravity-meta/.agents/skills/radix-ui-design-system/resources/component-patterns.md) | Compound components, Polymorphism (`asChild`), and Forms. |
| [Primitives Reference](file:///c:/workspaces/antigravity-meta/.agents/skills/radix-ui-design-system/resources/primitives-reference.md) | Dialog, Dropdown, Tabs, Tooltip, and Popover structures. |
| [A11y Checklist](file:///c:/workspaces/antigravity-meta/.agents/skills/radix-ui-design-system/resources/accessibility-checklist.md) | Focus management and component-specific audit items. |
| [Troubleshooting](file:///c:/workspaces/antigravity-meta/.agents/skills/radix-ui-design-system/resources/troubleshooting-and-performance.md) | Common issues, animations, and performance optimization. |

## Core Principles

### 1. Accessibility First
Radix handles keyboard navigation, screen reader support, and focus management automatically. Never override these features; enhance them.

### 2. Headless Architecture
Radix provides **behavior**, you provide **appearance**. This allows full styling control without fighting framework defaults.

### 3. Composition
Build complex interfaces by nesting simple primitives. This promotes highly reusable and maintainable component code.

## Getting Started

### Installation
```bash
npm install @radix-ui/react-{dialog,dropdown-menu,tabs,tooltip}
```

### Basic Pattern
```tsx
import * as Dialog from '@radix-ui/react-dialog';

<Dialog.Root>
  <Dialog.Trigger asChild><button>Open</button></Dialog.Trigger>
  <Dialog.Portal>
    <Dialog.Overlay className="bg-black/50" />
    <Dialog.Content>
      <Dialog.Title>Title</Dialog.Title>
      <Dialog.Description>Description</Dialog.Description>
      {/* Content */}
      <Dialog.Close />
    </Dialog.Content>
  </Dialog.Portal>
</Dialog.Root>
```

## Related Skills
- `tailwind-design-system`: Tailwind integration patterns.
- `react-patterns`: Advanced React composition.
- `accessibility-compliance`: WCAG verification.

## Summary
Build accessible, headless UI components with zero style lock-in.
