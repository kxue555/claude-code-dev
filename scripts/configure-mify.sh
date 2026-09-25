#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST="${CODEX_HOME:-${HOME}/.codex}/config.toml"
mkdir -p "$(dirname "$DEST")"
if [[ -f "$DEST" ]] && grep -qE '^\[(desktop|plugins\.|mcp_servers\.|marketplaces\.)' "$DEST"; then
  python3 - "$DEST" <<'PY'
import sys
path = sys.argv[1]
text = open(path, encoding="utf-8").read()
needle = 'env_key = "PROXY_API_KEY"\n'
if needle not in text:
    anchor = 'base_url = "https://api.llm.mioffice.cn/v1"\n'
    if anchor not in text:
        sys.exit("mify base_url not found; refusing to rewrite config")
    text = text.replace(anchor, anchor + needle, 1)
    open(path, "w", encoding="utf-8").write(text)
    print(f"Added env_key to existing config {path}")
else:
    print(f"env_key already set in {path}")
PY
else
  cp "$ROOT/config/codex-mify.toml" "$DEST"
  echo "Wrote Mify provider config to $DEST"
fi
echo "Model: amber_ai/gpt-5.6-sol"
echo "Provider key: PROXY_API_KEY (from ~/.config/mify.env)"
