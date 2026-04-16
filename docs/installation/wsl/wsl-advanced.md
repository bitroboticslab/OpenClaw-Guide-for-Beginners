<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# WSL 高级配置

> 深入配置WSL，提升性能和功能

---

## 📋 目录

- [WSL 2虚拟机配置](#-wsl-2虚拟机配置)
- [多WSL发行版管理](#-多wsl发行版管理)
- [GUI应用支持（WSLg）](#-gui应用支持wslg)
- [GPU加速配置](#-gpu加速配置)
- [systemd支持](#-systemd支持)
- [性能优化技巧](#-性能优化技巧)
- [WSL1和WSL2混合使用](#-wsl1和wsl2混合使用)
- [高级网络配置](#-高级网络配置)

---

## 🖥️ WSL 2虚拟机配置

### 虚拟机配置文件位置

`.wslconfig` 文件位于Windows用户目录：

```
C:\Users\[用户名]\.wslconfig
```

---

### 完整配置示例

```ini
[wsl2]
# 内存配置
memory=16GB           # 限制内存为16GB
swap=2GB              # 限制交换空间为2GB
swapFile=D:\\wsl-swap.vhdx  # 自定义交换文件位置

# CPU配置
processors=4          # 限制使用4个CPU核心

# 内核配置
kernelCommandLine=     # 传递给Linux内核的命令行参数

# 性能优化
pageReporting=false    # 禁用页面报告
nestedVirtualization=true  # 启用嵌套虚拟化
vmIdleTimeout=60      # WSL虚拟机空闲超时（分钟）

# systemd支持
systemd=true         # 启用systemd支持

# 调试配置
debugConsole=true    # 在启动时显示WSL调试控制台

# 自动挂载配置
automount=true       # 启用自动挂载
automountRoot=/      # 自动挂载根目录
automountOptions="metadata,uid=1000,gid=1000,umask=022,fmask=111"  # 挂载选项

# 网络配置
networkingMode=mirrored  # 网络模式（mirrored/nat）
firewall=true        # 启用防火墙
dnsTunneling=true    # 启用DNS隧道
autoProxy=true       # 启用自动代理

[experimental]
# 实验性功能
autoMemoryReclaim=gradual  # 自动内存回收（slow/gradual）
sparseVhd=true      # 启用稀疏VHD

[user]
# 用户自定义配置
defaultShell=/bin/bash  # 默认shell
```

---

### 配置说明

#### 内存相关

| 配置项 | 说明 | 推荐值 |
|--------|------|--------|
| `memory` | 限制WSL使用的内存 | 8GB-32GB |
| `swap` | 限制交换空间 | 2GB-8GB |
| `swapFile` | 自定义交换文件位置 | `D:\\wsl-swap.vhdx` |

#### CPU相关

| 配置项 | 说明 | 推荐值 |
|--------|------|--------|
| `processors` | 限制WSL使用的CPU核心数 | 物理核心数-2 |

#### 网络相关

| 配置项 | 说明 | 推荐值 |
|--------|------|--------|
| `networkingMode` | 网络模式 | `mirrored`（WSL 2.0.0+） |
| `firewall` | 启用WSL防火墙 | `true` |
| `dnsTunneling` | 启用DNS隧道 | `true` |
| `autoProxy` | 启用自动代理 | `true` |

---

### 应用配置

编辑 `.wslconfig` 文件后，重启WSL：

```powershell
# 重启WSL
wsl --shutdown

# 重新启动
wsl
```

---

## 📦 多WSL发行版管理

### 安装多个发行版

```powershell
# 查看可用的发行版
wsl --list --online

# 安装多个发行版
wsl --install -d Ubuntu-22.04
wsl --install -d Debian-12
wsl --install -d OracleLinux-8
```

---

### 管理发行版

```powershell
# 查看已安装的发行版
wsl --list --verbose

# 设置默认发行版
wsl --set-default Ubuntu-22.04

# 设置特定发行版的WSL版本
wsl --set-version Debian-12 1
wsl --set-version Ubuntu-22.04 2
```

---

### 启动特定发行版

```powershell
# 启动默认发行版
wsl

# 启动特定发行版
wsl -d Ubuntu-22.04
wsl -d Debian-12

# 以特定用户身份启动
wsl -d Ubuntu-22.04 -u root
```

---

### 终止发行版

```powershell
# 终止所有WSL实例
wsl --shutdown

# 终止特定发行版
wsl --terminate Ubuntu-22.04
```

---

### 导出和导入发行版

```powershell
# 导出发行版为tar文件
wsl --export Ubuntu-22.04 ubuntu-backup.tar

# 导入tar文件为新发行版
wsl --import Ubuntu-Copy D:\WSL\Ubuntu-Copy ubuntu-backup.tar

# 指定版本号导入
wsl --import Ubuntu-Test D:\WSL\Ubuntu-Test ubuntu-backup.tar --version 2
```

---

### 卸载发行版

```powershell
# 卸载发行版（保留数据）
wsl --unregister Ubuntu-22.04

# 或删除整个发行版（删除数据）
wsl --unregister Ubuntu-22.04
rm "C:\Users\[用户名]\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu22.04onWindows_..."
```

---

## 🎨 GUI应用支持（WSLg）

### 检查WSLg支持

WSLg（WSL GUI）自Windows 11和Windows 10 (Build 19044+)开始支持。

```powershell
# 查看Windows版本
winver
```

✅ **支持版本**: Windows 11 或 Windows 10 (Build 19044+)

---

### 安装GUI应用

在WSL中安装图形应用：

```bash
# 更新包管理器
sudo apt update

# 安装GTK应用
sudo apt install -y gedit

# 安装Qt应用
sudo apt install -y kate

# 安装浏览器
sudo apt install -y firefox
```

---

### 运行GUI应用

```bash
# 运行gedit文本编辑器
gedit

# 运行Kate编辑器
kate

# 运行Firefox浏览器
firefox
```

✅ **成功标志**: GUI应用在Windows桌面上显示

---

### 配置显示环境

WSLg自动配置显示环境，但也可以手动配置：

```bash
# 查看显示环境
echo $DISPLAY
echo $WAYLAND_DISPLAY
```

---

### WSLg性能优化

#### 1. 禁用硬件加速（如果遇到问题）

```bash
# 禁用硬件加速
export LIBGL_ALWAYS_SOFTWARE=1
```

---

#### 2. 调整DPI设置

编辑 `/etc/wsl.conf`：

```ini
[boot]
systemd=true

[user]
defaultShell=/bin/bash

[interop]
appendWindowsPath=true
displayWindowsApps=true
```

---

#### 3. 优化GPU使用

`.wslconfig` 中启用嵌套虚拟化：

```ini
[wsl2]
nestedVirtualization=true
```

---

## 🎮 GPU加速配置

### 检查GPU支持

```bash
# 在WSL中检查GPU
lspci | grep -i vga

# 检查CUDA支持
nvidia-smi
```

---

### 安装CUDA工具包

```bash
# 添加CUDA仓库
wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-wsl-ubuntu.pin
sudo mv cuda-wsl-ubuntu.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.2.0/local_installers/cuda-repo-wsl-ubuntu-12-2-local_12.2.0-1_amd64.deb
sudo dpkg -i cuda-repo-wsl-ubuntu-12-2-local_12.2.0-1_amd64.deb
sudo cp /var/cuda-repo-wsl-ubuntu-12-2-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda

# 添加CUDA到PATH
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
```

---

### 验证CUDA安装

```bash
# 验证CUDA安装
nvcc --version

# 测试CUDA设备
python3 -c "import torch; print(torch.cuda.is_available())"
```

---

### GPU加速应用示例

#### 1. PyTorch GPU加速

```bash
# 安装PyTorch（CUDA版本）
pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

# 测试GPU加速
python3 -c "import torch; print('CUDA available:', torch.cuda.is_available())"
```

---

#### 2. TensorFlow GPU加速

```bash
# 安装TensorFlow（GPU版本）
pip3 install tensorflow[and-cuda]

# 测试GPU加速
python3 -c "import tensorflow as tf; print('GPU available:', tf.config.list_physical_devices('GPU'))"
```

---

## ⚙️ systemd支持

### 启用systemd

WSL 0.67.0+版本支持systemd。

#### 1. 检查WSL版本

```powershell
# 查看WSL版本
wsl --version
```

确保版本 ≥ 0.67.0

---

#### 2. 启用systemd

编辑 `.wslconfig` 文件：

```ini
[wsl2]
systemd=true
```

保存后重启WSL：

```powershell
wsl --shutdown
```

---

### 验证systemd

```bash
# 在WSL中检查systemd
systemctl --user

# 查看systemd服务状态
systemctl --user status

# 列出所有用户服务
systemctl --user list-units
```

---

### 使用systemd服务

#### 1. 创建systemd服务

创建服务文件 `/etc/systemd/system/openclaw.service`：

```ini
[Unit]
Description=OpenClaw Gateway
After=network.target

[Service]
Type=simple
User=ubuntu
ExecStart=/home/ubuntu/.local/bin/openclaw gateway start
Restart=on-failure
RestartSec=10
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
```

---

#### 2. 启用并启动服务

```bash
# 重载systemd配置
sudo systemctl daemon-reload

# 启用服务（开机自启）
sudo systemctl enable openclaw

# 启动服务
sudo systemctl start openclaw

# 查看服务状态
sudo systemctl status openclaw
```

---

#### 3. 查看服务日志

```bash
# 查看服务日志
sudo journalctl -u openclaw -f
```

---

## ⚡ 性能优化技巧

### 1. 禁用时间同步（提升性能）

```ini
[wsl2]
systemd=false  # 禁用systemd时间同步
```

---

### 2. 启用自动内存回收

```ini
[experimental]
autoMemoryReclaim=gradual  # gradual或slow
```

---

### 3. 使用稀疏VHD

```ini
[experimental]
sparseVhd=true  # 启用稀疏虚拟硬盘
```

---

### 4. 优化文件系统

```ini
[automount]
automountOptions="metadata,uid=1000,gid=1000,umask=022,fmask=111"
```

---

### 5. 使用WSL 1（如果需要频繁访问Windows文件）

```powershell
# 设置发行版使用WSL 1
wsl --set-version Ubuntu-22.04 1
```

⚠️ **注意**: WSL 1不支持Docker

---

### 6. 禁用不必要的服务

```bash
# 禁用snapd（如果不使用snap）
sudo systemctl disable snapd

# 禁用计时器服务
sudo systemctl disable apt-daily.timer
sudo systemctl disable apt-daily-upgrade.timer
```

---

## 🔀 WSL 1和WSL 2混合使用

### 使用场景

- **WSL 1**: 频繁访问Windows文件，需要快速文件IO
- **WSL 2**: 需要Docker支持，更好的系统调用兼容性

---

### 设置不同发行版使用不同版本

```powershell
# 设置Ubuntu使用WSL 2（推荐）
wsl --set-version Ubuntu-22.04 2

# 设置Debian使用WSL 1（频繁访问Windows文件）
wsl --set-version Debian-12 1
```

---

### 查看每个发行版的WSL版本

```powershell
# 查看详细信息
wsl --list --verbose
```

---

## 🌐 高级网络配置

### 镜像网络模式（WSL 2.0.0+）

镜像网络模式使WSL网络与Windows网络镜像一致：

```ini
[wsl2]
networkingMode=mirrored
```

**优势**:
- ✅ WSL IP地址固定
- ✅ 可以使用IPv6
- ✅ localhost自动转发
- ✅ 防火墙规则自动同步

---

### DNS隧道

启用DNS隧道，使用Windows DNS解析：

```ini
[wsl2]
dnsTunneling=true
```

---

### 自动代理

启用自动代理，使用Windows代理设置：

```ini
[wsl2]
autoProxy=true
```

---

### 自定义网络配置

编辑 `/etc/wsl.conf`：

```ini
[network]
generateResolvConf = false  # 禁用自动生成resolv.conf

[boot]
systemd = true
```

手动配置 `/etc/resolv.conf`：

```
nameserver 8.8.8.8
nameserver 8.8.4.4
```

---

## 🚀 下一步

### WSL相关

- [ ] 学习[WSL基本配置](wsl-setup.md)
- [ ] 配置[多发行版管理](#-多wsl发行版管理)
- [ ] 探索[GUI应用支持](#-gui应用支持wslg)

### OpenClaw配置

- [ ] 配置[Systemd服务](#-使用systemd服务)
- [ ] 设置[自动启动](../cloud/cloud-deployment-guide.md)
- [ ] 对接[消息平台](../platform-integration/platform-integration-overview.md)

### 遇到问题？

- [ ] 查看[WSL故障排除](wsl-troubleshooting.md)
- [ ] 查看[常见问题](../../FAQ.md)
- [ ] 加入[Discord社区](https://discord.com/invite/clawd)

---

## 📊 相关资源

| 资源 | 链接 |
|------|------|
| WSL高级配置 | https://docs.microsoft.com/en-us/windows/wsl/wsl-config |
| systemd支持 | https://devblogs.microsoft.com/commandline/systemd-support-is-now-available-in-wsl/ |
| WSLg文档 | https://docs.microsoft.com/en-us/windows/wsl/tutorials/gui-apps |
| GPU加速 | https://docs.nvidia.com/cuda/wsl-support |

---

**创建时间**: 2026-02-22
**最后更新**: 2026-02-22
**版本**: 1.0
**适用版本**: WSL 2.0.0+

<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->
