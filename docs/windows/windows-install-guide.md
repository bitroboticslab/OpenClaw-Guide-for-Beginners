<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# Windows 安装指南

> 本教程适用于 Windows 10/11 用户，从零开始完成 OpenClaw 的安装和配置

## 📋 前置要求

- Windows 10 或 Windows 11
- 管理员权限
- 稳定的网络连接

## 🔧 第一步：安装 Node.js

OpenClaw 需要 Node.js 22+ 版本。

### 方法一：使用 nvm 安装（推荐）

1. 下载 nvm-windows 安装包
   - 访问 [nvm-windows Releases](https://github.com/coreybutler/nvm-windows/releases)
   - 下载最新的 `nvm-setup.exe`

2. 以管理员身份运行安装程序

3. 打开 PowerShell（管理员模式），执行以下命令：

```powershell
# 安装 Node.js 22
nvm install 22

# 切换到 Node.js 22
nvm use 22

# 验证安装
node -v
# 应显示 v22.x.x
```

### 方法二：直接安装 Node.js

1. 访问 [Node.js 官网](https://nodejs.org/)
2. 下载 LTS 版本（22.x）
3. 运行安装程序，一路 Next
4. 重启 PowerShell 后验证：
```powershell
node -v
```

## 📥 第二步：安装 OpenClaw

### 一键安装（推荐）

打开 PowerShell（管理员模式），执行：

```powershell
# 运行官方安装脚本
iwr -useb https://openclaw.ai/install.ps1 | iex
```

安装过程约 2-5 分钟，会自动完成：
- 检测并安装依赖
- 下载 OpenClaw 核心文件
- 配置环境变量

### 手动安装

如遇网络问题，可以手动安装：

```powershell
# 克隆仓库
git clone https://github.com/openclaw/openclaw.git
cd openclaw

# 安装依赖
npm install

# 构建项目
npm run build
```

## ⚙️ 第三步：配置 API

OpenClaw 需要配置大模型 API 才能运行。推荐以下平台：

### 推荐一：硅基流动（新手推荐）

**优势**：注册送 2000万 Tokens，邀请双方各得代金券

1. 访问 [硅基流动官网](https://cloud.siliconflow.cn/i/lva59yow) 注册账号
2. 进入「模型广场」，选择想要使用的模型
3. 点击右上角头像 → 「API 密钥」→「创建新密钥」
4. 复制 API Key

**配置 OpenClaw：**

```bash
# 启动配置向导
openclaw onboard --install-daemon

# 选择模型提供商时选择 SiliconFlow
# 粘贴刚才复制的 API Key
```

### 推荐二：阿里百炼

**优势**：新人免费额度，Coding Plan 套餐性价比高

1. 访问 [阿里云百炼](https://bailian.console.aliyun.com) 开通服务
2. 开通新人免费额度
3. 获取 API Key：控制台 → API-KEY 管理 → 创建 API Key
4. 参考 [百炼官方文档](https://help.aliyun.com/zh/model-studio/openclaw) 配置 OpenClaw

### 推荐三：火山方舟 Coding Plan

**优势**：Lite 套餐首月仅 8.91 元，支持多款顶级模型

1. 访问 [火山方舟 Coding Plan](https://volcengine.com/L/oqijuWrltl0/  )
2. 选择套餐（Lite/Pro），使用邀请码可享 9 折
3. 获取 API Key
4. 配置 OpenClaw

> 💡 **提示**：Coding Plan 支持 Doubao、GLM、DeepSeek、Kimi 等多款模型，一个订阅多模型可用！

## 📱 第四步：配置消息平台（可选）

OpenClaw 支持多种消息平台，推荐新手从飞书开始：

### 飞书配置步骤

1. 创建飞书开发者账号
   - 访问 [飞书开放平台](https://open.feishu.cn)
   - 创建企业自建应用

2. 配置应用权限
   - 进入「权限管理」
   - 添加以下权限：
     - `im:message` - 获取与发送消息
     - `im:message:send_as_bot` - 以应用身份发消息

3. 获取凭证
   - 复制 App ID 和 App Secret

4. 配置 OpenClaw
```bash
openclaw onboard --install-daemon
# 选择 Feishu (Lark Open Platform)
# 输入 App ID 和 App Secret
```

详细的飞书对接教程请参考 [飞书对接文档](../platform-integration/feishu-integration.md)

## ✅ 第五步：启动服务

```bash
# 启动 OpenClaw
openclaw start

# 查看状态
openclaw status

# 查看日志
openclaw logs
```

启动成功后，你可以：
- 访问 Web 界面：http://localhost:3000
- 通过配置的消息平台与 AI 对话

## 🔍 常见问题排查

### 问题1：`node` 命令不存在

**解决方案**：
- 确认 Node.js 安装成功
- 重启 PowerShell 或重启电脑
- 检查环境变量是否包含 Node.js 路径

### 问题2：安装脚本下载失败

**解决方案**：
- 检查网络连接
- 尝试使用代理或 VPN
- 使用手动安装方法

### 问题3：API 连接失败

**解决方案**：
- 检查 API Key 是否正确
- 确认账户余额充足
- 检查网络是否能访问 API 服务

### 问题4：权限不足

**解决方案**：
- 以管理员身份运行 PowerShell
- 右键 PowerShell → 「以管理员身份运行」

## 📚 进阶阅读

- [API 配置详解](../api-config/api-configuration.md)
- [平台对接教程](../platform-integration/README.md)
- [进阶配置优化](../advanced/README.md)

---

## 💰 优惠链接汇总

| 平台 | 链接 | 优惠说明 |
|------|------|----------|
| 硅基流动 | [注册链接](https://cloud.siliconflow.cn/i/lva59yow) | 注册送 2000万 Tokens |
| 阿里百炼 | [开通链接](https://bailian.console.aliyun.com) | 新人免费额度 |
| 火山方舟 | [Coding Plan](https://volcengine.com/L/oqijuWrltl0/  ) | 首月 8.91 元起 |
| 智谱 GLM | [订阅链接](https://www.bigmodel.cn/glm-coding?ic=BUDVTRHUYH) | 年付优惠 |

> 通过以上链接注册可享受额外优惠，同时支持作者持续更新教程 ❤️

---

**上一页**：[返回首页](../../README.md) | **下一页**：[macOS 安装指南](../macos/README.md)

<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->
