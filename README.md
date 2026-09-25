# claude-code-dev

小米 MiMo + OpenAI Codex 本地配置模板，用于修复 **`Unsupported model (empty)`** 等模型未配置问题。

配置说明与飞书文档 / [MiMo 官方 Codex 配置](https://mimo.mi.com/docs/zh-CN/tokenplan/integration/codex-configuration) 一致。

## 原因说明

`Unsupported model (empty)` 表示 Codex 当前 **没有有效的默认模型名**，常见情况：

1. `~/.codex/config.toml` 里 **未设置** `model`，或值为空
2. 未配置 **`model_catalog_json`**，或路径错误，导致 `/model` 列表与默认模型解析失败
3. `model` 与 `model-catalogs.json` 里模型的 **`slug` 不一致**（例如配置里写了旧名而 catalog 只有 `mimo-v2.6-pro`）
4. 仍使用 Chat Completions 旧配置，未设置 `wire_api = "responses"`

本仓库已包含官方 **`model-catalogs.json`**（含 `mimo-v2.6-pro`）和两份 `config.toml` 示例。

## 前置条件

- Node.js 18+
- `npm install -g @openai/codex`
- 在 [MiMo 控制台](https://platform.xiaomimimo.com/) 获取 API Key

> 若系统里已有 **`MIMO_API_KEY`** 环境变量，请先确认其值与当前使用方式（Token Plan / 按量付费）一致，否则请清除或替换。

## 快速安装

```bash
# Token Plan（tp- 密钥）
export MIMO_API_KEY="tp-your-api-key-here"
bash scripts/setup-codex.sh token-plan

# 或按量付费（sk- 密钥）
export MIMO_API_KEY="sk-your-api-key-here"
bash scripts/setup-codex.sh pay-as-you-go
```

## 手动安装

```bash
mkdir -p ~/.codex
cp codex/model-catalogs.json ~/.codex/model-catalogs.json
# 二选一
cp codex/config.token-plan.toml ~/.codex/config.toml
# cp codex/config.pay-as-you-go.toml ~/.codex/config.toml
```

在 shell 配置（如 `~/.bashrc`）中加入：

```bash
export MIMO_API_KEY="你的密钥"
```

## 关键配置项（勿漏）

| 配置项 | 说明 |
|--------|------|
| `model = "mimo-v2.6-pro"` | 必须非空，且与 catalog 中 `slug` 一致 |
| `model_provider = "mimo"` | 与 `[model_providers.mimo]` 对应 |
| `model_catalog_json = "~/.codex/model-catalogs.json"` | 模型元数据路径 |
| `wire_api = "responses"` | MiMo 要求使用 Responses API |

## 验证

```bash
codex --version
codex
# 在 CLI 中可执行 /model 查看 MiMo 模型列表
```

若出现 **“custom tools require MiMo freeform Responses lite mode”**，说明需要本仓库提供的 `model-catalogs.json`（内含 `use_responses_lite` 等字段），安装后 **重启 Codex**。

## 目录结构

```
codex/
  config.token-plan.toml      # Token Plan 示例
  config.pay-as-you-go.toml   # 按量付费示例
  model-catalogs.json         # 官方模型元数据
scripts/
  setup-codex.sh              # 一键安装到 ~/.codex
```
