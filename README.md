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

## 使用 Codex

```bash
# 交互式会话
codex

# 非交互式执行
codex exec "分析这个项目的结构"

# 代码审查
codex review
```

## Cloud Agent 环境

本仓库包含 `.cursor/environment.json`，Cloud Agent 启动时会自动：

1. 安装 Codex CLI
2. 使用环境密钥完成认证（`OPENAI_API_KEY` 或 `CODEX_ACCESS_TOKEN`）

请在 [Cloud Agent 环境设置](https://cursor.com/dashboard/cloud-agents/environments/e/f736edde-aaae-11f1-b532-320a589b8025) 中添加对应密钥。

## 参考

- [Codex CLI 文档](https://learn.chatgpt.com/docs/codex/cli)
- [认证说明](https://developers.openai.com/codex/auth)
