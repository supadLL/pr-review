# Node / TypeScript Review Rules

Use this reference when changed files include TypeScript, JavaScript, Node scripts, package manifests, build tools, or runtime API code.

## Type And Runtime Safety

- Check whether TypeScript types match runtime validation. Types do not protect untrusted JSON, IPC payloads, environment variables, files, or network responses.
- Watch for `as any`, broad `Record<string, unknown>` casts, unchecked optional values, and default values that hide invalid input.
- Check whether ESM/CJS interop is compatible with the configured Node version and bundler.

## Files, Paths, And Processes

- Treat shell execution, dynamic imports, file paths, and user-controlled filenames as high-risk.
- Check path traversal, platform separators, working directory assumptions, and missing parent directories.
- For scripts, verify they behave correctly on Windows and Unix-like shells if the project is cross-platform.

## Dependency And Package Changes

- Check `engines`, deprecated packages, postinstall scripts, native binaries, and supply-chain exposure.
- If `package.json` changes, verify `package-lock.json` is consistent.
- If scripts change, verify CI calls still match script names and required artifacts.

## Testing Signals

- New parsing, filesystem, process, or package behavior should have at least one failure-mode test or a documented manual verification.
