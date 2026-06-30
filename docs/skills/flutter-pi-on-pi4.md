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

## Display resolution / EDID override (1024x600 panel)

Resolves the ADR 0002 open issue (scaled/blurry output). **Reapply this after any OS reimage of the Main Unit Pi** — it is an OS/boot-level fix, not part of the app.

**Symptom.** The console and the flutter-pi app render soft/blurry, as if upscaled.

**Root cause (confirmed on the test panel).** The panel ships a spoofed EDID that impersonates a *Lenovo L1950wD* monitor declaring **1920x1080 native**, with a malformed 1024x600 detailed timing (5-pixel horizontal front porch). The Raspberry Pi `vc4-kms-v3d` driver **rejects** that 1024x600 timing (`dmesg`: `User-defined mode not supported: "1024x600" ...`), falls back to 1080p, and the physical 1024x600 panel downscales it -> blur. A `video=` cmdline override **cannot** fix this: while the bad EDID is in charge, the kernel keeps matching the request to the rejected EDID timing. Note also that legacy `config.txt` `hdmi_*`/`hdmi_cvt` settings are **inert under full KMS** on Bookworm.

**Fix.** Override the EDID entirely (`drm.edid_firmware`) with a clean one that advertises **only** 1024x600, reusing the panel's native pixel clock (49.00 MHz), htotal (1312) and vtotal (622) — so the panel locks identically — but with a **legal 24-px front porch** that vc4 accepts. Because `vc4.ko` loads from the initramfs *before* the rootfs mounts, the EDID must be **baked into the initramfs** or it fails `ENOENT` at probe.

Assets are committed in `assets/flutter-pi-edid/`:
- `1024x600.bin` — the prebuilt EDID (just copy it; no regen needed).
- `make_edid.py` — regenerates `1024x600.bin` if the panel ever changes.
- `edid-hook` — the initramfs-tools hook that includes the EDID.

**Reapply procedure** (run on the Pi; connector is **HDMI-A-1** = the HDMI port nearest USB-C):

```bash
# 1. Install the EDID (copy 1024x600.bin from assets/flutter-pi-edid/ to the Pi first)
sudo mkdir -p /lib/firmware/edid
sudo cp 1024x600.bin /lib/firmware/edid/1024x600.bin

# 2. Bake it into the initramfs (vc4 loads before rootfs -> must be in initramfs)
sudo cp edid-hook /etc/initramfs-tools/hooks/edid
sudo chmod +x /etc/initramfs-tools/hooks/edid
sudo update-initramfs -u -k all
sudo lsinitramfs /boot/firmware/initramfs8 | grep edid   # expect usr/lib/firmware/edid/1024x600.bin

# 3. Point the kernel at it (single-line file; back it up first)
sudo cp /boot/firmware/cmdline.txt /boot/firmware/cmdline.txt.bak
#    remove any prior 'video=HDMI-A-1:...' token, then append:
sudo sed -i 's#$# drm.edid_firmware=HDMI-A-1:edid/1024x600.bin#' /boot/firmware/cmdline.txt

# 4. Reboot
sudo systemctl reboot
```

**Verify** after reboot:

```bash
cat /sys/class/graphics/fb0/virtual_size          # expect: 1024,600
cat /sys/class/drm/card*-HDMI-A-1/modes           # expect: 1024x600 (only)
sudo dmesg | grep -i "not supported"              # expect: no 1024x600 rejection
```

The active CRTC mode should read `"1024x600": 60 49000 1024 1048 1184 1312 600 603 609 622` — native 49 MHz clock, 1:1 mapping, no scaling. Then a full-screen flutter-pi app renders sharp at native resolution.

> Note: `initramfs8` is the Pi 4 (arm64, `*-v8` kernel) image; `initramfs_2712` is Pi 5. `update-initramfs -u -k all` regenerates both. If the Main Unit ever moves to a different panel, regenerate `1024x600.bin` from that panel's true native timing with `make_edid.py` (see ADR 0002 on the Pi-5 boundary).

## Quality Gate

- App is built with `flutterpi_tool` in release mode against a matching engine; versions are pinned.
- App runs full-screen on the device and starts at boot independently of services.
- Base URL points at loopback; service-unavailable is handled (see the UI pack).
- The ADR 0002 spike result is recorded before feature work proceeds.
