"""Fail-closed public-release checks; never print private signing material."""
import argparse
import datetime as dt
import hashlib
import json
import os
from pathlib import Path
import plistlib
import re
import subprocess
import tempfile
import zipfile


VERSION = '1.0'
BUNDLE = 'com.zhangsfish.ebook'
AGE_KEY = 'com.apple.developer.declared-age-range'
AGE_TOKENS = (b'DeclaredAgeRange', b'AgeAssurance', b'AgeRangeService',
              b'requestAgeRange', AGE_KEY.encode())


class ContractError(Exception):
    pass


def require(value, code):
    if not value:
        raise ContractError(code)


def capture(args):
    result = subprocess.run(args, capture_output=True)
    require(result.returncode == 0, 'TOOL_FAILED')
    return result.stdout


def source_contract(root, sha):
    require(re.fullmatch(r'[0-9a-f]{40}', sha or ''), 'FULL_READER_SHA_REQUIRED')
    require(capture(['git', '-C', str(root), 'rev-parse', 'HEAD']).decode().strip() == sha,
            'READER_SHA_MISMATCH')
    require(not capture(['git', '-C', str(root), 'status', '--porcelain', '--untracked-files=all']).strip(),
            'DIRTY_READER_CHECKOUT')
    tracked = capture(['git', '-C', str(root), 'ls-files', '-z', '--', 'Sources',
                       'eBOOK.xcodeproj', 'scripts/generate_xcode_project.py']).decode().split('\0')
    for relative in filter(None, tracked):
        path = root / relative
        require(not path.is_symlink(), 'SOURCE_SYMLINK')
        require(not any(token in path.read_bytes() for token in AGE_TOKENS), 'AGE_RUNTIME_SOURCE')
    return {'source_sha': sha, 'clean_pinned_checkout': True, 'age_runtime_source_absent': True}


def export_options(team):
    require(re.fullmatch(r'[A-Z0-9]{10}', team or ''), 'INVALID_TEAM_FORMAT')
    return {'destination': 'export', 'method': 'app-store-connect',
            'signingStyle': 'automatic', 'teamID': team,
            'manageAppVersionAndBuildNumber': False, 'testFlightInternalTestingOnly': False}


def metadata_contract(info, build):
    require(re.fullmatch(r'[1-9][0-9]*\.[1-9][0-9]*', build or ''), 'INVALID_BUILD')
    require(info.get('CFBundleIdentifier') == BUNDLE, 'WRONG_BUNDLE')
    require(info.get('CFBundleShortVersionString') == VERSION, 'WRONG_MARKETING_VERSION')
    require(info.get('CFBundleVersion') == build, 'WRONG_BUILD')
    require(info.get('ITSAppUsesNonExemptEncryption') is False, 'ENCRYPTION_METADATA_MISMATCH')
    require(info.get('MinimumOSVersion') == '17.0', 'MIN_OS_MISMATCH')
    return {'version': VERSION, 'build': build, 'metadata_verified': True}


def profile_contract(entitlements, profile, team, now=None):
    expected = team + '.' + BUNDLE
    require(AGE_KEY not in entitlements, 'SIGNED_AGE_ENTITLEMENT_PRESENT')
    allowed = profile.get('Entitlements', {})
    for values in (entitlements, allowed):
        require(values.get('application-identifier') == expected, 'APP_IDENTIFIER_MISMATCH')
        require(values.get('com.apple.developer.team-identifier') == team, 'TEAM_MISMATCH')
        require(values.get('get-task-allow') is False, 'DEBUG_ENTITLEMENT')
    require(profile.get('TeamIdentifier') == [team], 'PROFILE_TEAM_MISMATCH')
    require(not profile.get('ProvisionedDevices') and not profile.get('ProvisionsAllDevices'),
            'NOT_APP_STORE_PROFILE')
    expiry = profile.get('ExpirationDate')
    require(isinstance(expiry, dt.datetime), 'PROFILE_EXPIRY_MISSING')
    require(expiry.replace(tzinfo=dt.timezone.utc) > (now or dt.datetime.now(dt.timezone.utc)),
            'PROFILE_EXPIRED')
    return {'signed_age_key_absent': True, 'app_store_profile': True, 'profile_not_expired': True}


def single_ipa(folder):
    paths = list(Path(folder).glob('*.ipa'))
    require(len(paths) == 1 and not paths[0].is_symlink(), 'EXPECTED_ONE_IPA')
    return paths[0]


def digest(path):
    with Path(path).open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()


def verify_digest(path, manifest):
    require(digest(path) == manifest.get('ipa_sha256'), 'IPA_DIGEST_CHANGED')
    require(Path(path).stat().st_size == manifest.get('ipa_bytes'), 'IPA_SIZE_CHANGED')


def signed_contract(folder, build, audit_log):
    # The existing genuine Apple Distribution verifier has already inspected the
    # actual archive, signatures, certificate chain and 6+2 model/notices bundle.
    rows = [line[len('EBOOK_SIGNED_EXPORT_AUDIT '):] for line in Path(audit_log).read_text().splitlines()
            if line.startswith('EBOOK_SIGNED_EXPORT_AUDIT ')]
    require(len(rows) == 1, 'SIGNED_AUDIT_MISSING')
    audit = json.loads(rows[0])
    require(audit.get('source_sha') == os.environ['EBOOK_TESTED_SHA'], 'AUDIT_SOURCE_MISMATCH')
    require(audit.get('build') == build, 'AUDIT_BUILD_MISMATCH')
    for key in ('codesign_deep_strict', 'apple_generic_anchor', 'apple_distribution_authority',
                'profile_team_matches', 'profile_app_identifier_matches', 'get_task_allow_false'):
        require(audit.get(key) is True, 'SIGNED_AUDIT_FAILED')
    certificate = audit.get('certificate_audit', {})
    require(certificate.get('extraction_exit') == 0 and certificate.get('chain_trust_exit') == 0
            and certificate.get('leaf_present_in_profile') is True, 'CERTIFICATE_CHAIN_FAILED')
    require(audit.get('adhoc_signature') is False and audit.get('embedded_framework_count') == 0
            and audit.get('app_dynamically_loads_onnxruntime') is False, 'UNEXPECTED_FRAMEWORK_OR_SIGNING')
    ipa = single_ipa(folder)
    verify_digest(ipa, audit)
    # Read the signed IPA itself, independently of unsigned archive metadata.
    with zipfile.ZipFile(ipa) as archive:
        infos = [name for name in archive.namelist()
                 if re.fullmatch(r'Payload/[^/]+\.app/Info\.plist', name)]
        require(len(infos) == 1, 'EXPECTED_ONE_SIGNED_APP')
        prefix = infos[0][:-len('Info.plist')]
        info = plistlib.loads(archive.read(infos[0]))
        metadata = metadata_contract(info, build)
        executable_name = info.get('CFBundleExecutable')
        require(executable_name == 'eBOOK', 'WRONG_EXECUTABLE')
        executable = archive.read(prefix + executable_name)
        require(not any(token in executable for token in AGE_TOKENS), 'COMPILED_AGE_RUNTIME_PRESENT')
        with tempfile.TemporaryDirectory(prefix='ebook-public-signature-', dir=os.environ['RUNNER_TEMP']) as temp:
            # security and codesign need actual filesystem objects; only the
            # already-validated ZIP paths are extracted by the existing verifier.
            # codesign entitlement inspection needs the entire sealed App.
            capture(['ditto', '-xk', str(ipa), temp])
            app = Path(temp) / prefix.rstrip('/')
            profile = plistlib.loads(capture(['security', 'cms', '-D', '-i', str(app / 'embedded.mobileprovision')]))
            entitlements = plistlib.loads(capture(['codesign', '-d', '--entitlements', ':-', str(app)]))
            contract = profile_contract(entitlements, profile, os.environ['APPLE_TEAM_ID'])
    return {**metadata, **contract, 'source_sha': os.environ['EBOOK_TESTED_SHA'],
            'ipa_sha256': digest(ipa), 'ipa_bytes': ipa.stat().st_size,
            'compiled_age_runtime_absent': True, 'signed_distribution_verified': True,
            'appReview': 'NOT_SUBMITTED_BY_THIS_WORKFLOW'}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('mode', choices=['source', 'options', 'metadata', 'signed', 'digest'])
    parser.add_argument('paths', nargs='*')
    args = parser.parse_args()
    if args.mode == 'source':
        result = source_contract(Path.cwd(), os.environ.get('EBOOK_TESTED_SHA', ''))
    elif args.mode == 'options':
        Path(args.paths[0]).write_bytes(plistlib.dumps(export_options(os.environ.get('APPLE_TEAM_ID'))))
        result = {'public_export_options': True, 'testFlightInternalTestingOnly': False}
    elif args.mode == 'metadata':
        result = metadata_contract(plistlib.loads(Path(args.paths[0]).read_bytes()), args.paths[1])
    elif args.mode == 'signed':
        result = signed_contract(args.paths[0], args.paths[1], args.paths[2])
        Path(args.paths[3]).write_text(json.dumps(result, sort_keys=True) + '\n')
    else:
        result = json.loads(Path(args.paths[1]).read_text())
        verify_digest(single_ipa(args.paths[0]), result)
        result = {'same_verified_ipa_sha256': result['ipa_sha256'], 'digest_verified': True}
    print('EBOOK_PUBLIC_CONTRACT ' + json.dumps(result, sort_keys=True))


if __name__ == '__main__':
    try:
        main()
    except ContractError as error:
        print('EBOOK_PUBLIC_CONTRACT_FAILED ' + str(error))
        raise SystemExit(2)
    except Exception:
        print('EBOOK_PUBLIC_CONTRACT_FAILED PRIVATE_DETAIL_SUPPRESSED')
        raise SystemExit(2)
