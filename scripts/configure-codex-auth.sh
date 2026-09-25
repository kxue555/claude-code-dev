#!/usr/bin/env bash
set -euo pipefail

export PATH="${HOME}/.local/bin:${PATH}"

if [[ -z "${OPENAI_API_KEY:-}" ]]; then
  echo "OPENAI_API_KEY is not set; skipping Codex auth configuration." >&2
  exit 1
fi

# Non-interactive API-key login for Cloud Agent / CI environments
printenv OPENAI_API_KEY | codex login --with-api-key
codex login status
codex doctor --summary 2>&1 | head -40 || true
