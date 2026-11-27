#!/usr/bin/env bash
# Runs only inside the explicitly triggered macOS GitHub Actions release step.
# Keep every Apple secret in Actions Secrets; never print raw xcodebuild signing logs.
set -euo pipefail
set +x
umask 077
[[ "$(git rev-parse HEAD)" == "${EBOOK_TESTED_SHA:?}" ]] || { echo EBOOK_UNTESTED_SOURCE; exit 2; }
operation="${EBOOK_RELEASE_OPERATION:-upload}"
case "$operation" in upload|inspect-export|status-only) ;; *) echo EBOOK_INVALID_OPERATION; exit 2 ;; esac

for name in APPLE_TEAM_ID APP_STORE_CONNECT_KEY_ID APP_STORE_CONNECT_ISSUER_ID APP_STORE_CONNECT_PRIVATE_KEY; do
  if [[ -z "${!name:-}" ]]; then
    echo "MISSING_GITHUB_ACTIONS_SETTING: $name"
    exit 2
  fi
done

[[ "$APPLE_TEAM_ID" =~ ^[A-Z0-9]{10}$ ]] || { echo 'INVALID_TEAM_ID_FORMAT'; exit 2; }
[[ "$APP_STORE_CONNECT_KEY_ID" =~ ^[A-Z0-9]{10}$ ]] || { echo 'INVALID_API_KEY_ID_FORMAT'; exit 2; }
[[ "$APP_STORE_CONNECT_ISSUER_ID" =~ ^[0-9a-fA-F-]{36}$ ]] || { echo 'INVALID_API_ISSUER_ID_FORMAT'; exit 2; }
[[ "$APP_STORE_CONNECT_PRIVATE_KEY" == *'-----BEGIN PRIVATE KEY-----'* ]] || { echo 'INVALID_API_KEY_FILE_FORMAT'; exit 2; }

secret_dir=$(mktemp -d "$RUNNER_TEMP/s00-apple.XXXXXX")
key_file="$secret_dir/AuthKey.p8"
archive_log="$secret_dir/archive.log"
export_log="$secret_dir/export.log"
export_options="$secret_dir/export-options.plist"
trap 'rm -f "$key_file" "$archive_log" "$export_log" "$export_options"; rmdir "$secret_dir"' EXIT
printf '%s' "$APP_STORE_CONNECT_PRIVATE_KEY" > "$key_file"
chmod 600 "$key_file"

if [[ "$operation" == 'status-only' ]]; then
  [[ "${EBOOK_RECHECK_BUILD:-}" =~ ^[0-9]+\.[0-9]+$ ]] || { echo EBOOK_INVALID_RECHECK_BUILD; exit 2; }
  echo "EBOOK_SAME_BUILD_READBACK_START build=$EBOOK_RECHECK_BUILD"
  swift "$EBOOK_BRIDGE_SCRIPTS/ebook_testflight_status.swift" "$key_file" "$EBOOK_RECHECK_BUILD"
  exit $?
fi
if [[ "$operation" == 'inspect-export' ]]; then
  [[ "${EBOOK_RECHECK_BUILD:-}" =~ ^[0-9]+\.[0-9]+$ ]] || { echo EBOOK_INVALID_RECHECK_BUILD; exit 2; }
  result=0
  swift "$EBOOK_BRIDGE_SCRIPTS/ebook_testflight_status.swift" "$key_file" "$EBOOK_RECHECK_BUILD" --once || result=$?
  case "$result" in
    0) exit 0 ;; # Already installable: no new export or upload.
    4) swift "$EBOOK_BRIDGE_SCRIPTS/ebook_testflight_status.swift" "$key_file" "$EBOOK_RECHECK_BUILD"; exit $? ;;
    2|3) ;; # Explicit rejection or an absent build after the failed export.
    *) echo EBOOK_READBACK_INCONCLUSIVE_NO_EXPORT; exit "$result" ;;
  esac
fi

build_number="${GITHUB_RUN_NUMBER}.${GITHUB_RUN_ATTEMPT}"
archive_path="$RUNNER_TEMP/EBOOK-Internal-TestFlight.xcarchive"
export_path="$RUNNER_TEMP/EBOOK-Internal-TestFlight-export"
code_sha=$(git rev-parse HEAD)

python3 - "$export_options" <<'PY'
import os
import plistlib
import sys

options = {
    "destination": "export" if os.environ.get("EBOOK_RELEASE_OPERATION") == "inspect-export" else "upload",
    "manageAppVersionAndBuildNumber": False,
    "method": "app-store-connect",
    "signingStyle": "automatic",
    "teamID": os.environ["APPLE_TEAM_ID"],
    "testFlightInternalTestingOnly": True,
}
with open(sys.argv[1], "wb") as output:
    plistlib.dump(options, output)
PY

echo "EBOOK_RELEASE_START version=0.1.0 build=$build_number code_sha=$code_sha"
if xcodebuild -project eBOOK.xcodeproj -scheme eBOOK \
  -configuration Release -destination 'generic/platform=iOS' \
  -archivePath "$archive_path" -derivedDataPath "$RUNNER_TEMP/EBOOKReleaseDerivedData" \
  CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO \
  CURRENT_PROJECT_VERSION="$build_number" archive > "$archive_log" 2>&1; then
  echo 'EBOOK_UNSIGNED_ARCHIVE_SUCCEEDED'
else
  result=$?
  echo "EBOOK_UNSIGNED_ARCHIVE_FAILED exit=$result"
  python3 "$EBOOK_BRIDGE_SCRIPTS/ebook_testflight_diagnostics.py" "$archive_log"
  exit "$result"
fi

app_info="$archive_path/Products/Applications/eBOOK.app/Info.plist"
test "$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$app_info")" = 'com.zhangsfish.ebook'
test "$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$app_info")" = '0.1.0'
test "$(/usr/libexec/PlistBuddy -c 'Print :CFBundleVersion' "$app_info")" = "$build_number"
echo 'EBOOK_UNSIGNED_ARCHIVE_METADATA_VERIFIED'

python3 - "$archive_path/Products/Applications/eBOOK.app" "$code_sha" "$build_number" <<'PY'
import hashlib
import json
from pathlib import Path
import sys

sys.path.insert(0, str(Path.cwd() / 'scripts'))
from verify_release_bundle import validate_resources

app = Path(sys.argv[1])
resources = validate_resources(app)
metadata = {
    'source_sha': sys.argv[2],
    'build': sys.argv[3],
    'app_bytes': sum(path.stat().st_size for path in app.rglob('*') if path.is_file()),
    'unsigned_executable_sha256': hashlib.sha256((app / 'eBOOK').read_bytes()).hexdigest(),
    **resources,
}
print('EBOOK_ARCHIVE_RESOURCES_VERIFIED ' + json.dumps(metadata, sort_keys=True))
PY

if [[ "$operation" == 'inspect-export' ]]; then
  if xcodebuild -exportArchive -archivePath "$archive_path" \
    -exportOptionsPlist "$export_options" -exportPath "$export_path" \
    -allowProvisioningUpdates -authenticationKeyPath "$key_file" \
    -authenticationKeyID "$APP_STORE_CONNECT_KEY_ID" \
    -authenticationKeyIssuerID "$APP_STORE_CONNECT_ISSUER_ID" > "$export_log" 2>&1; then
    echo 'EBOOK_EXPORT_ONLY_SUCCEEDED_NO_UPLOAD'
    python3 "$EBOOK_BRIDGE_SCRIPTS/ebook_verify_export.py" "$export_path"
    exit $?
  else
    result=$?
    echo "EBOOK_EXPORT_ONLY_FAILED_NO_UPLOAD exit=$result"
    python3 "$EBOOK_BRIDGE_SCRIPTS/ebook_testflight_diagnostics.py" "$export_log"
    exit "$result"
  fi
fi

if xcodebuild -exportArchive -archivePath "$archive_path" \
  -exportOptionsPlist "$export_options" -exportPath "$export_path" \
  -allowProvisioningUpdates \
  -authenticationKeyPath "$key_file" \
  -authenticationKeyID "$APP_STORE_CONNECT_KEY_ID" \
  -authenticationKeyIssuerID "$APP_STORE_CONNECT_ISSUER_ID" \
  > "$export_log" 2>&1; then
  echo "EBOOK_EXPORT_UPLOAD_ACCEPTED version=0.1.0 build=$build_number code_sha=$code_sha"
  if find "$export_path" -type f -name '*.ipa' -print -quit | grep -q .; then
    echo 'EBOOK_IPA_EXPORT_PRESENT'
  else
    echo 'EBOOK_IPA_EXPORT_NOT_RETAINED_BY_XCODE'
  fi
  if ! swift "$EBOOK_BRIDGE_SCRIPTS/ebook_testflight_status.swift" "$key_file" "$build_number"; then
    echo 'EBOOK_UPLOAD_ACCEPTED_PROCESSING_UNCONFIRMED'
  fi
else
  result=$?
  echo "EBOOK_EXPORT_UPLOAD_FAILED exit=$result"
  python3 "$EBOOK_BRIDGE_SCRIPTS/ebook_testflight_diagnostics.py" "$export_log"
  exit "$result"
fi
