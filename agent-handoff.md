# Agent Handoff

This file is for local, time-bound session state only.

Durable policy, canonical context, architecture, MQTT contracts, ADRs, and skill guidance live in the Greenhouse Documentation repository:

- https://github.com/thedrewdz/Greenhouse-Documentation/blob/main/README.md

## Current Workspace State

- Repository purpose: Greenhouse Main Unit UI (Dart/Flutter via flutter-pi).
- Status: repository scaffolded for agentic assistants (AGENTS.md, CLAUDE.md, skill packs, ADR index, Dart MCP config). No application code yet.

## Current Progress Snapshot

- Agent setup created. The Flutter app and project structure have not been generated.

## Open Questions

- None recorded.

## Next Actions

- Per ADR 0002's validation spike, build a minimal Flutter app and run it on the Raspberry Pi 4 via flutter-pi in release mode: full-screen render on the touchscreen, one REST call, and one push message from a stub services daemon.
- Establish the CLEAN project structure (`presentation`/`domain`/`data`) following `docs/skills/dart-clean-architecture-solid.md`, with bloc/cubit state and the generated OpenAPI client once the services daemon publishes its contract.

## Resume Prompt

```text
Read AGENTS.md, agent-handoff.md, and the Greenhouse Documentation README, then continue Main Unit UI work. Honor canonical ADRs 0001 and 0002, CLEAN architecture with SOLID, and bloc/cubit for state. The UI is a pure client of the services API over loopback.
```
