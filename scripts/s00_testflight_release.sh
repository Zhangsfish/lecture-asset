#!/usr/bin/env bash
# Runs only inside the explicitly triggered macOS GitHub Actions release step.
# Keep every Apple secret in Actions Secrets; never print raw xcodebuild signing logs.
set -euo pipefail
set +x
umask 077

for name in S00_APPLE_TEAM_ID S00_ASC_API_KEY_ID S00_ASC_API_ISSUER_ID S00_ASC_API_KEY_P8; do
  if [[ -z "${!name:-}" ]]; then
    echo "MISSING_GITHUB_ACTIONS_SECRET: $name"
    exit 2
  fi
done

[[ "$S00_APPLE_TEAM_ID" =~ ^[A-Z0-9]{10}$ ]] || { echo 'INVALID_TEAM_ID_FORMAT'; exit 2; }
[[ "$S00_ASC_API_KEY_ID" =~ ^[A-Z0-9]{10}$ ]] || { echo 'INVALID_API_KEY_ID_FORMAT'; exit 2; }
[[ "$S00_ASC_API_ISSUER_ID" =~ ^[0-9a-fA-F-]{36}$ ]] || { echo 'INVALID_API_ISSUER_ID_FORMAT'; exit 2; }
[[ "$S00_ASC_API_KEY_P8" == *'-----BEGIN PRIVATE KEY-----'* ]] || { echo 'INVALID_API_KEY_FILE_FORMAT'; exit 2; }

secret_dir=$(mktemp -d "$RUNNER_TEMP/s00-apple.XXXXXX")
key_file="$secret_dir/AuthKey.p8"
archive_log="$secret_dir/archive.log"
export_log="$secret_dir/export.log"
export_options="$secret_dir/export-options.plist"
trap 'rm -f "$key_file" "$archive_log" "$export_log" "$export_options"; rmdir "$secret_dir"' EXIT
printf '%s' "$S00_ASC_API_KEY_P8" > "$key_file"
chmod 600 "$key_file"

build_number="${GITHUB_RUN_NUMBER}.${GITHUB_RUN_ATTEMPT}"
archive_path="$RUNNER_TEMP/S00-TestFlight.xcarchive"
export_path="$RUNNER_TEMP/S00-TestFlight-export"
code_sha=$(git rev-parse HEAD)

python3 - "$export_options" <<'PY'
import os
import plistlib
import sys

options = {
    "destination": "upload",
    "manageAppVersionAndBuildNumber": False,
    "method": "app-store-connect",
    "signingStyle": "automatic",
    "teamID": os.environ["S00_APPLE_TEAM_ID"],
    "testFlightInternalTestingOnly": True,
}
with open(sys.argv[1], "wb") as output:
    plistlib.dump(options, output)
PY

echo "S00_RELEASE_START version=0.1.0 build=$build_number code_sha=$code_sha"
if xcodebuild -project LectureAsset.xcodeproj -scheme LectureAsset \
  -configuration Release -destination 'generic/platform=iOS' \
  -archivePath "$archive_path" -derivedDataPath "$RUNNER_TEMP/S00ReleaseDerivedData" \
  -allowProvisioningUpdates \
  -authenticationKeyPath "$key_file" \
  -authenticationKeyID "$S00_ASC_API_KEY_ID" \
  -authenticationKeyIssuerID "$S00_ASC_API_ISSUER_ID" \
  DEVELOPMENT_TEAM="$S00_APPLE_TEAM_ID" CODE_SIGN_STYLE=Automatic \
  CURRENT_PROJECT_VERSION="$build_number" archive > "$archive_log" 2>&1; then
  echo 'S00_ARCHIVE_SUCCEEDED'
else
  result=$?
  echo "S00_ARCHIVE_FAILED exit=$result"
  python3 scripts/s00_testflight_diagnostics.py "$archive_log"
  exit "$result"
fi

app_info="$archive_path/Products/Applications/Lecture Asset.app/Info.plist"
test "$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$app_info")" = 'com.zhangsfish.lectureasset'
test "$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$app_info")" = '0.1.0'
test "$(/usr/libexec/PlistBuddy -c 'Print :CFBundleVersion' "$app_info")" = "$build_number"
echo 'S00_ARCHIVE_METADATA_VERIFIED'

if xcodebuild -exportArchive -archivePath "$archive_path" \
  -exportOptionsPlist "$export_options" -exportPath "$export_path" \
  -allowProvisioningUpdates \
  -authenticationKeyPath "$key_file" \
  -authenticationKeyID "$S00_ASC_API_KEY_ID" \
  -authenticationKeyIssuerID "$S00_ASC_API_ISSUER_ID" \
  > "$export_log" 2>&1; then
  echo "S00_EXPORT_UPLOAD_ACCEPTED version=0.1.0 build=$build_number code_sha=$code_sha"
  if ! swift scripts/s00_testflight_status.swift "$key_file" "$build_number"; then
    echo 'S00_UPLOAD_ACCEPTED_PROCESSING_UNCONFIRMED'
  fi
else
  result=$?
  echo "S00_EXPORT_UPLOAD_FAILED exit=$result"
  python3 scripts/s00_testflight_diagnostics.py "$export_log"
  exit "$result"
fi
