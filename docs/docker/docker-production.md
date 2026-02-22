# Docker 生产部署

> 生产环境最佳实践、安全配置和性能优化

---

## 📋 目录

- [生产环境准备](#-生产环境准备)
- [安全配置](#-安全配置)
- [性能优化](#-性能优化)
- [高可用部署](#-高可用部署)
- [监控和日志](#-监控和日志)
- [备份和恢复](#-备份和恢复)
- [自动更新](#-自动更新)
- [常见问题](#-常见问题)

---

## 🚀 生产环境准备

### 服务器要求

| 资源 | 最低配置 | 推荐配置 | 生产环境 |
|------|---------|---------|---------|
| CPU | 1核 | 2核 | 4核+ |
| 内存 | 1GB | 2GB | 4GB+ |
| 存储 | 10GB | 20GB | 50GB+ |
| 网络 | 1Mbps | 10Mbps | 100Mbps+ |

---

### 系统优化

#### 1. 优化Docker配置

编辑 `/etc/docker/daemon.json`：

```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "storage-driver": "overlay2",
  "live-restore": true,
  "max-concurrent-downloads": 10,
  "max-concurrent-uploads": 10
}
```

重启Docker：

```bash
sudo systemctl restart docker
```

---

#### 2. 优化系统参数

编辑 `/etc/sysctl.conf`：

```conf
# 网络优化
net.core.somaxconn = 1024
net.ipv4.tcp_max_syn_backlog = 2048
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 30

# 文件描述符
fs.file-max = 65535
```

应用配置：

```bash
sudo sysctl -p
```

---

#### 3. 增加文件描述符限制

编辑 `/etc/security/limits.conf`：

```
* soft nofile 65536
* hard nofile 65536
* soft nproc 65536
* hard nproc 65536
```

---

## 🔒 安全配置

### 1. 使用只读配置文件

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

# 设置权限
chmod 600 openclaw.json
```

---

### 2. 使用环境变量存储敏感信息

创建 `.env` 文件：

```env
# API配置
OPENCLAW_API_KEY=YOUR_API_KEY

# 安全配置
OPENCLAW_ENABLE_TELEMETRY=false
OPENCLAW_LOG_LEVEL=warn
```

设置权限：

```bash
chmod 600 .env
```

---

### 3. 使用非root用户

```bash
# 创建非root用户
docker run -d \
  --name openclaw \
  -p 18789:18789 \
  -u 1000:1000 \
  -v $(pwd)/data:/home/openclaw/.openclaw \
  openclaw/openclaw:latest
```

---

### 4. 限制容器资源

```bash
# 启动容器（限制资源）
docker run -d \
  --name openclaw \
  --cpus="2" \
  --memory="2g" \
  --memory-swap="2g" \
  --pids-limit 100 \
  -p 18789:18789 \
  -v $(pwd)/data:/home/openclaw/.openclaw \
  openclaw/openclaw:latest
```

---

### 5. 使用Docker Compose生产配置

创建 `docker-compose.prod.yml`：

```yaml
version: '3.8'

services:
  openclaw:
    image: openclaw/openclaw:latest
    container_name: openclaw
    ports:
      - "18789:18789"
    volumes:
      - ./openclaw.json:/home/openclaw/.openclaw/openclaw.json:ro
      - ./data:/home/openclaw/.openclaw/data
    environment:
      - OPENCLAW_LOG_LEVEL=warn
      - OPENCLAW_ENABLE_TELEMETRY=false
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 2G
        reservations:
          cpus: '1'
          memory: 1G
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
    read_only: true
    tmpfs:
      - /tmp
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:18789/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    networks:
      - openclaw-network

networks:
  openclaw-network:
    driver: bridge
```

启动：

```bash
# 启动生产环境
docker-compose -f docker-compose.prod.yml up -d

# 查看状态
docker-compose -f docker-compose.prod.yml ps
```

---

### 6. 使用HTTPS（Nginx反向代理）

#### 获取SSL证书

使用Let's Encrypt：

```bash
# 安装certbot
sudo apt install -y certbot python3-certbot-nginx

# 获取证书
sudo certbot certonly --standalone -d openclaw.example.com
```

---

#### 配置Nginx

创建 `nginx.conf`：

```nginx
server {
    listen 80;
    server_name openclaw.example.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name openclaw.example.com;

    ssl_certificate /etc/letsencrypt/live/openclaw.example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/openclaw.example.com/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    location / {
        proxy_pass http://openclaw:18789;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_read_timeout 300s;
        proxy_connect_timeout 300s;
        proxy_send_timeout 300s;
    }

    # 限制请求大小
    client_max_body_size 10M;
}
```

---

#### 启动Nginx

```bash
# 启动OpenClaw
docker run -d \
  --name openclaw \
  --network openclaw-network \
  -p 18789:18789 \
  -v $(pwd)/data:/home/openclaw/.openclaw \
  openclaw/openclaw:latest

# 启动Nginx
docker run -d \
  --name nginx \
  --network openclaw-network \
  -p 80:80 \
  -p 443:443 \
  -v $(pwd)/nginx.conf:/etc/nginx/conf.d/default.conf:ro \
  -v /etc/letsencrypt:/etc/letsencrypt:ro \
  nginx:alpine
```

---

## ⚡ 性能优化

### 1. 使用多阶段构建

创建 `Dockerfile`：

```dockerfile
# 构建阶段
FROM node:22-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build

# 运行阶段
FROM node:22-alpine AS runner

WORKDIR /app

# 复制构建产物
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./

# 使用非root用户
RUN addgroup -g 1001 -S nodejs
RUN adduser -S openclaw -u 1001
USER openclaw

EXPOSE 18789

CMD ["node", "dist/index.js"]
```

---

### 2. 优化日志配置

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

### 3. 使用缓存优化

```yaml
version: '3.8'

services:
  openclaw:
    image: openclaw/openclaw:latest
    volumes:
      - ./data:/home/openclaw/.openclaw/data
      - ./cache:/home/openclaw/.cache
    environment:
      - NODE_ENV=production
      - CACHE_ENABLED=true
```

---

### 4. 使用Redis缓存（可选）

```yaml
version: '3.8'

services:
  redis:
    image: redis:alpine
    container_name: redis
    command: redis-server --appendonly yes
    volumes:
      - ./redis-data:/data
    restart: unless-stopped

  openclaw:
    image: openclaw/openclaw:latest
    container_name: openclaw
    depends_on:
      - redis
    ports:
      - "18789:18789"
    environment:
      - REDIS_HOST=redis
      - REDIS_PORT=6379
    restart: unless-stopped
```

---

## 🔁 高可用部署

### 1. 使用负载均衡

```yaml
version: '3.8'

services:
  nginx:
    image: nginx:alpine
    container_name: nginx
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    depends_on:
      - openclaw1
      - openclaw2

  openclaw1:
    image: openclaw/openclaw:latest
    container_name: openclaw1
    volumes:
      - ./data1:/home/openclaw/.openclaw
    restart: unless-stopped

  openclaw2:
    image: openclaw/openclaw:latest
    container_name: openclaw2
    volumes:
      - ./data2:/home/openclaw/.openclaw
    restart: unless-stopped
```

---

### 2. 使用Docker Swarm

```bash
# 初始化Swarm
docker swarm init

# 创建服务
docker service create \
  --name openclaw \
  --replicas 3 \
  --publish 18789:18789 \
  openclaw/openclaw:latest

# 查看服务
docker service ls

# 扩缩容
docker service scale openclaw=5
```

---

### 3. 使用Kubernetes

创建 `deployment.yaml`：

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: openclaw
spec:
  replicas: 3
  selector:
    matchLabels:
      app: openclaw
  template:
    metadata:
      labels:
        app: openclaw
    spec:
      containers:
      - name: openclaw
        image: openclaw/openclaw:latest
        ports:
        - containerPort: 18789
        resources:
          limits:
            memory: "2Gi"
            cpu: "1000m"
          requests:
            memory: "1Gi"
            cpu: "500m"
        volumeMounts:
        - name: data
          mountPath: /home/openclaw/.openclaw
      volumes:
      - name: data
        persistentVolumeClaim:
          claimName: openclaw-pvc
---
apiVersion: v1
kind: Service
metadata:
  name: openclaw
spec:
  selector:
    app: openclaw
  ports:
  - port: 18789
    targetPort: 18789
  type: LoadBalancer
```

---

## 📊 监控和日志

### 1. 使用Docker健康检查

```bash
# 启动容器（启用健康检查）
docker run -d \
  --name openclaw \
  --health-cmd="curl -f http://localhost:18789/health || exit 1" \
  --health-interval=30s \
  --health-timeout=10s \
  --health-retries=3 \
  -p 18789:18789 \
  openclaw/openclaw:latest

# 查看健康状态
docker inspect --format='{{json .State.Health}}' openclaw
```

---

### 2. 使用Prometheus监控

创建 `prometheus.yml`：

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'openclaw'
    static_configs:
      - targets: ['openclaw:18789']
```

启动Prometheus：

```yaml
version: '3.8'

services:
  prometheus:
    image: prom/prometheus
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'

  openclaw:
    image: openclaw/openclaw:latest
    container_name: openclaw
    ports:
      - "18789:18789"
```

---

### 3. 使用Grafana可视化

```yaml
version: '3.8'

services:
  grafana:
    image: grafana/grafana
    container_name: grafana
    ports:
      - "3000:3000"
    volumes:
      - ./grafana-data:/var/lib/grafana
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin

  prometheus:
    image: prom/prometheus
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml

  openclaw:
    image: openclaw/openclaw:latest
    container_name: openclaw
    ports:
      - "18789:18789"
```

---

### 4. 集中式日志收集（ELK Stack）

```yaml
version: '3.8'

services:
  elasticsearch:
    image: elasticsearch:8.0.0
    container_name: elasticsearch
    environment:
      - discovery.type=single-node
    volumes:
      - ./es-data:/usr/share/elasticsearchasticsearch/data

  logstash:
    image: logstash:8.0.0
    container_name: logstash
    volumes:
      - ./logstash.conf:/usr/share/logstash/pipeline/logstash.conf
    depends_on:
      - elasticsearch

  kibana:
    image: kibana:8.0.0
    container_name: kibana
    ports:
      - "5601:5601"
    depends_on:
      - elasticsearch

  openclaw:
    image: openclaw/openclaw:latest
    container_name: openclaw
    ports:
      - "18789:18789"
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

---

## 💾 备份和恢复

### 1. 自动备份脚本

创建 `backup.sh`：

```bash
#!/bin/bash

BACKUP_DIR="./backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="openclaw-backup-${BACKUP_DIR}.tar.gz"

mkdir -p ${BACKUP_DIR}

# 备份数据
tar -czf ${BACKUP_DIR}/${BACKUP_FILE} ./data

# 删除30天前的备份
find ${BACKUP_DIR} -name "openclaw-backup-*.tar.gz" -mtime +30 -delete

echo "Backup created: ${BACKUP_DIR}/${BACKUP_FILE}"
```

设置权限：

```bash
chmod +x backup.sh
```

---

### 2. 定时备份

使用cron：

```bash
# 编辑crontab
crontab -e
```

添加定时任务：

```cron
# 每天凌晨2点备份
0 2 * * * /path/to/backup.sh >> /var/log/openclaw-backup.log 2>&1
```

---

### 3. 恢复数据

```bash
# 解压备份
tar -xzf backups/openclaw-backup-20260222_020000.tar.gz

# 启动容器（恢复数据）
docker run -d \
  --name openclaw \
  -p 18789:18789 \
  -v $(pwd)/data:/home/openclaw/.openclaw \
  openclaw/openclaw:latest
```

---

## 🔄 自动更新

### 1. 使用Watchtower自动更新镜像

```yaml
version: '3.8'

services:
  watchtower:
    image: containrrr/watchtower
    container_name: watchtower
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - WATCHTOWER_CLEANUP=true
      - WATCHTOWER_SCHEDULE=0 0 * * *

  openclaw:
    image: openclaw/openclaw:latest
    container_name: openclaw
    ports:
      - "18789:18789"
    labels:
      - "com.centurylinklabs.watchtower.enable=true"
```

---

### 2. 手动更新脚本

创建 `update.sh`：

```bash
#!/bin/bash

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

echo "OpenClaw updated successfully!"
```

---

## ⚠️ 常见问题

### Q: 容器频繁重启？

**A:** 检查容器状态和日志：

```bash
# 查看容器状态
docker ps -a

# 查看容器日志
docker logs openclaw

# 查看退出代码
docker inspect openclaw | grep ExitCode
```

常见原因：
- 内存不足 → 增加内存限制
- 配置错误 → 检查 `openclaw.json`
- 健康检查失败 → 检查健康检查配置

---

### Q: 性能下降？

**A:** 优化措施：

1. **增加资源限制**
   ```bash
   docker update --cpus="2" --memory="2g" openclaw
   ```

2. **优化日志配置**
   ```bash
   docker run --log-opt max-size=10m --log-opt max-file=3
   ```

3. **使用缓存**
   ```yaml
   environment:
     - CACHE_ENABLED=true
   ```

---

### Q: 如何查看资源使用？

**A:**

```bash
# 实时查看资源使用
docker stats openclaw

# 查看详细信息
docker inspect openclaw

# 查看磁盘使用
docker system df
```

---

## 🚀 下一步

### Docker进阶

- [ ] 学习[Docker Cloud部署](docker-cloud-deployment.md)
- [ ] 配置[高可用部署](#-高可用部署)
- [ ] 设置[监控和日志](#-监控和日志)

### OpenClaw配置

- [ ] 配置[消息平台对接](../platform-integration/platform-integration-overview.md)
- [ ] 学习[安全配置](../advanced/security.md)
- [ ] 配置[自动备份](#-备份和恢复)

### 遇到问题？

- [ ] 查看[Docker故障排除](docker-troubleshooting.md)
- [ ] 查看[常见问题](../../FAQ.md)
- [ ] 加入[Discord社区](https://discord.com/invite/clawd)

---

## 📊 相关资源

| 资源 | 链接 |
|------|------|
| Docker安全最佳实践 | https://docs.docker.com/engine/security/ |
| Docker性能优化 | https://docs.docker.com/engine/quickstart/ |
| Prometheus监控 | https://prometheus.io/docs/ |
| Grafana可视化 | https://grafana.com/docs/ |

---

**创建时间**: 2026-02-22
**最后更新**: 2026-02-22
**版本**: 1.0
**适用版本**: Docker 20.10+, Docker Compose 2.0+
