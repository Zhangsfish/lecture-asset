"""Inspect Xcode's final simulator Mach-O; never claim distribution signing."""
import json
import plistlib
import re
import hashlib
import struct
import sys
from pathlib import Path

# Source proof of the real availability branch, not an old-OS execution claim.
entry_path = Path(__file__).resolve().parents[1] / 'App/AgeAssuranceEntryView.swift'
entry_source = entry_path.read_text(encoding='utf-8')
route = re.search(
    r'if #available\(iOS 26\.2,\s*\*\)\s*\{\s*SupportedAgeAssuranceEntry\(\)\s*\}'
    r'\s*else\s*\{(.*?)\n\s*\}', entry_source, re.S)
assert route, 'Missing explicit iOS 26.2 availability routing'
old_os_body = re.sub(r'//[^\n]*', '', route.group(1)).strip()
assert old_os_body == 'ContentView()', 'Old OS must directly enter ContentView only'
entry_proof = {
    'method': 'Focused source assertion; not old-OS simulator/device execution',
    'source_sha256': hashlib.sha256(entry_path.read_bytes()).hexdigest(),
    'ios_below_26_2': 'ContentView() directly; no service, request, or blocker',
    'ios_26_2_plus': 'SupportedAgeAssuranceEntry()',
    'owner_decision_date': '2026-10-06'
}
if sys.argv[1] == '--source-only':
    Path(sys.argv[2]).write_text(json.dumps(entry_proof, indent=2) + '\n', encoding='utf-8')
    print('AGE_ENTRY_SOURCE_ROUTING_PASS')
    sys.exit(0)

app = Path(sys.argv[1])
info = plistlib.loads((app / 'Info.plist').read_bytes())
assert info['CFBundleIdentifier'] == 'com.zhangsfish.lectureasset'
assert info['MinimumOSVersion'] == '18.0'
binary = (app / info['CFBundleExecutable']).read_bytes()
assert binary[:4] == b'\xcf\xfa\xed\xfe', 'Expected thin little-endian Mach-O 64'
command_count = struct.unpack_from('<I', binary, 16)[0]
cursor = 32
entitlements = None
for _ in range(command_count):
    command, length = struct.unpack_from('<II', binary, cursor)
    assert length >= 8 and cursor + length <= len(binary)
    if command == 0x19:  # LC_SEGMENT_64
        sections = struct.unpack_from('<I', binary, cursor + 64)[0]
        for index in range(sections):
            section = cursor + 72 + index * 80
            assert section + 80 <= cursor + length
            name = binary[section:section + 16].rstrip(b'\0')
            segment = binary[section + 16:section + 32].rstrip(b'\0')
            if name == b'__entitlements' and segment == b'__TEXT':
                size = struct.unpack_from('<Q', binary, section + 40)[0]
                offset = struct.unpack_from('<I', binary, section + 48)[0]
                assert offset + size <= len(binary)
                entitlements = plistlib.loads(binary[offset:offset + size].rstrip(b'\0'))
    cursor += length
assert entitlements is not None, 'Missing final Mach-O simulated entitlements'
assert entitlements.get('com.apple.developer.declared-age-range') is True
Path(sys.argv[2]).write_text(json.dumps({
    'entry_source_routing': entry_proof,
    'release_simulator_macho_declared_age_range': True,
    'minimum_os': info['MinimumOSVersion'],
    'bundle_id_correct': True,
    'apple_signed_device_entitlement': 'NOT_RUN',
    'evidence_scope': 'Final Release simulator __TEXT,__entitlements; not distribution provisioning'
}, indent=2) + '\n', encoding='utf-8')
