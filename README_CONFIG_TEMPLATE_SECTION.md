# ⚙️ 配置模板和脚本

> ⚠️ **重要提示**: 本章节的模板文件仅作为参考，请勿直接覆盖你的配置文件！

---

## 🔧 配置模板说明

项目提供了配置模板供参考，**适用于理解配置结构**，**不推荐直接覆盖使用**。

| 模板文件 | 说明 | 用途 |
|---------|------|------|
| `templates/openclaw-template.json` | 主配置参考模板 | 了解配置结构，提取配置片段 |
| `templates/env-template.txt` | 环境变量模板 | 参考环境变量配置格式 |

### ⚠️ 为什么不能直接覆盖？

**模板文件缺少系统配置**:
- ❌ 缺少 `meta` 字段（版本信息）
- ❌ 缺少 `wizard` 字段（配置向导状态）
- ❌ 缺少 `browser` 字段（浏览器配置）
- ❌ 缺少 `auth` 字段（认证配置）
- ✅ 仅包含 `models`、`agents`、`gateway`、`channels` 等用户配置

**直接覆盖的后果**:
- 🔥 `openclaw doctor` 报错
- 🔥 Gateway 启动失败
- 🔥 丢失浏览器配置
- 🔥 丢失认证信息

---

## ✅ 正确的使用方法

### 方法1: 使用OpenClaw配置向导（推荐新手）

```bash
# 启动配置向导
openclaw onboard --install-daemon

# 或运行诊断并配置
openclaw doctor
```

按照提示选择平台并输入 API Key，OpenClaw 会自动生成正确的配置。

---

### 方法2: 手动配置（推荐有经验的用户）

#### 步骤1: 备份现有配置

```bash
# 备份现有配置（安全第一！）
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.backup.$(date +%Y%m%d)
cp ~/.openclaw/.env ~/.openclaw/.env.backup.$(date +%Y%m%d) 2>/dev/null || true
```

#### 步骤2: 使用命令行配置

```bash
# 设置提供商（以硅基流动为例）
openclaw config set provider siliconflow

# 设置 API Key
openclaw config set api_key sk-xxxxxxxxxxxxxxxxxxxx

# 验证配置
openclaw doctor
```

#### 步骤3: 手动编辑配置文件

```bash
# 使用 nano 编辑配置文件
nano ~/.openclaw/openclaw.json

# 或使用 VS Code
code ~/.openclaw/openclaw.json
```

**编辑建议**:
- ✅ 只添加或修改需要的字段
- ✅ 保持 JSON 格式正确（逗号、引号）
- ✅ 使用 `openclaw doctor` 验证配置
- ❌ 不要删除或修改 `meta`、`wizard`、`browser` 等系统字段

---

### 方法3: 参考模板文件（高级用户）

**适用场景**:
- 了解配置结构
- 提取模型配置片段
- 参考环境变量配置

**操作步骤**:

```bash
# 1. 查看模板文件内容
cat templates/openclaw-template.json

# 2. 提取需要的配置（例如：模型配置）
#    打开模板文件和你的配置文件
nano templates/openclaw-template.json
nano ~/.openclaw/openclaw.json

# 3. 复制需要的配置片段到你的配置文件
#    注意：只复制需要的部分，不要覆盖整个文件

# 4. 验证配置
openclaw doctor
```

**示例：添加新的提供商配置**

1. 打开模板文件，找到你需要的提供商配置
2. 复制该提供商的配置块
3. 打开你的配置文件，粘贴到 `models.providers` 中
4. 修改 `apiKey` 为你的实际值
5. 运行 `openclaw doctor` 验证

---

## 🔐 环境变量配置

**推荐使用环境变量存储敏感信息**（API Key、Token等）。

### 创建 .env 文件

```bash
# 创建 .env 文件
touch ~/.openclaw/.env

# 设置文件权限（仅自己可读写）
chmod 600 ~/.openclaw/.env

# 编辑 .env 文件
nano ~/.openclaw/.env
```

### .env 文件示例

```bash
# ========================================
# OpenClaw 环境变量配置
# ========================================

# 硅基流动 API Key
SILICONFLOW_API_KEY=sk-your-siliconflow-api-key-here

# 火山引擎 API Key
VOLCENGINE_API_KEY=AK-your-volcengine-api-key-here

# 阿里百炼 API Key
BAILIAN_API_KEY=sk-your-bailian-api-key-here

# Gateway 认证 Token（用于访问 Gateway UI）
OPENCLAW_GATEWAY_TOKEN=your-gateway-token-here

# DingTalk 应用凭证
DINGTALK_CLIENT_ID=your-dingtalk-client-id
DINGTALK_CLIENT_SECRET=your-dingtalk-client-secret

# Telegram Bot Token
TELEGRAM_BOT_TOKEN=your-telegram-bot-token

# 智谱 GLM API Key
ZHIPU_API_KEY=your-zhipu-api-key
```

### 在配置文件中使用环境变量

```json
{
  "models": {
    "providers": {
      "siliconflow": {
        "baseUrl": "https://api.siliconflow.cn/v1",
        "apiKey": "${SILICONFLOW_API_KEY}",
        "api": "openai-completions"
      }
    }
  },
  "gateway": {
    "auth": {
      "token": "${OPENCLAW_GATEWAY_TOKEN}"
    }
  }
}
```

**优势**:
- ✅ 敏感信息与配置分离
- ✅ 不同环境使用不同的 .env 文件
- ✅ 可以安全地分享配置文件（不包含 .env）
- ✅ 使用 `${VARIABLE}` 格式引用

---

## 🛠️ 一键安装脚本

> ⚠️ **慎重使用**：一键安装脚本适合全新安装，**不适用于已有OpenClaw环境的用户**

| 脚本 | 平台 | 适用场景 | 下载方式 |
|------|------|---------|---------|
| `install-windows.bat` | Windows | 全新安装 | [下载](https://raw.githubusercontent.com/Mr-tooth/OpenClaw-Guide-for-Beginners/main/scripts/install-windows.bat) |
| `install-wsl.ps1` | WSL | 全新安装 | [下载](https://raw.githubusercontent.com/Mr-tooth/OpenClaw-Guide-for-Beginners/main/scripts/install-wsl.ps1) |
| `install-linux.sh` | Linux | 全新安装 | [下载命令](#linux-安装) |
| `install-macos.sh` | macOS | 全新安装 | [下载命令](#macos-安装) |
| `install-docker.sh` | Docker | 容器化部署 | [下载命令](#docker-安装) |

### Windows 安装

```powershell
# 下载安装脚本
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Mr-tooth/OpenClaw-Guide-for-Beginners/main/scripts/install-windows.bat" -OutFile "install-windows.bat"

# 以管理员身份运行
.\install-windows.bat
```

### macOS/Linux 安装

```bash
# 下载安装脚本
curl -O https://raw.githubusercontent.com/Mr-tooth/OpenClaw-Guide-for-Beginners/main/scripts/install-linux.sh

# 添加执行权限
chmod +x install-linux.sh

# 运行安装脚本（会自动安装Node.js和OpenClaw）
./install-linux.sh

# 或直接一行命令安装
curl -fsSL https://raw.githubusercontent.com/Mr-tooth/OpenClaw-Guide-for-Beginners/main/scripts/install-linux.sh | bash
```

### Docker 安装

```bash
# 下载安装脚本
curl -O https://raw.githubusercontent.com/Mr-tooth/OpenClaw-Guide-for-Beginners/main/scripts/install-docker.sh

# 添加执行权限
chmod +x install-docker.sh

# 运行安装脚本
./install-docker.sh
```

**脚本功能**:
- ✅ 自动检测系统环境
- ✅ 安装 Node.js（如未安装）
- ✅ 安装 OpenClaw
- ✅ 运行配置向导
- ✅ 提供后续配置指导
- ✅ 详细的错误提示

---

## 📋 配置验证

无论使用哪种方法配置，最后都要验证配置：

```bash
# 运行诊断
openclaw doctor

# 或检查配置
openclaw config list

# 检查模型配置
openclaw models list

# 检查 Gateway 状态
openclaw gateway status
```

**预期输出**:

```bash
✅ OpenClaw CLI: 已安装 v2026.2.19
✅ Node.js: 已安装 v22.22.0
✅ Gateway: 运行中 (PID: 12345)
✅ 模型配置: 正常
✅ 提供商: siliconflow (已配置)
✅ 向量搜索: 已启用
```

---

## ❓ 常见问题

### Q: 配置文件在哪里？

**A:**
- 主配置: `~/.openclaw/openclaw.json`
- 环境变量: `~/.openclaw/.env`
- 工作空间: `~/.openclaw/workspace`

### Q: 如何重置配置？

**A:**
```bash
# 删除配置文件（⚠️ 慎重操作）
rm ~/.openclaw/openclaw.json

# 重新运行配置向导
openclaw onboard --install-daemon
```

### Q: 如何备份配置？

**A:**
```bash
# 备份到当前目录
cp ~/.openclaw/openclaw.json ./openclaw-backup.json
cp ~/.openclaw/.env ./env-backup.txt 2>/dev/null || true

# 或创建备份目录
mkdir -p ~/openclaw-backup
cp -r ~/.openclaw/* ~/openclaw-backup/
```

### Q: 配置文件格式错误怎么办？

**A:**
```bash
# 1. 使用 openclaw doctor 诊断
openclaw doctor

# 2. 使用 JSON 验证工具
cat ~/.openclaw/openclaw.json | python3 -m json.tool

# 3. 如果无法修复，备份并重新初始化
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.broken
openclaw onboard --install-daemon
```

---

**详细使用说明**: [查看模板使用指南](templates/README.md) | [API配置教程](docs/api-config/api-configuration.md)
