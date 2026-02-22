#!/bin/bash

# OpenClaw Docker 快速部署脚本
# 适用于 Docker 环境（Linux/macOS/WSL）

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║           OpenClaw Docker 快速部署脚本                    ║"
echo "║                                                           ║"
echo "║  本脚本将自动执行:                                         ║"
echo "║  1. 检查 Docker 环境                                      ║"
echo "║  2. 拉取 OpenClaw 镜像                                   ║"
echo "║  3. 配置 OpenClaw                                        ║"
echo "║  4. 启动 OpenClaw 容器                                   ║"
echo "╚═════════════════════════════════════════════════════════╝"
echo ""

# 检查 Docker
check_docker() {
    echo -e "${BLUE}[1/5] 检查 Docker 环境...${NC}"

    if ! command -v docker &> /dev/null; then
        echo -e "${RED}[错误] Docker 未安装${NC}"
        echo ""
        echo "请先安装 Docker:"
        echo "  - Linux/macOS: https://docs.docker.com/get-docker/"
        echo "  - Windows: https://docs.docker.com/desktop/install/windows-install/"
        echo ""
        read -p "是否现在打开 Docker 安装页面? [y/N]: " OPEN_DOCKER
        if [[ $OPEN_DOCKER =~ ^[Yy]$ ]]; then
            if [[ "$OSTYPE" == "darwin"* ]]; then
                open "https://docs.docker.com/desktop/install/mac-install/"
            else
                echo "请访问: https://docs.docker.com/get-docker/"
            fi
        fi
        exit 1
    fi

    # 检查 Docker 是否运行
    if ! docker info &> /dev/null; then
        echo -e "${YELLOW}[警告] Docker 未运行${NC}"
        echo "请启动 Docker 后重新运行此脚本"
        exit 1
    fi

    echo -e "${GREEN}[√] Docker 环境正常: $(docker --version)${NC}"
}

# 拉取镜像
pull_image() {
    echo -e "${BLUE}[2/5] 拉取 OpenClaw 镜像...${NC}"

    # 检查镜像是否存在
    if docker images openclaw/openclaw:latest &> /dev/null; then
        echo -e "${GREEN}[√] OpenClaw 镜像已存在${NC}"
        read -p "是否更新镜像? [y/N]: " UPDATE_IMAGE
        if [[ ! $UPDATE_IMAGE =~ ^[Yy]$ ]]; then
            return 0
        fi
    fi

    echo -e "${YELLOW}[!] 正在拉取镜像...${NC}"
    docker pull openclaw/openclaw:latest

    echo -e "${GREEN}[√] 镜像拉取完成${NC}"
}

# 配置 OpenClaw
config_openclaw() {
    echo -e "${BLUE}[3/5] 配置 OpenClaw...${NC}"

    # 创建数据目录
    mkdir -p data

    # 检查是否存在配置文件
    if [ -f openclaw.json ]; then
        echo -e "${GREEN}[√] 配置文件已存在${NC}"
        read -p "是否重新配置? [y/N]: " RECONFIG
        if [[ ! $RECONFIG =~ ^[Yy]$ ]]; then
            return 0
        fi
    fi

    echo ""
    echo "请选择你的 API 提供商:"
    echo "  1. 硅基流动 (推荐新手)"
    echo "  2. 阿里百炼"
    echo "  3. 火山方舟"
    echo "  4. 智谱 GLM"
    echo "  5. 跳过配置"
    echo ""
    read -p "请输入选择 [1-5]: " CHOICE

    PROVIDER=""
    API_KEY=""

    case $CHOICE in
        1)
            echo ""
            echo "[!] 请先在 https://cloud.siliconflow.cn 注册账号并获取 API Key"
            read -p "请输入硅基流动 API Key: " API_KEY
            PROVIDER="siliconflow"
            ;;
        2)
            echo ""
            echo "[!] 请先在 https://bailian.console.aliyun.com 开通服务"
            read -p "请输入阿里百炼 API Key: " API_KEY
            PROVIDER="bailian"
            ;;
        3)
            echo ""
            echo "[!] 请先在 https://www.volcengine.com/activity/codingplan 订阅"
            read -p "请输入火山方舟 API Key: " API_KEY
            PROVIDER="volcengine"
            ;;
        4)
            echo ""
            echo "[!] 请先在 https://z.ai/subscribe 订阅"
            read -p "请输入智谱 API Key: " API_KEY
            PROVIDER="zhipu"
            ;;
        5)
            echo "[!] 已跳过配置"
            return 0
            ;;
        *)
            echo "[!] 无效选择，已跳过配置"
            return 0
            ;;
    esac

    # 创建配置文件
    cat > openclaw.json << EOF
{
  "providers": {
    "$PROVIDER": {
      "apiKey": "$API_KEY"
    }
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "$PROVIDER/qwen-turbo"
      }
    }
  }
}
EOF

    chmod 600 openclaw.json

    echo -e "${GREEN}[√] 配置文件创建完成${NC}"
}

# 停止旧容器
stop_old_container() {
    echo -e "${BLUE}[4/5] 停止旧容器...${NC}"

    if docker ps -a | grep -q openclaw; then
        echo -e "${YELLOW}[!] 发现旧容器，正在停止...${NC}"
        docker stop openclaw || true
        docker rm openclaw || true
    fi

    echo -e "${GREEN}[√] 旧容器已清理${NC}"
}

# 启动容器
start_container() {
    echo -e "${BLUE}[5/5] 启动 OpenClaw 容器...${NC}"

    # 检查端口是否被占用
    if lsof -Pi :18789 -sTCP:LISTEN -t >/dev/null ; then
        echo -e "${YELLOW}[警告] 端口 18789 已被占用${NC}"
        read -p "是否强制使用端口? [y/N]: " FORCE_PORT
        if [[ ! $FORCE_PORT =~ ^[Yy]$ ]]; then
            echo "[!] 请释放端口 18789 后重新运行"
            exit 1
        fi
    fi

    # 启动容器
    if [ -f openclaw.json ]; then
        docker run -d \
            --name openclaw \
            --restart unless-stopped \
            -p 18789:18789 \
            -v $(pwd)/openclaw.json:/home/openclaw/.openclaw/openclaw.json:ro \
            -v $(pwd)/data:/home/openclaw/.openclaw/data \
            openclaw/openclaw:latest
    else
        docker run -d \
            --name openclaw \
            --restart unless-stopped \
            -p 18789:18789 \
            -v $(pwd)/data:/home/openclaw/.openclaw/data \
            openclaw/openclaw:latest
    fi

    # 等待容器启动
    sleep 3

    # 检查容器状态
    if docker ps | grep -q openclaw; then
        echo -e "${GREEN}[√] OpenClaw 容器启动成功${NC}"
    else
        echo -e "${RED}[错误] 容器启动失败${NC}"
        echo "[!] 查看日志: docker logs openclaw"
        exit 1
    fi
}

# 显示完成信息
show_complete() {
    echo ""
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║                    部署成功！                              ║"
    echo "║                                                           ║"
    echo "║  容器名称: openclaw                                        ║"
    echo "║  服务端口: 18789                                          ║"
    echo "║  数据目录: $(pwd)/data                                    ║"
    echo "║                                                           ║"
    echo "║  管理命令:                                                 ║"
    echo "║  - 查看状态: docker ps                                    ║"
    echo "║  - 查看日志: docker logs -f openclaw                       ║"
    echo "║  - 停止容器: docker stop openclaw                          ║"
    echo "║  - 启动容器: docker start openclaw                         ║"
    echo "║  - 删除容器: docker rm -f openclaw                         ║"
    echo "║                                                           ║"
    echo "║  访问地址:                                                 ║"
    echo "║  - 本地: http://localhost:18789                            ║"
    echo "║  - 云服务器: http://YOUR_SERVER_IP:18789                   ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo ""
}

# 主流程
main() {
    check_docker
    pull_image
    config_openclaw
    stop_old_container
    start_container
    show_complete
}

main
