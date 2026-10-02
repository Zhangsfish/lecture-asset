# Instructional tutorial

Four scenes only: Sweep to select / Capture-time order / Generate ZIP + PDF / Save, then clean up. Native SwiftUI PhaseAnimator and KeyframeAnimator drive local shapes and SF Symbols. Each scene plays once, settles on its final state, and supports immediate Next/Back/swipe/Skip. Scene four shows ZIP save confirmation before both cleanup choices. No real photo sampling, processing action, permission request or network content exists in the tutorial.

Next/Back/Done are pinned in a bottom safe-area footer; the teaching content remains scrollable. This fixes the maximum-text simulator finding where navigation could scroll below the viewport. The navigation title is inline so the scene title remains the primary heading.

The first-visit reservation is captured before job restoration and stored under Application Support/LectureAsset in a tiny file. Existing installations already have the job root, so an upgrade does not force tutorial playback. Retained jobs or failed restoration take precedence. About can replay the tutorial without constructing a new ProcessingModel or changing selection/recovery state.

Reduce Motion uses the same static scene results and accessibility descriptions. Tutorial persistence uses file I/O only, not UserDefaults. No new Required Reason API category is introduced; the existing app-container file-metadata reason remains applicable. PrivacyInfo.xcprivacy is unchanged.
