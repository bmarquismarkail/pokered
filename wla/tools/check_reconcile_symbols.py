#!/usr/bin/env python3
"""Cross-check wla/data reconcile labels against the rgblink symbol table.

``pokered.sym`` (rgblink output for the finished Red ROM) is the bank/address
ground truth for every global label in the final ROM. It is independent of the
WLA-DX monolith, so this check runs even when the monolith is not present.

For each ``*_reconcile.asm`` file we:
  * extract the *global* labels (leading uppercase/underscore; WLA local labels
    start with ``.`` and are not in the sym table, so they are skipped), and
  * verify each global label is present in the sym table (a missing label is a
    real reconciliation bug), and
  * when the reconcile file is bank-located, verify the sym bank matches.

Bank location is resolved two ways:
  * the reconcile file's own path encodes a bank under ``wla/pkrd/bankNN/`` or
    is otherwise given a ``--bank-map`` (unused by default), and
  * by default we only *report* the sym bank so a human can confirm placement;
    a hard failure is raised only for missing labels, not bank mismatches,
    because reconcile files live under ``wla/data/`` and are not yet wired into
    ``wla/pkrd/bankNN.asm`` (see WLA_DX_PORTING.md).

Exit status: 0 if no missing labels, 1 otherwise.
"""

from __future__ import annotations

import argparse
import re
import sys
from dataclasses import dataclass, field
from pathlib import Path

# rgblink .sym lines: "<bank>:<addr> <name>" or "<bank> <name>" (bank-only, no addr).
SYM_BANK_ADDR_RE = re.compile(r'^\s*([0-9a-fA-F]{1,2}):([0-9a-fA-F]{4})\s+(.+?)\s*$')
SYM_BANK_ONLY_RE = re.compile(r'^\s*([0-9a-fA-F]{1,2})\s+([A-Za-z_][A-Za-z0-9_]*)\s*$')

# A reconcile global label: starts with a letter/underscore (NOT a dot), ends
# with ':' or '::'. Mirrors reconcile_audit.LABEL_RE intent but restricted to
# labels that rgblink would actually emit as global symbols.
GLOBAL_LABEL_RE = re.compile(r'^\s*([A-Za-z_][A-Za-z0-9_]*):{1,2}\s*(?:$|[;.]|[A-Za-z_])')


@dataclass(frozen=True)
class SymEntry:
    name: str
    bank: str | None
    addr: str | None


@dataclass
class SymTable:
    entries: dict[str, SymEntry] = field(default_factory=dict)
    # name -> list of (bank, addr); rgblink can emit a symbol in more than one
    # bank (e.g. a .DB table plus a relocating pointer). Keep them all.
    occurrences: dict[str, list[tuple[str | None, str | None]]] = field(default_factory=dict)

    @classmethod
    def load(cls, path: Path) -> 'SymTable':
        table = cls()
        for raw in path.read_text(errors='replace').splitlines():
            if raw.startswith(';'):
                continue
            m = SYM_BANK_ADDR_RE.match(raw)
            if m:
                bank, addr, name = m.group(1), m.group(2), m.group(3)
                table.entries[name] = SymEntry(name, bank, addr)
                table.occurrences.setdefault(name, []).append((bank, addr))
                continue
            m = SYM_BANK_ONLY_RE.match(raw)
            if m:
                bank, name = m.group(1), m.group(2)
                # bank-only entries: record presence, keep first addr-less form
                if name not in table.entries:
                    table.entries[name] = SymEntry(name, bank, None)
                table.occurrences.setdefault(name, []).append((bank, None))
        return table


def extract_global_labels(path: Path) -> list[str]:
    labels: list[str] = []
    for raw in path.read_text(errors='replace').splitlines():
        m = GLOBAL_LABEL_RE.match(raw)
        if m:
            labels.append(m.group(1))
    return labels


@dataclass
class CheckResult:
    sym_path: Path
    reconcile_files: int
    global_labels_checked: int
    present: int
    missing: list[tuple[Path, str]] = field(default_factory=list)
    bank_report: list[tuple[Path, str, str | None, str | None]] = field(default_factory=list)

    @property
    def ok(self) -> bool:
        return not self.missing


def check(sym_path: Path, wla_data_dir: Path = Path('wla/data')) -> CheckResult:
    table = SymTable.load(sym_path)
    reconcile_files = sorted(wla_data_dir.rglob('*_reconcile.asm'))
    result = CheckResult(
        sym_path=sym_path,
        reconcile_files=len(reconcile_files),
        global_labels_checked=0,
        present=0,
    )
    for reconcile in reconcile_files:
        for label in extract_global_labels(reconcile):
            result.global_labels_checked += 1
            if label in table.entries:
                result.present += 1
                entry = table.entries[label]
                result.bank_report.append((reconcile, label, entry.bank, entry.addr))
            else:
                result.missing.append((reconcile, label))
    return result


def print_report(result: CheckResult, *, show_banks: bool = False, missing_limit: int | None = None) -> None:
    total = result.global_labels_checked
    print('WLA-DX reconcile symbol check (rgblink symbol table)')
    print(f'  sym_table            : {result.sym_path}')
    print(f'  reconcile_files      : {result.reconcile_files}')
    print(f'  global_labels        : {total}')
    print(f'  present_in_sym       : {result.present}')
    print(f'  missing_from_sym     : {len(result.missing)}')
    if result.missing:
        shown = result.missing if missing_limit is None else result.missing[:missing_limit]
        for path, label in shown:
            print(f'    MISSING {path}:{label}')
        if missing_limit is not None and len(result.missing) > missing_limit:
            print(f'    ... {len(result.missing) - missing_limit} more missing label(s)')
    if show_banks:
        print()
        print('bank placement (from sym table; reconcile files are under wla/data/)')
        for path, label, bank, addr in result.bank_report:
            loc = f'{bank}:{addr}' if addr else f'{bank}'
            print(f'    {label:32} {loc:10} {path.name}')


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        prog='check_reconcile_symbols.py',
        description='Cross-check wla/data reconcile labels against the rgblink symbol table.',
    )
    parser.add_argument(
        'sym',
        nargs='?',
        default='wla/reference/pokered.sym',
        help='path to the rgblink .sym file (default: %(default)s)',
    )
    parser.add_argument(
        '--data-dir',
        default='wla/data',
        help='directory containing *_reconcile.asm files (default: %(default)s)',
    )
    parser.add_argument('--banks', action='store_true', help='also print the bank:addr report')
    args = parser.parse_args(argv)

    sym_path = Path(args.sym)
    if not sym_path.is_file():
        print(f'ERROR: symbol table not found at {sym_path}', file=sys.stderr)
        print('hint: copy it with  git show symbols:pokered.sym > wla/reference/pokered.sym',
              file=sys.stderr)
        return 2

    result = check(sym_path, Path(args.data_dir))
    print_report(result, show_banks=args.banks)
    return 0 if result.ok else 1


if __name__ == '__main__':
    raise SystemExit(main())
