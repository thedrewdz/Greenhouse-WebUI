# CLAUDE

This file is the Claude / Claude Code entry point for the Greenhouse Main Unit **UI** repository.

## First Action

Before taking any other action in this repository, read the central documentation entry point:

- https://github.com/thedrewdz/Greenhouse-Documentation/blob/main/README.md

The Greenhouse Documentation repository is canonical for durable documentation, platform context, architecture, MQTT contracts, ADRs, and skill guidance. This repository is a consumer of that documentation. Treat it as authoritative whenever guidance overlaps.

## Canonical Policy

@AGENTS.md

AGENTS.md is the canonical, cross-agent policy for this repository. Its governing architecture, design principles, scope boundaries, instruction precedence, tooling notes, and quality gates apply fully to Claude and Claude Code.

## What This Repository Is

This repository is the Main Unit **UI** - a Dart/Flutter operator interface rendered on-device via `flutter-pi`.

It is not the Main Unit services (`/services`) and not the ESP32 edge firmware (`/edge`). Claude Code may write and edit UI code, tests, and local supplemental docs here. The UI is a pure client of the services API; it must not contain business logic, MQTT, or persistence.

## Governing ADRs

- `adr/0001-main-unit-ui-services-separation.md` - independent processes; the UI consumes the services API over loopback REST + WebSocket/SSE, generated against the daemon's OpenAPI; the UI is optional.
- `adr/0002-main-unit-flutter-flutter-pi-ui.md` - Flutter via flutter-pi on a Raspberry Pi 4; status pending a hardware spike; Pi 5 unsupported by flutter-pi.

Read these before structural work. They are canonical and override local guidance.

## Design Principles (Required)

- CLEAN architecture, dependency rule inward: `presentation` (widgets + blocs/cubits) → `domain` (entities, use cases, repository abstractions) → `data` (repo impls, generated REST client, push transport).
- SOLID applied to Dart: small abstractions, single responsibility, dependency inversion via constructor injection.
- **State management is bloc/cubit** (`flutter_bloc`). Do not use `provider` or `riverpod` for state.
- Prefer constructor injection; confine any locator (`get_it`) to the composition root.

See `docs/skills/dart-clean-architecture-solid.md` and `docs/skills/flutter-bloc-state-management.md`.

## Incremental Loading and Partial Disclosure

**Do not read all documentation or all skill packs up front.** Load only what the task needs:

1. Read the documentation repository README first; load only the canonical docs the task needs.
2. In this repository, load only the matching local skill packs in `docs/skills/` (see below).
3. Load canonical and local ADRs only for the area you touch.

## Instruction Precedence

1. `AGENTS.md` (canonical cross-agent policy)
2. `CLAUDE.md` (this file - Claude-specific operational guidance; never overrides AGENTS.md)
3. Greenhouse Documentation repository instructions, ADRs, and docs (canonical)
4. `docs/skills/*.md` (local skill packs - supplemental only)
5. `docs/adr/README.md` (local ADR index; canonical ADRs still win)
6. `agent-handoff.md` (session scratchpad only - never durable guidance)

## Tooling: Dart MCP Server

The Dart MCP server is configured in `.mcp.json` (`dart mcp-server`). Approve it when prompted (`/mcp`), and prefer its tools for analysis, fixes, formatting, tests, and pub work:

- Use `analyze_files`, `dart_fix`, `dart_format`, `run_tests`, `pub`, `pub_dev_search`, `lsp` freely.
- Runtime tools (`launch_app`, `hot_reload`, `widget_inspector`, DTD/VM) target **standard Flutter devices** - use them against a desktop/emulator dev target.
- **flutter-pi is not a standard Flutter device:** the MCP runtime tools do not drive the Pi deployment. On-device validation (the ADR 0002 spike) is separate and manual/scripted.
- Prerequisite: Dart SDK >= 3.9.0-dev; the server is experimental.

## Local Skill Packs

Local, implementation-focused skill packs live under `docs/skills/`. They are supplemental to the canonical skills in the documentation repository. Read `docs/skills/README.md` to select one, and load only the matching pack.

Available skill packs:

- `docs/skills/flutter-pi-on-pi4.md` - flutter-pi embedder, release/AOT build via `flutterpi_tool`, KMS/DRM target, kiosk/boot, the Pi-5 boundary and Sony-embedder fallback.
- `docs/skills/dart-clean-architecture-solid.md` - CLEAN layers and SOLID applied to Dart; the dependency rule and boundaries.
- `docs/skills/flutter-bloc-state-management.md` - bloc/cubit state (chosen over provider/riverpod); wiring blocs to use cases; testing with bloc_test.
- `docs/skills/dart-rest-client-from-openapi.md` - generating and consuming the typed Dart client from the services OpenAPI, plus the WebSocket/SSE push channel.
- `docs/skills/flutter-touchscreen-ui.md` - touch-first design for the fixed on-device display; explicit idle/validating/connecting/failed/complete states.
- `docs/skills/flutter-dart-testing-strategy.md` - unit, bloc, widget, and golden tests; verification via the Dart MCP server.

If a documentation, knowledge, or skill gap is identified, do not make things up - bring it to the user's attention to be addressed properly, per AGENTS.md.

## Local ADRs

`docs/adr/README.md` is the local ADR index and loading rules. The cross-cutting architecture is governed by the canonical ADRs in the documentation repository. Read the index first and load only relevant ADRs.

## Handoff File

`agent-handoff.md` is for local, time-bound session state only. Do not treat it as durable guidance or duplicate canonical policy there.

## Repository Tool Bridges

| Tool | File |
|---|---|
| Claude / Claude Code | `CLAUDE.md` (this file) |
| OpenAI Codex | `AGENTS.md` |
| GitHub Copilot | `.github/copilot-instructions.md` |
| Dart MCP server | `.mcp.json` (Claude Code); other clients run `dart mcp-server` |

All bridges point to `AGENTS.md` as the canonical source of policy, and to the Greenhouse Documentation repository as the canonical source of project documentation.
