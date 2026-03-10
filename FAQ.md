<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# 常见问题 (FAQ)

> OpenClaw使用中的常见问题和解答

---

## 📋 目录

- [快速导航](#-快速导航)
- [安装与启动](#-安装与启动)
- [API相关](#-api相关)
- [配置问题](#-配置问题)
- [平台对接](#-平台对接)
- [性能优化](#-性能优化)
- [成本控制](#-成本控制)
- [安全问题](#-安全问题)
- [高级功能](#-高级功能)
- [获取帮助](#-获取帮助)

---

## 🏷️ 快速导航

| 问题类型 | 优先查看 | 难度 | 预计时间 |
|---------|---------|------|---------|
| 刚安装，想快速开始 | [5分钟快速上手](docs/start/quickstart.md) | ⭐ | 5分钟 |
| API报错，无法使用 | [如何选择API平台](#q-哪个api平台最推荐) | ⭐⭐ | 3分钟 |
| 配置失败，找不到原因 | [如何解决配置错误](#q-如何解决配置错误) | ⭐⭐ | 5分钟 |
| 钉钉/飞书对接失败 | [如何对接钉钉](#q-如何对接钉钉) | ⭐⭐ | 10分钟 |
| 成本过高，想优化 | [如何降低成本](#q-如何降低api使用成本) | ⭐⭐⭐ | 15分钟 |
| 响应慢，体验不佳 | [如何提升响应速度](#) | ⭐⭐ | 8分钟 |
| 想要更多功能 | [如何使用Skills](#q-如何安装和使用skills) | ⭐⭐⭐ | 20分钟 |

---

## 🚀 安装与启动

### Q: 如何安装OpenClaw？

**A:** 根据你的系统选择对应方式：

| 平台 | 命令 | 适用场景 |
|------|------|---------|
| Windows | `npm install -g openclaw@latest` | Windows 10/11 |
| macOS | `npm install -g openclaw@latest` | macOS 12+ |
| Linux | `npm install -g openclaw@latest` | Ubuntu/CentOS等 |
| Docker | `docker pull openclaw/openclaw` | 容器化部署 |

<details>
<summary><b>💻 Windows详细安装</b></summary>

```powershell
# 1. 安装Node.js (v22+)
# 下载: https://nodejs.org/

# 2. 安装OpenClaw
npm install -g openclaw@latest

# 3. 验证安装
openclaw --version
```

✅ 预期输出: `OpenClaw CLI v2026.2.x`

</details>

<details>
<summary><b>🐧 macOS/Linux详细安装</b></summary>

```bash
# 1. 使用nvm安装Node.js（推荐）
nvm install 22
nvm use 22

# 2. 安装OpenClaw
npm install -g openclaw@latest

# 3. 验证安装
openclaw --version
```

✅ 预期输出: `OpenClaw CLI v2026.2.x`

</details>

---

### Q: 安装后如何验证？

**A:** 运行以下命令：

```bash
# 检查版本
openclaw --version

# 检查配置
openclaw config validate

# 检查Gateway状态
openclaw gateway gateway status
```

✅ 成功标志:
- 看到版本号（如 `OpenClaw CLI v2026.2.x`）
- 配置验证通过
- Gateway状态显示为running

---

### Q: Gateway启动失败怎么办？

**A:** 按照以下步骤排查：

#### 步骤1: 检查端口占用

```bash
# macOS/Linux
lsof -i :18789

# Windows
netstat -ano | findstr :18789
```

⚠️ 如果端口被占用，关闭占用进程或更换端口

---

#### 步骤2: 检查配置文件

```bash
# 验证配置
openclaw config validate
```

❌ 如果提示配置错误，检查 `~/.openclaw/openclaw.json` 格式

---

#### 步骤3: 查看日志

```bash
# 查看最近50行日志
openclaw logs --tail 50
```

查找错误信息，根据错误类型采取对应措施

---

#### 步骤4: 重新初始化

```bash
# 备份配置
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.backup

# 重新初始化
openclaw init
```

---

<details>
<summary><b>🔍 详细排查步骤</b></summary>

如果以上步骤无法解决问题，查看[故障排除](docs/advanced/troubleshooting.md)获取完整排查指南。
</details>

---

## 🔑 API相关

### Q: 哪个API平台最推荐？

**A:** 根据不同需求推荐：

| 需求 | 推荐平台 | 优势 | 价格 | 链接 |
|------|---------|------|------|------|
| ![新手](https://img.shields.io/badge/新手-推荐-green) | 硅基流动 | 2000万Tokens免费 | 🆓 免费 | [注册](https://cloud.siliconflow.cn/i/lva59yow) |
| ![性价比](https://img.shields.io/badge/性价比-高-blue) | 火山引擎 | 4款模型，工具不限 | 💰 8.9元/月 | [订阅](https://volcengine.com/L/oqijuWrltl0/  ) |
| ![编程](https://img.shields.io/badge/编程-友好-orange) | 智谱GLM | Claude Code支持 | 💰 优惠价 | [开通](https://www.bigmodel.cn/glm-coding?ic=BUDVTRHUYH) |
| ![阿里生态](https://img.shields.io/badge/阿里-生态-purple) | 阿里百炼 | 与阿里云整合 | 💰 7.9元/月 | [开通](https://www.aliyun.com/benefit/ai/aistar?userCode=yyzsc1al&clubBiz=subTask..12385059..10263..) |

---

### Q: 如何配置多个API提供商？

**A:** 编辑配置文件 `~/.openclaw/openclaw.json`:

```json
{
  "models": {
    "providers": [
      {
        "providerId": "siliconflow",
        "apiKey": "sk-你的硅基流动API密钥",
        "models": [
          {
            "id": "Qwen/Qwen2.5-72B-Instruct",
            "primary": true
          }
        ]
      },
      {
        "providerId": "volcengine",
        "apiKey": "AK-你的火山引擎API密钥",
        "models": [
          {
            "id": "doubao-pro-32k"
          }
        ]
      }
    ]
  }
}
```

✅ 配置后可以切换使用不同的模型

---

### Q: API Key泄露了怎么办？

**A:** 立即执行以下操作：

1. ⚠️ **立即撤销旧Key**
   - 登录API平台控制台
   - 找到对应的API Key
   - 点击撤销/删除

2. ✅ **创建新Key**
   - 在控制台创建新的API Key
   - 复制新Key到OpenClaw配置

3. 🔒 **更新配置**
   ```bash
   # 编辑配置文件
   nano ~/.openclaw/openclaw.json
   ```

4. 🔄 **重启Gateway**
   ```bash
   openclaw gateway restart
   ```

---

## 🔧 配置问题

### Q: 如何解决配置错误？

**A:** 常见配置错误和解决方案：

| 错误信息 | 可能原因 | 解决方案 |
|---------|---------|---------|
| `Invalid API key` | API Key错误或过期 | 重新获取API Key |
| `Configuration file not found` | 配置文件不存在 | 运行 `openclaw init` |
| `Invalid JSON format` | JSON格式错误 | 检查语法，使用JSON验证器 |
| `Model not found` | 模型ID错误 | 检查模型ID是否正确 |

---

#### 验证配置文件

```bash
# 验证配置
openclaw config validate
```

✅ 成功输出: `✓ Configuration is valid`

❌ 失败输出: 查看错误信息并修正

---

### Q: 如何备份和恢复配置？

**A:** 使用以下命令：

#### 备份配置

```bash
# 备份整个OpenClaw目录
cp -r ~/.openclaw ~/.openclaw.backup

# 或只备份配置文件
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.backup
```

---

#### 恢复配置

```bash
# 恢复整个OpenClaw目录
rm -rf ~/.openclaw
cp -r ~/.openclaw.backup ~/.openclaw

# 或只恢复配置文件
cp ~/.openclaw/openclaw.json.backup ~/.openclaw/openclaw.json
```

---

### Q: 如何自定义模型参数？

**A:** 编辑配置文件，添加参数：

```json
{
  "models": {
    "providers": [
      {
        "providerId": "siliconflow",
        "apiKey": "sk-你的API密钥",
        "models": [
          {
            "id": "Qwen/Qwen2.5-72B-Instruct",
            "primary": true,
            "maxTokens": 4096,
            "temperature": 0.7,
            "topP": 0.9,
            "systemPrompt": "你是一个专业的AI助手"
          }
        ]
      }
    ]
  }
}
```

**参数说明**:

| 参数 | 说明 | 推荐值 |
|------|------|--------|
| `maxTokens` | 最大生成Token数 | 2048-8192 |
| `temperature` | 随机性（0-1） | 0.7（平衡） |
| `topP` | 核采样（0-1） | 0.9 |
| `systemPrompt` | 系统提示词 | 根据需求自定义 |

---

## 💬 平台对接

### Q: 如何对接钉钉？

**A:** 按照以下步骤：

#### 前置条件

- ✅ 已安装OpenClaw
- ✅ 已配置API Key
- ✅ Gateway正在运行
- ✅ 有公网IP或域名

---

#### 对接步骤

1. **创建钉钉应用**
   - 访问 [钉钉开放平台](https://open.dingtalk.com)
   - 创建企业内部应用
   - 获取AppKey和AppSecret

2. **配置OpenClaw**
   ```bash
   openclaw dingtalk init
   ```
   按照提示输入AppKey和AppSecret

3. **配置Webhook**
   - 在钉钉开放平台配置事件订阅URL
   - 格式：`https://你的域名/webhook/ddingtalk`
   - 验证加密Key

4. **测试消息**
   - 在钉钉中发送测试消息
   - 验证AI回复

---

#### 验证成功

✅ 成功标志:
- 钉钉应用状态正常
- 发送消息后AI正常回复
- Gateway日志显示消息处理成功

<details>
<summary><b>📚 详细教程</b></summary>

查看[钉钉对接完整教程](docs/platform-integration/dingtalk-integration.md)
</details>

---

### Q: 如何对接飞书？

**A:** 类似钉钉对接，步骤如下：

1. **创建飞书应用**
   - 访问 [飞书开放平台](https://open.feishu.cn)
   - 创建企业自建应用
   - 获取App ID和App Secret

2. **配置OpenClaw**
   ```bash
   openclaw feishu init
   ```

3. **配置事件订阅**
   - 在飞书开放平台配置事件订阅URL
   - 格式：`https://你的域名/webhook/feishu`

4. **测试消息**
   - 在飞书中发送测试消息

<details>
<summary><b>📚 详细教程</b></summary>

查看[飞书对接完整教程](docs/platform-integration/feishu-integration.md)
</details>

---

### Q: 如何对接Telegram？

**A:** Telegram对接相对简单：

1. **创建Bot**
   - 在Telegram中联系 [@BotFather](https://t.me/botfather)
   - 发送 `/newbot` 创建新Bot
   - 获取Bot Token

2. **配置OpenClaw**
   ```bash
   openclaw telegram init
   ```
   输入Bot Token

3. **开始使用**
   - 在Telegram中找到你的Bot
   - 发送 `/start` 开始对话

---

## ⚡ 性能优化

### Q: 如何提升响应速度？

**A:** 优化响应速度的多个方面：

#### 1. 选择更快的模型

| 模型 | 响应速度 | 适用场景 | 链接 |
|------|---------|---------|------|
| `Qwen/Qwen2.5-7B` | ⚡⚡⚡⚡⚡ | 轻量任务 | [查看](docs/api-config/model-comparison.md) |
| `Qwen/Qwen2.5-14B` | ⚡⚡⚡⚡ | 日常对话 | [查看](docs/api-config/model-comparison.md) |
| `Qwen/Qwen2.5-72B` | ⚡⚡⚡ | 复杂推理 | [查看](docs/api-config/model-comparison.md) |

---

#### 2. 优化网络连接

```bash
# 测试网络延迟
ping api.siliconflow.cn
```

⚠️ 如果延迟过高，考虑：
- 使用更近的服务器
- 配置CDN
- 使用代理

---

#### 3. 减少上下文长度

```json
{
  "models": {
    "maxContextLength": 2048
  }
}
```

减少上下文长度可以加快响应速度

---

#### 4. 使用缓存

```json
{
  "cache": {
    "enabled": true,
    "ttl": 3600
  }
}
```

启用缓存可以减少重复请求

---

### Q: 如何降低API使用成本？

**A:** 多个方面优化成本：

#### 1. 选择性价比高的模型

| 平台 | 推荐模型 | 价格 | 优势 |
|------|---------|------|------|
| 硅基流动 | Qwen2.5-7B | 便宜 | 性价比高 |
| 火山引擎 | Doubao-lite | 便宜 | 速度快 |
| 智谱GLM | GLM-4-Flash | 便宜 | 性能好 |

<details>
<summary><b>💰 详细成本对比</b></summary>

查看[成本优化完整指南](docs/api-config/cost-optimization.md)
</details>

---

#### 2. 减少Token消耗

- 缩短上下文长度
- 使用简洁的提示词
- 启用缓存
- 选择更小的模型

---

#### 3. 使用免费额度

充分利用各平台的免费额度：

| 平台 | 免费额度 | 有效期 |
|------|---------|--------|
| 硅基流动 | 2000万Tokens | 永久 |
| 火山引擎 | 首月8.9元 | 1个月 |
| 智谱GLM | 新用户优惠 | 有限期 |

---

## 🔒 安全问题

### Q: 如何保护API Key安全？

**A:** 安全最佳实践：

#### ✅ 推荐做法

1. **不要提交到Git**
   ```bash
   # 添加到.gitignore
   echo "*.json.backup" >> .gitignore
   echo "openclaw.json" >> .gitignore
   ```

2. **限制文件权限**
   ```bash
   chmod 600 ~/.openclaw/openclaw.json
   ```

3.   **使用环境变量**（可选）
   ```bash
   export OPENCLAW_API_KEY="sk-你的密钥"
   ```

#### ❌ 避免的做法

- ❌ 不要分享API Key
- �   不要在不信任的环境中使用
- ❌ 不要硬编码在脚本中
- ❌ 不要提交到公共仓库

---

### Q: 如何设置访问控制？

**A:** 配置访问限制：

#### 1. IP白名单

```json
{
  "gateway": {
    "allowedIps": [
      "192.168.1.100",
      "10.0.0.0/8"
    ]
  }
}
```

只允许特定IP访问Gateway

---

#### 2. API密钥认证

```json
{
  "gateway": {
    "auth": {
      "enabled": true,
      "apiKey": "your-internal-api-key"
    }
    }
}
```

启用API密钥认证

---

#### 3. HTTPS加密

配置HTTPS确保通信安全：

```bash
# 安装Nginx
apt install nginx certbot python3-certbot-nginx -y

# 获取SSL证书
certbot --nginx -d your-domain.com
```

---

## 🛠️ 高级功能

### Q: 如何安装和使用Skills？

**A:** OpenClaw支持丰富的Skills扩展：

#### 查找可用Skills

```bash
# 搜索Skills
openclaw skills search "weather"

# 列出所有Skills
openclaw skills list
```

---

#### 安装Skill

```bash
# 安装Skill
openclaw skills install weather

# 查看Skill详情
openclaw skills info weather
```

---

#### 使用Skill

安装后，直接在对话中使用：

```
用户: 北京今天天气怎么样？
AI: [调用weather skill] 北京今天晴，最高温度25°C...
```

<details>
<summary><b>📚 详细教程</b></summary>

查看[技能开发和使用](docs/advanced/skills.md)
</details>

---

### Q: 如何开发自定义Skill？

**A:** 创建自己的Skill：

#### Skill结构

```bash
~/.openclaw/skills/my-skill/
├── SKILL.md              # Skill文档
├── index.js              # Skill入口
└── package.json          # 依赖配置
```

---

#### 简单示例

```javascript
// index.js
module.exports = {
  name: 'my-skill',
  version: '1.0.0',
  description: '我的自定义技能',

  async execute(context) {
    const { message, reply } = context;

    // 处理消息
    const result = await processMessage(message);

    // 回复
    await reply(result);

    return { success: true };
  }
};
```

<details>
<summary><b>📚 完整教程</b></summary>

查看[技能开发完整指南](docs/advanced/skills.md)
</details>

---

## 📞 获取帮助

### Q: 遇到问题怎么办？

**A:** 按照以下顺序获取帮助：

#### 1. 查看文档

- 📖 [快速开始](docs/start/quickstart.md)
- 📋 [常见问题](FAQ.md)
- 🔍 [故障排除](docs/advanced/troubleshooting.md)

---

#### 2. 查看日志

```bash
# 查看最近日志
openclaw logs --tail 100

# 实时查看日志
openclaw logs --follow
```

---

#### 3. 搜索Issues

- [GitHub Issues](https://github.com/openclaw/openclaw/issues)
- 使用关键词搜索已有问题

---

#### 4. 提交Issue

如果以上都无法解决，提交Issue：

1. 收集诊断信息
   ```bash
   openclaw diagnostics > diagnostics.log
   ```

2. 查看日志
   ```bash
   openclaw logs > logs.log
   ```

3. 提交Issue
   - 访问 [GitHub Issues](https://github.com/openclaw/openclaw/issues/new)
   - 附上 `diagnostics.log` 和 `logs.log`
   - 详细描述问题和复现步骤

---

#### 5. 加入社区

- 💬 [Discord社区](https://discord.com/invite/clawd) - 实时讨论
- 📱 [Reddit社区](https://reddit.com/r/openclaw) - 问答和分享
- 📧 [邮件列表](mailto:support@openclaw.ai) - 问题反馈

---

## 📊 其他资源

### 📚 完整教程列表

| 类别 | 教程 | 难度 |
|------|------|------|
| 快速开始 | [5分钟快速上手](docs/start/quickstart.md) | ⭐ |
| API配置 | [API配置详解](docs/api-config/api-configuration.md) | ⭐⭐ |
| 模型选择 | [模型选择指南](docs/api-config/model-comparison.md) | ⭐⭐ |
| 成本优化 | [成本优化指南](docs/api-config/cost-optimization.md) | ⭐⭐⭐ |
| 云部署 | [云服务器部署](docs/cloud/cloud-deployment-guide.md) | ⭐⭐⭐ |
| 安全配置 | [安全配置指南](docs/advanced/security.md) | ⭐⭐⭐ |
| 技能开发 | [技能开发](docs/advanced/skills.md) | ⭐⭐⭐⭐ |
| 故障排除 | [故障排除指南](docs/advanced/troubleshooting.md) | ⭐⭐⭐ |

---

### 🔗 外部资源

- [OpenClaw官网](https://openclaw.ai)
- [OpenClaw文档](https://docs.openclaw.ai)
- [GitHub仓库](https://github.com/openclaw/openclaw)
- [更新日志](https://github.com/openclaw/openclaw/releases)

---

**最后更新**: 2026-02-22 (视觉优化 v2.0)
**版本**: 2.0
**维护者**: OpenClaw社区

<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->
