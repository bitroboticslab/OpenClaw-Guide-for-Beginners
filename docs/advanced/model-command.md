<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# /model 模型切换命令说明

> 使用 /model 命令快速切换 AI 模型，无需修改配置文件

## 📋 前置要求

- OpenClaw v2.0.0 或更高版本
- 已配置至少一个 AI 模型（参考 [模型选择指南](../configuration/model-comparison.md)）

---

## 功能说明

`/model` 命令允许用户在对话中快速切换 AI 模型，无需重启服务或修改配置文件。

### 核心特性

- 🔄 **快速切换**：一条命令切换模型
- 📋 **模型列表**：查看所有可用模型
- ✅ **切换确认**：确认当前使用的模型
- 🎯 **会话级切换**：仅影响当前会话
- 💾 **记忆功能**：记住用户偏好模型

---

## 基本用法

### 1.1 查看当前模型

```
/model
```

输出：

```
🤖 当前模型
━━━━━━━━━━━━━━━━━━━━
模型: bailian/qwen-plus
Provider: 百炼
状态: ✅ 正常
━━━━━━━━━━━━━━━━━━━━
```

### 1.2 查看可用模型列表

```
/model list
```

输出：

```
📋 可用模型列表
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  #  模型名称              Provider    状态
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  1  qwen-plus ⭐          百炼        ✅ 正常
  2  qwen-coder-plus      百炼        ✅ 正常
  3  claude-sonnet-4       OpenRouter  ✅ 正常
  4  gemini-2.5-pro        Vertex      ✅ 正常
  5  glm-5.2              智谱        ✅ 正常
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⭐ = 当前默认模型
使用 /model <编号或名称> 切换
```

### 1.3 切换模型

**按编号切换**：

```
/model 3
```

**按名称切换**：

```
/model claude-sonnet-4
```

**按 Provider/名称切换**：

```
/model openrouter/claude-sonnet-4
```

输出：

```
✅ 模型已切换
━━━━━━━━━━━━━━━━━━━━
原模型: bailian/qwen-plus
新模型: claude-sonnet-4
Provider: OpenRouter
━━━━━━━━━━━━━━━━━━━━
本次切换仅影响当前会话
```

---

## 快速切换

### 2.1 使用别名

OpenClaw 支持模型别名，方便快速切换：

```json
{
  "commands": {
    "model": {
      "aliases": {
        "qwen": "bailian/qwen-plus",
        "coder": "bailian/qwen-coder-plus",
        "claude": "openrouter/anthropic/claude-sonnet-4",
        "gemini": "vertex/gemini-2.5-pro",
        "fast": "bailian/qwen-turbo",
        "smart": "openrouter/anthropic/claude-sonnet-4"
      }
    }
  }
}
```

使用别名切换：

```
/model claude
/model fast
/model smart
```

### 2.2 快捷键切换

配置快捷键实现一键切换：

```json
{
  "commands": {
    "model": {
      "shortcuts": {
        "m1": "bailian/qwen-plus",
        "m2": "openrouter/anthropic/claude-sonnet-4",
        "m3": "vertex/gemini-2.5-pro"
      }
    }
  }
}
```

使用快捷键：

```
/model m1
/model m2
```

### 2.3 行内切换

在消息中直接指定模型：

```
/model:claude 帮我写一个函数
```

或

```
@claude 帮我写一个函数
```

> 行内切换仅对当前消息生效，不会改变会话默认模型。

---

## 模型列表

### 3.1 详细列表

```
/model list --detail
```

输出：

```
📋 可用模型详细列表
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[qwen-plus] ⭐
  Provider: 百炼
  类型: 通用对话
  上下文: 128K
  价格: ¥0.004/千次输入, ¥0.012/千次输出
  状态: ✅ 正常
  延迟: ~1.2s

[claude-sonnet-4]
  Provider: OpenRouter
  类型: 通用对话 / 编程
  上下文: 200K
  价格: $3/百万次输入, $15/百万次输出
  状态: ✅ 正常
  延迟: ~2.1s

[gemini-2.5-pro]
  Provider: Vertex
  类型: 通用对话 / 长文本
  上下文: 1M
  价格: $1.25/百万次输入, $5/百万次输出
  状态: ✅ 正常
  延迟: ~1.8s
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 3.2 按类型筛选

```
/model list --type code
```

输出：

```
📋 编程模型列表
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  #  模型名称              Provider    价格
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  1  qwen-coder-plus      百炼        ¥0.006/千次
  2  claude-sonnet-4       OpenRouter  $3/百万次
  3  codestral-latest      OpenRouter  $0.3/百万次
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 3.3 按 Provider 筛选

```
/model list --provider bailian
```

### 3.4 搜索模型

```
/model search claude
```

输出：

```
🔍 搜索结果: "claude"
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  #  模型名称              Provider    状态
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  1  claude-sonnet-4       OpenRouter  ✅
  2  claude-haiku-4.5      OpenRouter  ✅
  3  claude-3.5-sonnet     OpenRouter  ✅
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## 切换确认

### 4.1 切换确认提示

切换模型时会显示确认信息：

```
/model claude-sonnet-4
```

输出：

```
⚠️ 确认切换模型
━━━━━━━━━━━━━━━━━━━━
当前模型: bailian/qwen-plus
目标模型: claude-sonnet-4
Provider: OpenRouter

费用变化: ¥0.004 → $0.003 (约 ¥0.022)
上下文变化: 128K → 200K
━━━━━━━━━━━━━━━━━━━━
确认切换？(Y/n):
```

### 4.2 跳过确认

使用 `--yes` 或 `-y` 参数跳过确认：

```
/model claude-sonnet-4 --yes
/model claude-sonnet-4 -y
```

### 4.3 禁用确认提示

在配置中禁用确认提示：

```json
{
  "commands": {
    "model": {
      "confirm_switch": false
    }
  }
}
```

---

## 高级功能

### 5.1 模型预设

创建常用的模型组合预设：

```json
{
  "commands": {
    "model": {
      "presets": {
        "coding": {
          "primary": "bailian/qwen-coder-plus",
          "description": "编程模式：使用代码专用模型",
          "system_prompt_append": "你是一个专业的编程助手"
        },
        "writing": {
          "primary": "openrouter/anthropic/claude-sonnet-4",
          "description": "写作模式：使用擅长写作的模型",
          "system_prompt_append": "你是一个专业的写作助手"
        },
        "fast": {
          "primary": "bailian/qwen-turbo",
          "description": "快速模式：使用低延迟模型"
        }
      }
    }
  }
}
```

使用预设：

```
/model preset coding
/model preset writing
```

### 5.2 自动模型选择

根据任务类型自动选择模型：

```json
{
  "commands": {
    "model": {
      "auto_select": {
        "enabled": true,
        "rules": [
          {
            "trigger": "code|编程|函数|bug",
            "model": "bailian/qwen-coder-plus"
          },
          {
            "trigger": "翻译|translate",
            "model": "openrouter/anthropic/claude-sonnet-4"
          },
          {
            "trigger": "总结|summary|长文本",
            "model": "vertex/gemini-2.5-pro"
          }
        ]
      }
    }
  }
}
```

### 5.3 会话历史

查看当前会话的模型切换历史：

```
/model history
```

输出：

```
📜 模型切换历史
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
时间        操作        模型
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
14:30:15   初始        qwen-plus
14:35:22   切换        claude-sonnet-4
14:42:08   切换        qwen-plus
14:50:33   行内切换    gemini-2.5-pro
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 5.4 重置为默认

将模型重置为配置文件中的默认模型：

```
/model default
```

---

## 完整配置

编辑 `~/.openclaw/config.json`：

```json
{
  "commands": {
    "model": {
      "enabled": true,
      "confirm_switch": true,
      "show_cost_change": true,
      "show_context_change": true,
      "session_only": true,
      "aliases": {
        "qwen": "bailian/qwen-plus",
        "coder": "bailian/qwen-coder-plus",
        "claude": "openrouter/anthropic/claude-sonnet-4",
        "gemini": "vertex/gemini-2.5-pro",
        "fast": "bailian/qwen-turbo",
        "smart": "openrouter/anthropic/claude-sonnet-4"
      },
      "shortcuts": {
        "m1": "bailian/qwen-plus",
        "m2": "openrouter/anthropic/claude-sonnet-4",
        "m3": "vertex/gemini-2.5-pro"
      },
      "presets": {
        "coding": {
          "primary": "bailian/qwen-coder-plus",
          "description": "编程模式"
        },
        "writing": {
          "primary": "openrouter/anthropic/claude-sonnet-4",
          "description": "写作模式"
        }
      },
      "auto_select": {
        "enabled": false
      }
    }
  }
}
```

| 选项 | 说明 | 默认值 |
|------|------|--------|
| `enabled` | 是否启用 /model 命令 | `true` |
| `confirm_switch` | 切换时是否需要确认 | `true` |
| `show_cost_change` | 显示费用变化 | `true` |
| `show_context_change` | 显示上下文长度变化 | `true` |
| `session_only` | 切换仅影响当前会话 | `true` |
| `aliases` | 模型别名映射 | `{}` |
| `shortcuts` | 快捷键映射 | `{}` |
| `presets` | 模型预设 | `{}` |
| `auto_select.enabled` | 是否启用自动选择 | `false` |

---

## 使用场景

### 6.1 编程任务切换

```
用户: 帮我写一个排序算法
/model coder
AI: 好的，我来用代码专用模型帮你写一个排序算法...
```

### 6.2 长文本处理

```
用户: 帮我总结这篇文章（粘贴长文本）
/model gemini
AI: 好的，我来用支持长上下文的模型为你总结...
```

### 6.3 成本优化

```
用户: 简单翻译一下这句话
/model fast
AI: 好的，翻译如下...
```

### 6.4 对比测试

```
/model qwen
用户: 解释量子计算
AI: （qwen 的回答）

/model claude
用户: 解释量子计算
AI: （claude 的回答）
```

---

## 常见问题

### Q: 切换后模型不生效？

**排查步骤**：
1. 确认模型名称正确：`/model list`
2. 检查模型状态：`/model list --detail`
3. 确认 Provider 正常：`openclaw status`

### Q: 某些模型无法切换？

**可能原因**：
- API 密钥无效或过期
- Provider 服务不可用
- 模型已被禁用

**解决方案**：
```bash
# 测试 Provider 连接
openclaw provider test <provider-id>

# 检查 API 密钥
openclaw secret test <secret-name>
```

### Q: 如何设置默认模型？

编辑配置文件：

```json
{
  "models": {
    "providers": [
      {
        "providerId": "bailian",
        "models": [
          {
            "id": "qwen-plus",
            "primary": true
          }
        ]
      }
    ]
  }
}
```

或使用命令：

```
/model set-default claude-sonnet-4
```

### Q: 行内切换的格式是什么？

```
/model:模型名称 你的消息内容
```

或

```
@模型别名 你的消息内容
```

### Q: 切换会影响其他会话吗？

**默认不会**。`session_only` 默认为 `true`，切换仅影响当前会话。

如需全局切换，在配置中设置：

```json
{
  "commands": {
    "model": {
      "session_only": false
    }
  }
}
```

---

## 最佳实践

1. **使用别名**：为常用模型设置简短别名
2. **创建预设**：为不同任务类型创建预设
3. **对比测试**：使用不同模型处理同一任务，找到最合适的
4. **成本意识**：简单任务使用快速模型，复杂任务使用高质量模型
5. **及时重置**：完成特定任务后重置为默认模型

---

## 相关链接

- [模型选择指南](../configuration/model-comparison.md)
- [/btw 旁白命令](btw-command.md)
- [Provider 路由优化](../configuration/provider-routing.md)
- [成本优化指南](../configuration/cost-optimization.md)

---

**上一页**：[/btw 旁白命令](btw-command.md) | **下一页**：[技能开发指南](skills.md)

<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->
