<!-- This file is part of OpenClaw Guide for Beginners. Licensed under the MIT License. See LICENSE file for details. -->

# Telegram 富文本投递配置

> 配置 OpenClaw 在 Telegram 中发送富 HTML 消息、保留 Markdown 格式及进度渲染

---

## 📋 概述

OpenClaw v2.1.0 增强了 Telegram 消息投递能力，支持三种消息渲染模式：

| 模式 | 说明 | 适用场景 |
|------|------|----------|
| **富 HTML 发送** | 使用 Telegram 原生 HTML 格式 | 正式回复、文档输出 |
| **Markdown 保留** | 保持源文本的 Markdown 格式 | 技术问答、代码分享 |
| **进度渲染** | 实时更新消息内容 | 长任务执行、流式输出 |

---

## 🎨 富 HTML 发送

### 配置方法

在 `openclaw.json` 中添加 Telegram 投递配置：

```json
{
  "channels": {
    "telegram": {
      "enabled": true,
      "botToken": "YOUR_BOT_TOKEN",
      "delivery": {
        "mode": "html",
        "html": {
          "parseMode": "HTML",
          "disableWebPagePreview": false,
          "preserveCodeBlocks": true,
          "maxMessageLength": 4096
        }
      }
    }
  }
}
```

### HTML 支持的标签

Telegram 支持以下 HTML 标签：

| 标签 | 用途 | 示例 |
|------|------|------|
| `<b>`, `<strong>` | 加粗 | `<b>重要提示</b>` |
| `<i>`, `<em>` | 斜体 | `<i>注意事项</i>` |
| `<code>` | 行内代码 | `<code>openclaw -v</code>` |
| `<pre>` | 代码块 | `<pre>代码内容</pre>` |
| `<a href="">` | 链接 | `<a href="https://openclaw.ai">官网</a>` |
| `<pre><code class="language-python">` | 语法高亮代码块 | 带语言标注的代码块 |

### 使用示例

```bash
# 测试富 HTML 消息发送
openclaw test-telegram --format html --content "<b>标题</b>\n<i>正文内容</i>"

# 发送带代码块的消息
openclaw test-telegram --format html --content '<pre><code class="language-python">print("Hello OpenClaw")</code></pre>'
```

---

## 📝 Markdown 保留

### 配置方法

```json
{
  "channels": {
    "telegram": {
      "enabled": true,
      "botToken": "YOUR_BOT_TOKEN",
      "delivery": {
        "mode": "markdown",
        "markdown": {
          "parseMode": "MarkdownV2",
          "preserveFormatting": true,
          "escapeSpecialChars": true,
          "fallbackToPlainText": true
        }
      }
    }
  }
}
```

### MarkdownV2 特殊字符转义

以下字符在 MarkdownV2 中需要转义：

```
_ * [ ] ( ) ~ ` > # + - = | { } . !
```

OpenClaw 自动处理转义，无需手动操作。

### 使用示例

```bash
# 测试 Markdown 模式
openclaw test-telegram --format markdown --content "**加粗** _斜体_ \`代码\`"

# 测试代码块
openclaw test-telegram --format markdown --content '```python
def hello():
    print("Hello from OpenClaw")
```'
```

---

## ⏳ 进度渲染

### 配置方法

```json
{
  "channels": {
    "telegram": {
      "enabled": true,
      "botToken": "YOUR_BOT_TOKEN",
      "delivery": {
        "mode": "progress",
        "progress": {
          "enabled": true,
          "updateInterval": 1000,
          "showProgressBar": true,
          "showPercentage": true,
          "showElapsedTime": true,
          "streamingChunkSize": 100,
          "maxUpdates": 100
        }
      }
    }
  }
}
```

### 进度渲染效果

```
🔄 正在处理... [████████░░░░░░░░] 50%
⏱ 已用时: 3.2s | 剩余: ~3s
📄 当前步骤: 生成回复内容
```

### 使用示例

```bash
# 启用流式输出
openclaw chat "写一篇关于AI的短文" --stream --telegram-progress

# 自定义进度更新间隔
openclaw chat "分析这段代码" --stream --progress-interval 2000
```

---

## 🔧 完整配置示例

```json
{
  "channels": {
    "telegram": {
      "enabled": true,
      "botToken": "${TELEGRAM_BOT_TOKEN}",
      "allowedUsers": ["your_telegram_user_id"],
      "delivery": {
        "mode": "auto",
        "auto": {
          "useHtmlForLongContent": true,
          "useProgressForStreaming": true,
          "thresholdLength": 2000
        },
        "html": {
          "parseMode": "HTML",
          "disableWebPagePreview": true
        },
        "markdown": {
          "parseMode": "MarkdownV2",
          "preserveFormatting": true
        },
        "progress": {
          "enabled": true,
          "updateInterval": 1500,
          "showProgressBar": true
        }
      }
    }
  }
}
```

---

## ⚠️ 注意事项

1. **消息长度限制**：Telegram 单条消息最大 4096 字符，超长内容自动分段发送
2. **HTML 与 Markdown 互斥**：同一消息只能使用一种解析模式
3. **进度更新频率**：更新间隔不宜低于 500ms，否则可能触发 Telegram API 限流
4. **特殊字符**：MarkdownV2 模式下，特殊字符需转义（OpenClaw 自动处理）

---

## 🔍 故障排查

### 消息发送失败

```
错误: Telegram API error 400: Bad Request: can't parse entities
```

**原因**：消息中包含未转义的特殊字符或不支持的 HTML 标签。

**解决**：
```bash
# 检查消息格式
openclaw test-telegram --validate "你的消息内容"

# 切换到纯文本模式
openclaw config set channels.telegram.delivery.mode plain
```

### 进度消息不更新

```
错误: Telegram API error 429: Too Many Requests
```

**原因**：进度更新过于频繁，触发 API 限流。

**解决**：
```bash
# 增大更新间隔
openclaw config set channels.telegram.delivery.progress.updateInterval 2000

# 减少最大更新次数
openclaw config set channels.telegram.delivery.progress.maxUpdates 50
```

### 代码块显示异常

**原因**：MarkdownV2 模式下代码块中的特殊字符未正确转义。

**解决**：
```bash
# 切换到 HTML 模式处理代码内容
openclaw config set channels.telegram.delivery.mode html
```

---

最后更新：2026-06-27
