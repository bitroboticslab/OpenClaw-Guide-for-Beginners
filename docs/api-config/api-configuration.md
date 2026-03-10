<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# API 配置详解

> OpenClaw 需要配置大模型 API 才能运行，本文详细介绍各平台的配置方法

## 📋 目录

- [快速开始（推荐）](#)快速开始推荐)
- [使用配置模板](#使用配置模板)
- [API 平台对比](#api-平台对比)
- [硅基流动 SiliconFlow](#硅基流动-siliconflow)
- [阿里百炼](#阿里百炼)
- [火山方舟](#火山方舟)
- [智谱 GLM](#智谱-glm)
- [MiniMax](#minimax)
- [配置技巧](#配置技巧)

---

## 🚀 快速开始（推荐）

新手推荐使用配置向导自动生成配置：

```bash
# 运行配置向导
openclaw onboard --install-daemon
```

向导会自动：
1. 检测环境和依赖
2. 引导选择 API 提供商
3. 帮助获取 API Key
4. 自动生成配置文件
5. 验证配置正确性

---

## 📋 使用配置模板

如果你需要手动配置，可以使用我们提供的配置模板：

```bash
# 1. 克隆或下载教程仓库
git clone https://github.com/Mr-tooth/OpenClaw-Guide-for-Beginners.git
cd OpenClaw-Guide-for-Beginners

# 2. 查看模板目录
ls templates/

# 3. 查看模板使用指南
cat templates/README.md
```

**模板文件说明**:

| 文件 | 说明 | 使用方法 |
|------|------|---------|
| `openclaw-template.json` | OpenClaw 主配置模板 | 复制到 `~/.openclaw/openclaw.json` |
| `env-template.txt` | 环境变量模板 | 复制到 `~/.openclaw/.env` |

**快速使用模板**:

```bash
# 复制主配置模板
cp templates/openclaw-template.json ~/.openclaw/openclaw.json

# 复制环境变量模板
cp templates/env-template.txt ~/.openclaw/.env

# 设置正确权限（重要！）
chmod 600 ~/.openclaw/openclaw.json
chmod 600 ~/.openclaw/.env

# 编辑配置文件，填写你的 API Key
nano ~/.openclaw/openclaw.json
nano ~/.openclaw/.env
```

详细模板使用说明请查看：[templates/README.md](../templates/README.md)

---

---

## API 平台对比

| 平台 | 新用户福利 | Coding Plan | 模型丰富度 | 性价比 | 推荐场景 |
|------|------------|-------------|------------|--------|----------|
| 硅基流动 | 2000万 Tokens | ✗ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | 新手入门 |
| 阿里百炼 | 免费额度 | ✓ Lite/Pro | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | 阿里生态 |
| 火山方舟 | 首月折扣 | ✓ Lite/Pro | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | 性价比 |
| 智谱 GLM | 新用户优惠 | ✓ Lite/Pro/Max | ⭐⭐⭐ | ⭐⭐⭐⭐ | 长期使用 |
| MiniMax | 新用户优惠 | ✓ | ⭐⭐⭐ | ⭐⭐⭐⭐ | Agent 场景 |

---

## 硅基流动 SiliconFlow

### 平台简介

硅基流动是国内领先的大模型 API 平台，提供多种开源和商业模型的 API 服务。主要特点：
- 🎁 新用户注册送 2000万 Tokens
- 🔄 邀请好友双方各得代金券
- 📊 支持 DeepSeek、Qwen、GLM 等多款模型

### 注册步骤

1. **访问官网注册**
   
   👉 [硅基流动注册链接](https://cloud.siliconflow.cn/i/lva59yow)

2. **完成实名认证**
   - 手机号验证
   - 实名认证（可解锁更多权益）

3. **获取 API Key**
   - 登录后点击右上角头像
   - 进入「API 密钥」页面
   - 点击「创建新密钥」
   - 复制保存 API Key（只显示一次）

### 配置 OpenClaw

```bash
# 启动配置向导
openclaw onboard --install-daemon

# 选择模型提供商
Select AI Provider: SiliconFlow

# 粘贴 API Key
Enter API Key: sk-xxxxxxxxxxxxxxxx

# 选择模型（推荐）
Select Model: 
  - deepseek-ai/DeepSeek-V3  # 性价比最高
  - Qwen/Qwen2.5-72B-Instruct  # 综合能力强
  - THUDM/glm-4-9b-chat  # 轻量快速
```

### 手动配置文件

编辑 `~/.openclaw/config.json`：

```json
{
  "providers": {
    "siliconflow": {
      "api_key": "sk-xxxxxxxxxxxxxxxx",
      "base_url": "https://api.siliconflow.cn/v1",
      "models": {
        "default": "deepseek-ai/DeepSeek-V3"
      }
    }
  }
}
```

### 价格参考

| 模型 | 输入价格 | 输出价格 | 备注 |
|------|----------|----------|------|
| DeepSeek-V3 | ¥0.5/百万Tokens | ¥2/百万Tokens | 性价比之王 |
| Qwen2.5-72B | ¥4/百万Tokens | ¥4/百万Tokens | 综合能力强 |
| GLM-4-9B | 免费 | 免费 | 轻量模型 |

---

## 阿里百炼

### 平台简介

阿里云百炼是阿里云推出的大模型服务平台，与 OpenClaw 深度整合：
- 🆓 新人免费额度（30-90天）
- 💼 Coding Plan 编程套餐
- 🔗 阿里云生态无缝对接
- 💰 邀请好友每单得 30 元

### 注册步骤

1. **开通百炼服务**
   
   👉 [阿里百炼开通链接](https://bailian.console.aliyun.com)

2. **领取新人免费额度**
   - 进入「模型广场」
   - 申请想要的模型
   - 免费额度自动激活

3. **获取 API Key**
   - 控制台 → API-KEY 管理
   - 创建 API Key
   - 复制保存

### Coding Plan 套餐

| 套餐 | 价格 | 额度 | 适合人群 |
|------|------|------|----------|
| Lite | 10 元/月 | 6000次请求 | 个人开发者 |
| Pro | 50 元/月 | 18000次请求 | 重度用户 |

> 💡 **提示**：Coding Plan 支持 Qwen Code、Claude Code、OpenClaw 等工具

### 配置 OpenClaw

```bash
openclaw onboard --install-daemon

Select AI Provider: Alibaba Cloud (Bailian)
Enter API Key: sk-xxxxxxxxxxxxxxxx
Select Model: qwen-turbo / qwen-plus / qwen-max
```

### 官方文档

- [百炼 OpenClaw 文档](https://help.aliyun.com/zh/model-studio/openclaw)
- [Coding Plan 文档](https://help.aliyun.com/zh/model-studio/coding-plan)

---

## 火山方舟

### 平台简介

火山方舟是字节跳动推出的大模型服务平台：
- 🎯 Coding Plan 支持多款顶级模型
- 💰 Lite 套餐首月仅 8.91 元（原价 40 元）
- 🤝 邀请好友双方受益

### 注册步骤

1. **访问官网**
   
   👉 [火山方舟 Coding Plan](https://volcengine.com/L/oqijuWrltl0/  )

2. **选择套餐**
   - Lite: 首月 8.91 元（使用邀请码）
   - Pro: 首月 44.91 元

3. **获取 API Key**
   - 控制台 → API Key 管理
   - 创建并复制 API Key

### 支持模型

Coding Plan 一个订阅可使用：
- **Doubao-Seed-Code**：字节自研编程模型
- **GLM-4.7**：智谱最新模型
- **DeepSeek-V3.2**：性价比之王
- **Kimi-K2.5**：长文本能力出色

### 配置 OpenClaw

```bash
openclaw onboard --install-daemon

Select AI Provider: Volcengine (Ark)
Enter API Key: xxxxxxxxxxxxxxxx
Select Model: Doubao-Seed-Code / GLM-4.7 / DeepSeek-V3.2
```

---

## 智谱 GLM

### 平台简介

智谱 AI 是国内领先的大模型公司：
- 🧠 GLM 系列模型不断迭代
- 💎 Coding Plan 套餐丰富
- 💸 邀请返利最高 40%

### 套餐选择

| 套餐 | 月价 | 年价 | 额度 |
|------|------|------|------|
| Lite | ¥39 | ¥273（7折） | 基础额度 |
| Pro | ¥129 | ¥903（7折） | 进阶额度 |
| Max | ¥399 | ¥2793（7折） | 顶配额度 |

### 注册步骤

1. **访问订阅页面**
   
   👉 [智谱 GLM 订阅链接](https://www.bigmodel.cn/glm-coding?ic=BUDVTRHUYH)

2. **选择套餐并支付**

3. **获取 API Key**
   - 控制台 → API 密钥
   - 创建密钥

### 配置 OpenClaw

```bash
openclaw onboard --install-daemon

Select AI Provider: Zhipu AI (GLM)
Enter API Key: xxxxxxxxxxxxxxxx
Select Model: GLM-4-Plus / GLM-4-Air / GLM-4-Flash
```

---

## MiniMax

### 平台简介

MiniMax 专注于 Agent 场景优化：
- 🤖 M2.5 模型专为 Agent 设计
- 🎁 邀请好友享 9 折 + Builder 权益
- 💰 邀请者获得 10% 代金券返利

### 注册步骤

1. **访问官网**
   
   👉 [MiniMax Coding Plan](https://platform.minimaxi.com/subscribe/coding-plan)

2. **订阅 Coding Plan**

3. **获取 API Key**

### 配置 OpenClaw

```bash
openclaw onboard --install-daemon

Select AI Provider: MiniMax
Enter API Key: xxxxxxxxxxxxxxxx
Select Model: abab6.5s-chat / abab6.5-chat
```

---

## 配置技巧

### 多模型切换

OpenClaw 支持配置多个模型提供商，可以在不同场景使用不同模型：

```json
{
  "providers": {
    "siliconflow": {
      "api_key": "sk-xxx",
      "base_url": "https://api.siliconflow.cn/v1",
      "models": {
        "default": "deepseek-ai/DeepSeek-V3",
        "coding": "Qwen/Qwen2.5-72B-Instruct"
      }
    },
    "zhipu": {
      "api_key": "xxx",
      "base_url": "https://open.bigmodel.cn/api/paas/v4",
      "models": {
        "default": "GLM-4-Plus"
      }
    }
  },
  "default_provider": "siliconflow"
}
```

### 成本优化建议

1. **日常对话**：使用 DeepSeek-V3 等高性价比模型
2. **编程任务**：使用专门的编程模型（如 Qwen-Code）
3. **复杂推理**：使用 GLM-4-Plus 或 Qwen-Max
4. **批量处理**：使用轻量模型降低成本

### 常见问题

**Q: API Key 保存在哪里？**

A: OpenClaw 的配置文件位于 `~/.openclaw/config.json`，API Key 会安全存储在此文件中。

**Q: 如何查看 API 使用量？**

A: 登录各平台控制台查看，OpenClaw 也提供 `openclaw usage` 命令查看统计。

**Q: 多个 API Key 如何管理？**

A: 可以配置多个提供商，通过环境变量或配置文件切换。

---

## 💰 优惠链接汇总

| 平台 | 链接 | 专属优惠 |
|------|------|----------|
| 硅基流动 | [注册链接](https://cloud.siliconflow.cn/i/lva59yow) | 注册送 2000万 Tokens |
| 阿里百炼 | [开通链接](https://bailian.console.aliyun.com) | 新人免费额度 + Coding Plan |
| 火山方舟 | [Coding Plan](https://volcengine.com/L/oqijuWrltl0/  ) | 首月 8.91 元起 |
| 智谱 GLM | [订阅链接](https://www.bigmodel.cn/glm-coding?ic=BUDVTRHUYH) | 年付 7 折 |
| MiniMax | [官网链接](https://www.minimaxi.com) | 邀请享 9 折 |

> 通过以上链接注册可享受额外优惠，同时支持作者持续更新教程 ❤️

---

**上一页**：[云服务器部署指南](../cloud/cloud-deployment-guide.md) | **下一页**：[平台对接教程](../platform-integration/platform-integration-overview.md)

<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->
