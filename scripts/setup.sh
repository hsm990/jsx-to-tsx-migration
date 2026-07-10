#!/usr/bin/env bash
# Phase 1: install TypeScript deps + write tsconfig.json for the detected bundler.
# Usage: ./setup.sh <project-dir>

set -euo pipefail

PROJECT_DIR="${1:-.}"
cd "$PROJECT_DIR"

if [ ! -f package.json ]; then
  echo "No package.json found in $PROJECT_DIR — is this a JS project root?"
  exit 1
fi

echo "==> Installing TypeScript + React types"
npm install --save-dev typescript @types/react @types/react-dom @types/node

# Detect bundler
if [ -f vite.config.js ] || [ -f vite.config.ts ] || grep -q '"vite"' package.json; then
  BUNDLER="vite"
elif grep -q '"react-scripts"' package.json; then
  BUNDLER="cra"
elif [ -f webpack.config.js ]; then
  BUNDLER="webpack"
else
  BUNDLER="unknown"
fi

echo "==> Detected bundler: $BUNDLER"

case "$BUNDLER" in
  vite)
    cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",
    "strict": false,
    "noUnusedLocals": false,
    "noUnusedParameters": false,
    "noFallthroughCasesInSwitch": true,
    "esModuleInterop": true,
    "forceConsistentCasingInFileNames": true
  },
  "include": ["src"]
}
EOF
    if [ -f vite.config.js ]; then
      mv vite.config.js vite.config.ts
      echo "==> Renamed vite.config.js -> vite.config.ts (check its content compiles)"
    fi
    ;;
  cra)
    cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "lib": ["DOM", "DOM.Iterable", "ES2020"],
    "allowJs": true,
    "skipLibCheck": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "strict": false,
    "forceConsistentCasingInFileNames": true,
    "module": "ESNext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx"
  },
  "include": ["src"]
}
EOF
    ;;
  webpack)
    echo "!! Webpack detected — you also need ts-loader or babel's TS preset."
    echo "   npm install --save-dev ts-loader   (or @babel/preset-typescript)"
    echo "   Then add .ts/.tsx to resolve.extensions in webpack.config.js"
    cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "lib": ["DOM", "DOM.Iterable", "ES2020"],
    "module": "ESNext",
    "moduleResolution": "node",
    "jsx": "react-jsx",
    "strict": false,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "resolveJsonModule": true,
    "noEmit": true
  },
  "include": ["src"]
}
EOF
    ;;
  *)
    echo "!! Could not detect bundler automatically. Wrote a generic tsconfig.json —"
    echo "   review it against your build tool's docs."
    cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "lib": ["DOM", "DOM.Iterable", "ES2020"],
    "module": "ESNext",
    "moduleResolution": "node",
    "jsx": "react-jsx",
    "strict": false,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "resolveJsonModule": true,
    "noEmit": true
  },
  "include": ["src"]
}
EOF
    ;;
esac

echo "==> Done. Next: run rename.sh to convert .jsx/.js files."
