# Radix UI Primitives Reference

This resource provides a quick reference for the structure and sub-components of common Radix UI primitives.

## Dialog (Modal)
High-level structure for creating accessible modal dialogs.
```tsx
<Dialog.Root>               {/* State container */}
  <Dialog.Trigger />        {/* Opens dialog */}
  <Dialog.Portal>           {/* Renders in portal */}
    <Dialog.Overlay />      {/* Backdrop */}
    <Dialog.Content>        {/* Modal content */}
      <Dialog.Title />      {/* Required for a11y */}
      <Dialog.Description />{/* Required for a11y */}
      <Dialog.Close />      {/* Closes dialog */}
    </Dialog.Content>
  </Dialog.Portal>
</Dialog.Root>
```

## Dropdown Menu
Standard pattern for context and navigation menus.
```tsx
<DropdownMenu.Root>
  <DropdownMenu.Trigger />
  <DropdownMenu.Portal>
    <DropdownMenu.Content>
      <DropdownMenu.Item />
      <DropdownMenu.Separator />
      <DropdownMenu.CheckboxItem />
      <DropdownMenu.RadioGroup>
        <DropdownMenu.RadioItem />
      </DropdownMenu.RadioGroup>
      <DropdownMenu.Sub>   {/* Nested menus */}
        <DropdownMenu.SubTrigger />
        <DropdownMenu.SubContent />
      </DropdownMenu.Sub>
    </DropdownMenu.Content>
  </DropdownMenu.Portal>
</DropdownMenu.Root>
```

## Tabs
For switching between multiple views within a single container.
```tsx
<Tabs.Root defaultValue="tab1">
  <Tabs.List>
    <Tabs.Trigger value="tab1" />
    <Tabs.Trigger value="tab2" />
  </Tabs.List>
  <Tabs.Content value="tab1" />
  <Tabs.Content value="tab2" />
</Tabs.Root>
```

## Tooltip
For providing brief contextual information on hover or focus.
```tsx
<Tooltip.Provider delayDuration={200}>
  <Tooltip.Root>
    <Tooltip.Trigger />
    <Tooltip.Portal>
      <Tooltip.Content side="top" align="center">
        Tooltip Content
        <Tooltip.Arrow />
      </Tooltip.Content>
    </Tooltip.Portal>
  </Tooltip.Root>
</Tooltip.Provider>
```

## Popover
For floating content triggered by a button, like a settings menu or picker.
```tsx
<Popover.Root>
  <Popover.Trigger />
  <Popover.Portal>
    <Popover.Content side="bottom" align="start">
      Content
      <Popover.Arrow />
      <Popover.Close />
    </Popover.Content>
  </Popover.Portal>
</Popover.Root>
```
