# Claude Code 使用指南

本文档介绍 Claude Code 中已配置的 Agents、Skills 和 Hooks 的功能及使用方式。

## 📋 目录

- [🤖 Agents（代理）](#-agents代理)
- [🛠️ Skills（技能）](#-skills技能)
- [🔗 Hooks（钩子）](#-hooks钩子)
- [🎯 使用示例](#-使用示例)
- [💡 最佳实践](#-最佳实践)

---

## 🤖 Agents（代理）

Agents 是专业的深度分析工具，需要手动调用，用于复杂的任务和专业分析。

### 1. **ai-slop-review.md** - AI 内容审查代理
- **功能**：对生成的内容进行质量和安全审查
- **适用场景**：检查 AI 输出的准确性、偏见、安全性
- **特色**：专门针对 AI 生成内容的质量评估

### 2. **code-review.md** - 代码审查代理  
- **功能**：专业代码审查和安全检查
- **适用场景**：
  - 代码质量评估
  - 安全漏洞检测
  - 性能优化建议
  - 最佳实践检查
- **特色**：支持多种编程语言，自动化代码分析

### 3. **doc-review.md** - 文档审查代理
- **功能**：文档质量和内容审查
- **适用场景**：
  - 技术文档审查
  - 用户手册检查
  - 文档一致性验证
  - 清晰度评估
- **特色**：专注于技术文档的专业审查

### 4. **web-researcher.md** - 网络研究代理
- **功能**：深度网络信息搜集和研究
- **适用场景**：
  - 主题研究
  - 竞争分析
  - 市场调研
  - 技术趋势分析
- **特色**：能够进行系统性的信息收集和分析

---

## 🛠️ Skills（技能）

Skills 是自动触发的工具集，当你描述相关任务时会自动激活。

### 文档处理类
- **pdf** - 全功能 PDF 处理
  - 文本/表格提取
  - PDF 合并/分割
  - 页面旋转
  - 水印添加
  - 表单填写
  - 加密/解密
  - 图片提取
  - OCR 扫描（将扫描件转为可搜索文本）

- **pptx** - PowerPoint 处理
  - 演示文稿创建和编辑
  - 幻灯片操作
  - 格式设置

- **docx** - Word 文档处理
  - 文档创建和编辑
  - 格式化操作
  - 样式管理

### 开发工具类
- **context7** - 智能上下文管理
  - 代码依赖分析
  - 文件关联发现
  - 上下文智能推荐

- **ast-grep** - 结构化代码搜索
  - AST 分析
  - 模式匹配搜索
  - 代码重构建议

- **grep-app** - 增强文本搜索
  - 多文件搜索
  - 正则表达式支持
  - 搜索结果处理

### 系统工具类
- **pueue** - 后台任务管理
  - 任务队列管理
  - 并行任务执行
  - 任务监控

- **just** - 命令任务自动化
  - 任务自动化
  - 依赖管理
  - 命令组合

- **tmux** - 终端复用
  - 会话管理
  - 窗口操作
  - 分屏管理

### AI 增强类
- **jina-ai** - AI 视觉处理
  - 图像识别
  - 视觉分析

- **glm-vision** - 多模态 AI
  - 图像理解
  - 跨模态处理

- **explanatory** - 解释生成
  - 复杂概念解释
  - 教学内容生成

### 网络与搜索类
- **web-researcher** - 网络研究（也作为 agent）
- **duckduckgo** - 搜索集成
- **zhihu-post** - 知乎内容处理
- **bilibili-api** - B 站 API 集成

### 特殊功能类
- **cache-hygiene** - 缓存管理
- **preflight-check** - 预检查
- **anti-defensive** - 反安全检测
- **shader-dev** - 着色器开发
- **openscad** - 3D 建模
- **chrome-cdp** - Chrome 浏览器自动化

---

## 🔗 Hooks（钩子）

Hooks 是自动执行的安全和质量检查，在工具使用前后触发。

### PreToolUse（执行前检查）

**安全类钩子：**
- `no-head-read.sh` - 阻止 `head -n1` 文件读取
- `no-heredoc.sh` - 阻止危险的 heredoc 用法
- `no-cat-write.sh` - 阻止 `cat > file.txt` 写入
- `no-background-ampersand.sh` - 阻止 `&` 后台任务
- `no-git-amend.sh` - 阻止 `git amend` 修改历史
- `no-sed-print.sh` - 限制 `sed` 的打印操作
- `no-devnull-redirect.sh` - 限制 `/dev/null` 重定向
- `no-pip-npm.sh` - 确保 Python 包管理器使用正确

**质量类钩子：**
- `python-unbuffered.sh` - 确保 Python 后台任务使用无缓冲输出
- `prefer-uv-run.sh` - 优先使用 `uv run` 执行 Python
- `explore-model-sonnet.sh` - 探索代理使用 Sonnet 模型
- `no-worktree-team.sh` - 阻止工作树相关的团队操作
- `no-schedule-wakeup-deadzone.sh` - 优化任务调度

### PostToolUse（执行后验证）

- `reread-after-edit.sh` - 编辑后重新读取文件
- `show-image-on-read.sh` - 读取图片时显示
- `pep723-script.sh` - PEP 723 脚本标准检查
- `websearch-followup-hint.sh` - 网络搜索后提示
- `cache-keepalive-hint.sh` - 缓存保持活跃提示
- `verify-explore-results.sh` - 验证探索结果
- `python-unbuffered-post.sh` - Python 无缓冲后处理

### 共享库
- `bypass.sh` - 允许绕过特定检查
- `emit.sh` - 统一消息输出
- `check-python-unbuffered.sh` - Python 缓冲检查逻辑
- `read_input.sh` - 输入读取工具

---

## 🎯 使用示例

### Skills 使用方式（自动触发）

#### 例子 1：处理 PDF 文件
```
用户：帮我提取这个 PDF 中的表格数据
Claude：[自动检测到 PDF 任务，激活 pdf skill]
我来帮你提取 PDF 中的表格数据。请提供 PDF 文件路径。
```

**实际使用：**
```
用户：请读取 D:\reports\sales.pdf 并提取所有表格数据
Claude：
[激活 pdf skill]
使用 pdf skill 处理文件...
✅ 成功提取到 3 个表格：
1. Q1 销售报表 - 包含产品、销售额、增长率
2. Q2 销售报表 - 包含产品、销售额、增长率  
3. 客户分类表 - 包含客户等级、数量、占比
```

#### 例子 2：处理 Word 文档
```
用户：帮我创建一个项目计划书.docx，包含项目背景、目标、时间安排
Claude：[自动检测到 docx 任务，激活 docx skill]
我来帮你创建项目计划书。使用 docx skill 生成文档...
```

#### 例子 3：后台任务管理
```
用户：帮我同时运行多个测试任务，并监控进度
Claude：[激活 pueue skill]
使用 pueue skill 管理后台任务...
📋 任务队列已创建：
1. 运行单元测试
2. 运行集成测试  
3. 运行性能测试
```

### Agents 使用方式（手动调用）

#### 例子 1：代码审查代理
```
用户：请用 code-review agent 审查这个 PR
Claude：[调用 code-review agent]
🔍 启动 code-review agent 进行专业代码审查...
```

**Agent 会执行：**
1. 分析代码变更
2. 检查安全漏洞
3. 评估代码质量
4. 提供改进建议

**输出示例：**
```
📋 Code Review Report

✅ 通过项目：
- 命名规范符合团队标准
- 函数职责单一

⚠️ 需要注意：
- 第 45 行：未处理的异常
- 第 78 行：潜在的 N+1 查询问题

💡 改进建议：
1. 添加 try-catch 块
2. 考虑使用批量查询
```

#### 例子 2：网络研究代理
```
用户：请用 web-researcher agent 调研 React 18 的新特性
Claude：[调用 web-researcher agent]
🌐 启动 web-researcher agent 进行深度调研...
```

**Agent 会执行：**
1. 搜集 React 18 相关信息
2. 整理文档和示例
3. 分析技术影响
4. 总结最佳实践

**输出示例：**
```
📊 React 18 新特性调研报告

## 主要特性
1. 并发特性（Concurrent Features）
   - 自动批处理
   - 暂停/恢复功能
   - 选择性子树更新

2. 新 Hooks
   - useId
   - useDeferredValue
   - useTransition

## 实际应用建议
- 大列表渲染使用 useDeferredValue
- 频繁更新使用 useTransition
```

### 使用对比

#### Without Skills/Agents（传统方式）
```
用户：帮我压缩这个 PDF
Claude：
你需要安装 Python 和相关库...
pip install PyPDF2
然后编写脚本...
# 手动写代码处理
```

#### With Skills/Agents（增强方式）
```
用户：帮我压缩这个 PDF
Claude：[自动激活 pdf skill]
使用 pdf skill 压缩 PDF...
✅ 完成！文件大小从 10MB 减少到 3MB
```

#### 特殊技能使用

**1. context7 技能（上下文管理）**
```
用户：这个函数依赖哪些其他模块？
Claude：[激活 context7 skill]
使用 context7 分析代码依赖...
🔗 发现依赖：
- utils.js (核心工具函数)
- config.js (配置管理)
- logger.js (日志记录)
```

**2. ast-grep 技能（代码搜索）**
```
用户：找出所有使用 console.log 的地方
Claude：[激活 ast-grep skill]
使用 ast-grep 进行结构化搜索...
📝 找到 12 处 console.log 使用：
- src/app.js:23
- src/utils.js:45
- src/api.js:67
```

---

## 💡 最佳实践

### Skills 使用建议：
1. **自然语言描述** - 直接说你要做什么，skill 会自动处理
2. **无需关心技术细节** - 如 Python 路径、库安装等
3. **专注业务逻辑** - 让 skill 处理技术实现

### Agents 使用建议：
1. **明确指定** - 使用 "请用 XX agent" 的格式
2. **专业任务** - 适合需要深度分析的任务
3. **等待完整报告** - agents 通常会提供详细的分析结果

### Hooks 特点：
- **自动执行** - 无需手动干预
- **安全保障** - 防止危险操作
- **质量保证** - 确保输出质量
- **可绕过** - 特定情况下可以使用注释绕过检查

---

## 📝 总结

配置完成后，Claude Code 已从基础的代码助手升级为智能开发伙伴：

- **Skills** 让复杂任务变得简单，只需描述需求
- **Agents** 提供专业深度分析，如代码审查、市场调研
- **Hooks** 自动确保安全性和代码质量

这些配置将大幅提升开发效率，让你更专注于业务逻辑而非技术实现细节。