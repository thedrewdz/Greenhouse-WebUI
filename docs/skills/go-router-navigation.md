# Skill: GoRouter Navigation and Route Guards

## Purpose

Guide agents to implement navigation in the Main Unit UI using `go_router`, with
redirect-based route guards that enforce setup completion and connectivity state.

## Use This Skill When

- Adding a new route to the app.
- Implementing a route guard or conditional redirect.
- Navigating programmatically from a bloc/cubit or widget.

## Do Not Use This Skill When

- The task is services (`/services`) or firmware (`/edge`).
- The task is pure widget layout with no navigation.

## Router Location

The single `GoRouter` instance lives in `lib/app/router.dart`, created as a static field on
`AppRouter`. All route paths are constants on `AppRoutes`. Do not create additional routers.

## Route Guard Pattern

Guards live in the `redirect` callback on `GoRouter`. The callback returns `null` to allow
the current navigation, or a path string to redirect.

For guards that depend on runtime state (e.g. setup completion), use `refreshListenable`
with a `ChangeNotifier` (or `GoRouterRefreshStream` wrapping a `Stream`) so GoRouter
re-evaluates the redirect when state changes:

```dart
static final _setupNotifier = SetupStatusNotifier(); // ChangeNotifier

static final router = GoRouter(
  initialLocation: AppRoutes.dashboard,
  refreshListenable: _setupNotifier,
  redirect: _redirect,
  routes: [...],
);

static String? _redirect(BuildContext context, GoRouterState state) {
  final status = _setupNotifier.value; // synchronously available
  if (status == null) return null;     // still loading — allow through

  if (!status.setupComplete) {
    return status.isOnline
        ? AppRoutes.setupConfig
        : AppRoutes.setupNetwork;
  }
  // Already on a setup route but setup is complete — go to dashboard.
  if (state.matchedLocation.startsWith('/setup')) {
    return AppRoutes.dashboard;
  }
  return null;
}
```

Key rules:
- The `redirect` callback must be **synchronous**. Load state into a notifier first.
- Fetch setup status early (e.g. in `main()` after DI, or on app warm-up) and update
  the notifier. GoRouter will re-evaluate the guard automatically on each update.
- Return `null` (not the current path) when no redirect is needed.

## Programmatic Navigation

Navigate from widgets using `context.go(AppRoutes.dashboard)` (replaces stack) or
`context.push(AppRoutes.someRoute)` (pushes onto stack). Prefer `go` for top-level
flow transitions; use `push` only for true overlay/detail views.

Do not navigate from inside a bloc/cubit. Emit a navigation-intent state and let a
`BlocListener` in the widget tree call `context.go(...)`.

## Adding a Route

1. Add a path constant to `AppRoutes`.
2. Add a `GoRoute` to the `routes` list in `AppRouter.router`.
3. If the route requires a guard, update `_redirect`.
4. If the route needs parameters, use `:param` syntax and read via `GoRouterState.pathParameters`.

## Quality Gate

- All routes are declared in `AppRouter`; no `Navigator.push` calls exist outside it.
- `AppRoutes` has a constant for every declared path.
- Route guards are in `_redirect`; no guard logic lives in widgets.
- Navigation from blocs/cubits is done via emitted state + `BlocListener`, not `context.go` directly.
- `refreshListenable` is wired when guard outcome depends on async state.
