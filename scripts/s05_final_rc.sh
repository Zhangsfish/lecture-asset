#!/usr/bin/env bash
# Explicit S05-R2 dispatch only; credentials never used by ordinary pushes.
set -euo pipefail
set +x
umask 077

operation="${1:-prepare-only}"
if [[ "$operation" == prepare-only ]]; then
  echo 'S05_RC_PREPARE_ONLY_NO_CREDENTIAL_USE'
  exit 0
fi
[[ "$operation" == upload || "$operation" == status-only || "$operation" == readback-only || "$operation" == internal-only ]] || exit 2
for name in APPLE_TEAM_ID APP_STORE_CONNECT_KEY_ID APP_STORE_CONNECT_ISSUER_ID APP_STORE_CONNECT_PRIVATE_KEY; do
  [[ -n "${!name:-}" ]] || { echo "S05_RC_MISSING_SETTING $name"; exit 2; }
done
[[ "$APPLE_TEAM_ID" =~ ^[A-Z0-9]{10}$ ]] || { echo 'S05_RC_INVALID_TEAM_FORMAT'; exit 2; }
[[ "$APP_STORE_CONNECT_KEY_ID" =~ ^[A-Z0-9]{10}$ ]] || { echo 'S05_RC_INVALID_KEY_ID_FORMAT'; exit 2; }
[[ "$APP_STORE_CONNECT_ISSUER_ID" =~ ^[0-9a-fA-F-]{36}$ ]] || { echo 'S05_RC_INVALID_ISSUER_FORMAT'; exit 2; }
[[ "$APP_STORE_CONNECT_PRIVATE_KEY" == *'-----BEGIN PRIVATE KEY-----'* ]] || { echo 'S05_RC_INVALID_KEY_FORMAT'; exit 2; }

private_dir=$(mktemp -d "$RUNNER_TEMP/s05-rc-private.XXXXXX")
trap 'rm -rf "$private_dir"' EXIT
key_file="$private_dir/AuthKey_${APP_STORE_CONNECT_KEY_ID}.p8"
printf '%s' "$APP_STORE_CONNECT_PRIVATE_KEY" > "$key_file"
chmod 600 "$key_file"
unset APP_STORE_CONNECT_PRIVATE_KEY
RC_BUILD=$(python3 -c 'import json; print(json.load(open("reports/S05/submission-closeout-2026-10-31/round-01/candidate.json"))["build"])')
export RC_BUILD
python3 - <<'PY'
import json, os
candidate = json.load(open('reports/S05/submission-closeout-2026-10-31/round-01/candidate.json'))
assert os.environ['APPLE_TEAM_ID'] == candidate['team_id'], 'S05_RC_TEAM_CONFIG_MISMATCH'
PY
evidence="$RUNNER_TEMP/s05-rc-evidence"
mkdir -p "$evidence"
export API_PRIVATE_KEYS_DIR="$private_dir"
archive="$private_dir/LectureAsset-RC.xcarchive"
export_dir="$private_dir/export"

if [[ "$operation" == readback-only || "$operation" == internal-only ]]; then
  mode=readback
  [[ "$operation" != internal-only ]] || mode=internal
  swift scripts/s05_r2_asc.swift "$key_file" "$mode" "$evidence/asc-$mode.json"
  exit $?
fi
if [[ "$operation" == 'status-only' ]]; then
  swift scripts/s05_rc_status.swift "$key_file" poll "$evidence/asc-status.json"
  exit $?
fi
[[ "$operation" == 'upload' ]] || { echo 'S05_RC_INVALID_OPERATION'; exit 2; }

# Exact candidate must not exist; never re-upload this immutable build number.
swift scripts/s05_rc_status.swift "$key_file" preflight "$evidence/asc-preflight.json"
python3 scripts/s05_rc_verify.py --provenance "$evidence/provenance.json"

python3 - "$private_dir/export-options.plist" <<'PY'
import os, plistlib, sys
options = {"destination": "export", "method": "app-store-connect",
           "signingStyle": "automatic", "teamID": os.environ["APPLE_TEAM_ID"],
           "manageAppVersionAndBuildNumber": False}
assert "testFlightInternalTestingOnly" not in options
with open(sys.argv[1], "wb") as file: plistlib.dump(options, file)
PY

private_command() {
  local stage="$1"; shift
  if "$@" > "$private_dir/$stage.log" 2>&1; then
    echo "S05_RC_STAGE_PASS $stage"
  else
    local result=$?
    echo "S05_RC_STAGE_FAILED $stage exit=$result"
    # Existing fixed-vocabulary diagnostics redact account/certificate/key/path data.
    python3 scripts/s00_testflight_diagnostics.py "$private_dir/$stage.log" > "$evidence/$stage-diagnostic.txt"
    cat "$evidence/$stage-diagnostic.txt"
    exit "$result"
  fi
}

# Remove only cached provisioning files on this disposable runner, not Portal assets.
for cache in "$HOME/Library/MobileDevice/Provisioning Profiles" "$HOME/Library/Developer/Xcode/UserData/Provisioning Profiles"; do
  if [[ -d "$cache" ]]; then
    find "$cache" -type f -name '*.mobileprovision' -delete
  fi
done
echo 'S05_RC_LOCAL_PROFILE_CACHE_CLEARED'

# Proven unsigned archive path. Genuine distribution signing is checked after export.
private_command archive xcodebuild -project LectureAsset.xcodeproj -scheme LectureAsset \
  -configuration Release -destination 'generic/platform=iOS' \
  -archivePath "$archive" -derivedDataPath "$private_dir/DerivedData" \
  CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO \
  CURRENT_PROJECT_VERSION="$RC_BUILD" MARKETING_VERSION=0.1.0 archive
python3 scripts/s05_rc_verify.py --metadata "$archive/Products/Applications/Lecture Asset.app" "$evidence/archive-metadata.json"

bridge_archive="$private_dir/LectureAsset-EntitlementBridge.xcarchive"
python3 scripts/s05_rc_bridge.py "$archive" "$bridge_archive" App/LectureAsset.entitlements "$evidence/bridge.json"

private_command export xcodebuild -exportArchive -archivePath "$bridge_archive" \
  -exportOptionsPlist "$private_dir/export-options.plist" -exportPath "$export_dir" \
  -allowProvisioningUpdates -authenticationKeyPath "$key_file" \
  -authenticationKeyID "$APP_STORE_CONNECT_KEY_ID" -authenticationKeyIssuerID "$APP_STORE_CONNECT_ISSUER_ID"

ipa=$(find "$export_dir" -maxdepth 1 -type f -name '*.ipa' -print -quit)
[[ -n "$ipa" ]] || { echo 'S05_RC_SIGNED_IPA_MISSING'; exit 1; }
ditto -xk "$ipa" "$private_dir/unpacked"
python3 scripts/s05_rc_verify.py --signed "$private_dir/unpacked/Payload/Lecture Asset.app" "$ipa" "$evidence/signed-distribution.json"

python3 scripts/s05_rc_verify.py --digest "$ipa" "$evidence/signed-distribution.json" "$evidence/ipa-before-validation.json"
# Upload the exact already verified signed IPA, not an independently re-exported binary.
# API_PRIVATE_KEYS_DIR is Xcode altool's key-search mechanism; credentials stay temporary.
private_command validate xcrun altool --validate-app --file "$ipa" --type ios \
  --apiKey "$APP_STORE_CONNECT_KEY_ID" --apiIssuer "$APP_STORE_CONNECT_ISSUER_ID"
python3 scripts/s05_rc_verify.py --digest "$ipa" "$evidence/signed-distribution.json" "$evidence/ipa-before-upload.json"
private_command upload xcrun altool --upload-app --file "$ipa" --type ios \
  --apiKey "$APP_STORE_CONNECT_KEY_ID" --apiIssuer "$APP_STORE_CONNECT_ISSUER_ID"
python3 - "$evidence/upload.json" "$evidence/signed-distribution.json" <<'PY'
import json, sys
from pathlib import Path
signed = json.loads(Path(sys.argv[2]).read_text())
Path(sys.argv[1]).write_text(json.dumps({"version":"0.1.0", "build":signed["metadata"]["CFBundleVersion"], "upload":"ACCEPTED",
    "uploaded_ipa_sha256":signed["ipa_sha256"], "same_verified_signed_ipa":True,
    "testFlightInternalTestingOnly":"OMITTED", "appReview":"NOT_SUBMITTED"}, indent=2)+"\n")
PY
echo "S05_RC_UPLOAD_ACCEPTED version=0.1.0 build=$RC_BUILD"
swift scripts/s05_rc_status.swift "$key_file" poll "$evidence/asc-status.json"

python3 scripts/s05_rc_verify.py --manifest "$evidence" "$evidence/RELEASE_MANIFEST.json"
