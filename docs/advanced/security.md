<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# 安全配置指南

> 保护你的OpenClClaw实例，确保数据和API密钥安全

---

## 🔐 核心安全原则

### 1. 最小权限原则
- 仅开放必要的端口
- 仅授予必需的文件权限
- 仅使用必要的API访问

### 2. 加密存储原则
- API密钥加密存储
- 敏感配置加密存储
- 通信使用加密协议

### 3. 隔离原则
- 不同用户会话隔离
- 开发/生产环境隔离
- 服务间网络隔离

---

## 🔑 API Key安全

### 1. 安全存储位置

OpenClaw自动将API密钥存储在加密的配置文件中：

**配置文件位置**：
```bash
~/.openclaw/openclaw.json
```

**敏感信息存储**：
```bash
~/.openclaw/credentials/
```

---

### 2. 文件权限设置

**设置配置文件权限（仅用户可读写）**：

```bash
chmod 600 ~/.openclaw/openclaw.json
chmod 700 ~/.openclaw/credentials/
```

**验证权限**：
```bash
ls -la ~/.openclaw/openclaw.json
ls -la ~/.openclaw/credentials/
```

**预期输出**：
```
-rw------- 1 user group 1234 Feb 22 12:00 openclaw.json
drwx------ 2 user group 4096 Feb 22 12:00 credentials/
```

---

### 3. 避免硬编码API密钥

❌ **不安全（不要这样做）**：

```json
{
  "models": {
    "apiKey": "sk-1234567890abcdef"  // 密钥明文暴露
  }
}
```

✅ **安全（推荐做法）**：

```bash
# 使用环境变量
export API_KEY="sk-1234567890abcdef"

# 或使用openclaw配置向导
openclaw init
```

---

### 4. 轮换API密钥

**定期轮换密钥（建议每3-6个月）**：

```bash
# 1. 在API平台生成新密钥
# 2. 更新OpenClaw配置
openclaiw config set models.providers[0].apiKey "新密钥"

# 3. 验证配置
openclaw config validate
```

---

## 🛡️ 文件系统安全

### 1. Workspace权限

**限制workspace访问权限**：

```bash
# 设置目录权限（仅用户可访问）
chmod 700 ~/.openclaw/workspace

# 限制敏感文件权限
chmod 600 ~/.openclaw/workspace/SOUL.md
chmod 600 ~/.openclaw/workspace/USER.md
chmod 600 ~/.openclaw/workspace/MEMORY.md
```

---

### 2. 日志文件权限

**保护日志文件**：

```bash
# 日志目录权限
chmod 750 ~/.openclaw/logs

# 日志文件权限
chmod 640 ~/.openclaw/logs/*.log
```

---

### 3. 会话数据隔离

**DingTalk用户隔离**（推荐）：

```json
{
  "session": {
    "dmScope": "per-channel-peer"
  }
}
```

这确保不同DingTalk用户的会话完全隔离，防止数据泄露。

---

## 🔥 防火墙配置

### 1. 基本防火墙规则

**Ubuntu/Debian (UFW)**：

```bash
# 启用UFW
ufw enable

# 默认拒绝所有入站流量
ufw default deny incoming

# 允许已建立的连接
ufw allow established

# 允许SSH（根据需要限制IP）
ufw allow from 你的IP to any port 22

# 允许OpenClaw Gateway（仅内网）
ufw allow from 127.0.0.1 to any port 18789

# 查看状态
ufw status
```

---

### 2. 云服务器防火墙

**阿里云轻量应用服务器**：

1. 进入控制台 → 防火墙
2. 添加规则：
   - 22端口（SSH）- 限制你的IP
   - 80端口（HTTP）- 如果需要
   - 443端口（HTTPS）- 如果需要

**腾讯云轻量应用服务器**：

1. 进入控制台 → 防火墙
2. 添加规则：
   - 22端口（SSH）- 限制你的IP
   - 80端口（HTTP）- 如果需要
   - 443端口（HTTPS）- 如果需要

---

### 3. OpenClaw Gateway保护

**将Gateway绑定到本地接口**（推荐）：

```json
{
  "gateway": {
    "host": "127.0.0.1",
    "port": 18789
  }
}
```

然后使用Nginx提供反向代理：

```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://127.0.0.1:18789;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

---

## 🔒 SSH安全加固

### 1. 禁用密码登录（使用SSH密钥）

**编辑SSH配置**：
```bash
nano /etc/ssh/sshd_config
```

**修改以下配置**：
```
PasswordAuthentication no
PubkeyAuthentication yes
```

**重启SSH服务**：
```bash
systemctl restart sshd
```

---

### 2. 修改SSH端口（可选）

**编辑SSH配置**：
```bash
nano /etc/ssh/sshd_config
```

**修改端口**：
```
Port 22222  # 改为非标准端口
```

**重启SSH服务**：
```bash
systemctl restart sshd
```

---

### 3. 限制root登录

**编辑SSH配置**：
```bash
nano /etc/ssh/sshd_config
```

**禁止root登录**：
```
PermitRootLogin no
```

**创建普通用户**：
```bash
adduser youruser
usermod -aG sudo youruser
```

---

## 🔍 插件安全

### 1. 插件白名单配置

**只启用可信插件**：

```json
{
  "plugins": {
    "allow": [
      "feishu",
      "ddingtalk",
      "wecom",
      "telegram"
    ]
  }
}
```

---

### 2. 审查插件权限

**检查插件请求的权限**：

```bash
# 查看插件列表
openclaw plugins list

# 查看插件详情
openclaw plugins info <plugin-name>
```

---

### 3. 禁用不安全插件

**避免使用需要child_process等敏感权限的插件**：

| 插件 | 风险等级 | 建议 |
|------|---------|------|
| qqbot | 🔴 高 | 禁用 |
| wecom | 🟡 中 | 谨慎使用 |
| feishu | 🟢 低 | 可用 |

---

## 🌐 网络安全

### 1. 使用HTTPS

**配置SSL证书（Let's Encrypt）**：

```bash
# 安装certbot
apt install certbot python3-certbot-nginx

# 获取证书
certbot --nginx -d your-domain.com

# 自动续期
certbot renew --dry-run
```

---

### 2. 配置反向代理

**Nginx配置示例**：

```nginx
server {
    listen 443 ssl http2;
    server_name your-domain.com;

    ssl_certificate /etc/letsencrypt/live/your-domain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/your-domain.com/privkey.pem;

    location / {
        proxy_pass http://127.0.0.1:18789;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

---

### 3. 限流保护

**Nginx限流配置**：

```nginx
# 在http块中定义限流区
limit_req_zone $binary_remote_addr zone=one:10m rate=10r/s;

# 在server或location块中应用
location / {
    limit_req zone=one burst=20;
    proxy_pass http://127.0.0.1:18789;
}
```

---

## 🔐 依赖安全

### 1. 定期更新依赖

```bash
# 更新npm依赖
npm update -g openclaw

# 检查过时的包
npm outdated
```

---

### 2. 使用npm audit

```bash
# 检查安全漏洞
npm audit

# 自动修复可修复的漏洞
npm audit fix

# 强制修复（可能破坏依赖）
npm audit fix --force
```

---

## 📊 安全检查清单

### 部署前检查

- [ ] API密钥加密存储（不在代码中硬编码）
- [ ] 配置文件权限设置为600
- [ ] SSH使用密钥认证
- [ ] 防火墙仅开放必要端口
- [ ] Gateway绑定到本地接口（127.0.0.1）
- [ ] 使用HTTPS（生产环境）

### 定期检查（建议每月）

- [ ] 运行npm audit检查依赖漏洞
- [ ] 检查OpenClaw版本更新
- [ ] 审查日志文件大小和内容
- [ ] 检查磁盘空间使用
- [ ] 验证防火墙规则

### 每季度检查

- [ ] 轮换API密钥
- [ ] 更新SSL证书
- [ ] 审查插件列表
- [ ] 检查用户权限

---

## 🔧 常见安全问题

### Q: 配置文件权限不安全怎么办？

**A:** 立即修复：
```bash
chmod 600 ~/.openclaw/openclaw.json
chmod 700 ~/.openclaw/credentials/
```

---

### Q: API密钥泄露了怎么办？

**A:** 立即操作：
1. 在API平台撤销泄露的密钥
2. 生成新密钥
3. 更新OpenClaw配置
4. 检查日志查找泄露原因

---

### Q: 如何检查未授权访问？

**A:** 检查日志：
```bash
# 查看OpenClaw日志
openclaw logs | grep -i "unauthorized\|forbidden"

# 查看SSH日志
grep "Failed password" /var/log/auth.log
```

---

## 📚 相关资源

- [OpenClaw官方安全文档](https://docs.openclaw.ai/zh-CN/security)
- [阿里云安全最佳实践](https://help.aliyun.com/document_detail/55289.html)
- [腾讯云安全中心](https://cloud.tencent.com/document/product/296)
- [Nginx安全配置指南](https://nginx.org/en/docs/http/ngx_http_ssl_module.html)

---

## 🔍 OpenGrep 安全扫描 (v2026.4.29+)

OpenClaw v2026.4.29 新增了 OpenGrep 安全扫描功能，用于检测代码中的安全漏洞。

### 启用 OpenGrep 扫描

```bash
# 运行 OpenGrep 扫描
openclaw security scan

# 查看扫描报告
openclaw security report

# 配置扫描选项
openclaw config set security.opengrep.enabled true
```

### 扫描配置

```json
{
  "security": {
    "opengrep": {
      "enabled": true,
      "rules": "default",
      "severity": "high",
      "output": "sarif",
      "uploadToGithub": true
    }
  }
}
```

### 扫描规则

```bash
# 查看可用规则
openclaw security rules list

# 自定义规则
openclaw security rules add --name "custom-rule" --pattern "secret_key"

# 删除规则
openclaw security rules delete --name "custom-rule"
```

### 扫描结果

```bash
# 查看扫描结果
openclaw security results

# 导出扫描报告
openclaw security export --format sarif

# 上传到 GitHub Code Scanning
openclaw security upload-github
```

---

## 🛠️ 工具配置安全 (v2026.4.29+)

OpenClaw v2026.4.29 强化了工具配置安全，配置的工具部分不再隐式扩展限制性配置文件。

### 工具配置文件

```json
{
  "tools": {
    "profile": "coding",
    "exec": {
      "enabled": true,
      "allowedCommands": ["git", "npm", "node"],
      "deniedCommands": ["rm -rf", "sudo"]
    },
    "fs": {
      "enabled": true,
      "allowedPaths": ["/home", "/tmp"],
      "deniedPaths": ["/etc", "/var"]
    }
  }
}
```

### 安全配置选项

```bash
# 设置工具配置文件
openclaw config set tools.profile coding

# 启用 exec 工具
openclaw config set tools.exec.enabled true

# 设置允许的命令
openclaw config set tools.exec.allowedCommands '["git", "npm", "node"]'

# 设置拒绝的命令
openclaw config set tools.exec.deniedCommands '["rm -rf", "sudo"]'

# 启用 fs 工具
openclaw config set tools.fs.enabled true

# 设置允许的路径
openclaw config set tools.fs.allowedPaths '["/home", "/tmp"]'

# 设置拒绝的路径
openclaw config set tools.fs.deniedPaths '["/etc", "/var"]'
```

### 工具配置文件说明

| 配置文件 | 说明 | 适用场景 |
|----------|------|----------|
| messaging | 消息配置 | 仅消息功能 |
| minimal | 最小配置 | 基础功能 |
| coding | 编码配置 | 开发环境 |
| full | 完整配置 | 完整功能 |

### 安全最佳实践

1. **使用最小配置**: 仅启用必要的工具
2. **限制命令**: 只允许特定命令执行
3. **限制路径**: 只允许访问特定目录
4. **定期审计**: 定期检查工具配置
5. **监控日志**: 监控工具使用日志

---

## 👤 按发送者限制工具权限 (v2026.5.12+)

OpenClaw v2026.5.12 新增了按发送者身份限制工具使用的功能，允许管理员为不同用户设置不同的工具权限。

### 功能说明

在群组或多用户场景下，可以针对不同发送者设置不同的工具策略，避免非管理员用户执行危险操作。

### 配置示例

```json
{
  "tools": {
    "exec": {
      "enabled": true,
      "senderPolicies": {
        "admin_user": {
          "allowed": true,
          "allowedCommands": ["*"]
        },
        "normal_user": {
          "allowed": true,
          "allowedCommands": ["git", "npm", "ls"],
          "deniedCommands": ["rm", "sudo", "chmod"]
        },
        "guest_user": {
          "allowed": false
        }
      }
    }
  }
}
```

### 配置说明

| 字段 | 说明 |
|------|------|
| `senderPolicies` | 发送者策略配置，key 为发送者标识 |
| `allowed` | 是否允许使用该工具 |
| `allowedCommands` | 允许执行的命令列表 |
| `deniedCommands` | 禁止执行的命令列表 |

### 使用场景

- **群聊场景**：仅管理员可执行系统命令，普通用户只能执行查询命令
- **企业环境**：按角色分配不同工具权限
- **公共服务**：限制访客用户的工具访问

---

## 📊 安全监控

### 安全日志

```bash
# 查看安全日志
openclaw security logs

# 监控实时日志
openclaw security logs --follow

# 导出安全日志
openclaw security logs --export
```

### 安全统计

```bash
# 查看安全统计
openclaw security stats

# 查看扫描历史
openclaw security scan-history

# 查看漏洞统计
openclaw security vuln-stats
```

### 安全告警

```json
{
  "security": {
    "alerts": {
      "enabled": true,
      "email": "admin@example.com",
      "webhook": "https://hooks.slack.com/xxx",
      "severity": ["high", "critical"]
    }
  }
}
```

---

**最后更新**: 2026-05-02

---

**创建时间**: 2026-02-22
**版本**: 1.0

<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

---

## 🛡️ Exec审批机制（v2026.6.2+）

### 功能说明

Exec审批机制提供细粒度的命令执行控制，确保敏感操作经过授权确认。

### 配置说明

```json
{
  "exec": {
    "approval": {
      "enabled": true,
      "timeout": 30000,
      "failClosed": true,
      "ownerVerification": true,
      "mobilePush": true
    }
  }
}
```

### 配置参数

| 参数 | 说明 | 默认值 |
|------|------|--------|
| `enabled` | 是否启用Exec审批 | `false` |
| `timeout` | 审批超时时间（毫秒） | `30000` |
| `failClosed` | 超时时是否拒绝执行 | `true` |
| `ownerVerification` | 是否验证执行者身份 | `true` |
| `mobilePush` | 是否启用移动端推送审批 | `false` |

### 使用场景

1. **生产环境**：防止误操作导致服务中断
2. **团队协作**：多人协作时的权限控制
3. **敏感操作**：删除数据、修改配置等操作的二次确认

### 示例：配置允许的命令白名单

```json
{
  "exec": {
    "approval": {
      "enabled": true,
      "allowedBins": [
        "git",
        "npm",
        "node",
        "python",
        "curl"
      ]
    }
  }
}
```

---

## 🔒 SSRF防护（v2026.6.2+）

### 功能说明

SSRF（服务端请求伪造）防护防止OpenClaw被利用访问内部网络或受限资源。

### 配置说明

```json
{
  "security": {
    "ssrf": {
      "enabled": true,
      "allowlist": [
        "https://api.openai.com",
        "https://api.anthropic.com",
        "https://api.github.com"
      ],
      "blockInternal": true,
      "browserRecheck": true,
      "timeout": 10000
    }
  }
}
```

### 配置参数

| 参数 | 说明 | 默认值 |
|------|------|--------|
| `enabled` | 是否启用SSRF防护 | `true` |
| `allowlist` | URL白名单列表 | `[]` |
| `blockInternal` | 是否阻止访问内部网络 | `true` |
| `browserRecheck` | 浏览器操作前是否重新验证URL | `true` |
| `timeout` | 请求超时时间（毫秒） | `10000` |

### 白名单配置建议

```json
{
  "security": {
    "ssrf": {
      "allowlist": [
        "https://api.openai.com",
        "https://api.anthropic.com",
        "https://api.github.com",
        "https://api.google.com",
        "https://api.microsoft.com"
      ]
    }
  }
}
```

### 常见问题

**Q: 为什么某些API请求被拦截？**
A: 检查URL是否在白名单中，或者是否访问了内部网络地址。

**Q: 如何临时禁用SSRF防护？**
A: 设置 `security.ssrf.enabled` 为 `false`（不推荐在生产环境使用）。

---

## 🔐 Auth边界强化（v2026.6.2+）

### 功能说明

Auth边界强化提供更安全的认证和授权机制。

### 配置说明

```json
{
  "auth": {
    "providerScoping": true,
    "persistState": true,
    "tokenEncryption": true,
    "sessionIsolation": true
  }
}
```

### 配置参数

| 参数 | 说明 | 默认值 |
|------|------|--------|
| `providerScoping` | 限制Provider API密钥的访问范围 | `true` |
| `persistState` | 认证状态跨重启保持 | `true` |
| `tokenEncryption` | Token加密存储 | `true` |
| `sessionIsolation` | 不同会话的认证状态隔离 | `true` |

---

## 📋 安全检查清单

### 升级前检查

- [ ] 备份 `~/.openclaw/` 目录
- [ ] 记录当前API密钥
- [ ] 确认网络配置

### 升级后检查

- [ ] 验证版本号
- [ ] 测试API连接
- [ ] 检查安全日志
- [ ] 验证Exec审批功能
- [ ] 测试SSRF防护配置

### 定期检查

- [ ] 每周查看安全日志
- [ ] 每月更新API密钥
- [ ] 每季度审查白名单配置

---

**最后更新**: 2026-06-27

