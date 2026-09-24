# App Store delivery plan

This is a plan, not release evidence. Submission-day Apple requirements must be rechecked.

## Product release choices

- Name: Lecture Asset
- Planned Bundle ID: `com.zhangsfish.lectureasset`
- Minimum OS: iOS 18
- Languages: Simplified Chinese + English
- Price: Free
- No IAP, subscription, ads, login or analytics
- First storefront: United States
- China mainland distribution: not required for v0.1
- Source license: MIT

## Photo permission review story

The app intentionally requires full Photo Library Read & Write. Review notes must explain:

1. the app shows the user's library in a custom grid with drag-across batch selection;
2. it sorts selected assets by PhotoKit capture time;
3. after a complete external archive is shared and the user explicitly confirms, it deletes exactly those source assets to free phone storage;
4. limited access cannot deliver that product behavior reliably, so limited/denied states are blocked rather than silently degraded.

No camera/microphone/location permission is requested.

## Distribution states

SOURCE_READY → SIMULATOR_VERIFIED → DEVICE_MVP_VERIFIED → TESTFLIGHT_VERIFIED → SUBMITTED → APP_STORE_LIVE.

Only public storefront availability is APP_STORE_LIVE.

## Release checklist

- current stable Xcode/SDK satisfies Apple submission requirements;
- Developer Program and App Store Connect access available;
- Bundle ID registered and signing works;
- Info.plist photo usage text matches behavior;
- PrivacyInfo.xcprivacy reflects actual required-reason APIs and ZIPFoundation;
- MIT project license + third-party notices present;
- privacy/support URLs available (static GitHub Pages is acceptable);
- real screenshots from release build, icon, metadata, age rating, export compliance;
- privacy declaration says developer does not collect photo/OCR/analytics data;
- review notes explain local OCR, local work files, Share Sheet, source deletion and Live Photo motion omission;
- TestFlight build reruns end-to-end share/delete tests on a real iPhone.

## Privacy wording

Lecture Asset itself has no backend and does not send lecture content to the developer. Canonical processing and Vision OCR are on-device. The app disables network acquisition of iCloud-only source images; those must be downloaded by the user in Photos first. Once the user chooses a Share Sheet target such as WeChat, AirDrop or Files, that target/system controls transport under its own behavior.

After successful source cleanup the app deletes its job files. Photos Recently Deleted remains under Apple's/system behavior and the user controls it.

## App Review risks

- full-library permission must be clearly justified by core cleanup workflow;
- app must provide enough complete utility for minimum-functionality review;
- never claim a Share Sheet callback verifies a remote backup;
- never hide that Live Photo motion/audio is not archived before deleting the source.

If Apple rejects, preserve the actual reason and revise; no guarantee is made before review.
