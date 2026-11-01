#!/usr/bin/env bash
# Disposable simulator tests only. No Apple authentication/signing/upload path.
set -euo pipefail
kind="${1:?iphone or ipad}"
evidence="$RUNNER_TEMP/review-evidence"
mkdir -p "$evidence"
bundle=com.zhangsfish.lectureasset
derived="$RUNNER_TEMP/ReviewSimulator"
runtime=$(xcrun simctl list runtimes -j | python3 -c 'import json,sys; r=[x for x in json.load(sys.stdin)["runtimes"] if x["name"].startswith("iOS") and x["isAvailable"]]; print(sorted(r,key=lambda x:tuple(map(int,x["version"].split("."))))[-1]["identifier"])')
if [[ "$kind" == iphone ]]; then
  wanted='iPhone 17 Pro Max'
else
  wanted='iPad Air 11-inch (M3)'
fi
device_type=$(xcrun simctl list devicetypes -j | python3 -c 'import json,sys; name=sys.argv[1]; print(next(x["identifier"] for x in json.load(sys.stdin)["devicetypes"] if x["name"]==name))' "$wanted")
swift scripts/s00_make_synthetic.swift "$RUNNER_TEMP/review-synthetic"
device=$(xcrun simctl create "Review $kind" "$device_type" "$runtime")
xcrun simctl boot "$device"
xcrun simctl bootstatus "$device" -b
xcrun simctl addmedia "$device" "$RUNNER_TEMP/review-synthetic/01.jpg"
# Reuse only this disposable simulator across locales. Each scenario still
# resets actual TCC; changing system language is followed by a real reboot.
for locale in en zh-Hans; do
  xcrun simctl spawn "$device" defaults write NSGlobalDomain AppleLanguages -array "$locale"
  if [[ "$locale" == en ]]; then
    class=AppReviewEnglishPermissionUITests
    calendar=en_US
  else
    class=AppReviewChinesePermissionUITests
    calendar=zh_CN
  fi
  xcrun simctl spawn "$device" defaults write NSGlobalDomain AppleLocale -string "$calendar"
  xcrun simctl shutdown "$device"
  xcrun simctl boot "$device"
  xcrun simctl bootstatus "$device" -b
  base=(xcodebuild -project LectureAsset.xcodeproj -scheme LectureAsset -configuration Release
    -destination "platform=iOS Simulator,id=$device" -derivedDataPath "$derived"
    CURRENT_PROJECT_VERSION="${RC_BUILD:-35.1}" MARKETING_VERSION=0.1.0 ENABLE_TESTABILITY=YES ONLY_ACTIVE_ARCH=YES CODE_SIGN_IDENTITY=- CODE_SIGNING_ALLOWED=YES
    -parallel-testing-enabled NO)
  run_test() {
    local name="$1"; shift
    if "${base[@]}" -resultBundlePath "$RUNNER_TEMP/review-$kind-$locale-$name.xcresult" "$@" test-without-building > "$RUNNER_TEMP/review-$kind-$locale-$name.log" 2>&1; then
      echo "REVIEW_TEST_PASS $kind $locale $name"
    else
      tail -n 90 "$RUNNER_TEMP/review-$kind-$locale-$name.log"
      return 1
    fi
  }
  "${base[@]}" build-for-testing > "$RUNNER_TEMP/review-$kind-$locale-build.log" 2>&1 || {
    tail -n 90 "$RUNNER_TEMP/review-$kind-$locale-build.log"; exit 1;
  }
  if [[ "$kind-$locale" == iphone-en ]]; then
    run_test contracts -only-testing:LectureAssetTests/AgeAssuranceTests \
      -only-testing:LectureAssetTests/LocalizationResourceTests \
      -only-testing:LectureAssetTests/S01RecoveryTests -only-testing:LectureAssetTests/S03CleanupTests
  fi
  for phase in Denied FullAccess Limited; do
    xcrun simctl terminate "$device" "$bundle" >/dev/null 2>&1 || true
    xcrun simctl privacy "$device" reset all "$bundle"
    run_test "$phase-ui" -only-testing:"LectureAssetUITests/$class/testContinueThen$phase"
    container=$(xcrun simctl get_app_container "$device" "$bundle" data)
    case "$phase" in
      Denied) expected=denied ;;
      FullAccess) expected=authorized ;;
      Limited) expected=limited ;;
    esac
    mkdir -p "$container/tmp"
    printf '%s' "$expected" > "$container/tmp/review-permission-expected.txt"
    run_test "$phase-native-status" -only-testing:LectureAssetTests/AppReviewPermissionStateTests/testHostPreparedReadWriteAuthorization
    # Xcode may reinstall the host into a new data-container URL between runs.
    # Resolve it again after the test; never reuse the pre-install path.
    container=$(xcrun simctl get_app_container "$device" "$bundle" data)
    cp "$container/tmp/review-permission-observed.json" "$evidence/$kind-$locale-$phase-native.json"
  done
  python3 scripts/check_age_release.py "$derived/Build/Products/Release-iphonesimulator/Lecture Asset.app" "$evidence/$kind-$locale-simulator-entitlement.json"
done
xcrun simctl shutdown "$device"
