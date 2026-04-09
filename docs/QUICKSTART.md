<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# OpenClaw 快速开始指南

> 5分钟快速上手 OpenClaw AI 助手

---

## 📋 目录

- [什么是 OpenClaw](#-什么是-openclaw)
- [系统要求](#-系统要求)
- [快速安装](#-快速安装)
- [配置 API Key](#-配置-api-key)
- [启动 OpenClaw](#-启动-openclaw)
- [连接消息平台](#-连接消息平台)
- [第一次对话](#-第一次对话)
- [下一步](#-下一步)

---

## 🤖 什么是 OpenClaw

OpenClaw 是一个开源的自托管 AI Agent 网关，可以部署在本地或服务器，通过 Discord、飞书、Telegram、WhatsApp、Signal、Slack 等 15+ 消息渠道与 AI 对话。

**核心特性**:
- 智能对话 - 支持 35+ 模型提供商（Anthropic、OpenAI、Google、VolcEngine 等）
- 多平台支持 - 内置 + 插件 15+ 消息渠道
- 技能扩展 - 1500+ 可安装技能 ([ClawHub](https://clawhub.com))
- 自主执行 - 浏览器、文件操作、代码执行、自动化
- 多媒体 - 图片/视频/语音生成、TTS、语音转写
- 自托管 - 数据完全本地化，隐私优先

---

## 💻 系统要求

### 最低配置

| 组件 | 要求 |
|------|------|
| 操作系统 | Linux/macOS/Windows 10+ (WSL2 更稳定) |
| Node.js | Node 24 (推荐) 或 Node 22.14+ |
| 内存 | 2GB RAM |
| 磁盘空间 | 1GB 可用空间 |
| 网络 | 稳定的互联网连接 |

### 推荐配置

| 组件 | 要求 |
|------|------|
| 操作系统 | Ubuntu 22.04+ / macOS Ventura+ / Windows 11 (WSL2) |
| Node.js | Node 24 |
| 内存 | 4GB+ RAM |
| 磁盘空间 | 5GB+ 可用空间 |
| 网络 | 稳定互联网连接（推荐代理） |

---

## 🚀 快速安装

### 方法1: 官方安装脚本（推荐）

**macOS / Linux / WSL2**:
```bash
curl -fsSL https://openclaw.ai/install.sh | bash
```

**Windows (PowerShell)**:
```powershell
iwr -useb https://openclaw.ai/install.ps1 | iex
```

安装脚本会自动：检测操作系统 → 安装 Node.js 24 → 安装 OpenClaw CLI → 启动配置向导

---

### 方法2: 手动安装

**1. 安装 Node.js 24**

**Linux (Ubuntu/Debian)**:
```bash
curl -fsSL https://deb.nodesource.com/setup_24.x | sudo -E bash -
sudo apt install -y nodejs
```

**macOS**:
```bash
brew install node@24
```

**Windows**:
1. 下载 [nvm-windows](https://github.com/coreybutler/nvm-windows/releases)
2. 运行安装程序
3. `nvm install 24` → `nvm use 24`

**2. 安装 OpenClaw**

```bash
npm install -g openclaw
```

**3. 运行配置向导**
```bash
openclaw onboard --install-daemon
```

---

### 方法3: Docker 部署（快速体验）

```bash
# 拉取镜像
docker pull openclaw/openclaw:latest

# 启动容器
docker run -d \
  --name openclaw \
  --restart unless-stopped \
  -p 18789:18789 \
  -v $(pwd)/data:/home/openclaw/.openclaw/data \
  openclaw/openclaw:latest

# 查看日志
docker logs -f openclaw
```

---

## 🔑 配置 API Key

OpenClaw 需要 AI 模型提供商的 API Key 才能工作。

### 推荐平台（新手友好）

| 平台 |  免费额度 | 说明 |
|------|---------|------|
| [**硅基流动**](https://cloud.siliconflow.cn/i/lva59yow) | 2000万 Tokens ⭐ | 2000万免费Token，支持多个开源模型 |
| [**火山方舟**](https://volcengine.com/L/oqijuWrltl0/  )| 首月8.91元 | 宽松套餐，适合长期使用 |
| [**阿里百炼**](https://www.aliyun.com/benefit/ai/aistar?userCode=yyzsc1al&clubBiz=subTask..12385059..10263..) | 首月7.9元 | 阿里云AI服务，稳定可靠 |

### 配置命令

**硅基流动（推荐）**:
```bash
openclaw config set provider silicon
flow
openclaw config set api_key YOUR_API_KEY
```

**火山方舟**:
```bash
openclaw config set provider volcengine
openclaw config set api_key YOUR_API_KEY
```

**阿里百炼**:
```bash
openclaw config set provider bailian
openclaw config set api_key YOUR_API_KEY
```

### 使用配置向导

```bash
openclaw onboard --install-daemon
```

按照提示选择平台并输入 API Key。

---

## 🎯 启动 OpenClaw

### 方式1: 命令行启动

```bash
# 启动 OpenClaw Gateway
openclaw gateway start

# 查看状态
openclaw status

# 查看日志
openclaw logs

# 停止
openclaw gateway stop
```

### 方式2: 后台运行

```bash
# 后台启动
openclaw gateway start --background

# 查看状态
openclaw gateway status

# 查看日志
openclaw gateway logs --tail 50
```

### 方式3: Docker 启动

```bash
# 启动容器
docker start openclaw

# 查看状态
docker ps | grep openclaw

# 查看日志
docker logs -f openclaw
```

### 验证安装

```bash
# 检查 OpenClaw 版本
openclaw --version

# 检查 Gateway 状态
openclaw status

# 测试连接
openclaw health
```

---

## 💬 连接消息平台

### Telegram（推荐新手）

1. **创建 Bot**
   - 打开 Telegram，搜索 [@BotFather](https://t.me/BotFather)
   - 发送 `/newbot`
   - 按照提示设置 bot 名称和用户名

2. **获取 Token**
   - BotFather 会返回 API Token
   - 格式：`123456789:ABCdefGHIjklMNOpqrsTUVwxyZ`

3. **配置 OpenClaw**
   ```bash
   openclaw config set channels.telegram botToken YOUR_BOT_TOKEN
   ```

4. **重启 Gateway**
   ```bash
   openclaw gateway restart
   ```

5. **开始使用**
   - 打开 Telegram，搜索你的 bot
   - 发送消息开始对话

---

### Discord

1. **创建应用**
   - 访问 [Discord Developer Portal](https://discord.com/developers/applications)
   - 点击 "New Application"
   - 设置应用名称

2. **创建 Bot**
   - 进入 "Bot" 标签
   - 点击 "Add Bot"
   - 复制 "Token"

3. **配置 OpenClaw**
   ```bash
   openclaw config set channels.discord botToken YOUR_BOT_TOKEN
   openclaw config set channels.discord clientId YOUR_CLIENT_ID
   ```

4. **重启并使用**
   - `openclaw gateway restart`
   - 使用 OAuth2 URL 邀请 Bot 到服务器

---

### Signal

1. **安装 Signal Desktop**
   - 下载 [Signal Desktop](https://signal.org/download/)

2. **连接 OpenClaw**
   ```bash
   # macOS
   openclaw config set channels.signal signalCliPath "/Applications/Signal.app/Contents/MacOS/Signal"

   # Linux
   openclaw config set channels.signal signalCliPath "/usr/bin/signal-cli"
   ```

3. **重启并使用**
   - `openclaw gateway restart`

---

### 其他平台

OpenClaw 内置 + 插件支持 15+ 消息渠道：
- **飞书** — [飞书对接教程](feishu-integration.md)（推荐，有官方插件）
- **钉钉** — [钉钉对接教程](dingtalk-integration.md)
- **QQ** — 内置 QQ Bot 插件
- **LINE** — 内置 LINE 插件（支持多媒体）
- **Matrix** — 内置 Matrix 插件
- **微信** — 第三方插件支持
- **WhatsApp** — 内置支持
- **Slack** — 内置支持
- **iMessage** — 仅 macOS
- **Microsoft Teams** — 内置插件
- **IRC** — 内置支持

详细配置请参考 [平台对接总览](platform-integration-overview.md)

---

## 🗣️ 第一次对话

### Telegram 示例

1. **搜索你的 Bot**
   - 在 Telegram 中搜索你创建的 bot 用户名

2. **发送第一条消息**
   ```
   你好！我是 OpenClaw，有什么可以帮你的吗？
   ```

3. **尝试更多对话**
   ```
   - "帮我写一个 Python 脚本"
   - "搜索最新的 AI 新闻"
   - "翻译这段文字到英文"
   - "帮我总结这篇文章"
   ```

---

### 常用命令

在对话中使用以下命令：

| 命令 | 说明 |
|------|------|
| `/status` | 查看 OpenClaw 状态 |
| `/help` | 显示帮助信息 |
| `/config` | 查看配置 |
| `/models` | 查看可用模型 |
| `/set model <name>` | 切换模型 |
| `/set thinking on` | 启用深度思考 |
| `/history` | 查看对话历史 |

---

### 技能使用

OpenClaw 支持安装技能扩展功能：

```bash
# 搜索技能
openclaw skills search weather

# 安装技能
openclaw skills install weather-skill

# 列出已安装技能
openclaw skills list

# 卸载技能
openclaw skills uninstall weather-skill
```

---

## ✨ 下一步

### 学习资源

- [完整安装指南](../install/installation-guide.md) - 详细的安装教程
- [API配置指南](../api-config/api-setup.md) - 所有 API 平台配置
- [模型选择指南](../api-config/model-comparison.md) - 如何选择合适的模型
- [技能商店](https://clawhub.com) - 丰富的技能生态

### 高级功能

- **浏览器自动化** - 查看网页、填写表单、截图
- **文件操作** - 读取、编辑、创建文件
- **代码执行** - 运行 Python、Node.js、Shell
- **子代理** - 并行执行多个任务（ACP 协议）
- **多媒体生成** - 图片/视频/语音生成
- **Cron 任务** - 定时执行任务
- **记忆系统** - 向量搜索 + 长期记忆

### 社区支持

- 📖 [官方文档](https://docs.openclaw.ai)
- 💬 [Discord 社区](https://discord.com/invite/clawd)
- 🐙 [GitHub 仓库](https://github.com/openclaw/openclaw)
- 🌐 [ClawHub 技能商店](https://clawhub.com)

---

## ❓ 常见问题

### Q: OpenClaw 启动失败？

A: 检查以下几点：
```bash
# 1. 检查 Gateway 状态
openclaw status

# 2. 查看日志
openclaw logs --tail 100

# 3. 检查配置
openclaw config get

# 4. 验证 API Key
openclaw validate --provider siliconflow --api-key YOUR_API_KEY
```

### Q: 消息发送失败？

A: 检查通道配置：
```bash
# 验证 Telegram Bot Token
openclaw config get channels.telegram

# 重新启动 Gateway
openclaw gateway restart

# 查看错误日志
openclaw logs --tail 50 | grep -i error
```

### Q: 如何更换 AI 模型？

A:
```bash
# 查看可用模型
openclaw models list

# 设置默认模型
openclaw config set model.primary siliconflow/Pro/MiniMaxAI/MiniMax-M2.5

# 或在对话中
/set model siliconflow/Pro/MiniMaxAI/MiniMax-M2.5
```

### Q: 如何提高响应速度？

A:
1. 使用更快的模型（如 `qwen-turbo`）
2. 减少 `thinking` 模式（深度思考会降低速度）
3. 使用本地部署的模型（需要高性能硬件）

---

**创建时间**: 2026-02-22 15:05 UTC
**版本**: 3.0
**作者**: junhang lai

<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->
