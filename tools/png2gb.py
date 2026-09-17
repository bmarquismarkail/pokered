#!/usr/bin/env python3
"""Convert the project's grayscale PNGs to Game Boy planar tile data.

This deliberately implements only the bounded input format used by pokered:
non-interlaced grayscale PNGs with a bit depth of one or two.  Keeping the
decoder here avoids making the reproducible build depend on rgbgfx or Pillow.
"""

from __future__ import annotations

import argparse
import struct
import sys
import zlib
from pathlib import Path


PNG_SIGNATURE = b"\x89PNG\r\n\x1a\n"


def paeth(left: int, above: int, upper_left: int) -> int:
    prediction = left + above - upper_left
    left_distance = abs(prediction - left)
    above_distance = abs(prediction - above)
    corner_distance = abs(prediction - upper_left)
    if left_distance <= above_distance and left_distance <= corner_distance:
        return left
    if above_distance <= corner_distance:
        return above
    return upper_left


def read_grayscale_png(path: Path) -> tuple[int, int, int, list[list[int]]]:
    data = path.read_bytes()
    if not data.startswith(PNG_SIGNATURE):
        raise ValueError(f"{path}: not a PNG file")

    offset = len(PNG_SIGNATURE)
    header: tuple[int, int, int, int, int, int, int] | None = None
    compressed = bytearray()
    while offset < len(data):
        if offset + 12 > len(data):
            raise ValueError(f"{path}: truncated PNG chunk")
        length = struct.unpack_from(">I", data, offset)[0]
        chunk_type = data[offset + 4 : offset + 8]
        chunk_data = data[offset + 8 : offset + 8 + length]
        if len(chunk_data) != length:
            raise ValueError(f"{path}: truncated {chunk_type!r} chunk")
        expected_crc = struct.unpack_from(">I", data, offset + 8 + length)[0]
        actual_crc = zlib.crc32(chunk_type + chunk_data) & 0xFFFFFFFF
        if actual_crc != expected_crc:
            raise ValueError(f"{path}: bad {chunk_type!r} CRC")
        offset += length + 12

        if chunk_type == b"IHDR":
            if length != 13:
                raise ValueError(f"{path}: invalid IHDR length")
            header = struct.unpack(">IIBBBBB", chunk_data)
        elif chunk_type == b"IDAT":
            compressed.extend(chunk_data)
        elif chunk_type == b"IEND":
            break

    if header is None:
        raise ValueError(f"{path}: missing IHDR")
    width, height, bit_depth, color_type, compression, filtering, interlace = header
    if bit_depth not in (1, 2) or color_type != 0:
        raise ValueError(
            f"{path}: expected 1-bit or 2-bit grayscale PNG, got "
            f"depth={bit_depth} color_type={color_type}"
        )
    if compression != 0 or filtering != 0 or interlace != 0:
        raise ValueError(f"{path}: unsupported PNG compression/filter/interlace mode")
    if width % 8 or height % 8:
        raise ValueError(f"{path}: dimensions must be multiples of 8, got {width}x{height}")

    packed_row_size = (width * bit_depth + 7) // 8
    raw = zlib.decompress(bytes(compressed))
    expected_size = height * (packed_row_size + 1)
    if len(raw) != expected_size:
        raise ValueError(f"{path}: decoded size {len(raw)} != expected {expected_size}")

    packed_rows: list[bytearray] = []
    previous = bytearray(packed_row_size)
    cursor = 0
    for _ in range(height):
        filter_type = raw[cursor]
        cursor += 1
        current = bytearray(raw[cursor : cursor + packed_row_size])
        cursor += packed_row_size
        if filter_type > 4:
            raise ValueError(f"{path}: unsupported PNG filter {filter_type}")
        for index in range(packed_row_size):
            left = current[index - 1] if index else 0
            above = previous[index]
            upper_left = previous[index - 1] if index else 0
            if filter_type == 1:
                current[index] = (current[index] + left) & 0xFF
            elif filter_type == 2:
                current[index] = (current[index] + above) & 0xFF
            elif filter_type == 3:
                current[index] = (current[index] + ((left + above) // 2)) & 0xFF
            elif filter_type == 4:
                current[index] = (current[index] + paeth(left, above, upper_left)) & 0xFF
        packed_rows.append(current)
        previous = current

    mask = (1 << bit_depth) - 1
    pixels: list[list[int]] = []
    for packed in packed_rows:
        row = []
        for x in range(width):
            bit_offset = x * bit_depth
            shift = 8 - bit_depth - (bit_offset % 8)
            row.append((packed[bit_offset // 8] >> shift) & mask)
        pixels.append(row)
    return width, height, bit_depth, pixels


def convert(path: Path, output_depth: int, columns: bool) -> bytes:
    width, height, source_depth, pixels = read_grayscale_png(path)
    if output_depth not in (1, 2):
        raise ValueError("output depth must be 1 or 2")
    if source_depth < output_depth:
        raise ValueError(f"{path}: {source_depth}bpp source cannot produce {output_depth}bpp data")

    tiles_x, tiles_y = width // 8, height // 8
    tile_positions = (
        ((tile_x, tile_y) for tile_x in range(tiles_x) for tile_y in range(tiles_y))
        if columns
        else ((tile_x, tile_y) for tile_y in range(tiles_y) for tile_x in range(tiles_x))
    )
    output = bytearray()
    source_max = (1 << source_depth) - 1
    for tile_x, tile_y in tile_positions:
        for row_offset in range(8):
            planes = [0] * output_depth
            for column_offset in range(8):
                # rgbgfx --colors dmg maps white to color 0 and black to the
                # darkest color.  Down-conversion keeps the most significant
                # shade bits, matching rgbgfx's 1bpp behavior for this corpus.
                shade = source_max - pixels[tile_y * 8 + row_offset][tile_x * 8 + column_offset]
                if source_depth > output_depth:
                    shade >>= source_depth - output_depth
                for plane in range(output_depth):
                    planes[plane] |= ((shade >> plane) & 1) << (7 - column_offset)
            output.extend(planes)
    return bytes(output)


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--depth", type=int, choices=(1, 2), default=2)
    parser.add_argument("--columns", action="store_true")
    parser.add_argument("--colors", choices=("dmg",), default="dmg")
    parser.add_argument("-o", "--output", type=Path, required=True)
    parser.add_argument("input", type=Path)
    return parser.parse_args(argv)


def main(argv: list[str]) -> int:
    args = parse_args(argv)
    try:
        encoded = convert(args.input, args.depth, args.columns)
        args.output.write_bytes(encoded)
    except (OSError, ValueError, zlib.error) as error:
        print(error, file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
