<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# Linux 安装指南

> 本教程适用于 Ubuntu/Debian/CentOS 等 Linux 发行版用户

## 📋 前置要求

- Linux 发行版：Ubuntu 20.04+ / Debian 11+ / CentOS 7+
- 终端访问权限
- 稳定的网络连接

---

## 🔧 第一步：安装 Node.js

### Ubuntu/Debian

```bash
# 更新包列表
sudo apt update

# 安装依赖
sudo apt install -y curl git

# 使用 NodeSource 安装 Node.js 22
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs

# 验证安装
node -v  # 应显示 v22.x.x
npm -v
```

### CentOS/RHEL

```bash
# 安装依赖
sudo yum install -y curl git

# 使用 NodeSource 安装 Node.js 22
curl -fsSL https://rpm.nodesource.com/setup_22.x | sudo bash -
sudo yum install -y nodejs

# 验证安装
node -v
```

### 使用 nvm（推荐，适用于所有发行版）

```bash
# 安装 nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# 重新加载配置
source ~/.bashrc

# 安装 Node.js 22
nvm install 22
nvm use 22
nvm alias default 22

# 验证
node -v
```

---

## 📥 第二步：安装 OpenClaw

### 一键安装

```bash
# 运行官方安装脚本
curl -fsSL https://openclaw.ai/install.sh | bash
```

### 手动安装

```bash
# 克隆仓库
git clone https://github.com/openclaw/openclaw.git
cd openclaw

# 安装依赖
npm install

# 构建
npm run build

# 全局链接
npm link
```

---

## ⚙️ 第三步：配置 API

> 详细的 API 配置请参考 [API 配置详解](../api-config/api-configuration.md)

### 快速配置

```bash
# 启动配置向导
openclaw onboard --install-daemon
```

根据提示选择 API 提供商并输入密钥。

### 推荐平台

| 平台 | 新用户福利 | 注册链接 |
|------|------------|----------|
| 硅基流动 | 2000万 Tokens | [注册](https://cloud.siliconflow.cn/i/lva59yow) |
| 阿里百炼 | 免费额度 | [开通](https://bailian.console.aliyun.com) |
| 火山方舟 | 首月 8.91元 | [订阅](https://volcengine.com/L/tHxxM_WwYp4/) |
| 智谱 GLM | 年付 7折 | [订阅](https://z.ai/subscribe) |

---

## 📱 第四步：配置消息平台（可选）

### 飞书对接

```bash
openclaw onboard --install-daemon

# 选择 Feishu (Lark Open Platform)
# 输入 App ID 和 App Secret
```

详细步骤参考 [飞书对接教程](../platform-integration/feishu-integration.md)

### 其他平台

| 平台 | 教程链接 |
|------|----------|
| 钉钉 | [钉钉对接教程](../platform-integration/dingtalk-integration.md) |
| Telegram | [Telegram对接教程](../platform-integration/telegram-integration.md) |

---

## ✅ 第五步：启动服务

```bash
# 启动 OpenClaw
openclaw start

# 查看状态
openclaw status

# 查看日志
openclaw logs -f

# 停止服务
openclaw stop
```

---

## 🐧 系统服务配置

### 创建 systemd 服务

```bash
# 创建服务文件
sudo cat > /etc/systemd/system/openclaw.service << 'EOF'
[Unit]
Description=OpenClaw AI Assistant
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=/home/$USER/.openclaw
ExecStart=/usr/local/bin/openclaw start
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# 重载 systemd
sudo systemctl daemon-reload

# 启用开机自启
sudo systemctl enable openclaw

# 启动服务
sudo systemctl start openclaw

# 查看状态
sudo systemctl status openclaw
```

---

## 🔍 常见问题排查

### 问题1：权限不足

```bash
# 确保当前用户有权限
sudo chown -R $USER:$USER ~/.openclaw

# 或使用 sudo 运行（不推荐）
sudo openclaw start
```

### 问题2：Node.js 版本过低

```bash
# 检查版本
node -v

# 如果低于 v22，使用 nvm 更新
nvm install 22
nvm use 22
nvm alias default 22
```

### 问题3：端口被占用

```bash
# 查看端口占用
sudo lsof -i :3000

# 结束占用进程
sudo kill -9 <PID>

# 或更改端口
openclaw start --port 3001
```

### 问题4：网络连接问题

```bash
# 配置代理（如需要）
export HTTP_PROXY=http://proxy:port
export HTTPS_PROXY=http://proxy:port

# 或配置 npm 镜像
npm config set registry https://registry.npmmirror.com
```

---

## 🔐 防火墙配置

### UFW（Ubuntu/Debian）

```bash
# 允许端口
sudo ufw allow 3000/tcp

# 查看状态
sudo ufw status
```

### firewalld（CentOS/RHEL）

```bash
# 开放端口
sudo firewall-cmd --permanent --add-port=3000/tcp
sudo firewall-cmd --reload
```

---

## 📚 进阶阅读

- [云服务器部署指南](../cloud/cloud-deployment-guide.md) - 24小时在线部署
- [API 配置详解](../api-config/api-configuration.md) - 各平台配置方法
- [平台对接教程](../platform-integration/README.md) - 飞书、钉钉等对接

---

## 💰 优惠链接汇总

| 平台 | 链接 | 优惠说明 |
|------|------|----------|
| 硅基流动 | [注册链接](https://cloud.siliconflow.cn/i/lva59yow) | 注册送 2000万 Tokens |
| 阿里百炼 | [开通链接](https://bailian.console.aliyun.com) | 新人免费额度 |
| 火山方舟 | [Coding Plan](https://volcengine.com/L/tHxxM_WwYp4/) | 首月 8.91 元起 |
| 智谱 GLM | [订阅链接](https://z.ai/subscribe) | 年付 7 折优惠 |

> 通过以上链接注册可享受额外优惠，同时支持作者持续更新教程 ❤️

---

**上一页**：[macOS 安装指南](../macos/README.md) | **下一页**：[云服务器部署指南](../cloud/cloud-deployment-guide.md)

<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->
