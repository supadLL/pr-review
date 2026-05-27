# PR Review Skill

一个本地优先、非 Agent 化的 PR / 代码审查 Skill。

它不依赖 PR-Agent、远端 PR URL、GitHub/GitLab Token 或独立服务，而是让 Codex/AI 直接读取本地 Git 仓库的 diff、提交记录、项目配置、CI 信息和相关源码上下文，按 PR 审查流程生成中文审查报告。适合个人提交前自查、小团队代码评审，也可以作为企业本地化代码审查流程的基础框架。

## 核心能力

- **本地 PR 风格审查**：支持 staged、unstaged、指定 range、当前分支相对 upstream、最后一次提交等审查目标。
- **默认中文报告**：每次审查后默认在被审查仓库根目录生成 `review.md`，内容包含审查目标、整体风险、问题发现、检查结果、审查范围和规则来源。
- **跨平台上下文采集**：Windows 使用 PowerShell 脚本，macOS/Linux 使用 Bash 脚本。
- **项目类型识别**：采集脚本会识别 Node、React、Electron、TypeScript、Vite、Python、Go、Rust、GitHub Actions 等项目特征。
- **建议检查命令**：根据项目脚本自动提示 `npm run build`、`npm run lint`、`npm run electron:pack`、`pytest`、`go test ./...`、`cargo test` 等检查项。
- **通用企业级审查清单**：覆盖正确性、安全、权限、数据、测试、CI/CD、打包发布、可观测性和性能风险。
- **技术栈专项规则**：内置 React/前端、Node/TypeScript、Electron、CI/Release、安全、测试充分性等专项规则。
- **企业规则增强**：如果目标仓库存在 `.codex/pr-review.md` 等项目规则文件，会自动加载作为增强规则；没有规则文件也能正常运行，退回通用审查。
- **规则信任模型**：如果规则文件本身在本次 diff 中被修改，会降低信任级别，避免通过修改规则绕过审查。
- **跨平台 CI 验证**：仓库自带 GitHub Actions，在 Ubuntu 验证 Bash 采集脚本，在 Windows 验证 PowerShell 采集脚本。

## 工作方式

当你要求 Codex 做 PR 审查或代码审查时，Skill 会指导 AI 按以下流程执行：

1. 判断审查目标：staged、unstaged、指定 range、upstream diff 或最后一次提交。
2. 运行当前系统对应的上下文采集脚本，收集 git 状态、diff、变更文件、项目类型、建议检查命令、CI 文件和项目规则。
3. 根据项目类型和变更文件加载必要的专项规则。
4. 阅读变更文件、相关调用点、测试、配置和构建脚本。
5. 在合理范围内运行本地检查命令。
6. 输出 findings-first 的审查结论。
7. 生成 `review.md` 审查报告。

## 安装

将本仓库放入 Codex skills 目录，或将其映射到 Codex 可发现的 skills 目录中。目录结构应保留为：

```text
pr-review/
  SKILL.md
  README.md
  references/
  scripts/
  templates/
```

## 使用示例

在 Codex 中直接提出类似请求：

```text
对这个项目做一次 PR 审查
```

```text
做一次代码审查，检查当前分支相对 origin/main 的改动
```

```text
审查 staged changes，并生成 review.md
```

```text
对 D:\work\my-project 做一次企业级代码审查
```

## 单独运行上下文采集脚本

这些脚本只读，不会修改被审查仓库。

Windows：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\collect-review-context.ps1 -RepoPath . -LastCommit
```

Windows 指定 range：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\collect-review-context.ps1 -RepoPath . -Range origin/main...HEAD
```

macOS/Linux：

```bash
bash ./scripts/collect-review-context.sh --repo-path . --last-commit
```

macOS/Linux 指定 range：

```bash
bash ./scripts/collect-review-context.sh --repo-path . --range origin/main...HEAD
```

## 企业/项目规则

企业规则不是必需的。没有企业规则文件时，本 Skill 会继续使用通用审查清单和技术栈规则。

如果团队希望加入自己的审查标准，可以复制：

```text
templates/pr-review-rules.md
```

到目标项目：

```text
.codex/pr-review.md
```

然后补充项目自己的规则，例如：

- 高危模块路径
- 必须执行的检查命令
- 安全红线
- 发布包要求
- 模块 owner
- 兼容性要求
- 数据迁移规范

Skill 会自动查找这些规则文件：

```text
.codex/pr-review.md
.codex/code-review.md
.codex/review-rules.md
CODE_REVIEW.md
REVIEWING.md
docs/code-review-rules.md
docs/pr-review.md
CONTRIBUTING.md
.github/copilot-instructions.md
```

## 报告格式

默认生成中文 `review.md`，包含：

- 生成时间
- 审查目标
- 整体风险
- 问题发现
- 待确认问题
- 检查结果
- 审查范围
- 规则来源

每个问题会尽量包含：

- 严重级别
- 文件和行号
- 触发场景
- 实际影响
- 修复建议或验证方式

## 文件说明

- `SKILL.md`：Skill 主流程、触发说明、输出格式和审查策略。
- `references/enterprise-checklist.md`：通用企业级审查清单。
- `references/frontend-react.md`：React / 前端审查规则。
- `references/node-typescript.md`：Node / TypeScript 审查规则。
- `references/electron.md`：Electron 与桌面打包审查规则。
- `references/ci-release.md`：CI / Release 审查规则。
- `references/security.md`：安全审查规则。
- `references/testing.md`：测试充分性审查规则。
- `templates/pr-review-rules.md`：企业/项目规则模板。
- `scripts/collect-review-context.ps1`：Windows 只读上下文采集脚本。
- `scripts/collect-review-context.sh`：macOS/Linux 只读上下文采集脚本。
- `.github/workflows/verify.yml`：跨平台脚本验证 workflow。

## 设计取向

这个项目不是 PR-Agent 这样的完整平台，也不会连接远端 PR 系统或自动发布评论。它更像一个可分发的本地审查流程框架：让 AI 读取 Skill 后，用一致的方法审查本地代码变更，并生成可查阅的报告。
