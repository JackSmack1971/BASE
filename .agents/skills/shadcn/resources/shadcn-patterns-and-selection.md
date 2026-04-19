# shadcn/ui Patterns and Selection

This resource provides a quick reference for choosing the right component and writing idiomatic code.

## Component Selection Map

| UI Need | Recommended Component |
|---------|-----------------------|
| **Form Inputs** | `Input`, `Select`, `Combobox`, `Switch`, `Slider` |
| **Simple Toggle** | `ToggleGroup` + `ToggleGroupItem` |
| **Feedback** | `Alert`, `sonner` (toast), `Progress`, `Skeleton` |
| **Navigation** | `Sidebar`, `NavigationMenu`, `Tabs`, `Pagination` |
| **Overlays** | `Dialog`, `Sheet`, `Drawer`, `AlertDialog` |
| **Layout** | `Card`, `Resizable`, `ScrollArea`, `Accordion` |

## Idiomatic Code Patterns

### 1. Form Layout
Prefer `FieldGroup` over generic `div`.
```tsx
<FieldGroup>
  <Field>
    <FieldLabel>Email</FieldLabel>
    <Input id="email" />
  </Field>
</FieldGroup>
```

### 2. Validation & Icons
Use `aria-invalid` for accessiblility and `data-icon` for button internal spacing.
```tsx
<Field data-invalid>
  <Input aria-invalid />
</Field>

<Button>
  <SearchIcon data-icon="inline-start" />
  Search
</Button>
```

### 3. Separation of Concerns
- **Items Grouping**: `SelectItem` must live inside `SelectGroup`.
- **Card Content**: Use `CardHeader`/`CardContent`/`CardFooter` rather than a single large `CardContent`.
- **Skeleton**: Use the `Skeleton` component for loading states instead of custom animated divs.
