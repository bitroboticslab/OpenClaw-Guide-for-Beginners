<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# Mattermost 对接教程（原生支持）

> 将 OpenClaw 接入 Mattermost，支持原生命令 `/oc_queue`、频道消息和 Webhook 集成

**适用版本**：OpenClaw v2026.6.11-beta 及以上

---

## 📋 前置要求

- 已完成 OpenClaw 安装和 API 配置
- OpenClaw 版本 ≥ v2026.6.11-beta
- Mattermost 服务器管理员权限（或可请求管理员协助）
- Mattermost 版本 ≥ 7.0

---

## 第一步：创建 Mattermost 机器人账号

### 1.1 通过系统控制台创建

1. 登录 Mattermost 管理控制台
2. 进入 **系统控制台** → **集成** → **Bot 账号**
3. 点击 **创建 Bot 账号**
4. 填写信息：
   - **用户名**：`openclaw-bot`（或自定义名称）
   - **显示名称**：AI助手
   - **描述**：基于 OpenClaw 的 AI 助手
5. 记录生成的 **Access Token**

### 1.2 通过命令行创建（推荐）

```bash
# 使用 Mattermost mmctl 工具
mmctl bot create openclaw-bot --display-name "AI助手" --description "基于 OpenClaw 的 AI 助手"

# 生成访问令牌
mmctl token generate openclaw-bot
```

### 1.3 记录凭证信息

| 凭证 | 说明 |
|------|------|
| Bot Username | 机器人用户名 |
| Access Token | API 访问令牌 |
| Server URL | Mattermost 服务器地址 |

---

## 第二步：配置机器人权限

### 2.1 系统角色配置

在 **系统控制台** → **用户管理** → **系统角色** 中，为 Bot 账号分配以下权限：

| 权限 | 说明 |
|------|------|
| `create_post` | 创建消息 |
| `read_channel` | 读取频道消息 |
| `join_public_channels` | 加入公共频道 |
| `manage_webhooks` | 管理 Webhook（如使用 Webhook 模式） |

### 2.2 将机器人加入频道

```bash
# 将机器人加入指定频道
mmctl channel add general openclaw-bot
mmctl channel add ai-chat openclaw-bot
```

或在 Mattermost 客户端中：
1. 打开目标频道
2. 点击频道名称 → **成员**
3. 搜索并添加机器人

---

## 第三步：配置 OpenClaw

### 3.1 基础配置

在 `~/.openclaw/config.json` 中添加 Mattermost 通道：

```json
{
  "channels": {
    "mattermost": {
      "enabled": true,
      "server": "https://mattermost.example.com",
      "token": "你的Bot-Access-Token",
      "team": "your-team-name",
      "features": {
        "nativeCommands": true,
        "webhooks": false,
        "threads": true,
        "reactions": true
      },
      "channels": {
        "listen": ["general", "ai-chat"],
        "ignore": ["off-topic"],
        "dmEnabled": true
      }
    }
  }
}
```

### 3.2 配置项说明

| 配置项 | 类型 | 说明 |
|--------|------|------|
| `server` | string | Mattermost 服务器地址 |
| `token` | string | Bot Access Token |
| `team` | string | 团队名称 |
| `features.nativeCommands` | boolean | 启用原生命令支持 |
| `features.webhooks` | boolean | 启用 Webhook 模式 |
| `features.threads` | boolean | 启用线程支持 |
| `features.reactions` | boolean | 启用 emoji 回应 |
| `channels.listen` | array | 监听的频道列表 |
| `channels.ignore` | array | 忽略的频道列表 |
| `channels.dmEnabled` | boolean | 是否启用私信 |

---

## 第四步：使用原生命令 `/oc_queue`

### 4.1 命令简介

`/oc_queue` 是 OpenClaw v2026.6.11-beta 为 Mattermost 引入的原生斜杠命令，支持在频道中直接与 AI 交互。

### 4.2 注册斜杠命令

首次使用前需要在 Mattermost 中注册命令：

1. 进入 **集成** → **斜杠命令** → **添加斜杠命令**
2. 填写信息：

| 字段 | 值 |
|------|-----|
| 命令触发词 | `/oc_queue` |
| 请求 URL | `https://你的服务器:18789/mattermost/commands` |
| 请求方法 | `POST` |
| 自动完成 | 启用 |
| 自动完成提示 | `任务描述` |
| 自动完成描述 | `向 AI 助手提交任务` |

3. 保存并记录 **Token**

### 4.3 在 OpenClaw 中注册命令 Token

```json
{
  "channels": {
    "mattermost": {
      "commands": {
        "oc_queue": {
          "token": "Mattermost命令Token",
          "enabled": true,
          "allowedRoles": ["system_admin", "team_admin", "team_user"]
        }
      }
    }
  }
}
```

### 4.4 使用方法

在 Mattermost 频道中：

```
# 提交任务
/oc_queue 帮我分析这段代码的功能

# 查看队列状态
/oc_queue --status

# 清空当前队列
/oc_queue --clear

# 指定模型
/oc_queue --model gpt-4o 帮我写一个Python脚本
```

---

## 第五步：Webhook 集成（可选）

### 5.1 创建 Incoming Webhook

1. 进入 **集成** → **Incoming Webhook** → **添加**
2. 填写信息：
   - **标题**：OpenClaw Notifications
   - **频道**：选择目标频道
3. 记录 **Webhook URL**

### 5.2 创建 Outgoing Webhook

1. 进入 **集成** → **Outgoing Webhook** → **添加**
2. 填写信息：
   - **频道**：选择监听频道
   - **触发词**：`AI`（可选）
   - **回调 URL**：`https://你的服务器:18789/mattermost/webhook`

### 5.3 Webhook 配置

```json
{
  "channels": {
    "mattermost": {
      "webhooks": {
        "enabled": true,
        "incoming": "https://mattermost.example.com/hooks/xxx",
        "outgoingToken": "你的outgoing-webhook-token"
      }
    }
  }
}
```

---

## 第六步：启动与验证

### 6.1 启动 gateway

```bash
# 重启 OpenClaw gateway
openclaw gateway restart

# 查看 Mattermost 通道状态
openclaw channels status mattermost
```

### 6.2 测试连接

```bash
# 在 Mattermost 频道中发送消息
# 机器人应该会回复

# 测试斜杠命令
/oc_queue 你好，测试连接
```

### 6.3 查看日志

```bash
# 实时查看 Mattermost 通道日志
openclaw channels logs mattermost --follow
```

---

## 🔧 常见问题排查

### 问题 1：机器人不响应消息

**症状**：在频道中 @机器人后无回复

**排查**：
```bash
# 检查通道状态
openclaw channels status mattermost

# 检查连接是否正常
openclaw channels test mattermost

# 查看日志
openclaw channels logs mattermost --tail 50
```

**解决**：
1. 检查 `token` 是否正确
2. 确认机器人已加入目标频道
3. 确认服务器地址无误（包含 `https://`）

### 问题 2：`/oc_queue` 命令无响应

**症状**：执行 `/oc_queue` 后提示 "command not found" 或无反应

**解决**：
1. 确认已在 Mattermost 中注册斜杠命令
2. 检查 Request URL 是否正确且可访问
3. 确认 `features.nativeCommands` 设为 `true`
4. 检查命令 Token 是否匹配

### 问题 3：连接超时

**症状**：日志中出现连接超时错误

**排查**：
```bash
# 测试服务器连通性
curl -v https://mattermost.example.com/api/v4/system/ping

# 检查 DNS 解析
nslookup mattermost.example.com
```

**解决**：
1. 确认 Mattermost 服务器地址正确
2. 检查网络防火墙是否放行
3. 如使用自签名证书，在配置中添加 `"allowInsecure": true`

### 问题 4：Webhook 消息丢失

**症状**：通过 Webhook 发送的消息未出现在频道中

**解决**：
1. 检查 Incoming Webhook URL 是否正确
2. 确认目标频道未被归档
3. 检查 Webhook 请求返回的状态码

---

## 📝 完整配置示例

```json
{
  "channels": {
    "mattermost": {
      "enabled": true,
      "server": "https://mattermost.example.com",
      "token": "abcdefghijklmnopqrstuvwx",
      "team": "my-team",
      "features": {
        "nativeCommands": true,
        "webhooks": true,
        "threads": true,
        "reactions": true,
        "markdownPreserve": true
      },
      "channels": {
        "listen": ["general", "ai-chat", "dev-team"],
        "ignore": ["random", "off-topic"],
        "dmEnabled": true
      },
      "commands": {
        "oc_queue": {
          "token": "命令Token",
          "enabled": true,
          "allowedRoles": ["system_admin", "team_admin", "team_user"]
        }
      },
      "webhooks": {
        "enabled": true,
        "incoming": "https://mattermost.example.com/hooks/xxx",
        "outgoingToken": "outgoing-token"
      },
      "formatting": {
        "maxMessageLength": 16383,
        "codeBlockStyle": "fenced"
      }
    }
  }
}
```

---

## 🔗 相关链接

- [Mattermost 开发者文档](https://developers.mattermost.com/)
- [Mattermost Bot 账号文档](https://developers.mattermost.com/integrate/reference/bot-accounts/)
- [Mattermost 斜杠命令文档](https://developers.mattermost.com/integrate/reference/slash-commands/)
- [OpenClaw 通道配置指南](https://docs.openclaw.ai/channels)

---

This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License.
