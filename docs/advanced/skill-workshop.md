# Skill Workshop 技能工作坊使用指南

**创建时间**: 2026-06-27
**适用版本**: OpenClaw v1.9.0+

## 📖 概述

Skill Workshop（技能工作坊）是 OpenClaw v1.9.0 新增的一站式技能管理界面，提供可视化的技能浏览、安装、配置和开发体验。相比命令行方式，Workshop 提供更直观的操作界面和更丰富的信息展示。

## 🎯 核心功能

| 功能 | 说明 |
|------|------|
| 🔍 浏览 | 浏览 ClawHub 技能市场，按分类、标签筛选 |
| 📥 安装 | 一键安装技能，自动处理依赖 |
| 🗑️ 卸载 | 安全卸载技能，支持清理残留文件 |
| ⚙️ 配置 | 可视化编辑技能配置，实时预览效果 |
| 🔄 更新 | 批量检查更新，一键升级技能 |
| 🛠️ 开发 | 内置技能开发向导，快速创建自定义技能 |

## 🚀 启动方式

### 方式一：命令行启动

```bash
# 启动 Skill Workshop
openclaw skills workshop

# 指定端口启动
openclaw skills workshop --port 8080

# 指定主机和端口
openclaw skills workshop --host 0.0.0.0 --port 8080

# 仅本地访问
openclaw skills workshop --host 127.0.0.1
```

### 方式二：Web 界面访问

启动后在浏览器中访问：

```
http://localhost:3000/workshop
```

### 方式三：通过 openclaw 命令

```bash
# 打开 Workshop 并跳转到技能详情
openclaw skills workshop --skill weather

# 打开 Workshop 的开发模式
openclaw skills workshop --mode dev
```

## 📦 浏览技能

### 分类浏览

Workshop 提供按分类浏览技能的功能：

| 分类 | 说明 | 示例技能 |
|------|------|---------|
| 🌤️ 天气 | 天气查询与预报 | weather, forecast |
| 🔒 安全 | 安全检查与审计 | healthcheck, security |
| 💬 通讯 | 消息平台集成 | feishu, telegram, dingtalk |
| 📊 数据 | 数据分析与可视化 | data-analysis, chart |
| 🤖 AI | AI 模型增强 | model-enhance, agent |
| 🎤 语音 | TTS 与语音功能 | tts-broadcast, voice-assistant |
| 📝 文档 | 文档处理与生成 | markdown, pdf-reader |

### 搜索技能

```bash
# CLI 搜索
openclaw skills search weather

# 在 Workshop 中搜索
# 打开 Workshop 后使用顶部搜索栏
openclaw skills workshop
```

## 📥 安装技能

### 通过 Workshop 安装

1. 打开 Skill Workshop
2. 浏览或搜索目标技能
3. 点击技能卡片进入详情页
4. 点击「安装」按钮
5. 确认安装依赖和权限

### 通过命令行安装

```bash
# 安装单个技能
openclaw skills install weather

# 安装指定版本
openclaw skills install weather@1.2.0

# 批量安装
openclaw skills install weather healthcheck feishu
```

## ⚙️ 配置技能

### Workshop 可视化配置

1. 打开 Workshop，进入「已安装」标签
2. 选择目标技能
3. 点击「配置」按钮
4. 在可视化编辑器中修改配置
5. 点击「保存并应用」

### 命令行配置

```bash
# 查看技能配置
openclaw skills config weather

# 设置技能配置项
openclaw skills config set weather.apiKey "your-api-key"

# 重置技能配置
openclaw skills config reset weather
```

### 配置文件示例

技能配置存储在 `~/.openclaw/skills/<skill-name>/config.json` 中：

```json
{
  "weather": {
    "apiKey": "your-weather-api-key",
    "units": "metric",
    "language": "zh-CN",
    "cache": {
      "enabled": true,
      "ttl": 1800
    }
  }
}
```

## 🔄 更新技能

### Workshop 批量更新

1. 打开 Workshop，进入「更新」标签
2. 查看可更新的技能列表
3. 选择需要更新的技能
4. 点击「更新选中」或「全部更新」

### 命令行更新

```bash
# 检查可更新技能
openclaw skills outdated

# 更新所有技能
openclaw skills update

# 更新指定技能
openclaw skills update weather

# 更新到指定版本
openclaw skills update weather@1.3.0
```

## 🗑️ 卸载技能

```bash
# 卸载技能
openclaw skills uninstall weather

# 强制卸载（删除所有文件和配置）
openclaw skills uninstall weather --force

# 卸载并清理依赖
openclaw skills uninstall weather --clean-deps
```

## 🛠️ 开发自定义技能

### 使用开发向导

```bash
# 启动技能开发向导
openclaw skills create

# 指定技能名称
openclaw skills create --name my-skill

# 使用模板创建
openclaw skills create --template basic
```

### 开发模式

```bash
# 启动 Workshop 的开发模式
openclaw skills workshop --mode dev

# 监听文件变化并自动重载
openclaw skills dev --watch

# 测试技能
openclaw skills test my-skill

# 打包技能
openclaw skills pack my-skill
```

### 技能结构

```
my-skill/
├── SKILL.md              # 技能文档（必需）
├── _meta.json            # 元数据
├── config.json           # 默认配置
├── assets/               # 资源文件
│   └── LEARNINGS.md
├── scripts/              # 脚本文件
│   ├── activator.sh
│   └── hook.sh
└── references/           # 参考文档
    └── examples.md
```

### SKILL.md 示例

```markdown
---
name: My Custom Skill
description: 我的自定义技能
read_when:
  - 用户请求自定义功能
metadata: {
  "emoji": "🔧",
  "version": "1.0.0",
  "author": "your-name"
}
allowed-tools: Bash,Read,Write
---

# My Custom Skill

## 功能说明

本技能提供...

## 使用方法

### 基础用法

...
```

## 🔧 配置参考

### Workshop 全局配置

在 `~/.openclaw/openclaw.json` 中配置 Workshop：

```json
{
  "workshop": {
    "enabled": true,
    "host": "127.0.0.1",
    "port": 3000,
    "autoUpdate": false,
    "devMode": false,
    "theme": "auto"
  }
}
```

### 配置项说明

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `enabled` | boolean | `true` | 是否启用 Workshop |
| `host` | string | `127.0.0.1` | 监听地址 |
| `port` | number | `3000` | 监听端口 |
| `autoUpdate` | boolean | `false` | 是否自动更新技能 |
| `devMode` | boolean | `false` | 是否启用开发模式 |
| `theme` | string | `auto` | 界面主题（auto/light/dark） |

## ⚠️ 注意事项

1. **端口冲突**: 如果默认端口 3000 被占用，使用 `--port` 指定其他端口
2. **网络要求**: 浏览和安装技能需要网络连接到 ClawHub
3. **权限问题**: 某些技能安装需要管理员权限
4. **开发模式**: 开发模式仅用于技能开发调试，生产环境请关闭
5. **版本兼容**: 部分技能可能有最低版本要求，安装前请确认兼容性

## 📚 相关链接

- [技能开发与使用](./skills.md)
- [插件使用指南](./plugins.md)
- [ClawHub 技能市场](https://clawhub.com)
- [OpenClaw 官方文档](https://docs.openclaw.ai)

---

**最后更新**: 2026-06-27
**维护者**: OpenClaw Team
