#!/bin/bash
# OpenClaw版本监控脚本
# 用于自动检测OpenClaw官方版本更新
# 版本: v1.0 | 更新时间: 2026-06-27

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置
GITHUB_API="https://api.github.com/repos/openclaw/openclaw/releases"
GUIDE_VERSION_FILE="README.md"
CHANGELOG_FILE="CHANGELOG.md"

# 打印函数
print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}\n"
}

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 获取OpenClaw最新版本
get_latest_version() {
    print_info "获取OpenClaw最新版本..."
    
    # 使用GitHub API获取最新release
    LATEST_RELEASE=$(curl -s "$GITHUB_API/latest" 2>/dev/null)
    
    if [ $? -ne 0 ]; then
        print_error "无法访问GitHub API"
        return 1
    fi
    
    # 提取版本号
    LATEST_VERSION=$(echo "$LATEST_RELEASE" | grep -oP '"tag_name":\s*"\K[^"]+')
    
    if [ -z "$LATEST_VERSION" ]; then
        print_error "无法解析版本号"
        return 1
    fi
    
    print_success "OpenClaw最新版本: $LATEST_VERSION"
    echo "$LATEST_VERSION"
}

# 获取教程当前版本
get_guide_version() {
    print_info "获取教程当前版本..."
    
    if [ ! -f "$GUIDE_VERSION_FILE" ]; then
        print_error "README.md不存在"
        return 1
    fi
    
    GUIDE_VERSION=$(grep -oP 'v\d+\.\d+\.\d+' "$GUIDE_VERSION_FILE" | head -1)
    
    if [ -z "$GUIDE_VERSION" ]; then
        print_error "无法从README.md提取版本号"
        return 1
    fi
    
    print_success "教程当前版本: $GUIDE_VERSION"
    echo "$GUIDE_VERSION"
}

# 获取CHANGELOG版本
get_changelog_version() {
    print_info "获取CHANGELOG版本..."
    
    if [ ! -f "$CHANGELOG_FILE" ]; then
        print_error "CHANGELOG.md不存在"
        return 1
    fi
    
    CHANGELOG_VERSION=$(grep -oP '## \[\K\d+\.\d+\.\d+' "$CHANGELOG_FILE" | head -1)
    
    if [ -z "$CHANGELOG_VERSION" ]; then
        print_error "无法从CHANGELOG.md提取版本号"
        return 1
    fi
    
    print_success "CHANGELOG版本: $CHANGELOG_VERSION"
    echo "$CHANGELOG_VERSION"
}

# 版本比较
compare_versions() {
    local version1=$1
    local version2=$2
    
    # 移除v前缀
    v1=${version1#v}
    v2=${version2#v}
    
    # 分割版本号
    IFS='.' read -r major1 minor1 patch1 <<< "$v1"
    IFS='.' read -r major2 minor2 patch2 <<< "$v2"
    
    # 比较主版本号
    if [ "$major1" -gt "$major2" ]; then
        return 1
    elif [ "$major1" -lt "$major2" ]; then
        return 2
    fi
    
    # 比较次版本号
    if [ "$minor1" -gt "$minor2" ]; then
        return 1
    elif [ "$minor1" -lt "$minor2" ]; then
        return 2
    fi
    
    # 比较修订号
    if [ "$patch1" -gt "$patch2" ]; then
        return 1
    elif [ "$patch1" -lt "$patch2" ]; then
        return 2
    fi
    
    # 版本相同
    return 0
}

# 生成更新建议
generate_update_suggestion() {
    local latest=$1
    local current=$2
    
    print_header "更新建议"
    
    # 移除v前缀
    latest_num=${latest#v}
    current_num=${current#v}
    
    # 分割版本号
    IFS='.' read -r l_major l_minor l_patch <<< "$latest_num"
    IFS='.' read -r c_major c_minor c_patch <<< "$current_num"
    
    # 计算版本差距
    major_diff=$((l_major - c_major))
    minor_diff=$((l_minor - c_minor))
    patch_diff=$((l_patch - c_patch))
    
    echo "版本差距分析:"
    echo "  主版本差距: $major_diff"
    echo "  次版本差距: $minor_diff"
    echo "  修订号差距: $patch_diff"
    echo ""
    
    # 生成建议
    if [ $major_diff -gt 0 ]; then
        print_warning "存在主版本更新，可能包含破坏性变更"
        echo "建议:"
        echo "  1. 仔细阅读官方升级指南"
        echo "  2. 测试环境验证后再更新教程"
        echo "  3. 参考AGENT.md中的渐进式版本对齐策略"
    elif [ $minor_diff -gt 0 ]; then
        print_info "存在次版本更新，包含新功能"
        echo "建议:"
        echo "  1. 查看官方Release Notes"
        echo "  2. 评估对教程的影响"
        echo "  3. 制定版本对齐计划"
    elif [ $patch_diff -gt 0 ]; then
        print_info "存在修订号更新，主要是bug修复"
        echo "建议:"
        echo "  1. 查看修复内容"
        echo "  2. 评估是否影响教程"
        echo "  3. 按需更新教程"
    else
        print_success "版本已是最新"
    fi
}

# 检查关键版本
check_key_versions() {
    print_header "关键版本检查"
    
    # 定义关键版本列表
    KEY_VERSIONS=(
        "v2026.6.2"
        "v2026.6.6"
        "v2026.6.8"
        "v2026.6.9"
        "v2026.6.10"
    )
    
    print_info "检查关键版本覆盖情况..."
    
    for version in "${KEY_VERSIONS[@]}"; do
        # 检查是否有对应版本变更记录
        version_file="docs/version-changes/${version#v}.md"
        
        if [ -f "$version_file" ]; then
            print_success "$version - 已有版本变更记录"
        else
            print_warning "$version - 缺少版本变更记录"
        fi
    done
}

# 生成版本报告
generate_report() {
    local latest=$1
    local guide=$2
    local changelog=$3
    
    print_header "版本监控报告"
    
    echo "报告时间: $(date)"
    echo ""
    echo "版本信息:"
    echo "  OpenClaw最新版本: $latest"
    echo "  教程当前版本: $guide"
    echo "  CHANGELOG版本: $changelog"
    echo ""
    
    # 检查版本一致性
    if [ "$guide" == "v$changelog" ]; then
        print_success "版本一致性: README与CHANGELOG版本匹配"
    else
        print_warning "版本一致性: README($guide)与CHANGELOG($changelog)版本不匹配"
    fi
    
    # 生成更新建议
    generate_update_suggestion "$latest" "$guide"
    
    # 检查关键版本
    check_key_versions
}

# 主函数
main() {
    echo -e "${BLUE}OpenClaw版本监控脚本${NC}"
    echo -e "${BLUE}版本: v1.0${NC}"
    echo -e "${BLUE}时间: $(date)${NC}\n"
    
    # 获取版本信息
    LATEST_VERSION=$(get_latest_version)
    if [ $? -ne 0 ]; then
        print_error "获取OpenClaw最新版本失败"
        exit 1
    fi
    
    GUIDE_VERSION=$(get_guide_version)
    if [ $? -ne 0 ]; then
        print_error "获取教程当前版本失败"
        exit 1
    fi
    
    CHANGELOG_VERSION=$(get_changelog_version)
    if [ $? -ne 0 ]; then
        print_error "获取CHANGELOG版本失败"
        exit 1
    fi
    
    # 生成报告
    generate_report "$LATEST_VERSION" "$GUIDE_VERSION" "$CHANGELOG_VERSION"
    
    # 返回状态
    compare_versions "$LATEST_VERSION" "$GUIDE_VERSION"
    result=$?
    
    if [ $result -eq 0 ]; then
        print_success "教程版本已是最新"
        exit 0
    elif [ $result -eq 2 ]; then
        print_warning "教程版本落后于OpenClaw最新版本"
        exit 1
    else
        print_warning "教程版本超前于OpenClaw最新版本（可能使用beta版本）"
        exit 0
    fi
}

# 执行主函数
main "$@"
