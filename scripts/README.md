<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# OpenClaw 安装脚本文档

> 一键安装脚本使用指南

---

## 📋 目录

- [脚本列表](#-脚本列表)
- [Windows 安装](#-windows-安装)
- [macOS 安装](#macos-安装)
- [Linux 安装](#-linux-安装)
- [WSL 安装](#-wsl-安装)
- [Docker 快速部署](#-docker-快速部署)
- [故障排除](#-故障排除)

---

## 📦 脚本列表

| 脚本 | 平台 | 文件大小 | 状态 |
|------|------|---------|------|
| install-windows.bat | Windows | 4.8KB | ✅ |
| install-macos.sh | macOS | 6.2KB | ✅ |
| install-linux.sh | Linux (Ubuntu/Debian/CentOS) | 6.2KB | ✅ |
| install-wsl.ps1 | Windows (WSL) | 9.9KB | ✅ |
| install-docker.sh | Docker (Linux/macOS/WSL) | 7.2KB | ✅ |

---

## 🪟 Windows 安装

### 前置条件

- Windows 10/11
- PowerShell 5.1+
- 管理员权限

---

### 快速开始

1. **下载脚本**
   ```powershell
   # 使用 PowerShell 下载
   Invoke-WebRequest -Uri "https://raw.githubusercontent.com/bitroboticslab/OpenClaw-Guide-for-Beginners/main/scripts/install-windows.bat" -OutFile "install-windows.bat"
   ```

2. **以管理员身份运行**
   - 右键点击 `install-windows.bat`
   - 选择「以管理员身份运行」

3. **按照提示完成安装**

---

### 安装流程

| 步骤 | 任务 | 说明 |
|------|------|------|
| 1/4 | 检查 Node.js 环境 | 自动安装 nvm-windows 和 Node.js 22 |
| 2/4 | 安装 OpenClaw | 从 get.openclaw.ai 下载安装 |
| 3/4 | 配置向导 | 选择 API 提供商并输入 API Key |
| 4/4 | 安装完成 | 显示启动命令和帮助链接 |

---

### 常见问题

**Q: nvm 安装失败？**

A: 手动下载 nvm-windows:
```powershell
Invoke-WebRequest -Uri "https://github.com/coreybutler/nvm-windows/releases/download/1.1.11/nvm-setup.exe" -OutFile "$env:TEMP\nvm-setup.exe"
Start-Process "$env:TEMP\nvm-setup.exe"
```

**Q: OpenClaw 命令找不到？**

A: 重新打开 PowerShell 或 CMD:
```powershell
# 刷新环境变量
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","User") + ";" + [System.Environment]::GetEnvironmentVariable("Path","Machine")
```

---

## 🍎 macOS 安装

### 前置条件

- macOS 12+ (Monterey 及以上)
- 终端权限

---

### 快速开始

1. **下载脚本**
   ```bash
   curl -O https://raw.githubusercontent.com/bitroboticslab/OpenClaw-Guide-for-Beginners/main/scripts/install-macos.sh
   ```

2. **运行脚本**
   ```bash
   chmod +x install-macos.sh
   ./install-macos.sh
   ```

---

### 安装流程

| 步骤 | 任务 | 说明 |
|------|------|------|
| 1/4 | 检查 macOS 版本 | 支持 Monterey/Ventura/Sonoma/Sequoia |
| 2/4 | 安装 Homebrew | 如果未安装则自动安装 |
| 3/4 | 安装 Node.js 22 | 使用 Homebrew 安装 |
| 4/4 | 安装 OpenClaw | 从 get.openclaw.ai 下载安装 |

---

### 常见问题

**Q: Homebrew 安装失败？**

A: 手动安装 Homebrew:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**Q: PATH 配置不生效？**

A: 运行以下命令:
```bash
source ~/.zprofile
```

---

## 🐧 Linux 安装

### 前置条件

- Ubuntu 18.04+ / Debian 10+ / CentOS 7+
- sudo 权限

---

### 快速开始

1. **下载脚本**
   ```bash
   curl -O https://raw.githubusercontent.com/bitroboticslab/OpenClaw-Guide-for-Beginners/main/scripts/install-linux.sh
   ```

2. **运行脚本**
   ```bash
   chmod +x install-linux.sh
   sudo ./install-linux.sh
   ```

---

### 安装流程

| 步骤 | 任务 | 说明 |
|------|------|------|
| 1/3 | 检查 Node.js 环境 | 支持所有主流 Linux 发行版 |
| 2/3 | 安装 OpenClaw | 从 get.openclaw.ai 下载安装 |
| 3/3 | 配置向导 | 选择 API 提供商并输入 API Key |

---

### 支持的发行版

| 发行版 | 状态 | 说明 |
|---------|------|------|
| Ubuntu | ✅ | 18.04, 20.04, 22.04, 24.04 |
| Debian | ✅ | 10, 11, 12 |
| CentOS | ✅ | 7, 8, 9 |
| Rocky Linux | ✅ | 8, 9 |
| AlmaLinux | ✅ | 8, 9 |

---

## 🪟 WSL 安装

### 前置条件

- Windows 10/11
- 管理员权限
- 支持的 Windows 版本:
  - Windows 10: 版本 2004 (内部版本 19041) 及以上
  - Windows 11: 所有版本

---

### 快速开始

1. **下载脚本**
   ```powershell
   Invoke-WebRequest -Uri "https://raw.githubusercontent.com/bitroboticslab/OpenClaw-Guide-for-Beginners/main/scripts/install-wsl.ps1" -OutFile "install-wsl.ps1"
   ```

2. **以管理员身份运行**
   ```powershell
   # 以管理员身份运行 PowerShell
   Set-ExecutionPolicy Bypass -Scope Process -Force
   .\install-wsl.ps1
   ```

---

### 安装流程

| 步骤 | 任务 | 说明 |
|------|------|------|
| 1/4 | 启用 WSL 2 | 自动启用必要功能 |
| 2/4 | 安装 Ubuntu | 自动安装 Ubuntu 22.04 LTS |
| 3/4 | 安装 OpenClaw | 在 WSL 中安装 OpenClaw |
| 4/4 | 配置 API Key | 在 WSL 中配置 API Key |

---

### 常见问题

**Q: WSL 未启用？**

A: 以管理员身份运行 PowerShell:
```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
wsl --set-default-version 2
```

**Q: Ubuntu 安装失败？**

A: 从 Microsoft Store 手动安装:
1. 打开 Microsoft Store
2. 搜索「Ubuntu」
3. 安装 Ubuntu 22.04 LTS

---

## 🐳 Docker 快速部署

### 前置条件

- Docker 20.10+
- Docker Compose (可选)

---

### 快速开始

1. **下载脚本**
   ```bash
   curl -O https://raw.githubusercontent.com/bitroboticslab/OpenClaw-Guide-for-Beginners/main/scripts/install-docker.sh
   ```

2. **运行脚本**
   ```bash
   chmod +x install-docker.sh
   ./install-docker.sh
   ```

---

### 部署流程

| 步骤 | 任务 | 说明 |
|------|------|------|
| 1/5 | 检查 Docker 环境 | 验证 Docker 是否运行 |
| 2/5 | 拉取镜像 | 拉取 openclaw/openclaw:latest |
| 3/5 | 配置 OpenClaw | 创建配置文件 |
| 4/5 | 停止旧容器 | 清理旧容器（如果存在） |
| 5/5 | 启动容器 | 启动 OpenClaw 容器 |

---

### 管理命令

| 操作 | 命令 |
|------|------|
| 查看状态 | `docker ps` |
| 查看日志 | `docker logs -f openclaw` |
| 停止容器 | `docker stop openclaw` |
| 启动容器 | `docker start openclaw` |
| 删除容器 | `docker rm -f openclaw` |
| 更新镜像 | `docker pull openclaw/openclaw:latest && docker stop openclaw && && docker rm openclaw && ./install-docker.sh` |

---

### 数据持久化

脚本会自动创建数据目录:

| 内容 | 路径 |
|------|------|
| 配置文件 | `./openclaw.json` |
| 数据目录 | `./data` |

**注意**: 配置文件设置为只读（ro），需要重新运行脚本来更新配置。

---

## ⚠️ 故障排除

### 常见错误

| 错误 | 原因 | 解决方案 |
|------|------|---------|
| Permission denied | 权限不足 | 使用 sudo 或以管理员身份运行 |
| Command not found | 命令不存在 | 重新打开终端或刷新 PATH |
| Network timeout | 网络问题 | 检查网络连接或使用代理 |
| Port already in use | 端口被占用 | 停止占用端口的进程 |

---

### Windows 权限问题

**错误**: 请以管理员身份运行此脚本！

**解决方案**:
```powershell
# 以管理员身份运行 PowerShell
Start-Process powershell -Verb runAs

# 或右键点击 PowerShell -^> 以管理员身份运行
```

---

### Linux 权限问题

**错误**: permission denied: ./install-linux.sh

**解决方案**:
```bash
# 添加执行权限
chmod +x install-linux.sh

# 运行脚本
sudo ./install-linux.sh
```

---

### macOS 版本问题

**错误**: 建议使用 macOS 12 (Monterey) 或更高版本

**解决方案**:
```bash
# 如果使用旧版本 macOS，可以继续安装
# 但某些功能可能无法正常工作
```

---

### Docker 问题

**错误**: Docker 未运行

**解决方案**:
```bash
# macOS
open Docker.app

# Linux
sudo systemctl start docker
sudo systemctl enable docker

# Windows
# 从开始菜单启动 Docker Desktop
```

---

### API Key 配置问题

**错误**: API Key 无效

**解决方案**:
```bash
# 手动配置
openclaw config set provider siliconflow
openclaw config set api_key YOUR_API_KEY

# 或重新运行配置向导
openclaw onboard --install-daemon
```

---

### 网络问题

**错误**: Connection timeout

**解决方案**:
```bash
# 使用代理
export http_proxy=http://proxy.example.com:8080
export https_proxy=http://proxy.example.com:8080

# 然后重新运行脚本
```

---

## 📞 获取帮助

### 官方资源

| 资源 | 链接 |
|------|------|
| OpenClaw 文档 | https://docs.openclaw.ai |
| GitHub 仓库 | https://github.com/openclaw/openclaw |
| Discord 社区 | https://discord.com/invite/clawd |

---

### 反馈问题

如果遇到问题，请：

1. 检查 [故障排除](#-故障排除) 部分
2. 查看 OpenClaw [常见问题](../FAQ.md)
3. 加入 [Discord 社区](https://discord.com/invite/clawd) 寻求帮助
4. 在 GitHub 提交 [Issue](https://github.com/bitroboticslab/OpenClaw-Guide-for-Beginners/issues)

---

## ✨ 下一步

安装完成后:

1. **配置 API Key** (如果未配置)
   ```bash
   openclaw config set provider siliconflow
   openclaw config set api_key YOUR_API_KEY
   ```

2. **启动 OpenClaw**
   ```bash
   openclaw gateway start
   ```

3. **查看状态**
   ```bash
   openclaw status
   ```

4. **开始使用**
   - 连接消息平台（Telegram/Discord/Signal等）
   - 或使用 Web 界面
   - 查看[快速开始](../start/quickstart.md)了解更多

---

## 📄 许可证

这些脚本遵循 MIT 许可证。

---

**创建时间**: 2026-02-22
**最后更新**: 2026-02-22
**版本**: 1.0

<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->
