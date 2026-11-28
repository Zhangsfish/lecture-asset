#!/usr/bin/env bash
# Explicit eBOOK public distribution only. No review or storefront mutations.
set -euo pipefail
set +x
umask 077

operation="${EBOOK_PUBLIC_OPERATION:-prepare-only}"
case "$operation" in prepare-only|upload|status-only) ;; *) echo EBOOK_PUBLIC_INVALID_OPERATION; exit 2 ;; esac
[[ "${EBOOK_EXPECTED_VERSION:-}" == 1.0 ]] || { echo EBOOK_PUBLIC_VERSION_REQUIRED; exit 2; }
python3 "$EBOOK_BRIDGE_SCRIPTS/ebook_public_contract.py" source
build_number="${GITHUB_RUN_NUMBER:?}.${GITHUB_RUN_ATTEMPT:?}"
[[ "$build_number" =~ ^[1-9][0-9]*\.[1-9][0-9]*$ ]] || { echo EBOOK_PUBLIC_INVALID_BUILD; exit 2; }
if [[ "$operation" == status-only ]]; then
  [[ "${EBOOK_RECHECK_BUILD:-}" =~ ^[1-9][0-9]*\.[1-9][0-9]*$ ]] || { echo EBOOK_PUBLIC_RECHECK_BUILD_REQUIRED; exit 2; }
fi

private_dir=$(mktemp -d "$RUNNER_TEMP/ebook-public.XXXXXX")
cleanup() {
  [[ "$private_dir" == "$RUNNER_TEMP"/ebook-public.* && -d "$private_dir" ]] || return
  rm -rf -- "$private_dir"
}
trap cleanup EXIT
archive_log="$private_dir/archive.log"
key_file=''

private_command() {
  local stage="$1"; shift
  if "$@" > "$private_dir/$stage.log" 2>&1; then
    echo "EBOOK_PUBLIC_STAGE_PASS $stage"
  else
    local result=$?
    echo "EBOOK_PUBLIC_STAGE_FAILED $stage exit=$result"
    python3 "$EBOOK_BRIDGE_SCRIPTS/ebook_testflight_diagnostics.py" "$private_dir/$stage.log"
    exit "$result"
  fi
}

if [[ "$operation" != prepare-only ]]; then
  for name in APPLE_TEAM_ID APP_STORE_CONNECT_KEY_ID APP_STORE_CONNECT_ISSUER_ID APP_STORE_CONNECT_PRIVATE_KEY; do
    [[ -n "${!name:-}" ]] || { echo "EBOOK_PUBLIC_MISSING_SETTING $name"; exit 2; }
  done
  [[ "$APPLE_TEAM_ID" =~ ^[A-Z0-9]{10}$ ]] || { echo EBOOK_PUBLIC_INVALID_TEAM; exit 2; }
  [[ "$APP_STORE_CONNECT_KEY_ID" =~ ^[A-Z0-9]{10}$ ]] || { echo EBOOK_PUBLIC_INVALID_KEY_ID; exit 2; }
  [[ "$APP_STORE_CONNECT_ISSUER_ID" =~ ^[0-9a-fA-F-]{36}$ ]] || { echo EBOOK_PUBLIC_INVALID_ISSUER; exit 2; }
  [[ "$APP_STORE_CONNECT_PRIVATE_KEY" == *'-----BEGIN PRIVATE KEY-----'* ]] || { echo EBOOK_PUBLIC_INVALID_PRIVATE_KEY; exit 2; }
  key_file="$private_dir/AuthKey_${APP_STORE_CONNECT_KEY_ID}.p8"
  printf '%s' "$APP_STORE_CONNECT_PRIVATE_KEY" > "$key_file"
  chmod 600 "$key_file"
  unset APP_STORE_CONNECT_PRIVATE_KEY
  export API_PRIVATE_KEYS_DIR="$private_dir"
  if [[ "$operation" == status-only ]]; then
    swift "$EBOOK_BRIDGE_SCRIPTS/ebook_public_status.swift" "$key_file" "$EBOOK_RECHECK_BUILD" poll
    exit $?
  fi
  # A previous accepted upload must never be re-exported/re-uploaded implicitly.
  swift "$EBOOK_BRIDGE_SCRIPTS/ebook_public_status.swift" "$key_file" "$build_number" preflight
fi

baseline_archive="$private_dir/eBOOK-no-map.xcarchive"
archive_path="$private_dir/eBOOK.xcarchive"
export_path="$private_dir/export"
link_map="$private_dir/link-map.txt"
export EBOOK_RELEASE_LINK_MAP="$link_map"
archive_release() {
  local destination="$1" generate_map="$2"
  private_command "archive-$generate_map" xcodebuild -project eBOOK.xcodeproj -scheme eBOOK \
    -configuration Release -destination 'generic/platform=iOS' \
    -archivePath "$destination" -derivedDataPath "$private_dir/DerivedData" \
    CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO \
    LD_GENERATE_MAP_FILE="$generate_map" LD_MAP_FILE_PATH="$link_map" \
    MARKETING_VERSION=1.0 CURRENT_PROJECT_VERSION="$build_number" archive
}
archive_release "$baseline_archive" NO
[[ ! -e "$link_map" ]] || { echo EBOOK_PUBLIC_UNEXPECTED_BASELINE_MAP; exit 2; }
archive_release "$archive_path" YES
[[ -s "$link_map" ]] || { echo EBOOK_PUBLIC_LINK_MAP_MISSING; exit 2; }
python3 "$EBOOK_BRIDGE_SCRIPTS/ebook_public_contract.py" metadata \
  "$archive_path/Products/Applications/eBOOK.app/Info.plist" "$build_number"
# Reuses the exact internal-path guard, including paired executable and 6+2 checks.
private_command packaging python3 "$EBOOK_BRIDGE_SCRIPTS/ebook_prepare_archive.py" \
  "$archive_path/Products/Applications/eBOOK.app" "$baseline_archive/Products/Applications/eBOOK.app"
cat "$private_dir/packaging.log"
if [[ "$operation" == prepare-only ]]; then
  echo "EBOOK_PUBLIC_PREPARED_NO_SIGNING_NO_UPLOAD version=1.0 build=$build_number source_sha=$EBOOK_TESTED_SHA"
  exit 0
fi

python3 "$EBOOK_BRIDGE_SCRIPTS/ebook_public_contract.py" options "$private_dir/export-options.plist"
private_command export xcodebuild -exportArchive -archivePath "$archive_path" \
  -exportOptionsPlist "$private_dir/export-options.plist" -exportPath "$export_path" \
  -allowProvisioningUpdates -authenticationKeyPath "$key_file" \
  -authenticationKeyID "$APP_STORE_CONNECT_KEY_ID" -authenticationKeyIssuerID "$APP_STORE_CONNECT_ISSUER_ID"
private_command signed-audit python3 "$EBOOK_BRIDGE_SCRIPTS/ebook_verify_export.py" "$export_path"
python3 "$EBOOK_BRIDGE_SCRIPTS/ebook_public_contract.py" signed "$export_path" "$build_number" \
  "$private_dir/signed-audit.log" "$private_dir/verified-ipa.json"
python3 "$EBOOK_BRIDGE_SCRIPTS/ebook_public_contract.py" digest "$export_path" "$private_dir/verified-ipa.json"
private_command validate python3 "$EBOOK_BRIDGE_SCRIPTS/ebook_validate_export.py" "$export_path"
python3 "$EBOOK_BRIDGE_SCRIPTS/ebook_public_contract.py" digest "$export_path" "$private_dir/verified-ipa.json"
ipa=$(python3 - "$export_path" <<'PY'
from pathlib import Path
import sys
ipas = list(Path(sys.argv[1]).glob('*.ipa'))
assert len(ipas) == 1
print(ipas[0])
PY
)
# This exact IPA was genuinely signed, verified, hashed and validated above.
private_command upload xcrun altool --upload-app --file "$ipa" --type ios \
  --apiKey "$APP_STORE_CONNECT_KEY_ID" --apiIssuer "$APP_STORE_CONNECT_ISSUER_ID" --output-format json
python3 "$EBOOK_BRIDGE_SCRIPTS/ebook_public_contract.py" digest "$export_path" "$private_dir/verified-ipa.json"
echo "EBOOK_PUBLIC_UPLOAD_ACCEPTED version=1.0 build=$build_number source_sha=$EBOOK_TESTED_SHA"
swift "$EBOOK_BRIDGE_SCRIPTS/ebook_public_status.swift" "$key_file" "$build_number" poll
