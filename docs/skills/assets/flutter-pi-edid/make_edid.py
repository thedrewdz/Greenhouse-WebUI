#!/usr/bin/env python3
"""Generate a clean 1024x600 EDID 1.3 for the Greenhouse Main Unit touch panel.

Why this exists: the panel's stock EDID impersonates a Lenovo L1950wD (native
1920x1080) and grafts on a malformed 1024x600 detailed timing with a 5-pixel
horizontal front porch, which the Raspberry Pi vc4 HDMI driver rejects
("User-defined mode not supported"). vc4 then falls back to 1080p and the panel
downscales -> blur.

This EDID advertises ONLY 1024x600, reusing the panel's native pixel clock
(49.00 MHz), htotal (1312) and vtotal (622) so the panel locks identically, but
redistributes the blanking to a legal 24-px front porch so vc4 accepts it.
Sync polarity matches the panel's native H-/V+.

Usage:  python3 make_edid.py 1024x600.bin
See flutter-pi-on-pi4.md ("Display resolution / EDID override") for the full
install procedure. The prebuilt output is committed next to this script as
1024x600.bin; regenerate only if the panel changes.
"""
import sys

# --- Native-derived timing (49.00 MHz, htotal 1312, vtotal 622) -------------
PCLK_KHZ = 49000
HACT, HBLANK, HFRONT, HSYNC = 1024, 288, 24, 136   # hback = 288-24-136 = 128
VACT, VBLANK, VFRONT, VSYNC = 600, 22, 3, 6        # vback = 22-3-6   = 13
HMM, VMM = 154, 86                                  # ~7" 1024x600 panel
DTD_FLAGS = 0x1C  # digital separate sync, Vsync+, Hsync- (matches native)


def mfg_id(s):
    v = ((ord(s[0]) - 64) << 10) | ((ord(s[1]) - 64) << 5) | (ord(s[2]) - 64)
    return bytes([(v >> 8) & 0xFF, v & 0xFF])


def dtd():
    pc = PCLK_KHZ // 10  # pixel clock in 10 kHz units
    b = [0] * 18
    b[0] = pc & 0xFF
    b[1] = (pc >> 8) & 0xFF
    b[2] = HACT & 0xFF
    b[3] = HBLANK & 0xFF
    b[4] = ((HACT >> 8) << 4) | ((HBLANK >> 8) & 0xF)
    b[5] = VACT & 0xFF
    b[6] = VBLANK & 0xFF
    b[7] = ((VACT >> 8) << 4) | ((VBLANK >> 8) & 0xF)
    b[8] = HFRONT & 0xFF
    b[9] = HSYNC & 0xFF
    b[10] = ((VFRONT & 0xF) << 4) | (VSYNC & 0xF)
    b[11] = (((HFRONT >> 8) & 0x3) << 6) | (((HSYNC >> 8) & 0x3) << 4) \
        | (((VFRONT >> 4) & 0x3) << 2) | ((VSYNC >> 4) & 0x3)
    b[12] = HMM & 0xFF
    b[13] = VMM & 0xFF
    b[14] = ((HMM >> 8) << 4) | ((VMM >> 8) & 0xF)
    b[15] = 0
    b[16] = 0
    b[17] = DTD_FLAGS
    return bytes(b)


def name_desc(name):
    b = bytearray([0, 0, 0, 0xFC, 0])
    s = name.encode()[:13]
    b += s
    if len(s) < 13:
        b += b"\x0a"
        b += b"\x20" * (13 - len(s) - 1)
    return bytes(b)


def range_desc(vmin, vmax, hmin, hmax, maxclock_10mhz):
    return bytes([0, 0, 0, 0xFD, 0, vmin, vmax, hmin, hmax, maxclock_10mhz,
                  0x00, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20])


def dummy_desc():
    return bytes([0, 0, 0, 0x10, 0] + [0] * 13)


e = bytearray(128)
e[0:8] = bytes([0, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0])
e[8:10] = mfg_id("GHL")          # "Greenhouse" placeholder vendor
e[10:12] = bytes([0x01, 0x06])   # product code (LE)
e[12:16] = bytes([1, 1, 1, 1])   # serial
e[16] = 0                        # mfg week
e[17] = 2026 - 1990              # mfg year = 36
e[18] = 1                        # EDID version 1
e[19] = 3                        # revision 3
e[20] = 0x80                     # digital input
e[21] = HMM // 10                # max H image size (cm) = 15
e[22] = VMM // 10                # max V image size (cm) = 8
e[23] = 0x78                     # gamma 2.2
e[24] = 0x02                     # features: DTD1 is preferred/native timing
# chromaticity (generic sRGB-ish; not used for mode selection)
e[25:35] = bytes([0xee, 0x91, 0xa3, 0x54, 0x4c, 0x99, 0x26, 0x0f, 0x50, 0x54])
e[35:38] = bytes([0, 0, 0])      # established timings: none
for i in range(38, 54, 2):       # standard timings: all unused
    e[i] = 0x01
    e[i + 1] = 0x01
e[54:72] = dtd()                 # DTD 1: our 1024x600 preferred timing
e[72:90] = name_desc("1024x600")
e[90:108] = range_desc(50, 61, 30, 40, 6)
e[108:126] = dummy_desc()
e[126] = 0                       # no extension blocks
e[127] = (256 - (sum(e[0:127]) % 256)) % 256  # checksum

out = sys.argv[1] if len(sys.argv) > 1 else "1024x600.bin"
with open(out, "wb") as f:
    f.write(e)
print("wrote", out, len(e), "bytes; checksum byte =", hex(e[127]))
