<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# 通道恢复机制说明

> OpenClaw v2.1.0 通道自动恢复、状态保持及故障排查指南

---

## 📋 概述

通道恢复机制确保 OpenClaw 在网络中断、服务重启等异常情况下自动恢复连接，保持会话状态不丢失。

| 功能 | 说明 |
|------|------|
| **自动重连** | 网络断开后自动尝试恢复连接 |
| **状态保持** | 重连后恢复之前的会话上下文 |
| **故障检测** | 实时监测通道健康状态 |
| **优雅降级** | 连接失败时提供备用方案 |

---

## 🔄 自动重连

### 配置方法

```json
{
  "channels": {
    "recovery": {
      "enabled": true,
      "autoReconnect": true,
      "reconnect": {
        "maxRetries": 10,
        "initialDelay": 1000,
        "maxDelay": 30000,
        "backoffMultiplier": 2.0,
        "jitter": true
      }
    }
  }
}
```

### 重连策略

OpenClaw 使用指数退避策略进行重连：

```
第1次重试: 1s 后
第2次重试: 2s 后
第3次重试: 4s 后
第4次重试: 8s 后
第5次重试: 16s 后
第6-10次: 30s 后（达到最大延迟）
```

### 心跳检测

```json
{
  "channels": {
    "recovery": {
      "heartbeat": {
        "enabled": true,
        "interval": 30000,
        "timeout": 10000,
        "maxMissed": 3
      }
    }
  }
}
```

### 使用示例

```bash
# 查看通道状态
openclaw channels status

# 输出示例：
# ┌──────────────┬─────────┬──────────┬────────────┐
# │ 通道          │ 状态     │ 延迟     │ 最后心跳    │
# ├──────────────┼─────────┼──────────┼────────────┤
# │ telegram     │ ✅ 在线  │ 45ms     │ 2s ago     │
# │ feishu       │ ✅ 在线  │ 120ms    │ 1s ago     │
# │ discord      │ ❌ 离线  │ -        │ 5m ago     │
# └──────────────┴─────────┴──────────┴────────────┘

# 手动触发重连
openclaw channels reconnect discord

# 重连所有通道
openclaw channels reconnect --all
```

---

## 💾 状态保持

### 配置方法

```json
{
  "channels": {
    "recovery": {
      "statePreservation": {
        "enabled": true,
        "storage": "redis",
        "ttl": 3600,
        "persistConversationHistory": true,
        "persistUserContext": true,
        "persistChannelState": true
      }
    }
  }
}
```

### 状态存储后端

#### Redis 存储（推荐）

```json
{
  "channels": {
    "recovery": {
      "statePreservation": {
        "storage": "redis",
        "redis": {
          "host": "localhost",
          "port": 6379,
          "password": "${REDIS_PASSWORD}",
          "db": 0,
          "keyPrefix": "openclaw:state:"
        }
      }
    }
  }
}
```

#### 文件存储

```json
{
  "channels": {
    "recovery": {
      "statePreservation": {
        "storage": "file",
        "file": {
          "path": "~/.openclaw/state",
          "maxSize": 104857600,
          "cleanupInterval": 86400
        }
      }
    }
  }
}
```

### 使用示例

```bash
# 查看保存的状态
openclaw state list

# 清除指定通道的状态
openclaw state clear telegram

# 导出状态快照
openclaw state export --output backup.json

# 恢复状态
openclaw state import backup.json
```

---

## 🩺 健康检查

### 配置健康检查

```json
{
  "channels": {
    "recovery": {
      "healthCheck": {
        "enabled": true,
        "interval": 60000,
        "endpoints": [
          {
            "name": "telegram-api",
            "url": "https://api.telegram.org",
            "timeout": 5000
          }
        ],
        "onFailure": {
          "action": "reconnect",
          "notify": true,
          "webhook": "https://your-webhook.com/alert"
        }
      }
    }
  }
}
```

### 使用示例

```bash
# 运行健康检查
openclaw health check

# 输出示例：
# ✅ telegram-api: OK (45ms)
# ✅ feishu-api: OK (120ms)
# ❌ discord-api: TIMEOUT (>5000ms)
# ✅ redis: OK (2ms)

# 持续监控
openclaw health watch --interval 10
```

---

## 🔍 故障排查

### 连接频繁断开

```
症状: 通道状态在在线/离线之间频繁切换
```

**排查步骤**：
```bash
# 1. 检查网络连通性
openclaw network test

# 2. 查看重连日志
openclaw logs --filter "reconnect" --tail 50

# 3. 检查 API 限流状态
openclaw rate-limit status
```

**解决方案**：
```json
{
  "channels": {
    "recovery": {
      "reconnect": {
        "initialDelay": 5000,
        "maxDelay": 60000,
        "backoffMultiplier": 3.0
      }
    }
  }
}
```

### 状态恢复失败

```
症状: 重连后会话上下文丢失
```

**排查步骤**：
```bash
# 1. 检查状态存储
openclaw state list --verbose

# 2. 验证 Redis 连接
openclaw redis ping

# 3. 查看状态恢复日志
openclaw logs --filter "state-restore" --tail 20
```

**解决方案**：
```bash
# 手动备份状态
openclaw state export --output manual-backup.json

# 增加状态 TTL
openclaw config set channels.recovery.statePreservation.ttl 7200

# 启用更频繁的状态持久化
openclaw config set channels.recovery.statePreservation.saveInterval 5000
```

### 心跳超时

```
症状: 日志显示 "heartbeat timeout" 错误
```

**排查步骤**：
```bash
# 1. 检查网络延迟
openclaw network latency

# 2. 增大心跳超时
openclaw config set channels.recovery.heartbeat.timeout 20000

# 3. 减少心跳检测频率
openclaw config set channels.recovery.heartbeat.interval 60000
```

---

## ⚠️ 注意事项

1. **Redis 版本**：建议使用 Redis 6.0+，支持更好的连接管理
2. **状态大小**：单个会话状态建议不超过 1MB，避免存储压力
3. **并发重连**：多通道同时断开时，会按优先级依次重连
4. **优雅关闭**：使用 `openclaw stop` 而非直接 kill，确保状态正确保存

---

最后更新：2026-06-27
