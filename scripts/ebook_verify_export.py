"""Inspect an ephemeral export without publishing any IPA, profile or signer ID."""
from pathlib import Path
import hashlib
import json
import os
import plistlib
import stat
import struct
import subprocess
import sys
import tempfile
import zipfile

sys.path.insert(0, str(Path.cwd() / 'scripts'))
from verify_release_bundle import validate_resources

def run(args):
    return subprocess.run(args, capture_output=True)

def error_categories(result):
    text = (result.stdout + result.stderr).decode(errors='replace').lower()
    terms = {
        'REQUIREMENT_UNSATISFIED': 'failed to satisfy',
        'UNTRUSTED_CERTIFICATE': 'cssmerr_tp_not_trusted',
        'REVOKED_CERTIFICATE': 'revoked',
        'EXPIRED_CERTIFICATE': 'expired',
        'UNSIGNED_CODE': 'not signed at all',
        'INVALID_RESOURCES': 'sealed resource',
        'INVALID_FORMAT': 'bundle format',
    }
    return [name for name, term in terms.items() if term in text]

def signature_summary(path):
    strict = run(['codesign', '--verify', '--deep', '--strict', str(path)])
    anchor = run(['codesign', '--verify', '--strict', '-R', '=anchor apple generic', str(path)])
    display = run(['codesign', '-d', '-vvv', str(path)])
    text = (display.stdout + display.stderr).decode(errors='replace')
    flags = __import__('re').search(r'flags=(0x[0-9a-fA-F]+)', text)
    return {
        'strict_exit': strict.returncode, 'strict_errors': error_categories(strict),
        'anchor_exit': anchor.returncode, 'anchor_errors': error_categories(anchor),
        'authority_count': sum(line.startswith('Authority=') for line in text.splitlines()),
        'apple_distribution_authority': any(line.startswith(('Authority=Apple Distribution', 'Authority=iPhone Distribution')) for line in text.splitlines()),
        'adhoc_signature': 'Signature=adhoc' in text,
        'code_directory_flags': flags[1] if flags else None,
        'team_identifier_matches': ('TeamIdentifier=' + os.environ['APPLE_TEAM_ID']) in text.splitlines(),
    }

def binary_kind(path):
    with path.open('rb') as stream:
        data = stream.read(64)
        if data[:4] == b'\xca\xfe\xba\xbe':
            offset = struct.unpack('>I', data[16:20])[0]
            stream.seek(offset)
            data = stream.read(16)
        if data.startswith(b'!<arch>\n'):
            return 'STATIC_AR_ARCHIVE'
        if data[:4] in [b'\xcf\xfa\xed\xfe', b'\xce\xfa\xed\xfe']:
            kind = struct.unpack('<I', data[12:16])[0]
            return {1: 'MH_OBJECT', 2: 'MH_EXECUTE', 6: 'MH_DYLIB', 8: 'MH_BUNDLE'}.get(kind, 'OTHER_MACH_O')
        return 'OTHER_FORMAT'

ipas = list(Path(sys.argv[1]).glob('*.ipa'))
if len(ipas) != 1:
    print('EBOOK_SIGNED_EXPORT_AUDIT_NO_SINGLE_IPA')
    sys.exit(2)
ipa = ipas[0]
with tempfile.TemporaryDirectory(prefix='ebook-export-audit-', dir=os.environ['RUNNER_TEMP']) as temporary:
    root = Path(temporary)
    with zipfile.ZipFile(ipa) as archive:
        if sum(item.file_size for item in archive.infolist()) > 512 * 1024 * 1024:
            raise ValueError('Unexpected export size')
        for item in archive.infolist():
            path = Path(item.filename)
            if path.is_absolute() or '..' in path.parts or stat.S_ISLNK(item.external_attr >> 16):
                raise ValueError('Unexpected export path')
        archive.extractall(root)
        # ZIP extraction must retain executable bits before inspecting the bundle.
        for item in archive.infolist():
            mode = (item.external_attr >> 16) & 0o777
            if mode:
                (root / item.filename).chmod(mode)
    apps = list((root / 'Payload').glob('*.app'))
    if len(apps) != 1:
        raise ValueError('Expected one exported App')
    app = apps[0]
    info = plistlib.loads((app / 'Info.plist').read_bytes())
    if info['CFBundleIdentifier'] != 'com.zhangsfish.ebook' or info['CFBundleShortVersionString'] != '0.1.0':
        raise ValueError('Wrong exported product')
    verification = run(['codesign', '--verify', '--deep', '--strict', str(app)])
    anchor = run(['codesign', '--verify', '--strict', '-R', '=anchor apple generic', str(app)])
    display = run(['codesign', '-d', '-vvv', str(app)])
    details = (display.stdout + display.stderr).decode(errors='replace')
    distribution = any(line.startswith(('Authority=Apple Distribution', 'Authority=iPhone Distribution')) for line in details.splitlines())
    profile_result = run(['security', 'cms', '-D', '-i', str(app / 'embedded.mobileprovision')])
    entitlement_result = run(['codesign', '-d', '--entitlements', ':-', str(app)])
    profile = plistlib.loads(profile_result.stdout) if profile_result.returncode == 0 else {}
    try:
        entitlements = plistlib.loads(entitlement_result.stdout)
    except (ValueError, plistlib.InvalidFileException):
        entitlements = {}
    expected_team = os.environ['APPLE_TEAM_ID']
    matching_team = profile.get('TeamIdentifier') == [expected_team]
    profile_entitlements = profile.get('Entitlements', {})
    matching_app_id = (entitlements.get('application-identifier') == profile_entitlements.get('application-identifier')
                       and str(entitlements.get('application-identifier', '')).endswith('.com.zhangsfish.ebook'))
    frameworks = list((app / 'Frameworks').glob('*.framework'))
    component_audits = []
    for framework in frameworks:
        framework_info = plistlib.loads((framework / 'Info.plist').read_bytes())
        executable = framework / framework_info['CFBundleExecutable']
        with executable.open('rb') as stream:
            magic = stream.read(8)
        component_audits.append({
            'component': 'ONNXRUNTIME_FRAMEWORK' if framework.name == 'onnxruntime.framework' else 'OTHER_FRAMEWORK',
            'static_archive_magic': magic == b'!<arch>\n',
            'binary_kind': binary_kind(executable),
            **signature_summary(framework),
        })
    dependencies = run(['otool', '-L', str(app / 'eBOOK')])
    dependency_text = (dependencies.stdout + dependencies.stderr).decode(errors='replace')
    certificate_prefix = root / 'certificate-'
    extraction = run(['codesign', '-d', '--extract-certificates=' + str(certificate_prefix), str(app)])
    certificates = sorted(root.glob('certificate-*'))
    certificate_audit = {'extraction_exit': extraction.returncode, 'certificate_count': len(certificates)}
    if certificates:
        verification_args = ['security', 'verify-cert', '-p', 'codeSign']
        for certificate in certificates:
            verification_args.extend(['-c', str(certificate)])
        trust = run(verification_args)
        certificate_audit.update({'chain_trust_exit': trust.returncode, 'chain_trust_errors': error_categories(trust),
            'leaf_present_in_profile': certificates[0].read_bytes() in profile.get('DeveloperCertificates', [])})
    metadata = {
        'build': info['CFBundleVersion'], 'source_sha': os.environ['EBOOK_TESTED_SHA'],
        'no_upload': True, 'ipa_bytes': ipa.stat().st_size,
        'ipa_sha256': hashlib.sha256(ipa.read_bytes()).hexdigest(),
        'codesign_deep_strict': verification.returncode == 0,
        'apple_generic_anchor': anchor.returncode == 0,
        'apple_distribution_authority': distribution,
        'adhoc_signature': 'Signature=adhoc' in details,
        'profile_team_matches': matching_team, 'profile_app_identifier_matches': matching_app_id,
        'get_task_allow_false': entitlements.get('get-task-allow') is False,
        'embedded_framework_count': len(frameworks),
        'app_signature_detail': signature_summary(app),
        'app_dynamically_loads_onnxruntime': 'onnxruntime.framework/onnxruntime' in dependency_text,
        'component_audits': component_audits,
        'certificate_audit': certificate_audit,
        **validate_resources(app),
    }
    print('EBOOK_SIGNED_EXPORT_AUDIT ' + json.dumps(metadata, sort_keys=True))
    passed = all(metadata[name] for name in ['codesign_deep_strict', 'apple_generic_anchor',
        'apple_distribution_authority', 'profile_team_matches', 'profile_app_identifier_matches', 'get_task_allow_false'])
    sys.exit(0 if passed else 2)
