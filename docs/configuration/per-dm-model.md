<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# Per-DM 模型覆盖配置

> 为不同的私信（DM）对话设置独立的 AI 模型，实现精细化的模型路由

**适用版本**：OpenClaw v2026.6.11-beta 及以上

---

## 📋 功能简介

Per-DM Model Override（私信模型覆盖）是 v2026.6.11-beta 引入的新功能，允许用户为不同的 DM 对话指定不同的 AI 模型。这意味着你可以：

- 对不同联系人使用不同能力的模型
- 根据对话场景灵活选择模型
- 在不修改全局配置的情况下按需切换

| 特性 | 说明 |
|------|------|
| 按对话配置 | 每个 DM 对话可独立设置模型 |
| 全局回退 | 未配置的对话使用全局默认模型 |
| 动态切换 | 支持运行时切换模型 |
| 多通道支持 | Telegram、飞书、微信等所有支持 DM 的通道 |

---

## 配置方法

### 基础配置

在 `~/.openclaw/config.json` 中添加 `dmModelOverrides` 配置：

```json
{
  "models": {
    "default": "gpt-4o",
    "dmModelOverrides": {
      "telegram:user:123456789": "claude-sonnet-4",
      "telegram:user:987654321": "deepseek-r1",
      "feishu:user:ou_abc123": "gpt-4o-mini",
      "wechat:user|wxid_abc123": "qwen-max"
    }
  }
}
```

### 配置项说明

| 配置项 | 类型 | 说明 |
|--------|------|------|
| `models.default` | string | 全局默认模型 |
| `dmModelOverrides` | object | DM 模型覆盖映射表 |

### 用户标识格式

不同通道的用户标识格式不同：

| 通道 | 格式 | 示例 |
|------|------|------|
| Telegram | `telegram:user:{user_id}` | `telegram:user:123456789` |
| 飞书 | `feishu:user:{open_id}` | `feishu:user:ou_abc123` |
| 微信 | `wechat:user\|{wxid}` | `wechat:user|wxid_abc123` |
| Slack | `slack:user:{user_id}` | `slack:user:U01ABCDEF` |
| Mattermost | `mattermost:user:{user_id}` | `mattermost:user:abc123def` |
| QQ | `qq:user:{qq_number}` | `qq:user:1234567890` |

---

## 使用方法

### 方法一：通过配置文件设置

直接编辑 `~/.openclaw/config.json`，在 `dmModelOverrides` 中添加映射：

```json
{
  "models": {
    "default": "gpt-4o",
    "dmModelOverrides": {
      "telegram:user:123456789": "claude-sonnet-4"
    }
  }
}
```

保存后重启 gateway 生效：

```bash
openclaw gateway restart
```

### 方法二：通过命令动态设置

在与机器人的 DM 对话中使用 `/model` 命令：

```
# 查看当前对话使用的模型
/model

# 切换当前对话的模型
/model claude-sonnet-4

# 重置为全局默认模型
/model default
```

### 方法三：通过 CLI 设置

```bash
# 为指定用户设置模型
openclaw dm model set telegram:user:123456789 claude-sonnet-4

# 查看所有 DM 模型覆盖
openclaw dm model list

# 移除指定用户的模型覆盖
openclaw dm model unset telegram:user:123456789
```

---

## 使用场景

### 场景一：不同联系人使用不同模型

为重要客户使用更强的模型，普通联系人使用轻量模型：

```json
{
  "models": {
    "default": "gpt-4o-mini",
    "dmModelOverrides": {
      "telegram:user:VIP_USER_ID": "gpt-4o",
      "telegram:user:VIP_USER_ID_2": "claude-sonnet-4"
    }
  }
}
```

### 场景二：根据对话用途选择模型

```json
{
  "models": {
    "default": "gpt-4o",
    "dmModelOverrides": {
      "telegram:user:CODE_USER_ID": "deepseek-r1",
      "telegram:user:WRITE_USER_ID": "claude-sonnet-4",
      "telegram:user:MATH_USER_ID": "deepseek-r1"
    }
  }
}
```

### 场景三：测试不同模型效果

同时配置多个模型，对比不同联系人的对话效果：

```json
{
  "models": {
    "default": "gpt-4o",
    "dmModelOverrides": {
      "telegram:user:TESTER_1": "claude-sonnet-4",
      "telegram:user:TESTER_2": "deepseek-r1",
      "telegram:user:TESTER_3": "qwen-max"
    }
  }
}
```

---

## 优先级规则

模型选择的优先级（从高到低）：

| 优先级 | 来源 | 说明 |
|--------|------|------|
| 1 | 用户命令 `/model` | 用户在对话中手动切换 |
| 2 | DM 模型覆盖 | `dmModelOverrides` 中的配置 |
| 3 | 频道模型配置 | 通道级别的模型配置 |
| 4 | 全局默认模型 | `models.default` |

---

## 🔧 常见问题

### 如何查找用户的标识？

```bash
# 查看最近的对话记录，其中包含用户标识
openclaw sessions list --recent

# 或在日志中查找
openclaw channels logs --grep "user_id"
```

### 设置后不生效？

```bash
# 确认配置已保存
openclaw config get models.dmModelOverrides

# 重启 gateway
openclaw gateway restart

# 验证当前对话的模型
openclaw dm model check telegram:user:123456789
```

### 支持群聊模型覆盖吗？

Per-DM Model Override 仅适用于私信（DM）对话。群聊模型配置请使用 `channelModelOverrides`：

```json
{
  "models": {
    "channelModelOverrides": {
      "telegram:group:-100123456": "gpt-4o"
    }
  }
}
```

---

## 🔗 相关链接

- [模型配置指南](https://docs.openclaw.ai/models)
- [Provider 路由配置](https://docs.openclaw.ai/providers)
- [OpenClaw 命令参考](https://docs.openclaw.ai/commands)

---

This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License.
