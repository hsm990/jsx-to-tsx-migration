# jsx-to-tsx-migration

Agent Skill for converting a JavaScript/JSX React project to TypeScript/TSX — or
scaffolding a new React project directly in TypeScript so no migration is ever
needed. Works with Vite, Create React App, and Webpack projects.

Compatible with any AI coding agent that supports the
[Agent Skills](https://www.anthropic.com/news/agent-skills) open standard —
confirmed working with **Claude Code**, **Codex CLI**, **Gemini CLI**, and
**OpenCode**. Should also work with other Agent-Skills-compatible tools via the
`.agents/skills/` fallback directory.

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

Works with **Claude Code**, **Codex CLI**, **Gemini CLI**, and **OpenCode** — all
read the same open [Agent Skills](https://www.anthropic.com/news/agent-skills)
`SKILL.md` format.

### One line (any of the four agents above)

Paste this into your agent — it fetches the install instructions, figures out which
agent it's running in, and installs itself to the right directory:

```
Fetch and follow instructions from https://raw.githubusercontent.com/hsm990/jsx-to-tsx-migration/main/.agents/INSTALL.md
```

### Manual install

Pick the directory row for your agent and scope:

| Agent       | Personal (all projects)      | Project (this repo only) |
|-------------|-------------------------------|----------------------------|
| Claude Code | `~/.claude/skills/`           | `.claude/skills/`          |
| Codex CLI   | `~/.codex/skills/`            | `.codex/skills/`           |
| Gemini CLI  | `~/.gemini/skills/`           | `.gemini/skills/`          |
| OpenCode    | `~/.config/opencode/skills/`  | `.opencode/skills/`        |

```bash
git clone https://github.com/hsm990/jsx-to-tsx-migration.git <target-dir>/jsx-to-tsx-migration
```

Or download the latest release `.zip` from the
[Releases page](https://github.com/hsm990/jsx-to-tsx-migration/releases) and extract
it into the matching directory above.

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
