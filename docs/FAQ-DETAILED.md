# OpenClaw 常见问题解答 (FAQ)

> 新手常见问题快速解答

---

## 📋 目录

- [安装相关](#-安装相关)
- [配置相关](#-配置相关)
- [使用相关](#-使用相关)
- [消息平台](#-消息平台)
- [性能优化](#-性能优化)
- [错误处理](#-错误处理)
- [高级功能](#-高级功能)
- [其他问题](#-其他问题)

---

## 🔧 安装相关

### Q: 什么是 OpenClaw？

A: OpenClaw 是一个开源的 AI 助手框架，可以部署在本地或服务器，通过多种消息平台（Telegram、Discord、Signal 等）与 AI 对话。支持多个 AI 模型提供商（硅基流动、火山方舟、阿里百炼等）和自定义技能扩展。

---

### Q: 系统要求是什么？

A: **最低配置**:
- 内存: 2GB RAM
- 磁盘空间: 1GB
- 操作系统: Linux/macOS/Windows 10+

**推荐配置**:
- 内存: 4GB+ RAM
- 磁盘空间: 5GB+
- 操作系统: Ubuntu 22.04 LTS / macOS Ventura+ / Windows 11

---

### Q: 如何快速安装？

A: 推荐使用一键安装脚本：

**Linux**:
```bash
curl -O https://raw.githubusercontent.com/Mr-tooth/OpenClaw-Guide-for-Beginners/main/scripts/install-linux.sh
chmod +x install-linux.sh
sudo ./install-linux.sh
```

**macOS**:
```bash
curl -O https://raw.githubusercontent.com/Mr-tooth/OpenClaw-Guide-for-Beginners/main/scripts/install-macos.sh
chmod +x install-macos.sh
./install-macos.sh
```

**Windows**:
下载 [install-windows.bat](scripts/install-windows.bat) 并以管理员身份运行。

---

### Q: 安装失败怎么办？

A: 检查以下几点：

1. **检查 Node.js 版本**
```bash
node --version  # 应该是 v22.x.x
```

2. **检查网络连接**
```bash
curl -Iv https://get.openclaw.ai
```

3. **检查权限**
```bash
# Linux/macOS: 使用 sudo
sudo ./install-linux.sh

# Windows: 以管理员身份运行
```

4. **查看详细错误日志**
```bash
# 使用 -x 参数查看详细输出
bash -x install-linux.sh
```

更多故障排除请参考 [安装指南](INSTALLATION-GUIDE.md#-故障排除)

---

### Q: 如何卸载 OpenClaw？

A: **Linux/macOS**:
```bash
# 停止服务
openclaw stop

# 删除 OpenClaw
rm -rf ~/.local/bin/openclaw
rm -rf ~/.openclaw

# 从 PATH 移除（编辑 ~/.bashrc）
```

**Windows**:
```powershell
openclaw stop
Remove-Item -Path "$env:LOCALAPPDATA\openclaw" -Recurse -Force
Remove-Item -Path "$env:USERPROFILE\.openclaw" -Recurse -Force
```

**Docker**:
```bash
docker stop openclaw
docker rm openclaw
docker rmi openclaw/openclaw:latest
```

---

### Q: 更新 OpenClaw？

A:
```bash
# 更新到最新版本
openclaw update

# 或使用 npm 更新
npm update -g @openclaw/openclaw

# 验证版本
openclaw --version
```

---

## ⚙️ 配置相关

### Q: 如何配置 API Key？

A: 使用配置向导（推荐）:
```bash
openclaw onboard
```

或手动配置:
```bash
# 硅基流动
openclaw config set provider siliconflow
openclaw config set api_key YOUR_API_KEY
```

详细配置请参考 [API 配置指南](API-CONFIG-GUIDE.md)

---

### Q: 哪个 AI 平台最便宜？

A: **最推荐（新手）**:
- **硅基流动**: 2000万免费Tokens，50+模型
- **火山方舟**: 首月8.91元，宽松套餐

**其他平台**:
- **阿里百炼**: 按量付费，稳定可靠
- **智谱 GLM**: 新用户免费，年付7折

详见 [模型对比](api-config/model-comparison.md)

---

### Q: 如何获取 API Key？

A: **硅基流动**:
1. 访问 https://cloud.siliconflow.cn
2. 注册账号
3. 进入「API Keys」页面
4. 创建并复制 API Key

**火山方舟**:
1. 访问 https://www.volcengine.com/activity/codingplan
2. 订阅 Coding Plan（首月8.91元）
3. 进入「访问控制」→「API密钥管理」
4. 创建并复制 Access Key

详见 [API 配置指南](API-CONFIG-GUIDE.md)

---

### Q: 如何切换 AI 模型？

A:
```bash
# 查看可用模型
openclaw models list

# 设置默认模型
openclaw config set model.primary siliconflow/Pro/MiniMaxAI/MiniMax-M2.5

# 或在对话中切换
/set model siliconflow/Pro/MiniMaxAI/MiniMax-M2.5
```

---

### Q: 如何查看当前配置？

A:
```bash
# 查看所有配置
openclaw config get

# 查看提供商
openclaw config get provider

# 查看默认模型
openclaw config get model.primary
```

---

## 💬 使用相关

### Q: 如何启动 OpenClaw？

A:
```bash
# 前台启动
openclaw start

# 后台启动
openclaw gateway start --background

# 查看状态
openclaw status

# 查看日志
openclaw logs
```

---

### Q: 如何停止 OpenClaw？

A:
```bash
# 停止
openclaw stop

# 或停止 Gateway
openclaw gateway stop
```

---

### Q: 如何检查 OpenClaw 是否正常工作？

A:
```bash
# 检查版本
openclaw --version

# 检查状态
openclaw status

# 验证 API Key
openclaw validate

# Ping 测试
openclaw ping
```

---

### Q: OpenClaw 支持哪些 AI 功能？

A: OpenClaw 支持丰富的 AI 功能：

- **智能对话** - 多轮对话，上下文记忆
- **代码生成** - 支持多种编程语言
- **网页浏览** - 搜索网页，提取信息
- **文件操作** - 读取、编辑、创建文件
- **代码执行** - 运行 Python、Node.js 代码
- **技能扩展** - 安装第三方技能
- **多模态** - 图像识别、文档分析

---

### Q: 如何安装技能？

A:
```bash
# 搜索技能
openclaw skills search weather

# 安装技能
openclaw skills install weather-skill

# 列出已安装技能
openclaw skills list

# 卸载技能
openclaw skills uninstall weather-skill
```

---

### Q: 如何使用子代理？

A: 子代理可以并行执行多个任务：

```bash
# 启动子代理
openclaw subagent spawn --task "搜索最新新闻"

# 查看所有子代理
openclaw subagent list

# 与子代理通信
openclaw subagent send --session-id xxx --message "继续工作"

# 杀子代理
openclaw subagent kill --session-id xxx
```

---

## 📱 消息平台

### Q: 支持哪些消息平台？

A: OpenClaw 支持 10+ 消息平台：

- ✅ **Telegram**（推荐新手）
- ✅ **Discord**
- ✅ **Signal**
- ✅ **WhatsApp**
- ✅ **Slack**
- ✅ **Google Chat**
- ✅ **IRC**
- ✅ **iMessage**（仅 macOS）
- ✅ **钉钉**
- ✅ **企业微信**

---

### Q: 如何配置 Telegram Bot？

A: **步骤**:

1. **创建 Bot**
   - 打开 Telegram，搜索 [@BotFather](https://t.me/BotFather)
   - 发送 `/newbot`
   - 设置 bot 名称和用户名

2. **获取 Token**
   - BotFather 会返回 API Token

3. **配置 OpenClaw**
```bash
openclaw config set channels.telegram.botToken YOUR_BOT_TOKEN
```

4. **重启**
```bash
openclaw restart
```

详见 [Telegram 配置教程](channels/telegram-guide.md)

---

### Q: 如何配置 Discord Bot？

A: **步骤**:

1. **创建应用**
   - 访问 [Discord Developer Portal](https://discord.com/developers/applications)
   - 创建新应用

2. **创建 Bot**
   - 进入 "Bot" 标签
   - 点击 "Add Bot"
   - 复制 Token

3. **配置 OpenClaw**
```bash
openclaw config set channels.discord.botToken YOUR_BOT_TOKEN
openclaw config set channels.discord.clientId YOUR_CLIENT_ID
```

详见 [Discord 配置教程](channels/discord-guide.md)

---

### Q: 如何配置 Signal？

A: **步骤**:

1. **安装 Signal Desktop**

2. **配置 OpenClaw**
```bash
# macOS
openclaw config set channels.signal.signalCliPath "/Applications/Signal.app/Contents/MacOS/Signal"

# Linux
openclaw config set channels.signal.signalCliPath "/usr/bin/signal-cli"
```

3. **重启**
```bash
openclaw restart
```

详见 [Signal 配置教程](channels/signal-guide.md)

---

### Q: 消息发送失败怎么办？

A: 检查以下几点：

1. **检查通道配置**
```bash
openclaw config get channels.telegram
```

2. **检查 Gateway 日志**
```bash
openclaw logs --tail 50 | grep -i error
```

3. **重启 Gateway**
```bash
openclaw restart
```

4. **验证 API Key**
```bash
openclaw validate
```

---

## ⚡ 性能优化

### Q: 如何提高响应速度？

A: 优化建议：

1. **使用更快的模型**
```bash
openclaw config set model.primary siliconflow/Pro/THUDM/glm-4-9b-chat
```

2. **关闭深度思考**
```bash
# 在对话中
/set thinking off
```

3. **使用本地模型**（需要高性能硬件）
```bash
openclaw config set model.provider ollama
openclaw config set model.primary ollama/llama3
```

4. **增加并发数**
```bash
openclaw config set gateway.maxConcurrentRequests 10
```

---

### Q: 如何降低使用成本？

A: 成本优化建议：

1. **使用免费或低价模型**
   - 硅基流动: 2000万免费Tokens
   - 火山方舟: Coding Plan 首月8.91元

2. **使用 cheaper 模型**
```bash
openclaw config set model.primary siliconflow/Pro/THUDM/glm-4-9b-chat
```

3. **设置配额限制**
```bash
openclaw config set quota.maxDailyTokens 1000000
```

4. **监控使用量**
```bash
openclaw account --info
```

详见 [成本优化指南](api-config/cost-optimization.md)

---

### Q: 如何优化内存使用？

A: 优化建议：

1. **限制上下文长度**
```bash
openclaw config set agents.maxContextTokens 4000
```

2. **启用历史压缩**
```bash
openclaw config set agents.historyCompression.enabled true
```

3. **减少并发会话**
```bash
openclaw config set gateway.maxSessions 5
```

---

## 🐛 错误处理

### Q: 遇到错误怎么办？

A: 通用排查步骤：

1. **查看错误日志**
```bash
openclaw logs --tail 100 | grep -i error
```

2. **检查配置**
```bash
openclaw config get
```

3. **验证 API Key**
```bash
openclaw validate
```

4. **重启 Gateway**
```bash
openclaw restart
```

5. **查看详细日志**
```bash
openclaw logs --tail 200
```

---

### Q: API Key 无效错误？

A: 解决方案：

1. 检查 API Key 是否正确
```bash
openclaw config get api_key
```

2. 重新配置 API Key
```bash
openclaw config set api_key YOUR_NEW_API_KEY
```

3. 验证 API Key
```bash
openclaw validate
```

---

### Q: 端口被占用错误？

A: 解决方案：

1. 查找占用进程
```bash
sudo lsof -i :18789
```

2. 停止占用进程
```bash
sudo kill -9 <PID>
```

3. 或更改 OpenClaw 端口
```bash
openclaw config set gateway.port 18790
```

---

### Q: 网络连接超时？

A: 解决方案：

1. 检查网络连接
```bash
curl -Iv https://cloud.siliconflow.cn
```

2. 使用代理
```bash
export http_proxy=http://proxy.example.com:8080
export https_proxy=http://proxy.example.com:8080
```

3. 检查防火墙
```bash
sudo iptables -L OUTPUT
```

---

### Q: Gateway 启动失败？

A: 解决方案：

1. 查看详细日志
```bash
openclaw logs --tail 100
```

2. 检查配置文件
```bash
openclaw config get
```

3. 验证安装
```bash
openclaw --version
```

4. 重置配置（最后手段）
```bash
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.backup
rm ~/.openclaw/openclaw.json
openclaw onboard
```

---

## 🚀 高级功能

### Q: 如何使用浏览器自动化？

A: OpenClaw 内置浏览器自动化功能：

在对话中：
```
帮我搜索最新的 AI 新闻
打开 https://example.com 并截图
填写表单并发送
```

或使用 [agent-browser 技能](../skills/agent-browser/)

---

### Q: 如何使用记忆功能？

A: OpenClaw 自动记忆对话历史和重要信息。

查看长期记忆：
```bash
# 在对话中
查看我的记忆
```

或手动添加记忆：
```bash
# 创建记忆文件
mkdir -p ~/.openclaw/memory
echo "用户偏好: 喜欢简洁输出" > ~/.openclaw/memory/user-preferences.md
```

---

### Q: 如何使用多语言？

A: OpenClaw 支持多种编程语言：

在对话中：
```
用 Python 写一个爬虫
用 JavaScript 实现一个 API
用 Go 创建一个微服务
```

---

### Q: 如何使用视觉功能？

A: 使用多模态模型：

1. 配置视觉模型
```bash
openclaw config set model.primary siliconflow/Pro/Qwen/Qwen2-VL-72B-Instruct
```

2. 在对话中发送图片
```
[发送图片] 识别图片中的内容
[发送图片] 描述这张图片
```

---

## ❓ 其他问题

### Q: OpenClaw 是免费的吗？

A: OpenClaw 本身是开源免费的，但 AI 模型提供商收费：

- **OpenClaw**: 免费（开源）
- **硅基流动**: 2000万免费Tokens
- **火山方舟**: 首月8.91元
- **阿里百炼**: 按量付费
- **智谱 GLM**: 新用户免费

详见 [API 配置指南](API-CONFIG-GUIDE.md)

---

### Q: 数据隐私安全？

A: OpenClaw 优先保护隐私：

- ✅ 数据默认存储在本地
- ✅ 可选不使用云端模型
- ✅ 支持离线模式（使用本地模型）
- ✅ 配置文件权限 600
- ✅ 传输加密（HTTPS）

**注意**: 使用云端模型时（如硅基流动、火山方舟），对话内容会发送到提供商服务器。

---

### Q: 可以离线使用吗？

A: 可以，使用本地模型：

1. **安装 Ollama**
```bash
curl -fsSL https://ollama.com/install.sh | sh
```

2. **配置 OpenClaw**
```bash
openclaw config set provider ollama
openclaw config set model.primary ollama/llama3
```

详见 [本地模型配置指南](../local-models/local-models-guide.md)

---

### Q: 如何获取帮助？

A: 多种帮助方式：

1. **内置帮助**
```bash
openclaw --help
openclaw help
```

2. **文档**
   - [官方文档](https://docs.openclaw.ai)
   - [安装指南](INSTALLATION-GUIDE.md)
   - [API 配置指南](API-CONFIG-GUIDE.md)
   - [FAQ](FAQ.md)（本文档）

3. **社区**
   - [Discord 社区](https://discord.com/invite/clawd)
   - [GitHub Issues](https://github.com/openclaw/openclaw/issues)

4. **在对话中询问**
```
/help
```

---

### Q: 如何贡献代码？

A: 欢迎贡献！

1. **Fork 仓库**
   - 访问 [GitHub](https://github.com/openclaw/openclaw)
   - Fork 到你的账号

2. **创建分支**
```bash
git checkout -b feature/my-feature
```

3. **提交更改**
```bash
git commit -m "Add my feature"
```

4. **推送到 Fork**
```bash
git push origin feature/my-feature
```

5. **创建 Pull Request**
   - 在 GitHub 上创建 PR

详见 [贡献指南](https://github.com/openclaw/openclaw/blob/main/CONTRIBUTING.md)

---

### Q: 如何报告 Bug？

A: 报告 Bug：

1. **收集信息**
   - OpenClaw 版本: `openclaw --version`
   - 操作系统
   - 错误日志: `openclaw logs --tail 100`
   - 复现步骤

2. **创建 Issue**
   - 访问 [GitHub Issues](https://github.com/openclaw/openclaw/issues)
   - 点击 "New Issue"
   - 填写 Bug 模板

3. **等待回复**
   - 开发者会尽快处理

---

## 📚 更多资源

- [快速开始](QUICKSTART.md) - 5分钟快速上手
- [完整安装指南](INSTALLATION-GUIDE.md) - 详细安装步骤
- [API 配置指南](API-CONFIG-GUIDE.md) - API 平台配置
- [模型对比](api-config/model-comparison.md) - 模型选择指南
- [成本优化](api-config/cost-optimization.md) - 降低使用成本
- [官方文档](https://docs.openclaw.ai)
- [Discord 社区](https://discord.com/invite/clawd)

---

**创建时间**: 2026-02-22 15:20 UTC
**版本**: 1.0
**Phase**: Phase 4+ - 阶段5
