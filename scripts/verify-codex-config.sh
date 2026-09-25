#!/usr/bin/env bash
set -euo pipefail

CONFIG="${HOME}/.codex/config.toml"
CATALOG="${HOME}/.codex/model-catalogs.json"
FAIL=0

echo "=== Codex 自定义模型检查 ==="
echo ""

if [[ ! -f "${CONFIG}" ]]; then
  echo "❌ 未找到 ${CONFIG}"
  echo "   请运行: bash scripts/setup-codex.sh token-plan  或  pay-as-you-go"
  FAIL=1
else
  echo "✓ 配置文件: ${CONFIG}"
fi

if [[ ! -f "${CATALOG}" ]]; then
  echo "❌ 未找到 ${CATALOG}（model_catalog_json 指向的文件）"
  FAIL=1
else
  echo "✓ 模型目录: ${CATALOG}"
fi

if [[ -f "${CONFIG}" ]]; then
  if grep -qE '^model_provider\s*=\s*"openai"' "${CONFIG}" 2>/dev/null || \
     ! grep -qE '^model_provider\s*=' "${CONFIG}" 2>/dev/null; then
    echo "❌ model_provider 仍是默认 openai 或未设置 → 模型下拉只会显示官方 GPT"
    echo "   应设置为: model_provider = \"mimo\""
    FAIL=1
  else
    PROVIDER="$(grep -E '^model_provider\s*=' "${CONFIG}" | head -1)"
    echo "✓ ${PROVIDER}"
  fi

  if ! grep -qE '^model_catalog_json\s*=' "${CONFIG}"; then
    echo "❌ 缺少 model_catalog_json → /model 不会出现 MiMo 自定义模型"
    FAIL=1
  else
    echo "✓ $(grep -E '^model_catalog_json\s*=' "${CONFIG}" | head -1)"
  fi

  if ! grep -qE '^model\s*=\s*"mimo-' "${CONFIG}"; then
    echo "⚠ model 未设为 mimo-* 系列，可能导致 Unsupported model (empty)"
  else
    echo "✓ $(grep -E '^model\s*=' "${CONFIG}" | head -1)"
  fi
fi

if [[ -z "${MIMO_API_KEY:-}" ]]; then
  echo "⚠ 当前 shell 未设置 MIMO_API_KEY（Codex 启动时需能读到该变量）"
else
  echo "✓ MIMO_API_KEY 已设置（长度 ${#MIMO_API_KEY}）"
fi

if [[ -f "./.codex/config.toml" ]] && [[ ! -f "${CONFIG}" || "${CONFIG}" != "$(readlink -f ./.codex/config.toml 2>/dev/null || echo '')" ]]; then
  echo ""
  echo "⚠ 项目内存在 ./.codex/config.toml，但 Codex **不会**用项目配置里的 model_provider / model_catalog_json"
  echo "  请把配置写到用户目录: ~/.codex/config.toml"
fi

echo ""
if [[ "${FAIL}" -eq 0 ]]; then
  echo "配置看起来正确。请完全退出 Codex 桌面端 / VS Code 后重新打开。"
  echo "在 CLI 中输入 /model 应能看到 mimo-v2.6-pro 等模型。"
else
  echo "请先修复上述项，再重启 Codex。"
  exit 1
fi
