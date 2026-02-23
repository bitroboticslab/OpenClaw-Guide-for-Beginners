#!/bin/bash

# OpenClaw Linux 一键安装脚本
# 支持 Ubuntu/Debian/CentOS

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║           OpenClaw Linux 一键安装脚本                      ║"
echo "║                                                           ║"
echo "║  本脚本将自动安装:                                         ║"
echo "║  1. Node.js 22                                            ║"
echo "║  2. OpenClaw 核心                                         ║"
echo "║  3. 依赖组件                                              ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# 检测系统类型
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo -e "${RED}[错误] 无法检测系统类型${NC}"
    exit 1
fi

echo -e "${BLUE}[信息] 检测到系统: $OS${NC}"

# 检查是否有 root 权限
if [ "$EUID" -ne 0 ]; then
    echo -e "${YELLOW}[警告] 建议使用 sudo 运行此脚本${NC}"
    SUDO="sudo"
else
    SUDO=""
fi

# 安装 Node.js
install_nodejs() {
    echo -e "${BLUE}[1/3] 检查 Node.js 环境...${NC}"
    
    if command -v node &> /dev/null; then
        NODE_VER=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
        if [ "$NODE_VER" -ge 22 ]; then
            echo -e "${GREEN}[√] Node.js 已安装: $(node -v)${NC}"
            return 0
        else
            echo -e "${YELLOW}[!] Node.js 版本过低: $(node -v)，需要 22+${NC}"
        fi
    fi
    
    echo -e "${YELLOW}[!] 正在安装 Node.js 22...${NC}"
    
    case $OS in
        ubuntu|debian)
            $SUDO apt update
            $SUDO apt install -y curl
            curl -fsSL https://deb.nodesource.com/setup_22.x | $SUDO -E bash -
            $SUDO apt install -y nodejs
            ;;
        centos|rhel|rocky|almalinux)
            $SUDO yum install -y curl
            curl -fsSL https://rpm.nodesource.com/setup_22.x | $SUDO bash -
            $SUDO yum install -y nodejs
            ;;
        *)
            echo -e "${RED}[错误] 不支持的系统: $OS${NC}"
            echo "请手动安装 Node.js 22"
            exit 1
            ;;
    esac
    
    echo -e "${GREEN}[√] Node.js 安装完成: $(node -v)${NC}"
}

# 安装 OpenClaw
install_openclaw() {
    echo -e "${BLUE}[2/3] 安装 OpenClaw...${NC}"
    
    if command -v openclaw &> /dev/null; then
        echo -e "${GREEN}[√] OpenClaw 已安装${NC}"
        return 0
    fi
    
    echo -e "${YELLOW}[!] 正在下载并安装 OpenClaw...${NC}"
    curl -fsSL https://openclaw.ai/install.sh | bash
    
    # 添加到 PATH
    export PATH="$HOME/.local/bin:$PATH"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    
    echo -e "${GREEN}[√] OpenClaw 安装完成${NC}"
}

# 配置向导
config_openclaw() {
    echo -e "${BLUE}[3/3] 配置向导...${NC}"
    echo ""
    echo "请选择你的 API 提供商:"
    echo "  1. 硅基流动 (推荐新手)"
    echo "  2. 阿里百炼"
    echo "  3. 火山方舟"
    echo "  4. 智谱 GLM"
    echo "  5. 跳过配置"
    echo ""
    read -p "请输入选择 [1-5]: " CHOICE
    
    case $CHOICE in
        1)
            echo ""
            echo "[!] 请先在 https://cloud.siliconflow.cn 注册账号并获取 API Key"
            read -p "请输入硅基流动 API Key: " API_KEY
            openclaw config set provider siliconflow
            openclaw config set api_key "$API_KEY"
            ;;
        2)
            echo ""
            echo "[!] 请先在 https://bailian.console.aliyun.com 开通服务"
            read -p "请输入阿里百炼 API Key: " API_KEY
            openclaw config set provider bailian
            openclaw config set api_key "$API_KEY"
            ;;
        3)
            echo ""
            echo "[!] 请先在 https://www.volcengine.com/activity/codingplan 订阅"
            read -p "请输入火山方舟 API Key: " API_KEY
            openclaw config set provider volcengine
            openclaw config set api_key "$API_KEY"
            ;;
        4)
            echo ""
            echo "[!] 请先在 https://z.ai/subscribe 订阅"
            read -p "请输入智谱 API Key: " API_KEY
            openclaw config set provider zhipu
            openclaw config set api_key "$API_KEY"
            ;;
        5)
            echo "[!] 已跳过配置，稍后请运行: openclaw onboard --install-daemon"
            ;;
        *)
            echo "[!] 无效选择，已跳过配置"
            ;;
    esac
}

# 显示完成信息
show_complete() {
    echo ""
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║                    安装成功！                              ║"
    echo "║                                                           ║"
    echo "║  启动命令: openclaw start                                 ║"
    echo "║  查看状态: openclaw status                                ║"
    echo "║  查看日志: openclaw logs                                  ║"
    echo "║                                                           ║"
    echo "║  API 平台注册链接:                                        ║"
    echo "║  - 硅基流动: https://cloud.siliconflow.cn                 ║"
    echo "║  - 阿里百炼: https://bailian.console.aliyun.com           ║"
    echo "║  - 火山方舟: https://www.volcengine.com/activity/codingplan║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo ""
}

# 主流程
main() {
    install_nodejs
    install_openclaw
    config_openclaw
    show_complete
}

main
