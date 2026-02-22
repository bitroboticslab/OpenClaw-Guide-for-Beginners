<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# 故障排除指南

> 诊断和解决OpenClaw的常见问题

## 📋 目录

- [问题类型快速索引](#-问题类型快速索引)
- [标准排查流程](#-标准排查流程)
- [安装问题](#-安装问题)
- [配置问题](#-配置问题)
- [网络问题](#-网络问题)
- [平台对接问题](#-平台对接问题)
- [性能问题](#-性能问题)
- [需要帮助](#-需要帮助)

---

## 🏷️ 问题类型快速索引

按症状快速定位问题：

| 症状 | 可能原因 | 查看章节 |
|------|---------|---------|
| `npm install` 失败 | Node.js版本过低 | [问题1](#问题1-npm安装失败) |
| `EACCES: permission denied` | 权限不足 | [问题2](#问题2-权限不足) |
| `Invalid API key` | API Key错误 | [问题3](#问题3-api-key无效) |
| `Connection refused` | 网络或代理问题 | [问题6](#问题6-网络连接失败) |
| 钉钉无响应 | Webhook配置错误 | [问题7](#问题7-钉钉消息无响应) |
| 响应慢 | 网络或模型性能 | [问题8](#问题8-ai响应速度慢) |

---

## 🔍 标准排查流程

### 第一步：收集信息

```bash
# 1. 检查OpenClaw版本
openclaw --version

# 2. 查看错误日志
openclaw logs --tail 50

# 3. 检查Gateway状态
openclaw gateway status
```

### 第二步：常见检查

```bash
# 1. 验证配置
openclaw config validate

# 2. 测试网络连接
curl -I https://docs.openclaw.ai

# 3. 检查系统资源
free -h    # 内存
df -h      # 磁盘
```

### 第三步：尝试修复

```bash
# 1. 重启Gateway
openclaw gateway restart

# 2. 清理缓存
openclaw cache clear

# 3. 如果问题仍存在，查看具体问题章节
```

---

## 🚀 安装问题

### 问题1: npm安装失败

**症状**：
```
npm ERR! Cannot install OpenClaw
```

**可能原因**：
- Node.js版本过低（需v22.0+）
- npm缓存损坏
- 网络连接问题

**解决方案**：

#### 步骤1: 检查Node.js版本

```bash
node --version
```

✅ **预期输出**: `v22.x.x` 或更高

❌ **如果版本过低，升级Node.js**:

```bash
# 使用nvm（推荐）
nvm install 20
nvm use 20

# 或直接下载
# https://nodejs.org/
```

#### 步骤2: 清理npm缓存

```bash
npm cache clean --force
```

#### 步骤3: 重新安装

```bash
npm install -g openclaw@latest
```

#### 步骤4: 验证安装

```bash
openclaw --version
```

✅ **成功示例**: `OpenClaw CLI v2026.2.x`

---

### 问题2: 权限不足

**症状**：
```
Error: EACCES: permission denied
```

**原因**: npm全局安装目录需要root权限

**解决方案**：

#### 选项1：修复npm权限（推荐）

```bash
# 创建新目录
mkdir ~/.npm-global

# 配置npm使用新目录
npm config set prefix '~/.npm-global'

# 添加到PATH
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

# 重新安装
npm install -g openclaw@latest
```

#### 选项2：使用sudo（临时方案）

```bash
sudo npm install -g openclaw@latest
```

⚠️ **注意**: sudo安装可能导致后续权限问题，推荐使用选项1

---

## 🔑 配置问题

### 问题3: API Key无效

**症状**：
```
Error: Invalid API key or authentication failed
```

**可能原因**：
- API Key格式错误
- API Key已过期
- API Key复制不完整

**解决方案**：

#### 步骤1: 验证API Key格式

| 平台 | 格式要求 | 示例 |
|------|---------|------|
| 硅基流动 | `sk-`开头 | `sk-xxxxxxxxxx` |
| 火山引擎 | `AK-`开头 | `AK-xxxxxxxxxx` |
| 智谱GLM | 32字符 | `xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx` |

#### 步骤2: 重新配置

```bash
# 编辑配置文件
nano ~/.openclaw/openclaw.json

# 或使用命令配置
openclaw config set models.providers[0].apiKey "你的新密钥"
```

#### 步骤3: 测试连接

```bash
openclaw test api
```

✅ **成功输出**: API连接正常
❌ **失败输出**: 检查API Key是否正确

---

### 问题4: 配置文件损坏

**症状**：
```
Error: Invalid configuration file
```

**解决方案**：

#### 步骤1: 备份当前配置

```bash
cp ~/.openclaw/config.json ~/.openclaw/config.json.backup
```

#### 步骤2: 验证配置语法

```bash
openclaw config validate
```

#### 步骤3: 重新初始化

```bash
openclaw init
```

⚠️ **注意**: 这会重置配置，记得恢复API Key

---

### 问题5: 找不到配置文件

**症状**：
```
Error: Configuration file not found
```

**解决方案**：

#### 步骤1: 检查配置文件位置

```bash
ls -la ~/.openclaw/config.json
```

#### 步骤2: 如果不存在，创建默认配置

```bash
openclaw init
```

#### 步骤3: 配置API Key

参考 [API配置详解](../api-config/api-configuration.md)

---

## 🌐 网络问题

### 问题6: 网络连接失败

**症状**：
```
Error: Connection refused
Error: Network timeout
```

**可能原因**：
- 防火墙阻止
- 代理配置错误
- 网络不稳定

**解决方案**：

#### 步骤1: 检查防火墙

```bash
# Linux (ufw)
sudo ufw status

# 如果防火墙启用，开放端口
sudo ufw allow 18789

# CentOS (firewalld)
sudo firewall-cmd --add-port=18789/tcp --permanent
sudo firewall-cmd --reload
```

#### 步骤2: 检查代理设置

```bash
# 查看环境变量
echo $http_proxy
echo $https_proxy

# 如果需要配置代理
export http_proxy=http://proxy-server:port
export https_proxy=http://proxy-server:port
```

#### 步骤3: 测试网络连接

```bash
# 测试OpenClaw服务器
curl -I https://docs.openclaw.ai

# 测试API服务器（示例）
curl -I https://api.siliconflow.cn
```

---

## 💬 平台对接问题

### 问题7: 钉钉消息无响应

**症状**：
- 钉钉发送消息后无回复
- Gateway日志显示连接成功但无消息

**可能原因**：
- Webhook URL配置错误
- 钉钉应用权限不足
- 服务器无法被钉钉访问

**解决方案**：

#### 步骤1: 检查Webhook URL

```bash
# 查看配置
cat ~/.openclaw/openclaw.json | grep webhook
```

确保URL格式正确：`https://your-domain.com/webhook/ddingtalk`

#### 步骤2: 检查钉钉应用权限

在钉钉开放平台确认以下权限已启用：
- ✅ 发送工作消息
- ✅ 获取机器人信息
- ✅ 读取用户信息

#### 步骤3: 测试Webhook可访问性

```bash
# 从本地测试
curl -X POST https://your-domain.com/webhook/ddingtalk

# 从钉钉服务器测试
# 使用钉钉提供的调试工具
```

#### 步骤4: 查看Gateway日志

```bash
openclaw logs --tail 100 | grep ddingtalk
```

查看是否有错误消息

---

### 问题8: 飞书对接失败

**症状**：
```
Error: Feishu authentication failed
```

**解决方案**：

#### 步骤1: 验证App ID和App Secret

```bash
# 查看配置
cat ~/.openclaw/openclaw.json | grep feishu
```

#### 步骤2: 检查事件订阅URL

在飞书开放平台，确保事件订阅URL配置正确：
- 格式：`https://your-domain.com/webhook/feishu`
- 状态：✅ 已验证

#### 步骤3: 验证事件加密Key

如果启用了事件加密，确保Key与OpenClaw配置一致

详细步骤参考 [飞书对接教程](../platform-integration/feishu-integration.md)

---

## ⚡ 性能问题

### 问题9: AI响应速度慢

**症状**：
- 发送消息后需要等待10秒以上
- 预繁超时

**可能原因**：
- 网络延迟
- 模型性能问题
- 服务器资源不足

**解决方案**：

#### 步骤1: 测试网络延迟

```bash
# 测试到API服务器的延迟
ping api.siliconflow.cn
```

#### 步骤2: 切换到更快的模型

参考 [模型选择指南](../api-config/model-comparison.md)

推荐快速模型：
- `siliconflow/DeepSeek-V3`
- `bailian/qwen-turbo`

#### 步骤3: 检查系统资源

```bash
# 检查CPU使用
top

# 检查内存使用
free -h

# 检查磁盘IO
iostat -x 1
```

#### 步骤4: 优化配置

降低并发请求数、减少上下文长度等

---

### 问题10: 内存占用过高

**症状**：
```
Error: Out of memory
```

**解决方案**：

#### 步骤1: 检查内存使用

```bash
free -h
ps aux | grep openclaw
```

#### 步骤2: 清理缓存

```bash
openclaw cache clear
```

#### 步骤3: 减少上下文长度

在配置中设置较小的 `maxContextLength`

#### 步骤4: 升级服务器

如果内存持续不足，考虑升级到更大内存的服务器

推荐: [阿里云](https://www.aliyun.com/activity/ecs/clawdbot?userCode=yyzsc1al) 或 [腾讯云](https://curl.qcloud.com/JnWPPHIH)

---

## 📞 需要帮助？

如果以上步骤无法解决问题：

### 收集诊断信息

```bash
# 生成诊断报告
openclaw diagnostics > diagnostics.log

# 查看日志
openclaw logs > logs.log
```

### 获取帮助

1. **GitHub Issues**: [提交问题](https://github.com/openclaw/openclaw/issues)
   - 附上 `diagnostics.log`
   - 描述问题和复现步骤

2. **Discord社区**: [加入讨论](https://discord.com/invite/clawd)
   - 实时获取帮助
   - 与其他用户交流

3. **官方文档**: [docs.openclaw.ai](https://docs.openclaw.ai)
   - 查找更多资源

---

## 🔗 相关资源

- [快速开始](../start/quickstart.md)
- [API配置详解](../api-config/api-configuration.md)
- [模型选择指南](../api-config/model-comparison.md)
- [成本优化指南](../api-config/cost-optimization.md)
- [云服务器部署](../cloud/cloud-deployment-guide.md)

---

**创建时间**: 2026-02-21
**最后更新**: 2026-02-22 (应用写作最佳实践)
**版本**: v2.0

<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->
