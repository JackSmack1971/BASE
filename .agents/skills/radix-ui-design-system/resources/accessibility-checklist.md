# Radix UI Accessibility Checklist

Radix UI handles many accessibility features automatically, but developers must ensure proper implementation to meet WCAG standards.

## General Requirements

Every component using Radix primitives must have:

- [ ] **Focus Management**: Focus indicators are clearly visible on all interactive elements.
- [ ] **Keyboard Navigation**: Full support for `Tab`, `Arrow keys`, `Enter`, and `Esc`.
- [ ] **ARIA Labels**: Meaningful labels (`aria-label`) for screen readers on icon-only buttons.
- [ ] **Color Contrast**: WCAG AA minimum (4.5:1 for text, 3:1 for UI components).
- [ ] **Error States**: Clear error messages defined with `aria-invalid` and `aria-describedby`.
- [ ] **Loading States**: Proper use of `aria-busy` during asynchronous operations.

## Dialog (Modal) Specifics
- [ ] `Dialog.Title` is present and rendered (required for screen readers).
- [ ] `Dialog.Description` provides context for the modal's purpose.
- [ ] Focus is trapped inside the modal when open.
- [ ] `Esc` key successfully closes the dialog.
- [ ] Focus is returned to the original trigger element upon closing.

## Dropdown & Select Specifics
- [ ] `Arrow keys` allow navigation between items.
- [ ] Type-ahead search works for long lists.
- [ ] Selected state is indicated both visually and with `aria-selected` or relevant ARIA attributes.
- [ ] The menu closes when `Esc` or `Enter/Space` on an item is pressed.

## Best Practices
- ✅ **Always use `asChild`** to avoid unnecessary wrapper divs that can break accessibility hierarchies.
- ✅ **Provide semantic HTML** elements (e.g., using `asChild` to render a `button` or `nav`).
- ✅ **Benchmark** your components using the `@accessibility-compliance` skill.
