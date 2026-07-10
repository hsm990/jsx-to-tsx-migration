# jsx-to-tsx-migration

Agent Skill for converting a JavaScript/JSX React project to TypeScript/TSX — or
scaffolding a new React project directly in TypeScript so no migration is ever
needed. Works with Vite, Create React App, and Webpack projects.

Compatible with any AI coding agent that supports the
[Agent Skills](https://www.anthropic.com/news/agent-skills) open standard:
Claude Code, Cursor, Codex, Gemini CLI, OpenCode, and others.

## What it does

- Detects your bundler (Vite / CRA / Webpack) and writes a matching `tsconfig.json`
- Installs `typescript`, `@types/react`, `@types/react-dom`, `@types/node`
- Renames `.jsx` → `.tsx` and `.js` → `.ts` (skips ambiguous files for manual review)
- Walks the codebase file-by-file fixing type errors using proven patterns for props,
  hooks, event handlers, Framer Motion, Redux Toolkit/RTK Query, GSAP, Three.js, and
  RTL/bilingual components
- Flips on `strict: true` only after the whole project compiles clean
- Points to the zero-migration path (`--template react-ts`) when starting fresh

## Install

### Claude Code

```bash
git clone https://github.com/hsm990/jsx-to-tsx-migration.git ~/.claude/skills/jsx-to-tsx-migration
```

Or download the latest release `.zip` from the
[Releases page](https://github.com/hsm990/jsx-to-tsx-migration/releases) and extract
it into `.claude/skills/` (project-level) or `~/.claude/skills/` (global).

### Cursor / Codex / Gemini CLI / OpenCode

Extract into whichever skills directory your agent reads from (check your tool's docs
for the exact path — most follow the same `skills/<name>/SKILL.md` convention).

### Manual / any agent

```bash
git clone https://github.com/hsm990/jsx-to-tsx-migration.git
```

Then point your agent at the `SKILL.md` file directly, or copy the folder into
whatever skills directory it scans.

## Usage

Once installed, just tell your agent:

- *"Convert this project to TypeScript"* — triggers the full migration workflow
- *"Create a new Vite React project"* — triggers the zero-migration scaffold path

The agent reads `SKILL.md`, runs `scripts/setup.sh` and `scripts/rename.sh`, then
fixes type errors using `references/common-fixes.md` as a guide.

## Structure

```
jsx-to-tsx-migration/
├── SKILL.md                    # triggers + workflow
├── scripts/
│   ├── setup.sh                 # installs deps, detects bundler, writes tsconfig
│   └── rename.sh                # .jsx -> .tsx / .js -> .ts
└── references/
    ├── new-project.md           # scaffold directly in TS (no migration)
    └── common-fixes.md          # typing patterns for common libs
```

## License

MIT — see [LICENSE](LICENSE).

## Related

- [git-workflow-skill](https://github.com/hsm990/git-workflow-skill) — professional
  Git workflow skill for AI coding agents
