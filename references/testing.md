# Testing Review Rules

Use this reference when evaluating test coverage or deciding which checks to run.

## What Good Coverage Means

- Changed success paths are covered.
- At least one realistic failure path is covered for risky code.
- Cross-module behavior is tested at the integration level when unit tests cannot catch the regression.
- Packaging and CI changes are verified with the relevant build/package command when practical.

## Test Gap Severity

- High: missing tests for auth, payment, data migration, destructive actions, release automation, or common user-facing breakage.
- Medium: missing tests for platform-specific behavior, parsing/validation, async race paths, or important package scripts.
- Low: missing tests for low-risk docs, comments, or isolated display changes.

## Check Selection

- Prefer repository-defined scripts over guessed commands.
- If checks are expensive, run targeted checks first and explain what was skipped.
- A failing check is a finding only when tied to the reviewed change or when it blocks basic project validation.
