# Radix UI Component Patterns

This resource explains key design patterns for building scalable and flexible components with Radix UI.

## Pattern 1: Compound Components with Context
Share state between primitive parts (e.g., sharing a select value between multiple items).

```tsx
<Select.Root onValueChange={onValueChange}>
  <Select.Trigger>
    <Select.Value />
  </Select.Trigger>
  <Select.Portal>
    <Select.Content>
      <Select.Viewport>
        {items.map((item) => (
          <Select.Item key={item.value} value={item.value}>
            <Select.ItemText>{item.label}</Select.ItemText>
          </Select.Item>
        ))}
      </Select.Viewport>
    </Select.Content>
  </Select.Portal>
</Select.Root>
```

## Pattern 2: Polymorphic Components with `asChild`
Render Radix primitives as different elements (e.g., custom buttons or links) while maintaining Radix's internal accessibility and focus management.

```tsx
// Render as Next.js Link
<Dialog.Trigger asChild>
  <Link href="/settings">Open Settings</Link>
</Dialog.Trigger>

// Render as custom button component
<DropdownMenu.Item asChild>
  <Button variant="ghost">Action</Button>
</DropdownMenu.Item>
```
**Why `asChild`?** It prevents nested button/link issues that break accessibility trees.

## Pattern 3: Controlled vs Uncontrolled
Radix components can either manage their own state (uncontrolled) or let you manage it via props (controlled).

```tsx
// Uncontrolled (Radix manages state)
<Tabs.Root defaultValue="tab1">
  <Tabs.Trigger value="tab1">Tab 1</Tabs.Trigger>
</Tabs.Root>

// Controlled (You manage state)
const [activeTab, setActiveTab] = useState('tab1');
<Tabs.Root value={activeTab} onValueChange={setActiveTab}>
  <Tabs.Trigger value="tab1">Tab 1</Tabs.Trigger>
</Tabs.Root>
```
**Rule**: Use controlled when syncing with external state (e.g., URL query parameters or a global store).

## Pattern 4: Forms with Select + Hooks
Integrate Radix primitives with form libraries using Controllers.

```tsx
import { Controller } from 'react-hook-form';

<Controller
  name="country"
  control={control}
  render={({ field }) => (
    <Select.Root onValueChange={field.onChange} value={field.value}>
      <Select.Trigger>...</Select.Trigger>
      <Select.Portal>...</Select.Portal>
    </Select.Root>
  )}
/>
```
