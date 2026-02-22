# OpenClaw API 配置指南

> 配置 AI 模型提供商的详细指南

---

## 📋 目录

- [支持的 API 平台](#-支持的-api-平台)
- [快速开始](#-az-快速开始)
- [平台详细配置](#-平台详细配置)
  - [硅基流动](#-硅基流动-siliconflow)
  - [火山方舟](#-火山方舟-volcengine)
  - [阿里百炼](#-阿里百炼-bailian)
  - [智谱 GLM](#-智谱-glm-zhipu)
  - [MiniMax](#-minimax)
  - [其他平台](#-其他平台)
- [配置验证](#-配置验证)
- [故障排除](#-故障排除)

---

## 🔑 支持的 API 平台

| 平台 | 免费额度 | 推荐度 | 模型数量 |
|------|---------|--------|---------|
| **硅基流动** | 2000万 Tokens ⭐ | ⭐⭐⭐⭐⭐ | 50+ |
| **火山方舟** | 首月8.91元 | ⭐⭐⭐⭐⭐ | 30+ |
| **阿里百炼** | 按量付费 | ⭐⭐⭐⭐ | 20+ |
| **智谱 GLM** | 新用户免费 | ⭐⭐⭐ | 10+ |
| **MiniMax** | 新用户免费 | ⭐⭐⭐ | 8+ |

---

## 🚀 快速开始

### 方法1: 使用配置向导（推荐新手）

```bash
# 启动配置向导
openclaw onboard
```

按照提示选择平台并输入 API Key。

---

### 方法2: 手动配置

```bash
# 1. 设置提供商
openclaw config set provider siliconflow

# 2. 设置 API Key
openclaw config set api_key YOUR_API_KEY

# 3. 验证配置
openclaw validate
```

---

## 🌐 平台详细配置

### 一、硅基流动 (SiliconFlow)

#### 注册账号

1. 访问 https://cloud.siliconflow.cn
2. 点击「注册」
3. 完成邮箱验证
4. 登录账号

#### 获取 API Key

1. 进入「API Keys」页面
2. 点击「创建新的 API Key」
3. 复制 API Key（格式：`sk-xxx...`）

#### 配置 OpenClaw

```bash
# 设置提供商
openclaw config set provider siliconflow

# 设置 API Key
openclaw config set api_key sk sk-xxxxxxxxxxxxxxxxxxxx

# 设置默认模型（可选）
openclaw config set model.primary siliconflow/Pro/MiniMaxAI/MiniMax-M2.5
```

#### 免费额度

- **免费额度**: 2000万 Tokens
- **模型**: Qwen、ChatGLM、DeepSeek、Llama、Mistral 等
- **到期时间**: 永久有效

#### 推荐模型

| 模型 | 用途 | 速度 | 质量 |
|------|------|------|------|
| `Pro/MiniMaxAI/MiniMax-M2.5` | 通用对话 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| `Qwen/Qwen2.5-72B-Instruct` | 复杂推理 | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| `THUDM/glm-4-9b-chat` | 代码生成 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |

---

### 二、火山方舟 (VolcEngine)

#### 注册账号

1. 访问 https://www.volcengine.com/activity/codingplan
2. 点击「立即订阅」
3. 完成实名认证
4. 选择套餐（Coding Plan 首月8.91元）

#### 获取 API Key

1. 进入「访问控制」→「API密钥管理」
2. 点击「创建密钥」
3. 复制 Access Key ID 和 Access Key Secret

#### 配置 OpenClaw

```bash
# 设置提供商
openclaw config set provider volcengine

# 设置 API Key
openclaw config set api_key YOUR_ACCESS_KEY_ID:YOUR_ACCESS_KEY_SECRET

# 设置默认模型（可选）
openclaw config set model.primary volcengine/glm-4.7
```

#### 套餐价格

| 套餐 | 价格 | 额度 | 适合人群 |
|------|------|------|---------|
| Coding Plan | 首月8.91元 | 宽松 | 开发者/个人 |
| Monthly Plan | 月付 | 按需使用 | 小型团队 |
| Enterprise | 年付 | 大额度 | 企业用户 |

#### 推荐模型

| 模型 | 用途 | 速度 | 质量 |
|------|------|------|------|
| `glm-4.7` | 通用推理 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| `deepseek-v3.2` | 深度思考 | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| `kimi-k2-thinking` | 复杂逻辑 | ⭐⭐ | ⭐⭐⭐⭐⭐ |

---

### 三、阿里百炼 (Bailian)

#### 注册账号

1. 访问 https://bailian.console.aliyun.com
2. 使用阿里云账号登录
3. 开通百炼服务

#### 获取 API Key

1. 进入「API-KEY管理」
2. 创建 API-KEY
3. 复制 API Key

#### 配置 OpenClaw

```bash
# 设置提供商
openclaw config set provider bailian

# 设置 API Key
openclaw config set api_key sk sk-xxxxxxxxxxxxxxxxxxxx

# 设置默认模型（可选）
openclaw config set model.primary bailian/qwen-plus-latest
```

#### 价格

| 模型 | 输入价格 | 输出价格 |
|------|---------|---------|
| qwen-plus | ¥0.004/千tokens | ¥0.012/千tokens |
| qwen-max | ¥0.04/千tokens | ¥0.12/千tokens |
| qwen-coder-plus | ¥0.008/千tokens | ¥0.024/千tokens |

#### 推荐模型

| 模型 | 用途 | 速度 | 质量 |
|------|------|------|------|
| `qwen-plus-latest` | 通用对话 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| `qwen-max-2025-09-23` | 复杂推理 | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| `qwen-coder-plus` | 代码生成 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |

---

### 四、智谱 GLM (Zhipu)

#### 注册账号

1. 访问 https://z.ai/subscribe
2. 点击「注册」
3. 完成手机验证
4. 登录账号

#### 获取 API Key

1. 进入「API Key」页面
2. 点击「创建API Key」
3. 复制 API Key

#### 配置 OpenClaw

```bash
# 设置提供商
openclaw config set provider zhipu

# 设置 API Key
openclaw config set api_key YOUR_API_KEY

# 设置默认模型（可选）
openclaw config set model.primary zhipu/glm-4-plus
```

#### 价格

| 模型 | 输入价格 | 输出价格 |
|------|---------|---------|
| GLM-4-Plus | ¥0.005/千tokens | ¥0.05/千tokens |
| GLM-4-Air | ¥0.001/千tokens | ¥0.001/千tokens |

#### 推荐模型

| 模型 | 用途 | 速度 | 质量 |
|------|------|------|------|
| `glm-4-plus` | 通用对话 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| `glm-4-air` | 快速响应 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |

---

### 五、MiniMax

#### 注册账号

1. 访问 https://platform.minimaxi.com
2. 点击「注册」
3. 完成注册流程
4. 登录账号

#### 获取 API Key

1. 进入「API密钥」页面
2. 点击「新建API密钥」
3. 复制 API Key

#### 配置 OpenClaw

```bash
# 设置提供商
openclaw config set provider minimax

# 设置 API Key
openclaw config set api_key YOUR_API_KEY

# 设置默认模型（可选）
openclaw config set model.primary minimax/abab6.5s-chat
```

#### 推荐模型

| 模型 | 用途 | 速度 | 质量 |
|------|------|------|------|
| `abab6.5s-chat` | 通用对话 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| `abab5.5-chat` | 快速响应 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |

---

### 六、其他平台

#### OpenAI

```bash
openclaw config set provider openai
openclaw config set api_key sk sk-xxxxxxxxxxxxxxxxxxxx
openclaw config set model.primary openai/gpt-4o
```

#### Anthropic Claude

```bash
openclaw config set provider anthropic
openclaw config set api_key sk sk-xxxxxxxxxxxxxxxxxxxx
openclaw config set model.primary anthropic/claude-3-opus-20240229
```

#### Google Gemini

```bash
openclaw config set provider google
openclaw config set api_key YOUR_API_KEY
openclaw config set model.primary google/gemini-pro
```

---

## ✅ 配置验证

### 验证 API Key

```bash
# 验证当前配置
openclaw validate

# 验证指定提供商
openclaw validate --provider siliconflow

# 验证指定 API Key
openclaw validate --provider siliconflow --api-key YOUR_API_KEY
```

### 查看配置

```bash
# 查看所有配置
openclaw config get

# 查看提供商
openclaw config get provider

# 查看 API Key（隐藏）
openclaw config get api_key

# 查看默认模型
openclaw config get model.primary
```

### 测试模型

```bash
# 列出可用模型
openclaw models list

# 测试模型响应
openclaw test --model siliconflow/Pro/MiniMaxAI/MiniMax-M2.5

# 切换默认模型
openclaw config config set model.primary siliconflow/Pro/MiniMaxAI/MiniMax-M2.5
```

---

## 🐛 故障排除

### 问题1: API Key 无效

**错误信息**:
```
Error: Invalid API key
```

**解决方案**:

1. 检查 API Key 是否正确
```bash
openclaw config get api_key
```

2. 重新配置 API Key
```bash
openclaw config set api_key YOUR_NEW_API_KEY
```

3. 验证 API Key
```bash
openclaw validate
```

---

### 问题2: 配额已用尽

**错误信息**:
```
Error: Insufficient额度
```

**解决方案**:

1. 检查账户余额
```bash
openclaw account --info
```

2. 切换到其他模型（更便宜）
```bash
openclaw config set model.primary siliconflow/Pro/THUDM/glm-4-9b-chat
```

3. 充值或升级套餐
   - 访问对应平台的控制台
   - 充值或升级套餐

---

### 问题3: 模型不存在

**错误信息**:
```
Error: Model not found: xxx
```

**解决方案**:

1. 列出可用模型
```bash
openclaw models list
```

2. 使用正确的模型名称
```bash
openclaw config set model.primary siliconflow/Pro/MiniMaxAI/MiniMax-M2.5
```

---

### 问题4: 网络连接失败

**错误信息**:
```
Error: Connection timeout
```

**解决方案**:

1. 检查网络连接
```bash
curl -Iv https://cloud.siliconflow.cn
```

2. 使用代理
```bash
export http_proxy=http://proxy.example.com:8080
export https_proxy=http://proxy.example.com:8080
```

3. 检查防火墙设置
```bash
# 检查出站规则
sudo iptables -L OUTPUT
```

---

### 问题5: 配置文件损坏

**错误信息**:
```
Error: Failed to parse config file
```

**解决方案**:

1. 备份当前配置
```bash
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.backup
```

2. 删除损坏的配置
```bash
rm ~/.openclaw/openclaw.json
```

3. 重新配置
```bash
openclaw onboard
```

---

## 💡 最佳实践

### 1. 安全存储 API Key

**使用环境变量**:
```bash
export OPENCLAW_API_KEY=YOUR_API_KEY
```

**使用配置文件**:
```bash
chmod 600 ~/.openclaw/openclaw.json
```

**不要在代码中硬编码**:
```javascript
// ❌ 不要这样做
const apiKey = 'sk sk-xxxxxxxxxxxxxxxxxxxx';

// ✅ 应该这样做
const apiKey = process.env.OPENCLAW_API_KEY;
```

---

### 2. 多平台配置模型

```bash
# 配置硅基流动作为默认
openclaw config set providers.siliconflow.apiKey YOUR_SILICONFLOW_KEY
openclaw config set model.primary siliconflow/Pro/MiniMaxAI/MiniMax-M2.5

# 配置火山方舟作为备用
openclaw config set providers.volcengine.apiKey YOUR_VOLCENGINE_KEY
openclaw config set model.fallback volcengine/glm-4.7
```

---

### 3. 定期检查配额

```bash
# 查看账户信息
openclaw account --info

# 设置配额告警
openclaw config set quota.alert.threshold 1000000
openclaw config set quota.alert.enabled true
```

---

### 4. 模型切换策略

**根据任务类型选择模型**:
- 简单对话 → `qwen-turbo`（快速）
- 代码生成 → `qwen-coder-plus`（专业）
- 复杂推理 → `qwen-max-2025-09-23`（高质量）
- 视觉任务 → `qwen-vl-plus-2025-08-15`（多模态）

---

## 📚 参考资源

- [硅基流动文档](https://docs.siliconflow.cn)
- [火山方舟文档](https://www.volcengine.com/docs)
- [阿里百炼文档](https://help.aliyun.com/zh/dashscope/)
- [智谱 GLM 文档](https://open.bigmodel.cn/dev/api)
- [OpenClaw 官方文档](https://docs.openclaw.ai)

---

**创建时间**: 2026-02-22 15:15 UTC
**版本**: 1.0
**Phase**: Phase 4+ - 阶段5
