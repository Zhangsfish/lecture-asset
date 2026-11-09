"""Assert the ordinary utility entry and absence in the actual Release executable.

Negative assertions never replace genuine distribution codesign/profile checks.
"""
import hashlib
import json
from pathlib import Path
import plistlib
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
FORBIDDEN = (b"AgeAssurance", b"DeclaredAgeRange", b"AgeRangeService", b"requestAgeRange",
             b"ageGates", b"isEligibleForAgeFeatures", b"com.apple.developer.declared-age-range")
AGE_KEY = "com.apple.developer.declared-age-range"
AGE_STRINGS = ("age.unresolvedTitle", "age.unsupported", "age.unresolved", "age.retry")


def require_absent(data):
    # Includes Mach-O imports, Swift symbols, string constants and embedded plist.
    assert not any(token in data for token in FORBIDDEN), "FORBIDDEN_AGE_RUNTIME_REFERENCE"


def source_proof():
    entry = ROOT / "App/LectureAssetApp.swift"
    code = re.sub(r"//[^\n]*", "", entry.read_text(encoding="utf8"))
    assert re.sub(r"\s+", "", code) == (
        "importSwiftUI@mainstructLectureAssetApp:App{varbody:someScene{WindowGroup{ContentView()}}}")
    for folder in ("App", "AppResources", "Packages"):
        for path in (ROOT / folder).rglob("*"):
            if path.is_file() and not any(p.startswith(".") for p in path.relative_to(ROOT / folder).parts):
                require_absent(path.read_bytes())
    require_absent((ROOT / "project.yml").read_bytes())
    assert not (ROOT / "App/LectureAsset.entitlements").exists()
    return {"direct_content_view_entry": True, "active_age_references": 0,
            "source_entry_sha256": hashlib.sha256(entry.read_bytes()).hexdigest(),
            "scope": "Source/config assertion; not physical-device execution"}


def bundle_proof(app, signature_required=True):
    info = plistlib.loads((app / "Info.plist").read_bytes())
    assert info["CFBundleIdentifier"] == "com.zhangsfish.lectureasset"
    assert info["MinimumOSVersion"] == "18.0"
    binary = app / info["CFBundleExecutable"]
    require_absent(binary.read_bytes())
    # Apple tools inspect load commands and symbols too; a failed invocation fails closed.
    for command in (["xcrun", "otool", "-L", str(binary)], ["xcrun", "nm", "-u", str(binary)]):
        output = subprocess.run(command, capture_output=True, check=True).stdout
        require_absent(output)
    for locale in ("en", "zh-Hans"):
        values = plistlib.loads((app / (locale + ".lproj") / "Localizable.strings").read_bytes())
        assert not set(AGE_STRINGS).intersection(values), "ORPHANED_AGE_LOCALIZATION"
    # Simulator uses ad-hoc signing. Extract the real signature, not the source plist.
    if signature_required:
        ent = subprocess.run(["codesign", "-d", "--entitlements", ":-", str(app)], capture_output=True)
        assert ent.returncode == 0, "CANNOT_INSPECT_EXECUTABLE_SIGNATURE"
        if ent.stdout.strip():
            assert AGE_KEY not in plistlib.loads(ent.stdout), "AGE_ENTITLEMENT_PRESENT"
    return {"compiled_age_symbols_imports_strings_absent": True,
            "compiled_age_localizations_absent": True,
            "app_entitlement_age_key_absent": True if signature_required else "NOT_RUN_UNSIGNED_BUILD",
            "executable_sha256": hashlib.sha256(binary.read_bytes()).hexdigest(),
            "codesign_scope": "Ad-hoc simulator signature; NOT Apple Distribution" if signature_required else "Unsigned device Release"}


if __name__ == "__main__":
    result = source_proof()
    unsigned = sys.argv[1] == "--unsigned"
    if sys.argv[1] != "--source-only":
        result.update(bundle_proof(Path(sys.argv[2] if unsigned else sys.argv[1]), not unsigned))
    Path(sys.argv[3] if unsigned else sys.argv[2]).write_text(json.dumps(result, indent=2) + "\n", encoding="utf8")
    print("ORDINARY_APP_ENTRY_AND_ABSENCE_PASS")
