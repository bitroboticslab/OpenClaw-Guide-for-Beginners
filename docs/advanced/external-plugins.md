# 外部化插件安装说明

**创建时间**: 2026-06-27
**适用版本**: OpenClaw v1.9.0+

## 📖 概述

外部化插件是 OpenClaw v1.9.0 引入的插件分发机制，允许通过独立的插件包安装和管理扩展功能。与内置插件不同，外部化插件可以独立更新，支持更灵活的版本管理和依赖控制。

## 🎯 支持的外部插件

| 插件 | 说明 | 状态 |
|------|------|------|
| 🧃 Tokenjuice | Token 管理与优化插件 | ✅ 可用 |
| 🤖 Copilot | AI 辅助编程插件 | ✅ 可用 |

---

## 🧃 Tokenjuice 插件

### 功能说明

Tokenjuice 是一个 Token 管理与优化插件，提供以下功能：

- 📊 Token 使用量实时监控
- 💰 成本估算与预算管理
- 🔄 Token 缓存与复用
- 📈 使用量分析与报表
- ⚠️ 预算告警与限制

### 安装方法

#### 方式一：命令行安装

```bash
# 安装 Tokenjuice 插件
openclaw plugins install tokenjuice

# 安装指定版本
openclaw plugins install tokenjuice@1.2.0

# 从 GitHub 安装
openclaw plugins install github:openclaw/tokenjuice
```

#### 方式二：通过 Workshop 安装

1. 打开 Skill Workshop：`openclaw skills workshop`
2. 搜索「Tokenjuice」
3. 点击「安装」按钮

### 配置说明

在 `~/.openclaw/openclaw.json` 中添加配置：

```json
{
  "plugins": {
    "tokenjuice": {
      "enabled": true,
      "monitoring": {
        "enabled": true,
        "interval": 60,
        "retention": "30d"
      },
      "budget": {
        "daily": 10.00,
        "monthly": 200.00,
        "currency": "USD",
        "alertThreshold": 0.8
      },
      "cache": {
        "enabled": true,
        "maxSize": "1GB",
        "ttl": 3600
      },
      "notifications": {
        "enabled": true,
        "channels": ["email", "webhook"],
        "webhookUrl": "https://your-webhook-url.com/notify"
      }
    }
  }
}
```

### 配置项说明

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `enabled` | boolean | `true` | 是否启用插件 |
| `monitoring.enabled` | boolean | `true` | 是否启用监控 |
| `monitoring.interval` | number | `60` | 监控数据采集间隔（秒） |
| `monitoring.retention` | string | `"30d"` | 监控数据保留时间 |
| `budget.daily` | number | `10.00` | 每日预算（美元） |
| `budget.monthly` | number | `200.00` | 每月预算（美元） |
| `budget.alertThreshold` | number | `0.8` | 预算告警阈值（80%） |
| `cache.enabled` | boolean | `true` | 是否启用 Token 缓存 |
| `cache.maxSize` | string | `"1GB"` | 缓存最大大小 |
| `cache.ttl` | number | `3600` | 缓存过期时间（秒） |

### 使用示例

```bash
# 查看 Token 使用统计
openclaw tokenjuice stats

# 查看今日使用量
openclaw tokenjuice stats --today

# 查看月度使用量
openclaw tokenjuice stats --month

# 查看预算状态
openclaw tokenjuice budget

# 设置每日预算
openclaw tokenjuice budget set --daily 15.00

# 清除缓存
openclaw tokenjuice cache clear

# 导出使用报告
openclaw tokenjuice report --output report.csv
```

### 使用示例（对话场景）

```
你: 查看今天的 Token 使用情况
AI: 今日 Token 使用统计：
    - 输入 Token: 12,450
    - 输出 Token: 8,320
    - 总计: 20,770
    - 预估费用: $0.42
    - 预算剩余: $9.58 (95.8%)

你: 设置每月预算为 300 美元
AI: ✅ 已将月度预算设置为 $300.00
```

---

## 🤖 Copilot 插件

### 功能说明

Copilot 是一个 AI 辅助编程插件，提供以下功能：

- 💻 代码自动补全
- 🔍 代码分析与审查
- 🐛 Bug 检测与修复建议
- 📝 代码注释生成
- 🔄 代码重构建议
- 📚 文档生成

### 安装方法

#### 方式一：命令行安装

```bash
# 安装 Copilot 插件
openclaw plugins install copilot

# 安装指定版本
openclaw plugins install copilot@2.0.0

# 从 GitHub 安装
openclaw plugins install github:openclaw/copilot
```

#### 方式二：通过 Workshop 安装

1. 打开 Skill Workshop：`openclaw skills workshop`
2. 搜索「Copilot」
3. 点击「安装」按钮

### 配置说明

在 `~/.openclaw/openclaw.json` 中添加配置：

```json
{
  "plugins": {
    "copilot": {
      "enabled": true,
      "features": {
        "completion": true,
        "analysis": true,
        "bugDetection": true,
        "refactoring": true,
        "documentation": true
      },
      "languages": [
        "python",
        "javascript",
        "typescript",
        "go",
        "rust",
        "java"
      ],
      "model": "minimax/minimax-m3",
      "trigger": {
        "autoComplete": true,
        "autoCompleteDelay": 500,
        "manualOnly": false
      },
      "exclude": {
        "patterns": ["*.min.js", "*.bundle.js", "node_modules/**"],
        "files": [".env", "*.key", "*.pem"]
      }
    }
  }
}
```

### 配置项说明

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `enabled` | boolean | `true` | 是否启用插件 |
| `features.completion` | boolean | `true` | 启用代码补全 |
| `features.analysis` | boolean | `true` | 启用代码分析 |
| `features.bugDetection` | boolean | `true` | 启用 Bug 检测 |
| `features.refactoring` | boolean | `true` | 启用重构建议 |
| `features.documentation` | boolean | `true` | 启用文档生成 |
| `languages` | array | 见配置 | 支持的编程语言 |
| `model` | string | - | 使用的 AI 模型 |
| `trigger.autoComplete` | boolean | `true` | 是否自动触发补全 |
| `trigger.autoCompleteDelay` | number | `500` | 自动补全延迟（毫秒） |
| `exclude.patterns` | array | `[]` | 排除的文件模式 |

### 使用示例

```bash
# 启动 Copilot 模式
openclaw copilot start

# 分析当前项目
openclaw copilot analyze

# 审查代码文件
openclaw copilot review src/main.py

# 生成代码注释
openclaw copilot docgen src/utils.py

# 检测 Bug
openclaw copilot bugs src/

# 代码重构建议
openclaw copilot refactor src/main.py

# 停止 Copilot
openclaw copilot stop
```

### 使用示例（对话场景）

```
你: 帮我分析这段代码的问题
AI: 我发现了以下问题：
    1. ⚠️ 第 15 行：潜在的空指针异常
    2. ⚠️ 第 23 行：未使用的变量
    3. 🔴 第 31 行：SQL 注入风险
    建议修复方案：...

你: 帮这个函数添加注释
AI: ✅ 已生成注释：
    """
    计算两个日期之间的工作日天数
    
    Args:
        start_date: 开始日期
        end_date: 结束日期
    
    Returns:
        int: 工作日天数
    """
```

---

## 🔧 通用管理命令

### 插件管理

```bash
# 列出已安装插件
openclaw plugins list

# 查看插件详情
openclaw plugins info tokenjuice

# 更新插件
openclaw plugins update tokenjuice

# 更新所有插件
openclaw plugins update --all

# 卸载插件
openclaw plugins uninstall tokenjuice

# 禁用插件
openclaw plugins disable tokenjuice

# 启用插件
openclaw plugins enable tokenjuice
```

### 插件配置

```bash
# 查看插件配置
openclaw plugins config tokenjuice

# 设置插件配置项
openclaw plugins config set tokenjuice.budget.daily 20.00

# 重置插件配置
openclaw plugins config reset tokenjuice
```

### 插件诊断

```bash
# 检查插件状态
openclaw plugins status

# 运行插件诊断
openclaw plugins diagnose tokenjuice

# 查看插件日志
openclaw logs plugin tokenjuice
```

## ⚠️ 注意事项

1. **版本兼容**: 安装外部插件前请确认与当前 OpenClaw 版本兼容
2. **依赖冲突**: 部分插件可能有依赖冲突，安装时会自动检测并提示
3. **安全风险**: 仅从官方渠道安装插件，避免安装未知来源的插件
4. **资源占用**: 外部插件会占用额外的系统资源，请根据实际情况配置
5. **自动更新**: 建议定期更新插件以获取最新功能和安全修复
6. **配置备份**: 卸载插件前建议备份插件配置

## 🔍 故障排除

### 插件安装失败

```bash
# 检查网络连接
openclaw network test

# 清除插件缓存
openclaw plugins cache clear

# 重新安装
openclaw plugins install tokenjuice --force
```

### 插件不工作

```bash
# 检查插件状态
openclaw plugins status

# 检查插件配置
openclaw plugins config tokenjuice

# 查看插件日志
openclaw logs plugin tokenjuice

# 重启插件
openclaw plugins restart tokenjuice
```

### 插件冲突

```bash
# 检查插件依赖
openclaw plugins deps

# 检查插件冲突
openclaw plugins conflicts

# 卸载冲突插件
openclaw plugins uninstall <conflicting-plugin>
```

## 📚 相关链接

- [插件使用指南](./plugins.md)
- [技能开发与使用](./skills.md)
- [Skill Workshop 使用指南](./skill-workshop.md)
- [ClawHub 插件市场](https://clawhub.com/plugins)
- [OpenClaw 官方文档](https://docs.openclaw.ai)

---

**最后更新**: 2026-06-27
**维护者**: OpenClaw Team
