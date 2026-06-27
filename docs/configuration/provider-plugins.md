<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# 独立 Provider 插件配置

> OpenClaw v2.1.0 外部化插件架构、安装方法与配置示例

---

## 📋 概述

Provider 插件是 OpenClaw 的模型提供者扩展机制，允许通过独立插件接入不同的 AI 模型服务。v2.1.0 引入了外部化插件架构，支持热加载和动态配置。

| 特性 | 说明 |
|------|------|
| **外部化架构** | 插件独立于主程序，可单独更新 |
| **热加载** | 无需重启即可加载新插件 |
| **统一接口** | 所有 Provider 使用相同的配置格式 |
| **自动发现** | 支持从 npm/GitHub 自动安装插件 |

---

## 🏗️ 外部化插件架构

### 架构图

```
┌─────────────────────────────────────┐
│           OpenClaw Core              │
├─────────────────────────────────────┤
│         Plugin Manager               │
│    ┌───────┬───────┬───────┐        │
│    │ npm   │ local │ git   │        │
│    │ loader│ loader│ loader│        │
│    └───┬───┴───┬───┴───┬───┘        │
│        │       │       │            │
│    ┌───▼───────▼───────▼───┐        │
│    │   Provider Interface   │        │
│    └───────────────────────┘        │
└─────────────────────────────────────┘
           │
    ┌──────┴──────┬──────────┐
    ▼             ▼          ▼
┌────────┐  ┌────────┐  ┌────────┐
│OpenAI  │  │Claude  │  │Custom  │
│Provider│  │Provider│  │Provider│
└────────┘  └────────┘  └────────┘
```

### 插件目录结构

```
~/.openclaw/providers/
├── openai-provider/
│   ├── package.json
│   ├── index.js
│   └── config.json
├── claude-provider/
│   ├── package.json
│   ├── index.js
│   └── config.json
└── custom-provider/
    ├── package.json
    ├── index.js
    └── config.json
```

---

## 📦 安装方法

### 方法1：通过 npm 安装

```bash
# 安装官方 Provider 插件
openclaw providers install @openclaw/openai-provider
openclaw providers install @openclaw/claude-provider
openclaw providers install @openclaw/gemini-provider

# 安装第三方 Provider 插件
openclaw providers install openclaw-provider-ollama
```

### 方法2：从本地目录安装

```bash
# 从本地路径安装
openclaw providers install /path/to/my-provider

# 从压缩包安装
openclaw providers install ./my-provider-1.0.0.tgz
```

### 方法3：从 Git 仓库安装

```bash
# 从 GitHub 安装
openclaw providers install github:user/repo

# 指定分支或标签
openclaw providers install github:user/repo#v1.0.0
```

### 查看已安装插件

```bash
openclaw providers list

# 输出示例：
# ┌─────────────────────┬─────────┬──────────┬──────────┐
# │ Provider             │ 版本     │ 状态     │ 来源     │
# ├─────────────────────┼─────────┼──────────┼──────────┤
# │ @openclaw/openai     │ 2.1.0   │ ✅ 启用  │ npm      │
# │ @openclaw/claude     │ 2.1.0   │ ✅ 启用  │ npm      │
# │ ollama-provider      │ 1.0.0   │ ❌ 禁用  │ local    │
# └─────────────────────┴─────────┴──────────┴──────────┘
```

---

## 🔧 配置示例

### OpenAI Provider

```json
{
  "providers": {
    "openai": {
      "enabled": true,
      "provider": "@openclaw/openai-provider",
      "config": {
        "apiKey": "${OPENAI_API_KEY}",
        "baseUrl": "https://api.openai.com/v1",
        "organization": "${OPENAI_ORG_ID}",
        "models": ["gpt-4o", "gpt-4o-mini", "o1-preview"],
        "defaultModel": "gpt-4o",
        "timeout": 30000,
        "maxRetries": 3
      }
    }
  }
}
```

### Claude Provider

```json
{
  "providers": {
    "claude": {
      "enabled": true,
      "provider": "@openclaw/claude-provider",
      "config": {
        "apiKey": "${ANTHROPIC_API_KEY}",
        "baseUrl": "https://api.anthropic.com",
        "models": ["claude-sonnet-4-20250514", "claude-3-5-sonnet-20241022"],
        "defaultModel": "claude-sonnet-4-20250514",
        "maxTokens": 8192,
        "timeout": 60000
      }
    }
  }
}
```

### Ollama Provider（本地模型）

```json
{
  "providers": {
    "ollama": {
      "enabled": true,
      "provider": "openclaw-provider-ollama",
      "config": {
        "baseUrl": "http://localhost:11434",
        "models": ["llama3", "codellama", "mistral"],
        "defaultModel": "llama3",
        "keepAlive": "5m",
        "numCtx": 4096
      }
    }
  }
}
```

### 自定义 Provider

```json
{
  "providers": {
    "custom": {
      "enabled": true,
      "provider": "/path/to/custom-provider",
      "config": {
        "apiKey": "${CUSTOM_API_KEY}",
        "baseUrl": "https://custom-api.example.com/v1",
        "models": ["custom-model-1", "custom-model-2"],
        "defaultModel": "custom-model-1",
        "headers": {
          "X-Custom-Header": "value"
        }
      }
    }
  }
}
```

---

## 🔄 热加载与更新

### 热加载配置

```json
{
  "providers": {
    "hotReload": {
      "enabled": true,
      "watchInterval": 5000,
      "autoRestart": true
    }
  }
}
```

### 更新插件

```bash
# 更新单个插件
openclaw providers update @openclaw/openai-provider

# 更新所有插件
openclaw providers update --all

# 查看可用更新
openclaw providers outdated
```

---

## 💡 使用示例

### 场景1：多 Provider 负载均衡

```json
{
  "providers": {
    "openai-primary": {
      "enabled": true,
      "provider": "@openclaw/openai-provider",
      "config": {
        "apiKey": "${OPENAI_API_KEY_1}",
        "priority": 1
      }
    },
    "openai-backup": {
      "enabled": true,
      "provider": "@openclaw/openai-provider",
      "config": {
        "apiKey": "${OPENAI_API_KEY_2}",
        "priority": 2
      }
    }
  },
  "routing": {
    "strategy": "failover",
    "healthCheck": true
  }
}
```

### 场景2：按任务路由

```json
{
  "providers": {
    "openai": {
      "enabled": true,
      "provider": "@openclaw/openai-provider",
      "config": {
        "apiKey": "${OPENAI_API_KEY}",
        "routing": {
          "code": "gpt-4o",
          "chat": "gpt-4o-mini",
          "analysis": "o1-preview"
        }
      }
    }
  }
}
```

---

## ⚠️ 注意事项

1. **插件兼容性**：确保插件版本与 OpenClaw 版本兼容
2. **API 密钥安全**：使用环境变量存储密钥，不要硬编码
3. **网络要求**：部分 Provider 需要访问外部 API，确保网络通畅
4. **资源限制**：本地模型（如 Ollama）需要足够的硬件资源

---

## 🔍 故障排查

### 插件安装失败

```
错误: Failed to install provider: ENOTFOUND registry.npmjs.org
```

**解决**：
```bash
# 检查网络连接
openclaw network test

# 使用代理
openclaw config set proxy.http "http://proxy:8080"

# 从本地安装
openclaw providers install /path/to/provider
```

### Provider 连接超时

```
错误: Provider 'openai' connection timeout after 30000ms
```

**解决**：
```bash
# 增大超时时间
openclaw config set providers.openai.config.timeout 60000

# 检查 API 端点可达性
openclaw providers test openai
```

### 模型不可用

```
错误: Model 'xxx' not available in provider 'yyy'
```

**解决**：
```bash
# 查看可用模型列表
openclaw providers models yyy

# 更新模型列表
openclaw providers refresh-models yyy
```

---

最后更新：2026-06-27
