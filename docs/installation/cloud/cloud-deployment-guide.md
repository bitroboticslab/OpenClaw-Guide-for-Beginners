<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# 云服务器部署指南

> 24小时在线的 AI 助手，云服务器部署完全指南

## 🎯 为什么选择云服务器部署？

云服务器部署的优势：
- ✅ **24小时在线**：无需本地电脑一直开机
- ✅ **网络稳定**：企业级网络环境
- ✅ **维护简单**：一键镜像，开箱即用
- ✅ **成本低廉**：最低仅需 79 元/年

## 📋 服务器配置要求

### 最低配置
- CPU: 1核
- 内存: 1GB
- 存储: 20GB
- 带宽: 1Mbps
- 系统: Ubuntu 20.04+ / CentOS 7+

### 推荐配置
- CPU: 2核
- 内存: 2GB
- 存储: 40GB
- 带宽: 3Mbps
- 系统: Ubuntu 22.04 LTS

---

## ☁️ 云服务商选择

### 推荐一：阿里云轻量应用服务器（首选）

**推荐理由**：
- 🏷️ 价格实惠：68 元/年起
- 🚀 一键部署：官方提供 OpenClaw 镜像
- 🔗 深度整合：与阿里百炼无缝对接
<!-- - 💰 返利丰厚：云大使计划返利高达 45% -->

**购买步骤**：

1. 访问 [阿里云轻量应用服务器](https://www.aliyun.com/activity/ecs/clawdbot?userCode=yyzsc1al)

2. 选择镜像
   - 应用镜像 → 搜索「OpenClaw」
   - 或选择 Ubuntu 22.04 手动安装

3. 选择套餐
   - 入门型（1核1G）：适合轻度使用
   - 标准型（2核2G）：推荐配置

4. 完成购买，等待服务器创建

### 推荐二：腾讯云轻量应用服务器（推荐）

**优势**：
- 价格透明，套餐丰富
- 官方有 OpenClaw 实践教程

**购买步骤**：
1. 访问 [腾讯云轻量服务器 (4核4G3M一年79元)](
https://cloud.tencent.com/act/cps/redirect?redirect=1079&cps_key=d427af70c58018a013008ba30489f688&from=console&cps_promotion_id=102390)
2. 直接按腾讯云教程选择 OpenClaw 镜像 （OpenCloudOS 系统） 
建议选择 Ubuntu 22.04 镜像，按照本教程自己部署openclaw
3. 参考 [腾讯云官方教程](https://cloud.tencent.com/document/product/1207/127874)

### 推荐三：百度智能云

**优势**：
- 千问模型深度整合
- 一键部署教程完善

---

## 🚀 部署步骤（阿里云）

### 方法一：使用官方镜像（最简单）

1. **创建服务器时选择 OpenClaw 镜像**
   - 地域：选择离你最近的
   - 镜像：应用镜像 → OpenClaw
   - 套餐：根据需求选择

2. **获取服务器信息**
   - 进入控制台 → 轻量应用服务器
   - 点击实例 → 查看「应用详情」
   - 获取管理员密码或重置密码

3. **配置 API**
   - 通过 SSH 连接服务器
   ```bash
   ssh root@你的服务器IP
   ```
   - 运行配置向导
   ```bash
   openclaw onboard --install-daemon
   ```

### 方法二：手动安装

1. **SSH 连接服务器**
```bash
ssh root@你的服务器IP
```

2. **更新系统**
```bash
apt update && apt upgrade -y
```

3. **安装 Node.js**
```bash
# 安装 nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.bashrc

# 安装 Node.js 22
nvm install 22
nvm use 22
```

4. **安装 OpenClaw**
```bash
curl -fsSL https://openclaw.ai/install.sh | bash
```

5. **配置 OpenClaw**
```bash
openclaw onboard --install-daemon
```

---

## 🔧 配置消息平台

### 飞书对接（推荐）

1. 创建飞书应用
   - 访问 [飞书开放平台](https://open.feishu.cn)
   - 创建企业自建应用
   - 配置权限（参考 [飞书对接教程](../platform-integration/feishu-integration.md)）

2. 配置服务器公网访问
   - 确保服务器防火墙开放相应端口
   - 配置域名和 HTTPS（推荐使用 Nginx + Let's Encrypt）

3. 配置飞书事件订阅
   - 在飞书开放平台配置事件订阅地址
   - 格式：`https://你的域名/webhook/feishu`

### 钉钉对接

详细步骤参考 [钉钉对接教程](../platform-integration/dingtalk-integration.md)

---

## 🔐 安全配置

### 1. 配置防火墙

```bash
# 安装 ufw
apt install ufw -y

# 允许 SSH
ufw allow ssh

# 允许 Web 访问（如需要）
ufw allow 80
ufw allow 443

# 启用防火墙
ufw enable
```

### 2. 配置 HTTPS（推荐）

```bash
# 安装 Nginx
apt install nginx -y

# 安装 Certbot
apt install certbot python3-certbot-nginx -y

# 获取证书
certbot --nginx -d 你的域名.com
```

### 3. 设置开机自启

```bash
# 创建 systemd 服务
cat > /etc/systemd/system/openclaw.service << 'EOF'
[Unit]
Description=OpenClaw AI Assistant
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/.openclaw
ExecStart=/usr/local/bin/openclaw gateway start
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# 启用服务
systemctl daemon-reload
systemctl enable openclaw
systemctl start openclaw
```

---

## 💰 成本估算

### 阿里云方案

| 项目 | 费用 | 说明 |
|------|------|------|
| 轻量服务器 | 79 元/年 | 1核1G 入门型 |
| API 调用 | 10-50 元/月 | 视使用量 |
| 域名（可选） | 10-50 元/年 | 用于 HTTPS |
| **年总成本** | **约 200-400 元** | |

### 性价比建议

- 新用户：利用各大平台免费额度
- 轻度使用：Coding Plan Lite 套餐（约 10 元/月）
- 重度使用：考虑年付套餐

---

## 🔍 常见问题

### Q: 服务器连不上怎么办？

1. 检查安全组/防火墙是否开放 22 端口
2. 确认密码正确
3. 查看服务器是否正常运行

### Q: OpenClaw 启动失败？

1. 检查 Node.js 版本：`node -v`（需要 22+）
2. 查看日志：`openclaw logs`
3. 检查 API 配置是否正确

### Q: 消息平台收不到消息？

1. 检查网络连通性
2. 确认 Webhook 地址正确
3. 查看飞书/钉钉应用配置

---

## 📚 相关链接

- [阿里云 OpenClaw 部署文档](https://help.aliyun.com/zh/simple-application-server/use-cases)
- [腾讯云 OpenClaw 实践教程](https://cloud.tencent.com/document/product/1207/127874)
- [OpenClaw 官方文档](https://docs.openclaw.ai)

---

## 💰 优惠链接

| 服务商 | 链接 | 优惠 |
|--------|------|------|
| 阿里云轻量服务器 | [购买链接](https://www.aliyun.com/activity/ecs/clawdbot?userCode=yyzsc1al) | 2核2G 68 元/年起 |
| 腾讯云轻量服务器 | [购买链接](https://cloud.tencent.com/act/cps/redirect?redirect=1079&cps_key=d427af70c58018a013008ba30489f688&from=console&cps_promotion_id=102390) | 4核4G3M 79 元/年起 |
| 阿里百炼 | [开通链接](https://bailian.console.aliyun.com) | 新人多个模型免费额度1M |
| 火山方舟 Coding Plan | [订阅链接](https://volcengine.com/L/oqijuWrltl0/  ) | 首月 8.91 元 （量大管饱） |

> 通过以上链接购买可支持作者持续更新教程 ❤️

---

**上一页**：[Linux 安装指南](../linux/README.md) | **下一页**：[API 配置详解](../api-config/api-configuration.md)

<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->
