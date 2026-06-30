# Skill: Dart REST Client from OpenAPI (+ Push Channel)

## Purpose

Guide agents to consume the Main Unit services API from the UI: a typed Dart REST client generated from the services daemon's OpenAPI document, plus the WebSocket/SSE push channel for live data.

## Use This Skill When

- Generating or regenerating the REST client from the services OpenAPI.
- Implementing a `data`-layer repository that calls the services API.
- Wiring the live-push channel into the app.

## Do Not Use This Skill When

- The task is services-side API design (that is `/services`).
- The task is pure presentation/state (see the bloc and UI packs).

## Contract Rules

- The services daemon's **OpenAPI document is the source of truth** for the REST contract. Generate the Dart client from it (e.g. via an OpenAPI generator); do not hand-write request/response models that the contract already defines.
- Treat the generated client as a `data`-layer detail. Wrap it behind `domain` repository abstractions and map DTOs to entities at the boundary - generated types must not leak into `domain` or `presentation`.
- Regenerate the client when the services contract changes; never edit generated files by hand.
- Pin the generator and the contract version so client regeneration is reproducible.

## Connectivity Rules

- The services API is reachable on the **loopback interface only**. Make the base URL configurable (build/run config), defaulting to loopback.
- Loopback transport is plain HTTP by design (see ADR 0001); do not add certificate/TLS handling for the local link.
- Handle the daemon being unavailable gracefully: the UI can start before/without services and must show a clear "service unavailable" state, retrying rather than crashing.

## Push Channel Rules

- Use the daemon's WebSocket or SSE endpoint for the limited live-push cases. A community `signalr_netcore` client is permitted only if the daemon exposes a SignalR hub; prefer the plain WebSocket/SSE path on this single-client loopback link.
- Expose the push stream through a `domain` abstraction; map incoming payloads to entities in `data`.
- Reconnect with backoff; on reconnect, re-fetch authoritative state over REST rather than assuming the stream filled gaps.
- Cancel subscriptions when the consuming bloc/cubit closes.

## Quality Gate

- The REST client is generated from the services OpenAPI and lives in `data`; generated types do not appear in `domain`/`presentation`.
- The base URL is configurable and defaults to loopback; no TLS handling for the local link.
- Daemon-unavailable and push-reconnect paths are handled and surfaced as states.
- Contract/generator versions are pinned and regeneration is reproducible.
