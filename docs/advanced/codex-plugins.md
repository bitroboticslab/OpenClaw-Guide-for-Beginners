<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# Codex 原生插件使用指南

> 管理和配置 Codex 内置的原生插件系统

---

## 📋 概述

Codex 原生插件是 OpenClaw v2.1.0 引入的内置插件体系，提供开箱即用的功能扩展。与第三方插件不同，原生插件随 OpenClaw 一起发布，无需额外安装。

---

## 🔌 `/codex plugins` 命令

### 查看所有插件

```bash
# 列出所有可用插件及其状态
openclaw codex plugins list

# 输出示例：
# ┌─────────────────────┬─────────┬──────────┐
# │ 插件名称             │ 状态     │ 版本     │
# ├─────────────────────┼─────────┼──────────┤
# │ code-interpreter    │ ✅ 启用  │ 1.2.0    │
# │ web-search          │ ✅ 启用  │ 1.1.0    │
# │ file-operations     │ ✅ 启用  │ 1.0.0    │
# │ sandbox-executor    │ ❌ 禁用  │ 1.0.0    │
# │ memory-manager      │ ✅ 启用  │ 1.3.0    │
# └─────────────────────┴─────────┴──────────┘
```

### 查看插件详情

```bash
# 查看指定插件详情
openclaw codex plugins info code-interpreter

# 输出示例：
# 插件: code-interpreter
# 版本: 1.2.0
# 状态: 已启用
# 描述: 提供代码执行和解释能力
# 依赖: sandbox-executor
# 配置: ~/.openclaw/plugins/code-interpreter.json
```

---

## ⚙️ 插件启用/禁用

### 启用插件

```bash
# 启用单个插件
openclaw codex plugins enable sandbox-executor

# 批量启用
openclaw codex plugins enable sandbox-executor memory-manager
```

### 禁用插件

```bash
# 禁用单个插件
openclaw codex plugins disable web-search

# 批量禁用
openclaw codex plugins disable web-search file-operations
```

### 重置插件

```bash
# 重置插件到默认配置
openclaw codex plugins reset code-interpreter

# 重置所有插件
openclaw codex plugins reset --all
```

---

## 🔧 配置方法

### 全局插件配置

在 `openclaw.json` 中配置插件系统：

```json
{
  "codex": {
    "plugins": {
      "enabled": true,
      "autoLoad": true,
      "configDir": "~/.openclaw/plugins",
      "logLevel": "info"
    }
  }
}
```

### 单个插件配置

每个插件有独立的配置文件，位于 `~/.openclaw/plugins/` 目录下：

```json
// ~/.openclaw/plugins/code-interpreter.json
{
  "enabled": true,
  "version": "1.2.0",
  "settings": {
    "runtime": "python3",
    "timeout": 30000,
    "maxOutputSize": 65536,
    "allowedModules": ["os", "sys", "json", "math", "datetime"],
    "blockedModules": ["subprocess", "shutil"]
  }
}
```

### 插件优先级

```json
{
  "codex": {
    "plugins": {
      "priority": [
        "memory-manager",
        "code-interpreter",
        "web-search",
        "file-operations"
      ]
    }
  }
}
```

---

## 📦 内置插件列表

### code-interpreter

代码执行和解释器插件。

```json
{
  "enabled": true,
  "settings": {
    "runtime": "python3",
    "timeout": 30000,
    "sandboxMode": true,
    "allowedModules": ["json", "math", "datetime", "re"]
  }
}
```

### web-search

网络搜索插件。

```json
{
  "enabled": true,
  "settings": {
    "searchEngine": "auto",
    "maxResults": 5,
    "safeSearch": true,
    "cacheResults": true,
    "cacheTTL": 3600
  }
}
```

### file-operations

文件操作插件。

```json
{
  "enabled": true,
  "settings": {
    "allowedPaths": ["/root/workspace", "/tmp"],
    "denyPaths": ["/etc", "/root/.ssh"],
    "maxFileSize": 10485760,
    "createBackups": true
  }
}
```

### sandbox-executor

沙箱执行器插件。

```json
{
  "enabled": false,
  "settings": {
    "provider": "docker",
    "image": "openclaw/sandbox:latest",
    "memoryLimit": "512m",
    "cpuLimit": "1.0",
    "networkAccess": false
  }
}
```

### memory-manager

记忆管理插件。

```json
{
  "enabled": true,
  "settings": {
    "maxMemorySize": 1048576,
    "persistence": true,
    "storagePath": "~/.openclaw/memory",
    "autoCleanup": true,
    "cleanupInterval": 86400
  }
}
```

---

## 💡 使用示例

### 场景1：启用沙箱执行代码

```bash
# 启用沙箱插件
openclaw codex plugins enable sandbox-executor

# 配置沙箱参数
openclaw config set codex.plugins.sandbox-executor.settings.memoryLimit "1g"

# 测试执行
openclaw codex run "print('Hello from sandbox')" --sandbox
```

### 场景2：配置代码解释器白名单

```bash
# 编辑插件配置
openclaw codex plugins config code-interpreter

# 或直接编辑配置文件
cat > ~/.openclaw/plugins/code-interpreter.json << 'EOF'
{
  "enabled": true,
  "settings": {
    "runtime": "python3",
    "timeout": 60000,
    "allowedModules": ["json", "math", "pandas", "numpy"],
    "blockedModules": ["os", "subprocess"]
  }
}
EOF
```

### 场景3：插件依赖管理

```bash
# 查看插件依赖
openclaw codex plugins deps code-interpreter

# 输出：
# code-interpreter@1.2.0
# └── sandbox-executor@1.0.0 (required)

# 自动安装依赖
openclaw codex plugins install-deps code-interpreter
```

---

## ⚠️ 注意事项

1. **插件冲突**：同一功能的插件只能启用一个，如多个代码执行器
2. **依赖关系**：部分插件依赖其他插件，禁用依赖项会导致功能异常
3. **配置优先级**：插件配置 > 全局配置 > 默认配置
4. **版本兼容**：插件版本需与 OpenClaw 主版本兼容

---

## 🔍 故障排查

### 插件加载失败

```
错误: Plugin 'xxx' failed to load: dependency 'yyy' not found
```

**解决**：
```bash
# 安装缺失依赖
openclaw codex plugins install-deps xxx

# 或手动启用依赖插件
openclaw codex plugins enable yyy
```

### 插件配置不生效

```
错误: Plugin settings ignored
```

**解决**：
```bash
# 验证配置文件语法
openclaw codex plugins validate xxx

# 重启 OpenClaw 使配置生效
openclaw restart
```

### 插件版本不兼容

```
错误: Plugin 'xxx' requires OpenClaw >= 2.1.0
```

**解决**：
```bash
# 升级 OpenClaw
npm install -g openclaw@latest

# 或降级插件版本
openclaw codex plugins install xxx@1.0.0
```

---

最后更新：2026-06-27
