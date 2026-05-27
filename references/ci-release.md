# CI / Release Review Rules

Use this reference when changed files include `.github/workflows`, CI scripts, release scripts, Dockerfiles, package metadata, deployment manifests, or artifact packaging.

## Workflow Safety

- Check event triggers, branch/tag filters, permissions, and whether secrets are available only in trusted contexts.
- Pull request workflows from forks should not receive write tokens or sensitive secrets unless intentionally isolated.
- Use least-privilege `permissions`.

## Runtime Compatibility

- Verify tool versions in CI match package `engines`, lockfile metadata, and script assumptions.
- Check shell syntax against the runner OS. Bash syntax on Windows or PowerShell syntax on Linux needs explicit shells.
- Check caches do not hide dependency or generated-file problems.

## Artifacts And Releases

- Ensure produced artifact names match upload/release glob patterns.
- Check whether missing artifacts fail the workflow when they should.
- Check signing, notarization, installer metadata, changelog, and versioning assumptions.
- Confirm matrix jobs build the intended platform on the intended runner.

## Required Review Questions

- Could this workflow run with elevated permissions on untrusted code?
- Could a release silently omit an artifact?
- Could a dependency engine or binary requirement fail only in CI?
- Could secrets appear in logs, artifacts, cache keys, or generated files?
