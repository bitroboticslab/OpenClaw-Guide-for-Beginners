<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# Docker Cloud 部署

> 将OpenClaw部署到云平台，实现24小时在线服务

---

## 📋 目录

- [云平台选择](#-云平台选择)
- [阿里云部署](#-阿里云部署)
- [腾讯云部署](#-腾讯云部署)
- [AWS部署](#-aws部署)
- [自动部署脚本](#-自动部署脚本)
- [域名配置](#-域名配置)
- [安全加固](#-安全加固)
- [成本优化](#-成本优化)
- [常见问题](#-常见问题)

---

## ☁️ 云平台选择

### 云服务商对比

| 云服务商 | 价格（最低） | OpenClaw支持 | 推荐指数 | 专属优惠 |
|---------|------------|--------------|---------|---------|
| [阿里云](https://www.aliyun.com/activity/ecs/clawdbot?userCode=yyzsc1al) | 99元/年起 | ✅ 一键镜像部署 | ⭐⭐⭐⭐⭐ | 99元/年专属优惠 |
| [腾讯云](https://curl.qcloud.com/JnWPPHIH) | 优惠套餐 | ✅ 官方教程支持 | ⭐⭐⭐⭐ | 推广大使特惠 |
| AWS EC2 | $3.5/月起 | ✅ Docker支持 | ⭐⭐⭐ | 12个月免费层 |
| Google Cloud | $6/月起 | ✅ Docker支持 | ⭐⭐⭐ | 90天免费试用 |
| DigitalOcean | $4/月起 | ✅ 一键部署 | ⭐⭐⭐ | 60天免费试用 |

---

### 推荐方案

| 场景 | 推荐平台 | 套餐 | 价格 |
|------|---------|------|------|
| **个人学习** | 阿里云 | 2核2G | 99元/年 |
| **生产环境** | 阿里云 | 2核4G | 199元/年 |
| **海外访问** | DigitalOcean | 1GB RAM | $4/月 |
| **企业应用** | AWS EC2 | 2核8G | $20/月 |

---

## 🚀 阿里云部署

### 前置条件

- ✅ 阿里云账号
- ✅ 已创建云服务器（ECS）
- ✅ 服务器系统: Ubuntu 20.04+ 或 CentOS 7+

---

### 方式1: 一键镜像部署（推荐）✨

#### 步骤1: 购买购买服务器

1. 访问 [阿里云OpenClaw专属页面](https://www.aliyun.com/activity/ecs/clawdbot?userCode=yyzsc1al)
2. 选择实例配置：
   - **规格**: 2核2G（99元/年）
   - **操作系统**: Ubuntu 22.04
   - **公网带宽**: 1Mbps
3. 设置密码和实例名称
4. 确认订单并支付

---

#### 步骤2: 连接服务器

```bash
# 使用SSH连接
ssh root@YOUR_SERVER_IP

# 或使用密钥连接
ssh -i /path/to/your-key.pem root@YOUR_SERVER_IP
```

---

#### 步骤3: 安装Docker

```bash
# 安装Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# 将当前用户添加到docker组
sudo usermod -aG docker $USER
newgrp docker

# 验证安装
docker --version
```

---

#### 步骤4: 拉取并启动OpenClaw

```bash
# 拉取镜像
docker pull openclaw/openclaw:latest

# 启动容器
docker run -d \
  --name openclaw \
  --restart unless-stopped \
  -p 18789:18789 \
  openclaw/openclaw:latest

# 查看日志
docker logs -f openclaw
```

✅ **成功标志**: 看到 "Gateway running on http://0.0.0.0:18789"

---

#### 步骤5: 配置API Key

```bash
# 创建配置文件
cat > openclaw.json << 'EOF'
{
  "providers": {
    "bailian": {
      "apiKey": "YOUR_API_KEY"
    }
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "bailian/qwen-turbo"
      }
    }
  }
}
EOF

# 重启容器
docker stop openclaw
docker rm openclaw

docker run -d \
  --name openclaw \
  --restart unless-stopped \
  -p 18789:18789 \
  -v $(pwd)/openclaw.json:/home/openclaw/.openclaw/openclaw.json \
  openclaw/openclaw:latest
```

<details>
<summary><b>💡 推荐API平台</b></summary>

| 平台 | 新用户福利 | 链接 |
|------|-----------|------|
| ![推荐](https://img.shields.io/badge/推荐-新手-green) | 硅基流动 | 20002000万Tokens免费 | [注册](https://cloud.siliconflow.cn/i/lva59yow) |
| ![高性价比](https://img.shields.io/badge/高性价比-blue) | 火山引擎 | 首月8.9元 | [订阅](https://volcengine.com/L/tHxxM_WwYp4/) |
| ![优惠](https://img.shields.io/badge/优惠-长期-orange) | 智谱GLM | 年付7折 | [订阅](https://www.bigmodel.cn/glm-coding?ic=BUDVTRHUYH) |

</details>

---

#### 步骤6: 配置安全组

1. 登录阿里云控制台
2. 进入「云服务器ECS」→「安全组」
3. 添加入方向规则：
   - **端口范围**: 18789/18789
   - **授权对象**: 0.0.0.0/0（或限制IP范围）
4. 保存规则

✅ **成功标志**: 可以从外网访问 http://YOUR_SERVER_IP:18789

---

### 方式2: 使用Docker Compose

创建 `docker-compose.yml`：

```yaml
version: '3.8'

services:
  openclaw:
    image: openclaw/openclaw:latest
    container_name: openclaw
    ports:
      - "18789:18789"
    volumes:
      - ./openclaw.json:/home/openclaw/.openclaw/openclaw.json
      - ./data:/home/openclaw/.openclaw/data
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:18789/health"]
      interval: 30s
      timeout: 10s
      retries: 3
```

启动：

```bash
# 启动服务
docker-compose up -d

# 查看日志
docker-compose logs -f

# 查看状态
docker-compose ps
```

---

## 🔵 腾讯云部署

### 前置条件

- ✅ 腾讯云账号
- ✅ 已创建云服务器（CVM）
- ✅ 服务器系统: Ubuntu 20.04+ 或 CentOS 7+

---

### 部署步骤

#### 步骤1: 购买服务器

1. 访问 [腾讯云特惠页面](https://curl.qcloud.com/JnWPPHIH)
2. 选择实例配置：
   - **规格**: 2核2G
   - **操作系统**: Ubuntu 22.04
   - **带宽**: 1Mbps
3. 设置密码和实例名称
4. 确认订单并支付

---

#### 步骤2: 连接服务器

```bash
# 使用SSH连接
ssh root@YOUR_SERVER_IP

# 或使用密钥连接
ssh -i /path/to/your-key.pem root@YOUR_SERVER_IP
```

---

#### 步骤3: 安装Docker

```bash
# 安装Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# 将当前用户添加到docker组
sudo usermod -aG docker $USER
newgrp docker

# 验证安装
docker --version
```

---

#### 步骤4: 部署OpenClaw

```bash
# 拉取镜像
docker pull openclaw/openclaw:latest

# 启动容器
docker run -d \
  --name openclaw \
  --restart unless-stopped \
  -p 18789:18789 \
  openclaw/openclaw:latest

# 查看日志
docker logs -f openclaw
```

---

#### 步骤5: 配置防火墙

1. 登录腾讯云控制台
2. 进入「云服务器」→「安全组」
3. 添加入站规则：
   - **协议端口**: TCP:18789
   - **来源**: 0.0.0.0/0（或限制IP范围）
4. 保存规则

✅ **成功标志**: 可以从外网访问 http://YOUR_SERVER_IP:18789

---

## 🟠 AWS部署

### 前置条件

- ✅ AWS账号
- ✅ 已创建EC2实例
- ✅ 实例系统: Ubuntu 20.04+

---

### 部署步骤

#### 步骤1: 创建EC2实例

1. 登录AWS控制台
2. 进入「EC2」→「Launch Instance」
3. 选择镜像：Ubuntu 22.04 LTS
4. 选择实例类型：t3.micro（免费层）
5. 配置安全组：
   - 添加规则：SSH (22), HTTP (80), Custom TCP (18789)
6. 启动实例

---

#### 步骤2: 连接实例

```bash
# 使用SSH密钥连接
ssh -i /path/to/your-key.pem ubuntu@YOUR_INSTANCE_PUBLIC_IP
```

---

#### 步骤3: 安装Docker

```bash
# 安装Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# 将当前用户添加到docker组
sudo usermod -aG docker $USER
newgrp docker

# 验证安装
docker --version
```

---

#### 步骤4: 部署OpenClaw

```bash
# 拉取镜像
docker pull openclaw/openclaw:latest

# 启动容器
docker run -d \
  --name openclaw \
  --restart unless-stopped \
  -p 18789:18789 \
  openclaw/openclaw:latest

# 查看日志
docker logs -f openclaw
```

---

#### 步骤5: 配置安全组

1. 登录AWS控制台
2. 进入「EC2」→「Security Groups」
3. 选择实例的安全组
4. 添加入站规则：
   - **类型**: Custom TCP
   - **端口**: 18789
   - **来源**: 0.0.0.0/0（或限制IP范围）
5. 保存规则

✅ **成功标志**: 可以从外网访问 http://YOUR_INSTANCE_PUBLIC_IP:18789

---

## 🤖 自动部署脚本

### 一键部署脚本（阿里云）

创建 `deploy-aliyun.sh`：

```bash
#!/bin/bash

set -e

echo "=== OpenClaw Docker Deployment Script ==="
echo "Platform: Alibaba Cloud"

# 检查Docker
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    newgrp docker
fi

# 拉取镜像
echo "Pulling OpenClaw image..."
docker pull openclaw/openclaw:latest

# 停止旧容器
if docker ps -a | grep -q openclaw; then
    echo "Stopping old container..."
    docker stop openclaw || true
    docker rm openclaw || true
fi

# 启动新容器
echo "Starting OpenClaw container..."
docker run -d \
  --name openclaw \
  --restart unless-stopped \
  -p 18789:18789 \
  -v $(pwd)/data:/home/openclaw/.openclaw \
  openclaw/openclaw:latest

# 显示日志
echo ""
echo "=== OpenClaw deployed successfully! ==="
echo "Access: http://$(curl -s ifconfig.me):18789"
echo ""
echo "View logs:"
echo "  docker logs -f openclaw"
echo ""
```

使用脚本：

```bash
# 下载脚本
wget https://example.com/deploy-aliyun.sh

# 添加执行权限
chmod +x deploy-aliyun.sh

# 运行脚本
./deploy-aliyun.sh
```

---

### 一键部署脚本（AWS）

创建 `deploy-aws.sh`：

```bash
#!/bin/bash

set -e

echo "=== OpenClaw Docker Deployment Script ==="
echo "Platform: AWS"

# 检查Docker
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    newgrp docker
fi

# 拉取镜像
echo "Pulling OpenClaw image..."
docker pull openclaw/openclaw:latest

# 停止旧容器
if docker ps -a | grep -q openclaw; then
    echo "Stopping old container..."
    docker stop openclaw || true
    docker rm openclaw || true
fi

# 启动新容器
echo "Starting OpenClaw container..."
docker run -d \
  --name openclaw \
  --restart unless-stopped \
  -p 18789:18789 \
  -v $(pwd)/data:/home/openclaw/.openclaw \
  openclaw/openclaw:latest

# 显示日志
echo ""
echo "=== OpenClaw deployed successfully! ==="
echo "Access: http://$(curl -s ifconfig.me):18789"
echo ""
echo "View logs:"
echo "  docker logs -f openclaw"
echo ""
```

---

## 🌐 域名配置

### 配置域名解析

#### 步骤1: 购买域名

在域名注册商购买域名（如阿里云、腾讯云、Namecheap）

---

#### 步骤2: 配置DNS解析

1. 登录域名管理控制台
2. 进入「域名解析」
3. 添加记录：
   - **记录类型**: A
   - **主机记录**: openclaw
   - **记录值**: YOUR_SERVER_IP
   - **TTL**: 600

---

#### 步骤3: 配置Nginx反向代理

创建 `nginx.conf`：

```nginx
server {
    listen 80;
    server_name openclaw.example.com;

    location / {
        proxy_pass http://localhost:18789;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

启动Nginx：

```bash
# 启动Nginx
docker run -d \
  --name nginx \
  --network openclaw-network \
  -p 80:80 \
  -v $(pwd)/nginx.conf:/etc/nginx/conf.d/default.conf:ro \
  nginx:alpine
```

---

#### 步骤4: 配置HTTPS

```bash
# 安装certbot
sudo apt install -y certbot python3-certbot-nginx

# 获取证书
sudo certbot --nginx -d openclaw.example.com
```

✅ **成功标志**: 可以访问 https://openclaw.example.com

---

## 🔒 安全加固

### 1. 限制访问IP

```bash
# 使用防火墙限制访问
sudo ufw allow from YOUR_IP to any port 18789
sudo ufw enable
```

---

### 2. 配置安全组

| 协议 | 端口 | 来源 | 说明 |
|------|------|------|------|
| SSH | 22 | 0.0.0.0/0 | 或限制为特定IP |
| HTTP | 80 | 0.0.0.0/0 | 仅当使用Nginx时 |
| HTTPS | 443 | 0.0.0.0/0 | 仅当使用HTTPS时 |
| Custom TCP | 18789 | 0.0.0.0/0 | 或限制为特定IP |

---

### 3. 使用Fail2Ban

```bash
# 安装Fail2Ban
sudo apt install -y fail2ban

# 配置Fail2Ban
sudo cat > /etc/fail2ban/jail.local << 'EOF'
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 5

[ssh]
enabled = true
port = ssh
logpath = /var/log/auth.log
EOF

# 启动Fail2Ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

---

## 💰 成本优化

### 1. 使用包年包月套餐

| 云服务商 | 包年套餐 | 价格 |
|---------|---------|------|
| 阿里云 | 2核2G不限流量 | 99元/年 |
| 腾讯云 | 2核2G | 优惠套餐 |
| AWS | t3.small | $18/月 |

---

### 2. 使用Spot实例（AWS）

```bash
# 在AWS中使用Spot实例
aws ec2 request-spot-fleet \
  --spot-fleet-request-config file://config.json
```

**优势**: 价格低至按需实例的50%

---

### 3. 使用抢占式实例（阿里云）

在阿里云控制台选择「抢占式实例」

**优势**: 价格低至按需实例的50%

---

### 4. 自动停止实例

创建定时任务：

```bash
# 编辑crontab
crontab -e
```

添加定时任务：

```cron
# 每天23点停止实例（AWS）
0 23 * * * aws ec2 stop-instances --instance-ids i-XXXXXXXX
```

---

## ⚠️ 常见问题

### Q: 无法从外网访问？

**A:** 按照以下步骤排查：

1. **检查容器是否运行**
   ```bash
   docker ps
   ```

2. **检查安全组配置**
   - 端口18789是否开放
   - 访问IP是否允许

3. **检查防火墙**
   ```bash
   sudo ufw status
   ```

4. **查看容器日志**
   ```bash
   docker logs openclaw
   ```

---

### Q: 部署后无法启动？

**A:** 常见原因：

| 原因 | 解决方案 |
|------|---------|
| 内存不足 | 升级服务器配置 |
| 端口被占用 | 使用其他端口 |
| 镜像拉取失败 | 检查网络连接 |
| 配置错误 | 检查 openclaw.json |

详细排查见[Docker故障排除](docker-troubleshooting.md)

---

### Q: 如何更新镜像？

**A:**

```bash
# 拉取最新镜像
docker pull openclaw/openclaw:latest

# 停止并删除旧容器
docker stop openclaw
docker rm openclaw

# 启动新容器
docker run -d \
  --name openclaw \
  --restart unless-stopped \
  -p 18789:18789 \
  -v $(pwd)/data:/home/openclaw/.openclaw \
  openclaw/openclaw:latest
```

---

### Q: 如何备份数据？

**A:**

```bash
# 创建备份目录
mkdir -p backups

# 备份数据
docker exec openclaw tar -czf - /home/openclaw/.openclaw > backups/backup-$(date +%Y%m%d).tar.gz

# 查看备份
ls -lh backups/
```

---

## 🚀 下一步

### 云部署进阶

- [ ] 学习[Docker生产部署](docker-production.md)
- [ ] 配置[域名解析](#-域名配置)
- [ ] 设置[安全加固](#-安全加固)

### OpenClaw配置

- [ ] 配置[消息平台对接](../platform-integration/platform-integration-overview.md)
- [ ] 学习[安全配置](../advanced/security.md)
- [ ] 查看[成本优化](#-成本优化)

### 遇到问题？

- [ ] 查看[Docker故障排除](docker-troubleshooting.md)
- [ ] 查看[常见问题](../../FAQ.md)
- [ ] 加入[Discord社区](https://discord.com/invite/clawd)

---

## 📊 相关资源

| 资源 | 链接 |
|------|------|
| 阿里云文档 | https://help.aliyun.com/ |
| 腾讯云文档 | https://cloud.tencent.com/document/product |
| AWS文档 | https://docs.aws.amazon.com/ |
| OpenClaw文档 | https://docs.openclaw.ai |

---

**创建时间**: 2026-02-22
**最后更新**: 2026-02-22
**版本**: 1.0
**适用版本**: Docker 20.10+

<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->
