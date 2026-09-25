#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CODEX_DIR="${HOME}/.codex"

usage() {
  cat <<'EOF'
用法: setup-codex.sh <token-plan|pay-as-you-go|keep-chatgpt-login>

将本仓库中的 MiMo Codex 配置安装到 ~/.codex/
安装前请设置环境变量 MIMO_API_KEY（Token Plan 用 tp- 开头，按量付费用 sk- 开头）。
EOF
}

if [[ $# -ne 1 ]]; then
  usage
  exit 1
fi

case "$1" in
  token-plan)
    CONFIG_SRC="${REPO_ROOT}/codex/config.token-plan.toml"
    ;;
  pay-as-you-go)
    CONFIG_SRC="${REPO_ROOT}/codex/config.pay-as-you-go.toml"
    ;;
  keep-chatgpt-login)
    CONFIG_SRC="${REPO_ROOT}/codex/config.token-plan.keep-chatgpt-login.toml"
    ;;
  *)
    usage
    exit 1
    ;;
esac

if [[ "$1" != "keep-chatgpt-login" ]] && [[ -z "${MIMO_API_KEY:-}" ]]; then
  echo "错误: 未设置 MIMO_API_KEY。请先 export MIMO_API_KEY=\"你的密钥\"" >&2
  exit 1
fi

mkdir -p "${CODEX_DIR}"
cp "${CONFIG_SRC}" "${CODEX_DIR}/config.toml"
cp "${REPO_ROOT}/codex/model-catalogs.json" "${CODEX_DIR}/model-catalogs.json"

echo "已安装:"
echo "  ${CODEX_DIR}/config.toml"
echo "  ${CODEX_DIR}/model-catalogs.json"
echo ""
echo "请在新终端中运行: codex"
echo "若仍报错，执行: codex --version 并确认已 npm install -g @openai/codex"
echo ""
bash "${REPO_ROOT}/scripts/verify-codex-config.sh" || true
