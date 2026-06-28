<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# Slack 对接教程（Relay 模式）

> 通过 Slack Relay 模式将 OpenClaw 接入 Slack 工作区，支持频道与私信、富文本和线程回复

**适用版本**：OpenClaw v2026.6.11-beta 及以上

---

## 📋 前置要求

- 已完成 OpenClaw 安装和 API 配置
- OpenClaw 版本 ≥ v2026.6.11-beta
- Slack 工作区管理员权限（或可请求管理员审批）
- 如使用云服务器，需确保公网可访问（Relay 模式需要回调地址）

---

## 第一步：创建 Slack 应用

### 1.1 进入 Slack API 平台

访问 [Slack API](https://api.slack.com/apps) 并登录你的 Slack 账号。

### 1.2 创建新应用

1. 点击 **Create New App**
2. 选择 **From scratch**
3. 填写应用信息：
   - **App Name**：AI助手（或你喜欢的名称）
   - **Workspace**：选择你的 Slack 工作区

### 1.3 记录凭证信息

创建完成后，在 **Basic Information** 页面记录：

| 凭证 | 说明 |
|------|------|
| App ID | 应用唯一标识 |
| Client ID | OAuth 客户端 ID |
| Client Secret | OAuth 客户端密钥 |
| Signing Request URL | 用于验证请求来源 |

---

## 第二步：配置 Bot Token 权限

### 2.1 添加 OAuth Scopes

进入 **OAuth & Permissions** → **Scopes** → **Bot Token Scopes**，添加以下权限：

| 权限标识 | 用途 |
|----------|------|
| `app_mentions:read` | 读取 @提及机器人的消息 |
| `channels:history` | 读取公共频道消息 |
| `channels:read` | 读取公共频道列表 |
| `chat:write` | 发送消息 |
| `chat:write.public` | 向未加入的公共频道发消息 |
| `im:history` | 读取私信消息 |
| `im:read` | 读取私信列表 |
| `im:write` | 创建私信对话 |
| `reactions:write` | 添加 emoji 回应 |
| `threads:read` | 读取线程消息 |
| `users:read` | 读取用户信息 |

### 2.2 安装应用到工作区

1. 点击 **Install to Workspace**
2. 授权应用所需权限
3. 记录 **Bot User OAuth Token**（格式：`xoxb-xxxxxxxxxxxx`）

---

## 第三步：配置事件订阅

### 3.1 启用事件

进入 **Event Subscriptions**：

1. 打开 **Enable Events** 开关
2. 填写 **Request URL**：
   ```
   https://你的服务器地址:18789/slack/events
   ```
3. Slack 会发送验证请求，确保 OpenClaw gateway 正在运行

### 3.2 订阅 Bot Events

添加以下事件：

| 事件名称 | 说明 |
|----------|------|
| `app_mention` | 当机器人被 @提及时触发 |
| `message.im` | 当收到私信时触发 |
| `message.channels` | 当公共频道有新消息时触发 |

---

## 第四步：配置 OpenClaw Relay 模式

### 4.1 什么是 Relay 模式

Relay 模式是 v2026.6.11-beta 引入的 Slack 集成方式，通过中继层将 Slack 消息桥接到 OpenClaw。相比传统 Webhook 方式，Relay 模式具有以下优势：

| 特性 | 说明 |
|------|------|
| 自动重连 | 断线后自动恢复连接 |
| 富文本支持 | 支持 Slack Block Kit 格式 |
| 线程支持 | 原生线程内回复 |
| 多频道 | 同时监听多个频道 |
| 低延迟 | 长轮询 + WebSocket 混合模式 |

### 4.2 配置文件

在 `~/.openclaw/config.json` 中添加 Slack 通道配置：

```json
{
  "channels": {
    "slack": {
      "enabled": true,
      "mode": "relay",
      "token": {
        "bot": "xoxb-你的Bot-Token",
        "signing": "你的Signing-Secret"
      },
      "relay": {
        "endpoint": "https://你的服务器地址:18789/slack/events",
        "retryPolicy": "exponential",
        "maxRetries": 5,
        "heartbeatInterval": 30000
      },
      "features": {
        "threads": true,
        "richText": true,
        "reactions": true,
        "ephemeral": false
      },
      "channels": {
        "listen": ["#general", "#ai-chat"],
        "ignore": ["#random"],
        "dmEnabled": true
      }
    }
  }
}
```

### 4.3 配置项说明

| 配置项 | 类型 | 说明 |
|--------|------|------|
| `mode` | string | 必须设为 `"relay"` 启用 Relay 模式 |
| `token.bot` | string | Bot User OAuth Token |
| `token.signing` | string | 用于验证请求来源的 Signing Secret |
| `relay.endpoint` | string | 事件回调地址 |
| `relay.retryPolicy` | string | 重试策略，支持 `exponential` / `linear` / `fixed` |
| `relay.maxRetries` | number | 最大重试次数 |
| `relay.heartbeatInterval` | number | 心跳间隔（毫秒） |
| `features.threads` | boolean | 是否启用线程回复 |
| `features.richText` | boolean | 是否启用富文本格式 |
| `features.reactions` | boolean | 是否启用 emoji 回应 |
| `channels.listen` | array | 监听的频道列表 |
| `channels.ignore` | array | 忽略的频道列表 |
| `channels.dmEnabled` | boolean | 是否启用私信 |

---

## 第五步：启动与验证

### 5.1 启动 gateway

```bash
# 重启 OpenClaw gateway
openclaw gateway restart

# 查看 Slack 通道状态
openclaw channels status slack
```

### 5.2 测试连接

在 Slack 中：

```
# 在 #ai-chat 频道中 @机器人
@AI助手 你好

# 或发送私信
直接给机器人发消息
```

### 5.3 查看日志

```bash
# 实时查看 Slack 通道日志
openclaw channels logs slack --follow
```

---

## 📨 消息格式支持

### 富文本格式

Relay 模式支持 Slack Block Kit 格式的消息发送：

```json
{
  "blocks": [
    {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "*任务完成* ✅\n执行时间：2.3s"
      }
    }
  ]
}
```

### 线程回复

当用户在线程中 @机器人时，回复会自动发送到该线程内：

```
用户（在线程中）: @AI助手 帮我分析这段代码
机器人（线程内回复）: 好的，让我来看看...
```

### Emoji 回应

机器人可以对消息添加 emoji 回应表示状态：

| Emoji | 含义 |
|-------|------|
| 👀 | 正在处理 |
| ✅ | 处理完成 |
| ❌ | 处理失败 |

---

## 🔧 常见问题排查

### 问题 1：事件验证失败

**症状**：Slack 显示 "Request URL could not be verified"

**排查**：
```bash
# 检查 gateway 是否运行
openclaw gateway status

# 检查端口是否可访问
curl -X POST https://你的服务器:18789/slack/events

# 检查防火墙
sudo ufw status
```

**解决**：确保 gateway 正在运行且端口对外开放，HTTPS 证书有效。

### 问题 2：机器人不回复消息

**症状**：@机器人后无响应

**排查**：
```bash
# 查看 Slack 通道状态
openclaw channels status slack

# 查看日志是否有错误
openclaw channels logs slack --tail 50
```

**解决**：
1. 检查 Bot Token 是否正确
2. 确认 Bot 已被邀请到目标频道
3. 确认频道在 `channels.listen` 列表中

### 问题 3：线程回复不工作

**症状**：回复发送到频道而不是线程

**解决**：确认配置中 `features.threads` 设为 `true`，并检查 Slack 应用是否有 `threads:read` 权限。

### 问题 4：Relay 连接频繁断开

**症状**：日志中出现大量重连记录

**排查**：
```bash
# 查看心跳状态
openclaw channels logs slack --grep "heartbeat"
```

**解决**：
1. 调整 `relay.heartbeatInterval`（建议 30000~60000ms）
2. 检查服务器网络稳定性
3. 如使用反向代理，确保 WebSocket 连接未被中断

---

## 📝 完整配置示例

```json
{
  "channels": {
    "slack": {
      "enabled": true,
      "mode": "relay",
      "token": {
        "bot": "xoxb-1234567890-ABCDEFG",
        "signing": "a1b2c3d4e5f6g7h8i9j0"
      },
      "relay": {
        "endpoint": "https://example.com:18789/slack/events",
        "retryPolicy": "exponential",
        "maxRetries": 5,
        "heartbeatInterval": 30000,
        "timeout": 10000
      },
      "features": {
        "threads": true,
        "richText": true,
        "reactions": true,
        "ephemeral": false,
        "markdownPreserve": true
      },
      "channels": {
        "listen": ["#general", "#ai-chat", "#dev"],
        "ignore": ["#random", "#off-topic"],
        "dmEnabled": true
      },
      "formatting": {
        "maxMessageLength": 4000,
        "codeBlockStyle": "fenced",
        "linkPreview": false
      }
    }
  }
}
```

---

## 🔗 相关链接

- [Slack API 文档](https://api.slack.com/)
- [Slack Block Kit 构建器](https://app.slack.com/block-kit-builder)
- [OpenClaw 通道配置指南](https://docs.openclaw.ai/channels)

---

This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License.
