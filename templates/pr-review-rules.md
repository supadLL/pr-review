# Project PR Review Rules

Copy this file into a repository as `.codex/pr-review.md`, then customize it for the team or project.

The PR review skill works without this file. When present, these rules are loaded as project-specific policy on top of the general review checklist.

## Critical Paths

- `src/auth/**`: affects authentication and authorization; require tests for allowed and denied access.
- `src/payments/**`: affects money movement; require idempotency, retry, and failure-mode checks.
- `.github/workflows/**`: affects CI/release; check permissions, secrets, artifacts, and runner OS.
- `electron/main.ts`: affects desktop startup and IPC security; check path handling and renderer isolation.

## Required Checks

- Changes under `src/**` require:
  - `npm run build`
  - `npm test` or a targeted test command
- Changes under `package.json` or lockfiles require:
  - dependency consistency review
  - engine/version compatibility review
- Changes under release or packaging config require:
  - package command verification or a documented reason for skipping

## Security Rules

- Do not log full tokens, cookies, authorization headers, user documents, or PII.
- New IPC/API endpoints must validate runtime payload shape.
- User-controlled file paths must be restricted to allowed directories.
- New dependencies must be checked for deprecation, engine requirements, and install scripts.

## Release Rules

- Release artifacts must match the upload glob patterns.
- Version, changelog, and artifact names must remain consistent.
- Secrets should only be available to trusted branch/tag workflows.

## Ownership Notes

- Add module owners or reviewers here if the team has ownership boundaries.
