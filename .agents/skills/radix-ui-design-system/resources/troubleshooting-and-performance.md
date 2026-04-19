# Troubleshooting and Performance

This resource provides solutions for common Radix UI implementation issues and strategies for optimizing performance.

## Troubleshooting

### Issue: Dialog doesn't close on Escape key
- **Cause**: The `onEscapeKeyDown` event is being prevented or the `open` state is not synced.
- **Solution**: Ensure you're not calling `e.preventDefault()` on the Escape key in your custom handlers and verify state syncing:
```tsx
<Dialog.Root open={open} onOpenChange={setOpen}>
```

### Issue: Dropdown menu positioning is off
- **Cause**: Parent container has `overflow: hidden` or CSS transforms interfering with positioning logic.
- **Solution**: Use `Dialog.Portal` or `DropdownMenu.Portal` to render the content outside the problematic parent hierarchy.

### Issue: Animations don't work
- **Cause**: Portal content unmounts immediately before the animation can finish.
- **Solution**: Use `forceMount` on the Portal and wrap the content in Framer Motion's `AnimatePresence`.

## Performance Optimization

### 1. Code Splitting
Lazy load primitives to reduce the initial bundle size, especially for rarely used components like `Dialog` or `Popover`.
```tsx
const Dialog = lazy(() => import('@radix-ui/react-dialog'));
```

### 2. Portal Container Reuse
Wrap multiple Radix components in a single provider to share portal containers where possible.
```tsx
<Tooltip.Provider>
  <Tooltip.Root>...</Tooltip.Root>
  <Tooltip.Root>...</Tooltip.Root>
</Tooltip.Provider>
```

### 3. Memoization
Memoize expensive component parts to prevent unnecessary re-renders when the parent state changes.
```tsx
const SelectItems = memo(({ items }) => (
  items.map((item) => <Select.Item key={item.value} value={item.value} />)
));
```
