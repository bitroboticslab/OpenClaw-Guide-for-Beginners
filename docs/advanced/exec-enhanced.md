<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# exec 功能增强说明

> OpenClaw v2.1.0 安全执行、超时控制及高级配置指南

---

## 📋 概述

`exec` 是 OpenClaw 的命令执行功能，v2.1.0 对其进行了全面增强，提供更安全、更可控的命令执行能力。

| 增强特性 | 说明 |
|----------|------|
| **安全执行** | 沙箱隔离、命令白名单、权限控制 |
| **超时控制** | 精确的超时管理、优雅终止 |
| **资源限制** | CPU、内存、磁盘 I/O 限制 |
| **审计日志** | 完整的执行记录和审计追踪 |

---

## 🔒 安全执行

### 沙箱模式配置

```json
{
  "exec": {
    "sandbox": {
      "enabled": true,
      "provider": "docker",
      "image": "openclaw/sandbox:latest",
      "isolation": {
        "network": false,
        "filesystem": "readonly",
        "pid": true,
        "user": "nobody"
      }
    }
  }
}
```

### 命令白名单

```json
{
  "exec": {
    "security": {
      "whitelist": {
        "enabled": true,
        "commands": [
          "ls", "cat", "grep", "find", "wc",
          "python3", "node", "npm", "git",
          "curl", "wget"
        ],
        "patterns": [
          "^git (status|log|diff|branch).*",
          "^python3 .*\\.py$",
          "^npm (test|run|install).*"
        ]
      }
    }
  }
}
```

### 命令黑名单

```json
{
  "exec": {
    "security": {
      "blacklist": {
        "enabled": true,
        "commands": [
          "rm -rf /", "dd", "mkfs", "fdisk",
          "shutdown", "reboot", "halt"
        ],
        "patterns": [
          ".*> /dev/.*",
          ".*\\| .*sh$",
          ".*; rm .*"
        ]
      }
    }
  }
}
```

### 权限控制

```json
{
  "exec": {
    "security": {
      "permissions": {
        "allowRoot": false,
        "allowSudo": false,
        "allowedUsers": ["openclaw", "sandbox"],
        "allowedGroups": ["openclaw"],
        "umask": "022"
      }
    }
  }
}
```

---

## ⏱️ 超时控制

### 全局超时配置

```json
{
  "exec": {
    "timeout": {
      "default": 30000,
      "max": 300000,
      "min": 1000,
      "gracePeriod": 5000,
      "killSignal": "SIGTERM",
      "killTimeout": 10000
    }
  }
}
```

### 按命令类型配置超时

```json
{
  "exec": {
    "timeout": {
      "byType": {
        "shell": 30000,
        "python": 60000,
        "node": 60000,
        "build": 600000,
        "test": 120000
      }
    }
  }
}
```

### 优雅终止机制

```json
{
  "exec": {
    "timeout": {
      "gracefulShutdown": {
        "enabled": true,
        "signal": "SIGTERM",
        "waitTime": 5000,
        "fallbackSignal": "SIGKILL",
        "cleanupTimeout": 10000
      }
    }
  }
}
```

执行流程：
```
超时触发 → SIGTERM → 等待5s → 检查进程 → 未退出 → SIGKILL → 清理资源
```

---

## 📊 资源限制

### CPU 限制

```json
{
  "exec": {
    "resources": {
      "cpu": {
        "limit": "1.0",
        "affinity": [0, 1],
        "nice": 10
      }
    }
  }
}
```

### 内存限制

```json
{
  "exec": {
    "resources": {
      "memory": {
        "limit": "512m",
        "swap": "256m",
        "oomKillDisable": false
      }
    }
  }
}
```

### 磁盘 I/O 限制

```json
{
  "exec": {
    "resources": {
      "disk": {
        "readBps": "10m",
        "writeBps": "5m",
        "readIops": 1000,
        "writeIops": 500
      }
    }
  }
}
```

---

## 📝 审计日志

### 配置审计日志

```json
{
  "exec": {
    "audit": {
      "enabled": true,
      "logFile": "~/.openclaw/logs/exec-audit.log",
      "logLevel": "info",
      "rotate": {
        "maxSize": "100m",
        "maxFiles": 10,
        "compress": true
      },
      "fields": [
        "timestamp",
        "command",
        "user",
        "exitCode",
        "duration",
        "output"
      ]
    }
  }
}
```

### 日志格式示例

```json
{
  "timestamp": "2026-06-27T10:30:00Z",
  "command": "python3 script.py",
  "user": "openclaw",
  "pid": 12345,
  "exitCode": 0,
  "duration": 1234,
  "memoryUsed": "128m",
  "cpuUsed": "0.5",
  "output": "Script completed successfully"
}
```

---

## 🔧 完整配置示例

```json
{
  "exec": {
    "enabled": true,
    "sandbox": {
      "enabled": true,
      "provider": "docker",
      "image": "openclaw/sandbox:latest"
    },
    "security": {
      "whitelist": {
        "enabled": true,
        "commands": ["ls", "cat", "grep", "python3", "node", "git"]
      },
      "blacklist": {
        "enabled": true,
        "commands": ["rm -rf", "dd", "shutdown"]
      },
      "permissions": {
        "allowRoot": false,
        "allowSudo": false
      }
    },
    "timeout": {
      "default": 30000,
      "max": 300000,
      "gracePeriod": 5000
    },
    "resources": {
      "cpu": { "limit": "1.0" },
      "memory": { "limit": "512m" }
    },
    "audit": {
      "enabled": true,
      "logFile": "~/.openclaw/logs/exec-audit.log"
    }
  }
}
```

---

## 💡 使用示例

### 基本执行

```bash
# 执行命令
openclaw exec "ls -la"

# 带超时执行
openclaw exec "python3 long_task.py" --timeout 60000

# 在沙箱中执行
openclaw exec "npm test" --sandbox
```

### 安全模式执行

```bash
# 使用白名单模式
openclaw exec "git status" --security whitelist

# 使用沙箱模式
openclaw exec "python3 untrusted.py" --sandbox --timeout 30000

# 限制资源
openclaw exec "npm run build" --cpu-limit 2.0 --memory-limit 1g
```

### 批量执行

```bash
# 顺序执行多个命令
openclaw exec-batch "git pull" "npm install" "npm test"

# 并行执行
openclaw exec-parallel "test1.py" "test2.py" "test3.py" --max-parallel 3
```

---

## ⚠️ 注意事项

1. **沙箱依赖**：Docker 模式需要安装 Docker，且用户需有 Docker 权限
2. **超时精度**：超时检测存在 100-500ms 的误差，不适用于高精度场景
3. **资源限制**：cgroup v1/v2 差异可能导致配置行为不同
4. **审计日志**：大量执行操作会产生大量日志，注意磁盘空间

---

## 🔍 故障排查

### 命令执行超时

```
错误: Command 'xxx' exceeded timeout of 30000ms
```

**解决**：
```bash
# 增大超时时间
openclaw exec "xxx" --timeout 60000

# 或修改默认超时
openclaw config set exec.timeout.default 60000
```

### 命令被安全策略阻止

```
错误: Command 'xxx' is not in the whitelist
```

**解决**：
```bash
# 查看当前白名单
openclaw config get exec.security.whitelist.commands

# 添加命令到白名单
openclaw config add exec.security.whitelist.commands "xxx"

# 或临时禁用白名单（不推荐用于生产）
openclaw exec "xxx" --no-whitelist
```

### 沙箱启动失败

```
错误: Failed to start sandbox: docker daemon not running
```

**解决**：
```bash
# 检查 Docker 状态
docker info

# 启动 Docker
sudo systemctl start docker

# 或切换到非 Docker 沙箱
openclaw config set exec.sandbox.provider process
```

### 内存不足被 OOM Kill

```
错误: Process killed by OOM killer
```

**解决**：
```bash
# 增大内存限制
openclaw config set exec.resources.memory.limit "1g"

# 禁用 OOM Kill（不推荐）
openclaw config set exec.resources.memory.oomKillDisable true

# 使用交换空间
openclaw config set exec.resources.memory.swap "512m"
```

---

最后更新：2026-06-27
