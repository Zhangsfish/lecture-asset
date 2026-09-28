"""Inspect effective Xcode Release settings without exposing team or profile data."""

import json
import subprocess
import sys


command = [
    "xcodebuild",
    "-project", "LectureAsset.xcodeproj",
    "-scheme", "LectureAsset",
    "-configuration", "Release",
    "-destination", "generic/platform=iOS",
    "-showBuildSettings", "-json",
]
result = subprocess.run(command, capture_output=True, text=True, check=False)
if result.returncode:
    print(f"S00_SIGNING_SETTINGS_QUERY_FAILED exit={result.returncode}")
    sys.exit(result.returncode)

try:
    targets = json.loads(result.stdout)
    settings = next(item["buildSettings"] for item in targets if item["target"] == "LectureAsset")
except (KeyError, StopIteration, ValueError, TypeError):
    print("S00_SIGNING_SETTINGS_PARSE_FAILED")
    sys.exit(1)


def known(value: str, allowed: set[str]) -> str:
    return value if value in allowed else "OTHER_SET"


print("S00_RELEASE_CODE_SIGN_STYLE=" + known(settings.get("CODE_SIGN_STYLE", "UNSET"), {"Automatic", "Manual", "UNSET"}))
print("S00_RELEASE_CODE_SIGN_IDENTITY=" + known(settings.get("CODE_SIGN_IDENTITY", "UNSET"), {
    "Apple Development", "Apple Distribution", "iPhone Developer", "iPhone Distribution", "UNSET",
}))
print("S00_RELEASE_DEVELOPMENT_TEAM=" + ("SET_REDACTED" if settings.get("DEVELOPMENT_TEAM") else "UNSET"))
print("S00_RELEASE_PROVISIONING_PROFILE_SPECIFIER=" + (
    "SET_REDACTED" if settings.get("PROVISIONING_PROFILE_SPECIFIER") else "UNSET"
))
print("S00_RELEASE_PRODUCT_BUNDLE_IDENTIFIER=" + (
    "com.zhangsfish.lectureasset"
    if settings.get("PRODUCT_BUNDLE_IDENTIFIER") == "com.zhangsfish.lectureasset"
    else "UNEXPECTED_REDACTED"
))
print("S00_RELEASE_CODE_SIGNING_ALLOWED=" + known(settings.get("CODE_SIGNING_ALLOWED", "UNSET"), {"YES", "NO", "UNSET"}))
