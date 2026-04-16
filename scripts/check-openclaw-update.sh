#!/bin/bash
# OpenClaw 版本自动检测与更新脚本
# 功能：定期检测OpenClaw官方版本更新，自动同步到教程中

set -e

# 配置项
OFFICIAL_REPO="openclaw/openclaw"
CURRENT_DIR="/root/.hermes/projects/OpenClaw-Guide-for-Beginners"
VERSION_FILES=(
    "README.md"
    "docs/windows/windows-install-guide.md"
    "docs/wsl/wsl-setup.md"
    "docs/linux/linux-install-guide.md"
    "docs/macos/macos-install-guide.md"
)
NOTIFICATION_EMAIL="admin@example.com"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== OpenClaw 版本检测脚本启动 ===${NC}"
echo "检测时间: $(date '+%Y-%m-%d %H:%M:%S')"

# 1. 获取官方最新版本
echo -e "\n${YELLOW}1. 获取OpenClaw官方最新版本...${NC}"
LATEST_VERSION=$(curl -s "https://api.github.com/repos/$OFFICIAL_REPO/releases/latest" | jq -r '.tag_name' | sed 's/^v//')
if [ -z "$LATEST_VERSION" ] || [ "$LATEST_VERSION" == "null" ]; then
    echo -e "${RED}❌ 获取官方版本失败，请检查网络连接${NC}"
    exit 1
fi
echo -e "✅ 官方最新版本: $LATEST_VERSION"

# 2. 获取当前教程中使用的版本
echo -e "\n${YELLOW}2. 获取当前教程中使用的版本...${NC}"
CURRENT_VERSION=$(grep -r "OpenClaw.*v[0-9]*\.[0-9]*\.[0-9]*" README.md | head -n1 | grep -o "v[0-9]*\.[0-9]*\.[0-9]*" | sed 's/^v//')
if [ -z "$CURRENT_VERSION" ]; then
    CURRENT_VERSION=$(grep -r "openclaw.*202[0-9]\.[0-9]*\.[0-9]*" README.md | head -n1 | grep -o "202[0-9]\.[0-9]*\.[0-9]*")
fi
if [ -z "$CURRENT_VERSION" ]; then
    echo -e "${RED}❌ 无法获取当前教程版本，请检查README.md${NC}"
    exit 1
fi
echo -e "✅ 当前教程版本: $CURRENT_VERSION"

# 3. 版本对比
echo -e "\n${YELLOW}3. 版本对比...${NC}"
# 分割版本号
IFS='.' read -r LATEST_MAJOR LATEST_MINOR LATEST_PATCH <<< "$LATEST_VERSION"
IFS='.' read -r CURRENT_MAJOR CURRENT_MINOR CURRENT_PATCH <<< "$CURRENT_VERSION"

# 判断更新等级
UPDATE_LEVEL=""
if [ "$LATEST_MAJOR" -gt "$CURRENT_MAJOR" ]; then
    UPDATE_LEVEL="major"
elif [ "$LATEST_MINOR" -gt "$CURRENT_MINOR" ]; then
    UPDATE_LEVEL="minor"
elif [ "$LATEST_PATCH" -gt "$CURRENT_PATCH" ]; then
    UPDATE_LEVEL="patch"
else
    echo -e "${GREEN}✅ 教程内容已经是最新版本，无需更新${NC}"
    exit 0
fi

echo -e "${YELLOW}⚠️ 检测到新版本更新，更新等级: $UPDATE_LEVEL${NC}"
echo -e "版本变化: v$CURRENT_VERSION → v$LATEST_VERSION"

# 4. 检查是否为重大更新
echo -e "\n${YELLOW}4. 检查更新内容...${NC}"
RELEASE_NOTES=$(curl -s "https://api.github.com/repos/$OFFICIAL_REPO/releases/latest" | jq -r '.body')
BREAKING_CHANGE=$(echo "$RELEASE_NOTES" | grep -i "breaking\|不兼容\|重大变更" || true)

if [ -n "$BREAKING_CHANGE" ] || [ "$UPDATE_LEVEL" == "major" ]; then
    echo -e "${RED}⚠️ 检测到重大不兼容更新，需要进行完整适配${NC}"
    NEED_FULL_ADAPT=true
else
    echo -e "${YELLOW}ℹ️  本次为兼容更新，仅需要更新版本号与相关命令${NC}"
    NEED_FULL_ADAPT=false
fi

# 5. 自动更新教程内容
echo -e "\n${YELLOW}5. 开始更新教程内容...${NC}"
cd "$CURRENT_DIR"
git checkout main
git pull origin main

# 创建新分支
BRANCH_NAME="feat/update-openclaw-to-v$LATEST_VERSION"
git checkout -b "$BRANCH_NAME"

# 更新所有文件中的版本号
for file in "${VERSION_FILES[@]}"; do
    if [ -f "$file" ]; then
        sed -i "s/OpenClaw.*v$CURRENT_VERSION/OpenClaw v$LATEST_VERSION/g" "$file"
        sed -i "s/openclaw.*$CURRENT_VERSION/openclaw $LATEST_VERSION/g" "$file"
        sed -i "s/版本 >= $CURRENT_VERSION/版本 >= $LATEST_VERSION/g" "$file"
        echo "✅ 更新 $file 中的版本号"
    fi
done

# 6. 提交变更
echo -e "\n${YELLOW}6. 提交变更...${NC}"
git add .
COMMIT_MSG="feat: 更新OpenClaw版本到v$LATEST_VERSION"
if [ "$NEED_FULL_ADAPT" = true ]; then
    COMMIT_MSG="$COMMIT_MSG - 包含重大不兼容变更，需要后续适配"
fi
git commit -m "$COMMIT_MSG"

# 7. 推送分支并创建PR
echo -e "\n${YELLOW}7. 推送分支并创建PR...${NC}"
git push origin "$BRANCH_NAME"

PR_BODY="## 自动版本更新
### 版本变化
v$CURRENT_VERSION → v$LATEST_VERSION
### 更新等级
$UPDATE_LEVEL
### 重大变更
$([ "$NEED_FULL_ADAPT" = true ] && echo "✅ 包含重大不兼容变更，需要完整适配" || echo "❌ 兼容更新，无需额外适配")
### 官方Release说明
$RELEASE_NOTES
### 自动更新内容
- 已更新所有文档中的版本号引用
- 待人工检查是否有其他需要更新的内容
"
gh pr create --title "$COMMIT_MSG" --body "$PR_BODY" --base main --head "$BRANCH_NAME"

PR_URL=$(gh pr view --json url -q .url)
echo -e "${GREEN}✅ PR创建成功: $PR_URL${NC}"

# 8. 发送通知
echo -e "\n${GREEN}=== 版本检测完成 ===${NC}"
echo "检测到新版本 v$LATEST_VERSION，已自动创建PR: $PR_URL"
echo "请审核PR内容，完成适配后合并"

exit 0