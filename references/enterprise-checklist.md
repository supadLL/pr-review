# Enterprise PR Review Checklist

Use this checklist when a change affects production behavior, security, data, CI/CD, packaging, infrastructure, or any user-visible workflow. Do not mechanically report every unchecked item; use it to guide investigation and only surface concrete findings.

## Correctness

- Does the changed path handle empty, null, malformed, duplicate, and out-of-order inputs?
- Are failure paths explicit and observable?
- Are retries, cancellation, and timeouts handled safely?
- Could changed defaults break existing users or old clients?
- Does the code preserve invariants across all modified call sites?

## Security And Privacy

- Are auth and authorization checks still applied at the boundary and at sensitive operations?
- Can user-controlled input reach HTML, SQL, shell, file paths, URLs, redirects, deserialization, or logs unsafely?
- Are secrets, tokens, credentials, private keys, cookies, or PII exposed in code, logs, errors, telemetry, or artifacts?
- Are tenant, organization, workspace, or project boundaries enforced?
- Does the dependency or CI change introduce supply-chain risk?

## Data And Migrations

- Is the migration backward and forward compatible during rolling deploys?
- Are default values safe for existing rows/documents?
- Can the migration be retried without corruption?
- Does rollback require a matching data rollback?
- Could locks, table scans, or large backfills affect production availability?

## API And Compatibility

- Are response schemas, status codes, error shapes, event names, and field semantics preserved?
- Are old clients and new servers compatible, and vice versa?
- Are feature flags, capability checks, and gradual rollout paths present when needed?
- Are external integrations, webhooks, and SDKs considered?

## Frontend

- Are loading, empty, error, disabled, and permission-denied states handled?
- Are async requests protected against stale updates and race conditions?
- Is user-controlled content escaped or sanitized?
- Does the change remain usable with keyboard navigation and screen readers when UI is touched?
- Could layout break on narrow screens, long text, localization, or high zoom?

## Build, Packaging, And CI/CD

- Are required assets included in production artifacts?
- Are generated files and lockfiles updated consistently?
- Do scripts use shell syntax and paths compatible with the runner OS?
- Are signing, notarization, icons, metadata, artifact names, and installer behavior preserved?
- Are CI permissions least-privilege and are secrets only available to trusted contexts?
- Can release jobs run from forks, tags, protected branches, or manual dispatch as intended?

## Testing

- Do tests cover changed success behavior and at least one realistic failure mode?
- Are integration or end-to-end tests needed for cross-module behavior?
- Are snapshots or golden files intentionally updated?
- Is a missing test itself worth reporting because the change is risky?

## Observability

- Will operators be able to diagnose failures from logs, metrics, traces, or error messages?
- Are logs useful without leaking sensitive data?
- Are alerts or dashboards affected by changed event names or labels?

## Performance And Scale

- Did the change add an N+1 query, unbounded loop, large synchronous operation, or repeated render?
- Are pagination, streaming, batching, and backpressure preserved?
- Are memory, disk, network, and CPU costs bounded for large inputs?

## Review Output Quality

For each finding, include:

- Concrete trigger.
- Concrete impact.
- File and line reference.
- Minimal suggested fix or validation.
- Confidence if context is incomplete.
