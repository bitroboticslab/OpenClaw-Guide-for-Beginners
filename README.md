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
| ![WSL](https://img.shields.io/badge/WSL-新-green) | ⭐⭐ | ⭐⭐⭐⭐ | [WSL 安装教程](docs/wsl/wsl-setup.md) |
| macOS | ⭐⭐ | ⭐⭐⭐⭐⭐ | [macOS 安装指南](docs/macos/macos-install-guide.md) |
| Linux | ⭐ | ⭐⭐⭐⭐⭐ | [Linux 安装指南](docs/linux/linux-install-guide.md) |
| ![Docker](https://img.shields.io/badge/Docker-新-green) | ⭐⭐⭐ | ⭐⭐⭐⭐ | [Docker 部署教程](docs/docker/docker-deployment.md) |
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
</details>

<details>
<summary><b>Q: 云服务器配置要求是什么？</b></summary>

最低配置：
- CPU: 1核
- 内存: 1GB
- 存储: 20GB
- 系统: Ubuntu 20.04+ / CentOS 7+

推荐配置：
- CPU: 2核
- 内存: 2GB
- 存储: 40GB
- 系统: Ubuntu 22.04

阿里云 79元/年的轻量应用服务器完全满足需求。
</details>

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
