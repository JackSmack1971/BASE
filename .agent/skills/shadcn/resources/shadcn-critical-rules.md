# shadcn/ui Critical Rules and Patterns

These rules are non-negotiable when building with shadcn/ui to ensure accessibility, consistency, and maintainability.

## Styling & Tailwind Rules

- **Semantic Tokens**: Use `bg-primary`, `text-muted-foreground`, etc. Never use raw hex/HSL values or raw Tailwind colors (e.g., `bg-blue-500`) unless explicitly required.
- **Layout vs. Styling**: Use `className` for spacing (gap, padding) and layout (flex, grid), not for overriding component cores.
- **Modern Shorthands**: Use `size-10` (replaces `w-10 h-10`) and `truncate` (replaces `overflow-hidden text-ellipsis...`).
- **Standard Spacing**: Use `flex flex-col gap-4` instead of legacy `space-y-4`.
- **Conditional Classes**: Use the `cn()` utility for all conditional logic.

## Form and Input Patterns

- **Standard Layout**: Use `FieldGroup` + `Field`. Never use raw `div` for form layout.
- **Control Grouping**: Use `InputGroup` with its sub-components (`InputGroupInput`, `InputGroupTextarea`).
- **Toggle Choice**: For 2-7 options, use `ToggleGroup` instead of individual buttons.
- **Validation State**:
  - `data-invalid`: Apply to the `Field` container.
  - `aria-invalid`: Apply to the specific input control.

## Component Composition

- **Accessibility**: All `Dialog`, `Sheet`, and `Drawer` components MUST have a `Title` component. Use `sr-only` if it should be visually hidden.
- **RSC Safety**: Components using `useState`, `useEffect`, or event handlers must include `"use client"` if the project's `isRSC` field is true.
- **Card Integrity**: Use the full suite: `CardHeader`, `CardTitle`, `CardDescription`, `CardContent`, and `CardFooter`.
- **Fallback UI**: `Avatar` always requires an `AvatarFallback` for broken image states.
- **AsChild Pattern**: Use `asChild` for trigger components to maintain prop forwarding for Radix-based components.
