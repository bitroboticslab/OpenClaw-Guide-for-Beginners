<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# Android 部署指南

> 在 Android 手机上通过 Termux 部署 OpenClaw，随时随地使用 AI 助手

## 📋 前置要求

- Android 7.0 或更高版本
- 至少 2GB 可用存储空间
- Termux 应用

---

## 🔧 第一步：安装 Termux

### 方法一：F-Droid（推荐）

1. 下载并安装 [F-Droid](https://f-droid.org/)
2. 在 F-Droid 中搜索「Termux」
3. 安装 Termux

### 方法二：GitHub Releases

1. 访问 [Termux Releases](https://github.com/termux/termux-app/releases)
2. 下载最新的 APK 文件
3. 安装（需允许未知来源）

> ⚠️ **注意**：不建议从 Google Play 安装，版本过旧且不再维护

---

## 📥 第二步：配置 Termux 环境

### 初始化环境

打开 Termux，执行以下命令：

```bash
# 更新包列表
pkg update && pkg upgrade -y

# 安装必要依赖
pkg install -y git curl wget nodejs-lts

# 验证 Node.js 版本
node -v
# 应显示 v20.x 或更高
```

### 授予存储权限

```bash
# 获取存储权限
termux-setup-storage

# 在弹出的对话框中点击「允许」
```

---

## 📦 第三步：安装 OpenClaw

### 使用一键脚本（推荐）

```bash
# 运行安装脚本
curl -fsSL https://openclaw.ai/install.sh | bash
```

### 手动安装

```bash
# 创建工作目录
mkdir -p ~/openclaw && cd ~/openclaw

# 克隆仓库
git clone https://github.com/openclaw/openclaw.git .

# 安装依赖
npm install

# 构建
npm run build

# 配置全局命令
npm link
```

---

## ⚙️ 第四步：配置 API

> 详细的 API 配置请参考 [API 配置详解](../api-config/api-configuration.md)

```bash
# 启动配置向导
openclaw onboard --install-daemon
```

### 推荐平台

| 平台 | 新用户福利 | 注册链接 |
|------|------------|----------|
| 硅基流动 | 2000万 Tokens | [注册](https://cloud.siliconflow.cn/i/lva59yow) |
| 阿里百炼 | 免费额度 | [开通](https://bailian.console.aliyun.com) |
| 火山方舟 | 首月 8.91元 | [订阅](https://volcengine.com/L/tHxxM_WwYp4/) |

---

## 📱 第五步：使用 OpenClaw

### 命令行模式

```bash
# 启动交互式对话
openclaw chat

# 直接提问
openclaw ask "今天天气怎么样？"

# 执行任务
openclaw task "帮我整理一下最近的待办事项"
```

### Web 界面模式

```bash
# 启动 Web 服务
openclaw start

# 在手机浏览器访问
# http://localhost:3000
```

---

## 🔧 高级配置

### 配置开机自启

创建 Termux:Boot 配置：

```bash
# 安装 Termux:Boot（需额外安装 Termux:Boot 应用）
mkdir -p ~/.termux/boot

# 创建启动脚本
cat > ~/.termux/boot/openclaw.sh << 'EOF'
#!/data/data/com.termux/files/usr/bin/sh
sleep 10
openclaw start
EOF

# 添加执行权限
chmod +x ~/.termux/boot/openclaw.sh
```

### 后台运行

```bash
# 安装 tmux
pkg install tmux

# 创建新会话并启动
tmux new -s openclaw -d "openclaw start"

# 查看会话
tmux ls

# 进入会话
tmux attach -t openclaw

# 退出会话（保持后台运行）
# 按 Ctrl+B 然后按 D
```

---

## 🔍 常见问题排查

### 问题1：Node.js 版本过低

```bash
# 检查版本
node -v

# 如果版本低于 18，尝试以下方法
pkg uninstall nodejs
pkg install nodejs-lts
```

### 问题2：内存不足

**解决方案**：
- 关闭后台应用
- 使用轻量级模型（如 GLM-4-Flash）
- 增加 Termux 可用内存限制

### 问题3：网络连接问题

```bash
# 配置代理
export HTTP_PROXY=http://proxy:port
export HTTPS_PROXY=http://proxy:port

# 或使用国内镜像
npm config set registry https://registry.npmmirror.com
```

### 问题4：Termux 进程被杀

**解决方案**：
- 在系统设置中将 Termux 加入电池优化白名单
- 使用 tmux 后台运行
- 关闭省电模式

---

## 💡 使用技巧

### 桌面快捷方式

使用 Termux:Widget 创建桌面小部件：

```bash
# 安装 Termux:Widget
pkg install termux-widget

# 创建快捷方式目录
mkdir -p ~/.shortcuts

# 创建快捷命令
echo 'openclaw chat' > ~/.shortcuts/"AI Chat"
echo 'openclaw ask "$1"' > ~/.shortcuts/"AI Ask"
```

### 语音输入

配合 Termux 的语音识别功能：

```bash
# 安装 Termux:API
pkg install termux-api

# 使用语音输入
termux-speech-to-text | openclaw ask
```

---

## ⚠️ 限制说明

Android 部署存在以下限制：

1. **后台运行限制**：Android 系统可能会杀掉后台进程
2. **性能限制**：手机性能不如服务器，响应可能较慢
3. **电池消耗**：长时间运行会消耗电池
4. **网络限制**：移动网络可能不稳定

**建议**：
- 日常轻量使用推荐 Android 部署
- 重度使用推荐 [云服务器部署](../cloud/cloud-deployment-guide.md)

---

## 📚 进阶阅读

- [API 配置详解](../api-config/api-configuration.md) - 各平台配置方法
- [云服务器部署](../cloud/cloud-deployment-guide.md) - 24小时稳定运行方案
- [Termux 官方文档](https://wiki.termux.com)

---

## 💰 优惠链接汇总

| 平台 | 链接 | 优惠说明 |
|------|------|----------|
| 硅基流动 | [注册链接](https://cloud.siliconflow.cn/i/lva59yow) | 注册送 2000万 Tokens |
| 阿里百炼 | [开通链接](https://bailian.console.aliyun.com) | 新人免费额度 |
| 火山方舟 | [Coding Plan](https://volcengine.com/L/tHxxM_WwYp4/) | 首月 8.91 元起 |
| 智谱 GLM | [订阅链接](https://www.bigmodel.cn/glm-coding?ic=BUDVTRHUYH) | 年付 7 折优惠 |

> 通过以上链接注册可享受额外优惠，同时支持作者持续更新教程 ❤️

---

**上一页**：[云服务器部署指南](../cloud/cloud-deployment-guide.md) | **下一页**：[API 配置详解](../api-config/api-configuration.md)

<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->
