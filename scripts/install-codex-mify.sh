#!/usr/bin/env bash
# 把仓库里的 Codex Mify 配置安装到本机 ~/.codex/config.toml
# 项目级 .codex/config.toml 不会生效（Codex 会忽略其中的 model_provider）
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="${ROOT}/.codex/config.toml"
CATALOG_SRC="${ROOT}/.codex/model-catalogs.json"
DST="${HOME}/.codex/config.toml"
CATALOG_DST="${HOME}/.codex/model-catalogs.json"

if [[ ! -f "${SRC}" ]]; then
  echo "缺少 ${SRC}" >&2
  exit 1
fi
if [[ ! -f "${CATALOG_SRC}" ]]; then
  echo "缺少 ${CATALOG_SRC}" >&2
  exit 1
fi

mkdir -p "${HOME}/.codex"
if [[ -f "${DST}" ]]; then
  cp "${DST}" "${DST}.bak.$(date +%Y%m%d%H%M%S)"
  echo "已备份原配置到 ${DST}.bak.*"
fi
if [[ -f "${CATALOG_DST}" ]]; then
  cp "${CATALOG_DST}" "${CATALOG_DST}.bak.$(date +%Y%m%d%H%M%S)"
  echo "已备份原模型目录到 ${CATALOG_DST}.bak.*"
fi

cp "${SRC}" "${DST}"
cp "${CATALOG_SRC}" "${CATALOG_DST}"
echo "已写入 ${DST}"
echo "已写入 ${CATALOG_DST}"
echo
echo "请确认："
echo "  1. model / model_provider 已生效（打开新终端跑: grep -E '^(model|model_provider)' ~/.codex/config.toml）"
echo "  2. Codex 已用公司账号登录（requires_openai_auth = true）"
echo "  3. 完全退出并重启 Codex / IDE 插件后再试"
echo "  4. 在 Codex 里执行 /model，应能看到 Claude Opus / Sonnet / Haiku 5.5 和 ppio/pa/gpt-5.6-sol"
echo
grep -E '^(model|model_provider|model_catalog_json)[[:space:]]*=' "${DST}" || true
