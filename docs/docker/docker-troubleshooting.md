<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# Docker 故障排除

> Docker部署OpenClaw时的常见问题及解决方案

---

## 📋 目录

- [问题快速索引](#-问题快速索引)
- [安装问题](#-安装问题)
- [容器问题](#-容器问题)
- [网络问题](#-网络问题)
- [数据持久化问题](#-数据持久化问题)
- [性能问题](#-性能问题)
- [安全相关问题](#-安全相关问题)
- [更新和迁移问题](#-更新和迁移问题)
- [获取帮助](#-获取帮助)

---

## 🔍 问题快速索引

| 问题类型 | 优先查看 | 难度 | 预计时间 |
|---------|---------|------|---------|
| Docker无法安装 | [系统检查](#q-docker无法安装) | ⭐ | 3分钟 |
| 容器无法启动 | [日志排查](#q-容器无法启动) | ⭐⭐ | 5分钟 |
| 无法访问服务 | [网络排查](#q-无法从外网访问openclaw服务) | ⭐⭐ | 5分钟 |
| 数据丢失 | [持久化检查](#q-数据没有持久化) | ⭐⭐⭐ | 10分钟 |
| 内存占用过高 | [资源限制](#q-容器内存占用过高) | ⭐⭐ | 5分钟 |
| 更新失败 | [更新排查](#q-镜像更新失败) | ⭐⭐ | 5分钟 |
| 权限错误 | [权限排查](#q-权限不足错误) | ⭐⭐ | 3分钟 |

---

## 📦 安装问题

### Q: Docker无法安装？

**A:** 按照以下步骤排查：

#### 步骤1: 检查系统版本

```bash
# 查看系统版本
cat /etc/os-release
```

**要求**:
- Ubuntu: 18.04+
- CentOS: 7+
- Debian: 10+

❌ 如果版本过低，升级系统或使用其他安装方式

---

#### 步骤2: 清理旧版本

```bash
# Ubuntu/Debian
sudo apt remove docker docker-engine docker.io containerd runc

# CentOS/RHEL
sudo yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine

# 验证清理
docker --version 2>&1 || echo "Docker not found"
```

---

#### 步骤3: 使用官方安装脚本

```bash
# 下载安装脚本
curl -fsSL https://get.docker.com -o get-docker.sh

# 查看脚本内容（可选）
# cat get-docker.sh

# 运行安装脚本
sudo sh get-docker.sh

# 验证安装
docker --version
docker-compose version
```

✅ **成功输出**: Docker version 24.x.x, Docker Compose version 2.x.x

---

### Q: Docker服务无法启动？

**A:** 常见原因和解决方案：

| 原因 | 解决方案 |
|------|---------|
| 权限不足 | `sudo systemctl start docker` |
| 端口被占用 | 检查并停止占用端口的进程 |
| 配置文件错误 | 检查 `/etc/docker/daemon.json` |

---

#### 启动Docker服务

```bash
# 启动Docker服务
sudo systemctl start docker

# 设置开机自启
sudo systemctl enable docker

# 查看服务状态
sudo systemctl status docker
```

---

#### 查看服务日志

```bash
# 查看Docker服务日志
sudo journalctl -u docker -f

# 查看错误日志
sudo journalctl -u docker -p err
```

---

### Q: 权限不足错误？

**A:** 将用户添加到docker组：

```bash
# 将当前用户添加到docker组
sudo usermod -aG docker $USER

# 重新登录或使用newgrp
newgrp docker

# 验证权限
docker ps
```

✅ **成功标志**: 可以运行docker命令而不需要sudo

---

## 🐳 容器问题

### Q: 容器无法启动？

**A:** 按照以下步骤排查：

#### 步骤1: 查看容器状态

```bash
# 查看所有容器（包括停止的）
docker ps -a

# 查看特定容器
docker ps -a | grep openclaw
```

---

#### 步骤2: 查看容器日志

```bash
# 查看容器日志
docker logs openclaw

# 实时查看日志
docker logs -f openclaw

# 查看最近100行
docker logs --tail 100 openclaw
```

---

#### 步骤3: 查看退出代码

```bash
# 查看容器退出代码
docker inspect openclaw | grep ExitCode

# 常见退出代码:
# 0 = 正常退出
# 1 = 错误退出
# 125 = Docker daemon错误
# 126 = 命令不可执行
# 127 = 命令未找到
# 137 = 信号杀死（SIGKILL）
# 139 = 段错误（SIGSEGV）
```

---

#### 步骤4: 重新启动容器

```bash
# 重启容器
docker restart openclaw

# 如果无法重启，删除并重新创建
docker stop openclaw
docker rm openclaw

docker run -d \
  --name openclaw \
  --restart unless-stopped \
  -p 18789:18789 \
  openclaw/openclaw:latest
```

---

### Q: 容器频繁重启？

**A:** 常见原因和解决方案：

| 原因 | 解决方案 |
|------|---------|
| 内存不足 | 增加内存限制或升级服务器 |
| 配置文件错误 | 检查 openclaw.json 语法 |
| 健康检查失败 | 修改健康检查配置 |
| API Key错误 | 更新API Key |

---

#### 查看重启历史

```bash
# 查看容器重启次数
docker inspect openclaw | grep RestartCount

# 查看最后重启时间
docker inspect openclaw | grep RestartedAt
```

---

#### 增加内存限制

```bash
# 启动容器（增加内存限制）
docker run -d \
  --name openclaw \
  --memory="2g" \
  --memory-swap="2g" \
  --restart unless-stopped \
  -p 18789:18789 \
  openclaw/openclaw:latest
```

---

### Q: 容器CPU占用过高？

**A:** 查看和限制CPU使用：

#### 查看CPU使用

```bash
# 查看容器资源使用
docker stats openclaw

# 查看详细信息
docker inspect openclaw | grep -i cpu
```

---

#### 限制CPU使用

```bash
# 启动容器（限制CPU）
docker run -d \
  --name openclaw \
  --cpus="1" \
  --restart unless-stopped \
  -p 18789:18789 \
  openclaw/openclaw:latest

# 更新运行中容器的CPU限制
docker update --cpus="1" openclaw
```

---

## 🌐 网络问题

### Q: 无法从外网访问OpenClaw服务？

**A:** 按照以下步骤排查：

#### 步骤1: 检查容器是否运行

```bash
# 查看容器状态
docker ps | grep openclaw
```

❌ 如果容器未运行，启动容器：
```bash
docker start openclaw
```

---

#### 步骤2: 检查端口映射

```bash
# 查看端口映射
docker port openclaw

# 查看详细信息
docker inspect openclaw | grep -A 10 PortBindings
```

✅ **预期输出**: `18789/tcp -> 0.0.0.0:18789`

---

#### 步骤3: 检查本地访问

```bash
# 在服务器上测试本地访问
curl http://localhost:18789

# 或使用容器IP
docker inspect openclaw | grep IPAddress
curl http://<CONTAINER_IP>:18789
```

---

#### 步骤4: 检查防火墙

```bash
# 检查防火墙状态
sudo ufw status

# 允许端口
sudo ufw allow 18789/tcp

# 或临时禁用防火墙测试
sudo ufw disable
```

---

#### 步骤5: 检查云服务商安全组

**阿里云**:
1. 登录阿里云控制台
2. 进入「云服务器ECS」→「安全组」
3. 检查端口18789是否开放

**腾讯云**:
1. 登录腾讯云控制台
2. 进入「云服务器」→「安全组」
3. 检查端口18789是否开放

**AWS**:
1. 登录AWS控制台
2. 进入「EC2」→「Security Groups」
3. 检查端口18789是否开放

---

#### 步骤6: 检查网络连接

```bash
# 测试服务器IP
ping YOUR_SERVER_IP

# 测试端口
nc -zv YOUR_SERVER_IP 18789
# 或
telnet YOUR_SERVER_IP 18789
```

---

### Q: 容器无法访问外网？

**A:** 检查Docker网络配置：

#### 查看Docker网络

```bash
# 查看网络列表
docker network ls

# 查看默认网络
docker network inspect bridge

# 查看容器网络
docker inspect openclaw | grep -A 10 Networks
```

---

#### 检查DNS解析

```bash
# 在容器中测试DNS
docker exec openclaw nslookup google.com

# 或使用ping
docker exec openclaw ping -c 4 8.8.8.8
```

---

#### 修复DNS问题

**方式1: 使用主机DNS**

```bash
# 启动容器（使用主机DNS）
docker run -d \
  --name openclaw \
  --dns 8.8.8.8 \
  --dns 8.8.4.4 \
  -p 18789:18789 \
  openclaw/openclaw:latest
```

---

**方式2: 使用Docker网络**

```bash
# 创建自定义网络
docker network create --driver bridge openclaw-network

# 启动容器（使用自定义网络）
docker run -d \
  --name openclaw \
  --network openclaw-network \
  --dns 8.8.8.8 \
  -p 18789:18789 \
  openclaw/openclaw:latest
```

---

## 💾 数据持久化问题

### Q: 数据没有持久化？

**A:** 检查volume挂载：

#### 查看挂载

```bash
# 查看容器挂载
docker inspect openclaw | grep -A 20 Mounts
```

✅ **预期输出**:
```json
"Mounts": [
  {
    "Type": "volume",
    "Source": "/home/user/data",
    "Destination": "/home/openclaw/.openclaw",
    ...
  }
]
```

---

#### 正确挂载数据

```bash
# 创建数据目录
mkdir -p data

# 启动容器（挂载数据）
docker run -d \
  --name openclaw \
  -v $(pwd)/data:/home/openclaw/.openclaw \
  -p 18789:18789 \
  openclaw/openclaw:latest

# 验证挂载
docker inspect openclaw | grep Mounts -A 20
```

---

### Q: 数据丢失？

**A:** 恢复数据或检查备份：

#### 检查volume

```bash
# 查看所有volume
docker volume ls

# 查看特定volume
docker volume inspect openclaw-data
```

---

#### 恢复数据

```bash
# 如果有备份，解压备份
tar -xzf backups/backup-20260222.tar.gz

# 重新创建容器并挂载恢复的数据
docker run -d \
  --name openclaw \
  -v $(pwd)/data:/home/openclaw/.openclaw \
  -p 18789:18789 \
  openclaw/openclaw:latest
```

---

#### 查看数据

```bash
# 在容器中查看数据
docker exec openclaw ls -la /home/openclaw/.openclaw

# 复制数据到宿主机
docker cp openclaw:/home/openclaw/.openclaw ./backup-data
```

---

## ⚡ 性能问题

### Q: 容器内存占用过高？

**A:** 查看和优化内存使用：

#### 查看内存使用

```bash
# 查看容器资源使用
docker stats openclaw

# 查看详细信息
docker inspect openclaw | grep -i memory
```

---

#### 限制内存使用

```bash
# 启动容器（限制内存）
docker run -d \
  --name openclaw \
  --memory="2g" \
  --memory-swap="2g" \
  --restart unless-stopped \
  -p 18789:18789 \
  openclaw/openclaw:latest

# 更新运行中容器的内存限制
docker update --memory="2g" openclaw
```

---

#### 优化日志

```bash
# 启动容器（限制日志大小）
docker run -d \
  --name openclaw \
  --log-driver json-file \
  --log-opt max-size=10m \
  --log-opt max-file=3 \
  -p 18789:18789 \
  openclaw/openclaw:latest
```

---

### Q: 磁盘空间不足？

**A:** 清理Docker数据：

#### 查看磁盘使用

```bash
# 查看Docker磁盘使用
docker system df

# 查看详细使用情况
docker system df -v
```

---

#### 清理未使用的资源

```bash
# 清理未使用的镜像
docker image prune -a

# 清理未使用的容器
docker container prune

# 清理未使用的volume
docker volume prune

# 清理所有未使用的资源
docker system prune -a
```

---

#### 清理日志文件

```bash
# 清理容器日志
docker logs openclaw --tail 0

# 或手动清理
sudo sh -c "truncate -s 0 /var/lib/docker/containers/*/openclaw-json.log*"
```

---

### Q: 性能下降？

**A:** 优化措施：

#### 1. 使用资源限制

```bash
# 启动容器（限制资源）
docker run -d \
  --name openclaw \
  --cpus="2" \
  --memory="2g" \
  --pids-limit 100 \
  -p 18789:18789 \
  openclaw/openclaw:latest
```

---

#### 2. 使用缓存

```yaml
version: '3.8'

services:
  redis:
    image: redis:alpine
    container_name: redis
    command: redis-server --appendonly yes

  openclaw:
    image: openclaw/openclaw:latest
    container_name: openclaw
    environment:
      - REDIS_HOST=redis
      - REDIS_PORT=6379
```

---

#### 3. 优化Docker配置

编辑 `/etc/docker/`daemon.json`：

```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "storage-driver": "overlay2",
  "live-restore": true
}
```

重启Docker：

```bash
sudo systemctl restart docker
```

---

## 🔒 安全相关问题

### Q: 容器权限过高？

**A:** 使用非root用户：

```bash
# 启动容器（使用非root用户）
docker run -d \
  --name openclaw \
  -u 1000:1000 \
  -p 18789:18789 \
  openclaw/openclaw:latest
```

---

### Q: 敏感信息泄露？

**A:** 使用环境变量或secret：

#### 使用环境变量

```bash
# 创建.env文件
cat > .env << 'EOF'
OPENCLAW_API_KEY=YOUR_API_KEY
OPENCLAW_PASSWORD=YOUR_PASSWORD
EOF

# 设置权限
chmod 600 .env

# 启动容器（使用环境变量）
docker run -d \
  --name openclaw \
  --env-file .env \
  -p 18789:18789 \
  openclaw/openclaw:latest
```

---

## 🔄 更新和迁移问题

### Q: 镜像更新失败？

**A:** 按照以下步骤排查：

#### 步骤1: 检查网络连接

```bash
# 测试Docker Hub连接
ping registry-1.docker.io

# 或使用curl
curl -I https://registry-1.docker.io/v2/
```

---

#### 步骤2: 手动拉取镜像

```bash
# 拉取最新镜像
docker pull openclaw/openclaw:latest

# 查看镜像
docker images | grep openclaw
```

---

#### 步骤3: 清理旧镜像

```bash
# 清理旧镜像
docker rmi openclaw/openclaw:old-tag

# 或清理所有未使用的镜像
docker image prune -a
```

---

#### 步骤4: 重新创建容器

```bash
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

### Q: 数据迁移失败？

**A:** 检查数据权限和格式：

#### 步骤1: 检查数据权限

```bash
# 查看数据目录权限
ls -la data/

# 修复权限
sudo chown -R 1000:1000 data/
```

---

#### 步骤2: 检查数据格式

```bash
# 检查配置文件格式
docker run --rm \
  -v $(pwd)/data:/data \
  openclaw/openclaw:latest \
  cat /data/openclaw.json | python3 -m json.tool
```

---

#### 步骤3: 手动迁移数据

```bash
# 备份旧数据
docker cp old-openclaw:/home/openclaw/.openclaw ./backup-data

# 启动新容器并挂载数据
docker run -d \
  --name openclaw \
  -v $(pwd)/backup-data:/home/openclaw/.openclaw \
  -p 18789:18789 \
  openclaw/openclaw:latest
```

---

## 📞 获取帮助

### Q: 如何查看详细日志？

**A:**

#### 容器日志

```bash
# 查看容器日志
docker logs openclaw

# 实时查看日志
docker logs -f openclaw

# 查看最近N行
docker logs --tail 100 openclaw

# 查看特定时间的日志
docker logs --since 2024-02-22T10:00:00 openclaw
```

---

#### Docker服务日志

```bash
# 查看Docker服务日志
sudo journalctl -u docker -f

# 查看错误日志
sudo journalctl -u docker -p err
```

---

### Q: 如何诊断问题？

**A:** 收集诊断信息：

```bash
# 收集系统信息
echo "=== System Information ==="
uname -a
docker --version
docker-compose version

echo ""
echo "=== Docker Information ==="
docker info

echo ""
echo "=== Container Information ==="
docker ps -a
docker stats --no-stream

echo ""
echo "=== Network Information ==="
docker network ls

echo ""
echo "=== Volume Information ==="
docker volume ls

echo ""
echo "=== Container Logs ==="
docker logs --tail 50 openclaw
```

---

### Q: 如何获取帮助？

**A:**

#### 官方资源

| 资源 | 链接 |
|------|------|
| Docker文档 | https://docs.docker.com/ |
| Docker论坛 | https://forums.docker.com/ |
| OpenClaw文档 | https://docs.openclaw.ai |
| OpenClaw社区 | https://discord.com/invite/clawd |

---

#### 社区支持

- 💬 [Discord社区](https://discord.com/invite/clawd) - 实时讨论
- 📋 [GitHub Issues](https://github.com/openclaw/openclaw/issues) - 问题报告
- 🔍 [Stack Overflow](https://stackoverflow.com) - Docker相关问题

---

### Q: 如何提交问题？

**A:**

#### 收集诊断信息

```bash
# 收集诊断信息
docker info > docker-info.txt
docker ps -a > docker-ps.txt
docker logs --tail 100 openclaw > docker-logs.txt
```

---

#### 提交Issue

1. 访问 [GitHub Issues](https://github.com/openclaw/openclaw/issues/new)
2. 填写问题描述
3. 附上诊断信息文件
4. 说明复现步骤

---

**创建时间**: 2026-02-22
**最后更新**: 2026-02-22
**版本**: 1.0
**适用版本**: Docker 20.10+

<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->
