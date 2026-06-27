<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# Telegram 富文本渲染配置说明

> 配置 Telegram 消息的富文本渲染，支持表格、列表、引用块、代码块等格式

## 📋 前置要求

- 已完成 Telegram 机器人配置（参考 [Telegram 对接教程](telegram-integration.md)）
- OpenClaw v2.0.0 或更高版本

---

## 支持的格式

OpenClaw v2.0.0 在 Telegram 渲染方面新增了对以下富文本格式的原生支持：

| 格式 | 说明 | Telegram 支持方式 |
|------|------|------------------|
| 表格 | Markdown 表格自动转换 | `parse_mode: MarkdownV2` |
| 有序/无序列表 | 多级嵌套列表 | HTML `<ul>` / `<ol>` |
| 引用块 | `>` 开头的引用 | HTML `<blockquote>` |
| 代码块 | 围栏代码块 | HTML `<pre><code>` |
| 行内代码 | 反引号代码 | HTML `<code>` |
| 粗体/斜体 | 基础文本格式 | HTML `<b>` / `<i>` |

---

## 第一步：启用富文本渲染

### 1.1 使用配置向导

```bash
openclaw configure telegram

# 在高级选项中启用富文本
Enable rich text rendering? (Y/n): Y
Select parse mode: HTML (recommended)
```

### 1.2 手动配置

编辑 `~/.openclaw/config.json`：

```json
{
  "channels": {
    "telegram": {
      "enabled": true,
      "bot_token": "1234567890:***",
      "mode": "webhook",
      "rich_text": {
        "enabled": true,
        "parse_mode": "HTML",
        "fallback_mode": "MarkdownV2",
        "table_rendering": "pre_block",
        "max_message_length": 4096,
        "split_long_messages": true
      }
    }
  }
}
```

---

## 第二步：配置选项详解

### 2.1 parse_mode — 解析模式

选择 Telegram 消息的解析模式：

| 模式 | 说明 | 推荐度 |
|------|------|--------|
| `HTML` | 使用 HTML 标签渲染 | ⭐⭐⭐⭐⭐ 推荐 |
| `MarkdownV2` | 使用 Markdown 语法 | ⭐⭐⭐⭐ |
| `Markdown` | 旧版 Markdown（不推荐） | ⭐⭐ |

**推荐配置**：

```json
{
  "rich_text": {
    "parse_mode": "HTML",
    "fallback_mode": "MarkdownV2"
  }
}
```

> **说明**：`fallback_mode` 会在主模式渲染失败时自动降级，确保消息始终能发送。

### 2.2 table_rendering — 表格渲染方式

表格在 Telegram 中没有原生支持，OpenClaw 提供了多种渲染策略：

| 策略 | 效果 | 适用场景 |
|------|------|---------|
| `pre_block` | 用 `<pre>` 代码块渲染等宽表格 | **推荐**，对齐效果最好 |
| `text_table` | 纯文本表格，用空格对齐 | 简单表格 |
| `html_table` | 转为 HTML 表格（部分客户端支持） | 高级用户 |
| `disabled` | 不渲染表格，显示原始文本 | 不需要表格 |

```json
{
  "rich_text": {
    "table_rendering": "pre_block"
  }
}
```

**`pre_block` 渲染效果示例**：

```
┌─────────┬──────────┬────────┐
│ 模型     │ 价格/千次 │ 速度    │
├─────────┼──────────┼────────┤
│ GPT-4o  │ $2.50    │ 快     │
│ Claude  │ $3.00    │ 中     │
│ GLM-5.2 │ ¥0.50    │ 快     │
└─────────┴──────────┴────────┘
```

### 2.3 list_rendering — 列表渲染

```json
{
  "rich_text": {
    "list_rendering": {
      "unordered": "bullet",
      "ordered": "number",
      "max_depth": 3,
      "indent_size": 2
    }
  }
}
```

**无序列表效果**：

```
• 第一项
  ◦ 子项 A
  ◦ 子项 B
    ▪ 孙项
• 第二项
```

**有序列表效果**：

```
1. 第一步
   1.1 子步骤
   1.2 子步骤
2. 第二步
```

### 2.4 quote_rendering — 引用块渲染

```json
{
  "rich_text": {
    "quote_rendering": {
      "style": "blockquote",
      "prefix": "┃",
      "add_attribution": true
    }
  }
}
```

**引用块效果**：

```
┃ 这是一段引用文本。
┃ OpenClaw 会自动将 Markdown 引用
┃ 转换为 Telegram 支持的格式。
┃
┃ —— 来源：某篇文章
```

### 2.5 code_rendering — 代码块渲染

```json
{
  "rich_text": {
    "code_rendering": {
      "syntax_highlight": false,
      "show_language": true,
      "max_lines": 50,
      "line_numbers": false
    }
  }
}
```

**代码块效果**：

```python
# Python 示例
def hello():
    print("Hello from OpenClaw!")
```

> **注意**：Telegram 不支持语法高亮，代码块会以等宽字体显示。

---

## 第三步：高级配置

### 3.1 消息分割

当消息超过 Telegram 的 4096 字符限制时，自动分割：

```json
{
  "rich_text": {
    "split_long_messages": true,
    "split_strategy": "paragraph",
    "split_suffix": "\n\n📄 [续]",
    "split_prefix": "[续] "
  }
}
```

| 策略 | 说明 |
|------|------|
| `paragraph` | 按段落分割（推荐） |
| `sentence` | 按句子分割 |
| `line` | 按行分割 |
| `fixed` | 按固定字符数分割 |

### 3.2 格式转换映射

自定义 Markdown 到 Telegram 格式的映射规则：

```json
{
  "rich_text": {
    "format_mapping": {
      "heading_1": "bold",
      "heading_2": "bold",
      "heading_3": "bold_italic",
      "horizontal_rule": "---",
      "link": "html"
    }
  }
}
```

### 3.3 特殊字符转义

Telegram 的 MarkdownV2 模式需要转义特殊字符：

```json
{
  "rich_text": {
    "auto_escape": true,
    "escape_chars": "_*[]()~`>#+-=|{}.!"
  }
}
```

> **建议**：使用 `HTML` 模式可避免大部分转义问题，推荐优先使用。

---

## 完整配置示例

```json
{
  "channels": {
    "telegram": {
      "enabled": true,
      "bot_token": "1234567890:***",
      "mode": "webhook",
      "webhook_url": "https://你的域名/webhook/telegram",
      "rich_text": {
        "enabled": true,
        "parse_mode": "HTML",
        "fallback_mode": "MarkdownV2",
        "table_rendering": "pre_block",
        "list_rendering": {
          "unordered": "bullet",
          "ordered": "number",
          "max_depth": 3
        },
        "quote_rendering": {
          "style": "blockquote",
          "prefix": "┃"
        },
        "code_rendering": {
          "syntax_highlight": false,
          "show_language": true,
          "max_lines": 50
        },
        "split_long_messages": true,
        "split_strategy": "paragraph",
        "max_message_length": 4096,
        "auto_escape": true
      }
    }
  }
}
```

---

## 使用效果对比

### 开启前

```
**表格标题**
模型 | 价格
GPT-4o | $2.50
Claude | $3.00

> 这是引用文本
```

### 开启后

<b>表格标题</b>
<pre>
模型    | 价格
GPT-4o | $2.50
Claude | $3.00
</pre>

<blockquote>这是引用文本</blockquote>

---

## 常见问题排查

### Q: 表格显示错乱？

**可能原因**：等宽字体未正确加载

**解决方案**：
```json
{
  "rich_text": {
    "table_rendering": "pre_block",
    "use_monospace_font": true
  }
}
```

### Q: 特殊字符导致发送失败？

**解决方案**：切换到 HTML 模式，或启用自动转义

```json
{
  "rich_text": {
    "parse_mode": "HTML",
    "auto_escape": true
  }
}
```

### Q: 消息被截断？

**解决方案**：启用消息分割

```json
{
  "rich_text": {
    "split_long_messages": true,
    "split_strategy": "paragraph"
  }
}
```

### Q: 引用块不显示？

**可能原因**：Telegram Web 端对 `<blockquote>` 支持有限

**解决方案**：使用自定义前缀方式

```json
{
  "rich_text": {
    "quote_rendering": {
      "style": "prefix",
      "prefix": "┃ "
    }
  }
}
```

---

## 相关链接

- [Telegram 对接教程](telegram-integration.md)
- [Telegram Bot API - 格式化消息](https://core.telegram.org/bots/api#formatting-options)
- [OpenClaw 配置文档](../configuration/model-comparison.md)

---

**上一页**：[Telegram 对接教程](telegram-integration.md) | **下一页**：[微信对接教程](wechat-integration.md)

<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->
