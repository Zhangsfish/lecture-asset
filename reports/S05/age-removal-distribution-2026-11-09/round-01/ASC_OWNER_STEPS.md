# Owner App Store Connect closeout steps after 36.1 independent audit

**Authenticated state at 2026-11-09 13:44:41Z:**
- New candidate `0.1.0 (36.1)`: `VALID / APP_STORE_ELIGIBLE`, internally `IN_BETA_TESTING`.
- **Saved** age questionnaire: `Parental Controls=false`, `Age Assurance=false`, computed `FOUR_PLUS`. The owner screenshot agrees; **do not repeat the age question**.
- App Review still associates `0.1.0 (35.1)` and review state remains `REJECTED`; review Notes absent. Age questionnaire is app-level, not proof the selected binary changed.
- Current territory list: USA and CHN available=true; 173 other returned territories=false. `availableInNewTerritories=false`; free; `releaseType=AFTER_APPROVAL` as owner explicitly chose.
- R5 actual iPhone TestFlight installation/startup `NOT_RUN` in the last evidence. No current build physical video available to this audit.

## Next concrete steps — owner actions only

1. On iPhone TestFlight install/update Lecture Asset to **0.1.0 (36.1)** and open. Confirm normal entry and no age page (not a new Sandbox request). Do not delete personal Photos or reset existing jobs. If recording for Apple, use synthetic photos, film actual current build and actual normal flow; do not fabricate age UI or include private identifiers.
2. In App Store Connect → Lecture Asset → current iOS App 0.1.0 / rejected submission → Edit. In Build select processed **36.1**; remove association to 35.1 (does not delete build), Save. The exact UI may require App Review → View Issues & Messages → Resolve → Edit; Apple officially provides this path for Unresolved Issues. Re-open to confirm selection 36.1.
3. Review Notes: include truthful explanation of removed age feature and how to review native photo flow; include actual physical-demo video URL **only if verified and hosted with owner consent**. Don't claim an age demo exists in 36.1. Save. If attached screenshot, it must come from actual 36.1.
4. Use [APP_REVIEW_REPLY_DRAFT.md](APP_REVIEW_REPLY_DRAFT.md) after independent verification; reply in existing November8 App Review thread. According to portal workflow, `Add for Review → Resubmit to App Review` for the rejected updated binary when ready and owner explicitly decides to resubmit. Do not cancel/delete rejected item casually; Apple allows only one edit before resubmission.
5. Because `AFTER_APPROVAL` may publish automatically in selected USA+CHN regions, explicitly address the separate Texas/applicable developer-duty risk before pressing final Resubmit. **No claim of legal exemption** from Everwhile approval, rating 4+ or missing age module.

Official Apple steps:
- https://developer.apple.com/help/app-store-connect/manage-builds/choose-a-build-to-submit/
- https://developer.apple.com/help/app-store-connect/manage-submissions-to-app-review/manage-a-submission-with-unresolved-issues/
- https://developer.apple.com/help/app-store-connect/manage-submissions-to-app-review/reply-to-app-review-messages/
- https://developer.apple.com/help/app-review/after-submitting-for-review/review-status/
