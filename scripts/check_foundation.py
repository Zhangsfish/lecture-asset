#!/usr/bin/env python3
"""Check planning files and contract example only; this is NOT an iOS/app test."""
from __future__ import annotations
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REQUIRED = [
    'README.md', 'AGENTS.md', 'STATUS.md', 'docs/SPEC.md',
    'docs/ARCHITECTURE.md', 'docs/ASSET_FORMAT.md',
    'docs/SAFETY_AND_STORAGE.md', 'docs/TEST_PLAN.md',
    'docs/WORKFLOW.md', 'docs/APP_STORE.md',
    'docs/REFERENCES.md', 'docs/TECHNICAL_REVIEW.md',
    'docs/OWNER_ACTIONS.md', 'tasks/INDEX.md',
    'tasks/S00_BOOTSTRAP.md', 'tasks/S01_IMPORT.md',
    'tasks/S02_ARCHIVE.md', 'tasks/S03_EXPORT_CLEANUP.md',
    'tasks/S04_DEVICE_QA.md', 'tasks/S05_RELEASE.md',
    'handoff/CODEX_START.md', 'templates/DELIVERY.md',
    'templates/AUDIT.md', 'templates/TEST_RESULTS.json',
    'schemas/manifest-v1.schema.json', 'examples/manifest.example.json'
]

def main() -> int:
    errors: list[str] = []
    for name in REQUIRED:
        path = ROOT / name
        if not path.is_file() or not path.stat().st_size:
            errors.append(f'Missing or empty: {name}')
    parsed: dict[str, object] = {}
    for path in ROOT.rglob('*.json'):
        if any(p in {'.git', '.build', 'build', 'DerivedData'} for p in path.parts):
            continue
        try:
            parsed[str(path.relative_to(ROOT))] = json.loads(path.read_text(encoding='utf-8'))
        except (OSError, UnicodeError, json.JSONDecodeError) as exc:
            errors.append(f'Invalid JSON {path.relative_to(ROOT)}: {exc}')
    link_count = 0
    for path in ROOT.rglob('*.md'):
        if '.git' in path.parts:
            continue
        # Only local Markdown links, not plain URLs/code paths or future source files.
        for target in re.findall(r'(?<!!)\[[^\]\n]+\]\(([^\s)]+)\)', path.read_text(encoding='utf-8')):
            if '://' in target or target.startswith(('#', 'mailto:', 'urn:')):
                continue
            local = target.split('#', 1)[0]
            if local:
                link_count += 1
                resolved = (path.parent / local).resolve()
                if not resolved.is_relative_to(ROOT) or not resolved.exists():
                    errors.append(f'Broken local link {path.relative_to(ROOT)} -> {target}')
    example = parsed.get('examples/manifest.example.json')
    schema = parsed.get('schemas/manifest-v1.schema.json')
    if isinstance(schema, dict) and isinstance(example, dict):
        if set(example) != set(schema.get('required', [])):
            errors.append('Example top-level keys do not match schema required fields.')
        pages = example.get('pages', [])
        if example.get('source_count') != example.get('page_count') or example.get('page_count') != len(pages):
            errors.append('Example counts differ.')
        expected_images = [f'slides/{n:04d}.jpg' for n in range(1, len(pages) + 1)]
        if [p.get('image') for p in pages] != expected_images:
            errors.append('Example page image paths are not sequential.')
        if [p.get('number') for p in pages] != list(range(1, len(pages) + 1)):
            errors.append('Example page numbers are not sequential.')
        if [p.get('pdf_page') for p in pages] != list(range(1, len(pages) + 1)):
            errors.append('Example PDF page numbers differ.')
        files = example.get('files', [])
        paths = [f.get('path') for f in files]
        if len(paths) != len(set(paths)) or set(paths) != set(expected_images + ['README.md', 'lecture.md', 'lecture.pdf']):
            errors.append('Example file list mismatch.')
        forbidden = {'localIdentifier', 'local_identifier', 'gps', 'latitude', 'longitude'}
        def scan(value: object) -> None:
            if isinstance(value, dict):
                if forbidden.intersection(value):
                    errors.append('Private source identifiers or GPS found in example.')
                for child in value.values(): scan(child)
            elif isinstance(value, list):
                for child in value: scan(child)
        scan(example)
    else:
        errors.append('Schema/example missing or not objects.')
    if errors:
        print('\n'.join(f'FAIL: {e}' for e in errors), file=sys.stderr)
        return 1
    print(f'PASS: {len(REQUIRED)} required planning files; {len(parsed)} JSON files parsed; {link_count} local links checked; example cross-field checks.')
    print('NOT TESTED: full JSON Schema validation, real archive files, Swift build, simulator, device, OCR, export, cleanup, App Store.')
    return 0

if __name__ == '__main__':
    raise SystemExit(main())
