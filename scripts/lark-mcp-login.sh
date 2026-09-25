#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${FEISHU_APP_ID:-}" || -z "${FEISHU_APP_SECRET:-}" ]]; then
  echo "缺少 FEISHU_APP_ID 或 FEISHU_APP_SECRET。"
  echo "请在飞书开放平台创建自建应用后，把凭证写入环境密钥。"
  exit 1
fi

echo "使用用户身份登录飞书 OpenAPI MCP..."
exec npx -y @larksuiteoapi/lark-mcp login \
  -a "$FEISHU_APP_ID" \
  -s "$FEISHU_APP_SECRET" \
  --scope "offline_access docx:document:readonly docx:document:write_only wiki:wiki:readonly wiki:wiki drive:drive"
