# 配置模板使用指南

> ⚠️ **重要提示**: 模板文件仅供参考，请勿直接覆盖你的配置文件！

---

## 📋 模板文件说明

| 模板文件 | 说明 | 用途 |
|---------|------|------|
| `openclaw-template.json` | 主配置参考模板 | 了解配置结构，提取配置片段 |
| `env-template.txt` | 环境变量模板 | 参考环境变量配置格式 |

---

## ⚠️ 为什么不能直接覆盖？

### 模板文件缺少系统配置

**模板文件包含**:
- ✅ `models` - 模型提供商配置
- ✅ `agents` - Agent 默认配置
- ✅ `gateway` - Gateway 配置
- ✅ `channels` - 消息平台配置
- ✅ `session` - 会话配置
- ✅ `plugins` - 插件配置
- ✅ `skills` - 技能配置

**模板文件缺少**（由OpenClaw自动管理）:
- ❌ `meta` - 版本信息和最后修改时间
- ❌ `wizard` - 配置向导状态
- ❌ `browser` - 浏览器配置（如已启用）
- ❌ `auth` - 认证配置（如已配置）

### 直接覆盖的后果

如果你直接用模板文件覆盖 `openclaw.json`，会导致：

1. **版本信息丢失**
   ```json
   "meta": {
     "lastTouchedVersion": "2026.3.23",
     "lastTouchedAt": "2026-02-22T02:44:58.515Z"
   }
   ```
   OpenClaw 无法识别配置文件版本

2. **浏览器配置丢失**
   ```json
   "browser": {
     "enabled": true,
     "executablePath": "/root/.cache/ms-playwright/chromium-1208/chrome-linux64/chrome"
   }
   ```
   需要重新配置浏览器

3. **认证配置丢失**
   ```json
   "auth": {
     "profiles": {
       "qwen-portal:default": {...}
     }
   }
   ```
   需要重新登录或配置认证

4. **错误示例**
   ```bash
   $ openclaw doctor
   ❌ 配置文件格式错误: 缺少 meta 字段
   ❌ Gateway 启动失败
   ```

---

## ✅ 正确的使用方法

### 方法1: 使用OpenClaw配置向导（推荐新手）

这是最安全、最简单的方法：

```bash
# 启动配置向导
openopenclaw onboard --install-daemon
```

按照提示：
1. 选择 API 平台
2. 输入 API Key
3. 选择默认模型
4. 配置消息平台（可选）

OpenClaw 会自动生成正确的配置，包括所有系统字段。

---

### 方法2: 使用命令行配置

配置单个提供商，不影响其他配置：

```bash
# 设置提供商
openclaw config set provider siliconflow

# 设置 API Key
openclaw config set api_key sk-xxxxxxxxxxxxxxxxxxxx

# 验证配置
openclaw doctor
```

---

### 方法3: 手动编辑配置文件

**适用于**：需要精细配置，或添加多个提供商

#### 步骤1: 备份现有配置

```bash
# 备份现有配置（安全第一！）
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.backup.$(date +%Y%m%d)

# 验证备份
ls -lh ~/.openclaw/openclaw.json.backup.*
```

#### 步骤2: 查看模板文件

```bash
# 查看模板文件内容
cat templates/openclaw-template.json

# 或使用编辑器
nano templates/openclaw-template.json
```

#### 步骤3: 编辑你的配置文件

```bash
# 使用 nano 编辑配置文件
nano ~/.openclaw/openclaw.json

# 或使用 VS Code
code ~/.openclaw/openclaw.json
```

**编辑建议**:
- ✅ 只添加或修改需要的字段
- ✅ 保持 JSON 格式正确（逗号、引号、大括号）
- ✅ 不要删除或修改 `meta`、`wizard`、`browser`、`auth` 等系统字段
- ✅ 使用 `openclaw doctor` 验证配置

---

### 方法4: 提取配置片段（高级用户）

**适用场景**:
- 了解配置结构
- 提取模型配置片段
- 参考环境变量配置

**操作步骤**:

```bash
# 1. 打开模板文件
nano templates/openclaw-template.json

# 2. 找到你需要的配置（例如：火山引擎模型配置）
#    在 models.providers.volcengine 部分

# 3. 复制该配置块

# 4. 打开你的配置文件
nano ~/.openclaw/openclaw.json

# 5. 粘贴到 models.providers 中（不要覆盖其他提供商）

# 6. 修改 apiKey 为你的实际值
#     "apiKey": "YOUR_VOL_VOLCENGINE_API_KEY"
#     改为:
#     "apiKey": "AK-xxxxxxxxxxxxxxxx"

# 7. 保存并验证
openclaw doctor
```

**示例：添加阿里百炼提供商**

1. 打开 `templates/openclaw-template.json`
2. 找到 `bailian` 配置块（约第120行）
3. 复制整个 `bailian` 对象
4. 打开 `~/.openclaw/openclaw.json`
5. 定位到 `models.providers` 部分
6. 粘贴 `bailian` 配置
7. 修改 `apiKey` 为你的实际值
8. 保存并运行 `openclaw doctor` 验证

---

## 🔐 环境变量配置

推荐使用环境变量存储敏感信息（API Key、Token等）。

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

参考 `env-template.txt` 文件：

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
      },
      "bailian": {
        "baseUrl": "https://dashscope.aliyuncs.com/compatible-mode/v1",
        "apiKey": "${BAILIAN_API_KEY}",
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

## 📋 配置验证

无论使用哪种方法配置，最后都要验证配置：

```bash
# 运行诊断
openclaw doctor

# 检查配置
openclaw config list

# 检查模型配置
openclaw models list

# 检查 Gateway 状态
openclaw gateway status
```

**预期输出**:

```bash
✅ OpenClaw CLI: 已安装 v2026.3.23
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
- 日志: `~/.openclaw/logs/`

### Q: 如何重置配置？

**A:**
```bash
# 1. 备份现有配置
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.backup

# 2. 删除配置文件
rm ~/.openclaw/openclaw.json

# 3. 重新运行配置向导
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

# 或创建时间戳备份
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.backup.$(date +%Y%m%d_%H%M%S)
```

### Q: 配置文件格式错误怎么办？

**A:**
```bash
# 1. 使用 openclaw doctor 诊断
openclaw doctor

# 2. 使用 JSON 验证工具
cat ~/.openclaw/openclaw.json | python3 -m json.tool

# 3. 如果无法修复，恢复备份
cp ~/.openclaw/openclaw.json.backup ~/.openclaw/openclaw.json

# 4. 或重新初始化
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.broken
openclaw onboard --install-daemon
```

### Q: 为什么模板文件不能直接使用？

**A:**

模板文件是**参考模板**，不是完整的配置文件：

1. **缺少系统字段**: `meta`、`wizard`、`browser`、`auth`
2. **由OpenClaw自动管理**: 这些字段不应手动修改
3. **直接覆盖会导致错误**: 配置文件格式错误，Gateway 启动失败

**正确做法**:
- 新手 → 使用 `openclaw onboard` 配置向导
- 高级用户 → 参考模板，手动编辑现有配置文件
- 提取片段 → 只复制需要的配置，不要覆盖整个文件

### Q: 如何检查配置是否正确？

**A:**
```bash
# 1. 使用 openclaw doctor 全面诊断
openclaw doctor

# 2. 检查 JSON 格式是否正确
cat ~/.openclaw/openclaw.json | python3 -m json.tool

# 3. 检查 Gateway 是否正常启动
openclaw gateway status

# 4. 测试模型是否可用
openclaw models list
```

### Q: 配置文件中有哪些关键字段？

**A:**

**系统字段（不要删除）**:
- `meta`: 版本信息和最后修改时间
- `wizard`: 配置向导状态
- `browser`: 浏览器配置（如已启用）
- `auth`: 认证配置（如已配置）

**用户字段（可以修改）**:
- `models`: 模型提供商配置
- `agents`: Agent 默认配置
- `gateway`: Gateway 配置
- `channels`: 消息平台配置
- `session`: 会话配置
- `plugins`: 插件配置
- `skills`: 技能配置

---

## 🚀 快速参考

### 新手推荐流程

```bash
# 1. 启动配置向导
openclaw onboard --install-daemon

# 2. 验证配置
openclaw doctor

# 3. 启动 Gateway
openclaw gateway start

# 4. 连接消息平台（如钉钉）
#    按照 docs/integration/dingtalk-integration.md 操作
```

### 高级用户流程

```bash
# 1. 备份配置
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.backup

# 2. 编辑配置
nano ~/.openclaw/openclaw.json

# 3. 验证配置
openclaw doctor

# 4. 重启 Gateway
openclaw gateway restart
```

### 添加新的提供商

```bash
# 1. 备份配置
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.backup

# 2. 编辑配置
nano ~/.openclaw/openclaw.json

# 3. 在 models.providers 中添加新提供商
#    从 templates/openclaw-template.json 复制配置

# 4. 验证配置
openclaw doctor

# 5. 重启 Gateway
openclaw gateway restart
```

### 使用环境变量

```bash
# 1. 创建 .env 文件
touch ~/.openclaw/.env
chmod 600 ~/.openclaw/.env

# 2. 编辑 .env 文件
nano ~/.openclaw/.env
# 添加: SILICONFLOW_API_KEY=sk-xxxxxx

# 3. 在配置文件中使用 ${VARIABLE}
nano ~/.openclaw/openclaw.json
# 修改: "apiKey": "${SILICONFLOW_API_KEY}"

# 4. 验证配置
openclaw doctor
```

---

## 📚 相关文档

- [API配置教程](../docs/configuration/api-configuration.md) - 详细的API提供商配置
- [快速上手](../docs/start/quickstart.md) - 5分钟快速上手
- [Docker部署](../docs/docker/docker-deployment.md) - Docker容器化部署
- [常见问题](../FAQ.md) - 教程常见问题解答

---

**提示**: 如果遇到配置问题，首先运行 `openclaw doctor` 诊断，然后参考本指南或相关文档。
