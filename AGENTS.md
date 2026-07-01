# AGENTS

## Purpose

This repository contains the Greenhouse **Main Unit UI** - the operator touchscreen interface, built in Dart/Flutter and rendered on-device via `flutter-pi`.

This is not the Main Unit services repository (`/services`) and not the ESP32 Edge Unit firmware repository (`/edge`).

This file is the canonical, cross-agent policy for this repository.

## First Action

Before taking any other action in this repository, read the central documentation entry point:

- https://github.com/thedrewdz/Greenhouse-Documentation/blob/main/README.md

The Greenhouse Documentation repository is the source of truth for durable documentation, terminology, architecture, MQTT contracts, ADRs, journeys, and skills. Do not recreate that material here. If this file conflicts with the documentation repository, follow the documentation repository and update this file to remove the conflict.

## Governing Architecture

This repository implements the UI side of two canonical ADRs in the documentation repository. Read them before structural work:

- `adr/0001-main-unit-ui-services-separation.md` - UI and services are **independent processes**. The UI consumes the services API over the **loopback interface only** (REST + a WebSocket/SSE push channel) and is generated against the services daemon's **OpenAPI** document. The UI is optional: the device runs headless without it.
- `adr/0002-main-unit-flutter-flutter-pi-ui.md` - the UI is **Flutter, rendered via `flutter-pi`** (KMS/DRM + GLES, no X11/Wayland, no browser). Target hardware is a Raspberry Pi 4; status is *pending a hardware-validation spike*. Pi 5 is not on flutter-pi's supported list.

Non-negotiables from those ADRs:

- The UI holds no logic that belongs to services. It knows only the API base URL and the push endpoint, and talks to them over loopback.
- No business rules, MQTT, or persistence live here; those belong to `/services`.

## Design Principles (Required)

- **CLEAN architecture** with the dependency rule pointing inward: `presentation` (widgets + blocs/cubits) → `domain` (entities, use cases, repository abstractions) → `data` (repository implementations, the generated REST client, push transport). Inner layers never depend on outer ones.
- **SOLID, applied to Dart**: small focused abstractions (abstract classes/interfaces), single responsibility per class, dependency inversion via constructor injection against abstractions.
- **State management: bloc/cubit.** Use `flutter_bloc` (cubit for simple state, bloc for event-driven flows). Do **not** use the `provider` package or `riverpod` for state. (`BlocProvider` from `flutter_bloc` for supplying blocs to the widget tree is expected and is not the same thing.)
- **Dependency injection**: use `injectable` + `get_it`. Annotate classes with `@injectable`, `@singleton`, or `@lazySingleton`; run `dart run build_runner build` to regenerate `app/di.config.dart`. Never call `get_it`'s service locator (`sl<T>()`) from `domain` code, repositories, or blocs — only from the composition root (`app/di.dart`) and `BlocProvider` widget-tree wiring.

## Scope Boundaries

- Use this repository only for UI code, tests, and local operational assets the app needs.
- Do not add services/firmware code or local copies of durable documentation.
- Keep the app a pure client of the services API; do not reach around it to MQTT or storage.

## Instruction Precedence

1. AGENTS.md (this file)
2. Greenhouse Documentation repository instructions, ADRs, and docs (canonical)
3. `docs/skills/*.md` (local skill packs - supplemental only)
4. `docs/adr/README.md` (local ADR index; canonical ADRs still win)
5. `agent-handoff.md` (session scratchpad only - never durable guidance)

If guidance conflicts, follow the highest-precedence source.

## Incremental Loading and Partial Disclosure

Do not read all documentation or all skill packs up front.

1. Read the documentation repository README first; from it, load only the canonical docs the task needs.
2. In this repository, load only the matching local skill packs in `docs/skills/` (see `docs/skills/README.md`).
3. Load canonical and local ADRs only for the area you are touching.

## Tooling

- The **Dart MCP server** (`dart mcp-server`) is configured for Claude Code in `.mcp.json`; other MCP clients (e.g. Codex) point at the same command. It provides analysis, fixes, formatting, tests, and pub tooling, plus runtime tools for **standard Flutter targets**.
- flutter-pi is a custom embedder and is **not** a standard Flutter device: the MCP runtime/device tools do not drive the Pi deployment. Use them against a desktop/emulator dev target while developing; validate on the Pi via flutter-pi separately (the ADR 0002 spike).
- Verification is tool-neutral: run `dart analyze` and `dart test` (directly, or via the Dart MCP server's `analyze_files`/`run_tests` if configured).

## Quality Gates

Before finalizing changes, verify:

1. The dependency rule holds: `domain` depends on nothing outward; `data` and `presentation` depend on `domain` abstractions.
2. State is managed with bloc/cubit; no `provider`/`riverpod` state usage; no business logic inside widgets.
3. The REST client is the generated OpenAPI client in the `data` layer; the UI never hardcodes payloads that should come from the contract.
4. No services/MQTT/persistence logic leaks into the UI.
5. `dart analyze` is clean and `dart format` applied.
6. New behavior has tests at the right layer (unit/bloc/widget), including loading/error/offline states.

## Session Closeout (Definition of Done)

1. Confirm changes stay within Main Unit UI scope.
2. Re-check canonical docs/ADRs for conflicts.
3. Run: `dart format .`, `dart analyze`, `dart test` (or the MCP equivalents).
4. Confirm tests for changed behavior exist and pass.
5. Update `agent-handoff.md` with factual current-session state.
6. Propose durable guidance changes in the documentation repository, not here.

## Handoff

`agent-handoff.md` is for local, time-bound session state only. Do not treat it as durable guidance or duplicate canonical policy there.
