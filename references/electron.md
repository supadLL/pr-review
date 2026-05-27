# Electron Review Rules

Use this reference when changed files include Electron main/preload processes, IPC, packaging, desktop integration, auto-update, icons, installers, or release artifacts.

## Security

- Renderer should not get direct Node access unless there is a clear and justified reason.
- `contextIsolation` should remain enabled, and `nodeIntegration` should remain disabled for remote/untrusted content.
- New IPC channels must validate payload shape, permissions, and file paths in the main process.
- Avoid exposing arbitrary filesystem, shell, URL opening, or credential access through preload APIs.

## Correctness

- Check development vs packaged paths separately. `process.cwd()`, `__dirname`, `app.getAppPath()`, `resourcesPath`, and `userData` behave differently.
- Check platform-specific branches for Windows/macOS/Linux path and asset differences.
- Ensure app startup does not depend on missing optional assets.

## Packaging And Release

- Verify icons and assets are included in final artifacts, not only in dev.
- Check `electron-builder` `files`, `extraResources`, `afterPack`, signing, notarization, installer targets, artifact names, and CI runner OS.
- For native tools or binaries, verify Node version, OS, architecture, and CI availability.
- For release workflows, check uploaded artifact patterns match actual artifact names.

## Testing Signals

- Packaging changes should run the relevant package command or clearly document why it was skipped.
- IPC changes should have validation tests or manual verification of malformed inputs.
