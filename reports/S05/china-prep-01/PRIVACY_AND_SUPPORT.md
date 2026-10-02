# Privacy manifest and support preparation

Status: **S05-A source preparation; no public page or App Store Connect changes.**

## Required-reason API inventory

| API/category | Actual source and purpose | App reason | Dependency position |
|---|---|---|---|
| Available disk capacity / Disk Space | `Packages/ArchiveCore/Sources/ArchiveCore/ArchiveBuilder.swift:44-46` queries `volumeAvailableCapacityForImportantUsageKey` to reject an archive that cannot fit locally, with a user-facing storage failure. | `E174.1` | App manifest declares this reason. |
| File metadata / File Timestamp | `App/ArchivePipeline.swift:65`, `App/ArchiveModel.swift:325` and `Packages/ArchiveCore/Sources/ArchiveCore/CompanionPDF.swift:240` use `FileManager.attributesOfItem` to size/verify App work files, PDF JPEG streams and ZIP identity. Access is limited to App-created files. | `C617.1` | App manifest declares this reason. |
| ZIP entry metadata / File Timestamp | ZIPFoundation 0.9.20 calls filesystem metadata APIs (`lstat`, modification dates) when adding/validating App-created entries. | `0A2A.1` | ZIPFoundation 0.9.20 includes its own `Sources/ZIPFoundation/Resources/PrivacyInfo.xcprivacy`, supplied as a SwiftPM resource in `Package@swift-5.9.swift`; dependency manifest should be retained in the built framework bundle. |
| UserDefaults | No S05-A addition or use found in App/ArchiveCore source. | Not declared | Re-audit if S05-B adds a tutorial viewed flag. |

App source: `AppResources/PrivacyInfo.xcprivacy`, referenced as a `LectureAsset` target resource in `project.yml`. CI [run 36967361233](https://github.com/Zhangsfish/lecture-asset/actions/runs/36967361233) parsed the built iPhone Release `.app/PrivacyInfo.xcprivacy` and found `E174.1` and `C617.1`. It also found and parsed `ZIPFoundation_ZIPFoundation.bundle/PrivacyInfo.xcprivacy` with `0A2A.1`. The manifest declares no tracking and no data collected by the App. This describes developer collection, not the data practices of user-chosen Share Sheet destinations or future web hosting. App Privacy labels require a separate App Store Connect review.

Apple references: [required-reason API categories](https://developer.apple.com/documentation/bundleresources/app-privacy-configuration/nsprivacyaccessedapitypes/nsprivacyaccessedapitype), [approved reasons](https://developer.apple.com/documentation/bundleresources/app-privacy-configuration/nsprivacyaccessedapitypes/nsprivacyaccessedapitypereasons), [adding a manifest](https://developer.apple.com/documentation/bundleresources/adding-a-privacy-manifest-to-your-app-or-third-party-sdk). Xcode Organizer's combined privacy report was **NOT_RUN**; this is source plus built-bundle verification, not an App Store privacy approval.

## Help and page sources

- In-app `App/AboutSupportView.swift` is local text, accessible before Photos authorization. Opening it does not construct a new processing model or request Photos access.
- `web/static/privacy.html` and `web/static/support.html` are unpublished static draft sources with no backend, scripts, analytics, forms, invented email, homepage or account data.
- Public support/privacy URLs and contact channel: **NOT_PROVIDED / NOT_PUBLISHED**. Their absence does not block S05-A implementation, but blocks public page/RC completion. Host reachability and server access logging remain to be assessed after the owner chooses a host.
- No Photos, OCR text, PHAsset ID, ZIP, private ledger or credentials are stored in this report or CI screenshot artifacts.
