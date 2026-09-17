#!/usr/bin/env python3
"""Verify every bank without requiring a reference ROM at build time."""

from __future__ import annotations

import hashlib
import sys
from pathlib import Path


EXPECTED = (
    "1b70957a2b7a482a6b2d769ddf2c5d3365e6071b", "0b2ed8cfa6e42b3cbd814e868b38f21c590b30ac",
    "466a84098c3df3e7a767b2a18846cbec9e98550d", "734f3521c484a1a4c3dbd0870d6038b54bcd0741",
    "46e2b9663e3ea9fa6703ef58d6d7c29dcabfc5ab", "45720f73b9c0bb3a73f4608568c29d3ac7fe8ded",
    "98e279d41f38eac14d51af0dc042d86a7f1219dc", "521af681a3e4c9d45521d2e3921d008fffa1a436",
    "2b77916418ed61d8787ad77029f9ea08e158e12f", "7e54fcda332d9d3767042fb4c18ca4bdd5eda2a9",
    "8190a9213c0244043ce018c6e494531913f6ee00", "01277e001ed9ac257d8afb678528b70cd34c6bac",
    "b98c55406c15bfa81968914f33076c826e01383c", "1581049d8d4a6cea370770fc33e0ae4560b4869b",
    "c2df217d01e65752b20bd53b5e566913169c48f4", "bf8b2db73ffd9e2aad3b0a1850afd436c27bab05",
    "c58ff2e8faa113b506ca5b051876440df84b1a0c", "c9b74cfd278bddb5b8f88849d6381cf95ac4f174",
    "e174e5deda87b69be86d25bb54e99da601c39c4b", "6ae5df7f883014e15f50e214837f48acc94dfb4b",
    "339485e6bec4c23315610d543064b8f691f29a4d", "f9e0e10fa88d678f485523241cb3524b6f9f183b",
    "3efd9b0faba5c087c3989052ed52661bb5870faf", "2808151e38cce83885ad9bc7c00cae66481bd39f",
    "36b907a9783ae00ef1eea92357cb88c45284ef7b", "41d0ea917b41d3f8796b549fd0ef63427fbd1ab1",
    "3d82d822993daa22b1a639b42ed8187d9c30a7f4", "682b94550690d2e4c4103fe93753ed74ab38fc72",
    "389cb0de514f17b9052f6d06ed8d158bc4530fac", "310c32b954c6b097151f26e54c7ccc3de33578ea",
    "afb56eb2c4c8c580752b220a6bbfbc5a591cc926", "f790cc50740f81fef8a03d1623461659ed96baa7",
    "70f5deb41463196850f48b40b5abfb73f7d77c74", "f5b7fc7c0ebbb1273d8e4bf7139554fbfbaee945",
    "aea5695ed3feb651b6e0e4be2db91f7b5d4fefc0", "b383ef3b379addd94260d7fecaf2f07d0481f4e9",
    "514f38957a9a3dd624283a8ea95246b7eb671edf", "5aa43e94937c8f44ad4f32f2ba406440e3cdcca6",
    "2a8101ae6956c7fbd0c424d20e018e99ffde158f", "85218e42077884c662a82190e7dfc37aff52904f",
    "533dcbb39001ec732873c889df17cf2d04ca4f36", "c705f9c027307755d13a7f8411c95ea11835feaf",
    "1a7e39fee5d9b8029045dcb807eeb63f717a40f8", "a9965d84d7e03bcf467d90912bb0150178deab80",
    "ef9429bfefb02cfac0e04046d6df0966df3906f9",
    *("897256b6709e1a4da9daba92b6bde39ccfccd8c1",) * 19,
)


def main() -> int:
    data = Path(sys.argv[1]).read_bytes()
    if len(data) != 64 * 0x4000:
        raise SystemExit(f"expected 1048576 bytes, got {len(data)}")
    failed = False
    for bank, expected in enumerate(EXPECTED):
        actual = hashlib.sha1(data[bank * 0x4000 : (bank + 1) * 0x4000]).hexdigest()
        if actual != expected:
            print(f"bank {bank:02x}: expected {expected}, got {actual}", file=sys.stderr)
            failed = True
    if failed:
        return 1
    print("all 64 ROM banks match")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
