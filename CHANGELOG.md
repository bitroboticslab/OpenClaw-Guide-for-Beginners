# 更新日志

本项目的所有重要变更都会记录在此文件中，格式遵循 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)，版本号遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

## [Unreleased]
### 新增
- 新增工程规范文档：CONTRIBUTING.md、RELEASING.md、CHANGELOG.md
- 新增OpenClaw版本自动跟踪脚本与cron任务配置
### 优化
- 全文档内容对齐OpenClaw 2026.4.16最新版本

---

## [1.1.0] - 2026-04-16
### 新增
- Windows安装指南新增飞书官方一键安装脚本支持
- WSL安装教程新增飞书一键安装步骤与API配置引导
### 优化
- 优化README快速开始部分，突出WSL是Windows新手首选安装方式，推荐指数提升为5星
- 调整平台列表顺序，WSL放到Windows前面，新增适用人群说明
- Windows安装指南开头增加WSL推荐提示与跳转链接，引导新手优先使用WSL安装
- Windows安装指南飞书配置部分将手动配置折叠，默认展示官方一键安装方案
- 修正WSL安装教程中的"安OpenOpenClaw"错别字
- 所有飞书相关内容链接到官方最新教程，保证内容及时性
### 安全
- 明确引导用户使用WSL安装，避免Windows本地安装可能带来的误操作安全风险

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
- README/QUICKSTART补充多媒体生成、ACP、Cron、记忆系统等特性说明
### 修复
- 修正所有失效链接与过时命令

---

[Unreleased]: https://github.com/bitroboticslab/OpenClaw-Guide-for-Beginners/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/bitroboticslab/OpenClaw-Guide-for-Beginners/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/bitroboticslab/OpenClaw-Guide-for-Beginners/releases/tag/v1.0.0