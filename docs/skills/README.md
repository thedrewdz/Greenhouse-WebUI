# Local Skill Packs

This folder contains local, implementation-focused skill packs for the Greenhouse Main Unit **UI** repository.

These packs are tool-neutral: they work for both OpenAI Codex (via `AGENTS.md`) and Claude / Claude Code (via `CLAUDE.md`).

They are **supplemental**. Canonical skills, context, architecture, and contracts live in the Greenhouse Documentation repository:

- https://github.com/thedrewdz/Greenhouse-Documentation/blob/main/README.md

Review relevant canonical guidance first, then apply these repository-local packs for Main Unit UI specifics. Local packs must never override canonical policy, architecture, contracts, or terminology.

## Partial Disclosure

Load only the pack that matches the current task. Do not read all packs up front. Each pack states when to use it and when not to.

## Packs

| Pack | Use when |
|---|---|
| `dart-clean-architecture-solid.md` | Establishing project structure, adding features across layers, or reviewing boundaries. **Start here for structure.** |
| `flutter-bloc-state-management.md` | Adding or changing UI state, wiring blocs/cubits to use cases, or testing state logic. |
| `dart-rest-client-from-openapi.md` | Generating/consuming the services REST client, or wiring the WebSocket/SSE push channel. |
| `flutter-touchscreen-ui.md` | Building screens/widgets for the on-device touchscreen, or designing loading/error/offline states. |
| `flutter-pi-on-pi4.md` | Building, deploying, or troubleshooting the app on the device via flutter-pi. |
| `flutter-dart-testing-strategy.md` | Adding unit, bloc, widget, or golden tests for changed behavior. |

## Verification (Dart MCP Server)

Verification is tool-neutral. Run `dart analyze`, `dart format`, and `dart test`/`flutter test` directly, or use the Dart MCP server's `analyze_files`, `dart_format`, `dart_fix`, and `run_tests` tools (configured for Claude Code in `.mcp.json`). The MCP runtime/device tools apply to standard Flutter targets only - not flutter-pi.

## Gaps

If a documentation, knowledge, or skill gap is identified, do not make things up - bring it to the user's attention to be addressed properly, per `AGENTS.md`.
