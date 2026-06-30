# Skill: Flutter on flutter-pi (Raspberry Pi 4)

## Purpose

Guide agents to build, deploy, and troubleshoot the Main Unit UI on the device using the `flutter-pi` embedder, which renders directly to KMS/DRM + GLES with no X11/Wayland and no browser.

This implements ADR 0002 in the documentation repository. Read it for the decision and its pending validation spike.

## Use This Skill When

- Building or deploying the app to the device.
- Configuring boot/kiosk startup on the device.
- Troubleshooting rendering, input, or build issues specific to flutter-pi.

## Do Not Use This Skill When

- Developing/debugging on a workstation - use a standard Flutter target (desktop/emulator), where hot reload, the widget inspector, and the Dart MCP runtime tools apply. flutter-pi is for the on-device deployment.

## Target and Toolchain Rules

- Target hardware is the **Raspberry Pi 4** (8 GB), which is on flutter-pi's documented support list. flutter-pi requires working 3D acceleration with KMS/DRM.
- Build and deploy with **`flutterpi_tool`** (`flutter pub global activate flutterpi_tool`). Ship in **release/AOT** mode for the appliance; debug bundles are for bring-up only.
- Pin the Flutter SDK, the flutter-pi engine, and `flutterpi_tool` versions together; a release app needs an engine built for the matching runtime mode.

## Boundary and Fallback Rules

- **flutter-pi is not a standard Flutter device.** The Dart MCP runtime/device tools and `flutter run` device workflows do not drive the Pi deployment; on-device runs are launched via flutter-pi directly.
- **Raspberry Pi 5 is not on flutter-pi's documented support list.** Moving to a Pi 5 (for performance or price) requires re-validating the embedder and may supersede ADR 0002.
- Documented fallback embedder if flutter-pi proves insufficient: **Sony `flutter-embedded-linux`**. Treat any newer official embedded-Flutter support as upside, not a dependency.

## On-Device Rules

- Run full-screen; configure the app to start at boot as the `greenhouse-ui` process unit (it is optional and independent of the services daemon).
- The touchscreen is the primary input; account for the small input-latency characteristic of flutter-pi's polling when designing interactions.
- Point the app at the services API on loopback (see `dart-rest-client-from-openapi.md`).

## Validation Spike (ADR 0002)

Before building UI features, validate on the Pi 4 in release mode: full-screen GPU/KMS render on the touchscreen, one REST call, and one push message from a stub services daemon. Optionally repeat on the Pi 3B to observe headroom. ADR 0002 stays *pending* until this passes.

## Quality Gate

- App is built with `flutterpi_tool` in release mode against a matching engine; versions are pinned.
- App runs full-screen on the device and starts at boot independently of services.
- Base URL points at loopback; service-unavailable is handled (see the UI pack).
- The ADR 0002 spike result is recorded before feature work proceeds.
