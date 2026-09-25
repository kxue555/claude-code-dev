#!/usr/bin/env bash
set -euo pipefail

export PATH="${HOME}/.local/bin:${PATH}"

if command -v codex >/dev/null 2>&1; then
  echo "Codex CLI already installed: $(codex --version)"
  exit 0
fi

echo "Installing Codex CLI..."
curl -fsSL https://chatgpt.com/codex/install.sh | sh

export PATH="${HOME}/.local/bin:${PATH}"
echo "Codex CLI installed: $(codex --version)"
