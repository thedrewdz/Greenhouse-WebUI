# Skill: Flutter Bloc/Cubit State Management

## Purpose

Guide agents to manage Main Unit UI state with `flutter_bloc` (bloc and cubit), keeping presentation logic out of widgets and wired to domain use cases.

This project standardizes on bloc/cubit. Do **not** use the `provider` package or `riverpod` for state management.

## Use This Skill When

- Adding or changing screen/component state.
- Wiring user actions to domain use cases.
- Testing presentation logic.

## Do Not Use This Skill When

- The task is pure layout/styling with no state (see `flutter-touchscreen-ui.md`).
- The task is services (`/services`) or firmware (`/edge`).

## Cubit vs Bloc

- **Cubit** for simple state: expose methods that call use cases and `emit` new states. Default choice for most screens.
- **Bloc** for event-driven flows with multiple inputs, debouncing, or an auditable event log: map events to states.

## State and Logic Rules

- Blocs/cubits depend on **domain use cases**, not on repositories, the REST client, or the push transport directly. Inject use cases via the constructor.
- Keep widgets dumb: they render state and dispatch events/calls. No business logic, no direct data access in widgets.
- Model states explicitly and immutably (e.g. sealed classes or `equatable`/`freezed`): represent `idle`/`loading`/`success`/`failure` rather than scattering booleans.
- Surface errors as states the UI can render; do not throw across the bloc boundary.
- Dispose resources: cancel subscriptions (including push-channel streams) in `close()`.

## Wiring

- Provide blocs with `BlocProvider`; scope them to the subtree that needs them. Use `BlocBuilder`/`BlocListener`/`BlocSelector` to consume.
- Keep one bloc/cubit responsible for one screen or cohesive component (SRP).

## Testing

- Use `bloc_test` with fake/mock use cases to assert emitted state sequences for success, failure, and offline paths.
- Tests must not require a real services daemon or network.

## Quality Gate

- No `provider`/`riverpod` state usage anywhere.
- Blocs/cubits depend only on injected use cases; no data-layer types in presentation.
- States are immutable and model loading/error explicitly.
- Subscriptions are cancelled in `close()`.
- Each bloc/cubit has `bloc_test` coverage including negative paths.
