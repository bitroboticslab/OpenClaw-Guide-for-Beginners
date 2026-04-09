<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# WSL 安装配置教程

> 在Windows Subsystem for Linux中部署OpenClaw，享受Windows和Linux的双重视角

---

## 📋 目录

- [前置条件](#-前置条件)
- [快速开始](#-快速开始)
- [安装WSL](#-安装wsl)
- [WSL配置优化](#-wsl配置优化)
- [在WSL中安装OpenClaw](#-在wsl中安装openclaw)
- [WSL网络配置](#-wsl网络配置)
- [Windows集成](#-windows集成)
- [常见问题](#-常见问题)

---

## ✅ 前置条件

### 系统要求

| 要求 | 最低版本 | 推荐版本 | 检查命令 |
|------|---------|---------|---------|
| Windows | 10 (Build 19044+) | 11 (22H2+) | `winver` |
| 内存 | 8GB | 16GB+ | 查看系统信息 |
| 存储 | 40GB | 100GB+ | 查看磁盘空间 |
| 网络 | 稳定连接 | 稳定连接 | - |

---

### 权限要求

✅ **管理员权限**: 安装和配置WSL需要管理员权限

<details>
<summary><b>💻 如何检查Windows版本</b></summary>

1. 按 `Win + R` 打开运行
2. 输入 `winver`
3. 查看Windows版本号

**Windows 10**: Build 19044 或更高
**Windows 11**: 任何版本都支持

</details>

---

## 🚀 快速开始

> 5分钟快速在WSL中部署OpenClaw

### 安装进度

| 步骤 | 任务 | 预计时间 | 状态 |
|------|------|---------|------|
| 1️⃣ | 安装WSL | 3分钟 | ⏳ 进行中 |
| 2️⃣ | 配置WSL | 1分钟 | ⏸️ 待开始 |
| 3️⃣ | 安装OpenClaw | 1分钟 | ⏸️ 待开始 |
| 4️⃣ | 配置API | 30秒 | ⏸️ 待开始 |
| 5️⃣ | 启动Gateway | 30秒 | ⏸️ 待开始 |

---

### 一键安装（推荐）✨

```powershell
# 以管理员身份运行PowerShell，然后执行以下命令

wsl --install
```

**此命令将**:
- ✅ 启用WSL功能
- ✅ 启用虚拟机平台
- ✅ 下载并安装Ubuntu（默认Linux发行版）
- ✅ 重启计算机

<details>
<summary><b>⚙️ 自定义Linux发行版</b></summary>

```powershell
# 安装指定发行版
wsl --install -d Ubuntu-22.04

# 查看可用发行版
wsl --list --online
```

</details>

---

## 📦 安装WSL

### 方式1: 使用wsl --install（推荐）✨

**适用场景**: Windows 10 (Build 19044+) 或 Windows 11

#### 步骤

1. **打开PowerShell（管理员）**
   - 右键点击开始菜单
   - 选择 "Windows PowerShell (管理员)"
   - 或按 `Win + X` → "Windows PowerShell (管理员)"

2. **执行安装命令**
   ```powershell
   wsl --install
   ```

3. **重启计算机**
   - 安装完成后会提示重启
   - 保存所有工作后重启

4. **首次启动配置**
   - 重启后会自动打开Ubuntu
   - 设置用户名和密码

✅ **成功标志**: 可以在Ubuntu终端中运行Linux命令

---

### 方式2: 手动安装

**适用场景**: 更细粒度控制，或WSL 1

#### 启用WSL功能

```powershell
# 启用WSL
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# 启用虚拟机平台
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# 设置WSL 2为默认
wsl --set-default-version 2

# 重启
shutdown /r /t 0
```

---

### 方式3: 使用Docker Desktop

**适用场景**: 已使用Docker Desktop，需要WSL 2

#### 启用WSL 2

1. **下载Docker Desktop**
   - 访问: https://www.docker.com/products/docker-desktop
   - 下载并安装

2. **启用WSL 2集成**
   - 打开Docker Desktop
   - Settings → General → 勾选 "Use the WSL 2 based engine"
   - Settings → Resources → WSL Integration → 勾选 "Enable integration with my default WSL distro"

✅ **成功标志**: Docker Desktop中可以看到WSL发行版

---

### 验证WSL安装

```powershell
# 查看WSL状态
wsl --status

# 查看已安装的发行版
wsl --list --verbose
```

✅ **成功输出**:
```
默认分发：Ubuntu-22.04
默认版本：2
```

---

## ⚙️ WSL配置优化

### 内存配置

> WSL2默认使用50%的物理内存，可以根据需要调整

```powershell
# 创建.wslconfig文件（在用户目录下）
notepad $env:USERPROFILE\.wslconfig
```

**添加以下内容**:
```ini
[wsl2]
memory=16GB           # 限制内存为16GB
processors=4          # 限制使用4个CPU核心
swap=2GB              # 限制交换空间为2GB
swapFile=D:\\wsl-swap.vhdx  # 自定义交换文件位置
```

**保存并重启WSL**:
```powershell
wsl --shutdown
```

---

### 性能优化

#### 1. 禁用WSL时间同步

WSL 2默认与Windows同步时间，可以禁用以提高性能：

```ini
[wsl2]
memory=16GB
processors=4
swap=2GB
# 禁用时间同步
systemd=false
```

---

#### 2. 优化文件系统性能

WSL 2的文件系统性能可能不如原生Linux，优化建议：

- **尽量避免频繁访问Windows文件**（WSL 2会通过9P协议访问，速度慢）
- **将项目文件放在WSL文件系统**（`/home/username/`）
- **使用WSL 1**（如果需要频繁访问Windows文件）

---

#### 3. 启用systemd支持（WSL 0.67.0+）

WSL 2 (版本0.67.0+) 支持systemd，可以更好地运行服务：

```ini
[wsl2]
memory=16GB
processors=4
swap=2GB
# 启用systemd支持
systemd=true
```

---

## 📥 在WSL中安装OpenClaw

### 进入WSL

```powershell
# 进入默认WSL发行版
wsl

# 或进入指定发行版
wsl -d Ubuntu-22.04
```

✅ **成功标志**: 终端提示符变为Linux格式（如 `username@computername:~$`）

---

### 安装Node.js

```bash
# 更新包管理器
sudo apt update

# 安装Node.js 22（使用NodeSource）
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs

# 验证安装
node --version
npm --version
```

✅ **成功输出**:
```
v22.x.x
9.x.x
```

---

### 安OpenOpenClaw

```bash
# 安装OpenClaw
npm install -g openclaw@latest

# 验证安装
openclaw --version
```

✅ **成功输出**: `OpenClaw CLI v2026.3.x`

---

### 配置API Key

```bash
# 启动配置向导
openclaw init
```

按照提示操作：
1. 选择API提供商（推荐硅基流动）
2. 粘贴API Key
3. 选择默认模型
4. 完成配置

<details>
<summary><b>💡 推荐API平台</b></summary>

| 平台 | 新用户福利 | 链接 |
|------|-----------|------|
| ![推荐](https://img.shields.io/badge/推荐-新手-green) | 硅基流动 | 2000万Tokens免费 | [注册](https://cloud.siliconflow.cn/i/lva59yow) |
| ![高性价比](https://img.shields.io/badge/高性价比-blue) | 火山引擎 | 首月8.9元 | [订阅](https://volcengine.com/L/oqijuWrltl0/  ) |

</details>

---

## 🔌 WSL网络配置

### localhost访问

> WSL 2的网络是独立的，需要特殊配置才能从Windows访问

#### 方式1: 使用localhost（WSL 2.0.9+）

WSL 2.0.9+版本支持localhost自动转发：

```bash
# 在WSL中启动Gateway
openclaw gateway start
```

然后在Windows浏览器访问: http://localhost:18789

✅ **优势**: 无需额外配置

---

#### 方式2: 使用WSL IP地址

适用于旧版本WSL：

```wsl
# 在WSL中查询IP地址
ip addr show eth0
```

记录IP地址（如 `172.20.10.5`），然后在Windows浏览器访问:
`http://172.20.10.5:18789`

---

### 防火墙配置

#### Windows防火墙

```powershell
# 允许WSL访问（在Windows PowerShell中运行）
New-NetFirewallRule -DisplayName "WSL" -Direction Inbound -InterfaceAlias "vEthernet (WSL)" -Action Allow
```

---

#### WSL防火墙（可选）

```bash
# 安装并配置UFW
sudo apt install -y ufw
sudo ufw allow 18789/tcp
sudo ufw enable
```

---

### 端口转发（高级）

> 使Windows外网可以访问WSL中的服务

```powershell
# 创建端口转发规则（在Windows PowerShell中运行）
# 格式: netsh interface portproxy add v4tov4 listenport=[Windows端口] listenaddress=0.0.0.0 connectport=[WSL端口] connectaddress=[WSL IP]

netsh interface portproxy add v4tov4 listenport=18789 listenaddress=0.0.0.0 connectport=18789 connectaddress=172.20.10.5

# 查看规则
netsh interface portproxy show all
```

然后从外网访问: `http://[Windows公网IP]:18789`

[![阿里云](https://img.shields.io/badge/阿里云-推荐-purple)](https://www.aliyun.com/activity/ecs/clawdbot?userCode=yyzsc1al) 推荐云服务器

---

## 🔄 Windows集成

### Windows文件访问

> WSL可以访问Windows文件系统，反之亦然

#### 在WSL中访问Windows文件

Windows的C盘挂载在 `/mnt/c/`：

```bash
# 访问Windows的C盘
cd /mnt/c/Users/YourUsername/Documents

# 访问Windows的D盘
cd /mnt/d/Projects
```

#### 在Windows中访问WSL文件

WSL文件系统通过 `\\wsl$\` 访问：

```powershell
# 在Windows资源管理器中访问
\\wsl$\Ubuntu-22.04\home\username\.openclaw

# 在命令行中访问
cd \\wsl$\Ubuntu-22.04\home\username\.openclaw
```

---

### 剪贴板共享

WSL和Windows共享剪贴板：

```bash
# 安装xclip（如果需要）
sudo apt install -y xclip

# 复制到剪贴板
echo "Hello from WSL" | xclip -selection clipboard
```

然后在Windows中粘贴即可

---

### 任务栏集成

#### 添加WSL快捷方式

```powershell
# 创建快捷方式到桌面
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\WSL Ubuntu.lnk")
$Shortcut.TargetPath = "wsl.exe"
$Shortcut.Arguments = "-d Ubuntu-22.04"
$Shortcut.Save()
```

---

### Windows服务启动（高级）

> 配置Windows服务，开机自动启动WSL中的OpenClaw

#### 使用Task Scheduler

1. **打开Task Scheduler**
   - 按 `Win + R` → 输入 `taskschd.msc`

2. **创建任务**
   - 右侧 "Create Task"
   - General:
     - Name: `OpenClaw WSL`
     - Run whether user is logged on or not
   - Triggers → New:
     - Begin the task: At startup
   - Actions → New:
     - Program/script: `C:\Windows\System32\wsl.exe`
     - Add arguments: `-d Ubuntu-22.04 -u root -- openclaw gateway start`

3. **保存任务**

✅ **成功标志**: Windows重启后自动启动OpenClaw

---

## ⚠️ 常见问题

### Q: WSL安装失败？

**A:** 按照以下步骤排查：

1. **检查Windows版本**
   ```powershell
   winver
   ```
   确保是Windows 10 (Build 19044+) 或 Windows 11

2. **启用虚拟化**
   - 进入BIOS/UEFI
   - 启用Intel VT-x或AMD-V

3. **启用WSL功能**
   ```powershell
   dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
   dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
   ```

4. **重启计算机**

详细排查见[WSL故障排除](wsl-troubleshooting.md)

---

### Q: 如何切换WSL版本？

**A:**

```powershell
# 查看当前WSL版本
wsl --list --verbose

# 设置默认WSL版本
wsl --set-default-version 2

# 设置特定发行版的WSL版本
wsl --set-version Ubuntu-22.04 2

# 重启WSL
wsl --shutdown
```

---

### Q: WSL网络无法连接？

**A:** 常见原因和解决方案：

| 原因 | 解决方案 |
|------|---------|
| 防火墙阻止 | 允许WSL通过Windows防火墙 |
| WSL未启动 | 运行 `wsl` 启动WSL |
| IP地址变化 | 重新查询WSL IP地址 |
| 代理设置 | 配置 `http_proxy` 和 `https_proxy` |

详细解决方案见[WSL故障排除](wsl-troubleshooting.md)

---

### Q: 如何卸载WSL？

**A:**

```powershell
# 卸载指定发行版
wsl --unregister Ubuntu-22.04

# 禁用WSL功能
dism.exe /online /disable-feature /featurename:Microsoft-Windows-Subsystem-Linux /norestart
dism.exe /online /disable-feature /featurename:VirtualMachinePlatform /norestart

# 重启
shutdown /r /t 0
```

⚠️ **警告**: 此操作会删除所有WSL数据和Linux发行版

---

### Q: WSL内存占用过高？

**A:** 优化.wslconfig：

```ini
[wsl2]
memory=8GB           # 限制内存
processors=4          # 限制CPU
swap=2GB              # 限制交换空间
pageReporting=false    # 禁用页面报告
```

然后重启WSL：`wsl --shutdown`

---

## 🚀 下一步

### WSL进阶

- [ ] 学习[WSL高级配置](wsl-advanced.md)
- [ ] 配置GUI应用支持（WSLg）
- [ ] 设置GPU加速

### OpenClaw配置

- [ ] 对接[消息平台](../platform-integration/platform-integration-overview.md)
- [ ] 配置[自动启动](../cloud/cloud-deployment-guide.md)
- [ ] 了解[安全配置](../advanced/security.md)

### 遇到问题？

- [ ] 查看[WSL故障排除](wsl-troubleshooting.md)
- [ ] 查看[常见问题](../../FAQ.md)
- [ ] 加入[Discord社区](https://discord.com/invite/clawd)

---

## 📊 相关资源

| 资源 | 链接 |
|------|------|
| WSL官方文档 | https://docs.microsoft.com/en-us/windows/wsl/ |
| WSL发行版列表 | https://docs.microsoft.com/en-us/windows/wsl/install |
| OpenClaw文档 | https://docs.openclaw.ai |
| Docker Desktop WSL2 | https://docs.docker.com/desktop/wsl/ |

---

**创建时间**: 2026-02-22
**最后更新**: 2026-02-22
**版本**: 1.0
**适用版本**: WSL 2.0.9+

<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->
