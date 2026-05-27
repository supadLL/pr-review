# PR Review Skill

本地优先、非 Agent 化的 PR / 代码审查 Skill。

它不依赖 PR-Agent、远端 PR URL 或 GitHub/GitLab Token，而是让 AI 直接读取本地 Git 仓库的 diff、提交记录、项目配置与相关上下文，按 PR 审查流程输出高质量 review。支持 staged、unstaged、分支对比、指定 range、最后一次提交等审查模式；内置通用企业级审查清单，覆盖正确性、安全、权限、测试、CI/CD、打包发布、性能与可维护性等风险点。

同时支持自动发现项目/企业自定义规则文件：有规则就增强审查，没有规则就退回通用审查。适合个人提交前自查、小团队代码评审，也可作为企业代码审查流程的本地化基础框架。

## Usage

将本目录放入 Codex skills 目录后，可以直接向 Codex 提出类似请求：

```text
对这个项目做一次 PR 审查
```

```text
做一次代码审查，检查当前分支相对 origin/main 的改动
```

也可以单独运行上下文采集脚本。

Windows：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\collect-review-context.ps1 -RepoPath . -LastCommit
```

macOS/Linux：

```bash
bash ./scripts/collect-review-context.sh --repo-path . --last-commit
```

## Files

- `SKILL.md`: skill 主流程与触发说明
- `references/enterprise-checklist.md`: 企业级通用审查清单
- `scripts/collect-review-context.ps1`: Windows 只读上下文采集脚本
- `scripts/collect-review-context.sh`: macOS/Linux 只读上下文采集脚本
