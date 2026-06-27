# SQLite 队列系统配置说明

**创建时间**: 2026-06-27
**适用版本**: OpenClaw v1.9.0+

## 📖 概述

SQLite 队列系统是 OpenClaw v1.9.0 引入的轻量级队列后端，使用 SQLite 数据库作为任务队列的存储引擎。相比 Redis 等外部队列服务，SQLite 队列无需额外部署依赖，适合单机部署和中小型工作负载场景。

## 🎯 核心特性

| 特性 | 说明 |
|------|------|
| 💾 持久化存储 | 任务数据持久化到磁盘，重启不丢失 |
| 🔒 事务支持 | 基于 SQLite 事务保证操作原子性 |
| 🔐 并发安全 | WAL 模式支持多进程并发读写 |
| 🧹 自动清理 | 自动清理过期任务和已完成任务 |
| 📊 监控统计 | 内置队列状态监控和性能统计 |

## 🔧 基础配置

### 启用 SQLite 队列

在 `~/.openclaw/openclaw.json` 中添加队列配置：

```json
{
  "queue": {
    "driver": "sqlite",
    "database": "~/.openclaw/data/queue.db",
    "enabled": true
  }
}
```

### 使用命令行配置

```bash
# 设置队列驱动为 SQLite
openclaw config set queue.driver sqlite

# 设置数据库路径
openclaw config set queue.database ~/.openclaw/data/queue.db

# 启用队列系统
openclaw config set queue.enabled true
```

### 验证配置

```bash
# 查看队列状态
openclaw queue status

# 测试队列功能
openclaw queue test

# 查看队列统计
openclaw queue stats
```

## ⚙️ 高级配置

### 完整配置示例

```json
{
  "queue": {
    "driver": "sqlite",
    "database": "~/.openclaw/data/queue.db",
    "enabled": true,
    "wal": true,
    "maxSize": "500MB",
    "cleanup": {
      "enabled": true,
      "interval": 3600,
      "maxAge": "7d",
      "maxCompleted": 10000
    },
    "retry": {
      "maxAttempts": 3,
      "backoff": "exponential",
      "initialDelay": 1000,
      "maxDelay": 60000
    },
    "concurrency": {
      "workers": 4,
      "prefetch": 10
    }
  }
}
```

### WAL 模式配置

WAL（Write-Ahead Logging）模式提升并发性能：

```json
{
  "queue": {
    "sqlite": {
      "wal": true,
      "walAutocheckpoint": 1000,
      "synchronous": "normal",
      "cacheSize": "64MB"
    }
  }
}
```

```bash
# 启用 WAL 模式
openclaw config set queue.sqlite.wal true

# 设置 WAL 自动检查点
openclaw config set queue.sqlite.walAutocheckpoint 1000

# 设置同步模式
openclaw config set queue.sqlite.synchronous normal
```

### 自动清理配置

```json
{
  "queue": {
    "cleanup": {
      "enabled": true,
      "interval": 3600,
      "maxAge": "7d",
      "maxCompleted": 10000,
      "maxFailed": 5000,
      "vacuumOnCleanup": true
    }
  }
}
```

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `enabled` | boolean | `true` | 是否启用自动清理 |
| `interval` | number | `3600` | 清理间隔（秒） |
| `maxAge` | string | `"7d"` | 已完成任务保留时间 |
| `maxCompleted` | number | `10000` | 最大已完成任务数 |
| `maxFailed` | number | `5000` | 最大失败任务数 |
| `vacuumOnCleanup` | boolean | `true` | 清理后是否执行 VACUUM |

### 重试策略配置

```json
{
  "queue": {
    "retry": {
      "maxAttempts": 3,
      "backoff": "exponential",
      "initialDelay": 1000,
      "maxDelay": 60000,
      "retryableErrors": ["timeout", "connection_error"]
    }
  }
}
```

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `maxAttempts` | number | `3` | 最大重试次数 |
| `backoff` | string | `"exponential"` | 退避策略（linear/exponential） |
| `initialDelay` | number | `1000` | 初始延迟（毫秒） |
| `maxDelay` | number | `60000` | 最大延迟（毫秒） |

### 并发配置

```json
{
  "queue": {
    "concurrency": {
      "workers": 4,
      "prefetch": 10,
      "maxQueueSize": 10000
    }
  }
}
```

## 📊 队列管理

### 查看队列状态

```bash
# 查看队列概览
openclaw queue status

# 查看详细统计
openclaw queue stats --detailed

# 查看队列大小
openclaw queue size
```

### 任务管理

```bash
# 列出待处理任务
openclaw queue list --status pending

# 列出失败任务
openclaw queue list --status failed

# 查看任务详情
openclaw queue info <task-id>

# 重试失败任务
openclaw queue retry <task-id>

# 重试所有失败任务
openclaw queue retry --all --status failed

# 删除任务
openclaw queue remove <task-id>

# 清空队列
openclaw queue purge --status completed
```

### 维护操作

```bash
# 手动触发清理
openclaw queue cleanup

# 压缩数据库
openclaw queue vacuum

# 重建索引
openclaw queue reindex

# 导出队列数据
openclaw queue export --output queue-backup.json

# 导入队列数据
openclaw queue import --input queue-backup.json
```

## 🔍 故障排除

### 常见问题

#### 1. 队列数据库锁定

**症状**: 出现 `database is locked` 错误

**解决方案**:
```bash
# 启用 WAL 模式
openclaw config set queue.sqlite.wal true

# 增加超时时间
openclaw config set queue.sqlite.busyTimeout 30000

# 检查是否有其他进程占用
openclaw queue diagnose
```

#### 2. 队列性能下降

**症状**: 任务处理速度变慢

**解决方案**:
```bash
# 压缩数据库
openclaw queue vacuum

# 重建索引
openclaw queue reindex

# 检查队列大小
openclaw queue size

# 清理旧任务
openclaw queue cleanup
```

#### 3. 任务丢失

**症状**: 任务提交后未被处理

**解决方案**:
```bash
# 检查队列状态
openclaw queue status

# 查看任务状态
openclaw queue list --status all

# 检查 worker 状态
openclaw queue workers
```

### 调试命令

```bash
# 查看队列日志
openclaw logs queue

# 运行诊断
openclaw queue diagnose

# 测试队列性能
openclaw queue benchmark
```

## ⚠️ 注意事项

1. **适用场景**: SQLite 队列适合单机部署和中小型工作负载，大规模分布式场景建议使用 Redis 队列
2. **并发限制**: SQLite 的写入并发有限，高并发场景建议增加 worker 数量并启用 WAL 模式
3. **磁盘空间**: 定期清理过期任务，避免数据库文件过大
4. **备份**: 定期备份队列数据库文件 `~/.openclaw/data/queue.db`
5. **VACUUM**: 大量删除操作后建议执行 `openclaw queue vacuum` 回收空间
6. **WAL 模式**: 强烈建议启用 WAL 模式以提升并发性能

## 📚 相关链接

- [记忆系统配置指南](./memory-configuration.md)
- [OpenClaw 官方文档](https://docs.openclaw.ai)
- [SQLite WAL 模式文档](https://www.sqlite.org/wal.html)

---

**最后更新**: 2026-06-27
**维护者**: OpenClaw Team
