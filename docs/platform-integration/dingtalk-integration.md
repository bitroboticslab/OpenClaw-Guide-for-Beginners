<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# 钉钉对接教程

> 将 OpenClaw 接入钉钉，打造企业级 AI 助手

## 📋 前置要求

- 钉钉企业账号
- 企业管理员权限
- 已完成 OpenClaw 安装和 API 配置
- 云服务器部署（推荐，需公网访问）

---

## 第一步：创建钉钉应用

### 1.1 进入钉钉开放平台

访问 [钉钉开放平台](https://open.dingtalk.com) 并使用管理员账号登录。

### 1.2 创建企业内部应用

1. 点击「应用开发」→「企业内部开发」
2. 点击「创建应用」
3. 填写应用信息：
   - **应用名称**：AI助手
   - **应用描述**：基于 OpenClaw 的企业 AI 助手
   - **应用图标**：上传图标

### 1.3 记录凭证信息

创建完成后，在应用详情页记录：
- **AppKey**：dingxxxxxxxxxx
- **AppSecret**：xxxxxxxxxxxxxxxxxx

---

## 第二步：配置应用权限

### 2.1 添加必要权限

进入「权限管理」，申请以下权限：

| 权限名称 | 权限标识 | 用途 |
|----------|----------|------|
| 企业内消息通知 | `qyapi_chat_manage` | 发送消息 |
| 通讯录只读权限 | `qyapi_get_member` | 获取用户信息 |
| 企业会话消息 | `qyapi_get_conversation` | 群消息处理 |

### 2.2 发布应用

1. 点击「版本管理与发布」
2. 创建版本
3. 选择可见范围（全员或指定部门）
4. 发布应用

---

## 第三步：配置消息接收

### 3.1 开启 Stream 模式（推荐）

钉钉支持 Stream 模式，无需配置公网回调地址：

1. 在应用详情页，找到「开发管理」
2. 开启「Stream 模式」
3. 记录 Stream 推送地址

### 3.2 配置回调地址（传统模式）

如使用传统 Webhook 模式：

1. 在「开发管理」→「消息推送」
2. 填写请求地址：`https://你的域名/webhook/dingtalk`
3. 配置加解密：
   - **Token**：自定义，如 `OpenClaw2026`
   - **EncodingAESKey**：随机生成或自定义

---

## 第四步：配置 OpenClaw

### 4.1 使用配置向导

```bash
openclaw onboard --install-daemon

# 选择消息平台
Select Channel: DingTalk

# 输入 AppKey
Enter AppKey: dingxxxxxxxxxx

# 输入 AppSecret
Enter AppSecret: xxxxxxxxxxxxxxxxxx

# 选择连接模式
Select Mode: 
  1. Stream (推荐，无需公网IP)
  2. Webhook (需要公网访问)

# 如选择 Webhook，输入回调配置
Enter Token: OpenClaw2026
Enter EncodingAESKey: xxx
```

### 4.2 手动配置

编辑 `~/.openclaw/config.json`：

```json
{
  "channels": {
    "dingtalk": {
      "enabled": true,
      "app_key": "dingxxxxxxxxxx",
      "app_secret": "xxxxxxxxxxxxxxxxxx",
      "mode": "stream",
      "token": "",
      "encoding_aes_key": ""
    }
  }
}
```

---

## 第五步：测试和使用

### 5.1 启动服务

```bash
openclaw start

# 查看日志确认连接成功
openclaw logs -f
```

### 5.2 在钉钉中使用

**单聊**：
1. 打开钉钉，进入「工作台」
2. 找到你创建的应用
3. 点击进入，发送消息

**群聊**：
1. 创建或选择一个群组
2. 点击群设置 → 群机器人
3. 添加你的应用机器人
4. @机器人 发送消息

---

## 高级配置

### 配置机器人名称和头像

在钉钉开放平台「应用信息」中修改：
- 机器人名称
- 机器人头像
- 机器人简介

### 配置消息卡片

钉钉支持丰富的消息卡片格式：

```json
{
  "msgtype": "actionCard",
  "actionCard": {
    "title": "AI助手回复",
    "text": "### 回复内容\n\n这是AI的回复...",
    "btnOrientation": "0",
    "singleTitle": "查看详情",
    "singleURL": "https://example.com"
  }
}
```

### 多群配置

可以为不同群组配置不同的行为：

```json
{
  "channel_settings": {
    "dingtalk": {
      "groups": {
        "chatxxx": {
          "model": "qwen-plus",
          "system_prompt": "你是一个项目助手"
        },
        "chatyyy": {
          "model": "deepseek-v3",
          "system_prompt": "你是一个客服助手"
        }
      }
    }
  }
}
```

---

## 常见问题排查

### Q: Stream 模式连接失败？

**排查步骤**：
1. 检查 AppKey 和 AppSecret 是否正确
2. 确认应用已发布
3. 查看日志错误信息
4. 确认网络连接正常

### Q: 消息发送成功但收不到回复？

**可能原因**：
- 权限配置不完整
- AI 模型响应失败
- 消息格式错误

**解决方案**：
```bash
# 查看详细日志
openclaw logs -f --debug

# 测试 AI 连接
openclaw test --ai
```

### Q: 群消息没有触发回复？

**检查项**：
1. 确认机器人已添加到群
2. 确认使用了 @机器人
3. 检查群消息权限配置

---

## 与飞书的对比

| 特性 | 钉钉 | 飞书 |
|------|------|------|
| 配置难度 | 中等 | 简单 |
| Stream 模式 | ✅ 支持 | ✅ 支持 |
| 消息卡片 | ✅ 丰富 | ✅ 丰富 |
| 企业整合 | 审批、日程等 | 文档、会议等 |
| 权限管理 | 较严格 | 较宽松 |

---

## 相关链接

- [钉钉开放平台文档](https://open.dingtalk.com/document/)
- [钉钉机器人文档](https://open.dingtalk.com/document/robots/custom-robot-access)
- [OpenClaw 官方文档](https://docs.openclaw.ai)

---

## 💰 优惠链接

| 平台 | 链接 | 优惠 |
|------|------|------|
| 阿里百炼 | [开通链接](https://bailian.console.aliyun.com) | 与钉钉同生态，整合更方便 |
| 硅基流动 | [注册链接](https://cloud.siliconflow.cn/i/lva59yow) | 注册送 2000万 Tokens |

---

**上一页**：[平台对接总览](platform-integration-overview.md) | **下一页**：[Telegram 对接教程](telegram-integration.md)

<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->
