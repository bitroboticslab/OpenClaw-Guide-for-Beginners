## ⚙️ 配置模板和脚本

> ⚠️ **重要**: 模板文件仅供参考，请勿直接覆盖你的配置文件！

---

### 📋 配置模板

项目提供了配置模板供参考，**适用于理解配置结构**，**不推荐直接覆盖使用**。

| 模板文件 | 说明 | 用途 |
|---------|------|------|
| `templates/openclaw-template.json` | 主配置参考模板 | 了解配置结构，提取配置片段 |
| `templates/env-template.txt` | 环境变量模板 | 参考环境变量配置格式 |

**⚠️ 为什么不能直接覆盖？**

模板文件缺少系统配置（`meta`、`wizard`、`browser`、`auth`），直接覆盖会导致：
- ❌ `openclaw doctor` 报错
- ❌ Gateway 启动失败
- ❌ 丢失浏览器和认证配置

**✅ 推荐的使用方法：**

1. **使用配置向导（推荐新手）**
   ```bash
   openclaw onboard --install-daemon
   ```

2. **使用命令行配置**
   ```bash
   openclaw config set provider siliconflow
   openclaw config set api_key sk-xxxxxxxx
   ```

3. **手动编辑配置文件**
   ```bash
   nano ~/.openclaw/openclaw.json
   # 只修改需要的字段，不要删除系统字段！
   ```

**详细使用指南**: [查看模板使用指南](templates/README.md)

---

### 🛠️ 一键安装脚本

> ⚠️ **慎重使用**: 适用于全新安装，不适用于已有Open

Claw环境的用户

| 脚本 | 平台 | 下载方式 |
|------|------|---------|
| `install-windows.bat` | Windows | [下载](scripts/install-windows.bat) |
| `install-wsl.ps1` | WSL | [下载](scripts/install-wsl.ps1) |
| `install-linux.sh` | Linux | [下载](scripts/install-linux.sh) |
| `install-macos.sh` | macOS | [下载](scripts/install-macos.sh) |
| `install-docker.sh` | Docker | [下载](scripts/install-docker.sh) |

**使用方法（以Linux为例）**:

```bash
# 下载并运行
curl -fsSL https://raw.githubusercontent.com/Mr-tooth/OpenClaw-Guide-for-Beginners/main/scripts/install-linux.sh | bash

# 或分步执行
curl -O https://raw.githubusercontent.com/Mr-tooth/OpenClaw-Guide-for-Beginners/main/scripts/install-linux.sh
chmod +x install-linux.sh
./install-linux.sh
```

**脚本功能**:
- ✅ 自动检测系统环境
- ✅ 安装 Node.js（如未安装）
- ✅ 安装 OpenClaw
- ✅ 运行配置向导
- ✅ 提供后续配置指导

---

### 🔐 配置验证

无论使用哪种方法配置，最后都要验证：

```bash
# 运行诊断
openclaw doctor

# 检查模型配置
openclaw models list

# 检查 Gateway 状态
openclaw gateway status
```

**预期输出**:
```
✅ OpenClaw CLI: 已安装 v2026.2.19
✅ Node.js: 已安装 v22.22.0
✅ Gateway: 运行中
✅ 模型配置: 正常
```

---

**详细教程**: [API配置](docs/api-config/api-configuration.md) | [快速上手](docs/start/quickstart.md)
