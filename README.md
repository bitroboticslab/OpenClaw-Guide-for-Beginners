<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# OpenClaw 新手完全指南

> 从零开始，手把手教你部署属于自己的 24 小时在线 AI 助手

![OpenClaw](https://img.shields.io/badge/OpenClaw-218K%2B%20Stars-blue)
![License](https://img.shields.io/badge/License-MIT-green)
![更新时间](https://img.shields.io/badge/更新时间-2026年2月-orange)

## 📖 项目简介

OpenClaw（原名 Clawdbot、Moltbot）是一个开源的个人 AI 助手平台，在短短 3 周内突破 190,000+ Stars，成为 GitHub 历史上增长最快的开源项目之一。

**教程作者**: [junhang lai](https://github.com/Mr-tooth)

**核心特性：**
- 🤖 真正的 AI Agent —— 不只是聊天，还能执行操作
- 🔒 本地运行 —— 数据完全由你掌控
- 🌐 多平台对接 —— 支持飞书、钉钉、微信、Telegram 等
- ⚡ 24小时在线 —— 云服务器部署全天候待命
- 🛠️ 1700+ Skills —— 丰富的技能扩展库

## 🚀 快速开始

根据你的平台选择对应教程：

| 平台 | 难度 | 推荐指数 | 教程链接 |
|------|------|----------|----------|
| Windows | ⭐⭐ | ⭐⭐⭐ | [Windows 安装指南](docs/windows/windows-install-guide.md) |
| WSL | ⭐⭐ | ⭐⭐⭐⭐ | [WSL 安装教程](docs/wsl/wsl-setup.md) |
| macOS | ⭐⭐ | ⭐⭐⭐⭐⭐ | [macOS 安装指南](docs/macos/macos-install-guide.md) |
| Linux | ⭐ | ⭐⭐⭐⭐⭐ | [Linux 安装指南](docs/linux/linux-install-guide.md) |
| Docker | ⭐⭐⭐ | ⭐⭐⭐⭐ | [Docker 部署教程](docs/docker/docker-deployment.md) |
| 云服务器 | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | [云服务器部署指南](docs/cloud/cloud-deployment-guide.md) |
| Android | ⭐⭐⭐⭐ | ⭐⭐⭐ | [Android 部署指南](docs/android/android-deployment-guide.md) |

## 💰 API 平台推荐

OpenClaw 需要接入大模型 API 才能运行。以下是各平台的优惠信息：

| 平台 | 新用户福利 | 邀请奖励 | 推荐指数 |
|------|-----------|---------|----------|
| [硅基流动](https://cloud.siliconflow.cn/i/lva59yow) | 注册送 2000万 Tokens | 邀请双方各得代金券 | ⭐⭐⭐⭐⭐ |
| [火山引擎方舟](https://volcengine.com/L/tHxxM_WwYp4/) | 折上9折，低至8.9元，支持Doubao/GLM/DeepSeek/Kimi | 订阅越多越划算 | ⭐⭐⭐⭐⭐ |
| [智谱 GLM Coding](https://www.bigmodel.cn/glm-coding?ic=BUDVTRHUYH) | Claude Code、Cline等20+工具无缝支持 | 限时惊喜价 | ⭐⭐⭐⭐ |
| [MiniMax](https://platform.minimaxi.com/subscribe/coding-plan) | 新用户9折优惠 | 邀请者10%返利 | ⭐⭐⭐ |

💡 **新手建议**：先注册[硅基流动](https://cloud.siliconflow.cn/i/lva59yow)体验免费额度，再根据需求选择其他平台。

👉 [查看详细 API 配置教程](docs/api-config/api-configuration.md) | [模型选择指南](docs/api-config/model-comparison.md) | [成本优化](docs/api-config/cost-optimization.md)

## ☁️ 云服务器推荐

想要 24 小时在线的 AI 助手？推荐使用云服务器部署：

### 阿里云（推荐）

**OpenClaw 专属活动页**，通过我的链接注册享受独家优惠：

[🔗 立即部署 - 半小时搞定](https://www.aliyun.com/activity/ecs/clawdbot?userCode=yyzsc1al)

**专属福利**:
- 🎁 普惠套餐（2核2G不限流量，99元/年，新用户 68元/年 起）
- 🔗 阿里百炼 AI 大模型 88% 折扣
- 💎 建站三件套（域名+服务器+AI建站，百元搞定）
- ⏰ 半小时内完成部署

### 云服务商对比

| 云服务商 | 套餐价格 | OpenClaw 支持 | 推荐指数 |
|----------|----------|---------------|----------|
| [阿里云](https://www.aliyun.com/activity/ecs/clawdbot?userCode=yyzsc1al) | 68元/年起 | 一键镜像部署 | ⭐⭐⭐⭐⭐ |
| [腾讯云](https://curl.qcloud.com/JnWPPHIH) | [79元起](https://cloud.tencent.com/act/cps/redirect?redirect=1079&cps_key=d427af70c58018a013008ba30489f688&from=console&cps_promotion_id=102390)| 官方教程支持 | ⭐⭐⭐⭐ |
| [百度智能云](https://cloud.baidu.com) | 多种套餐 | 一键部署教程 | ⭐⭐⭐ |

👉 [查看云服务器部署教程](docs/cloud/cloud-deployment-guide.md) | [阿里云专属教程](docs/cloud/aliyun-guide.md) | [腾讯云专属教程](docs/cloud/tencent-guide.md)

## 📱 平台对接

OpenClaw 支持对接多种消息平台：

| 平台 | 对接难度 | 教程链接 |
|------|----------|----------|
| 飞书 | ⭐⭐ | [飞书对接教程](docs/platform-integration/feishu-integration.md) |
| 钉钉 | ⭐⭐ | [钉钉对接教程](docs/platform-integration/dingtalk-integration.md) |
| Telegram | ⭐ | [Telegram对接教程](docs/platform-integration/telegram-integration.md) |
| 微信 | ⭐⭐⭐ | [微信对接教程](docs/platform-integration/wechat-integration.md) |

## 🎯 学习路径

根据你的经验选择合适的学习路径：

### 🌱 新手入门路径

1. 阅读 [5分钟快速上手](docs/start/quickstart.md)
2. 根据系统选择安装教程（Windows/macOS/Linux）
3. 配置 API ([API配置详解](docs/api-config/api-configuration.md))
4. 对接第一个平台（推荐钉钉或飞书）
5. 遇到问题查看 [FAQ](FAQ.md)

### 🚀 服务器部署路径

1. 阅读 [云服务器部署指南](docs/cloud/cloud-deployment-guide.md)
2. 选择云服务商（推荐[阿里云](https://www.aliyun.com/activity/ecs/clawdbot?userCode=yyzsc1al)）
3. 配置服务器和域名
4. 部署 OpenClaw
5. 对接消息平台

### 🔧 进阶开发路径

1. 熟悉基础配置
2. 学习 [技能开发](docs/advanced/skills.md)
3. 研究 [安全配置](docs/advanced/security.md)
4. 掌握 [故障排查](docs/advanced/troubleshooting.md)

---

## 📚 目录结构

```
OpenClaw-Guide-for-Beginners/
├── README.md                    # 项目首页（本文件）
├── AUTHORS.md                   # 作者信息
├── FAQ.md                       # 常见问题解答
├── RESOURCES.md                 # 资源汇总
├── docs/                        # 教程文档目录
│   ├── start/                   # 快速开始
│   │   └── quickstart.md        # 5分钟快速上手
│   ├── windows/                 # Windows 相关教程
│   │   └── windows-install-guide.md
│   ├── wsl/                     # WSL 相关教程
│   │   ├── wsl-setup.md         # WSL 安装配置
│   │   ├── wsl-troubleshooting.md
│   │   └── wsl-advanced.md      # WSL 高级配置
│   ├── macos/                   # macOS 相关教程
│   │   └── macos-install-guide.md
│   ├── linux/                   # Linux 相关教程
│   │   └── linux-install-guide.md
│   ├── docker/                  # Docker 部署教程
│   │   ├── docker-deployment.md      # Docker 基础部署
│   │   ├── docker-production.md      # Docker 生产部署
│   │   ├── docker-cloud-deployment.md # Docker Cloud 部署
│   │   └── docker-troubleshooting.md
│   ├── cloud/                   # 云服务器相关教程
│   │   ├── cloud-deployment-guide.md
│   │   ├── aliyun-guide.md      # 阿里云专属教程
│   │   └── tencent-guide.md    # 腾讯云教程
│   ├── android/                 # Android 相关教程
│   │   └── android-deployment-guide.md
│   ├── api-config/              # API 配置教程
│   │   ├── api-configuration.md
│   │   ├── model-comparison.md  # 模型选择指南
│   │   └── cost-optimization.md # 成本优化指南
│   ├── platform-integration/    # 平台对接教程
│   │   ├── platform-integration-overview.md
│   │   ├── feishu-integration.md
│   │   ├── dingtalk-integration.md
│   │   ├── telegram-integration.md
│   │   └── wechat-integration.md
│   └── advanced/                # 进阶主题
│       ├── security.md          # 安全配置指南
│       ├── skills.md            # 技能开发与使用
│       └── troubleshooting.md   # 故障排除
├── scripts/                     # 安装脚本
│   ├── install-windows.bat      # Windows 安装脚本
│   ├── install-wsl.ps1          # WSL 安装脚本
│   ├── install-linux.sh         # Linux 安装脚本
│   ├── install-macos.sh         # macOS 安装脚本
│   └── install-docker.sh        # Docker 安装脚本
├── images/                      # 教程图片
└── templates/                   # 配置模板
    ├── README.md                # 模板使用指南
    ├── openclaw-template.json   # 主配置模板
    └── env-template.txt         # 环境变量模板
```
<details>
<summary><b>Q: 哪个 API 平台最推荐？</b></summary>

推荐根据你的需求选择：
- **新手入门**：硅基流动（免费额度多，上手简单）
- **性价比优先**：火山方舟 Coding Plan（首月仅8.91元）
- **长期使用**：智谱 GLM Coding Plan（年付优惠力度大）
- **阿里生态用户**：阿里百炼（与阿里云整合好）
# ⚙️ 配置模板和脚本

> ⚠️ **重要提示**: 本章节的模板文件仅作为参考，请勿直接覆盖你的配置文件！

---

## 🔧 配置模板说明

项目提供了配置模板供参考，**适用于理解配置结构**，**不推荐直接覆盖使用**。

| 模板文件 | 说明 | 用途 |
|---------|------|------|
| `templates/openclaw-template.json` | 主配置参考模板 | 了解配置结构，提取配置片段 |
| `templates/env-template.txt` | 环境变量模板 | 参考环境变量配置格式 |

### ⚠️ 为什么不能直接覆盖？

**模板文件缺少系统配置**:
- ❌ 缺少 `meta` 字段（版本信息）
- ❌ 缺少 `wizard` 字段（配置向导状态）
- ❌ 缺少 `browser` 字段（浏览器配置）
- ❌ 缺少 `auth` 字段（认证配置）
- ✅ 仅包含 `models`、`agents`、`gateway`、`channels` 等用户配置

**直接覆盖的后果**:
- 🔥 `openclaw doctor` 报错
- 🔥 Gateway 启动失败
- 🔥 丢失浏览器配置
- 🔥 丢失认证信息

---

## ✅ 正确的使用方法

### 方法1: 使用OpenClaw配置向导（推荐新手）

```bash
# 启动配置向导
openclaw onboard --install-daemon

# 或运行诊断并配置
openclaw doctor
```

按照提示选择平台并输入 API Key，OpenClaw 会自动生成正确的配置。

---

### 方法2: 手动配置（推荐有经验的用户）

#### 步骤1: 备份现有配置

```bash
# 备份现有配置（安全第一！）
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.backup.$(date +%Y%m%d)
cp ~/.openclaw/.env ~/.openclaw/.env.backup.$(date +%Y%m%d) 2>/dev/null || true
```

#### 步骤2: 使用命令行配置

```bash
# 设置提供商（以硅基流动为例）
openclaw config set provider siliconflow

# 设置 API Key
openclaw config set api_key sk-xxxxxxxxxxxxxxxxxxxx

# 验证配置
openclaw doctor
```

#### 步骤3: 手动编辑配置文件

```bash
# 使用 nano 编辑配置文件
nano ~/.openclaw/openclaw.json

# 或使用 VS Code
code ~/.openclaw/openclaw.json
```

**编辑建议**:
- ✅ 只添加或修改需要的字段
- ✅ 保持 JSON 格式正确（逗号、引号）
- ✅ 使用 `openclaw doctor` 验证配置
- ❌ 不要删除或修改 `meta`、`wizard`、`browser` 等系统字段

---

### 方法3: 参考模板文件（高级用户）

**适用场景**:
- 了解配置结构
- 提取模型配置片段
- 参考环境变量配置

**操作步骤**:

```bash
# 1. 查看模板文件内容
cat templates/openclaw-template.json

# 2. 提取需要的配置（例如：模型配置）
#    打开模板文件和你的配置文件
nano templates/openclaw-template.json
nano ~/.openclaw/openclaw.json

# 3. 复制需要的配置片段到你的配置文件
#    注意：只复制需要的部分，不要覆盖整个文件

# 4. 验证配置
openclaw doctor
```

**示例：添加新的提供商配置**

1. 打开模板文件，找到你需要的提供商配置
2. 复制该提供商的配置块
3. 打开你的配置文件，粘贴到 `models.providers` 中
4. 修改 `apiKey` 为你的实际值
5. 运行 `openclaw doctor` 验证

---

## 🔐 环境变量配置

**推荐使用环境变量存储敏感信息**（API Key、Token等）。

### 创建 .env 文件

```bash
# 创建 .env 文件
touch ~/.openclaw/.env

# 设置文件权限（仅自己可读写）
chmod 600 ~/.openclaw/.env

# 编辑 .env 文件
nano ~/.openclaw/.env
```

### .env 文件示例

```bash
# ========================================
# OpenClaw 环境变量配置
# ========================================

# 硅基流动 API Key
SILICONFLOW_API_KEY=sk-your-siliconflow-api-key-here

# 火山引擎 API Key
VOLCENGINE_API_KEY=AK-your-volcengine-api-key-here

# 阿里百炼 API Key
BAILIAN_API_KEY=sk-your-bailian-api-key-here

# Gateway 认证 Token（用于访问 Gateway UI）
OPENCLAW_GATEWAY_TOKEN=your-gateway-token-here

# DingTalk 应用凭证
DINGTALK_CLIENT_ID=your-dingtalk-client-id
DINGTALK_CLIENT_SECRET=your-dingtalk-client-secret

# Telegram Bot Token
TELEGRAM_BOT_TOKEN=your-telegram-bot-token

# 智谱 GLM API Key
ZHIPU_API_KEY=your-zhipu-api-key
```

### 在配置文件中使用环境变量

```json
{
  "models": {
    "providers": {
      "siliconflow": {
        "baseUrl": "https://api.siliconflow.cn/v1",
        "apiKey": "${SILICONFLOW_API_KEY}",
        "api": "openai-completions"
      }
    }
  },
  "gateway": {
    "auth": {
      "token": "${OPENCLAW_GATEWAY_TOKEN}"
    }
  }
}
```

**优势**:
- ✅ 敏感信息与配置分离
- ✅ 不同环境使用不同的 .env 文件
- ✅ 可以安全地分享配置文件（不包含 .env）
- ✅ 使用 `${VARIABLE}` 格式引用

---

## 🛠️ 一键安装脚本

> ⚠️ **慎重使用**：一键安装脚本适合全新安装，**不适用于已有OpenClaw环境的用户**

| 脚本 | 平台 | 适用场景 | 下载方式 |
|------|------|---------|---------|
| `install-windows.bat` | Windows | 全新安装 | [下载](https://raw.githubusercontent.com/Mr-tooth/OpenClaw-Guide-for-Beginners/main/scripts/install-windows.bat) |
| `install-wsl.ps1` | WSL | 全新安装 | [下载](https://raw.githubusercontent.com/Mr-tooth/OpenClaw-Guide-for-Beginners/main/scripts/install-wsl.ps1) |
| `install-linux.sh` | Linux | 全新安装 | [下载命令](#linux-安装) |
| `install-macos.sh` | macOS | 全新安装 | [下载命令](#macos-安装) |
| `install-docker.sh` | Docker | 容器化部署 | [下载命令](#docker-安装) |

### Windows 安装

```powershell
# 下载安装脚本
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Mr-tooth/OpenClaw-Guide-for-Beginners/main/scripts/install-windows.bat" -OutFile "install-windows.bat"

# 以管理员身份运行
.\install-windows.bat
```

### macOS/Linux 安装

```bash
# 下载安装脚本
curl -O https://raw.githubusercontent.com/Mr-tooth/OpenClaw-Guide-for-Beginners/main/scripts/install-linux.sh

# 添加执行权限
chmod +x install-linux.sh

# 运行安装脚本（会自动安装Node.js和OpenClaw）
./install-linux.sh

# 或直接一行命令安装
curl -fsSL https://raw.githubusercontent.com/Mr-tooth/OpenClaw-Guide-for-Beginners/main/scripts/install-linux.sh | bash
```

### Docker 安装

```bash
# 下载安装脚本
curl -O https://raw.githubusercontent.com/Mr-tooth/OpenClaw-Guide-for-Beginners/main/scripts/install-docker.sh

# 添加执行权限
chmod +x install-docker.sh

# 运行安装脚本
./install-docker.sh
```

**脚本功能**:
- ✅ 自动检测系统环境
- ✅ 安装 Node.js（如未安装）
- ✅ 安装 OpenClaw
- ✅ 运行配置向导
- ✅ 提供后续配置指导
- ✅ 详细的错误提示

---

## 📋 配置验证

无论使用哪种方法配置，最后都要验证配置：

```bash
# 运行诊断
openclaw doctor

# 或检查配置
openclaw config list

# 检查模型配置
openclaw models list

# 检查 Gateway 状态
openclaw gateway status
```

**预期输出**:

```bash
✅ OpenClaw CLI: 已安装 v2026.2.19
✅ Node.js: 已安装 v22.22.0
✅ Gateway: 运行中 (PID: 12345)
✅ 模型配置: 正常
✅ 提供商: siliconflow (已配置)
✅ 向量搜索: 已启用
```

---

## ❓ 常见问题

### Q: 配置文件在哪里？

**A:**
- 主配置: `~/.openclaw/openclaw.json`
- 环境变量: `~/.openclaw/.env`
- 工作空间: `~/.openclaw/workspace`

### Q: 如何重置配置？

**A:**
```bash
# 删除配置文件（⚠️ 慎重操作）
rm ~/.openclaw/openclaw.json

# 重新运行配置向导
openclaw onboard --install-daemon
```

### Q: 如何备份配置？

**A:**
```bash
# 备份到当前目录
cp ~/.openclaw/openclaw.json ./openclaw-backup.json
cp ~/.openclaw/.env ./env-backup.txt 2>/dev/null || true

# 或创建备份目录
mkdir -p ~/openclaw-backup
cp -r ~/.openclaw/* ~/openclaw-backup/
```

### Q: 配置文件格式错误怎么办？

**A:**
```bash
# 1. 使用 openclaw doctor 诊断
openclaw doctor

# 2. 使用 JSON 验证工具
cat ~/.openclaw/openclaw.json | python3 -m json.tool

# 3. 如果无法修复，备份并重新初始化
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.broken
openclaw onboard --install-daemon
```

---

**详细使用说明**: [查看模板使用指南](templates/README.md) | [API配置教程](docs/api-config/api-configuration.md)
## 🤝 贡献指南

欢迎提交 Issue 和 Pull Request 帮助完善教程！

## 📄 许可证

本项目采用 MIT 许可证。

## 👨‍💻 作者信息

**作者**: [junhang lai](https://github.com/Mr-tooth)

- GitHub: [Mr. Tooth](https://github.com/Mr-tooth)
- 教程仓库: [OpenClaw-Guide-for-Beginners](https://github.com/Mr-tooth/OpenClaw-Guide-for-Beginners)
- 作者信息: [查看 AUTHORS.md](AUTHORS.md)
<!-- - 分发策略: [查看分发方案](DISTRIBUTION-STRATEGY.md) -->

---

**⭐ 创作不易，如果这个教程对你有帮助，请给个 Star 支持一下！**

---

*本教程包含推荐链接，通过链接注册可享受额外优惠，同时也支持作者持续产出优质内容。*

*作者: junhang lai | 最后更新: 2026-02-22*

<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->
