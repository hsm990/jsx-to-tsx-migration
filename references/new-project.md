# New project — scaffold directly in TypeScript

No migration needed. Pick TypeScript at creation time and you get `.tsx` from the start.

## Vite (recommended default)

Non-interactive, one line:

```bash
npm create vite@latest my-app -- --template react-ts
```

Or interactively — `npm create vite@latest`, then answer:
- Project name: `my-app`
- Framework: **React**
- Variant: **TypeScript** (or **TypeScript + SWC** for faster builds — SWC is a good
  default unless the project needs a Babel-only plugin)

This produces `src/App.tsx`, `src/main.tsx`, and a working `tsconfig.json` /
`tsconfig.node.json` out of the box.

## Create React App (legacy, avoid for new projects)

```bash
npx create-react-app my-app --template typescript
```

CRA is in maintenance mode — prefer Vite for new client work unless the client
specifically requires CRA.

## After scaffolding

Same conventions as a migrated project apply going forward:
- Define prop interfaces per component (see `references/common-fixes.md`)
- Keep `strict: true` on from day one — it's the default in the Vite TS templates,
  don't turn it off
