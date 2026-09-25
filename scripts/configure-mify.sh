#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST="${CODEX_HOME:-${HOME}/.codex}/config.toml"
mkdir -p "$(dirname "$DEST")"
cp "$ROOT/config/codex-mify.toml" "$DEST"
echo "Wrote Mify provider config to $DEST"
echo "Model: amber_ai/gpt-5.6-sol"
