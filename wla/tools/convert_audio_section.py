#!/usr/bin/env python3
"""Generate a WLA-DX audio section from an RGBDS section's INCLUDE list."""
from pathlib import Path
import subprocess
import sys
import tempfile
import re

def main() -> int:
    if len(sys.argv) != 4:
        raise SystemExit("usage: convert_audio_section.py audio.asm section output")
    audio, section, output = map(Path, (sys.argv[1], sys.argv[2], sys.argv[3]))
    lines = audio.read_text().splitlines()
    start = next(i for i, line in enumerate(lines) if line == f'SECTION "{section}", ROMX')
    end = next((i for i in range(start + 1, len(lines)) if lines[i].startswith("SECTION ")), len(lines))
    includes = [line for line in lines[start + 1:end]
                if line.startswith("INCLUDE ") or re.match(r'^[A-Za-z_][A-Za-z0-9_]*:$', line)]
    with tempfile.NamedTemporaryFile("w", suffix=".asm", delete=False) as tmp:
        tmp.write("\n".join(includes) + "\n")
        source = tmp.name
    try:
        result = subprocess.run([sys.executable, "wla/tools/convert_rgbds_code.py", "--symbols", "pokered.sym", source], check=True, text=True, capture_output=True)
    finally:
        Path(source).unlink(missing_ok=True)
    body = result.stdout
    suffix = {'Sound Effects 1': '1', 'Sound Effects 2': '2', 'Sound Effects 3': '3', 'Audio Engine 1': 'E1'}.get(str(section), '1')
    prefix = 'AudioWaveforms' + suffix
    body = body.replace('AudioWaveforms.', prefix + '.')
    end_label = 'AudioSectionEnd' + suffix
    Path(output).write_text(f"; Generated from {audio}:{section}; do not edit.\n{body}{end_label}:\n")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
