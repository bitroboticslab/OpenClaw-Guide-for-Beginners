<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# 飞书对接教程

> 一步步教你将 OpenClaw 接入飞书，实现随时随地与 AI 助手对话

## 📋 前置要求

- 已完成 OpenClaw 安装和 API 配置
- 飞书账号（个人或企业均可）
- 如使用云服务器，需确保公网可访问

---

## 第一步：创建飞书应用

### 1.1 进入飞书开放平台

访问 [飞书开放平台](https://open.feishu.cn) 并登录。

### 1.2 创建企业自建应用

1. 点击「开发者后台」
2. 点击「创建企业自建应用」
3. 填写应用信息：
   - **应用名称**：AI助手（或你喜欢的名称）
   - **应用描述**：基于 OpenClaw 的 AI 助手
   - **应用图标**：上传一个图标（可选）

### 1.3 记录凭证信息

创建完成后，在「凭证与基础信息」页面记录：
- **App ID**：cli_xxxxxxxxxxxx
- **App Secret**：xxxxxxxxxxxxxxxxxx

---

## 第二步：配置应用权限

### 2.1 添加权限

进入「权限管理」→「权限配置」，添加以下权限：

| 权限名称 | 权限标识 | 用途 |
|----------|----------|------|
| 获取与发送消息 | `im:message` | 接收和发送消息 |
| 以应用身份发消息 | `im:message:send_as_bot` | 以机器人身份回复 |
| 获取用户信息 | `contact:user.base:readonly` | 获取用户基本信息 |
| 接收消息 | `im:message.p2p_msg:readonly` | 接收私聊消息 |
| 群消息 | `im:message.group_msg:readonly` | 接收群消息 |

### 2.2 发布版本

1. 点击「版本管理与发布」
2. 创建版本并发布
3. 等待审核通过（通常几分钟）

---

## 第三步：配置事件订阅

### 3.1 配置请求网址

如果你使用云服务器且有域名：

1. 进入「事件订阅」页面
2. 填写请求网址：`https://你的域名/webhook/feishu`
3. 点击验证（确保 OpenClaw 已启动）

### 3.2 添加事件

在「事件订阅」中添加以下事件：

| 事件名称 | 事件标识 | 说明 |
|----------|----------|------|
| 接收消息 | `im.message.receive_v1` | 接收用户发送的消息 |

---

## 第四步：配置 OpenClaw

### 4.1 方式一：使用配置向导

```bash
openclaw onboard --install-daemon

# 选择消息平台
Select Channel: Feishu (Lark Open Platform)

# 输入 App ID
Enter App ID: cli_xxxxxxxxxxxx

# 输入 App Secret
Enter App Secret: xxxxxxxxxxxxxxxxxx

# 配置回调地址（云服务器部署时填写）
Enter Webhook URL: https://你的域名/webhook/feishu
```

### 4.2 方式二：手动配置

编辑 `~/.openclaw/config.json`：

```json
{
  "channels": {
    "feishu": {
      "enabled": true,
      "app_id": "cli_xxxxxxxxxxxx",
      "app_secret": "xxxxxxxxxxxxxxxxxx",
      "encrypt_key": "",
      "verification_token": ""
    }
  }
}
```

### 4.3 云服务器额外配置

如果使用云服务器，需要配置公网访问：

**使用 Nginx 反向代理：**

```nginx
server {
    listen 443 ssl;
    server_name 你的域名.com;

    ssl_certificate /etc/letsencrypt/live/你的域名.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/你的域名.com/privkey.pem;

    location /webhook/feishu {
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

---

## 第五步：添加应用到飞书

### 5.1 发布应用

1. 在飞书开放平台，确保应用版本已发布
2. 配置「可用性状态」为「所有员工可见」

### 5.2 添加到通讯录

1. 在飞书客户端，进入「通讯录」
2. 搜索你的应用名称
3. 添加应用

### 5.3 开始对话

- 在飞书中找到你的机器人
- 发送消息开始对话
- 机器人会使用 OpenClaw 进行回复

---

## 高级配置

### 群聊配置

1. 创建群组或选择已有群组
2. 点击群设置 → 群机器人 → 添加机器人
3. 选择你创建的应用

> 💡 **提示**：群聊中通常需要 @机器人 才会触发回复

### 自定义机器人名称和头像

在飞书开放平台的「应用信息」中修改：
- 机器人名称
- 机器人头像
- 机器人简介

---

## 常见问题排查

### Q: 消息发送后没有回复？

**排查步骤**：
1. 检查 OpenClaw 服务是否正常运行：`openclaw status`
2. 检查事件订阅是否配置正确
3. 查看日志：`openclaw logs`
4. 确认 API 配置正确且有余额

### Q: 事件订阅验证失败？

**可能原因**：
- OpenClaw 服务未启动
- 防火墙阻止了请求
- 域名 HTTPS 配置问题

**解决方案**：
```bash
# 检查服务状态
openclaw status

# 检查端口是否开放
curl http://localhost:3000/health

# 检查防火墙
ufw status
```

### Q: 权限不足错误？

**解决方案**：
1. 确认所有必要权限已添加
2. 确认应用版本已发布
3. 等待权限生效（可能需要几分钟）

---

## 安全建议

1. **不要泄露 App Secret**
   - 不要提交到公开仓库
   - 使用环境变量存储敏感信息

2. **启用 IP 白名单**（可选）
   - 在飞书开放平台配置 IP 白名单

3. **定期更新密钥**
   - 定期轮换 App Secret

---

## 相关链接

- [飞书开放平台文档](https://open.feishu.cn/document/)
- [飞书机器人文档](https://open.feishu.cn/document/client-docs/bot-v3/bot-overview)
- [OpenClaw 官方文档](https://docs.openclaw.ai)

---

**上一页**：[API 配置详解](../api-config/api-configuration.md) | **下一页**：[钉钉对接教程](dingtalk-integration.md)

<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->
