# Skill: Flutter/Dart Testing Strategy

## Purpose

Guide agents to verify Main Unit UI behavior through layered tests that match the CLEAN architecture: domain unit tests, bloc tests, widget tests, and golden tests.

## Use This Skill When

- Adding or changing use cases, blocs/cubits, repositories, or widgets.
- Closing coverage gaps or validating regressions before deployment.

## Do Not Use This Skill When

- The task is services (`/services`) or firmware (`/edge`).

## Test Layers

### 1) Domain Unit Tests (fast, pure Dart)

- Test use cases and entities with no Flutter and no transport.
- Use fakes/mocks for repository abstractions.
- Cover success, failure, and empty/boundary cases.

### 2) Bloc/Cubit Tests

- Use `bloc_test` with fake use cases to assert emitted state sequences.
- Cover loading, success, failure, and offline/service-unavailable paths.
- No real network or services daemon.

### 3) Widget Tests

- Verify widgets render the right state and dispatch the right actions.
- Pump widgets with test blocs/fakes; assert loading/error/complete UI and that disabled-while-in-flight behavior holds.

### 4) Golden Tests (selective)

- Use goldens for key fixed-resolution touchscreen layouts where visual regressions matter. Keep the set small and deterministic.

## Data-Layer Tests

- Test repository implementations against a mocked HTTP client / generated client and assert DTO-to-entity mapping.
- Do not hit the real loopback API in unit/widget tests.

## Verification

- Run `dart format .`, `dart analyze`, and `flutter test` - directly or via the Dart MCP server (`dart_format`, `analyze_files`, `run_tests`).
- Analysis must be clean before changes are considered done.

## Quality Gate

- New behavior has tests at the right layer; negative and offline paths are covered.
- Bloc tests exist for every bloc/cubit with state logic.
- `dart analyze` is clean and formatting is applied.
- Golden tests, where used, are deterministic and scoped to meaningful layouts.
