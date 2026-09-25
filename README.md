# claude-code-dev

OpenAI Codex CLI 开发环境。

## 快速开始

```bash
# 安装 Codex CLI
bash scripts/install-codex.sh

# 认证（二选一）
export OPENAI_API_KEY="sk-..."   # OpenAI API Key
# 或
export CODEX_ACCESS_TOKEN="..."  # ChatGPT 访问令牌

bash scripts/codex-auth.sh

# 验证安装
codex --version
codex doctor
codex login status
```

## Mify provider

桌面版和 CLI 共用 `~/.codex/config.toml`。仓库里的模板是 `config/codex-mify.toml`，模型为 `amber_ai/gpt-5.6-sol`。

```bash
bash scripts/configure-mify.sh
```

配置要点：

- `model_provider = "mify"`，接口 `https://api.llm.mioffice.cn/v1`
- `model_reasoning_effort` 只能用 `high`，不能用 `max`
- 非 GPT 模型必须 `web_search = "disabled"`，并关闭 `features.apply_patch_freeform`
- `requires_openai_auth = true`，并用 API Key 登录：

```bash
printf '%s' "$MIFY_API_KEY" | codex login --with-api-key
```

只登录还不够。provider 里要在 `base_url` 下面加上 `env_key`，否则桌面版会报找不到模型元数据（`Unsupported model (empty)`）：

```toml
[model_providers.mify]
name = "mify"
base_url = "https://api.llm.mioffice.cn/v1"
env_key = "PROXY_API_KEY"
wire_api = "responses"
requires_openai_auth = true
```

把中转密钥写进 `PROXY_API_KEY`，并让 shell 启动时加载。密钥不要提交到仓库：

```bash
echo 'export PROXY_API_KEY="sk-xxxx你的中转密钥"' >> ~/.zshrc
source ~/.zshrc
```

桌面版不会读已经打开的终端，改完后要重新打开 Codex，进程里才能看到 `PROXY_API_KEY`。

## 使用 Codex

```bash
# 交互式会话
codex

# 非交互式执行
codex exec "分析这个项目的结构"

# 代码审查
codex review
```

## 飞书 MCP（本地 OpenAPI，用户身份）

Cloud Agent 通过 `.cursor/mcp.json` 启动 `@larksuiteoapi/lark-mcp`，并强制 `--token-mode user_access_token`，文档以你的个人身份读写。

1. 在 [飞书开放平台](https://open.feishu.cn/app) 创建自建应用，拿到 App ID、App Secret。
2. 开通权限：`docx:document:readonly`、`docx:document:write_only`、`wiki:wiki:readonly`、`drive:drive`。
3. 安全设置里把重定向 URL 设为 `http://localhost:3000/callback`，并打开发布版本。
4. 在 Cloud Agent 环境密钥中写入 `FEISHU_APP_ID`、`FEISHU_APP_SECRET`。
5. 运行登录，打开终端里的授权链接并扫码：

```bash
bash scripts/lark-mcp-login.sh
```

看到 `success` 后，重启 Agent，即可读取飞书云文档和知识库。

## Cloud Agent 环境

本仓库包含 `.cursor/environment.json`，Cloud Agent 启动时会自动：

1. 安装 Codex CLI
2. 使用环境密钥完成认证（`OPENAI_API_KEY` 或 `CODEX_ACCESS_TOKEN`）

请在 [Cloud Agent 环境设置](https://cursor.com/dashboard/cloud-agents/environments/e/f736edde-aaae-11f1-b532-320a589b8025) 中添加对应密钥。

## 参考

- [Codex CLI 文档](https://learn.chatgpt.com/docs/codex/cli)
- [认证说明](https://developers.openai.com/codex/auth)
