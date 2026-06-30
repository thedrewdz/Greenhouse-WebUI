# Copilot Instructions

## Canonical Agent Policy

Use `AGENTS.md` at the repository root as the canonical source of long-lived agent instructions.

Before taking any other action in this repository, read the central documentation entry point:

- https://github.com/thedrewdz/Greenhouse-Documentation/blob/main/README.md

## Repository Focus

This repository is the Greenhouse Main Unit **UI** - a Dart/Flutter operator interface rendered on-device via `flutter-pi`.

It is not the Main Unit services (`/services`) and not the ESP32 edge firmware (`/edge`). The UI is a pure client of the services API (loopback REST + WebSocket/SSE, generated from OpenAPI); do not add business logic, MQTT, or persistence here. Follow CLEAN architecture and SOLID, and manage state with bloc/cubit (`flutter_bloc`) - not `provider` or `riverpod`. See canonical ADRs 0001 and 0002 in the documentation repository.

## Required References

Read and follow:

- `AGENTS.md`

Use the dedicated Greenhouse Documentation repository for durable project documentation, canonical context, architecture, MQTT contracts, ADRs, and skill guidance.
