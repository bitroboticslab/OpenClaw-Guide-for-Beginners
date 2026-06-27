#!/bin/bash
# OpenClaw Guide 质量保障测试脚本
# 用于版本发布前的完整验证
# 版本: v1.0 | 更新时间: 2026-06-27

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 计数器
TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0
WARNING_CHECKS=0

# 打印函数
print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}\n"
}

print_check() {
    echo -e "${BLUE}[CHECK]${NC} $1"
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
}

print_pass() {
    echo -e "${GREEN}[PASS]${NC} $1"
    PASSED_CHECKS=$((PASSED_CHECKS + 1))
}

print_fail() {
    echo -e "${RED}[FAIL]${NC} $1"
    FAILED_CHECKS=$((FAILED_CHECKS + 1))
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
    WARNING_CHECKS=$((WARNING_CHECKS + 1))
}

print_summary() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}测试总结${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo -e "总检查项: ${TOTAL_CHECKS}"
    echo -e "${GREEN}通过: ${PASSED_CHECKS}${NC}"
    echo -e "${RED}失败: ${FAILED_CHECKS}${NC}"
    echo -e "${YELLOW}警告: ${WARNING_CHECKS}${NC}"
    
    if [ $FAILED_CHECKS -gt 0 ]; then
        echo -e "\n${RED}❌ 存在失败的检查项，请修复后重新测试${NC}"
        return 1
    elif [ $WARNING_CHECKS -gt 0 ]; then
        echo -e "\n${YELLOW}⚠️ 存在警告，建议修复后再发布${NC}"
        return 0
    else
        echo -e "\n${GREEN}✅ 所有检查通过，可以发布！${NC}"
        return 0
    fi
}

# 1. 文件结构检查
check_file_structure() {
    print_header "1. 文件结构检查"
    
    print_check "检查必要文件存在"
    local required_files=(
        "README.md"
        "CHANGELOG.md"
        "CONTRIBUTING.md"
        "RELEASING.md"
        "AGENT.md"
        "LICENSE"
        "AUTHORS.md"
        "FAQ.md"
        "RESOURCES.md"
    )
    
    for file in "${required_files[@]}"; do
        if [ -f "$file" ]; then
            print_pass "$file 存在"
        else
            print_fail "$file 不存在"
        fi
    done
    
    print_check "检查docs目录结构"
    local required_dirs=(
        "docs/getting-started"
        "docs/installation"
        "docs/configuration"
        "docs/integration"
        "docs/advanced"
        "docs/version-changes"
    )
    
    for dir in "${required_dirs[@]}"; do
        if [ -d "$dir" ]; then
            print_pass "$dir 存在"
        else
            print_fail "$dir 不存在"
        fi
    done
}

# 2. 版本一致性检查
check_version_consistency() {
    print_header "2. 版本一致性检查"
    
    print_check "检查README版本号"
    README_VERSION=$(grep -oP 'v\d+\.\d+\.\d+' README.md | head -1)
    if [ -n "$README_VERSION" ]; then
        print_pass "README版本号: $README_VERSION"
    else
        print_fail "README中未找到版本号"
    fi
    
    print_check "检查CHANGELOG版本号"
    CHANGELOG_VERSION=$(grep -oP '## \[\K\d+\.\d+\.\d+' CHANGELOG.md | head -1)
    if [ -n "$CHANGELOG_VERSION" ]; then
        print_pass "CHANGELOG版本号: $CHANGELOG_VERSION"
    else
        print_fail "CHANGELOG中未找到版本号"
    fi
    
    print_check "检查版本号一致性"
    if [ "$README_VERSION" == "v$CHANGELOG_VERSION" ]; then
        print_pass "版本号一致: $README_VERSION"
    else
        print_fail "版本号不一致: README($README_VERSION) vs CHANGELOG($CHANGELOG_VERSION)"
    fi
}

# 3. 链接验证
check_links() {
    print_header "3. 链接验证"
    
    print_check "检查内部链接"
    # 提取所有内部链接并验证
    INTERNAL_ERRORS=0
    for file in $(find docs -name "*.md" -type f); do
        # 提取相对链接
        grep -oP '\[.*?\]\(\K[^)]+' "$file" | while read link; do
            # 跳过外部链接和锚点
            if [[ "$link" =~ ^https?:// ]] || [[ "$link" =~ ^# ]]; then
                continue
            fi
            
            # 解析相对路径
            base_dir=$(dirname "$file")
            full_path="$base_dir/$link"
            
            # 检查文件是否存在
            if [ ! -f "$full_path" ]; then
                print_fail "内部链接失效: $file -> $link"
                INTERNAL_ERRORS=$((INTERNAL_ERRORS + 1))
            fi
        done
    done
    
    if [ $INTERNAL_ERRORS -eq 0 ]; then
        print_pass "所有内部链接有效"
    fi
    
    print_check "检查外部链接（抽样）"
    # 只检查关键外部链接
    EXTERNAL_ERRORS=0
    for url in "https://github.com/bitroboticslab" "https://openclaw.ai"; do
        if curl -s --head "$url" | head -n 1 | grep -q "200 OK"; then
            print_pass "外部链接可访问: $url"
        else
            print_warning "外部链接可能无法访问: $url"
            EXTERNAL_ERRORS=$((EXTERNAL_ERRORS + 1))
        fi
    done
}

# 4. Markdown格式检查
check_markdown_format() {
    print_header "4. Markdown格式检查"
    
    print_check "检查标题层级"
    FORMAT_ERRORS=0
    for file in $(find docs -name "*.md" -type f); do
        # 检查是否有跳级标题
        prev_level=0
        while IFS= read -r line; do
            if [[ "$line" =~ ^#{1,6}\  ]]; then
                level=$(echo "$line" | grep -oP '^#+')
                level=${#level}
                
                if [ $prev_level -gt 0 ] && [ $level -gt $((prev_level + 1)) ]; then
                    print_warning "标题层级跳跃: $file (第$prev_level级 -> 第$level级)"
                    FORMAT_ERRORS=$((FORMAT_ERRORS + 1))
                fi
                prev_level=$level
            fi
        done < "$file"
    done
    
    if [ $FORMAT_ERRORS -eq 0 ]; then
        print_pass "标题层级规范"
    fi
    
    print_check "检查代码块语言标注"
    CODE_BLOCK_ERRORS=0
    for file in $(find docs -name "*.md" -type f); do
        # 检查是否有未标注语言的代码块
        if grep -q '^```$' "$file"; then
            print_warning "发现未标注语言的代码块: $file"
            CODE_BLOCK_ERRORS=$((CODE_BLOCK_ERRORS + 1))
        fi
    done
    
    if [ $CODE_BLOCK_ERRORS -eq 0 ]; then
        print_pass "代码块语言标注完整"
    fi
}

# 5. 术语一致性检查
check_terminology() {
    print_header "5. 术语一致性检查"
    
    print_check "检查OpenClaw拼写"
    TERMINOLOGY_ERRORS=0
    
    # 检查全小写
    if grep -r "openclaw" docs/ --include="*.md" -l | grep -v "openclaw.ai" >/dev/null 2>&1; then
        print_fail "发现 'openclaw'（全小写），应使用 'OpenClaw'"
        TERMINOLOGY_ERRORS=$((TERMINOLOGY_ERRORS + 1))
    fi
    
    # 检查首字母小写
    if grep -r "Openclaw" docs/ --include="*.md" -l >/dev/null 2>&1; then
        print_fail "发现 'Openclaw'，应使用 'OpenClaw'"
        TERMINOLOGY_ERRORS=$((TERMINOLOGY_ERRORS + 1))
    fi
    
    if [ $TERMINOLOGY_ERRORS -eq 0 ]; then
        print_pass "术语使用一致"
    fi
}

# 6. 命令语法检查
check_command_syntax() {
    print_header "6. 命令语法检查"
    
    print_check "检查bash命令语法"
    SYNTAX_ERRORS=0
    
    for file in $(find docs -name "*.md" -type f); do
        # 提取bash代码块
        sed -n '/^```bash/,/^```$/p' "$file" | grep -v '```' > /tmp/test_commands.sh
        
        if [ -s /tmp/test_commands.sh ]; then
            # 语法检查
            if ! bash -n /tmp/test_commands.sh 2>/dev/null; then
                print_fail "命令语法错误: $file"
                SYNTAX_ERRORS=$((SYNTAX_ERRORS + 1))
            fi
        fi
    done
    
    if [ $SYNTAX_ERRORS -eq 0 ]; then
        print_pass "所有bash命令语法正确"
    fi
}

# 7. 内容完整性检查
check_content_completeness() {
    print_header "7. 内容完整性检查"
    
    print_check "检查CHANGELOG格式"
    if grep -q "^## \[" CHANGELOG.md; then
        print_pass "CHANGELOG格式正确"
    else
        print_fail "CHANGELOG格式错误"
    fi
    
    print_check "检查版本变更记录"
    VERSION_FILES=$(find docs/version-changes -name "*.md" -type f | wc -l)
    if [ $VERSION_FILES -gt 0 ]; then
        print_pass "版本变更记录存在 ($VERSION_FILES 个文件)"
    else
        print_warning "版本变更记录为空"
    fi
    
    print_check "检查安装脚本"
    SCRIPT_FILES=$(find scripts -name "*.sh" -o -name "*.ps1" -o -name "*.bat" | wc -l)
    if [ $SCRIPT_FILES -gt 0 ]; then
        print_pass "安装脚本存在 ($SCRIPT_FILES 个文件)"
    else
        print_warning "安装脚本为空"
    fi
}

# 8. 安全性检查
check_security() {
    print_header "8. 安全性检查"
    
    print_check "检查敏感信息泄露"
    SECURITY_ERRORS=0
    
    # 检查是否包含API密钥
    if grep -r "sk-" docs/ --include="*.md" >/dev/null 2>&1; then
        print_fail "发现可能的API密钥"
        SECURITY_ERRORS=$((SECURITY_ERRORS + 1))
    fi
    
    # 检查是否包含密码
    if grep -ri "password" docs/ --include="*.md" | grep -v "密码" | grep -v "password=" >/dev/null 2>&1; then
        print_warning "发现可能的密码字段，请确认是否为示例"
    fi
    
    if [ $SECURITY_ERRORS -eq 0 ]; then
        print_pass "未发现敏感信息泄露"
    fi
}

# 主函数
main() {
    echo -e "${BLUE}OpenClaw Guide 质量保障测试${NC}"
    echo -e "${BLUE}版本: v1.0${NC}"
    echo -e "${BLUE}时间: $(date)${NC}\n"
    
    # 执行所有检查
    check_file_structure
    check_version_consistency
    check_links
    check_markdown_format
    check_terminology
    check_command_syntax
    check_content_completeness
    check_security
    
    # 打印总结
    print_summary
    
    return $?
}

# 执行主函数
main "$@"
