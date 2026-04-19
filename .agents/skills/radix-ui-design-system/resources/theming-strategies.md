# Radix UI Theming Strategies

This resource outlines various methods for styling and theming Radix UI primitives.

## Strategy 1: CSS Variables (Framework-Agnostic)

Best for performance and SSR-friendly projects.

```css
/* globals.css */
:root {
  --color-primary: 220 90% 56%;
  --color-surface: 0 0% 100%;
}

[data-theme="dark"] {
  --color-primary: 220 90% 66%;
  --color-surface: 222 47% 11%;
}
```

```tsx
<Dialog.Content className="bg-[hsl(var(--color-surface))] rounded-[var(--radius-base)]" />
```

## Strategy 2: Tailwind + CVA (Class Variance Authority)

Recommended for Tailwind projects with many component variants.

```tsx
import { cva, type VariantProps } from 'class-variance-authority';

const buttonVariants = cva(
  "inline-flex items-center justify-center rounded-md font-medium",
  {
    variants: {
      variant: {
        default: "bg-primary text-primary-foreground hover:bg-primary/90",
        outline: "border border-input bg-background hover:bg-accent",
        ghost: "hover:bg-accent hover:text-accent-foreground",
      },
      size: {
        default: "h-10 px-4 py-2",
        sm: "h-9 rounded-md px-3",
      },
    },
    defaultVariants: {
      variant: "default",
      size: "default",
    },
  }
);
```

## Strategy 3: Stitches (CSS-in-JS)

Best for runtime theming and scoped styles.

```tsx
import { styled } from '@stitches/react';
import * as Dialog from '@radix-ui/react-dialog';

const StyledContent = styled(Dialog.Content, {
  backgroundColor: '$surface',
  borderRadius: '$md',
  padding: '$6',
  variants: {
    size: {
      small: { width: '300px' },
      medium: { width: '500px' },
    },
  },
});
```

## Animation with Framer Motion

Radix primitives can be animated easily using `AnimatePresence`.

```tsx
import { motion, AnimatePresence } from 'framer-motion';

export function AnimatedDialog({ open, onOpenChange }) {
  return (
    <Dialog.Root open={open} onOpenChange={onOpenChange}>
      <Dialog.Portal forceMount>
        <AnimatePresence>
          {open && (
            <>
              <Dialog.Overlay asChild>
                <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }} />
              </Dialog.Overlay>
              <Dialog.Content asChild>
                <motion.div initial={{ opacity: 0, scale: 0.95 }} animate={{ opacity: 1, scale: 1 }} exit={{ opacity: 0, scale: 0.95 }}>
                  {/* Content */}
                </motion.div>
              </Dialog.Content>
            </>
          )}
        </AnimatePresence>
      </Dialog.Portal>
    </Dialog.Root>
  );
}
```
