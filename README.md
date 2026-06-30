# Greenhouse Main Unit UI

Dart/Flutter operator interface for the Greenhouse Main Unit, rendered on-device via [`flutter-pi`](https://github.com/ardera/flutter-pi) on a touchscreen.

Before working in this repository, read the central documentation entry point:

- [Greenhouse Documentation README](https://github.com/thedrewdz/Greenhouse-Documentation/blob/main/README.md)

All durable project documentation lives in the dedicated Greenhouse Documentation repository. Local documentation here under `docs/` is supplemental and implementation-focused; when guidance overlaps, the documentation repository is canonical.

## Architecture

This repository implements the UI side of the Main Unit, per the canonical ADRs in the documentation repository:

- **Independent processes** - the UI runs as a separate process from the services daemon and is optional; the device operates headless without it (`adr/0001-main-unit-ui-services-separation.md`).
- **Pure API client** - the UI talks to the services daemon over the loopback interface only: REST (request/response) plus a WebSocket/SSE push channel. Its REST client is generated from the daemon's OpenAPI document. No business logic, MQTT, or persistence lives here.
- **Flutter via flutter-pi** - rendered on-device with no browser/compositor, targeting a Raspberry Pi 4 (`adr/0002-main-unit-flutter-flutter-pi-ui.md`).

## Design Principles

- CLEAN architecture (`presentation` → `domain` → `data`, dependency rule inward) with SOLID applied to Dart.
- State management with **bloc/cubit** (`flutter_bloc`) - not `provider` or `riverpod`.
- Constructor injection; any locator confined to the composition root.

See `docs/skills/` for the implementation skill packs.

## Develop, Verify, Deploy

```bash
flutter pub get
dart format .
dart analyze
flutter test
```

- **Develop/debug** against a standard target (desktop/emulator), where the Dart MCP server's runtime tools (hot reload, widget inspector) apply.
- **Deploy** to the device with `flutterpi_tool` in release mode (see `docs/skills/flutter-pi-on-pi4.md`).
- **Validate on-device** per the ADR 0002 spike - separate from the standard `flutter run` device model.

## Agent Setup

This repository is configured for agentic assistants:

- Claude / Claude Code: `CLAUDE.md`
- OpenAI Codex: `AGENTS.md`
- GitHub Copilot: `.github/copilot-instructions.md`
- Dart MCP server (Claude Code): `.mcp.json`
- Local supplemental skill packs: `docs/skills/`
- Local ADR index: `docs/adr/README.md`
- Session continuity: `agent-handoff.md`
