<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# 📋 配置模板使用指南

> OpenClaw 配置文件模板 - 快速开始配置

---

## 🎯 模板说明

本目录包含 OpenClaw 配置文件模板，帮助新手快速完成配置。

| 文件 | 说明 | 用途 |
|------|------|------|
| `openclaw-template.json` | OpenClaw 主配置模板 | 模型配置、Gateway 配置 |
| `env-template.txt` | 环境变量模板 | API Key、消息平台配置 |

---

## 🚀 快速开始

### 方法1: 使用配置向导（推荐）

```bash
# 运行配置向导
openclaw onboard --install-daemon

# 向导会自动创建配置文件
```

### 方法2: 手动使用模板

```bash
# 1. 进入 OpenClaw 目录
cd ~/.openclaw

# 2. 复制模板文件
cp openclaw-template.json openclaw.json
cp env-template.txt .env

# 3. 设置文件权限（重要！）
chmod 600 openclaw.json
chmod 600 .env

# 4. 编辑配置文件
nano openclaw.json
nano .env
```

---

## 🔧 配置步骤

### 步骤1: 选择 API 提供商

至少需要配置一个 API 提供商：

| 平台 | 推荐度 | 免费额度 | 获取地址 |
|------|--------|---------|---------|
| 硅基流动 | ⭐⭐⭐⭐⭐ | 2000万 Tokens | https://cloud.siliconflow.cn/ |
| 火山引擎 | ⭐⭐⭐⭐⭐ | Coding Plan 套餐 | https://www.volcengine.com/activity/codingplan |
| 阿里百炼 | ⭐⭐⭐⭐ | 有免费试用 | https://bailian.console.aliyun.com/ |

**新手推荐**:
- 测试学习 → 硅基流动（完全免费）
- 长期使用 → 火山引擎 Coding Plan（首月8.91元）

---

### 步骤2: 填写配置

#### 配置 `openclaw.json`

```json
{
  "models": {
    "providers": {
      "siliconflow": {
        "baseUrl": "https://api.siliconflow.cn/v1",
        "apiKey": "sk-your-api-key-here",  // ← 填写你的 API Key
        "api": "openai-completions",
        "models": [...]
      }
    }
  }
}
```

#### 配置 `.env`

```bash
# 填写你的 API Key
SILICONFLOW_API_KEY=sk-your-api-key-here
```

---

### 步骤3: 验证配置

```bash
# 检查配置
openclaw doctor

# 测试 API 连接
openclaw validate

# 查看 Gateway 状态
openclaw status
```

---

## 📝 配置示例

### 硅基流动配置

```json
{
  "models": {
    "providers": {
      "siliconflow": {
        "baseUrl": "https://api.siliconflow.cn/v1",
        "apiKey": "sk-xxxxxxxxxxxxxxxxxxxx",
        "api": "openai-completions",
        "models": [
          {
            "id": "Pro/zai-org/GLM-4.7",
            "name": "GLM-4.7",
            "input": ["text"],
            "contextWindow": 200000,
            "maxTokens": 8192
          }
        ]
      }
    }
  }
}
```

---

### 火山引擎配置

```json
{
  "models": {
    "providers": {
      "volcengine": {
        "baseUrl": "https://ark.cn-beijing.volces.com/api/coding/v3",
        "apiKey": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
        "api": "openai-completions",
        "models": [
          {
            "id": "glm-4.7",
            "name": "GLM-4.7",
            "input": ["text"],
            "contextWindow": 200000,
            "maxTokens": 65536
          }
        ]
      }
    }
  }
}
```

---

## 🔒 安全配置

### 文件权限

```bash
# 设置正确的权限（仅所有者可读写）
chmod 600 ~/.openclaw/openclaw.json
chmod 600 ~/.openclaw/.env

# 验证权限
ls -la ~/.openclaw/openclaw.json
ls -la ~/.openclaw/.env
```

**正确权限**: `-rw-------` (600)  
**错误权限**: `-rw-r--r--` (644)

---

### 环境变量

在 `openclaw.json` 中引用环境变量：

```json
{
  "models": {
    "providers": {
      "siliconflow": {
        "apiKey": "${SILICONFLOW_API_KEY}",  // ← 从环境变量读取
        "api": "openai-completions"
      }
    }
  }
}
```

---

## ⚠️ 常见错误

### 错误1: 权限配置错误

```bash
# 错误
chmod 644 openclaw.json  # ❌ 其他用户可读取

# 正确
chmod 600 openclaw.json  # ✅ 仅所有者可读写
```

### 错误2: API Key 填写错误

```json
// 错误
"apiKey": "YOUR_API_KEY",  // ❌ 未替换

// 正确
"apiKey": "sk-xxxxxxxxxx",  // ✅ 填写真实的 Key
```

### 错误3: baseUrl 配置错误

```json
// 错误
"baseUrl": "https://api.siliconflow.com/v1",  // ❌ 域名错误

// 正确
"baseUrl": "https://api.siliconflow.cn/v1",  // ✅ 正确域名
```

---

## 🔧 高级配置

### 多提供商配置

```json
{
  "models": {
    "providers": {
      "siliconflow": {...},
      "volcengine": {...},
      "bailian": {...}
    }
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "siliconflow/Pro/zai-org/GLM-4.7",  // 主模型
        "fallbacks": [  // 备用模型
          "volcengine/glm-4.7",
          "bailian/qwen-plus-latest"
        ]
      }
    }
  }
}
```

### 消息平台配置

```json
{
  "channels": {
    "ddingtalk": {
      "enabled": true,
      "clientId": "your-client-id",
      "clientSecret": "your-client-secret",
      "allowFrom": ["*"]
    }
  }
}
```

---

## 📚 相关文档

- [API 配置完整指南](../docs/API-CONFIG-GUIDE.md)
- [模型选择指南](../docs/api-config/model-comparison.md)
- [成本优化指南](../docs/api-config/cost-optimization.md)
- [故障排除](../docs/advanced/troubleshooting.md)

---

## 💡 提示

1. **备份配置**: 定期备份配置文件
2. **测试配置**: 修改配置后运行 `openclaw validate`
3. **查看日志**: `tail -f ~/.openclaw/logs/gateway.log`
4. **获取帮助**: `openclaw doctor`

---

**最后更新**: 2026-02-22
**OpenClaw 版本**: 2026.2.19+

<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->
