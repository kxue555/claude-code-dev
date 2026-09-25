# claude-code-dev

## Codex `Unsupported model (empty)`

网关收到的 model 是空字符串。常见原因：

1. 配置写在了项目 `.codex/config.toml` 里——Codex **会忽略** 其中的 `model_provider` / `model_providers`
2. 走了 WebSocket，请求里没带上 model

按飞书文档评论，安装到本机用户级配置：

```bash
bash scripts/install-codex-mify.sh
```

配置要点（见 `.codex/config.toml`）：

- `model_provider = "mify"`
- `model = "hippo/gpt-5.6-sol"`（`{provider}/{model}`，不能空）
- `supports_websockets = false`（强制 HTTPS，避免空 model）
- `base_url = "https://api.llm.mioffice.cn/v1"`
- `requires_openai_auth = true`

不用 `azure_openai/gpt-5.2-codex`（评论：费用过高、不允许）。

安装后**完全退出并重启** Codex / VS Code 插件，再发一条消息验证。

自检（在本仓库目录执行）：

```bash
bash scripts/check-codex-mify.sh
```

若报 `Unsupported model (empty)`，多半是 **本机 `~/.codex/config.toml` 没配对**：`model` 为空，或 `model_provider` 仍是默认 `openai`（只改了项目里的 `.codex/config.toml` 不够）。
