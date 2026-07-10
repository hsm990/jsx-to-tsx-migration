---
name: jsx-to-tsx-migration
description: Use this skill whenever the user wants to convert a JavaScript/JSX React project (Vite, CRA, or Webpack) to TypeScript/TSX, add TypeScript to an existing React project, or start a brand-new React project and needs to decide between JS and TS at creation time. Trigger on phrases like "convert to TypeScript", "migrate to tsx", "add TS to this project", "create a new vite react project", or any request involving .jsx -> .tsx conversion, tsconfig setup, or typing React components/hooks/props. Covers both the "new project" path (scaffold directly in TS, no migration needed) and the "existing project" path (install deps, add tsconfig, rename files, fix type errors file by file).
---

# JSX → TSX Migration

Helps convert an existing JavaScript/JSX React project to TypeScript/TSX, or scaffold a
new project directly in TypeScript so no migration is ever needed.

## Step 0: Which path?

Ask (or infer from context) which situation applies:

1. **New project** → don't migrate anything. Scaffold directly in TS. See `references/new-project.md`.
2. **Existing JS/JSX project** → run the migration workflow below.

## Migration workflow (existing project)

Follow these phases in order. Do not skip ahead — each phase depends on the last one
compiling cleanly.

### Phase 1 — Install & configure

Run `scripts/setup.sh <project-dir>` (or do it manually — see the script for the exact
commands). This:
- Installs `typescript`, `@types/react`, `@types/react-dom`, `@types/node`
- Detects the bundler (Vite / CRA / Webpack) and writes the matching `tsconfig.json`
- For Vite: renames `vite.config.js` → `vite.config.ts` if present

Do NOT set `"strict": true` yet — leave it off for phase 1 so the project can compile
with loose types first. Flip it on at the very end (Phase 4).

### Phase 2 — Rename files

Run `scripts/rename.sh <project-dir>`. This renames:
- `.jsx` → `.tsx` for any file that contains JSX syntax (components)
- `.js` → `.ts` for plain logic/utils/hooks with no JSX

Rename **leaf components first, composing components last** — i.e. small
presentational components with no children-of-children before the ones that import
and assemble them. This keeps error counts manageable per file. If the project has an
obvious composition root (e.g. `Hero.jsx`, `App.jsx`), rename it last.

### Phase 3 — Fix type errors, file by file

After each rename, run the type checker (`npx tsc --noEmit`) and fix errors in that
file before moving to the next. Common patterns and their fixes are in
`references/common-fixes.md` — consult it for:
- Component props (interfaces)
- useState / useRef / useReducer generics
- Event handler types
- children / React.ReactNode
- Third-party libs without types (Framer Motion, Redux/RTK, GSAP, Three.js)

Keep going until `npx tsc --noEmit` is clean across the whole project.

### Phase 4 — Tighten

Once the project compiles with zero errors:
1. Flip `"strict": true` in `tsconfig.json`
2. Re-run `npx tsc --noEmit`
3. Fix the new errors that strict mode surfaces (mostly implicit `any` and null checks)
4. Optionally enable `noUnusedLocals` / `noUnusedParameters` for cleanliness

### Phase 5 — Verify

- `npm run build` should succeed
- `npm run dev` and click through the app — TS conversion doesn't change runtime
  behavior, so anything broken visually is a real bug introduced during the migration,
  not an expected side effect

## Notes

- CSS files, images, and other assets don't need any changes.
- If a third-party package has no types and no `@types/*` package exists, don't fight
  it — declare a quick module shim (`declare module 'package-name';`) in a
  `src/types/shims.d.ts` file rather than spending time writing full types for a
  dependency.
- For a project the size of a typical freelance client build (10–30 components), this
  whole process is usually 30–60 minutes of file-by-file fixes once Phase 1–2 are
  automated.
