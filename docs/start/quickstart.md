<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# 5分钟快速上手

> 在5分钟内完成OpenClaw的安装和配置，开始你的AI助手之旅

---

## 📊 安装进度

| 步骤 | 任务 | 预计时间 | 状态 |
|------|------|---------|------|
| 1️⃣ | 获取API密钥 | 2分钟 | ⏳ 进行中 |
| 2️⃣ | 安装OpenClaw | 1分钟 | ⏸️ 待开始 |
| 3️⃣ | 配置API密钥 | 1分钟 | ⏸️ 待开始 |
| 4️⃣ | 启动Gateway | 30秒 | ⏸️ 待开始 |
| 5️⃣ | 连接对话平台 | 30秒 | ⏸️ 待开始 |

---

## 1️⃣ 第1步：获取API密钥 ⭐

> OpenClaw需要接入大模型API才能运行。推荐使用以下平台

<details>
<summary><b>💡 为什么需要API密钥？</b></summary>

OpenClaw本身是一个AI Agent平台，需要调用大模型API来生成回复。
选择哪个平台决定了你的AI助手使用的模型、性能和成本。
</details>

---

### 推荐方案对比

| 方案 | 平台 | 价格 | 优势 | 适用场景 |
|------|------|------|------|---------|
| ![方案1](https://img.shields.io/badge/方案1-推荐-green) | [硅基流动](https://cloud.siliconflow.cn/i/lva59yow) | 🆓 免费 | 2000万Tokens免费额度 | 新手入门 |
| ![方案2](https://img.shields.io/badge/方案2-高性价比-blue) | [火山引擎](https://volcengine.com/L/tHxxM_WwYp4/) | 💰 8.9元/月 | 支持4款模型，工具不限 | 长期使用 |
| ![方案3](https://img.shields.io/badge/方案3-编程友好-orange) | [智谱GLM](https://www.bigmodel.cn/glm-coding?ic=BUDVTRHUYH) | 💰 优惠价 | Claude Code、Cline支持 | 编程开发 |

---

#### ✅ 方案1: 硅基流动（新手推荐）

**注册即送2000万Tokens，完全免费体验** 🎁

[🔗 注册硅基流动 - 领取免费额度](https://cloud.siliconflow.cn/i/lva59yow)
**邀请码**: `lva59yow`

**注册后获取API Key**:
```markdown
1. 进入控制台
2. 点击"API Keys"
3. 点击"创建API Key"
4. 复制备用（格式: sk-xxxxxx）
```

✅ **预期输出**: API Key已复制到剪贴板

---

#### ✅ 方案2: 火山引擎方舟（高性价比）

**支持Doubao、GLM、DeepSeek、Kimi等模型，折上9折低至8.9元** 💎

[🔗 订阅火山引擎Coding Plan](https://volcengine.com/L/tHxxM_WwYp4/)
**邀请码**: `XCWPWPZTHW`

**套餐详情**:
- ✅ 首月仅8.9元
- ✅ 支持4款模型（Doubao/GLM/DeepSeek/Kimi）
- ✅ 工具不限（Claude Code、Cline等20+工具）
- ✅ 订阅越多越划算

**获取API Key**:
```markdown
1. 登录火山引擎控制台
2. 进入"API密钥管理"
3. 创建密钥（格式: AK-xxxxxx）
4. 复制备用
```

---

#### ✅ 方案3: 智谱GLM Coding（编程友好）

**专为编程优化，Claude Code、Cline等20+工具无缝支持** 🛠️

[🔗 立即开拼 - 享限时惊喜价](https://www.bigmodel.cn/glm-coding?ic=BUDVTRHUYH)

**核心卖点**:
- ✅ 越拼越爽，码力全开
- ✅ 限时惊喜价
- ✅ 邀你一起薅羊毛

**获取API Key**:
```markdown
1. 登录智谱开放平台
2. 进入"API Keys"
3. 创建密钥（32字符）
4. 复制备用
```

---

## 2️⃣ 第2步：安装OpenClaw

> 支持Windows、macOS、Linux、Android

---

### Windows

```powershell
# 使用npm安装（推荐）
npm install -g openclaw@latest

# 或使用npx（无需安装）
npx openclaw install
```

### macOS / Linux

```bash
# 使用npm安装
npm install -g openclaw@latest
```

### Android

```bash
# 使用Termux安装
pkg install nodejs npm
npm install -g openclaw@latest
```

---

### ✅ 验证安装

```bash
# 检查OpenClaw版本
openclaw --version
```

✅ **成功输出**: `OpenClaw CLI v2026.2.x`

❌ **失败处理**:
- 确保 Node.js 版本 ≥ v22.0
- 检查网络连接
- 查看错误日志

详细排查见[故障排除](../advanced/troubleshooting.md)

---

## 3️⃣ 第3步：配置API密钥

> 使用配置向导快速配置

---

### 方式1: 配置向导（推荐）✨

```bash
# 启动配置向导
openclaw init
```

**按照提示操作**:
```markdown
1. 选择API提供商（硅基流动/火山引擎/智谱GLM）
2. 粘贴API Key
3. 选择默认模型
4. 完成配置
```

✅ **成功标志**: `Configuration saved successfully`

---

### 方式2: 手动配置

<details>
<summary><b>📝 手动编辑配置文件</b></summary>

编辑配置文件 `~/.openclaw/openclaw.json`：

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
            "primary": true
          }
        ]
      }
    ]
  }
}
```

</details>

---

### ✅ 验证配置

```bash
# 验证配置文件
openclaw config validate
```

✅ **成功输出**: `✓ Configuration is valid`

---

## 4️⃣ 第4步：启动Gateway

> Gateway是OpenClaw的核心服务，需要在后台持续运行

---

### 启动Gateway

```bash
# 启动OpenClaw Gateway
openclaw gateway start
```

✅ **成功输出**:
```
[OpenClaw Gateway] Starting...
[OpenClaw Gateway] Listening on http://localhost:18789
[OpenClaw Gateway] Ready to receive connections
```

---

### 检查Gateway状态

```bash
# 检查Gateway运行状态
openclaw gateway status
```

✅ **成功输出**: `Gateway is running on http://localhost:18789`

---

### ⚠️ 注意

Gateway需要在后台持续运行：
- **macOS/Linux**: 使用 `nohup` 或 `tmux`
- **Windows**: 保持终端窗口打开
- **云服务器**: 推荐使用systemd服务

详细配置见[云服务器部署](../cloud/cloud-deployment-guide.md)

---

## 5️⃣ 第5步：连接对话平台

> 选择你喜欢的对话方式开始使用

---

### 方式1: Web聊天（最快）🌐

访问 [http://localhost:18789/chat](http://localhost:18789/chat)

✅ **优势**:
- 无需额外配置
- 即开即用
- 支持markdown渲染

---

### 方式2: 钉钉（推荐企业用户）💬

```bash
# 配置钉钉集成
openclaw feishu init
```

按照提示：
```markdown
1. 扫描二维码或配置应用凭证
2. 测试发送消息
3. 开始使用
```

详细教程见[钉钉对接教程](../platform-integration/dingtalk-integration.md)

---

### 方式3: Telegram（推荐海外用户）📱

```bash
# 配置Telegram Bot
openclaw telegram init
```

按照提示：
```markdown
1. 创建Telegram Bot
2. 配置Bot Token
3. 开始对话
```

详细教程见[Telegram对接教程](../platform-integration/telegram-integration.md)

---

## 🎉 验证成功

### 发送测试消息

**用户**: 你好！
**AI**: 你好！我是OpenClaw，有什么可以帮助你的吗？

---

### ✅ 成功标志

- ✅ Gateway正常运行
- ✅ 可以发送消息
- ✅ AI正常回复
- ✅ 无错误日志

🎉 **恭喜！你的AI助手已经就绪！**

---

## 📊 安装完成

| 步骤 | 任务 | 状态 |
|------|------|------|
| 1️⃣ | 获取API密钥 | ✅ 完成 |
| 2️⃣ | 安装OpenClaw | ✅ 完成 |
| 3️⃣ | 配置API密钥 | ✅ 完成 |
| 4️⃣ | 启动Gateway | ✅ 完成 |
| 5️⃣ | 连接对话平台 | ✅ 完成 |

---

## 🚀 下一步

### 基础学习

- [ ] 📖 学习[API配置](../api-config/api-configuration.md)
- [ ] 🎯 选择合适的[模型](../api-config/model-comparison.md)
- [ ] 💰 了解[成本优化](../api-config/cost-optimization.md)

### 进阶配置

- [ ] ☁️ 部署到[云服务器](../cloud/cloud-deployment-guide.md)
- [ ] 💬 对接更多[消息平台](../platform-integration/platform-integration-overview.md)
- [ ] 🔧 学习[技能开发](../advanced/skills.md)

### 遇到问题？

- [ ] ❓ 查看[常见问题](../../FAQ.md)
- [ ] 🔍 阅读[故障排除](../advanced/troubleshooting.md)
- [ ] 💬 加入[Discord社区](https://discord.com/invite/clawd)

---

## ❓ 常见问题

<details>
<summary><b>❓ 免费额度能用多久？</b></summary>

**A:** 硅基流动的2000万Tokens足够新手使用1-3个月，具体取决于使用频率。

每天使用100次对话约消耗20万Tokens，可用3个月左右。
</details>

---

<details>
<summary><b>❓ 不想付费怎么办？</b></summary>

**A:** 先使用免费额度体验，觉得有价值再考虑订阅。

推荐顺序：
1. 硅基流动（2000万Tokens免费）
2. 火山引擎（首月8.9元）
3. 智谱GLM Coding（年付优惠）
</details>

---

<details>
<summary><b>❓ 安装失败怎么办？</b></summary>

**A:** 检查以下几点：

1. **Node.js版本**: 需要v22.0 或更高
   ```bash
   node --version
   ```

2. **网络连接**: 确保能访问npm仓库
   ```bash
   ping registry.npmjs.org
   ```

3. **写入权限**: 确保有全局安装权限

详细排查见[故障排除](../advanced/troubleshooting.md)
</details>

---

<details>
<summary><b>❓ Gateway启动失败？</b></summary>

**A:** 可能的原因和解决方案：

1. **端口被占用**: 18789端口已被使用
   ```bash
   # 检查端口占用
   lsof -i :18789  # macOS/Linux
   netstat -ano | findstr :18789  # Windows
   ```

2. **配置文件错误**: 配置文件格式有问题
   ```bash
   openclaw config validate
   ```

3. **查看日志**: 查看详细错误信息
   ```bash
   openclaw logs --tail 50
   ```

</details>

---

## 📚 参考资源

### 官方文档

- [OpenClaw官方文档](https://docs.openclaw.ai)
- [GitHub仓库](https://github.com/openclaw/openclaw)
- [更新日志](https://github.com/openclaw/openclaw/releases)

### 社区支持

- [Discord社区](https://discord.com/invite/clawd)
- [GitHub Issues](https://github.com/openclaw/openclaw/issues)
- [Reddit社区](https://reddit.com/r/openclaw)

---

## 🎯 快速命令参考

| 命令 | 说明 | 首次使用 |
|------|------|---------|
| `openclaw --version` | 查看版本 | ✅ |
| `openclaw init` | 初始化配置 | ✅ |
| `openclaw gateway start` | 启动Gateway | ✅ |
| `openclaw gateway status` | 检查状态 | ⏸️ |
| `openclaw logs --tail 50` | 查看日志 | ⏸️ |
| `openclaw config validate` | 验证配置 | ⏸️ |

---

**创建时间**: 2026-02-22
**最后更新**: 2026-02-22 (视觉优化 v2.0)
**版本**: 2.0
**适用版本**: OpenClaw 2026.2.x

<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->
