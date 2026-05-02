#!/usr/bin/env python3
"""Generate tiny PNG assets used by the Komorebi shader pack."""

from __future__ import annotations

import struct
import zlib
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
TEXTURES = ROOT / "shaders" / "textures"


def lerp(a: int, b: int, t: float) -> int:
    return int(round(a + (b - a) * t))


def mix(c0: tuple[int, int, int], c1: tuple[int, int, int], t: float) -> tuple[int, int, int]:
    return (lerp(c0[0], c1[0], t), lerp(c0[1], c1[1], t), lerp(c0[2], c1[2], t))


def png_chunk(kind: bytes, data: bytes) -> bytes:
    body = kind + data
    return struct.pack(">I", len(data)) + body + struct.pack(">I", zlib.crc32(body) & 0xFFFFFFFF)


def write_png(path: Path, width: int, height: int, pixels: list[tuple[int, int, int, int]]) -> None:
    raw_rows = []
    for y in range(height):
        start = y * width
        row = pixels[start : start + width]
        raw_rows.append(b"\x00" + bytes(channel for pixel in row for channel in pixel))

    png = b"\x89PNG\r\n\x1a\n"
    png += png_chunk(b"IHDR", struct.pack(">IIBBBBB", width, height, 8, 6, 0, 0, 0))
    png += png_chunk(b"IDAT", zlib.compress(b"".join(raw_rows), 9))
    png += png_chunk(b"IEND", b"")
    path.write_bytes(png)


def make_colormap() -> None:
    dark = (0x1A, 0x00, 0x33)
    mid = (0xFF, 0x99, 0x33)
    bright = (0xFF, 0xFF, 0x99)
    pixels = []
    for x in range(256):
        t = x / 255.0
        if t < 0.52:
            rgb = mix(dark, mid, t / 0.52)
        else:
            rgb = mix(mid, bright, (t - 0.52) / 0.48)
        pixels.append((*rgb, 255))
    write_png(TEXTURES / "colormap.png", 256, 1, pixels)


def make_lut_preview() -> None:
    pixels = []
    for y in range(16):
        for x in range(16):
            r = x / 15.0
            g = y / 15.0
            b = 0.48 + 0.24 * (1.0 - y / 15.0)
            rgb = (
                min(255, int((r * 1.12 + 0.02) * 255)),
                min(255, int((g * 1.05 + 0.01) * 255)),
                min(255, int((b * 0.90) * 255)),
            )
            pixels.append((*rgb, 255))
    write_png(TEXTURES / "lut.png", 16, 16, pixels)


def make_pack_icon() -> None:
    size = 256
    dark = (26, 0, 51)
    gold = (255, 153, 51)
    pale = (255, 255, 153)
    ink = (9, 7, 14)
    pixels = []
    for y in range(size):
        for x in range(size):
            t = (x + y) / (2 * (size - 1))
            rgb = mix(dark, gold, min(t * 1.4, 1.0))
            if x > y + 54:
                rgb = mix(rgb, pale, 0.48)
            stripe = abs((x - y) % 54 - 27)
            if stripe < 3:
                rgb = mix(rgb, ink, 0.55)
            if 58 < x < 198 and 58 < y < 198 and abs((x - 128) + (y - 128)) < 74:
                rgb = mix(rgb, pale, 0.32)
            pixels.append((*rgb, 255))
    write_png(ROOT / "pack.png", size, size, pixels)


def main() -> None:
    TEXTURES.mkdir(parents=True, exist_ok=True)
    make_colormap()
    make_lut_preview()
    make_pack_icon()


if __name__ == "__main__":
    main()
