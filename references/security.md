# Security Review Rules

Use this reference when changed code touches authentication, authorization, input parsing, network requests, file access, secrets, logs, dependencies, CI/CD, or user-generated content.

## High-Risk Patterns

- Secrets or credentials in code, config, tests, logs, docs, artifacts, or examples.
- User-controlled input reaching shell commands, SQL/NoSQL queries, path joins, redirects, HTML/markdown rendering, deserialization, or SSRF-capable URLs.
- Authorization checks moved from server/main process to client/renderer only.
- Tenant, workspace, organization, or project IDs accepted from users without server-side validation.

## Validation

- Validate untrusted JSON, IPC payloads, environment variables, uploaded files, query params, and webhook bodies at runtime.
- Prefer allowlists over denylists for protocol, host, file extension, and command choices.
- Check size limits, rate limits, timeouts, and cancellation for expensive operations.

## Dependency And Supply Chain

- Review new dependencies for deprecation, native binaries, postinstall hooks, license surprises, and engine requirements.
- Check CI permissions and release tokens when build/release scripts change.

## Reporting

- If a secret is found, report the exposure without repeating the full value.
- Distinguish exploitable vulnerabilities from hardening suggestions.
