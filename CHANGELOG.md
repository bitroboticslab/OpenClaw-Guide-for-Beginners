# 更新日志

本项目的所有重要变更都会记录在此文件中，格式遵循 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)，版本号遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

## [Unreleased]

### 待开发

- 无

## [2.1.1] - 2026-06-27

### 🐛 修复

- ✅ 补充v1.9.0~v2.1.0缺失的14个功能文档
- ✅ 修复CHANGELOG中声称新增但实际未创建的文档问题

### 📝 补充文档清单

**v1.9.0补充 (4个)**:

- docs/advanced/skill-workshop.md
- docs/configuration/sqlite-queue.md
- docs/configuration/minimax-m3.md
- docs/advanced/external-plugins.md

**v2.0.0补充 (5个)**:

- docs/integration/telegram-rich-text.md
- docs/configuration/usage-footer.md
- docs/configuration/provider-routing.md
- docs/advanced/btw-command.md
- docs/advanced/model-command.md

**v2.1.0补充 (5个)**:

- docs/integration/telegram-delivery.md
- docs/advanced/codex-plugins.md
- docs/advanced/channel-recovery.md
- docs/configuration/provider-plugins.md
- docs/advanced/exec-enhanced.md

## [2.1.0] - 2026-06-27

### 🌟 新增功能

- ✅ 对齐OpenClaw最新稳定版本v2026.6.9
- ✅ 新增《v2026.6.9版本变更说明》独立文档
- ✅ 新增Telegram富文本投递配置说明
- ✅ 新增Codex原生插件使用指南
- ✅ 新增通道恢复机制说明
- ✅ 新增独立Provider插件配置
- ✅ 新增exec功能增强说明

### 🛠️ 优化

- ✅ 全文档默认版本统一更新为v2026.6.9
- ✅ 更新README版本徽章和更新时间

## [2.0.0] - 2026-06-27

### 🌟 新增功能

- ✅ 对齐OpenClaw最新稳定版本v2026.6.8（重大版本升级）
- ✅ 新增《v2026.6.7~6.8版本变更说明》独立文档
- ✅ 新增GLM-5.2和Claude Haiku 4.5模型配置
- ✅ 新增Telegram富文本渲染配置说明
- ✅ 新增用量页脚功能配置
- ✅ 新增Provider路由优化说明
- ✅ 新增/btw和/model命令增强说明

### 🛠️ 优化

- ✅ 全文档默认版本统一更新为v2026.6.8
- ✅ 更新README版本徽章和更新时间
- ✅ 更新模型对比文档，新增GLM-5.2和Claude Haiku 4.5

### 🎯 重大升级

- ✅ 教程版本从v1.x升级到v2.x
- ✅ 通道能力大幅提升（Telegram富文本）
- ✅ 模型支持范围扩大（GLM-5.2、Claude Haiku 4.5）

## [1.10.0] - 2026-06-27

### 🌟 新增功能

- ✅ 对齐OpenClaw最新稳定版本v2026.6.6
- ✅ 新增《v2026.6.2~6.6版本变更说明》独立文档
- ✅ 新增Exec审批机制配置说明
- ✅ 新增SSRF防护配置指南
- ✅ 新增Auth边界强化说明
- ✅ 新增运行时上下文保护配置
- ✅ 新增 compact 命令使用说明

### 🛠️ 优化

- ✅ 全文档默认版本统一更新为v2026.6.6
- ✅ 更新README版本徽章和更新时间
- ✅ 更新安全配置文档，新增Exec审批和SSRF防护章节

### 🔒 安全增强

- ✅ 新增Exec审批机制详细配置指南
- ✅ 新增SSRF防护白名单配置建议
- ✅ 新增Auth边界强化配置说明
- ✅ 新增安全检查清单

## [1.9.0] - 2026-06-27

### 🌟 新增功能

- ✅ 对齐OpenClaw最新稳定版本v2026.6.1
- ✅ 新增《v2026.5.19~6.1版本变更说明》独立文档
- ✅ 新增Skill Workshop技能工作坊使用指南
- ✅ 新增SQLite队列系统配置说明
- ✅ 新增MiniMax M3模型配置指南
- ✅ 新增外部化插件安装说明（Tokenjuice、Copilot）

### 🛠️ 优化

- ✅ 全文档默认版本统一更新为v2026.6.1
- ✅ 更新README版本徽章和更新时间
- ✅ 优化升级指南，补充多种部署方式

### 📖 文档更新

- ✅ 更新AGENT.md，新增渐进式版本对齐策略
- ✅ 更新质量保障体系文档
- ✅ 更新应急响应预案文档

### 🤖 基础设施

- ✅ 新增CI持续集成测试workflow（链接验证、格式检查、命令语法验证）
- ✅ 增强Release workflow（发布前验证、自动Release说明生成）
- ✅ 新增版本监控脚本和定时任务
- ✅ 新增质量保障测试脚本

## [1.8.1] - 2026-05-25

### 🛠️ 补充更新

- ✅ 补充 Per-sender 工具策略配置说明（v2026.5.12+）
- ✅ 补充 /context map 上下文可视化命令说明
- ✅ 补充 Slack 增强配置（unfurlLinks/unfurlMedia/replyBroadcast）
- ✅ 补充 Discord 语音频道限制配置（voice.allowedChannels）
- ✅ 补充 /readyz 健康检查端点说明（v2026.5.18+）

### 📖 文档更新

- ✅ 更新安全文档，新增按发送者限制工具权限章节
- ✅ 更新故障排查文档，新增 /context map 命令
- ✅ 更新平台对接概览，新增 Slack 和 Discord 配置说明
- ✅ 更新云服务器部署文档，新增健康检查与监控章节

## [1.8.0] - 2026-05-25

### 🌟 新增功能

- ✅ 对齐OpenClaw最新稳定版本v2026.5.18
- ✅ 新增《v2026.5.8~5.12版本变更说明》独立文档
- ✅ 新增《v2026.5.13~5.18版本变更说明》独立文档
- ✅ 新增Plugin SDK插件开发工具包使用指南
- ✅ 新增Skills全局安装和更新功能说明
- ✅ 新增/stop和/btw交互命令使用说明
- ✅ 新增QA测试工具和Obsidian集成说明

### 🛠️ 优化

- ✅ 更新README核心特性列表，新增任务控制和Plugin SDK特性
- ✅ 更新版本徽章和更新时间

### 📖 文档更新

- ✅ 更新AGENT.md对齐版本号
- ✅ 更新迁移指南版本引用
- ✅ 更新技能开发文档，补充新功能章节

## [1.7.1] - 2026-05-19

### 🌟 新增功能

- ✅ 对齐OpenClaw最新稳定版本v2026.5.7
- ✅ 新增《v2026.5.4~v5.7版本变更说明》独立文档
- ✅ 新增内置文件传输插件使用指南，支持file_fetch/dir_list/dir_fetch/file_write命令
- ✅ 新增飞书话题线程配置说明，修复v5.4及之前版本回复错位问题

### 🛠️ 优化

- ✅ 全文档默认版本统一更新为v2026.5.7
- ✅ 飞书常见问题新增回复错位/不在对应话题的排查解决方案

### 🐛 修复

- ✅ 补充v2026.5.5飞书话题线程ID路由错误修复的相关说明
- ✅ 更新参考链接到最新官方版本文档

## [1.7.0] - 2026-05-05

### 🌟 新增功能

- ✅ 升级所有安装脚本适配OpenClaw v2026.4.x最新版本
- ✅ 新增ClawDock官方Docker镜像部署完整体系
- ✅ 新增独立的《ClawDock官方部署指南》，覆盖一键部署、手动部署、Docker Compose生产部署全场景
- ✅ macOS安装脚本新增Homebrew官方安装路径可选支持，更符合苹果用户使用习惯

### 🛠️ 优化

- ✅ 所有脚本Node.js运行环境统一升级到24 LTS，性能更优，符合官方最低要求
- ✅ 统一命令规范：所有`openclaw start/stop/restart`旧命令100%替换为`openclaw gateway`系列，与官方文档完全对齐
- ✅ 所有安装脚本新增版本校验功能，安装完成后自动显示当前OpenClaw版本号
- ✅ Docker脚本优化挂载路径，完全对齐官方ClawDock镜像目录结构
- ✅ 云部署文档优先推荐ClawDock作为首选部署方案，传统手动部署降级为备选方案
- ✅ 所有配套文档同步更新，引导更清晰，新手友好度提升

### 🐛 修复

- ✅ 修复Docker脚本中DEFAULT_MODEL变量未正确展开的问题
- ✅ 修复Docker脚本中路径未加引号导致含空格路径执行失败的问题
- ✅ 统一所有脚本中的占位符表述，`YOUR_SERVER_IP`统一调整为`你的服务器IP`，更符合中文用户阅读习惯

## [1.6.0] - 2026-05-02

### 🌟 新增功能

- ✅ 版本更新到 OpenClaw v2026.4.29 (最终版本)
- ✅ 新增 NVIDIA 提供商配置指南
- ✅ 新增记忆系统配置指南
- ✅ 新增 v2026.4.29 版本变更记录

### 📖 内容优化

- ✅ 更新安全配置文档，新增 OpenGrep 扫描和工具配置安全
- ✅ 更新 README 版本号和徽章
- ✅ 更新所有文档最后更新时间
- ✅ 更新 CHANGELOG 记录 v1.6.0

## [1.5.0] - 2026-05-01

### 🌟 新增功能

- ✅ 版本更新到 OpenClaw v2026.4.27
- ✅ 新增 DeepInfra 提供商配置指南
- ✅ 新增腾讯元宝集成文档
- ✅ 新增 QQBot 集成文档
- ✅ 新增 v2026.4.27 版本变更记录

### 📖 内容优化

- ✅ 更新 README 版本号和徽章
- ✅ 更新目录结构，新增版本变更记录
- ✅ 更新 CHANGELOG 记录 v1.5.0

## [1.4.0] - 2026-05-01

### 🌟 新增功能

- ✅ 版本更新到 OpenClaw v2026.4.26
- ✅ 新增 Control UI 配置完整指南
- ✅ 新增迁移指南文档
- ✅ 新增 v2026.4.26 版本变更记录

### 📖 内容优化

- ✅ 更新 README 版本号和徽章
- ✅ 更新目录结构，新增版本变更记录
- ✅ 更新 CHANGELOG 记录 v1.4.0

## [1.3.0] - 2026-05-01

### 🌟 新增功能

- ✅ 版本更新到 OpenClaw v2026.4.25
- ✅ 新增 TTS 语音配置完整指南
- ✅ 新增 TTS 技能开发和使用文档
- ✅ 新增 v2026.4.25 版本变更记录

### 📖 内容优化

- ✅ 更新 API 配置教程，新增 TTS 配置章节
- ✅ 更新技能开发文档，新增 TTS 语音技能
- ✅ 更新所有版本号和徽章

## [1.2.0] - 2026-05-01

### 🌟 新增功能

- ✅ 新增小米 MiMo 开放平台推荐，提供邀请码注册奖励
- ✅ 更新火山引擎 Coding Plan 信息：4月22日起新增支持 GLM 5.1、Minimax M2.7、Kimi K2.6 模型

### 📖 内容优化

- ✅ 优化大模型平台推荐表格，新增小米 MiMo 平台条目
- ✅ 补充火山引擎最新模型支持动态
- ✅ 更新文档最后更新时间

## [1.1.0] - 2026-04-16

### 🌟 新增功能

- ✅ 新增工程规范体系：贡献指南、发布流程、更新日志、完整工作流规范
- ✅ 新增版本自动跟踪系统：自动检测OpenClaw官方版本更新，自动创建PR
- ✅ 新增版本变更记录目录，记录OpenClaw各版本的重要变更
- ✅ 新增安全运行重要提示文档，重点提示WSL安装的安全优势
- ✅ 新增版本选择说明文档，帮助用户选择适合的版本
- ✅ Windows安装指南新增飞书官方一键安装脚本支持
- ✅ WSL安装教程新增飞书一键安装步骤与API配置引导

### 🔒 安全优化

- ✅ 所有Windows相关页面突出WSL为新手首选安装方式，避免本地安装误操作风险
- ✅ 新增沙箱安全特性说明，提示用户启用沙箱模式限制文件系统访问
- ✅ 强化安全最佳实践，提醒用户遵循最小权限原则

### 📖 内容优化

- ✅ 所有教程对齐OpenClaw最新稳定版v2026.4.14
- ✅ Node.js版本要求统一升级到24，符合官方最低要求
- ✅ 所有平台教程新增飞书官方一键安装支持，5分钟完成对接
- ✅ 优化目录结构，重新组织为快速开始、安装教程、配置指南、平台对接等分类
- ✅ 修复所有失效链接，统一路径规范
- ✅ 优化表述，提升新手友好度
- ✅ 优化README快速开始部分，突出WSL是Windows新手首选安装方式，推荐指数提升为5星
- ✅ 调整平台列表顺序，WSL放到Windows前面，新增适用人群说明

### 🛠️ 工程化

- ✅ 配置每周自动检测OpenClaw版本更新的Cron任务
- ✅ 完善提交规范、PR规范、版本发布规范
- ✅ 新增版本兼容性说明

## [1.0.0] - 2026-04-09

### 🌟 新增功能

- 初始版本发布，包含完整的多平台安装教程
- 支持平台：Windows、WSL、macOS、Linux、Docker、云服务器、Android
- 包含API配置教程、多平台对接教程、成本优化指南

### 🛠️ 优化

- 仓库URL迁移到bitroboticslab组织，更新所有相关链接
- Node.js版本推荐从22更新到24
- CLI命令更新：`openclaw start/stop/restart` → `openclaw gateway start/stop/restart`
- 版本引用从2026.2.x更新到2026.3.x
- 平台列表新增Discord、WhatsApp、Signal、QQ、LINE、Matrix、Teams支持
- 安装方式更新：官方`curl -fsSL https://openclaw.ai/install.sh | bash`作为QUICKSTART首选
- 定位描述更新："AI助手框架" → "自托管AI Agent网关"
- 删除过时的硅基流动限时活动内容
- README/QUICKSTART补充多媒体生成、ACP、Cron、记忆系统等特性

### 🐛 修复

- 修正所有失效链接与过时命令

---

## 版本对比链接

[Unreleased]: https://github.com/bitroboticslab/OpenClaw-Guide-for-Beginners/compare/v2.1.1...HEAD
[2.1.1]: https://github.com/bitroboticslab/OpenClaw-Guide-for-Beginners/compare/v2.1.0...v2.1.1
[2.1.0]: https://github.com/bitroboticslab/OpenClaw-Guide-for-Beginners/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/bitroboticslab/OpenClaw-Guide-for-Beginners/compare/v1.10.0...v2.0.0
[1.10.0]: https://github.com/bitroboticslab/OpenClaw-Guide-for-Beginners/compare/v1.9.0...v1.10.0
[1.9.0]: https://github.com/bitroboticslab/OpenClaw-Guide-for-Beginners/compare/v1.8.1...v1.9.0
[1.8.1]: https://github.com/bitroboticslab/OpenClaw-Guide-for-Beginners/compare/v1.8.0...v1.8.1
[1.8.0]: https://github.com/bitroboticslab/OpenClaw-Guide-for-Beginners/compare/v1.7.1...v1.8.0
[1.7.1]: https://github.com/bitroboticslab/OpenClaw-Guide-for-Beginners/compare/v1.7.0...v1.7.1
[1.7.0]: https://github.com/bitroboticslab/OpenClaw-Guide-for-Beginners/compare/v1.6.0...v1.7.0
[1.6.0]: https://github.com/bitroboticslab/OpenClaw-Guide-for-Beginners/compare/v1.5.0...v1.6.0
[1.5.0]: https://github.com/bitroboticslab/OpenClaw-Guide-for-Beginners/compare/v1.4.0...v1.5.0
[1.4.0]: https://github.com/bitroboticslab/OpenClaw-Guide-for-Beginners/compare/v1.3.0...v1.4.0
[1.3.0]: https://github.com/bitroboticslab/OpenClaw-Guide-for-Beginners/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/bitroboticslab/OpenClaw-Guide-for-Beginners/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/bitroboticslab/OpenClaw-Guide-for-Beginners/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/bitroboticslab/OpenClaw-Guide-for-Beginners/releases/tag/v1.0.0
