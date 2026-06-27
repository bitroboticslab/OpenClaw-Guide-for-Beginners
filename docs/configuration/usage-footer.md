<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# 用量页脚功能配置

> 配置 /usage 命令和消息页脚，实时显示 Token 用量和成本信息

## 📋 前置要求

- OpenClaw v2.0.0 或更高版本
- 已完成 AI 模型配置（参考 [模型选择指南](model-comparison.md)）

---

## 功能说明

用量页脚功能会在每条 AI 回复的底部自动附加用量统计信息，包括：

- 📊 本次对话 Token 消耗
- 💰 累计费用估算
- 🤖 当前使用的模型
- ⏱️ 响应时间

---

## 第一步：使用 /usage 命令

### 1.1 查看当前用量

在对话中发送：

```
/usage
```

机器人会返回类似以下信息：

```
📊 用量统计
━━━━━━━━━━━━━━━━━━━━
🔹 本次对话: 1,234 tokens
🔹 输入: 856 tokens
🔹 输出: 378 tokens
🔹 累计用量: 45,678 tokens
🔹 预估费用: ¥0.23
🔹 当前模型: bailian/qwen-plus
━━━━━━━━━━━━━━━━━━━━
```

### 1.2 查看详细用量

```
/usage detail
```

返回更详细的用量信息：

```
📊 详细用量报告
━━━━━━━━━━━━━━━━━━━━━━━━
📅 日期: 2026-06-27
🤖 模型: bailian/qwen-plus

🔸 本次会话
  输入 tokens:  856
  输出 tokens:  378
  总计:         1,234 tokens
  费用:         ¥0.0062

🔸 今日累计
  会话数:       12
  总 tokens:    45,678
  总费用:       ¥0.23

🔸 本月累计
  总 tokens:    1,234,567
  总费用:       ¥6.17
━━━━━━━━━━━━━━━━━━━━━━━━
```

### 1.3 重置用量统计

```
/usage reset
```

> **注意**：重置操作不可撤销，请谨慎使用。

---

## 第二步：配置消息页脚

### 2.1 启用页脚

编辑 `~/.openclaw/config.json`：

```json
{
  "usage_footer": {
    "enabled": true,
    "position": "bottom",
    "style": "compact"
  }
}
```

### 2.2 页脚模板配置

使用模板自定义页脚显示内容：

```json
{
  "usage_footer": {
    "enabled": true,
    "template": "🤖 {model} | 📊 {tokens} tokens | 💰 {cost} | ⏱️ {time}",
    "templates": {
      "compact": "📊 {tokens}t | 💰 {cost}",
      "standard": "🤖 {model} | 📊 {tokens} tokens | 💰 {cost}",
      "detailed": "🤖 {model} | 📊 输入:{input_tokens}t 输出:{output_tokens}t | 💰 {cost} | ⏱️ {time}ms"
    }
  }
}
```

**可用模板变量**：

| 变量 | 说明 | 示例 |
|------|------|------|
| `{model}` | 当前模型名称 | `bailian/qwen-plus` |
| `{tokens}` | 总 Token 数 | `1,234` |
| `{input_tokens}` | 输入 Token 数 | `856` |
| `{output_tokens}` | 输出 Token 数 | `378` |
| `{cost}` | 费用估算 | `¥0.0062` |
| `{time}` | 响应时间（毫秒） | `1,234` |
| `{session_total}` | 会话累计 Token | `45,678` |
| `{daily_total}` | 今日累计 Token | `123,456` |

### 2.3 选择预设样式

```json
{
  "usage_footer": {
    "enabled": true,
    "style": "compact"
  }
}
```

| 样式 | 效果 |
|------|------|
| `compact` | `📊 1,234t \| 💰 ¥0.006` |
| `standard` | `🤖 qwen-plus \| 📊 1,234 tokens \| 💰 ¥0.006` |
| `detailed` | `🤖 qwen-plus \| 📊 输入:856t 输出:378t \| 💰 ¥0.006 \| ⏱️ 1,234ms` |
| `hidden` | 不显示页脚 |

---

## 第三步：格式控制

### 3.1 货币格式

```json
{
  "usage_footer": {
    "cost_format": {
      "currency": "CNY",
      "symbol": "¥",
      "decimal_places": 4,
      "free_threshold": 0.0001
    }
  }
}
```

| 选项 | 说明 | 默认值 |
|------|------|--------|
| `currency` | 货币类型 | `CNY` |
| `symbol` | 货币符号 | `¥` |
| `decimal_places` | 小数位数 | `4` |
| `free_threshold` | 低于此值显示"免费" | `0.0001` |

**效果**：
- 费用 > 0.0001：`💰 ¥0.0062`
- 费用 ≤ 0.0001：`💰 免费`

### 3.2 Token 格式

```json
{
  "usage_footer": {
    "token_format": {
      "use_k_suffix": true,
      "separator": ","
      "show_unit": true
    }
  }
}
```

**效果**：
- `use_k_suffix: true` → `1.2k tokens`
- `use_k_suffix: false` → `1,234 tokens`

### 3.3 时间格式

```json
{
  "usage_footer": {
    "time_format": {
      "unit": "ms",
      "show_unit": true,
      "humanize": true
    }
  }
}
```

**效果**：
- `humanize: false` → `1,234ms`
- `humanize: true` → `1.2s`

### 3.4 条件显示

仅在满足条件时显示页脚：

```json
{
  "usage_footer": {
    "show_conditions": {
      "min_tokens": 100,
      "show_on_short": false,
      "show_on_command": false,
      "show_on_error": false
    }
  }
}
```

| 条件 | 说明 | 默认值 |
|------|------|--------|
| `min_tokens` | 最少 Token 数才显示 | `0` |
| `show_on_short` | 短回复是否显示 | `false` |
| `show_on_command` | 命令回复是否显示 | `false` |
| `show_on_error` | 错误回复是否显示 | `false` |

---

## 第四步：多渠道配置

不同消息渠道可以使用不同的页脚配置：

```json
{
  "usage_footer": {
    "enabled": true,
    "style": "standard",
    "channel_overrides": {
      "telegram": {
        "style": "compact",
        "template": "📊 {tokens}t | 💰 {cost}"
      },
      "wechat": {
        "style": "detailed",
        "enabled": true
      },
      "dingtalk": {
        "enabled": false
      }
    }
  }
}
```

---

## 完整配置示例

```json
{
  "usage_footer": {
    "enabled": true,
    "position": "bottom",
    "style": "standard",
    "template": "🤖 {model} | 📊 {tokens} tokens | 💰 {cost}",
    "templates": {
      "compact": "📊 {tokens}t | 💰 {cost}",
      "standard": "🤖 {model} | 📊 {tokens} tokens | 💰 {cost}",
      "detailed": "🤖 {model} | 📊 输入:{input_tokens}t 输出:{output_tokens}t | 💰 {cost} | ⏱️ {time}ms"
    },
    "cost_format": {
      "currency": "CNY",
      "symbol": "¥",
      "decimal_places": 4
    },
    "token_format": {
      "use_k_suffix": false,
      "separator": ","
    },
    "time_format": {
      "unit": "ms",
      "humanize": true
    },
    "show_conditions": {
      "min_tokens": 100,
      "show_on_short": false
    },
    "channel_overrides": {
      "telegram": {
        "style": "compact"
      }
    }
  }
}
```

---

## 使用效果示例

### compact 样式

```
你好！我可以帮你完成各种任务。

有什么需要帮助的吗？

📊 1,234t | 💰 ¥0.0062
```

### standard 样式

```
你好！我可以帮你完成各种任务。

有什么需要帮助的吗？

🤖 bailian/qwen-plus | 📊 1,234 tokens | 💰 ¥0.0062
```

### detailed 样式

```
你好！我可以帮你完成各种任务。

有什么需要帮助的吗？

🤖 bailian/qwen-plus | 📊 输入:856t 输出:378t | 💰 ¥0.0062 | ⏱️ 1,234ms
```

---

## 常见问题排查

### Q: 页脚不显示？

**排查步骤**：
1. 确认 `usage_footer.enabled` 为 `true`
2. 检查 `show_conditions.min_tokens` 是否设置过高
3. 确认当前渠道未被禁用

### Q: 费用显示为 0？

**可能原因**：模型未配置价格信息

**解决方案**：在模型配置中添加价格

```json
{
  "models": {
    "providers": [
      {
        "providerId": "bailian",
        "models": [
          {
            "id": "qwen-plus",
            "pricing": {
              "input": 0.004,
              "output": 0.012,
              "unit": "per_1k_tokens"
            }
          }
        ]
      }
    ]
  }
}
```

### Q: 如何临时隐藏页脚？

在对话中发送：

```
/usage footer off
```

恢复显示：

```
/usage footer on
```

---

## 相关链接

- [模型选择指南](model-comparison.md)
- [API 配置教程](api-configuration.md)
- [成本优化指南](cost-optimization.md)

---

**上一页**：[模型选择指南](model-comparison.md) | **下一页**：[Provider 路由优化说明](provider-routing.md)

<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->
