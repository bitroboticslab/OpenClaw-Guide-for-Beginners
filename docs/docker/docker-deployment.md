<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# Docker 部署教程

> 使用Docker快速部署OpenClaw，实现环境隔离和轻松迁移

---

## 📋 目录

- [前置条件](#-前置条件)
- [快速开始](#-快速开始)
- [Docker安装](#-docker安装)
- [OpenClaw Docker镜像](#-openclaw-docker镜像)
- [基本部署](#-基本部署)
- [配置文件](#-配置文件)
- [数据持久化](#-数据持久化)
- [网络配置](#-网络配置)
- [常见问题](#-常见问题)

---

## ✅ 前置条件

### 系统要求

| 要求 | 最低版本 | 推荐版本 | 检查命令 |
|------|---------|---------|---------|
| 操作系统 | Ubuntu 18.04+ | Ubuntu 22.04 | `cat /etc/os-release` |
| 内存 | 2GB | 4GB+ | `free -h` |
| 存储 | 10GB | 20GB+ | `df -h` |
| 网络 | 稳定连接 | 稳定连接 | - |

---

### Docker要求

| 要求 | 版本 | 检查命令 |
|------|------|---------|
| Docker | 20.10+ | `docker --version` |
| Docker Compose | 2.0+ | `docker-compose --version` |

---

### 权限要求

✅ **sudo权限**: 安装和管理Docker需要管理员权限

---

## 🚀 快速开始

> 5分钟快速部署OpenClaw

### 部署进度

| 步骤 | 任务 | 预计时间 | 状态 |
|------|------|---------|------|
| 1️⃣ | 安装Docker | 2分钟 | ⏳ 进行中 |
| 2️⃣ | 拉取镜像 | 1分钟 | ⏸️ 待开始 |
| 3️⃣ | 配置文件 | 1分钟 | ⏸️ 待开始 |
| 4️⃣ | 启动容器 | 30秒 | ⏸️ 待开始 |
| 5️⃣ | 验证部署 | 30秒 | ⏸️ 待开始 |

---

### 一键部署（推荐）✨

```bash
# 1. 拉取OpenClaw镜像
docker pull openclaw/openclaw:latest

# 2. 创建配置文件
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

# 3. 启动容器
docker run -d \
  --name openclaw \
  --restart unless-stopped \
  -p 18789:18789 \
  -v $(pwd)/openclaw.json:/home/openclaw/.openclaw/openclaw.json:ro \
  -v $(pwd)/data:/home/openclaw/.openclaw/data \
  openclaw/openclaw:latest

# 4. 查看日志
docker logs -f openclaw
```

✅ **成功标志**: 看到 "Gateway running on http://0.0.0.0:18789"

---

## 📦 Docker安装

### 方式1: 官方安装脚本（推荐）✨

**适用场景**: Ubuntu/Debian系统

```bash
# 下载安装脚本
curl -fsSL https://get.docker.com -o get-docker.sh

# 运行安装脚本
sudo sh get-docker.sh

# 将当前用户添加到docker组
sudo usermod -aG docker $USER

# 重新登录以生效
newgrp docker

# 验证安装
docker docker version
docker-compose version
```

✅ **成功输出**: Docker version 24.x.x, Docker Compose version 2.x.x

---

### 方式2: 手动安装

**适用场景**: 需要精细控制版本

#### Ubuntu/Debian

```bash
# 更新包管理器
sudo apt update

# 安装依赖
sudo apt install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release

# 添加Docker官方GPG密钥
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# 添加Docker仓库
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 安装Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 启动Docker服务
sudo systemctl start docker
sudo systemctl enable docker

# 验证安装
docker --version
docker-compose version
```

---

#### CentOS/RHEL

```bash
# 安装依赖
sudo yum install -y yum-utils

# 添加Docker仓库
sudo yum-config-manager \
  --add-repo \
  https://download.docker.com/linux/centos/docker-ce.repo

# 安装Docker
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 启动Docker服务
sudo systemctl start docker
sudo systemctl enable docker

# 验证安装
docker --version
docker-compose version
```

---

### 方式3: 使用Docker Desktop

**适用场景**: Windows/macOS系统

#### Windows

1. 下载Docker Desktop: https://www.docker.com/products/docker-desktop
2. 运行安装程序
3. 启用WSL 2后端（推荐）
4. 重启计算机
5. 验证安装: `docker --version`

#### macOS

1. 下载Docker Desktop: https://www.docker.com/products/docker-desktop/mac
2. 拖拽到Applications文件夹
3. 启动Docker Desktop
4. 验证安装: `docker --version`

---

### 验证Docker安装

```bash
# 运行测试容器
docker run hello-world

# 查看Docker信息
docker info

# 查看Docker版本
docker --version
docker-compose version
```

✅ **成功输出**: Hello from Docker!

---

## 🐳 OpenClaw Docker镜像

### 拉取镜像

```bash
# 拉取最新版本
docker pull openclaw/openclaw:latest

# 拉取指定版本
docker pull openclaw/openclaw:v2026.3.28

# 查看已拉取的镜像
docker images | grep openclaw
```

---

### 镜像版本

| 版本标签 | 说明 | 推荐场景 |
|---------|------|---------|
| `latest` | 最新稳定版本 | 生产环境 |
| `v2026.3.28` | 特定版本 | 稳定环境 |
| `dev` | 开发版本 | 测试环境 |
| `alpine` | Alpine Linux版本 | 轻量级部署 |

---

### 查看镜像信息

```bash
# 查看镜像详细信息
docker inspect openclaw/openclaw:latest

# 查看镜像大小
docker images openclaw/openclaw:latest
```

---

## 🚀 基本部署

### 最小化部署

```bash
# 启动容器（最小配置）
docker run -d \
  --name openclaw \
  -p 18789:18789 \
  openclaw/openclaw:latest
```

---

### 使用配置文件部署

```bash
# 创建配置文件目录
mkdir -p openclaw-config

# 创建openclaw.json
cat > openclaw-config/openclaw.json << 'EOF'
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

# 启动容器（挂载配置文件）
docker run -d \
  --name openclaw \
  -p 18789:18789 \
  -v $(pwd)/openclaw-config/openclaw.json:/home/openclaw/.openclaw/openclaw.json \
  openclaw/openclaw:latest
```

---

### 使用环境变量部署

```bash
# 启动容器（使用环境变量）
docker run -d \
  --name openclaw \
  -p 18789:18789 \
  -e OPENCLAW_API_KEY="YOUR_API_KEY" \
  -e OPENCLAW_MODEL="bailian/qwen-turbo" \
  openclaw/openclaw:latest
```

---

### 完整部署

```bash
# 创建必要目录
mkdir -p openclaw-config/data

# 启动容器（完整配置）
docker run -d \
  --name openclaw \
  -p 18789:18789 \
  -v $(pwd)/openclaw-config/openclaw.json:/home/openclaw/.openclaw/openclaw.json \
  -v $(pwd)/openclaw-config/data:/home/openclaw/.openclaw/data \
  -e OPENCLAW_LOG_LEVEL="info" \
  -e OPENCLAW_ENABLE_TELEMETRY="false" \
  --restart unless-stopped \
  openclaw/openclaw:latest
```

---

## 📄 配置文件

### openclaw.json

创建 `openclaw.json` 配置文件：

```json
{
  "providers": {
    "bailian": {
      "apiKey": "YOUR_API_KEY",
      "endpoint": "https://dashscope.aliyuncs.com/api/v1"
    }
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "bailian/qwen-turbo",
        "fallback": ["bailian/qwen-max"]
      }
    },
    "maxResponseTokens": 4096
  },
  "gateway": {
    "bind": "0.0.0.0",
    "port": 18789,
    "trustedProxies": ["*"]
  },
  "plugins": {
    "allow": [
      "feishu",
      "wecom",
      "dingtalk",
      "adp-openclaw"
    ]
  }
}
```

<details>
<summary><b>💡 推荐API平台</b></summary>

| 平台 | 新用户福利 | 链接 |
|------|-----------|------|
| ![推荐](https://img.shields.io/badge/推荐-新手-green) | 硅基流动 | 2000万Tokens免费 | [注册](https://cloud.siliconflow.cn/i/lva59yow) |
| ![高性价比](https://img.shields.io/badge/高性价比-blue) | 火山引擎 | 首月8.9元 | [订阅](https://volcengine.com/L/oqijuWrltl0/  ) |
| ![优惠](https://img.shields.io/badge/优惠-长期-orange) | 智谱GLM | 年付7折 | [订阅](https://www.bigmodel.cn/glm-coding?ic=BUDVTRHUYH) |

</details>

---

### .env 文件

创建 `.env` 文件存储敏感信息：

```env
# API配置
OPENCLAW_API_KEY=YOUR_API_KEY
OPENCLAW_MODEL=bailian/qwen-turbo

# 网关配置
GATEWAY_BIND=0.0.0.0
GATEWAY_PORT=18789

# 日志配置
LOG_LEVEL=info

# 其他配置
ENABLE_TELEMETRY=false
```

---

### 使用Docker Compose

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
    environment:
      - OPENCLAW_LOG_LEVEL=info
      - OPENCLAW_ENABLE_TELEMETRY=false
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:18789/health"]
      interval: 30s
      timeout: 10s
      retries: 3
```

启动服务：

```bash
# 启动服务
docker-compose up -d

# 查看日志
docker-compose logs -f

# 停止服务
docker-compose down
```

---

## 💾 数据持久化

### 挂载目录

```bash
# 创建数据目录
mkdir -p openclaw-data

# 启动容器（挂载数据目录）
docker run -d \
  --name openclaw \
  -p 18789:18789 \
  -v $(pwd)/openclaw-data:/home/openclaw/.openclaw \
  openclaw/openclaw:latest
```

---

### 数据目录结构

```
openclaw-data/
├── openclaw.json          # 配置文件
├── data/                  # 数据目录
│   ├── sessions/          # 会话数据
│   ├── memory/            # 记忆数据
│   └── workspace/         # 工作区
├── logs/                  # 日志文件
└── cache/                 # 缓存文件
```

---

### 备份数据

```bash
# 备份完整数据目录
tar -czf openclaw-backup-$(date +%Y%m%d).tar.gz openclaw-data/

# 仅备份关键数据
tar -czf openclaw-data-backup-$(date +%Y%m%d).tar.gz \
  openclaw-data/data/ \
  openclaw-data/openclaw.json
```

---

### 恢复数据

```bash
# 解压备份文件
tar -xzf openclaw-backup-20260222.tar.gz

# 启动容器（恢复数据）
docker run -d \
  --name openclaw \
  -p 18789:18789 \
  -v $(pwd)/openclaw-data:/home/openclaw/.openclaw \
  openclaw/openclaw:latest
```

---

## 🌐 网络配置

### 端口映射

```bash
# 单端口映射
docker run -d --name openclaw -p 18789:18789 openclaw/openclaw:latest

# 多端口映射（如果需要）
docker run -d \
  --name openclaw \
  -p 18789:18789 \
  -p 8080:8080 \
  openclaw/openclaw:latest
```

---

### 使用自定义网络

```bash
# 创建网络
docker network create openclaw-network

# 启动容器（使用自定义网络）
docker run -d \
  --name openclaw \
  --network openclaw-network \
  --network-alias openclaw \
  -p 18789:18789 \
  openclaw/openclaw:latest

# 查看网络
docker network inspect openclaw-network
```

---

### 使用反向代理（Nginx）

创建 `nginx.conf`：

```nginx
server {
    listen 80;
    server_name openclaw.example.com;

    location / {
        proxy_pass http://openclaw:18789;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

启动Nginx和OpenClaw：

```bash
# 启动OpenClaw
docker run -d \
  --name openclaw \
  --network openclaw-network \
  -p 18789:18789 \
  openclaw/openclaw:latest

# 启动Nginx
docker run -d \
  --name nginx \
  --network openclaw-network \
  -p 80:80 \
  -v $(pwd)/nginx.conf:/etc/nginx/conf.d/default.conf:ro \
  nginx:alpine
```

---

## ⚠️ 常见问题

### Q: Docker安装失败？

**A:** 按照以下步骤排查：

1. **检查系统版本**
   ```bash
   cat /etc/os-release
   ```
   确保是Ubuntu 18.04+或CentOS 7+

2. **清理旧版本**
   ```bash
   sudo apt remove docker docker-engine docker.io containerd runc
   ```

3. **重新安装**
   ```bash
   curl -fsSL https://get.docker.com -o get-docker.sh
   sudo sh get-docker.sh
   ```

详细排查见[Docker故障排除](docker-troubleshooting.md)

---

### Q: 容器无法启动？

**A:** 常见原因和解决方案：

| 原因 | 解决方案 |
|------|---------|
| 端口被占用 | 使用 `-p 18790:18789` 映射其他端口 |
| 配置文件错误 | 检查 `openclaw.json` 语法 |
| 权限不足 | 使用 `sudo` 或添加用户到docker组 |
| 内存不足 | 增加Docker内存限制 |

查看详细日志：
```bash
# 查看容器日志
docker logs openclaw

# 实时查看日志
docker logs -f openclaw
```

---

### Q: 数据无法持久化？

**A:** 确保正确挂载目录：

```bash
# 正确挂载
docker run -d \
  --name openclaw \
  -v $(pwd)/data:/home/openclaw/.openclaw \
  openclaw/openclaw:latest

# 验证挂载
docker inspect openclaw | grep Mounts -A 10
```

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
  -p 18789:18789 \
  -v $(pwd)/data:/home/openclaw/.openclaw \
  openclaw/openclaw:latest
```

---

### Q: 如何查看容器资源使用？

**A:**

```bash
# 查看容器状态
docker stats openclaw

# 查看详细信息
docker inspect openclaw

# 查看进程
docker top openclaw
```

---

## 🚀 下一步

### Docker进阶

- [ ] 学习[Docker生产部署](docker-production.md)
- [ ] 学习[Docker Cloud部署](docker-cloud-deployment.md)
- [ ] 配置[数据备份和恢复](#-数据持久化)

### OpenClaw配置

- [ ] 配置[消息平台对接](../platform-integration/platform-integration-overview.md)
- [ ] 设置[自动重启](docker-production.md)
- [ ] 学习[安全配置](../advanced/security.md)

### 遇到问题？

- [ ] 查看[Docker故障排除](docker-troubleshooting.md)
- [ ] 查看[常见问题](../../FAQ.md)
- [ ] 加入[Discord社区](https://discord.com/invite/clawd)

---

## 📊 相关资源

| 资源 | 链接 |
|------|------|
| Docker官方文档 | https://docs.docker.com/ |
| Docker Compose文档 | https://docs.docker.com/compose/ |
| OpenClaw Docker镜像 | https://hub.docker.com/r/openclaw/openclaw |
| OpenClaw文档 | https://docs.openclaw.ai |

---

**创建时间**: 2026-02-22
**最后更新**: 2026-02-22
**版本**: 1.0
**适用版本**: Docker 20.10+, Docker Compose 2.0+

<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->
