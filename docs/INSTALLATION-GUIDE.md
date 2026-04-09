<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# OpenClaw 完整安装指南

> 详细的安装步骤和故障排除

---

## 📋 目录

- [安装方式选择](#-安装方式选择)
- [系统要求](#-系统要求)
- [安装方式详解](#-安装方式详解)
  - [一、一键安装脚本](#-一键安装脚本)
- [安装后配置](#-)
- [故障排除](#-故障排除)
- [卸载 OpenClaw](#-卸载-openclaw)

---

## 🎯 安装方式选择

根据你的需求和技能水平选择安装方式：

| 安装方式 | 难度 | 适合人群 | 优势 |
|---------|------|---------|------|
| **一键安装脚本** | ⭐ | 新手 | 自动化安装，简单快速 |
| **手动安装** | ⭐⭐ | 开发者 | 完全控制安装过程 |
| **Docker 部署** | ⭐⭐ | 服务器用户 | 隔离环境，易于管理 |
| **WSL 部署** | ⭐⭐⭐ | Windows 用户 | 在 WSL 中运行 OpenClaw |

---

## 💻 系统要求

### 最低要求

| 组件 | Linux | macOS | Windows |
|------|-------|-------|---------|
| 操作系统 | Ubuntu 18.04+ | macOS 12+ | Windows 10 (2004+) |
| 内存 | 2GB RAM | 2GB RAM | 4GB RAM |
| 磁盘空间 | 1GB | 1GB | 2GB |
| Node.js | 22+ | 22+ | 22+ |

### 推荐配置

| 组件 | 推荐 |
|------|------|
| 操作系统 | Ubuntu 22.04 LTS / macOS Ventura+ / Windows 11 |
| 内存 | 4GB+ RAM |
| 磁盘空间 | 5GB+ |
| 网络 | 稳定的互联网连接 |
| CPU | 2核+ |

---

## 🚀 安装方式详解

### 一、一键安装脚本（推荐新手）

#### 1. Windows 安装

**前置条件**:
- Windows 10/11
- PowerShell 5.1+
- 管理员权限

**安装步骤**:

1. **下载脚本**
   ```powershell
   # 方式1: 使用 PowerShell
   Invoke-WebRequest -Uri "https://raw.githubusercontent.com/bitroboticslab/OpenClaw-Guide-for-Beginners/main/scripts/install-windows.bat" -OutFile "install-windows.bat"

   # 方式2: 手动浏览器下载
   # 访问: https://github.com/bitroboticslab/OpenClaw-Guide-for-Beginners/blob/main/scripts/install-windows.bat
   ```

2. **以管理员身份运行**
   - 右键点击 `install-windows.bat`
   - 选择「以管理员管理员身份运行」

3. **按照提示完成安装**
   - 检查 Node.js 环境（要求 v22+）
   - 安装 OpenClaw
   - 配置 API Key

**验证安装**:
```powershell
# 检查版本
openclaw --version

# 检查状态
openclaw status
```

---

#### 2. macOS 安装

**前置条件**:
- macOS 12+ (Monterey 及以上)
- 终端权限

**安装步骤**:

1. **下载脚本**
   ```bash
   curl -O https://raw.githubusercontent.com/bitroboticslab/OpenClaw-Guide-for-Beginners/main/scripts/install-macos.sh
   ```

2. **运行脚本**
   ```bash
   chmod +x install-macos.sh
   ./install-macos.sh
   ```

3. **按照提示完成安装**
   - 检查 macOS 版本
   - 安装 Homebrew
   - 安装 Node.js 22
   - 安装 OpenClaw
   - 配置 API Key

**验证安装**:
```bash
# 检查版本
openclaw --version

# 检查状态
openclaw status
```

---

#### 3. Linux 安装

**前置条件**:
- Ubuntu 18.04+ / Debian 10+ / CentOS 7+
- sudo 权限

**安装步骤**:

1. **下载脚本**
   ```bash
   curl -O https://raw.githubusercontent.com/bitroboticslab/OpenClaw-Guide-for-Beginners/main/scripts/install-linux.sh
   ```

2. **运行脚本**
   ```bash
   chmod +x install-linux.sh
   sudo ./install-linux.sh
   ```

3. **按照提示完成安装**
   - 检查系统类型
   - 安装 Node.js 22
   - 安装 OpenClaw
   - 配置 API Key

**支持的发行版**:
- Ubuntu: 18.04, 20.04, 22.04, 24.04
- Debian: 10, 11, 12
- CentOS: 7, 8, 9
- Rocky Linux: 8, 9
- AlmaLinux: 8, 9

**验证安装**:
```bash
# 检查版本
openclaw --version

# 检查状态
openclaw status
```

---

#### 4. WSL 安装（Windows）

**前置条件**:
- Windows 10: 版本 2004 (内部版本 19041) 及以上
- Windows 11: 所有版本
- 管理员权限

**安装步骤**:

1. **下载脚本**
   ```powershell
   Invoke-WebRequest -Uri "https://raw.githubusercontent.com/bitroboticslab/OpenClaw-Guide-for-Beginners/main/scripts/install-wsl.ps1" -OutFile "install-wsl.ps1"
   ```

2. **以管理员身份运行 PowerShell**
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force
   .\install-wsl.ps1
   ```

3. **按照提示完成安装**
   - 启用 WSL 2
   - 安装 Ubuntu 22.04 LTS
   - 在 WSL 中安装 OpenClaw
   - 配置 API Key

**验证安装**:
```powershell
# 检查 WSL 状态
wsl --list --verbose

# 在 WSL 中检查
wsl -d Ubuntu -- openclaw --version
wsl -d Ubuntu -- openclaw status
```

---

#### 5. Docker 快速部署

**前置条件**:
- Docker 20.10+
- Docker Compose (可选)

**安装步骤**:

1. **下载脚本**
   ```bash
   curl -O https://raw.githubusercontent.com/bitroboticslab/OpenClaw-Guide-for-Beginners/main/scripts/install-docker.sh
   ```

2. **运行脚本**
   ```bash
   chmod +x install-docker.sh
   ./install-docker.sh
   ```

3. **按照提示完成部署**
   - 检查 Docker 环境
   - 拉取 OpenClaw 镜像
   - 配置 API Key
   - 启动容器

**验证部署**:
```bash
# 检查容器状态
docker ps | grep openclaw

# 查看日志
docker logs -f openclaw

# 进入容器
docker exec -it openclaw bash
```

---

### 二、手动安装（开发者）

#### 1. 安装 Node.js

**Linux (Ubuntu/Debian)**:
```bash
# 安装 NodeSource 仓库
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -

# 安装 Node.js 22
sudo apt install -y nodejs

# 验证安装
node --version  # 应显示 v22.x.x
npm --version
```

**macOS**:
```bash
# 使用 Homebrew 安装
brew install node@22

# 链接到系统（如果需要）
brew unlink node
brew link node@22

# 验证安装
node --version
npm --version
```

**Windows**:
```powershell
# 使用 nvm-windows 安装
nvm install 22
nvm use 22

# 验证安装
node --version
npm --version
```

---

#### 2. 安装 OpenClaw

**macOS/Linux/WSL2（官方推荐）**:
```bash
# 一键安装（自动安装 Node.js + OpenClaw）
curl -fsSL https://openclaw.ai/install.sh | bash

# 验证安装
openclaw --version
```

**Windows PowerShell**:
```powershell
# 一键安装
iwr -useb https://openclaw.ai/install.ps1 | iex

# 验证安装
openclaw --version
```

**手动安装（从源码）**:
```bash
# 克隆仓库
git clone https://github.com/openclaw/openclaw.git
cd openclaw

# 安装依赖
npm install

# 全局链接
npm link
```

---

## ⚙️ 安装后配置

### 1. 配置 API Key

**硅基流动（推荐）**:
```bash
openclaw config set provider siliconflow
openclaw config set api_key YOUR_API_KEY
```

**火山方舟**:
```bash
openclaw config set provider volcengine
openclaw config set api_key YOUR_API_KEY
```

**阿里百炼**:
```bash
openclaw config set provider bailian
openclaw config set api_key YOUR_API_KEY
```

**使用配置向导**:
```bash
openclaw onboard --install-daemon
```

---

### 2. 配置消息平台

**Telegram**:
```bash
openclaw config set channels.telegram.botToken YOUR_BOT_TOKEN
```

**Discord**:
```bash
openclaw config set channels.discord.botToken YOUR_BOT_TOKEN
openclaw config set channels.discord.clientId YOUR_CLIENT_ID
```

**Signal**:
```bash
# macOS
openclaw config set channels.signal.signalCliPath "/Applications/Signal.app/Contents/MacOS/Signal"

# Linux
openclaw config set channels.signal.signalCliPath "/usr/bin/signal-cli"
```

---

### 3. 启动 OpenClaw

**命令行启动**:
```bash
openclaw gateway start
```

**后台启动**:
```bash
openclaw gateway start --background
```

**Docker 启动**:
```bash
docker start openclaw
```

---

## 🐛 故障排除

### 问题1: Node.js 版本过低

**错误信息**:
```
Node.js 版本过低: v18.0.0，需要 22+
```

**解决方案**:
```bash
# Linux
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs

# macOS
brew install node@22

# Windows
nvm install 22
nvm use 22
```

---

### 问题2: OpenClaw 命令找不到

**错误信息**:
```
openclaw: command not found
```

**解决方案**:

**Linux/macOS**:
```bash
# 添加到 PATH
export PATH="$HOME/.local/bin:$PATH"
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

# 重新加载配置
source ~/.bashrc

# 验证
openclaw --version
```

**Windows**:
```powershell
# 刷新环境变量
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","User") + ";" + [System.Environment]::GetEnvironmentVariable("Path","Machine")

# 验证
openclaw --version
```

---

### 问题3: Docker 启动失败

**错误信息**:
```
Error: Cannot connect to the Docker daemon
```

**解决方案**:

**Linux**:
```bash
# 启动 Docker 服务
sudo systemctl start docker
sudo systemctl enable docker

# 验证
docker info
```

**macOS**:
```bash
# 启动 Docker Desktop
open Docker.app

# 验证
docker info
```

**Windows**:
```powershell
# 从开始菜单启动 Docker Desktop
# 或使用服务管理器启动 Docker Desktop Service
```

---

### 问题4: 端口被占用

**错误信息**:
```
Error: Port 18789 is already in use
```

**解决方案**:
```bash
# 查找占用端口的进程
sudo lsof -i :18789

# 或使用 netstat
sudo netstat -tlnp | grep 18789

# 停止占用端口的进程
sudo kill -9 <PID>

# 或更改 OpenClaw 端口
openclaw config set gateway.port 18790
```

---

### 问题5: 权限问题

**错误信息**:
```
Error: EACCES: permission denied
```

**解决方案**:

**修复目录权限**:
```bash
sudo chown -R $USER:$USER ~/.openclaw
chmod -R 755 ~/.openclaw
```

**修复文件权限**:
```bash
chmod 600 ~/.openclaw/openclaw.json
chmod 700 ~/.openclaw/credentials/
```

---

### 问题6: API Key 无效

**错误信息**:
```
Error: Invalid API key
```

**解决方案**:
```bash
# 重新配置 API Key
openclaw config set api_key YOUR_NEW_API_KEY

# 验证 API Key
openclaw validate --provider siliconflow --api-key YOUR_API_KEY

# 查看配置
openclaw config get
```

---

### 问题7: Gateway 启动失败

**错误信息**:
```
Error: Gateway failed to start
```

**解决方案**:
```bash
# 查看详细日志
openclaw logs --tail 100

# 检查配置
openclaw config get

# 检查端口
sudo lsof -i :18789

# 重启 Gateway
openclaw gateway restart

# 如果仍有问题，尝试完全重置
openclaw gateway stop
openclaw gateway start
```

---

## 🗑️ 卸载 OpenClaw

### Linux/macOS 卸载

```bash
# 停止 Gateway
openclaw gateway stop

# 删除 OpenClaw CLI
rm -rf ~/.local/bin/openclaw

# 删除 OpenClaw 数据目录
rm -rf ~/.openclaw

# 从 PATH 中移除（编辑 ~/.bashrc）
# 删除或注释: export PATH="$HOME/.local/bin:$PATH"

# 重新加载配置
source ~/.bashrc

# 验证卸载
which openclaw  # 应无输出
```

---

### Windows 卸载

```powershell
# 停止 Gateway
openclaw gateway stop

# 删除 OpenClaw CLI
Remove-Item -Path "$env:LOCALAPPDATA\openclaw" -Recurse -Force

# 删除 OpenClaw 数据目录
Remove-Item -Path "$env:USERPROFILE\.openclaw" -Recurse -Force

# 验证卸载
where openclaw  # 应无输出
```

---

### Docker 卸载

```bash
# 停止容器
docker stop openclaw

# 删除容器
docker rm openclaw

# 删除镜像（可选）
docker rmi openclaw/openclaw:latest

# 删除数据卷（可选）
docker volume rm openclaw-data

# 验证卸载
docker ps -a | grep openclaw  # 应无输出
```

---

## 📚 参考资源

- [官方文档](https://docs.openclaw.ai)
- [GitHub 仓库](https://github.com/openclaw/openclaw)
- [Discord 社区](https://discord.com/invite/clawd)
- [ClawHub 技能商店](https://clawhub.com)

---

**创建时间**: 2026-02-22 15:10 UTC
**版本**: 2.0
**作者**: junhang lai

<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->
