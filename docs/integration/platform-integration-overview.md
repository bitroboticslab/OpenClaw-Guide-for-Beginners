<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# 平台对接教程

> OpenClaw 支持多种消息平台对接，选择你需要的平台进行配置

## 📋 支持平台一览

| 平台 | 对接难度 | 推荐指数 | 教程链接 | 特点 |
|------|----------|----------|----------|------|
| 飞书 | ⭐⭐ | ⭐⭐⭐⭐⭐ | [详细教程](feishu-integration.md) | 企业协作，功能丰富 |
| 钉钉 | ⭐⭐ | ⭐⭐⭐⭐ | [详细教程](dingtalk-integration.md) | 企业办公，集成度高 |
| Telegram | ⭐ | ⭐⭐⭐⭐ | [详细教程](telegram-integration.md) | 海外首选，配置简单 |
| 微信 | ⭐⭐⭐ | ⭐⭐⭐ | [详细教程](wechat-integration.md) | 用户基数大，门槛较高 |
| Discord | ⭐⭐ | ⭐⭐⭐ | [详细教程](discord.md) | 游戏社区，年轻用户 |
| WhatsApp | ⭐⭐ | ⭐⭐⭐ | [详细教程](whatsapp.md) | 海外通讯主力 |

---

## 🎯 如何选择？

### 国内用户推荐

1. **飞书**（首选）
   - 配置简单，文档完善
   - 支持丰富的消息格式
   - 企业级安全保障
   - 免费使用

2. **钉钉**
   - 与企业办公深度整合
   - 审批、日程等功能联动
   - 阿里生态兼容性好

3. **微信**
   - 用户基数最大
   - 无需额外安装
   - 配置门槛较高（需要企业认证）

### 海外用户推荐

1. **Telegram**（首选）
   - 配置最简单
   - 无需审核
   - 功能强大

2. **Discord**
   - 社区属性强
   - 支持 Slash 命令
   - 游戏用户友好

3. **WhatsApp**
   - 用户量大
   - Business API 支持

---

## 🚀 快速对接流程

### 通用步骤

1. **注册开发者账号**
   - 访问对应平台开放平台
   - 创建开发者应用

2. **获取凭证信息**
   - App ID / Token
   - App Secret / Key
   - Webhook 地址

3. **配置 OpenClaw**
   ```bash
   openclaw onboard --install-daemon
   # 选择对应的消息平台
   # 输入凭证信息
   ```

4. **测试连接**
   ```bash
   openclaw test --channel feishu
   ```

5. **启动服务**
   ```bash
   openclaw gateway start
   ```

---

## 📱 平台对接详解

### 飞书对接

**准备工作**：
- 飞书账号（个人或企业）
- 开放平台访问权限

**核心配置**：
1. 创建企业自建应用
2. 配置消息接收权限
3. 设置事件订阅地址

👉 [查看完整教程](feishu-integration.md)

---

### 钉钉对接

**准备工作**：
- 钉钉企业账号
- 管理员权限

**核心配置**：
1. 创建企业内部机器人
2. 配置消息回调地址
3. 设置加解密参数

👉 [查看完整教程](dingtalk-integration.md)

---

### Telegram 对接

**准备工作**：
- Telegram 账号
- BotFather 创建机器人

**核心配置**：
1. 通过 BotFather 创建机器人
2. 获取 Bot Token
3. 配置 Webhook

👉 [查看完整教程](telegram-integration.md)

---

### 微信对接

**准备工作**：
- 微信企业认证（或服务号）
- 服务器公网访问

**核心配置**：
1. 创建企业微信应用或公众号
2. 配置服务器地址
3. 设置消息加解密

👉 [查看完整教程](wechat-integration.md)

---

## 🔧 高级配置

### 多平台同时对接

OpenClaw 支持同时对接多个平台：

```bash
# 配置第一个平台
openclaw onboard --install-daemon --add-channel

# 添加更多平台
openclaw onboard --install-daemon --add-channel
```

配置文件示例：

```json
{
  "channels": {
    "feishu": {
      "enabled": true,
      "app_id": "cli_xxx",
      "app_secret": "xxx"
    },
    "telegram": {
      "enabled": true,
      "bot_token": "xxx"
    },
    "dingtalk": {
      "enabled": false,
      "app_key": "xxx",
      "app_secret": "xxx"
    }
  }
}
```

### 消息路由配置

可以配置不同平台使用不同的 AI 模型：

```json
{
  "routing": {
    "feishu": {
      "model": "qwen-plus",
      "system_prompt": "你是一个专业的企业助手"
    },
    "telegram": {
      "model": "deepseek-v3",
      "system_prompt": "You are a helpful assistant"
    }
  }
}
```

---

## 🔍 常见问题

### Q: 对接后收不到消息？

**排查步骤**：
1. 检查服务是否正常运行
2. 确认 Webhook 地址配置正确
3. 检查平台权限设置
4. 查看日志：`openclaw logs`

### Q: 消息回复延迟？

**可能原因**：
- AI 模型响应时间长
- 网络延迟
- 服务器性能不足

**解决方案**：
- 使用响应更快的模型
- 优化网络环境
- 升级服务器配置

### Q: 如何处理消息加密？

各平台消息加密配置：

| 平台 | 加密方式 | 配置方法 |
|------|----------|----------|
| 飞书 | Encrypt Key | 应用配置页获取 |
| 钉钉 | AES 加解密 | 配置 EncodingAESKey |
| 微信 | 消息加解密 | 公众平台配置 |

---

## 📚 相关教程

- [API 配置详解](../api-config/api-configuration.md) - AI 模型配置
- [云服务器部署](../cloud/cloud-deployment-guide.md) - 公网访问配置
- [OpenClaw 官方文档](https://docs.openclaw.ai)

---

**上一页**：[API 配置详解](../api-config/api-configuration.md) | **下一页**：[飞书对接教程](feishu-integration.md)

<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->
