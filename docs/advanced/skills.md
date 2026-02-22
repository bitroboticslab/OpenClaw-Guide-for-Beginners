# 技能开发与使用

> 扩展OpenClaw的能力，安装、使用和开发自定义技能

---

## 🛠️ 什么是技能？

技能（Skills）是OpenClaw的扩展机制，类似于浏览器插件或VS Code扩展。通过安装技能，OpenClaw可以获得新的能力和功能。

### 技能的核心价值

- ✅ **快速扩展**: 无需修改核心代码即可添加功能
- ✅ **社区共享**: 1700+技能可供选择
- ✅ **自定义开发**: 轻松创建专属技能
- ✅ **权限控制**: 精确控制技能可访问的工具和资源

---

## 📦 ClawHub �技能

ClawHub是OpenClaw的技能市场，类似于npm或VS Code扩展市场。

### 访问ClawHub

- **Web界面**: https://clawhub.com
- **CLI工具**: `openclaw skills` 命令

---

## 🔍 搜索和发现技能

### 1. CLI搜索

```bash
# 搜索技能
openclaw skills search weather

# 搜索所有技能
openclaw skills search --all

# 按标签搜索
openclaw skills search --tag productivity
```

### 2. Web浏览

访问 https://clawhub.com 浏览所有技能

| 分类 | 说明 |
|------|------|
| 🌤️ 天气 | 天气查询、预报 |
| 🔒 安全 | 健康检查、安全审计 |
| 💬 通讯 | 飞书、钉钉、Telegram集成 |
| 📊 数据 | 数据分析、可视化 |
| 🤖 AI | AI模型增强、Agent能力 |

---

## 📥 安装技能

### 1. 使用CLI安装

```bash
# 安装技能
openclaw skills install weather

# 安装指定版本
openclaw skills install weather@1.0.0

# 安装多个技能
openclaw skills install weather healthcheck feishu
```

### 2. 使用Web安装

在ClawHub上找到技能，点击"安装"按钮，复制安装命令执行。

---

## 📋 管理已安装技能

### 1. 列出已安装技能

```bash
# 查看所有已安装技能
openclaw skills list

# 查看技能详情
openclaw skills info weather

# 查看技能版本
openclaw skills list --versions
```

### 2. 更新技能

```bash
# 更新所有技能
openclaw skills update

# 更新指定技能
openclaw skills update weather
```

### 3. 卸载技能

```bash
# 卸载技能
openclaw skills uninstall weather

# 强制卸载（删除所有文件）
openclaw skills uninstall weather --force
```

---

## 🌟 热门技能推荐

### 1. 天气查询

**功能**: 查询实时天气和天气预报

**安装**:
```bash
openclaw skills install weather
```

**使用**:
```
你: 北京今天的天气怎么样？
AI: 北京今天晴，最高温度25°C，最低温度15°C，空气质量良好。
```

---

### 2. 健康检查

**功能**: 系统安全检查和健康监控

**安装**:
```bash
openclaw skills install healthcheck
```

**使用**:
```
你: 运行安全检查
AI: 正在检查系统...
✅ 文件权限正常
✅ 防火墙配置正确
✅ API密钥安全存储
⚠️ 发现1个警告，建议检查...
```

---

### 3. 飞书集成

**功能**: 与飞书消息平台集成

**安装**:
```bash
openclaw skills install feishu
```

**配置**:
```bash
openclaw feishu init
```

详见[飞书集成教程](../platform-integration/feishu-integration.md)

---

### 4. 自我提升

**功能**: 记录学习、错误和改进建议

**安装**:
```bash
openclaw skills install self-improvement
```

**使用**:
```
你: 记住这个教训：配置文件需要600权限
AI: ✅ 已记录到学习文件中，未来会自动应用。
```

---

### 5. NotebookLM

**功能**: 谷用Google NotebookLM进行文档分析

**安装**:
```bash
openclaw skills install notebooklm
```

**使用**:
```
你: 用NotebookLM分析这个PDF文件
AI: 正在上传到NotebookLM并分析...
```

---

## 📝 创建自定义技能

### 1. 技能结构

```
my-skill/
├── SKILL.md              # 技能文档（必需）
├── _meta.json            # 元数据（可选）
├── assets/               # 资源文件（可选）
│   ├── LEARNINGS.md
│   └── templates/
├── scripts/              # 脚本文件（可选）
│   ├── activator.sh
│   └── hook.sh
└── references/           # 参考文档（可选）
    └── examples.md
```

---

### 2. SKILL.md 基本结构

```markdown
---
name: My Skill
description: 技能描述
read_when:
  - 触发条件1
  - 触发条件2
metadata: {
  "emoji": "🎯",
  "version": "1.0.0"
}
allowed-tools: Bash,Read,Write
---

# 技能标题

## 功能描述

描述技能的功能和用途

## 使用方法

### 场景1
```
你: 用户输入
AI: 响应内容
```

### 场景2
...

## 配置选项

| 参数 | 类型 | 说明 |
|------|------|------|
| param1 | string | 参数说明 |
| param2 | boolean | 参数说明 |

## 示例代码

```bash
# 示例命令
command example
```

## 相关资源

- 参考链接1
- 参考链接2
```

---

### 3. 示例技能：简单计数器

**创建目录**：
```bash
mkdir -p counter-skill
cd counter-skill
```

**创建SKILL.md**：
```markdown
---
name: Counter
description: 简单的计数器技能
read_when:
  - 需要计数时
metadata: {
  "emoji": "🔢",
  "version": "1.0.0"
}
allowed-tools: Read,Write,Exec
---

# Counter Skill

简单计数器，用于追踪和统计

## 使用方法

```
你: 计数器加1
AI: 计数器当前值：1

你: 计数器加1
AI: 计数器当前值：2
```

## 实现逻辑

1. 读取counter.txt文件
2. 如果不存在，创建并初始化为0
3. 增加1并保存
4. 返回当前值

## 配置

计数器文件位置：~/.openclaw/workspace/counter.txt
```

---

## 🚀 发布技能到ClawHub

### 1. 准备发布

**确保技能完整**：
- [ ] SKILL.md文件存在且格式正确
- [ ] 元数据完整（name, description, version）
- [ ] 权限配置合理（allowed-tools）
- [ ] 测试通过

---

### 2. 打包技能

```bash
# 打包为zip
zip -r my-skill.zip my-skill/

# 验证内容
unzip -l my-skill.zip
```

---

### 3. 上传到ClawHub

**方式1: 使用CLI**
```bash
openclaw skills publish my-skill.zip
```

**方式2: 使用Web**
1. 访问 https://clawhub.com/publish
2. 上传zip文件
3.填写元数据
4. 提交审核

---

## ⚙️ 技能配置

### 1. 全局技能配置

```json
{
  "skills": {
    "enabled": true,
    "autoUpdate": true,
    "allowlist": [
      "weather",
      "healthcheck",
      "feishu"
    ],
    "blocklist": [
      "untrusted-skill"
    ]
  }
}
```

---

### 2. 技能特定配置

```json
{
  "skills": {
    "config": {
      "weather": {
        "units": "metric",
        "language": "zh-CN"
      },
      "healthcheck": {
        "schedule": "daily",
        "notifyOnFail": true
      }
    }
  }
}
```

---

## 🔧 技能调试

### 1. 启用调试模式

```bash
# 启动OpenClaw时启用调试
DEBUG=* openclaw gateway start

# 查看技能日志
openclaw logs --level debug | grep skills
```

---

### 2. 测试技能

```bash
# 测试技能安装
openclaw skills test-install my-skill

# 测试技能执行
openclaw skills test-run my-skill
```

---

### 3. 查看技能输出

```bash
# 查看技能执行日志
tail -f ~/.openclaw/logs/skills.log
```

---

## 📚 技能开发最佳实践

### 1. 命名规范

- 使用小写字母和连字符：`my-skill`
- 名称描述功能：`weather-forecaster`, `code-reviewer`
- 避免冲突：使用独特前缀

---

### 2. 文档质量

**SKILL.md应包含**：
- 清晰的功能描述
- 详细的使用方法
- 完整的配置选项
- 可运行的示例
- 相关资源链接

---

### 3. 错误处理

```bash
# 总是检查错误
if command; then
  echo "成功"
else
  echo "错误: $?" >&2
  exit 1
fi
```

---

### 4. 权限最小化

只请求必要的工具权限：

```markdown
allowed-tools: Read,Write
# 不要使用: Bash, Exec 除非必需
```

---

## 🔗 相关资源

### 官方文档

- [ClawHub文档](https://docs.openclaw.ai/skills/clawhub)
- [技能开发指南](https://docs.openclaw.ai/skills/development)
- [技能API参考](https://docs.openclaw.ai/skills/api)

### 社区资源

- [技能分享社区](https://clawhub.com/community)
- [技能开发示例](https://github.com/openclaw/skills)
- [技能讨论区](https://github.com/openclaw/openclaw/discussions)

---

## ❓ 常见问题

### Q: 技能安装失败怎么办？

**A:** 检查以下几点：
1. 网络连接是否正常
2. ClawHub是否可访问
3. 技能名称是否正确
4. 查看错误日志：`openclaw logs`

---

### Q: 如何更新技能？

**A:**
```bash
# 更新所有技能
openclaw skills update

# 更新指定技能
openclaw skills update skill-name
```

---

### Q: 技能权限是什么？

**A:** 技能权限定义了技能可以访问的工具：
- `Read`: 读取文件
- `Write`: 写入文件
- `Bash`: 执行shell命令
- `Exec`: 执行外部程序
- `Browser`: 控制浏览器

---

### Q: 如何创建技能Hook？

**A:** 在scripts目录创建hook脚本：
```
my-skill/
└── scripts/
    └── pre-hook.sh  # 在技能执行前运行
```

---

**创建时间**: 2026-02-22
**版本**: 1.0
