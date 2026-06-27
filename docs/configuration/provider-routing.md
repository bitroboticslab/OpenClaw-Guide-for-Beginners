<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# Provider 路由优化说明

> 配置 AI 模型 Provider 的路由规则，支持 OpenRouter 规范化、Google Vertex 规范化和 SecretRef 认证

## 📋 前置要求

- OpenClaw v2.0.0 或更高版本
- 已完成 AI 模型配置（参考 [API 配置教程](api-configuration.md)）

---

## 功能说明

Provider 路由优化是 OpenClaw v2.0.0 新增的核心功能，用于：

- 🔄 **规范化请求路由**：统一不同 Provider 的 API 格式
- 🔐 **SecretRef 认证**：安全管理 API 密钥
- ⚡ **智能路由**：自动选择最优 Provider
- 🔁 **故障转移**：Provider 不可用时自动切换

---

## OpenRouter 规范化

OpenRouter 是一个聚合多个 AI 模型的统一 API 平台。OpenClaw 对其进行了规范化处理。

### 1.1 配置 OpenRouter Provider

```json
{
  "models": {
    "providers": [
      {
        "providerId": "openrouter",
        "type": "openrouter",
        "apiKey": "sk-or-你的密钥",
        "base_url": "https://openrouter.ai/api/v1",
        "models": [
          {
            "id": "anthropic/claude-sonnet-4",
            "display_name": "Claude Sonnet 4",
            "primary": true
          },
          {
            "id": "google/gemini-2.5-pro",
            "display_name": "Gemini 2.5 Pro"
          },
          {
            "id": "meta-llama/llama-4-maverick",
            "display_name": "Llama 4 Maverick"
          }
        ]
      }
    ]
  }
}
```

### 1.2 OpenRouter 规范化特性

| 特性 | 说明 |
|------|------|
| 模型 ID 映射 | 自动将 `provider/model` 格式映射到 OpenRouter |
| 参数标准化 | 统一 `temperature`、`max_tokens` 等参数 |
| 响应格式化 | 将 OpenRouter 响应转为 OpenClaw 标准格式 |
| 成本追踪 | 自动解析 OpenRouter 返回的用量信息 |

### 1.3 OpenRouter 高级配置

```json
{
  "models": {
    "providers": [
      {
        "providerId": "openrouter",
        "type": "openrouter",
        "apiKey": "sk-or-你的密钥",
        "base_url": "https://openrouter.ai/api/v1",
        "normalization": {
          "model_prefix": true,
          "strip_provider_prefix": false,
          "param_mapping": {
            "max_tokens": "max_tokens",
            "top_p": "top_p",
            "frequency_penalty": "frequency_penalty"
          }
        },
        "headers": {
          "HTTP-Referer": "https://your-app.com",
          "X-Title": "Your App Name"
        },
        "fallback": {
          "enabled": true,
          "models": ["anthropic/claude-haiku-4.5"]
        }
      }
    ]
  }
}
```

### 1.4 使用效果

配置前 —— 需要手动指定完整路径：
```json
{
  "model": "openrouter/anthropic/claude-sonnet-4"
}
```

配置后 —— 自动规范化路由：
```json
{
  "model": "claude-sonnet-4"
}
```

OpenClaw 会自动识别并路由到正确的 Provider 和模型。

---

## Google Vertex 规范化

Google Vertex AI 使用与其他 Provider 不同的 API 格式和认证方式。OpenClaw 对其进行了规范化处理。

### 2.1 配置 Vertex Provider

```json
{
  "models": {
    "providers": [
      {
        "providerId": "vertex",
        "type": "google_vertex",
        "project_id": "your-gcp-project-id",
        "location": "us-central1",
        "models": [
          {
            "id": "gemini-2.5-pro",
            "display_name": "Gemini 2.5 Pro",
            "primary": true
          },
          {
            "id": "gemini-2.5-flash",
            "display_name": "Gemini 2.5 Flash"
          }
        ]
      }
    ]
  }
}
```

### 2.2 认证方式

支持多种 GCP 认证方式：

**方式一：服务账号密钥文件**

```json
{
  "providerId": "vertex",
  "type": "google_vertex",
  "auth": {
    "method": "service_account",
    "key_file": "/path/to/service-account.json"
  }
}
```

**方式二：应用默认凭据（ADC）**

```json
{
  "providerId": "vertex",
  "type": "google_vertex",
  "auth": {
    "method": "application_default"
  }
}
```

**方式三：环境变量**

```bash
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/service-account.json"
```

```json
{
  "providerId": "vertex",
  "type": "google_vertex",
  "auth": {
    "method": "environment"
  }
}
```

### 2.3 Vertex 规范化特性

| 特性 | 说明 |
|------|------|
| API 格式转换 | 将 OpenAI 格式转为 Vertex AI 格式 |
| 模型名称映射 | `gemini-2.5-pro` → `projects/{id}/locations/{loc}/publishers/google/models/gemini-2.5-pro` |
| 参数适配 | 自动转换 `temperature`、`top_p` 等参数 |
| 流式响应 | 将 Vertex SSE 流转为 OpenClaw 标准流 |

### 2.4 Vertex 高级配置

```json
{
  "models": {
    "providers": [
      {
        "providerId": "vertex",
        "type": "google_vertex",
        "project_id": "your-gcp-project-id",
        "location": "us-central1",
        "normalization": {
          "map_openai_params": true,
          "convert_content_format": true,
          "system_instruction_mode": "prepend"
        },
        "safety_settings": [
          {
            "category": "HARM_CATEGORY_HARASSMENT",
            "threshold": "BLOCK_NONE"
          }
        ],
        "generation_config": {
          "max_output_tokens": 8192,
          "top_k": 40
        }
      }
    ]
  }
}
```

---

## SecretRef 认证

SecretRef 是 OpenClaw v2.0.0 引入的安全认证机制，用于安全管理 API 密钥，避免明文存储。

### 3.1 基本用法

将 API 密钥存储在安全的 Secret 存储中，通过引用方式使用：

```json
{
  "models": {
    "providers": [
      {
        "providerId": "bailian",
        "type": "openai_compatible",
        "api_key_ref": "secret://bailian-api-key",
        "base_url": "https://dashscope.aliyuncs.com/compatible-mode/v1",
        "models": [
          {
            "id": "qwen-plus",
            "primary": true
          }
        ]
      }
    ]
  }
}
```

### 3.2 支持的 Secret 存储后端

| 后端 | 配置格式 | 说明 |
|------|---------|------|
| 环境变量 | `secret://env/VARIABLE_NAME` | 从环境变量读取 |
| 文件 | `secret://file/path/to/secret` | 从文件读取 |
| HashiCorp Vault | `secret://vault/path/key` | 从 Vault 读取 |
| AWS Secrets Manager | `secret://aws/secret-name` | 从 AWS 读取 |
| 本地加密存储 | `secret://local/key-name` | 从本地加密存储读取 |

### 3.3 环境变量方式

```bash
# 设置环境变量
export OPENCLAW_SECRET_BAILIAN_KEY="sk-你的密钥"
```

```json
{
  "api_key_ref": "secret://env/OPENCLAW_SECRET_BAILIAN_KEY"
}
```

### 3.4 文件方式

```bash
# 创建密钥文件
echo "sk-你的密钥" > ~/.openclaw/secrets/bailian.key
chmod 600 ~/.openclaw/secrets/bailian.key
```

```json
{
  "api_key_ref": "secret://file/~/.openclaw/secrets/bailian.key"
}
```

### 3.5 本地加密存储

```bash
# 添加密钥到本地加密存储
openclaw secret set bailian-api-key "sk-你的密钥"

# 查看已存储的密钥名称（不显示值）
openclaw secret list
```

```json
{
  "api_key_ref": "secret://local/bailian-api-key"
}
```

### 3.6 Vault 配置

```json
{
  "secrets": {
    "vault": {
      "address": "https://vault.example.com",
      "auth": {
        "method": "token",
        "token_ref": "secret://env/VAULT_TOKEN"
      },
      "namespace": "openclaw"
    }
  },
  "models": {
    "providers": [
      {
        "providerId": "openai",
        "api_key_ref": "secret://vault/openai/api-key"
      }
    ]
  }
}
```

---

## 智能路由配置

### 4.1 故障转移

当主 Provider 不可用时，自动切换到备用 Provider：

```json
{
  "routing": {
    "fallback": {
      "enabled": true,
      "strategy": "sequential",
      "providers": [
        { "providerId": "bailian", "priority": 1 },
        { "providerId": "openrouter", "priority": 2 },
        { "providerId": "vertex", "priority": 3 }
      ]
    }
  }
}
```

### 4.2 负载均衡

在多个 Provider 之间分配请求：

```json
{
  "routing": {
    "load_balancing": {
      "enabled": true,
      "strategy": "weighted",
      "providers": [
        { "providerId": "bailian", "weight": 60 },
        { "providerId": "openrouter", "weight": 30 },
        { "providerId": "vertex", "weight": 10 }
      ]
    }
  }
}
```

| 策略 | 说明 |
|------|------|
| `sequential` | 按顺序尝试，失败后切换下一个 |
| `weighted` | 按权重分配请求 |
| `round_robin` | 轮询分配 |
| `latency` | 选择延迟最低的 Provider |

### 4.3 模型级路由

针对不同模型使用不同的 Provider：

```json
{
  "routing": {
    "model_routing": {
      "claude-sonnet-4": {
        "preferred_provider": "openrouter",
        "fallback_provider": "anthropic"
      },
      "gemini-2.5-pro": {
        "preferred_provider": "vertex",
        "fallback_provider": "openrouter"
      },
      "qwen-plus": {
        "preferred_provider": "bailian",
        "fallback_provider": null
      }
    }
  }
}
```

---

## 完整配置示例

```json
{
  "models": {
    "providers": [
      {
        "providerId": "bailian",
        "type": "openai_compatible",
        "api_key_ref": "secret://local/bailian-api-key",
        "base_url": "https://dashscope.aliyuncs.com/compatible-mode/v1",
        "models": [
          { "id": "qwen-plus", "primary": true }
        ]
      },
      {
        "providerId": "openrouter",
        "type": "openrouter",
        "api_key_ref": "secret://env/OPENROUTER_API_KEY",
        "normalization": {
          "model_prefix": true
        },
        "models": [
          { "id": "anthropic/claude-sonnet-4" },
          { "id": "google/gemini-2.5-pro" }
        ]
      },
      {
        "providerId": "vertex",
        "type": "google_vertex",
        "project_id": "my-gcp-project",
        "location": "us-central1",
        "auth": {
          "method": "application_default"
        },
        "models": [
          { "id": "gemini-2.5-pro" },
          { "id": "gemini-2.5-flash" }
        ]
      }
    ]
  },
  "routing": {
    "fallback": {
      "enabled": true,
      "strategy": "sequential"
    },
    "model_routing": {
      "claude-sonnet-4": {
        "preferred_provider": "openrouter"
      },
      "gemini-2.5-pro": {
        "preferred_provider": "vertex"
      }
    }
  }
}
```

---

## 常见问题排查

### Q: OpenRouter 模型找不到？

**可能原因**：模型 ID 格式不正确

**解决方案**：使用 `provider/model` 格式

```json
// ❌ 错误
{ "id": "claude-sonnet-4" }

// ✅ 正确
{ "id": "anthropic/claude-sonnet-4" }
```

### Q: Vertex 认证失败？

**排查步骤**：
```bash
# 检查 ADC 配置
gcloud auth application-default login

# 验证服务账号
gcloud auth activate-service-account --key-file=/path/to/key.json

# 测试 API 访问
openclaw provider test vertex
```

### Q: SecretRef 无法读取密钥？

**排查步骤**：
```bash
# 检查密钥是否存在
openclaw secret list

# 测试密钥读取
openclaw secret test bailian-api-key

# 检查文件权限（file 方式）
ls -la ~/.openclaw/secrets/
```

### Q: 故障转移不生效？

**可能原因**：未配置备用 Provider 或健康检查间隔过长

**解决方案**：
```json
{
  "routing": {
    "fallback": {
      "enabled": true,
      "health_check": {
        "interval": 30,
        "timeout": 5
      }
    }
  }
}
```

---

## 相关链接

- [API 配置教程](api-configuration.md)
- [模型选择指南](model-comparison.md)
- [成本优化指南](cost-optimization.md)

---

**上一页**：[用量页脚功能配置](usage-footer.md) | **下一页**：[常见问题解答](../../FAQ.md)

<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->
