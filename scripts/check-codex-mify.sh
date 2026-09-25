#!/usr/bin/env bash
# 检查 Codex + Mify 是否在本机 ~/.codex 配好（项目 .codex/config.toml 不算）
set -u

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

ok() { echo -e "${GREEN}OK${NC}  $*"; }
warn() { echo -e "${YELLOW}WARN${NC}  $*"; }
fail() { echo -e "${RED}FAIL${NC}  $*"; }

HOME_CFG="${HOME}/.codex/config.toml"
PROJECT_CFG=""
if [[ -f ".codex/config.toml" ]]; then
  PROJECT_CFG="$(pwd)/.codex/config.toml"
elif [[ -f "${PWD}/.codex/config.toml" ]]; then
  PROJECT_CFG="${PWD}/.codex/config.toml"
fi

echo "=== Codex Mify 配置自检 ==="
echo

if [[ ! -f "${HOME_CFG}" ]]; then
  fail "未找到 ${HOME_CFG}"
  echo "      只改仓库里的 .codex/config.toml 不会生效。请运行: bash scripts/install-codex-mify.sh"
  exit 1
fi
ok "找到用户配置 ${HOME_CFG}"

get_toml() {
  local key="$1"
  python3 - "$HOME_CFG" "$key" <<'PY'
import re, sys
path, key = sys.argv[1], sys.argv[2]
text = open(path, encoding="utf-8").read()
# 简单匹配顶层 key = "value"
m = re.search(rf'^\s*{re.escape(key)}\s*=\s*"([^"]*)"', text, re.M)
print(m.group(1) if m else "")
PY
}

has_section() {
  local section="$1"
  grep -q "^\[${section}\]" "${HOME_CFG}" 2>/dev/null
}

model="$(get_toml model)"
provider="$(get_toml model_provider)"

if [[ -z "${model}" ]]; then
  fail 'model 为空或未设置 → 网关会报 Unsupported model (empty)'
else
  ok "model = \"${model}\""
  if [[ "${model}" != *"/"* ]]; then
    warn "Mify 模型建议写成 {provider}/{model}，例如 hippo/gpt-5.6-sol"
  fi
fi

if [[ -z "${provider}" ]]; then
  fail "model_provider 未设置（默认会走 openai/ChatGPT，不会走 Mify）"
elif [[ "${provider}" != "mify" ]]; then
  warn "model_provider = \"${provider}\"（文档示例为 mify）"
else
  ok "model_provider = mify"
fi

if has_section "model_providers.mify"; then
  if grep -A20 '^\[model_providers\.mify\]' "${HOME_CFG}" | grep -q 'supports_websockets = false'; then
    ok "supports_websockets = false（避免请求不带 model）"
  else
    fail "请在 [model_providers.mify] 下设置 supports_websockets = false"
  fi
  if grep -A20 '^\[model_providers\.mify\]' "${HOME_CFG}" | grep -q 'base_url = "https://api.llm.mioffice.cn/v1"'; then
    ok "base_url 指向 Mify 网关"
  else
    warn "请确认 base_url = https://api.llm.mioffice.cn/v1"
  fi
else
  fail "缺少 [model_providers.mify] 段"
fi

if [[ -n "${PROJECT_CFG}" ]]; then
  warn "仓库里有 ${PROJECT_CFG}，但其中的 model_provider / model_providers 会被 Codex 忽略"
  echo "      只有 model 等少数项可在项目级覆盖；网关 provider 必须在 ~/.codex/config.toml"
fi

if [[ -f "${HOME}/.codex/auth.json" ]]; then
  ok "存在 ~/.codex/auth.json（requires_openai_auth 需要已登录）"
else
  warn "未找到 ~/.codex/auth.json，请先 codex login（公司/Mify 要求的 OpenAI 兼容登录）"
fi

echo
echo "若以上有 FAIL：先 bash scripts/install-codex-mify.sh，再完全退出并重启 Codex。"
echo "在 Codex 里可执行 /status 或 /debug-config 看最终生效的 model 与 provider。"
