# 更新日志

本项目的所有重要变更都会记录在此文件中，格式遵循 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)，版本号遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

## [1.1.0] - 2026-04-16
### 🌟 新增功能
- ✅ 新增工程规范体系：贡献指南、发布流程、更新日志、完整工作流规范
- ✅ 新增版本自动跟踪系统：自动检测OpenClaw官方版本更新，自动创建PR
- ✅ 新增版本变更记录目录，记录OpenClaw各版本的重要变更
- ✅ 新增安全运行重要提示文档，重点提示WSL安装的安全优势
- ✅ 新增版本选择说明文档，帮助用户选择适合的版本
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
### 🛠️ 工程化
- ✅ 配置每周自动检测OpenClaw版本更新的Cron任务
- ✅ 完善提交规范、PR规范、版本发布规范
- ✅ 新增版本兼容性说明
---
## [1.0.0] - 2026-04-09

## [1.1.0] - 2026-04-16
### 新增
- Windows安装指南新增飞书官方一键安装脚本支持
- WSL安装教程新增飞书一键安装步骤与API配置引导
### 优化
- 优化README快速开始部分，突出WSL是Windows新手首选安装方式，推荐指数提升为5星
- 调整平台列表顺序，WSL放到Windows前面，新增适用人群说明
---
## [1.0.0] - 2026-04-09
### 新增
- 初始版本发布，包含完整的多平台安装教程
- 支持平台：Windows、WSL、macOS、Linux、Docker、云服务器、Android
- 包含API配置教程、多平台对接教程、成本优化指南
### 优化
- 仓库URL迁移到bitroboticslab组织，更新所有相关链接
- Node.js版本推荐从22更新到24
- CLI命令更新：`openclaw start/stop/restart` → `openclaw gateway start/stop/restart`
- 版本引用从2026.2.x更新到2026.3.x
- 平台列表新增Discord、WhatsApp、Signal、QQ、LINE、Matrix、Teams支持
- 安装方式更新：官方`curl -fsSL https://openclaw.ai/install.sh | bash`作为QUICKSTART首选
- 定位描述更新："AI助手框架" → "自托管AI Agent网关"
- 删除过时的硅基流动限时活动内容
- README/QUICKSTART补充多媒体生成、ACP、Cron、记忆系统等特性
### 修复
- 修正所有失效链接与过时命令
---
[Unreleased]: https://github.com/bitroboticslab/OpenClaw-Guide-for-Beginners/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/bitroboticslab/OpenClaw-Guide-for-Beginners/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/bitroboticslab/OpenClaw-Guide-for-Beginners/releases/tag/v1.0.0
[1.1.0]: https://github.com/bitroboticslab/OpenClaw-Guide-for-Beginners/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/bitroboticslab/OpenClaw-Guide-for-Beginners/releases/tag/v1.0.0