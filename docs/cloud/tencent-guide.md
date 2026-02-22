# 腾讯云部署指南

> 在腾讯云上部署OpenClaw，享受24小时在线的AI助手服务

---

## 🎁 OpenClaw x 腾讯云 专属优惠

通过我的推广链接注册腾讯云，享受专属福利：

[🔗 立即部署 - 推广大使特惠](https://curl.qcloud.com/JnWPPHIH)

### 专属福利

| 福利 | 内容 | 价值 |
|------|------|------|
| 🎁 新用户优惠 | 轻量服务器专属套餐 | 优惠50%+ |
| 💰 CPS返佣 | 推广大使奖励 | 双方收益 |
| 🔧 官方支持 | 完整的部署教程 | 快速上手 |
| ⏰ 一键部署 | 镜像市场开箱即用 | 5分钟完成 |

---

### 为什么选择腾讯云？

✅ **价格优势**: 新用户专享特惠，性价比高
✅ **稳定可靠**: 腾讯云基础设施，99.9% SLA
✅ **快速部署**: 镜像市场提供一键部署方案
✅ **文档完善**: 官方部署教程，遇到问题快速解决
✅ **生态丰富**: 腾讯云AI服务可无缝对接

---

## 📋 第1步：购买云服务器

### 访问推广页面

点击下方链接进入腾讯云推广大使专属活动页：

[🔗 腾讯云推广大使特惠](https://curl.qcloud.com/JnWPPHIH)

---

### 选择套餐

**推荐配置（轻量应用服务器）**：

| 配置项 | 推荐值 | 说明 |
|--------|--------|------|
| 地域 | 上海 / 北京 / 广州 | 选择离你最近的 |
| 实例规格 | 2核4G 或 2核2G | 推荐配置 |
| 操作系统 | Ubuntu 22.04 LTS | 推荐使用Ubuntu |
| 套餐 | 50GB SSD | 推荐配置 |

**套餐价格**（新用户特惠）:
- 2核2G（50GB）：约50-70元/年（新用户特惠）
- 2核4G（60GB）：约80-120元/年（新用户特惠）
- 4核8G（80GB）：约150-200元/年

---

### 完成购买

1. **创建实例**
2. **设置root密码**（务必记住或使用SSH密钥）
3. **配置防火墙**（开放22端口用于SSH）
4. **创建并启动实例**
5. **获取服务器公网IP地址**

---

## 📋 第2步：连接服务器

### 使用SSH连接

```bash
# 替换为你的服务器公网IP
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
npm install -g openclaw

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
- [硅基流动](https://cloud.siliconflow.cn/i/lva59yow) - 2000万Tokens免费
- [火山引擎方舟](https://volcengine.com/L/tHxxM_WwYp4/) - 折上9折低至8.9元
- [智谱GLM Coding](https://www.bigmodel.cn/glm-coding?ic=BUDVTRHUYH) - 限时惊喜价

---

## 📋 第5步：配置Gateway后台运行

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

腾讯云轻量应用服务器使用轻量级防火墙（安全组）

### 在控制台配置

1. 进入腾讯云控制台
2. 找到你的轻量服务器
3. 点击"防火墙"标签
4. 添加规则：
   - 类型：TCP
   - 端口：22（SSH）
   - 来源：0.0.0.0/0（或限制你的IP）
   - 策略：允许
5. 添加规则：
   - 类型：TCP
   - 端口：18789（OpenClaw Gateway）
   - 来源：0.0.0.0/0（或限制你的IP）
   - 策略：允许

---

## 📋 第7步：连接对话平台

### 方式1: Web聊天

本地浏览器访问：
```
http://服务器公网IP:18789/chat
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

**A:** 在腾讯云控制台：
1. 进入轻量服务器管理
2. 点击"重置密码"
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

或在腾讯云控制台的"监控"标签查看实时数据

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

**A:** 在腾讯云控制台升级实例：
1. 停止实例
2. 点击"升级配置"
3. 选择新配置
4. 重启实例

---

### Q: 防火墙不生效？

**A:** 检查以下几点：
1. 控制台防火墙规则是否正确配置
2. 端口号是否正确（18789）
3. 服务是否正在运行（`systemctl status openclaw`）
4. 重启防火墙或服务

---

## 💰 成本估算

### 服务器成本

| 套餐 | 月费（新用户） | 年费（新用户） | 适合场景 |
|------|-------------|--------------|----------|
| 2核2G（50GB） | 5-6元 | 50-70元 | 测试 |
| 2核4G（60GB） | 7-10元 | 80-120元 | **推荐** |
| 4核8G（80GB） | 15-18元 | 150-200元 | 多用户 |

### API成本

- 免费额度（硅基流动）：0元
- Coding Plan（火山引擎）：8.9元/月
- Coding Plan（智谱GLM）：39元/月

### 总成本

- **轻量使用**：服务器(5-10元) + API(0-39元) = **5-49元/月**
- **年付优惠**：服务器(80-120元) + API(8.9*12=107元) = **约187-227元/年**

---

## 📚 相关资源

- [云服务器部署通用指南](cloud-deployment-guide.md)
- [阿里云部署指南](aliyun-guide.md)
- [API配置教程](../api-config/api-configuration.md)
- [模型选择指南](../api-config/model-comparison.md)
- [故障排除](../advanced/troubleshooting.md)

---

## 🔗 腾讯云官方资源

- [腾讯云轻量应用服务器文档](https://cloud.tencent.com/document/product/213)
- [腾讯云推广中心](https://cloud.tencent.com/developer/channel/actuator)
- [云服务器控制台](https://console.cloud.tencent.com/lighthouse)

---

**创建时间**: 2026-02-22
**版本**: 1.0
**适用版本**: OpenClaw 2026.2.x
