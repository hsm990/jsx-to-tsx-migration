#!/usr/bin/env bash
# Phase 2: rename .jsx -> .tsx (always) and .js -> .ts (only if it looks like plain
# logic, i.e. no JSX tags detected) inside src/.
# Usage: ./rename.sh <project-dir>

set -euo pipefail

PROJECT_DIR="${1:-.}"
SRC_DIR="$PROJECT_DIR/src"

if [ ! -d "$SRC_DIR" ]; then
  echo "No src/ directory found at $SRC_DIR — adjust the path or run manually."
  exit 1
fi

echo "==> Renaming .jsx -> .tsx"
find "$SRC_DIR" -name "*.jsx" | while read -r f; do
  new="${f%.jsx}.tsx"
  git mv "$f" "$new" 2>/dev/null || mv "$f" "$new"
  echo "  $f -> $new"
done

echo "==> Renaming .js -> .ts (skipping files that contain JSX tags — check those manually)"
find "$SRC_DIR" -name "*.js" | while read -r f; do
  if grep -qE '<[A-Za-z][A-Za-z0-9]*[ />]' "$f"; then
    echo "  SKIP (looks like it may contain JSX, rename to .tsx by hand if so): $f"
    continue
  fi
  new="${f%.js}.ts"
  git mv "$f" "$new" 2>/dev/null || mv "$f" "$new"
  echo "  $f -> $new"
done

echo "==> Done. Next: run 'npx tsc --noEmit' inside $PROJECT_DIR and fix errors file by file."
echo "    See references/common-fixes.md for the usual patterns."
