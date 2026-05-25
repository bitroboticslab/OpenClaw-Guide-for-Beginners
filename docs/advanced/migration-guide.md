# OpenClaw 迁移指南

**创建时间**: 2026-05-01
**最后更新**: 2026-05-01
**适用版本**: OpenClaw v2026.4.26+

## 📖 概述

本指南帮助你从旧版本 OpenClaw 迁移到最新版本，包括配置迁移、数据迁移和功能升级。

## 🎯 迁移场景

### 场景1: 小版本升级 (推荐)
- **范围**: v2026.4.x → v2026.4.y
- **风险**: 低
- **时间**: 5-10 分钟
- **特点**: 向后兼容，自动迁移

### 场景2: 大版本升级
- **范围**: v2026.3.x → v2026.4.x
- **风险**: 中
- **时间**: 30-60 分钟
- **特点**: 可能有破坏性变更

### 场景3: 跨大版本升级
- **范围**: v2026.2.x → v2026.4.x
- **风险**: 高
- **时间**: 1-2 小时
- **特点**: 需要手动迁移

### 场景4: v2026.4.x → v2026.5.x 平滑升级（推荐）
- **范围**: v2026.4.29 → v2026.5.18
- **风险**: 极低
- **时间**: 3-5 分钟
- **特点**: 100%向后兼容，无破坏性变更，自动迁移所有配置

## 🔧 迁移前准备

### 1. 备份当前状态

```bash
# 使用内置备份命令 (v2026.3.8+)
openclaw backup create --verify

# 或手动备份
tar -czf openclaw-backup-$(date +%Y%m%d).tgz ~/.openclaw
```

### 2. 记录当前配置

```bash
# 导出当前配置
openclaw config export > config-backup.json

# 记录当前版本
openclaw --version > version-backup.txt

# 记录已安装的技能
openclaw skills list > skills-backup.txt
```

### 3. 检查系统要求

```bash
# 检查 Node.js 版本
node --version  # 需要 v24.x

# 检查磁盘空间
df -h ~/.openclaw

# 检查网络连接
openclaw doctor
```

## 🚀 自动迁移 (推荐)

### 场景4专属：v2026.4.29 → v2026.5.18 升级步骤
无需手动修改任何配置，全程自动完成：
```bash
# 1. 停止gateway服务
openclaw gateway stop
# 2. 升级到最新版本
openclaw update
# 3. 自动修复配置（可选，推荐执行）
openclaw doctor --fix
# 4. 启动gateway服务
openclaw gateway start
# 5. 验证升级结果
openclaw version # 输出应为v2026.5.18
```
> 💡 升级完成后所有原有配置、记忆数据、技能插件全部保留，无需额外操作。

### 使用 `openclaw update` 命令

```bash
# 1. 更新到最新版本
openclaw update

# 2. 自动修复配置
openclaw doctor --fix

# 3. 验证迁移结果
openclaw status
```

### 使用 `openclaw migrate` 命令 (v2026.4.26+)

```bash
# 1. 查看迁移计划
openclaw migrate plan

# 2. 干运行迁移
openclaw migrate --dry-run

# 3. 执行迁移
openclaw migrate

# 4. 验证迁移结果
openclaw migrate verify
```

## 📋 手动迁移

### 步骤1: 更新 OpenClaw

```bash
# 方法1: 使用 npm
npm install -g openclaw@latest

# 方法2: 使用 pnpm
pnpm install -g openclaw@latest

# 方法3: 使用 brew (macOS)
brew upgrade openclaw
```

### 步骤2: 迁移配置文件

```bash
# 备份旧配置
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.old

# 检查配置差异
openclaw config diff

# 应用新配置
openclaw config apply
```

### 步骤3: 迁移环境变量

```bash
# 检查废弃的环境变量
env | grep -E "(CLAWDBOT_|MOLTBOT_)"

# 重命名环境变量
# CLAWDBOT_API_KEY → OPENCLAW_API_KEY
# MOLTBOT_API_KEY → OPENCLAW_API_KEY

# 更新 .bashrc 或 .zshrc
sed -i 's/CLAWDBOT_/OPENCLAW_/g' ~/.bashrc
sed -i 's/MOLTBOT_/OPENCLAW_/g' ~/.bashrc
```

### 步骤4: 迁移技能和插件

```bash
# 备份技能目录
cp -r ~/.openclaw/skills ~/.openclaw/skills.backup

# 重新安装技能
openclaw skills update

# 验证技能
openclaw skills list
```

### 步骤5: 迁移数据

```bash
# 备份记忆数据
cp -r ~/.openclaw/memory ~/.openclaw/memory.backup

# 备份会话数据
cp -r ~/.openclaw/sessions ~/.openclaw/sessions.backup

# 验证数据完整性
openclaw doctor
```

## ⚠️ 破坏性变更处理

### 变更1: 环境变量重命名

**影响**: 所有使用 `CLAWDBOT_*` 或 `MOLTBOT_*` 的用户

**解决方案**:
```bash
# 查找所有使用旧环境变量的文件
grep -r "CLAWDBOT_" ~/.openclaw/
grep -r "MOLTBOT_" ~/.openclaw/

# 批量替换
find ~/.openclaw -type f -exec sed -i 's/CLAWDBOT_/OPENCLAW_/g' {} \;
find ~/.openclaw -type f -exec sed -i 's/MOLTBOT_/OPENCLAW_/g' {} \;
```

### 变更2: 插件 SDK 路径变更

**影响**: 使用自定义插件的开发者

**解决方案**:
```bash
# 查找使用旧 SDK 路径的插件
grep -r "openclaw-plugin-sdk" ~/.openclaw/skills/

# 更新导入路径
# 旧: require('openclaw-plugin-sdk')
# 新: require('openclaw/plugin-sdk')
```

### 变更3: Matrix 插件重写

**影响**: 使用 Matrix 渠道的用户

**解决方案**:
```bash
# 备份 Matrix 配置
openclaw config get matrix > matrix-backup.json

# 重新配置 Matrix
openclaw matrix setup

# 导入旧配置
openclaw config import matrix-backup.json
```

### 变更4: Chrome MCP 路径移除

**影响**: 使用 Chrome MCP 的用户

**解决方案**:
```bash
# 自动修复
openclaw doctor --fix

# 或手动修复
openclaw config unset chrome.mcp.legacyPath
```

### 变更5: 工具配置默认值变更

**影响**: 所有用户

**解决方案**:
```bash
# 检查当前工具配置
openclaw config get tools

# 设置正确的工具配置
openclaw config set tools.profile coding

# 验证配置
openclaw config validate
```

## 🔄 数据迁移

### 记忆数据迁移

```bash
# 备份记忆数据
cp -r ~/.openclaw/memory ~/.openclaw/memory.backup

# 迁移记忆数据
openclaw memory migrate

# 验证记忆数据
openclaw memory verify
```

### 会话数据迁移

```bash
# 备份会话数据
cp -r ~/.openclaw/sessions ~/.openclaw/sessions.backup

# 迁移会话数据
openclaw sessions migrate

# 验证会话数据
openclaw sessions verify
```

### 技能数据迁移

```bash
# 备份技能数据
cp -r ~/.openclaw/skills ~/.openclaw/skills.backup

# 迁移技能数据
openclaw skills migrate

# 验证技能数据
openclaw skills verify
```

## 📊 迁移验证

### 验证配置

```bash
# 验证配置文件
openclaw config validate

# 检查配置差异
openclaw config diff

# 测试配置
openclaw doctor
```

### 验证功能

```bash
# 测试 Gateway 启动
openclaw gateway start

# 测试模型调用
openclaw models test

# 测试技能加载
openclaw skills test
```

### 验证数据

```bash
# 验证记忆数据
openclaw memory verify

# 验证会话数据
openclaw sessions verify

# 验证技能数据
openclaw skills verify
```

## 🔍 故障排除

### 常见问题

#### 1. 配置验证失败

**症状**: `openclaw config validate` 报错

**解决方案**:
```bash
# 查看详细错误
openclaw config validate --verbose

# 重置配置
openclaw config reset

# 重新配置
openclaw onboard --install-daemon
```

#### 2. Gateway 无法启动

**症状**: `openclaw gateway start` 失败

**解决方案**:
```bash
# 查看详细日志
openclaw gateway logs

# 检查端口占用
netstat -tulpn | grep 8080

# 重启 Gateway
openclaw gateway restart
```

#### 3. 技能加载失败

**症状**: 技能无法正常加载

**解决方案**:
```bash
# 查看技能日志
openclaw skills logs

# 重新安装技能
openclaw skills reinstall

# 重置技能目录
rm -rf ~/.openclaw/skills
openclaw skills update
```

#### 4. 记忆数据丢失

**症状**: 记忆数据无法访问

**解决方案**:
```bash
# 恢复记忆数据
cp -r ~/.openclaw/memory.backup/* ~/.openclaw/memory/

# 重建记忆索引
openclaw memory rebuild

# 验证记忆数据
openclaw memory verify
```

### 回滚方案

如果迁移失败，可以回滚到旧版本：

```bash
# 1. 停止 Gateway
openclaw gateway stop

# 2. 恢复备份
rm -rf ~/.openclaw
tar -xzf openclaw-backup-$(date +%Y%m%d).tgz -C /

# 3. 安装旧版本
npm install -g openclaw@<旧版本号>

# 4. 启动 Gateway
openclaw gateway start
```

## 📋 迁移检查清单

### 迁移前
- [ ] 备份当前状态
- [ ] 记录当前配置
- [ ] 检查系统要求
- [ ] 通知用户维护时间

### 迁移中
- [ ] 更新 OpenClaw
- [ ] 迁移配置文件
- [ ] 迁移环境变量
- [ ] 迁移技能和插件
- [ ] 迁移数据

### 迁移后
- [ ] 验证配置
- [ ] 验证功能
- [ ] 验证数据
- [ ] 测试关键功能
- [ ] 监控运行状态

## 📚 参考资料

- [官方迁移文档](https://docs.openclaw.ai/zh-CN/migration)
- [版本更新日志](https://github.com/openclaw/openclaw/releases)
- [破坏性变更说明](https://docs.openclaw.ai/zh-CN/breaking-changes)
- [故障排除指南](https://docs.openclaw.ai/zh-CN/troubleshooting)
- [社区支持](https://github.com/openclaw/openclaw/issues)

---

**最后更新**: 2026-05-19
**维护者**: junhang 🦞
