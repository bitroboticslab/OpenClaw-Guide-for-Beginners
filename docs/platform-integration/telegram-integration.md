<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# Telegram 对接教程

> 将 OpenClaw 接入 Telegram，配置最简单的消息平台对接

## 📋 前置要求

- Telegram 账号
- 已完成 OpenClaw 安装和 API 配置
- 公网可访问的服务器（可选，推荐使用 Webhook 模式）

---

## 为什么选择 Telegram？

- ✅ **配置最简单**：无需审核，几分钟即可完成
- ✅ **无需企业认证**：个人账号即可创建机器人
- ✅ **功能强大**：支持丰富的消息格式、内联按钮等
- ✅ **全球可用**：海外用户首选

---

## 第一步：创建 Telegram 机器人

### 1.1 找到 BotFather

1. 打开 Telegram
2. 搜索 `@BotFather`
3. 点击进入 BotFather 对话

### 1.2 创建新机器人

发送以下命令：

```
/newbot
```

BotFather 会引导你完成创建：

```
BotFather: Alright, a new bot. How are we going to call it? 
Please choose a name for your bot.

你: My AI Assistant

BotFather: Good. Now let's choose a username for your bot. 
It must end in `bot`. Like this, for example: TetrisBot or tetris_bot.

你: my_ai_assistant_bot

BotFather: Congratulations! Your bot has been created...
```

### 1.3 保存 Bot Token

创建成功后，BotFather 会返回类似以下内容：

```
Done! Congratulations on your new bot...
Use this token to access the HTTP API:
1234567890:AAHdqTcvCH1vGWJxfSeofSAs0K5PALDsaw

Keep your token secure...
```

**重要**：请妥善保存这个 Token，这是你的机器人凭证！

---

## 第二步：配置 OpenClaw

### 2.1 使用配置向导

```bash
openclaw onboard --install-daemon

# 选择消息平台
Select Channel: Telegram

# 输入 Bot Token
Enter Bot Token: 1234567890:AAHdqTcvCH1vGWJxfSeofSAs0K5PALDsaw

# 选择连接模式
Select Mode:
  1. Webhook (推荐，需要公网服务器)
  2. Polling (本地开发，无需公网)
```

### 2.2 手动配置

编辑 `~/.openclaw/config.json`：

```json
{
  "channels": {
    "telegram": {
      "enabled": true,
      "bot_token": "1234567890:AAHdqTcvCH1vGWJxfSeofSAs0K5PALDsaw",
      "mode": "webhook",
      "webhook_url": "https://你的域名/webhook/telegram"
    }
  }
}
```

---

## 第三步：设置 Webhook（推荐模式）

### 3.1 云服务器配置

如果你使用云服务器，配置 Webhook：

```bash
# 确保 OpenClaw 服务已启动
openclaw start

# 自动设置 Webhook
openclaw telegram set-webhook https://你的域名/webhook/telegram
```

### 3.2 手动设置 Webhook

```bash
# 使用 curl 设置 Webhook
curl -X POST "https://api.telegram.org/bot你的TOKEN/setWebhook" \
  -H "Content-Type: application/json" \
  -d '{"url": "https://你的域名/webhook/telegram"}'
```

### 3.3 验证 Webhook

```bash
# 查看当前 Webhook 状态
curl "https://api.telegram.org/bot你的TOKEN/getWebhookInfo"
```

---

## 第四步：测试机器人

### 4.1 启动服务

```bash
openclaw start

# 查看日志
openclaw logs -f
```

### 4.2 发送消息测试

1. 在 Telegram 中搜索你的机器人用户名
2. 点击「Start」开始对话
3. 发送任意消息测试

---

## Polling 模式（本地开发）

如果本地开发，没有公网 IP，可以使用 Polling 模式：

```json
{
  "channels": {
    "telegram": {
      "enabled": true,
      "bot_token": "你的TOKEN",
      "mode": "polling",
      "polling_interval": 1000
    }
  }
}
```

启动后，机器人会主动轮询 Telegram 服务器获取新消息。

---

## 高级配置

### 配置机器人命令

在 BotFather 中设置命令菜单：

```
/setcommands

你: 
start - 开始对话
help - 获取帮助
clear - 清除对话历史
settings - 设置选项
```

### 配置机器人描述

```
/setdescription

你: 这是一个基于 OpenClaw 的 AI 助手，可以帮助你回答问题、执行任务。
```

### 配置欢迎消息

在 OpenClaw 中配置：

```json
{
  "channels": {
    "telegram": {
      "welcome_message": "你好！我是 AI 助手，有什么可以帮你的？"
    }
  }
}
```

### 内联按钮

支持发送带按钮的消息：

```json
{
  "inline_keyboard": [
    [
      {"text": "查询天气", "callback_data": "weather"},
      {"text": "设置提醒", "callback_data": "reminder"}
    ],
    [
      {"text": "帮助", "callback_data": "help"}
    ]
  ]
}
```

---

## 群组使用

### 将机器人添加到群组

1. 打开群组设置
2. 点击「添加成员」
3. 搜索并添加你的机器人
4. 将机器人设为管理员（可选，但推荐）

### 群消息触发

在群组中，需要 @机器人 才会触发回复：

```
@my_ai_assistant_bot 今天天气怎么样？
```

---

## 常见问题排查

### Q: Webhook 设置失败？

**可能原因**：
- 域名未配置 HTTPS
- 服务器防火墙阻止
- Token 错误

**解决方案**：
```bash
# 检查 HTTPS
curl -I https://你的域名/webhook/telegram

# 删除 Webhook 后重新设置
curl "https://api.telegram.org/bot你的TOKEN/deleteWebhook"
```

### Q: 机器人不回复？

**排查步骤**：
1. 检查服务是否运行：`openclaw status`
2. 查看日志：`openclaw logs -f`
3. 确认 Token 正确
4. 检查 AI 模型配置

### Q: Polling 模式延迟高？

**解决方案**：
- 减小 polling_interval
- 使用 Webhook 模式

---

## 隐私与安全

### 隐私模式

默认情况下，机器人只能看到：
- @它的消息
- 回复它消息的消息
- 命令消息（以 / 开头）

如需关闭隐私模式：

```bash
# 在 BotFather 中
/setprivacy

选择你的机器人 → Disable
```

### 安全建议

1. **保护 Token**：不要泄露给他人
2. **使用 HTTPS**：Webhook 必须使用 HTTPS
3. **验证请求**：验证请求来自 Telegram

---

## 相关链接

- [Telegram Bot API 文档](https://core.telegram.org/bots/api)
- [BotFather 使用指南](https://core.telegram.org/bots#botfather)
- [OpenClaw 官方文档](https://docs.openclaw.ai)

---

## 💰 优惠链接

| 平台 | 链接 | 优惠 |
|------|------|------|
| 硅基流动 | [注册链接](https://cloud.siliconflow.cn/i/lva59yow) | 注册送 2000万 Tokens |
| 火山方舟 | [Coding Plan](https://volcengine.com/L/tHxxM_WwYp4/) | 首月 8.91 元起 |
| 智谱 GLM | [订阅链接](https://www.bigmodel.cn/glm-coding?ic=BUDVTRHUYH) | 年付 7 折 |

---

**上一页**：[钉钉对接教程](dingtalk-integration.md) | **下一页**：[微信对接教程](wechat-integration.md)

<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->
