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

- [OpenClaw官方安全文档](https://docs.openclaw.ai/security)
- [阿里云安全最佳实践](https://help.aliyun.com/document_detail/55289.html)
- [腾讯云安全中心](https://cloud.tencent.com/document/product/296)
- [Nginx安全配置指南](https://nginx.org/en/docs/http/ngx_http_ssl_module.html)

---

**创建时间**: 2026-02-22
**版本**: 1.0

<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->
