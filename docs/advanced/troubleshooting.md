# 故障排除指南

> 诊断和解决OpenClaw的常见问题

---

## 🔍 故障排查流程

### 标准排查步骤

```
1. 检查错误日志
2. 验证配置文件
3. 测试网络连接
4. 检查系统资源
5. 重启服务
```

---

## 🚀 安装问题

### 问题1: npm安装失败

**症状**：
```
npm ERR! Cannot install OpenClaw
```

**解决方案**：

1. **检查Node.js版本**
   ```bash
   node --version
   # 需要v18.0或更高
   ```

2. **升级Node.js**
   ```bash
   # 使用nvm
   nvm install 20
   nvm use 20
   ```

3. **清理npm缓存**
   ```bash
   npm cache clean --force
   ```

4. **重新安装**
   ```bash
   npm install -g openclaw
   ```

---

### 问题2: 权限不足

**症状**：
```
Error: EACCES: permission denied
```

**解决方案**：

1. **使用sudo**（不推荐）
   ```bash
   sudo npm install -g openclaw
   ```

2. **修复npm权限**（推荐）
   ```bash
   mkdir ~/.npm-global
   npm config set prefix '~/.npm-global'
   export PATH=~/.npm-global/bin:$PATH
   ```

---

## 🔑 配置问题

### 问题3: API Key无效

**症状**：
```
Error: Invalid API key or authentication failed
```

**解决方案**：

1. **验证API Key格式**
   - 硅基流动：`sk-`开头
   - 火山引擎：`AK-`开头
   - 智谱GLM：32字符密钥

2. **重新配置**
   ```bash

   openclaw config set models.providers[0].apiKey "新密钥"
   ```

3. **测试连接**
   ```bash
   openclaw test api
   ```

---

### 问题4: 配置文件损坏

**症状**：
```
Error: Invalid configuration file
```

**解决方案**：

1. **备份当前配置**
   ```bash
   cp ~/.openclaw/config.json ~/.openclaw/config.json.backup
   ```

2. **验证配置语法**
   ```bash
   openclaw config validate
   ```

3. **重新初始化**
   ```bash
   openclaw init
   ```

---

### 问题5: 找不到配置文件

**症状**：
```
Error: Configuration file not found
```

**解决方案**：

1. **检查配置文件位置**
   ```bash
   ls -la ~/.openclaw/config.json
   ```

2. **如果不存在，创建默认配置**
   ```bash
   openclaw init
   ```

3. **检查配置路径环境变量**
   ```bash
   echo $OPENCLAW_CONFIG
   ```

---

## 🌐 Gateway问题

### 问题6: Gateway无法启动

**症状**：
```
Error: Gateway failed to start
```

**解决方案**：

1. **检查端口占用**
   ```bash
   # Linux/macOS
   lsof -i :18789

   # Windows
   netstat -ano | findstr :18789
   ```

2. **停止占用进程**
   ```bash
   kill -9 <PID>
   ```

3. **检查配置**
   ```bash
   openclaw config validate
   ```

4. **查看详细日志**
   ```bash
   openclaw logs --level debug
   ```

---

### 问题7: Gateway连接超时

**症状**：
```
Error: Connection timeout to Gateway
```

**解决方案**：

1. **检查Gateway是否运行**
   ```bash
   systemctl status openclaw  # Linux
   # 或
   ps aux | grep openclaw
   ```

2. **检查防火墙**
   ```bash
   # UFW
   ufw status allow 18789

   # iptables
   iptables -L -n | grep 18789
   ```

3. **检查云服务器安全组**
   - 确保端口18789已开放
   - 检查来源IP限制

---

### 问题8: Gateway频繁崩溃

**症状**：
```
Gateway keeps restarting or crashing
```

**解决方案**：

1. **查看崩溃日志**
   ```bash
   journalctl -u openclaw --since "1 hour ago"
   ```

2. **检查内存使用**
   ```bash
   free -h
   ```

3. **检查磁盘空间**
   ```bash
   df -h
   ```

4. **重启服务**
   ```bash
   systemctl restart openclaw
   ```

---

## 🔌 API调用问题

### 问题9: API调用失败

**症状**：
```
Error: API request failed (401/403/429)
```

**解决方案**：

| 错误码 | 原因 | 解决方案 |
|-------|------|---------|
| 401 | API Key无效 | 检查并更新API Key |
| 403 | 权限不足 | 检查API权限设置 |
| 429 | 速率限制 | 减少请求频率或升级套餐 |

---

### 问题10: 响应超时

**症状**：
```
Error: Request timeout after 60s
```

**解决方案**：

1. **检查网络连接**
   ```bash
   ping api.example.com
   ```

2. **增加超时时间**
   ```json
   {
     "models": {
       "timeout": 120000
     }
   }
   ```

3. **检查API服务状态**
   - 访问API提供商状态页面
   - 查看服务公告

---

### 问题区11: 模型不可用

**症状**：
```
Error: Model not available or deprecated
```

**解决方案**：

1. **检查模型列表**
   ```bash
   openclaw models list
   ```

2. **切换到可用模型**
   ```json
   {
     "models": {
       "primary": "bailian/qwen-plus"
     }
   }
   ```

3. **查看模型状态**
   - 访问API提供商文档
   - 检查模型是否已下线

---

## 💻 系统资源问题

### 问题12: 内存不足

**症状**：
```
Error: Out of memory
```

**解决方案**：

1. **检查内存使用**
   ```bash
   free -h
   ```

2. **清理缓存**
   ```bash
   npm cache clean --force
   ```

3. **限制OpenClaw内存使用**
   ```json
   {
     "agents": {
       "maxMemory": "512MB"
     }
   }
   ```

4. **升级服务器配置**

---

### 问题13: 磁盘空间不足

**症状**：
```
Error: No space left on device
```

**解决方案**：

1. **检查磁盘使用**
   ```bash
   df -h
   ```

2. **清理旧日志**
   ```bash
   # 删除30天前的日志
   find ~/.openclaw/logs -name "*.log" -mtime +30 -delete
   ```

3. **清理npm缓存**
   ```bash
   npm cache clean --force
   ```

4. **清理备份文件**
   ```bash
   find ~/.openclaw/backups -name "*.tar.gz" -mtime +7 -delete
   ```

---

### 问题14: CPU占用过高

****症状**：
```
CPU usage exceeds 90%
```

**解决方案**：

1. **检查CPU使用**
   ```bash
   top
   ```

2. **限制并发请求**
   ```json
   {
     "models": {
       "maxConcurrentRequests": 2
     }
   }
   ```

3. **优化模型选择**
   - 使用更快的模型
   - 减少上下文长度

---

## 📱 平台集成问题

### 问题15: 钉钉集成失败

**症状**：
```
Error: DingTalk integration failed
```

**解决方案**：

1. **检查配置**
   ```bash
   openclaw dingtalk config
   ```

2. **验证凭证**
   - AppKey和AppSecret是否正确
   - Robot Webhook是否有效

3. **测试连接**
   ```bash
   openclaw dingtalk test
   ```

---

### 问题16: Telegram Bot无响应

**症状****：
```
Telegram bot not responding
```

**解决方案**：

1. **检查Bot Token**
   ```bash
   openclaw telegram config
   ```

2. **验证Webhook**
   ```bash
   openclaw telegram webhook
   ```

3. **重新设置Webhook**
   ```bash
   openclaw telegram webhook set
   ```

---

## 🔒 安全问题

### 问题17: 权限错误

**症状**：
```
Error: Permission denied
```

**解决方案**：

1. **检查文件权限**
   ```bash
   ls -la ~/.openclaw/
   ```

2. **修复权限**
   ```bash
   chmod 700 ~/.openclaw/
   chmod 600 ~/.openclaw/config.json
   ```

3. **检查所有者**
   ```bash
   chown -R $USER:$USER ~/.openclaw/
   ```

---

### 问题18: SSL/TLS错误

**症状**：
```
Error: SSL certificate verify failed
```

**解决方案**：

1. **更新证书**
   ```bash
   apt update && apt install ca-certificates
   ```

2. **禁用证书验证（不推荐）**
   ```json
   {
     "models": {
       "rejectUnauthorized": false
     }
   }
   ```

---

## 📊 日志分析

### 查看日志

```bash
# 实时日志
openclaw logs -f

# 错误日志
openclaw logs --level error

# 最近100行
openclaw logs -n 100

# 按时间筛选
openclaw logs --since "1 hour ago"
```

### 日志级别

| 级别 | 用途 |
|------|------|
| debug | 详细调试信息 |
| info | 一般信息 |
| warn | 警告信息 |
| error | 错误信息 |
| fatal | 严重错误 |

---

## 🆘 获取帮助

### 1. 查看文档

- [官方文档](https://docs.openclaw.ai)
- [API文档](https://docs.openclaw.ai/api)
- [常见问题](../FAQ.md)

---

### 2. 搜索问题

- [GitHub Issues](https://github.com/openclaw/openclaw/issues)
- [Discord社区](https://discord.gg/clawd)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/openclaw)

---

### 3. 提交问题

**提交Issue前**：
1. 搜索现有Issue
2. 收集错误日志
3. 提供环境信息：
   ```bash
   openclaw --version
   node --version
   npm --version
   uname -a
   ```

---

### 4. 紧急支持

**生产环境问题**：
1. 检查服务状态：`systemctl status openclaw`
2. 查看错误日志：`journalctl -u openclaw -p err`
3. 重启服务：`systemctl restart openclaw`
4. 如果问题持续，提交紧急Issue

---

## 🔧 诊断工具

### 系统诊断

```bash
# OpenClaw健康检查
openclaw doctor

# 详细诊断
openclaw doctor --verbose
```

### 网络诊断

```bash
# 测试API连接
openclaw test api

# 测试Gateway连接
openclaw test gateway

# 测试所有连接
openclaw test all
```

### 配置诊断

```bash
# 验证配置
openclaw config validate

# 显示配置
openclaw config show

# 检查配置文件
openclaw config check
```

---

## 📚 相关资源

- [快速开始](../start/quickstart.md)
- [API配置](../api-config/api-configuration.md)
- [安全配置](security.md)
- [技能使用](skills.md)
- [云部署](../cloud/cloud-deployment-guide.md)

---

**创建时间**: 2026-02-22
**版本**: 1.0
