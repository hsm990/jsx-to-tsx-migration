# Install jsx-to-tsx-migration skill (cross-agent)

You are an AI coding agent. Follow these steps yourself, right now, in order.
Do not just describe them to the user — execute them.

## 1. Identify which agent you are

You already know this from your own runtime/harness. Use the row below that
matches you:

| Agent       | Personal (all projects)         | Project (this repo only) |
|-------------|----------------------------------|---------------------------|
| Claude Code | `~/.claude/skills/`              | `.claude/skills/`         |
| Codex CLI   | `~/.codex/skills/`               | `.codex/skills/`          |
| Gemini CLI  | `~/.gemini/skills/`              | `.gemini/skills/`         |
| OpenCode    | `~/.config/opencode/skills/`     | `.opencode/skills/`       |

If you're some other Agent-Skills-compatible tool not listed here, use
`.agents/skills/` (project) or `~/.agents/skills/` (personal) — this is the
universal fallback directory several agents (including Codex and OpenCode)
also read.

## 2. Determine install scope

If you're already working inside a specific project the user wants this
scoped to, install as **project** scope. Otherwise, ask the user in one short
message: "Install jsx-to-tsx-migration for all your projects, or just this
one?" Default to **personal** scope if the context makes this ambiguous and
you can't ask.

Set `<TARGET>` to the directory from the table above (personal or project,
per your agent and the chosen scope) followed by `jsx-to-tsx-migration`, e.g.
`~/.claude/skills/jsx-to-tsx-migration` or `.codex/skills/jsx-to-tsx-migration`.

## 3. Create the target directory and download the skill files

```bash
mkdir -p <TARGET>/scripts <TARGET>/references
curl -sL https://raw.githubusercontent.com/hsm990/jsx-to-tsx-migration/main/SKILL.md -o <TARGET>/SKILL.md
curl -sL https://raw.githubusercontent.com/hsm990/jsx-to-tsx-migration/main/scripts/setup.sh -o <TARGET>/scripts/setup.sh
curl -sL https://raw.githubusercontent.com/hsm990/jsx-to-tsx-migration/main/scripts/rename.sh -o <TARGET>/scripts/rename.sh
curl -sL https://raw.githubusercontent.com/hsm990/jsx-to-tsx-migration/main/references/new-project.md -o <TARGET>/references/new-project.md
curl -sL https://raw.githubusercontent.com/hsm990/jsx-to-tsx-migration/main/references/common-fixes.md -o <TARGET>/references/common-fixes.md
chmod +x <TARGET>/scripts/setup.sh <TARGET>/scripts/rename.sh
```

If `curl` isn't available, use `wget -O` instead, or clone the whole repo and
copy its contents into `<TARGET>`:

```bash
git clone https://github.com/hsm990/jsx-to-tsx-migration.git /tmp/jsx-to-tsx-migration
mkdir -p <TARGET>
cp -r /tmp/jsx-to-tsx-migration/SKILL.md /tmp/jsx-to-tsx-migration/scripts /tmp/jsx-to-tsx-migration/references <TARGET>/
chmod +x <TARGET>/scripts/*.sh
rm -rf /tmp/jsx-to-tsx-migration
```

## 4. Gemini CLI extra step (extension registry, optional)

Gemini CLI can also register skills as an extension. This step is optional —
the `.gemini/skills/` install above already works without it. Only do this if
you're specifically Gemini CLI and want it listed in the extension registry:

```bash
cat > <TARGET-PARENT>/gemini-extension.json << 'EOF'
{
  "name": "jsx-to-tsx-migration",
  "version": "1.0.0",
  "description": "Convert a JS/JSX React project to TypeScript/TSX, or scaffold new projects directly in TS.",
  "skills": ["jsx-to-tsx-migration"]
}
EOF
```
(`<TARGET-PARENT>` is the skills directory itself, e.g. `.gemini/skills/`.)

## 5. Verify

```bash
ls <TARGET> <TARGET>/scripts <TARGET>/references
```
You should see `SKILL.md`, `scripts/setup.sh`, `scripts/rename.sh`,
`references/new-project.md`, and `references/common-fixes.md`.

## 6. Confirm to the user

Tell the user, briefly:
- The skill is installed at `<TARGET>`.
- It's active starting now (or next session, if your tool requires a restart
  to pick up new skills — check and say which applies to you).
- One-line summary: it converts a JS/JSX React project (Vite, CRA, or
  Webpack) to TypeScript/TSX — installs deps, writes tsconfig, renames
  files, then fixes type errors file by file — or, for a brand-new project,
  points straight to scaffolding in TypeScript so no migration is needed.
- They can test it immediately by saying something like "convert this
  project to TypeScript" and confirming you ask which path applies (new
  project vs. existing project) before proceeding.

Do not print the full SKILL.md contents back to the user unless they ask —
just confirm installation succeeded.
