# MiniMax M3 模型配置指南

**创建时间**: 2026-06-27
**适用版本**: OpenClaw v1.9.0+

## 📖 概述

MiniMax M3 是 MiniMax 推出的新一代大语言模型，具备原生多模态能力，支持文本、图像、音频等多种输入类型。OpenClaw v1.9.0 新增了对 MiniMax M3 模型的完整支持，提供开箱即用的配置方案。

## 🎯 模型特性

| 特性 | 说明 |
|------|------|
| 🖼️ 原生多模态 | 支持文本、图像、音频多模态输入 |
| 🧠 强大推理 | 优秀的逻辑推理和数学能力 |
| 📝 长文本 | 支持超长上下文窗口 |
| 🌍 多语言 | 支持中英文等多种语言 |
| ⚡ 快速响应 | 优化的推理速度 |
| 🔧 工具调用 | 支持 Function Calling |

## 🔧 基础配置

### 添加 MiniMax M3 提供商

在 `~/.openclaw/openclaw.json` 中添加配置：

```json
{
  "providers": {
    "minimax": {
      "apiKey": "your-minimax-api-key",
      "baseUrl": "https://api.minimax.chat/v1",
      "models": {
        "minimax-m3": {
          "id": "MiniMax-M3",
          "maxTokens": 65536,
          "contextWindow": 1048576,
          "multimodal": true
        }
      }
    }
  }
}
```

### 使用命令行配置

```bash
# 添加 MiniMax 提供商
openclaw config set providers.minimax.apiKey "your-minimax-api-key"

# 设置默认模型
openclaw config set providers.minimax.defaultModel minimax-m3

# 设置 API 基础地址
openclaw config set providers.minimax.baseUrl "https://api.minimax.chat/v1"
```

### 验证配置

```bash
# 测试模型连接
openclaw model test minimax/minimax-m3

# 查看模型信息
openclaw model info minimax/minimax-m3

# 列出可用模型
openclaw model list --provider minimax
```

## 📊 模型参数配置

### 完整配置示例

```json
{
  "providers": {
    "minimax": {
      "apiKey": "your-minimax-api-key",
      "baseUrl": "https://api.minimax.chat/v1",
      "timeout": 60000,
      "retry": {
        "maxAttempts": 3,
        "backoff": "exponential"
      },
      "models": {
        "minimax-m3": {
          "id": "MiniMax-M3",
          "maxTokens": 65536,
          "contextWindow": 1048576,
          "multimodal": true,
          "defaultParams": {
            "temperature": 0.7,
            "topP": 0.9,
            "topK": 50
          }
        }
      }
    }
  }
}
```

### 参数说明

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `temperature` | number | `0.7` | 生成温度，控制随机性（0-2） |
| `topP` | number | `0.9` | 核采样参数（0-1） |
| `topK` | number | `50` | Top-K 采样参数 |
| `maxTokens` | number | `65536` | 最大输出 token 数 |
| `contextWindow` | number | `1048576` | 上下文窗口大小 |

### 模式配置

```json
{
  "models": {
    "minimax-m3": {
      "presets": {
        "creative": {
          "temperature": 1.2,
          "topP": 0.95
        },
        "precise": {
          "temperature": 0.3,
          "topP": 0.8
        },
        "balanced": {
          "temperature": 0.7,
          "topP": 0.9
        }
      }
    }
  }
}
```

```bash
# 使用创意模式
openclaw model use minimax/minimax-m3 --preset creative

# 使用精确模式
openclaw model use minimax/minimax-m3 --preset precise

# 使用平衡模式
openclaw model use minimax/minimax-m3 --preset balanced
```

## 🖼️ 多模态使用

### 图像理解

MiniMax M3 支持原生图像理解能力：

```json
{
  "multimodal": {
    "image": {
      "enabled": true,
      "maxImages": 10,
      "maxSize": "20MB",
      "supportedFormats": ["jpg", "jpeg", "png", "webp", "gif"]
    }
  }
}
```

**使用示例**:
```
你: [上传图片] 这张图片里有什么？
AI: 这张图片显示了一幅美丽的风景画，画面中有...
```

### 音频理解

```json
{
  "multimodal": {
    "audio": {
      "enabled": true,
      "maxDuration": "300s",
      "supportedFormats": ["mp3", "wav", "m4a", "ogg"]
    }
  }
}
```

**使用示例**:
```
你: [上传音频] 这段音频说了什么？
AI: 这段音频的内容是...
```

## 🔄 切换模型

### 设置默认模型

```bash
# 设置 MiniMax M3 为默认模型
openclaw config set defaultModel minimax/minimax-m3

# 临时切换模型
openclaw model switch minimax/minimax-m3

# 恢复默认模型
openclaw model reset
```

### 使用模型别名

```json
{
  "modelAliases": {
    "mm3": "minimax/minimax-m3",
    "mm3-creative": "minimax/minimax-m3?preset=creative",
    "mm3-precise": "minimax/minimax-m3?preset=precise"
  }
}
```

```bash
# 使用别名
openclaw chat --model mm3
openclaw chat --model mm3-creative
```

## 📋 推荐场景

| 场景 | 推荐配置 | 说明 |
|------|---------|------|
| 💬 日常对话 | `temperature: 0.7` | 平衡创意和准确性 |
| 📝 文档写作 | `temperature: 0.8` | 略高温度增加创意 |
| 🔬 数据分析 | `temperature: 0.3` | 低温度确保准确性 |
| 🎨 创意写作 | `temperature: 1.2` | 高温度激发创意 |
| 🖼️ 图像理解 | 默认配置 | 原生多模态支持 |
| 🔧 代码生成 | `temperature: 0.2` | 最低温度确保代码正确性 |

## 🆚 与其他模型对比

| 特性 | MiniMax M3 | GPT-4o | Claude 3.5 |
|------|-----------|--------|------------|
| 多模态 | ✅ 原生支持 | ✅ 支持 | ✅ 支持 |
| 中文能力 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| 上下文窗口 | 1M tokens | 128K tokens | 200K tokens |
| 价格 | 较低 | 较高 | 中等 |
| 响应速度 | 快 | 中等 | 中等 |

## 💰 成本控制

### Token 使用统计

```bash
# 查看 Token 使用统计
openclaw usage stats --model minimax/minimax-m3

# 查看月度使用量
openclaw usage monthly --model minimax/minimax-m3

# 设置 Token 限制
openclaw config set providers.minimax.limits.dailyTokens 1000000
openclaw config set providers.minimax.limits.monthlyTokens 30000000
```

### 配置预算告警

```json
{
  "providers": {
    "minimax": {
      "budget": {
        "dailyLimit": 1000000,
        "monthlyLimit": 30000000,
        "alertThreshold": 0.8,
        "onExceed": "notify"
      }
    }
  }
}
```

## 🔍 故障排除

### 常见问题

#### 1. API 密钥错误

**症状**: 返回 `401 Unauthorized` 错误

**解决方案**:
```bash
# 检查 API 密钥配置
openclaw config get providers.minimax.apiKey

# 重新设置 API 密钥
openclaw config set providers.minimax.apiKey "your-new-api-key"

# 测试连接
openclaw model test minimax/minimax-m3
```

#### 2. 多模态功能不可用

**症状**: 上传图片或音频后无法处理

**解决方案**:
```bash
# 检查多模态配置
openclaw config get providers.minimax.models.minimax-m3.multimodal

# 启用多模态
openclaw config set providers.minimax.models.minimax-m3.multimodal true

# 检查文件格式是否支持
openclaw model capabilities minimax/minimax-m3
```

#### 3. 响应超时

**症状**: 请求长时间无响应

**解决方案**:
```bash
# 增加超时时间
openclaw config set providers.minimax.timeout 120000

# 减少 maxTokens
openclaw config set providers.minimax.models.minimax-m3.maxTokens 32768

# 检查网络连接
openclaw model test minimax/minimax-m3 --verbose
```

### 调试命令

```bash
# 查看模型详细信息
openclaw model info minimax/minimax-m3 --verbose

# 测试模型性能
openclaw model benchmark minimax/minimax-m3

# 查看模型日志
openclaw logs model minimax/minimax-m3
```

## ⚠️ 注意事项

1. **API 密钥安全**: 请妥善保管 MiniMax API 密钥，不要提交到版本控制系统
2. **多模态限制**: 图像和音频文件有大小限制，请在上传前确认文件大小
3. **Token 用量**: 长对话会消耗大量 Token，建议定期检查使用量
4. **网络要求**: 需要稳定的网络连接访问 MiniMax API
5. **区域限制**: 部分地区可能需要代理访问 MiniMax API
6. **模型更新**: MiniMax 会定期更新模型，建议关注官方公告

## 📚 相关链接

- [模型对比指南](./model-comparison.md)
- [API 配置指南](../API-CONFIG-GUIDE.md)
- [MiniMax 官方文档](https://platform.minimaxi.com/document)
- [OpenClaw 官方文档](https://docs.openclaw.ai)

---

**最后更新**: 2026-06-27
**维护者**: OpenClaw Team
