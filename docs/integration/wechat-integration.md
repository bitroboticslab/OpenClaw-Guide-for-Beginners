<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# 微信对接教程

> 将 OpenClaw 接入微信，覆盖最广泛的用户群体

## 📋 前置要求

- 微信企业认证 或 微信服务号
- 公网可访问的服务器（必须）
- 已完成 OpenClaw 安装和 API 配置
- 域名并配置 HTTPS（必须）

---

## 对接方式选择

微信对接有两种主要方式：

| 方式 | 门槛 | 用户覆盖 | 推荐场景 |
|------|------|----------|----------|
| 企业微信 | 需企业认证 | 企业内部 | 企业办公场景 |
| 微信服务号 | 需服务号认证 | 所有微信用户 | 对外服务 |

> ⚠️ **注意**：个人订阅号无法使用消息接口，必须使用企业微信或服务号。

---

## 方式一：企业微信对接

### 第一步：创建企业微信应用

1. 登录 [企业微信管理后台](https://work.weixin.qq.com/)

2. 进入「应用管理」→「自建」→「创建应用」

3. 填写应用信息：
   - **应用名称**：AI助手
   - **应用logo**：上传图标
   - **可见范围**：选择部门或全员

4. 记录凭证信息：
   - **AgentId**：1000001
   - **Secret**：xxxxxxxxxxxxxxxxxx

### 第二步：配置企业信息

在企业微信管理后台「我的企业」页面记录：
- **企业ID (CorpID)**：wwxxxxxxxxxxxx

### 第三步：设置可信域名

1. 进入应用详情页
2. 点击「企业可信IP」
3. 配置你的服务器 IP

### 第四步：配置消息接收

1. 进入应用「接收消息」设置
2. 设置 URL：`https://你的域名/webhook/wechat`
3. 设置 Token 和 EncodingAESKey
4. 保存配置

### 第五步：配置 OpenClaw

```bash
openclaw onboard --install-daemon

Select Channel: WeChat Work (企业微信)

# 输入企业ID
Enter CorpID: wwxxxxxxxxxxxx

# 输入应用AgentId
Enter AgentID: 1000001

# 输入应用Secret
Enter Secret: xxxxxxxxxxxxxxxxxx

# 输入Token
Enter Token: OpenClaw2026

# 输入EncodingAESKey
Enter EncodingAESKey: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

---

## 方式二：微信服务号对接

### 第一步：准备服务号

1. 确保拥有已认证的微信服务号
2. 登录 [微信公众平台](https://mp.weixin.qq.com/)

### 第二步：配置服务器

1. 进入「设置与开发」→「基本配置」
2. 记录 **AppID** 和 **AppSecret**
3. 配置 IP 白名单（你的服务器 IP）

### 第三步：配置消息接口

1. 进入「设置与开发」→「基本配置」→「服务器配置」
2. 填写配置：
   - **URL**：`https://你的域名/webhook/wechat`
   - **Token**：自定义，如 OpenClaw2026
   - **EncodingAESKey**：随机生成
   - **消息加解密方式**：安全模式（推荐）

3. 点击提交（需要 OpenClaw 服务已启动）

### 第四步：配置 OpenClaw

```bash
openclaw onboard --install-daemon

Select Channel: WeChat Official Account (微信公众号)

# 输入AppID
Enter AppID: wxxxxxxxxxxx

# 输入AppSecret
Enter AppSecret: xxxxxxxxxxxxxxxxxx

# 输入Token
Enter Token: OpenClaw2026

# 输入EncodingAESKey
Enter EncodingAESKey: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

---

## 微信特殊配置

### 处理菜单命令

微信公众号可以配置自定义菜单：

```json
{
  "menu": {
    "button": [
      {
        "type": "click",
        "name": "开始对话",
        "key": "START_CHAT"
      },
      {
        "type": "click",
        "name": "清除历史",
        "key": "CLEAR_HISTORY"
      },
      {
        "type": "click",
        "name": "使用帮助",
        "key": "HELP"
      }
    ]
  }
}
```

创建菜单：

```bash
# OpenClaw 提供菜单创建命令
openclaw wechat create-menu
```

### 处理事件消息

微信会推送多种事件：

| 事件类型 | 说明 | 处理建议 |
|----------|------|----------|
| subscribe | 用户关注 | 发送欢迎消息 |
| unsubscribe | 用户取关 | 记录日志 |
| CLICK | 菜单点击 | 执行对应操作 |
| text | 文本消息 | 转发 AI 处理 |

### 客服消息

对于 48 小时内互动过的用户，可以主动发送消息：

```bash
openclaw wechat send --user openid --message "您的任务已完成"
```

---

## 微信限制说明

### 消息限制

| 类型 | 限制 |
|------|------|
| 被动回复消息 | 必须在 5 秒内响应 |
| 客服消息 | 用户 48 小时内互动过才能发送 |
| 模板消息 | 需要申请模板，有日限额 |
| 群发消息 | 订阅号每天1次，服务号每月4次 |

### 应对策略

1. **异步处理**：
   - 收到消息立即返回 success
   - 通过客服消息接口异步回复

2. **长消息处理**：
   - 超过 5 秒的任务先返回「处理中」
   - 完成后通过客服消息发送结果

---

## Nginx 配置示例

```nginx
server {
    listen 443 ssl http2;
    server_name your-domain.com;

    ssl_certificate /etc/letsencrypt/live/your-domain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/your-domain.com/privkey.pem;

    location /webhook/wechat {
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # 微信要求 5 秒响应
        proxy_read_timeout 5s;
    }
}
```

---

## 常见问题排查

### Q: 服务器配置验证失败？

**可能原因**：
- 服务未启动
- 域名未备案
- HTTPS 配置问题
- Token 不一致

**解决方案**：
```bash
# 检查服务状态
openclaw status

# 测试接口
curl -X GET "https://你的域名/webhook/wechat?signature=xxx&timestamp=xxx&nonce=xxx&echostr=test"

# 查看日志
openclaw logs -f
```

### Q: 消息发送成功但无回复？

**排查步骤**：
1. 检查是否在 5 秒内响应
2. 查看日志是否有错误
3. 确认 AI 模型配置正确
4. 检查消息格式是否正确

### Q: 出现"该公众号暂时无法提供服务"？

**原因**：服务器未在 5 秒内返回有效响应

**解决方案**：
- 使用异步处理模式
- 优化 AI 响应速度
- 使用更快的模型

---

## 相关链接

- [微信公众平台开发文档](https://developers.weixin.qq.com/doc/offiaccount/Getting_Started/Overview.html)
- [企业微信开发文档](https://developer.work.weixin.qq.com/document/)
- [OpenClaw 官方文档](https://docs.openclaw.ai)

---

## 💰 优惠链接

| 平台 | 链接 | 优惠 |
|------|------|------|
| 阿里百炼 | [开通链接](https://bailian.console.aliyun.com) | 与微信生态兼容性好 |
| 硅基流动 | [注册链接](https://cloud.siliconflow.cn/i/lva59yow) | 注册送 2000万 Tokens |

---

**上一页**：[Telegram 对接教程](telegram-integration.md) | **返回**：[平台对接总览](platform-integration-overview.md)

<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->
