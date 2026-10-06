"""Fail-closed RC provenance, metadata and genuine distribution signature checks.

Never publish raw codesign output, profile contents, certificate identities or keys.
"""
import datetime
import hashlib
import json
import os
from pathlib import Path
import plistlib
import subprocess
import sys

BASELINE = "5012695af687a94af687dc5f631617a66940e3c8"
MAIN = "f217fcebb27b1bef3f86864878baa8f5983b8832"
BUNDLE = "com.zhangsfish.lectureasset"
PROTECTED = ["App", "Packages", "AppResources", "schemas", "project.yml",
             "reports/S05/store-screenshots-01",
             ".github/workflows/s00-testflight.yml", "scripts/s00_testflight_release.sh"]


class RCError(Exception):
    pass


def require(condition, code):
    if not condition:
        raise RCError(code)


def capture(command):
    result = subprocess.run(command, capture_output=True)
    require(result.returncode == 0, "COMMAND_FAILED_" + Path(command[0]).name.upper())
    return result.stdout


def metadata(info):
    expected = {"CFBundleIdentifier": BUNDLE, "CFBundleShortVersionString": "0.1.0",
                "CFBundleVersion": "32.1", "MinimumOSVersion": "18.0"}
    for key, value in expected.items():
        require(info.get(key) == value, "METADATA_MISMATCH_" + key)
    require(info.get("ITSAppUsesNonExemptEncryption") is False, "ENCRYPTION_FLAG_MISMATCH")
    return {**expected, "ITSAppUsesNonExemptEncryption": False}


def privacy(app):
    root = app / "PrivacyInfo.xcprivacy"
    require(root.is_file(), "APP_PRIVACY_MANIFEST_MISSING")
    manifests = sorted(app.rglob("PrivacyInfo.xcprivacy"))
    for file in manifests:
        plistlib.loads(file.read_bytes())
    dependency = [file for file in manifests if file != root and "ZIPFoundation" in str(file.relative_to(app))]
    require(any(any("0A2A.1" in row.get("NSPrivacyAccessedAPITypeReasons", [])
                    for row in plistlib.loads(file.read_bytes()).get("NSPrivacyAccessedAPITypes", []))
                for file in dependency), "ZIPFOUNDATION_PRIVACY_MANIFEST_MISSING")
    return {"app_manifest": True, "zipfoundation_manifest": True,
            "bundled_manifest_paths": [str(file.relative_to(app)) for file in manifests]}


def entitlement_contract(entitlements, profile, team):
    expected_app = team + "." + BUNDLE
    require(entitlements.get("com.apple.developer.declared-age-range") is True,
            "SIGNED_DECLARED_AGE_RANGE_MISSING")
    require(entitlements.get("application-identifier") == expected_app, "SIGNED_APP_IDENTIFIER_MISMATCH")
    require(entitlements.get("com.apple.developer.team-identifier") == team, "SIGNED_TEAM_MISMATCH")
    require(entitlements.get("get-task-allow") is not True, "SIGNED_DEBUG_ENTITLEMENT")
    allowed = profile.get("Entitlements", {})
    require(allowed.get("com.apple.developer.declared-age-range") is True,
            "DISTRIBUTION_PROFILE_DECLARED_AGE_RANGE_MISSING")
    require(allowed.get("application-identifier") == expected_app, "PROFILE_APP_IDENTIFIER_MISMATCH")
    require(allowed.get("com.apple.developer.team-identifier") == team, "PROFILE_TEAM_MISMATCH")
    require(allowed.get("get-task-allow") is not True, "PROFILE_DEBUG_ENTITLEMENT")
    require(team in profile.get("TeamIdentifier", []), "PROFILE_TEAM_IDENTIFIER_MISMATCH")
    require(not profile.get("ProvisionedDevices") and not profile.get("ProvisionsAllDevices"),
            "PROFILE_NOT_APP_STORE_DISTRIBUTION")
    expiry = profile.get("ExpirationDate")
    require(isinstance(expiry, datetime.datetime), "PROFILE_EXPIRY_MISSING")
    require(expiry.replace(tzinfo=datetime.timezone.utc) > datetime.datetime.now(datetime.timezone.utc),
            "PROFILE_EXPIRED")
    return {"declared_age_range": True, "application_identifier_correct": True,
            "team_identifier_correct": True, "get_task_allow_not_true": True,
            "profile_declared_age_range": True, "app_store_distribution_profile": True,
            "profile_not_expired": True}


def signed(app, ipa):
    capture(["codesign", "--verify", "--deep", "--strict", str(app)])
    ent = plistlib.loads(capture(["codesign", "-d", "--entitlements", ":-", str(app)]))
    profile_bytes = capture(["security", "cms", "-D", "-i", str(app / "embedded.mobileprovision")])
    profile = plistlib.loads(profile_bytes)
    detail = subprocess.run(["codesign", "-dv", "--verbose=4", str(app)], capture_output=True)
    require(detail.returncode == 0, "CODESIGN_DETAIL_FAILED")
    # Certificate/account display names stay private; expose only the type check.
    authority = detail.stderr.decode("utf8", "replace")
    require("Authority=Apple Distribution:" in authority or "Authority=iPhone Distribution:" in authority,
            "APPLE_DISTRIBUTION_CERTIFICATE_NOT_CONFIRMED")
    result = entitlement_contract(ent, profile, os.environ["APPLE_TEAM_ID"])
    return {"codesign_verification": "PASS", "apple_distribution_certificate": True,
            "signed_entitlements": result, "metadata": metadata(plistlib.loads((app / "Info.plist").read_bytes())),
            "privacy": privacy(app), "ipa_sha256": hashlib.sha256(ipa.read_bytes()).hexdigest(),
            "raw_profile_retained_or_published": False}


def self_test():
    import copy
    team = "SYNTHETIC0"
    ent = {"com.apple.developer.declared-age-range": True, "application-identifier": team + "." + BUNDLE,
           "com.apple.developer.team-identifier": team, "get-task-allow": False}
    profile = {"Entitlements": copy.deepcopy(ent), "TeamIdentifier": [team],
               "ExpirationDate": datetime.datetime.now() + datetime.timedelta(days=1)}
    entitlement_contract(ent, profile, team)
    mutations = [
        ("signed age absent", lambda e, p: e.pop("com.apple.developer.declared-age-range")),
        ("signed age false", lambda e, p: e.update({"com.apple.developer.declared-age-range": False})),
        ("signed wrong app", lambda e, p: e.update({"application-identifier": "wrong"})),
        ("signed wrong team", lambda e, p: e.update({"com.apple.developer.team-identifier": "wrong"})),
        ("signed debug", lambda e, p: e.update({"get-task-allow": True})),
        ("profile age absent", lambda e, p: p["Entitlements"].pop("com.apple.developer.declared-age-range")),
        ("development/ad-hoc profile", lambda e, p: p.update({"ProvisionedDevices": ["SYNTHETIC"]})),
        ("enterprise profile", lambda e, p: p.update({"ProvisionsAllDevices": True})),
        ("expired profile", lambda e, p: p.update({"ExpirationDate": datetime.datetime.now() - datetime.timedelta(days=1)})),
    ]
    for name, mutation in mutations:
        e, p = copy.deepcopy(ent), copy.deepcopy(profile)
        mutation(e, p)
        try:
            entitlement_contract(e, p, team)
        except RCError:
            continue
        raise RCError("SELF_TEST_ACCEPTED_INVALID_ASSET")
    return {"valid_synthetic_contract": "PASS", "negative_contract_cases": len(mutations),
            "result": "PASS", "scope": "Validator logic only; NOT genuine signing evidence"}


def main():
    mode = sys.argv[1]
    if mode == "--provenance":
        require(not capture(["git", "diff", "--name-only", BASELINE, "HEAD", "--", *PROTECTED]).strip(),
                "FROZEN_PRODUCT_OR_HISTORICAL_UPLOAD_PATH_CHANGED")
        dirty = capture(["git", "diff", "--name-only", "HEAD", "--", *PROTECTED]).decode().splitlines()
        # XcodeGen may serialize the existing entitlement plist differently.
        # Only identical plist contents qualify; no new/missing capability is allowed.
        require(not dirty or dirty == ["App/LectureAsset.entitlements"],
                "GENERATED_PROJECT_CHANGED_FROZEN_FILES")
        if dirty:
            require(plistlib.loads(Path(dirty[0]).read_bytes()) ==
                    plistlib.loads(capture(["git", "show", "HEAD:" + dirty[0]])),
                    "GENERATED_ENTITLEMENT_CONTENT_CHANGED")
        result = {"product_baseline_sha": BASELINE, "current_main_at_start": MAIN,
                  "release_checkout_sha": capture(["git", "rev-parse", "HEAD"]).decode().strip(),
                  "protected_paths": PROTECTED, "product_sources_identical": True,
                  "historical_internal_pipeline_unchanged": True,
                  "xcodegen_entitlement_format_only": bool(dirty)}
        output = sys.argv[2]
    elif mode == "--self-test":
        result, output = self_test(), sys.argv[2]
    elif mode == "--metadata":
        app = Path(sys.argv[2])
        result = {"metadata": metadata(plistlib.loads((app / "Info.plist").read_bytes())), "privacy": privacy(app)}
        output = sys.argv[3]
    elif mode == "--signed":
        result, output = signed(Path(sys.argv[2]), Path(sys.argv[3])), sys.argv[4]
    else:
        raise RCError("INVALID_MODE")
    Path(output).write_text(json.dumps(result, indent=2) + "\n", encoding="utf8")
    print("S05_RC_VERIFY_PASS " + mode)


if __name__ == "__main__":
    try:
        main()
    except RCError as error:
        print("S05_RC_VERIFY_FAILED " + str(error))
        sys.exit(1)
    except Exception:
        print("S05_RC_VERIFY_FAILED PRIVATE_DETAIL_SUPPRESSED")
        sys.exit(1)
