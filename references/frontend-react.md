# Frontend / React Review Rules

Use this reference when changed files include React, frontend routing, browser APIs, CSS, state management, or UI tests.

## Correctness

- Check whether async effects can update state after unmount or after a newer request has completed.
- Check whether derived state can become stale when props, route params, filters, or permissions change.
- Check whether controlled inputs preserve IME composition, cursor position, and empty values.
- Check whether event listeners, timers, observers, and subscriptions are cleaned up.
- Check whether optimistic UI handles rollback and duplicate submissions.

## User Experience

- Verify loading, empty, error, disabled, permission-denied, and long-content states.
- Check small viewport, high zoom, long localized text, and keyboard-only use when UI changes are visible.
- Prefer concrete user-facing breakage over broad design opinions.

## Security

- Treat `dangerouslySetInnerHTML`, URL construction, markdown rendering, file previews, and iframe usage as high-risk.
- Check whether user-controlled links use safe protocols and avoid open redirects.
- Do not log tokens, cookies, authorization headers, imported documents, or PII in browser logs.

## Testing Signals

- UI state machines and async flows usually need component or integration tests.
- Changes to shared components should consider at least one caller-specific regression path.
