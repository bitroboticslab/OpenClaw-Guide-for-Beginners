<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# 阿里云部署指南

> 在阿里云上部署OpenClaw，享受24小时在线的AI助手服务

---

## 🎁 OpenClaw x 阿里云 专属优惠

通过我的专属链接注册阿里云，享受OpenClaw独家福利：

[🔗 立即部署 - 半小时搞定](https://www.aliyun.com/activity/ecs/clawdbot?userCode=yyzsc1al)

### 专属福利



| 福利 | 内容 | 价值 |
|------|------|------|
| 🎁 普惠套餐 | 2核2G不限流量，99元/年 新人68元/年 | 原价180+元 |
| 🔗 AI大模型 | 阿里百炼88%折扣 | 节省数百元 |
| 💎 建站三件套 | 域名+服务器+AI建站 | 百元搞定 |
| ⏰ 快速部署 | 官方支持OpenClaw镜像 | 半小时完成 |

---

### 为什么选择阿里云？

✅ **深度整合**: 阿里百炼与OpenClaw无缝对接
✅ **价格透明**: 99元普惠套餐，价格明确
✅ **一键部署**: 官方OpenClaw镜像，开
箱即用
✅ **文档完善**: 官方部署教程，遇到问题快速解决
✅ **稳定可靠**: 国内领先云服务商，99.9% SLA

---

## 📋 第1步：购买云服务器

### 访问专属页面

点击下方链接进入阿里云OpenClaw专属活动页：

[🔗 阿里云OpenClaw专属活动](https://www.aliyun.com/activity/ecs/clawdbot?userCode=yyzsc1al)

---

### 选择套餐

**推荐配置**：

| 配置项 | 推荐值 | 说明 |
|--------|--------|------|
| 地域 | 华东1（杭州）/ 华北2（北京） | 选择离你最近的 |
| 实例规格 | 2核 vCPU (2 Core) | 2核足够运行OpenClaw |
| 内存 | 2 GB | 推荐配置 |
| 操作系统 | Ubuntu 22.04 LTS | 推荐使用Ubuntu |
| 带宽 | 3 Mbps | 足够日常使用 |
| 系统盘 | 40 GB SSD | 推荐 |

**套餐价格**:
- 2核2G：99元/年（普惠套餐）
- 2核4G：120-150元/年
- 4核8G：300-500元/年

---

### 完成购买

1. **创建实例**
2. **设置root密码**（务必记住或使用SSH密钥）
3. **配置安全组**（开放22端口用于SSH）
4. **创建并启动实例**
5. **获取服务器IP地址**

---

## 📋 第2步：连接服务器

### 使用SSH连接

```bash
# 替换为你的服务器IP地址
ssh root@你的服务器IP

# 输入购买时设置的密码
```

**首次连接提示**:
```
The authenticity of host 'xxx.xxx.xxx.xxx' can't be established.
Are you sure you want to continue connecting (yes/no)? yes
```

输入 `yes` 确认

---

### 使用SSH密钥（推荐，更安全）

**生成密钥对**（本地）：
```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

**上传公钥到服务器**：
```bash
ssh-copy-id root@你的服务器IP
```

**之后连接无需密码**：
```bash
ssh root@你的服务器IP
```

---

## 📋 第3步：安装Node.js

OpenClaw需要Node.js 18.0或更高版本

### 检查版本

```bash
node --version
```

如果版本 >= 18.0，跳过此步

---

### 安装Node.js（Ubuntu）

```bash
# 更新包列表
apt update

# 安装Node.js 20 LTS
apt install -y nodejs npm

# 验证安装
node --version
npm --version
```

**或使用nvm（推荐）**：
```bash
# 安装nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# 加载nvm
source ~/.bashrc

# 安装Node.js 20 LTS
nvm install 20
nvm use 20
nvm alias default 20

# 验证
node --version
```

---

## 📋 第4步：安装OpenClaw

### 使用npm安装

```bash
# 全局安装OpenClaw
npm install -g openclaw@latest

# 验证安装
openclaw --version
```

---

### 初始化配置

```bash
# 启动配置向导
openclaw init
```

按照提示操作：
1. 选择API提供商
2. 粘贴API Key（从硅基流动、火山引擎或智谱GLM获取）
3. 选择默认模型
4. 完成配置

---

**快速获取API Key**:
- [硅基流动](https://cloud.siliconflow.cn/i/lva59yow) - 2000万Tokens免费，实名认证得16元任意模型抵扣代金券
- [火山引擎 Coding](https://volcengine.com/L/tHxxM_WwYp4/) - 折上9折低至8.9元（量大管饱 性价比首选！）
- [智谱GLM Coding](https://www.bigmodel.cn/glm-coding?ic=BUDVTRHUYH) - 限时惊喜价

---

## 📋 第5步：配置Gateway后台运行
### 注意：如果已经使用--install-daemon参数进行安装，则此步骤可忽略
### 创建Systemd服务

```bash
# 创建服务文件
nano /etc/systemd/system/openclaw.service
```

**粘贴以下内容**：

```ini
[Unit]
Description=OpenClaw Gateway Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root
ExecStart=/usr/local/bin/openclaw gateway start
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

**保存并退出**（Ctrl+O，Enter，Ctrl+X）

---

### 启动服务

```bash
# 重载systemd配置
systemctl daemon-reload

# 启动OpenClaw服务
systemctl start openclaw

# 设置开机自启
systemctl enable openclaw

# 查看服务状态
systemctl status openclaw
```

**成功标志**：
```
● openclaw.service - OpenClaw Gateway Service
   Loaded: loaded (/etc/systemd/system/openclaw.service; enabled; vendor preset: enabled)
   Active: active (running) since Fri 2026-02-22 12:00:00 CST
```

---

### 查看日志

```bash
# 实时查看日志
journalctl -u openclaw -f

# 查看最近100行日志
journalctl -u openclaw -n 100
```

---

## 📋 第6步：配置防火墙

### 开放必要端口

```bash
# 如果使用ufw
ufw allow 22/tcp    # SSH
ufw allow 18789/tcp # OpenClaw Gateway
ufw enable

# 如果使用iptables
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 18789 -j ACCEPT
service iptables save
```

---

## 📋 第7步：连接对话平台

### 方式1: Web聊天

本地浏览器访问：
```
http://服务器IP:18789/chat
```

---

### 方式2: 钉钉集成

```bash
# 配置钉钉
openclaw dingtalk init
```

按照提示扫描二维码或配置应用凭证

---

### 方式3: Telegram集成

```bash
# 配置Telegram Bot
openclaw telegram init
```

---

## ✅ 验证部署

### 1. 检查Gateway运行状态

```bash
systemctl status openclaw
```

---

### 2. 检查端口监听

```bash
netstat -tlnp | grep 18789
```

**预期输出**：
```
tcp        0      0 0.0.0.0:18789            0.0.0.0:*               LISTEN      1234/openclaw
```

---

### 3. 发送测试消息

通过Web聊天或已配置的平台发送消息：
**用户**: 你好！
**AI**: 你好！我是OpenClaw，有什么可以帮助你的吗？

🎉 **部署成功！**

---

## 🔧 常见问题

### Q: 忘记root密码怎么办？

**A:** 在阿里云控制台：
1. 进入实例管理
2. 点击"重置实例密码"
3. 重启实例

---

### Q: 如何更新OpenClaw？

**A:**
```bash
# 停止服务
systemctl stop openclaw

# 更新
npm update -g openclaw

# 重启服务
systemctl start openclaw
```

---

### Q: 如何查看资源使用情况？

**A:**
```bash
# CPU和内存
htop

# 磁盘空间
df -h

# 网络流量
iftop
```

---

### Q: 如何备份数据？

**A:**
```bash
# 备份workspace
tar -czf openclaw-backup-$(date +%Y%m%d).tar.gz ~/.openclaw/workspace

# 备份到本地
scp root@服务器IP:~/openclaw-backup-*.tar.gz ./
```

---

### Q: 配置太低怎么办？

**A:** 在阿里云控制台升级实例规格：
1. 停止实例
2. 更改实例规格
3. 重启实例

---

## 💰 成本估算

### 服务器成本

| 套餐 | 月费 | 年费 | 适合场景 |
|------|------|------|----------|
| 1核1G | 60-80元 | - | 测试 |
| 2核2G | 8-10元 | 99元 | **推荐** |
| 2核4G | 12-15元 | 120-150元 | 多用户 |
| 4核8G | 30-40元 | 300-500元 | 重度使用 |

### API成本

- 免费额度（硅基流动）：0元
- Coding Plan（火山引擎kt）：8.9元/首月，后续40元/月 （建议48元开季卡）
- Coding Plan（智谱GLM）：39元/月

### 总成本

- **轻量使用**：服务器(8-10元) + API(0-39元) = **8-49元/月**
- **年付优惠**：服务器(99元) + API(40*12=480元) = **约580元/年**

---

## 📚 相关资源

- [云服务器部署通用指南](cloud-deployment-guide.md)
- [API配置教程](../api-config/api-configuration.md)
- [模型选择指南](../api-config/model-comparison.md)
- [故障排除](../advanced/troubleshooting.md)

---

**创建时间**: 2026-02-22
**版本**: 1.0
**适用版本**: OpenClaw 2026.2.x

<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->
