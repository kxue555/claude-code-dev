# claude-code-dev

Cloud Agent 环境中部署 [OpenAI Codex CLI](https://developers.openai.com/codex/cli)。

## 本机 / 环境安装

```bash
./scripts/install-codex.sh
```

鉴权（需要 `OPENAI_API_KEY`）：

```bash
./scripts/configure-codex-auth.sh
# 或: printenv OPENAI_API_KEY | codex login --with-api-key
```

验证：

```bash
codex --version
codex doctor
codex exec "Say hello and exit"
```
