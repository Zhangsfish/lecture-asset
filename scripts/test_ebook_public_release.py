"""Synthetic safety contracts only; never signing/upload/device evidence."""
import ast
import copy
import datetime as dt
import hashlib
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parent))
import ebook_public_contract as public


class PublicReleaseTests(unittest.TestCase):
    def setUp(self):
        self.team = 'SYNTHETIC1'
        self.info = {'CFBundleIdentifier': public.BUNDLE,
                     'CFBundleShortVersionString': '1.0', 'CFBundleVersion': '1.1',
                     'ITSAppUsesNonExemptEncryption': False, 'MinimumOSVersion': '17.0'}
        self.entitlements = {'application-identifier': self.team + '.' + public.BUNDLE,
                             'com.apple.developer.team-identifier': self.team,
                             'get-task-allow': False}
        self.profile = {'Entitlements': copy.deepcopy(self.entitlements), 'TeamIdentifier': [self.team],
                        'ExpirationDate': dt.datetime.now(dt.timezone.utc) + dt.timedelta(days=1)}

    def test_public_export_and_metadata_reject_internal_version(self):
        options = public.export_options(self.team)
        self.assertEqual(options['destination'], 'export')
        self.assertIs(options['testFlightInternalTestingOnly'], False)
        public.metadata_contract(self.info, '1.1')
        for key, value in [('CFBundleShortVersionString', '0.1.0'), ('CFBundleVersion', '2.1'),
                           ('CFBundleIdentifier', 'com.zhangsfish.lectureasset'),
                           ('ITSAppUsesNonExemptEncryption', True)]:
            invalid = {**self.info, key: value}
            with self.subTest(key=key), self.assertRaises(public.ContractError):
                public.metadata_contract(invalid, '1.1')

    def test_shared_signed_verifier_keeps_internal_default_and_public_pin(self):
        source = Path(__file__).with_name('ebook_verify_export.py').read_text(encoding='utf8')
        tree = ast.parse(source)
        function = next(node for node in tree.body if isinstance(node, ast.FunctionDef)
                        and node.name == 'exported_product_matches')
        namespace = {'os': os}
        exec(compile(ast.Module(body=[function], type_ignores=[]), '<actual-shared-version-contract>', 'exec'), namespace)
        matches = namespace['exported_product_matches']
        with patch.dict(os.environ, {}, clear=True):
            self.assertFalse(matches(self.info))
            self.assertTrue(matches({**self.info, 'CFBundleShortVersionString': '0.1.0'}))
        with patch.dict(os.environ, {'EBOOK_EXPECTED_VERSION': '1.0'}):
            self.assertTrue(matches(self.info))
            self.assertFalse(matches({**self.info, 'CFBundleShortVersionString': '0.1.0'}))
            self.assertFalse(matches({**self.info, 'CFBundleIdentifier': 'wrong'}))
        self.assertIn('if not exported_product_matches(info):', source)

    def test_profile_rejects_age_debug_expired_and_device_signing(self):
        public.profile_contract(self.entitlements, self.profile, self.team)
        invalid_cases = [
            lambda e, p: e.update({public.AGE_KEY: True}),
            lambda e, p: e.update({public.AGE_KEY: False}),
            lambda e, p: e.update({'get-task-allow': True}),
            lambda e, p: p['Entitlements'].pop('get-task-allow'),
            lambda e, p: p.update({'ProvisionedDevices': ['SYNTHETIC']}),
            lambda e, p: p.update({'ProvisionsAllDevices': True}),
            lambda e, p: p.update({'ExpirationDate': dt.datetime.now(dt.timezone.utc) - dt.timedelta(days=1)}),
            lambda e, p: p.update({'TeamIdentifier': ['WRONGTEAM1']}),
            lambda e, p: e.update({'application-identifier': 'wrong'}),
        ]
        for index, mutation in enumerate(invalid_cases):
            ent, profile = copy.deepcopy(self.entitlements), copy.deepcopy(self.profile)
            mutation(ent, profile)
            with self.subTest(case=index), self.assertRaises(public.ContractError):
                public.profile_contract(ent, profile, self.team)
        # An unused profile allowance never becomes a claimed App entitlement.
        profile = copy.deepcopy(self.profile)
        profile['Entitlements'][public.AGE_KEY] = True
        public.profile_contract(self.entitlements, profile, self.team)

    def test_same_ipa_guard_rejects_changed_bytes(self):
        with tempfile.TemporaryDirectory() as folder:
            ipa = Path(folder) / 'synthetic.ipa'
            ipa.write_bytes(b'first signed bytes')
            manifest = {'ipa_sha256': hashlib.sha256(ipa.read_bytes()).hexdigest(),
                        'ipa_bytes': ipa.stat().st_size}
            public.verify_digest(ipa, manifest)
            ipa.write_bytes(b'other signed bytes')
            with self.assertRaises(public.ContractError):
                public.verify_digest(ipa, manifest)
            (Path(folder) / 'second.ipa').write_bytes(b'other')
            with self.assertRaises(public.ContractError):
                public.single_ipa(folder)

    def test_source_rejects_moving_ref_before_git_or_credentials(self):
        for value in ('main', 'codex/release', 'a' * 39, 'a' * 40 + '; echo secret'):
            with self.subTest(value=value), self.assertRaises(public.ContractError), \
                    patch.object(public, 'capture', side_effect=AssertionError('must not reach git')):
                public.source_contract(Path.cwd(), value)
        env = {**os.environ, 'EBOOK_TESTED_SHA': 'main'}
        result = subprocess.run([sys.executable, str(Path(public.__file__)), 'source'],
                                env=env, capture_output=True, text=True)
        self.assertEqual(result.returncode, 2)
        self.assertEqual(result.stdout.strip(), 'EBOOK_PUBLIC_CONTRACT_FAILED FULL_READER_SHA_REQUIRED')


if __name__ == '__main__':
    unittest.main(verbosity=2)
