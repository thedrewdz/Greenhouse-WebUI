# Skill: Flutter Touchscreen UI

## Purpose

Guide agents to build appliance-style Main Unit screens for a fixed on-device touchscreen: touch-first, glanceable, and resilient to a services daemon that may be slow or absent.

## Use This Skill When

- Building or restyling screens/widgets for the device display.
- Designing input, validation, loading, and error/offline states.

## Do Not Use This Skill When

- The task is state logic (see `flutter-bloc-state-management.md`) or data access (see the OpenAPI pack).
- The task is services (`/services`) or firmware (`/edge`).

## Display and Touch Rules

- Design for the fixed touchscreen resolution and orientation of the device; lay out with that target in mind rather than assuming a resizable window or mouse.
- Use large, well-spaced touch targets; avoid hover-only affordances and tiny hit areas.
- Keep navigation shallow and obvious; this is an appliance, not a general-purpose browser.
- Assume no physical keyboard by default; provide on-screen input where text is required.

## Interaction State Rules

- Render explicit states for every async action: `idle`, `validating`, `connecting`, `failed`, `complete`. Drive them from the bloc/cubit state, not ad hoc widget flags.
- Disable primary actions while an operation is in flight; show progress.
- Provide clear retry paths for network and onboarding operations.
- Validate input before starting network or onboarding work; show actionable, bounded error messages (never raw exceptions).
- Show a clear, recoverable "service unavailable" state when the services daemon is unreachable (the UI may start before/without services).

## Separation Rules

- Widgets render state and dispatch actions only - no business logic, no direct data access.
- Keep Main Unit Setup flows and Edge Unit onboarding/reconfiguration flows visually and structurally separated, per canonical terminology.

## Quality Gate

- Layout works on the device's fixed touchscreen target; touch targets are adequate.
- Every async action has explicit loading/error/complete states sourced from bloc state.
- A service-unavailable state exists and is recoverable.
- No business logic or data access in widgets.
- Setup vs onboarding/reconfiguration flows remain distinct.
