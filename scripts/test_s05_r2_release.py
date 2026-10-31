"""Negative release-tool contracts; synthetic files/mocked OS commands only.

Real signature, Apple API, UI and device evidence are separate CI/owner lanes.
"""
import copy
import datetime
import hashlib
import importlib.util
import json
from pathlib import Path
import plistlib
import subprocess
import tempfile
import unittest
from unittest.mock import patch

spec = importlib.util.spec_from_file_location("rc", Path(__file__).with_name("s05_rc_verify.py"))
rc = importlib.util.module_from_spec(spec)
spec.loader.exec_module(rc)


class ReleaseGuards(unittest.TestCase):
    def test_generated_info_is_narrowly_validated(self):
        valid={"CFBundleDisplayName":"Lecture Asset", "CFBundleShortVersionString":"$(MARKETING_VERSION)",
               "CFBundleVersion":"$(CURRENT_PROJECT_VERSION)", "ITSAppUsesNonExemptEncryption":False,
               "UILaunchScreen":{}, "NSPhotoLibraryUsageDescription":
               "Select lecture photos and delete only the exact selected sources after separate sharing and confirmation steps."}
        with tempfile.TemporaryDirectory() as folder:
            path=Path(folder)/"Info.plist"
            path.write_bytes(plistlib.dumps(valid)); rc.generated_info(path)
            for altered in ({**valid,"CFBundleURLTypes":[]},{**valid,"CFBundleIdentifier":"wrong"},
                            {**valid,"CFBundleDisplayName":"wrong"}):
                path.write_bytes(plistlib.dumps(altered))
                with self.assertRaises(rc.RCError): rc.generated_info(path)

    def test_wrong_bundle_version_build_minimum_os_encryption(self):
        valid = {"CFBundleIdentifier": rc.BUNDLE, "CFBundleVersion": rc.BUILD,
                 "CFBundleShortVersionString": "0.1.0", "MinimumOSVersion": "18.0",
                 "ITSAppUsesNonExemptEncryption": False, "UIDeviceFamily":[1]}
        rc.metadata(valid)
        for key in valid:
            with self.subTest(field=key), self.assertRaises(rc.RCError):
                rc.metadata({**valid, key: True if key == "ITSAppUsesNonExemptEncryption" else "wrong"})

    def test_missing_privacy_and_wrong_compiled_labels(self):
        with tempfile.TemporaryDirectory() as folder:
            app = Path(folder)
            with self.assertRaisesRegex(rc.RCError, "APP_PRIVACY_MANIFEST_MISSING"):
                rc.privacy(app)
            (app / "PrivacyInfo.xcprivacy").write_bytes(plistlib.dumps({}))
            with self.assertRaisesRegex(rc.RCError, "ZIPFOUNDATION_PRIVACY_MANIFEST_MISSING"):
                rc.privacy(app)
            dep = app / "ZIPFoundation_ZIPFoundation.bundle"
            dep.mkdir()
            (dep / "PrivacyInfo.xcprivacy").write_bytes(plistlib.dumps({"NSPrivacyAccessedAPITypes":[
                {"NSPrivacyAccessedAPITypeReasons":["0A2A.1"]}]}))
            rc.privacy(app)
            for locale, label in [("en","Continue"),("zh-Hans","继续")]:
                loc = app / (locale + ".lproj"); loc.mkdir()
                (loc / "Localizable.strings").write_bytes(plistlib.dumps({"permission.allow":label}))
            self.assertEqual(rc.labels(app), {"en":"Continue","zh-Hans":"继续"})
            (app / "en.lproj/Localizable.strings").write_bytes(plistlib.dumps({"permission.allow":"Allow full access"}))
            with self.assertRaisesRegex(rc.RCError, "LOCALIZED_PERMISSION_LABEL_MISMATCH"):
                rc.labels(app)

    def test_digest_mismatch_and_unverified_ipa(self):
        with tempfile.TemporaryDirectory() as folder:
            ipa=Path(folder)/"candidate.ipa"; report=Path(folder)/"signed.json"
            ipa.write_bytes(b"synthetic signed fixture")
            report.write_text(json.dumps({"contract_result":"PASS","ipa_sha256":hashlib.sha256(ipa.read_bytes()).hexdigest()}))
            rc.digest(ipa,report)
            ipa.write_bytes(b"reexported different fixture")
            with self.assertRaisesRegex(rc.RCError,"UPLOADED_IPA_DIGEST_MISMATCH"):
                rc.digest(ipa,report)
            report.write_text(json.dumps({"contract_result":"FAIL"}))
            with self.assertRaisesRegex(rc.RCError,"UNVERIFIED_IPA"):
                rc.digest(ipa,report)

    def test_profile_and_signature_fail_closed(self):
        team="QK73K23W9N"
        ent={"com.apple.developer.declared-age-range":True, "application-identifier":team+"."+rc.BUNDLE,
             "com.apple.developer.team-identifier":team, "get-task-allow":False}
        profile={"Entitlements":copy.deepcopy(ent), "TeamIdentifier":[team],
                 "ExpirationDate":datetime.datetime.now()+datetime.timedelta(days=1)}
        for field in ("get-task-allow","com.apple.developer.declared-age-range"):
            for target in ("app","profile"):
                e,p=copy.deepcopy(ent),copy.deepcopy(profile)
                (e if target=="app" else p["Entitlements"]).pop(field)
                with self.subTest(field=field,target=target),self.assertRaises(rc.RCError):
                    rc.entitlement_contract(e,p,team)
        with tempfile.TemporaryDirectory() as folder:
            app=Path(folder)/"app"; app.mkdir(); ipa=Path(folder)/"a.ipa"; ipa.write_bytes(b"fixture")
            def capture(command):
                return plistlib.dumps(profile if command[0]=="security" else ent)
            for signature_ok, distribution in ((False,True),(True,False)):
                def run(command,**kwargs):
                    is_verify="--verify" in command
                    return subprocess.CompletedProcess(command,0 if (not is_verify or signature_ok) else 1,
                        stdout=b"", stderr=b"Authority=Apple Distribution: synthetic" if distribution else b"Signature=adhoc")
                with patch.object(rc,"capture",capture),patch.object(rc.subprocess,"run",run),patch.dict(rc.os.environ,{"APPLE_TEAM_ID":team}):
                    with self.assertRaises(rc.RCError):
                        rc.signed(app,ipa,Path(folder)/"result.json")

    def test_provenance_source_dirty_and_unexpected_files(self):
        head="a"*40
        cases=[("EXPECTED_SOURCE_SHA_MISMATCH","source"),("FROZEN_PRODUCT_OR_HISTORICAL_UPLOAD_PATH_CHANGED","baseline"),
               ("UNEXPECTED_PRODUCT_FILE","untracked"),("DIRTY_PRODUCT_TREE","dirty"),("DIRTY_RELEASE_INPUT","tooling")]
        for code,case in cases:
            def capture(command):
                if command[1:3]==["rev-parse","HEAD"]: return head.encode()
                if "diff" in command and rc.BASELINE in command: return b"App/changed.swift" if case=="baseline" else b""
                if "ls-files" in command: return b"App/new.swift" if case=="untracked" and "--others" in command else b""
                if command[1:4]==["diff","--name-only","HEAD"]: return b"App/changed.swift" if case=="dirty" else b""
                if command[1:3]==["diff","HEAD"]: return b"changed" if case=="tooling" else b""
                raise AssertionError("Unexpected test command")
            with self.subTest(case=case),patch.object(rc,"capture",capture),patch.dict(rc.os.environ,{"RC_EXPECTED_SOURCE_SHA":"b"*40 if case=="source" else head}):
                with self.assertRaisesRegex(rc.RCError,code): rc.provenance()

    def test_workflow_secrets_are_manual_and_default_is_prepare(self):
        text=Path(".github/workflows/s05-final-rc.yml").read_text(encoding="utf8")
        steps=text.split("      - name: ")
        secret_steps=[s for s in steps if "secrets." in s]
        self.assertEqual(len(secret_steps),1)
        self.assertIn("if: github.event_name == 'workflow_dispatch' && inputs.operation != 'prepare-only'",secret_steps[0])
        text=Path("scripts/s05_final_rc.sh").read_text()
        self.assertIn('${1:-prepare-only}',text)
        self.assertNotIn('[upload-rc-',Path(".github/workflows/s05-final-rc.yml").read_text())
        self.assertEqual(text.count('--digest "$ipa"'),2)
        self.assertIn('assert "testFlightInternalTestingOnly" not in options',text)


if __name__=="__main__":
    unittest.main(verbosity=2)
