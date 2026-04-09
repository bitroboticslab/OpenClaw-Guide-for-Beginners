<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# macOS 安装指南

> 本教程适用于 macOS 用户，从零开始完成 OpenClaw 的安装和配置

## 📋 前置要求

- macOS 10.15 (Catalina) 或更高版本
- Homebrew（推荐）或手动安装
- 稳定的网络连接

---

## 🔧 第一步：安装 Node.js

### 方法一：使用 Homebrew（推荐）

```bash
# 安装 Homebrew（如未安装）
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 安装 Node.js 22
brew install node@22

# 验证安装
node -v
# 应显示 v22.x.x

npm -v
```

### 方法二：使用 nvm

```bash
# 安装 nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# 重新加载终端配置
source ~/.zshrc  # 或 source ~/.bash_profile

# 安装 Node.js 22
nvm install 22
nvm use 22

# 验证
node -v
```

### 方法三：官方安装包

1. 访问 [Node.js 官网](https://nodejs.org/)
2. 下载 macOS 安装包（LTS 22.x）
3. 运行安装程序
4. 终端验证：`node -v`

---

## 📥 第二步：安装 OpenClaw

### 一键安装

打开终端，执行：

```bash
# 运行官方安装脚本
curl -fsSL https://openclaw.ai/install.sh | bash
```

安装过程约 2-5 分钟，自动完成依赖安装和配置。

### 手动安装

```bash
# 克隆仓库
git clone https://github.com/openclaw/openclaw.git
cd openclaw

# 安装依赖
npm install

# 构建
npm run build

# 全局安装
npm link
```

---

## ⚙️ 第三步：配置 API

> 详细的 API 配置请参考 [API 配置详解](../api-config/api-configuration.md)

### 快速配置：硅基流动（新手推荐）

```bash
# 启动配置向导
openclaw onboard --install-daemon

# 选择 SiliconFlow 作为提供商
# 粘贴你的 API Key
```

**获取 API Key**：
1. 访问 [硅基流动](https://cloud.siliconflow.cn/i/lva59yow) 注册
2. 进入「API 密钥」→「创建新密钥」
3. 复制 API Key

### 其他推荐平台

| 平台 | 优势 | 注册链接 |
|------|------|----------|
| 阿里百炼 | 新人免费额度 | [开通](https://bailian.console.aliyun.com) |
| 火山方舟 | Coding Plan 首月 8.91元 | [订阅](https://volcengine.com/L/oqijuWrltl0/  ) |
| 智谱 GLM | 年付 7 折 | [订阅](https://www.bigmodel.cn/glm-coding?ic=BUDVTRHUYH) |

---

## 📱 第四步：配置消息平台（可选）

### 飞书对接（推荐新手）

详细的飞书配置步骤请参考 [飞书对接教程](../platform-integration/feishu-integration.md)

**快速配置**：

```bash
openclaw onboard --install-daemon

# 选择 Feishu (Lark Open Platform)
# 输入 App ID 和 App Secret
```

### 其他平台

| 平台 | 难度 | 教程链接 |
|------|------|----------|
| 钉钉 | ⭐⭐ | [钉钉对接教程](dingtalk.md) |
| Telegram | ⭐ | [Telegram对接教程](telegram.md) |
| 微信 | ⭐⭐⭐ | [微信对接教程](wechat.md) |

---

## ✅ 第五步：启动服务

```bash
# 启动 OpenClaw
openclaw gateway start

# 查看运行状态
openclaw status

# 查看日志
openclaw logs

# 停止服务
openclaw gateway stop
```

### 访问 Web 界面

启动后访问：http://localhost:3000

---

## 🍎 macOS 特殊配置

### 解决权限问题

如果遇到权限错误：

```bash
# 给予终端完全磁盘访问权限
# 系统偏好设置 → 安全性与隐私 → 隐私 → 完全磁盘访问权限
# 添加终端应用
```

### 配置开机自启

```bash
# 创建 launchd 服务
cat > ~/Library/LaunchAgents/com.openclaw.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.openclaw</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/bin/openclaw</string>
        <string>start</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
</dict>
</plist>
EOF

# 加载服务
launchctl load ~/Library/LaunchAgents/com.openclaw.plist
```

---

## 🔍 常见问题排查

### 问题1：`node: command not found`

**解决方案**：
```bash
# 检查 Node.js 是否安装
which node

# 如果使用 nvm，确保已加载
source ~/.zshrc
nvm use 22
```

### 问题2：安装脚本下载慢

**解决方案**：
- 使用代理或 VPN
- 使用手动安装方法
- 配置 npm 国内镜像：
```bash
npm config set registry https://registry.npmmirror.com
```

### 问题3：端口被占用

**解决方案**：
```bash
# 查看占用端口的进程
lsof -i :3000

# 结束进程
kill -9 <PID>

# 或更改端口
openclaw gateway start --port 3001
```

### 问题4：M1/M2 芯片兼容性

**解决方案**：
OpenClaw 已原生支持 Apple Silicon，无需额外配置。如遇问题：
```bash
# 确保使用 arm64 版本的 Node.js
node -p process.arch
# 应显示 arm64

# 如果显示 x64，重新安装 arm64 版本
arch -arm64 brew install node@22
```

---

## 📚 进阶阅读

- [API 配置详解](../api-config/api-configuration.md) - 各平台 API 配置方法
- [平台对接教程](README.md) - 飞书、钉钉等对接教程
- [云服务器部署](../cloud/cloud-deployment-guide.md) - 24小时在线部署方案

---

## 💰 优惠链接汇总

| 平台 | 链接 | 优惠说明 |
|------|------|----------|
| 硅基流动 | [注册链接](https://cloud.siliconflow.cn/i/lva59yow) | 注册送 2000万 Tokens |
| 阿里百炼 | [开通链接](https://bailian.console.aliyun.com) | 新人免费额度 |
| 火山方舟 | [Coding Plan](https://volcengine.com/L/oqijuWrltl0/  ) | 首月 8.91 元起 |
| 智谱 GLM | [订阅链接](https://www.bigmodel.cn/glm-coding?ic=BUDVTRHUYH) | 年付 7 折优惠 |

> 通过以上链接注册可享受额外优惠，同时支持作者持续更新教程 ❤️

---

**上一页**：[Windows 安装指南](../windows/README.md) | **下一页**：[Linux 安装指南](../linux/README.md)

<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->
