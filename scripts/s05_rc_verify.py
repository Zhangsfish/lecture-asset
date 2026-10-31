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

# Independent PR22 audit covers this immutable production baseline.
BASELINE = "6a2be31f27ee90ad094bc8b003c9484e81fb6803"
MAIN = "14f91942f19e80c1afaabbd2445692fdd60b9da9"
CONFIG = Path("reports/S05/submission-closeout-2026-10-31/round-01/candidate.json")
CANDIDATE = json.loads(CONFIG.read_text(encoding="utf8"))
VERSION = CANDIDATE["version"]
BUILD = CANDIDATE["build"]
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
    expected = {"CFBundleIdentifier": BUNDLE, "CFBundleShortVersionString": VERSION,
                "CFBundleVersion": BUILD, "MinimumOSVersion": "18.0"}
    for key, value in expected.items():
        require(info.get(key) == value, "METADATA_MISMATCH_" + key)
    require(info.get("UIDeviceFamily") == [1], "DEVICE_FAMILY_MISMATCH")
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


def age_state(values):
    key = "com.apple.developer.declared-age-range"
    return "missing" if key not in values else ("true" if values[key] is True else "false")


def age_contract(entitlements, profile):
    require(profile.get("Entitlements", {}).get("com.apple.developer.declared-age-range") is True,
            "DISTRIBUTION_PROFILE_DECLARED_AGE_RANGE_REGRESSED")
    require(entitlements.get("com.apple.developer.declared-age-range") is True,
            "DISTRIBUTION_SIGNED_ENTITLEMENT_DROPPED_AFTER_ADHOC_BRIDGE")


def entitlement_contract(entitlements, profile, team):
    expected_app = team + "." + BUNDLE
    age_contract(entitlements, profile)
    require(entitlements.get("application-identifier") == expected_app, "SIGNED_APP_IDENTIFIER_MISMATCH")
    require(entitlements.get("com.apple.developer.team-identifier") == team, "SIGNED_TEAM_MISMATCH")
    require(entitlements.get("get-task-allow") is False, "SIGNED_DEBUG_ENTITLEMENT")
    allowed = profile.get("Entitlements", {})
    require(allowed.get("application-identifier") == expected_app, "PROFILE_APP_IDENTIFIER_MISMATCH")
    require(allowed.get("com.apple.developer.team-identifier") == team, "PROFILE_TEAM_MISMATCH")
    require(allowed.get("get-task-allow") is False, "PROFILE_DEBUG_ENTITLEMENT")
    require(team in profile.get("TeamIdentifier", []), "PROFILE_TEAM_IDENTIFIER_MISMATCH")
    require(not profile.get("ProvisionedDevices") and not profile.get("ProvisionsAllDevices"),
            "PROFILE_NOT_APP_STORE_DISTRIBUTION")
    expiry = profile.get("ExpirationDate")
    require(isinstance(expiry, datetime.datetime), "PROFILE_EXPIRY_MISSING")
    require(expiry.replace(tzinfo=datetime.timezone.utc) > datetime.datetime.now(datetime.timezone.utc),
            "PROFILE_EXPIRED")
    return {"declared_age_range": True, "application_identifier_correct": True,
            "team_identifier_correct": True, "get_task_allow_false": True,
            "profile_declared_age_range": True, "app_store_distribution_profile": True,
            "profile_not_expired": True}


def signed(app, ipa, output):
    # Profile is decoded first; App entitlement is independently read second.
    profile = plistlib.loads(capture(["security", "cms", "-D", "-i", str(app / "embedded.mobileprovision")]))
    ent = plistlib.loads(capture(["codesign", "-d", "--entitlements", ":-", str(app)]))
    verification = subprocess.run(["codesign", "--verify", "--deep", "--strict", str(app)], capture_output=True)
    detail = subprocess.run(["codesign", "-dv", "--verbose=4", str(app)], capture_output=True)
    authority = detail.stderr.decode("utf8", "replace")
    is_distribution = detail.returncode == 0 and ("Authority=Apple Distribution:" in authority or "Authority=iPhone Distribution:" in authority)
    team = os.environ["APPLE_TEAM_ID"]
    allowed = profile.get("Entitlements", {})
    profile_type = ("enterprise" if profile.get("ProvisionsAllDevices") else
                    "development" if allowed.get("get-task-allow") is True else
                    "ad-hoc" if profile.get("ProvisionedDevices") else "app-store")
    def safe_boolean(values, key):
        value = values.get(key)
        return value if type(value) is bool else "missing" if key not in values else "INVALID_REDACTED"
    result = {
        "codesign_verification": "PASS" if verification.returncode == 0 else "FAIL",
        "distribution_profile_declared_age_range": age_state(allowed),
        "signed_app_declared_age_range": age_state(ent),
        "signed_application_identifier_correct": ent.get("application-identifier") == team + "." + BUNDLE,
        "application_identifier_correct": allowed.get("application-identifier") == team + "." + BUNDLE,
        "signed_team_identifier_correct": ent.get("com.apple.developer.team-identifier") == team,
        "team_identifier_correct": allowed.get("com.apple.developer.team-identifier") == team and team in profile.get("TeamIdentifier", []),
        "signed_get_task_allow": safe_boolean(ent, "get-task-allow"),
        "get_task_allow": safe_boolean(allowed, "get-task-allow"),
        "profile_type": profile_type,
        "apple_distribution_certificate": is_distribution,
        "raw_profile_retained_or_published": False,
        "contract_result": "NOT_CHECKED"
    }
    with ipa.open("rb") as file:
        tests = result.get("tests", {})
        if tests.get("failedTests") == 0 and tests.get("passedTests", 0) >= 18 and tests.get("skippedTests") == 0:
            result["tested_sha"] = result["release_checkout_sha"]
        result["ipa_sha256"] = hashlib.file_digest(file, "sha256").hexdigest()
    def persist():
        Path(output).write_text(json.dumps(result, indent=2) + "\n", encoding="utf8")
    persist()
    try:
        # Age classification is profile-first, even when both fields are missing.
        result["signed_entitlements"] = entitlement_contract(ent, profile, team)
        require(verification.returncode == 0, "CODESIGN_VERIFICATION_FAILED")
        require(is_distribution, "APPLE_DISTRIBUTION_CERTIFICATE_NOT_CONFIRMED")
        result["metadata"] = metadata(plistlib.loads((app / "Info.plist").read_bytes()))
        result["privacy"] = privacy(app)
        result["localized_permission_labels"] = labels(app)
    except RCError as error:
        result.update(contract_result="FAIL", failure_code=str(error))
        persist()
        raise
    result["contract_result"] = "PASS"
    return result


def labels(app):
    result = {}
    for locale, expected in [("en", "Continue"), ("zh-Hans", "继续")]:
        path = app / (locale + ".lproj") / "Localizable.strings"
        require(path.is_file(), "LOCALIZED_STRINGS_MISSING")
        # Compiled .strings are binary plists in the real Release product.
        values = plistlib.loads(path.read_bytes())
        require(values.get("permission.allow") == expected, "LOCALIZED_PERMISSION_LABEL_MISMATCH")
        result[locale] = expected
    return result


def generated_info(path):
    """XcodeGen creates this untracked file from immutable project.yml.

    Do not allow arbitrary untracked App sources. Validate the sole generated
    plist against the committed project properties and benign XcodeGen defaults.
    """
    values = plistlib.loads(path.read_bytes())
    expected = {
        "CFBundleDisplayName":"Lecture Asset", "CFBundleShortVersionString":"$(MARKETING_VERSION)",
        "CFBundleVersion":"$(CURRENT_PROJECT_VERSION)", "ITSAppUsesNonExemptEncryption":False,
        "UILaunchScreen":{}, "NSPhotoLibraryUsageDescription":
        "Select lecture photos and delete only the exact selected sources after separate sharing and confirmation steps."
    }
    for key, value in expected.items():
        require(values.get(key) == value, "GENERATED_INFO_PROPERTY_MISMATCH")
    defaults = {"CFBundleDevelopmentRegion":["$(DEVELOPMENT_LANGUAGE)","en"],
                "CFBundleExecutable":["$(EXECUTABLE_NAME)"], "CFBundleIdentifier":["$(PRODUCT_BUNDLE_IDENTIFIER)"],
                "CFBundleInfoDictionaryVersion":["6.0"], "CFBundleName":["$(PRODUCT_NAME)"],
                "CFBundlePackageType":["$(PRODUCT_BUNDLE_PACKAGE_TYPE)","APPL"],
                "CFBundleSignature":["????"], "LSRequiresIPhoneOS":[True]}
    require(set(values) <= set(expected) | set(defaults), "GENERATED_INFO_UNEXPECTED_PROPERTY")
    for key, allowed in defaults.items():
        require(key not in values or values[key] in allowed, "GENERATED_INFO_DEFAULT_MISMATCH")
    return hashlib.sha256(path.read_bytes()).hexdigest()


def provenance():
    require(CANDIDATE["audited_product_baseline"] == BASELINE and CANDIDATE["base_main"] == MAIN,
            "AUDITED_BASELINE_MISMATCH")
    require(CANDIDATE["bundle_id"] == BUNDLE and VERSION == "0.1.0" and
            CANDIDATE["team_id"] == "QK73K23W9N" and CANDIDATE["minimum_os"] == "18.0", "CANDIDATE_CONFIG_MISMATCH")
    require(BUILD == "35.1", "CANDIDATE_BUILD_NOT_AUTHORIZED")
    head = capture(["git", "rev-parse", "HEAD"]).decode().strip()
    expected = os.environ.get("RC_EXPECTED_SOURCE_SHA", head)
    require(expected == head, "EXPECTED_SOURCE_SHA_MISMATCH")
    require(not capture(["git", "diff", "--name-only", BASELINE, "HEAD", "--", *PROTECTED]).strip(),
            "FROZEN_PRODUCT_OR_HISTORICAL_UPLOAD_PATH_CHANGED")
    tracked = capture(["git", "ls-files", "--", *PROTECTED]).decode().splitlines()
    untracked = capture(["git", "ls-files", "--others", "--exclude-standard", "--", *PROTECTED]).decode().splitlines()
    require(set(untracked) <= {"App/Info.plist", "Packages/ArchiveCore/Package.resolved"}, "UNEXPECTED_PRODUCT_FILE")
    generated_hash = generated_info(Path("App/Info.plist")) if "App/Info.plist" in untracked else None
    if "Packages/ArchiveCore/Package.resolved" in untracked:
        package_lock(Path("Packages/ArchiveCore/Package.resolved"))
    dirty = capture(["git", "diff", "--name-only", "HEAD", "--", *PROTECTED]).decode().splitlines()
    require(not dirty or dirty == ["App/LectureAsset.entitlements"], "DIRTY_PRODUCT_TREE")
    if dirty:
        require(plistlib.loads(Path(dirty[0]).read_bytes()) ==
                plistlib.loads(capture(["git", "show", "HEAD:" + dirty[0]])), "GENERATED_ENTITLEMENT_CONTENT_CHANGED")
    # Bind all executable release inputs too. Permit only the documented semantic
    # XcodeGen rewrite in the protected entitlement file.
    release_inputs = ["scripts/s05_rc_verify.py", "scripts/s05_rc_status.swift", "scripts/s05_rc_bridge.py",
                      "scripts/s05_final_rc.sh", "scripts/s05_r2_asc.swift", ".github/workflows/s05-final-rc.yml", str(CONFIG)]
    require(not capture(["git", "diff", "HEAD", "--", *release_inputs]).strip(), "DIRTY_RELEASE_INPUT")
    hashes = {}
    for name in tracked:
        data = Path(name).read_bytes()
        if name == "App/LectureAsset.entitlements":
            data = plistlib.dumps(plistlib.loads(data), sort_keys=True)
        hashes[name] = hashlib.sha256(data).hexdigest()
    return {"product_baseline_sha": BASELINE, "current_main_at_start": MAIN,
            "release_checkout_sha": head, "protected_paths": PROTECTED,
            "product_sources_identical": True, "production_file_sha256": hashes,
            "historical_internal_pipeline_unchanged": True, "xcodegen_entitlement_format_only":bool(dirty),
            "validated_generated_info_sha256":generated_hash}


def package_lock(path):
    # SwiftPM creates a lock for swift test. Xcode resolves the same exact dependency.
    # The peeled 0.9.20 upstream tag was independently checked with git ls-remote.
    lock = json.loads(path.read_text())
    require(lock.get("version") in (2, 3), "GENERATED_PACKAGE_LOCK_FORMAT")
    pins = lock.get("pins", [])
    require(len(pins) == 1, "UNEXPECTED_RUNTIME_DEPENDENCY")
    pin = pins[0]
    require(pin.get("identity") == "zipfoundation" and pin.get("kind") == "remoteSourceControl" and
            pin.get("location") == "https://github.com/weichsel/ZIPFoundation.git" and
            pin.get("state") == {"revision":"22787ffb59de99e5dc1fbfe80b19c97a904ad48d", "version":"0.9.20"},
            "UNEXPECTED_RUNTIME_DEPENDENCY")


def digest(ipa, signed_report):
    signed = json.loads(signed_report.read_text())
    require(signed.get("contract_result") == "PASS", "UNVERIFIED_IPA")
    with ipa.open("rb") as file: actual = hashlib.file_digest(file, "sha256").hexdigest()
    require(actual == signed.get("ipa_sha256"), "UPLOADED_IPA_DIGEST_MISMATCH")
    return {"ipa_sha256":actual, "same_verified_signed_ipa":True}


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
    diagnostic_cases = 0
    for signed_state in ("true", "false", "missing"):
        for profile_state in ("true", "false", "missing"):
            e, p = copy.deepcopy(ent), copy.deepcopy(profile)
            key = "com.apple.developer.declared-age-range"
            for values, state in ((e, signed_state), (p["Entitlements"], profile_state)):
                if state == "missing": values.pop(key)
                else: values[key] = state == "true"
                require(age_state(values) == state, "SELF_TEST_WRONG_AGE_OBSERVATION")
            expected = ("DISTRIBUTION_PROFILE_DECLARED_AGE_RANGE_REGRESSED" if profile_state != "true" else
                        "DISTRIBUTION_SIGNED_ENTITLEMENT_DROPPED_AFTER_ADHOC_BRIDGE" if signed_state != "true" else None)
            try:
                age_contract(e, p)
                require(expected is None, "SELF_TEST_MISSED_DIAGNOSTIC")
            except RCError as error:
                require(str(error) == expected, "SELF_TEST_WRONG_DIAGNOSTIC")
            diagnostic_cases += 1
    return {"valid_synthetic_contract": "PASS", "negative_contract_cases": len(mutations),
            "distribution_diagnostic_cases": diagnostic_cases,
            "result": "PASS", "scope": "Validator logic only; NOT genuine signing evidence"}


def main():
    mode = sys.argv[1]
    if mode == "--provenance":
        result = provenance()
        output = sys.argv[2]
    elif mode == "--digest":
        result, output = digest(Path(sys.argv[2]), Path(sys.argv[3])), sys.argv[4]
    elif mode == "--manifest":
        directory, output = Path(sys.argv[2]), sys.argv[3]
        result = provenance()
        result.update(version=VERSION, build=BUILD, app_id=CANDIDATE["app_id"], bundle_id=BUNDLE,
                      team_id=CANDIDATE["team_id"], tested_sha=None,
                      workflow_run=os.environ.get("GITHUB_SERVER_URL", "") + "/" + os.environ.get("GITHUB_REPOSITORY", "") + "/actions/runs/" + os.environ.get("GITHUB_RUN_ID", ""))
        for name in ("signed-distribution", "upload", "asc-status", "tests"):
            path = directory / (name + ".json")
            if path.is_file(): result[name] = json.loads(path.read_text())
        tests = result.get("tests", {})
        if tests.get("failedTests") == 0 and tests.get("passedTests", 0) >= 18 and tests.get("skippedTests") == 0:
            result["tested_sha"] = result["release_checkout_sha"]
        result["ipa_sha256"] = result.get("signed-distribution", {}).get("ipa_sha256")
        result["independently_audited_candidate"] = False
    elif mode == "--self-test":
        result, output = self_test(), sys.argv[2]
    elif mode == "--metadata":
        app = Path(sys.argv[2])
        result = {"metadata": metadata(plistlib.loads((app / "Info.plist").read_bytes())), "privacy": privacy(app), "localized_permission_labels": labels(app)}
        output = sys.argv[3]
    elif mode == "--signed":
        output = sys.argv[4]
        result = signed(Path(sys.argv[2]), Path(sys.argv[3]), output)
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
