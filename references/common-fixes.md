# Common fixes during Phase 3 (file-by-file type errors)

## Component props

Always define an interface, even for tiny components:

```tsx
interface HeroProps {
  title: string;
  ctaLabel?: string;          // optional prop
  onCtaClick?: () => void;
  variant: 'light' | 'dark';  // union instead of loose string
}

export default function Hero({ title, ctaLabel, onCtaClick, variant }: HeroProps) {
  ...
}
```

## children

```tsx
interface PanelProps {
  children: React.ReactNode;
}
// or, more concisely:
function Panel({ children }: React.PropsWithChildren<{}>) { ... }
```

## useState

Let TS infer when the initial value is unambiguous. Add a generic when it's `null`/`undefined`
initially or a union:

```tsx
const [count, setCount] = useState(0);                       // inferred: number
const [user, setUser] = useState<User | null>(null);         // explicit needed
const [status, setStatus] = useState<'idle' | 'loading' | 'error'>('idle');
```

## useRef

```tsx
const divRef = useRef<HTMLDivElement>(null);
const timeoutRef = useRef<ReturnType<typeof setTimeout>>();
```

## Event handlers

```tsx
const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => { ... };
const handleClick = (e: React.MouseEvent<HTMLButtonElement>) => { ... };
const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => { e.preventDefault(); ... };
```

## Custom hooks

Type the return value explicitly, especially tuples:

```tsx
function useToggle(initial = false): [boolean, () => void] {
  const [value, setValue] = useState(initial);
  const toggle = () => setValue(v => !v);
  return [value, toggle];
}
```

## Framer Motion

Types ship with the package — usually no extra install needed. If a `motion.div`
prop errors on a custom variant object, type the variants explicitly:

```tsx
import { Variants } from 'framer-motion';

const cardVariants: Variants = {
  hidden: { opacity: 0, y: 20 },
  visible: { opacity: 1, y: 0 },
};
```

## Redux Toolkit / RTK Query

Type the store and hooks once in `src/store/hooks.ts`:

```tsx
import { TypedUseSelectorHook, useDispatch, useSelector } from 'react-redux';
import type { RootState, AppDispatch } from './store';

export const useAppDispatch: () => AppDispatch = useDispatch;
export const useAppSelector: TypedUseSelectorHook<RootState> = useSelector;
```

Then use `useAppSelector` / `useAppDispatch` instead of the untyped versions everywhere.

## GSAP / Three.js

Both ship their own types. If you get "cannot find module" errors, install:

```bash
npm install --save-dev @types/three
```

GSAP includes types in the base package — no `@types/gsap` needed.

## No types available for a package

Don't burn time hand-typing a whole third-party library. Add a shim:

```ts
// src/types/shims.d.ts
declare module 'some-untyped-package';
```

## RTL / bilingual components (Arabic + English)

No special typing needed for RTL itself — it's a CSS/attribute concern (`dir="rtl"`),
not a type concern. Just make sure locale/direction props are typed as a union rather
than `string`:

```tsx
interface LocaleProps {
  locale: 'ar' | 'en' | 'fr';
  dir: 'rtl' | 'ltr';
}
```

## CSS-in-panel / mockup components with many style props

If a component takes a large inline style object (like CSS-drawn dashboard/CRM panel
mockups), type it as `React.CSSProperties` rather than `any`:

```tsx
interface PanelProps {
  style?: React.CSSProperties;
}
```
