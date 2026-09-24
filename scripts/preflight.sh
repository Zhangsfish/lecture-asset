#!/usr/bin/env bash
# Read-only host check. Does not install tools, sign in, inspect keys or build an app.
set -u
printf 'Lecture Asset host preflight (not an app test)\n'
printf 'OS: '; uname -s
printf 'Architecture: '; uname -m
printf '\nGit: '; git --version 2>/dev/null || true
printf '\nSwift:\n'; command -v swift >/dev/null 2>&1 && swift --version || true
printf '\nXcodeGen:\n'; command -v xcodegen >/dev/null 2>&1 && xcodegen --version || true
if [ "$(uname -s)" != "Darwin" ]; then
  printf '\nBLOCKED_ENV: this host cannot run Xcode/iOS Simulator. Core/docs checks are not iOS build evidence.\n'
  exit 2
fi
printf '\nmacOS:\n'; sw_vers
if ! command -v xcodebuild >/dev/null 2>&1; then
  printf '\nBLOCKED_ENV: xcodebuild not available.\n'
  exit 2
fi
printf '\nXcode:\n'
if ! xcodebuild -version; then
  printf '\nBLOCKED_ENV: Xcode selection/license/toolchain needs owner attention.\n'
  exit 2
fi
printf '\nSDKs:\n'
if ! xcodebuild -showsdks; then exit 2; fi
printf '\nSimulator runtimes (no device identifiers):\n'
if ! xcrun simctl list runtimes; then exit 2; fi
printf '\nPREFLIGHT_RECORDED: inspect SDK/runtime suitability. No build, signing, device or App Store test performed.\n'
