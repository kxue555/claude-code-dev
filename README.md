# claude-code-dev

Codex 报 `Unsupported model (empty)` 时，请求里的 model 是空的。WebSocket 传输不会带上 model，Mify 网关就会回这个错。

按飞书文档评论里的做法，配置在 [`.codex/config.toml`](.codex/config.toml)：

- `supports_websockets = false`，走 Responses API 的 HTTPS
- `model = "ppio/pa/gpt-5.5"`（`{provider}/{model}`，不能空）
- `base_url = "https://api.llm.mioffice.cn/v1"`

不使用 `azure_openai/gpt-5.2-codex`（评论里说明该模型费用过高、不允许使用）。

`model_provider` 和 `model_providers` 只在用户级配置里生效。把本文件复制到本机：

```bash
mkdir -p ~/.codex
cp .codex/config.toml ~/.codex/config.toml
```
