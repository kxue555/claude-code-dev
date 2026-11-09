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
- `base_url = "https://api.llm.mioffice.cn/v1"`（Mify 接口）
- `model = "ppio/anthropic/claude-sonnet-5-5"`（`{provider}/{model}`，不能空）
- `model_catalog_json = "~/.codex/model-catalogs.json"`
- `supports_websockets = false`（强制 HTTPS，避免空 model）
- `requires_openai_auth = true`

`/model` 里可选：

| 模型 | 说明 |
|------|------|
| `ppio/anthropic/claude-opus-5-5` | Claude Opus 5.5，1M 上下文 |
| `ppio/anthropic/claude-sonnet-5-5` | Claude Sonnet 5.5，默认模型 |
| `ppio/anthropic/claude-haiku-5-5` | Claude Haiku 5.5，1M 上下文 |
| `hippo/gpt-5.6-sol` | 之前的默认模型，仍保留 |

不使用 `moonshot/kimi-k3.1-pro`：该模型在 Mify 上 ping 不通。也不用 `azure_openai/gpt-5.2-codex`（费用过高、不允许）。

上下文窗口写在模型目录里。不要在 `config.toml` 顶层再写死 `model_context_window = 272000`，否则 Claude 的 1M 窗口会被压短。

安装后**完全退出并重启** Codex / VS Code 插件，再发一条消息验证。

自检（在本仓库目录执行）：

```bash
bash scripts/check-codex-mify.sh
```

若报 `Unsupported model (empty)`，多半是 **本机 `~/.codex/config.toml` 没配对**：`model` 为空，或 `model_provider` 仍是默认 `openai`（只改了项目里的 `.codex/config.toml` 不够）。
