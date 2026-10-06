#!/usr/bin/env bash
# Owner-authorized 0.1.0 (32.1). No Review/ASC mutation except binary upload.
set -euo pipefail
set +x
umask 077

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
evidence="$RUNNER_TEMP/s05-rc-evidence"
mkdir -p "$evidence"
export API_PRIVATE_KEYS_DIR="$private_dir"
archive="$private_dir/LectureAsset-RC.xcarchive"
export_dir="$private_dir/export"

if [[ "${1:-upload}" == 'status-only' ]]; then
  swift scripts/s05_rc_status.swift "$key_file" poll "$evidence/asc-status.json"
  exit $?
fi
[[ "${1:-upload}" == 'upload' ]] || { echo 'S05_RC_INVALID_OPERATION'; exit 2; }

# Exact 32.1 must not exist; never re-upload this immutable build number.
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

private_command archive xcodebuild -project LectureAsset.xcodeproj -scheme LectureAsset \
  -configuration Release -destination 'generic/platform=iOS' \
  -archivePath "$archive" -derivedDataPath "$private_dir/DerivedData" \
  CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO CURRENT_PROJECT_VERSION=32.1 MARKETING_VERSION=0.1.0 archive
python3 scripts/s05_rc_verify.py --metadata "$archive/Products/Applications/Lecture Asset.app" "$evidence/archive-metadata.json"

private_command export xcodebuild -exportArchive -archivePath "$archive" \
  -exportOptionsPlist "$private_dir/export-options.plist" -exportPath "$export_dir" \
  -allowProvisioningUpdates -authenticationKeyPath "$key_file" \
  -authenticationKeyID "$APP_STORE_CONNECT_KEY_ID" -authenticationKeyIssuerID "$APP_STORE_CONNECT_ISSUER_ID"

ipa=$(find "$export_dir" -maxdepth 1 -type f -name '*.ipa' -print -quit)
[[ -n "$ipa" ]] || { echo 'S05_RC_SIGNED_IPA_MISSING'; exit 1; }
ditto -xk "$ipa" "$private_dir/unpacked"
python3 scripts/s05_rc_verify.py --signed "$private_dir/unpacked/Payload/Lecture Asset.app" "$ipa" "$evidence/signed-distribution.json"

# Upload the exact already verified signed IPA, not an independently re-exported binary.
# API_PRIVATE_KEYS_DIR is Xcode altool's key-search mechanism; credentials stay temporary.
private_command validate xcrun altool --validate-app --file "$ipa" --type ios \
  --apiKey "$APP_STORE_CONNECT_KEY_ID" --apiIssuer "$APP_STORE_CONNECT_ISSUER_ID"
private_command upload xcrun altool --upload-app --file "$ipa" --type ios \
  --apiKey "$APP_STORE_CONNECT_KEY_ID" --apiIssuer "$APP_STORE_CONNECT_ISSUER_ID"
python3 - "$evidence/upload.json" "$evidence/signed-distribution.json" <<'PY'
import json, sys
from pathlib import Path
signed = json.loads(Path(sys.argv[2]).read_text())
Path(sys.argv[1]).write_text(json.dumps({"version":"0.1.0", "build":"32.1", "upload":"ACCEPTED",
    "uploaded_ipa_sha256":signed["ipa_sha256"], "same_verified_signed_ipa":True,
    "testFlightInternalTestingOnly":"OMITTED", "appReview":"NOT_SUBMITTED"}, indent=2)+"\n")
PY
echo 'S05_RC_UPLOAD_ACCEPTED version=0.1.0 build=32.1'
swift scripts/s05_rc_status.swift "$key_file" poll "$evidence/asc-status.json"
