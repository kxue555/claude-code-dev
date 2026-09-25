#!/usr/bin/env bash
set -euo pipefail

export PATH="${HOME}/.local/bin:${PATH}"

if codex login status 2>/dev/null | grep -q "Logged in"; then
  echo "Codex already authenticated."
  exit 0
fi

if [[ -n "${CODEX_ACCESS_TOKEN:-}" ]]; then
  printf '%s' "$CODEX_ACCESS_TOKEN" | codex login --with-access-token
  echo "Authenticated with CODEX_ACCESS_TOKEN."
  exit 0
fi

if [[ -n "${OPENAI_API_KEY:-}" ]]; then
  printf '%s' "$OPENAI_API_KEY" | codex login --with-api-key
  echo "Authenticated with OPENAI_API_KEY."
  exit 0
fi

echo "No Codex credentials found. Set OPENAI_API_KEY or CODEX_ACCESS_TOKEN in environment secrets."
exit 1
