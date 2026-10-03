# App Privacy — NEEDS_FINAL_CONFIRMATION

**ASC label status: NEEDS_FINAL_CONFIRMATION. Data Not Collected is a reasonable candidate interpretation of the current code structure, not an approved or definitely correct final answer.**

Revision addresses the [independent review of PR #11](https://github.com/Zhangsfish/lecture-asset/pull/11#pullrequestreview-5401135314) at `1a7c38208705f13063e35ed11b103e7d84323f61`. The earlier recommendation conflated app-originated collection with subsequent external support correspondence. No runtime or public policy was changed.

## 1. What Lecture Asset itself does

`App/AboutSupportView.swift` invokes `openURL(mailto:zhangs.taq@gmail.com)`. It provides no support form, reads no user email address or message body, and pre-fills no user data, photos, OCR or logs. It uploads no mail contents and sends no support data to a developer backend. The user composes and sends any message in the external system Mail app.

Photos, OCR, JPEG, ZIP and PDF processing remain on device, with no developer upload, account, analytics, tracking or advertising. User-initiated system sharing is not automatic developer collection. External browser hosting logs are separate website data flows; they do not by themselves establish App Privacy collection by Lecture Asset.

**Current code evidence therefore supports no app-originated support-data collection.** A developer receiving a later voluntary message through Mail does not, without further interpretation, prove that Lecture Asset collected it from the app.

## 2. External support correspondence remains real

If the user actually sends mail, the developer may receive and retain the sender address, message body and possibly display name/signature to reply. That external support practice must be described truthfully in the public Privacy Policy regardless of the final ASC label. `web/static/privacy.html` already distinguishes voluntary mail and its support purpose; it was only read, not modified this round. Retention, deletion requests and any later change in support use must remain accurately described.

This report does not inspect the inbox, claim that names are stripped, or approve marketing/analytics use of support correspondence.

## 3. Apple definitions and the remaining interpretation

Rechecked 2026-10-03 against [Apple's primary App Privacy definitions](https://developer.apple.com/app-store/app-privacy-details/), not forum opinions. Apple frames labels around data collected from the app and defines collection by off-device transmission with access beyond immediate servicing. Its optional-disclosure criteria are cumulative and include user data provided through the app's own submission interface. Customer Support is a defined data type; App Functionality can include support.

Those definitions do not explicitly settle this bare `mailto:` handoff. Failure to demonstrate an in-app optional-feedback exception does **not** establish that an app with no support-data collection must disclose external Mail correspondence. The first question is whether this external flow falls within collection **from Lecture Asset** at all. Conversely, absence of an app uploader does not constitute Apple's final approval of a label.

**Minimum final confirmation:** in the portal guidance or a written Apple answer, confirm whether an app that only opens a bare `mailto:` URL, without collecting/pre-filling/transmitting user data, should count independently composed external support mail as collection from that app. Portal entry and Apple confirmation are **NOT_RUN** here. Do not submit a declaration on the strength of this report alone.

## 4. Two possible declaration routes

| Route | Proposed interpretation / fields | Authority and limit |
|---|---|---|
| Data Not Collected | Reasonable candidate under the present app code and external-Mail separation | NEEDS_FINAL_CONFIRMATION; not “definitely correct” |
| **CONSERVATIVE OWNER DISCLOSURE OPTION** | Email Address + Customer Support; App Functionality; Linked to User = Yes; Tracking = No | Optional conservative owner policy if chosen after final guidance; **not required by current code** |

For the conservative option only, retain Name as a conditional addition if sender display names/signatures are actually retained. Customer Support is the specific support-body category; do not automatically duplicate it as Other User Content or treat this app as a general mailbox reader. Do not add Photos, Location, Device ID or website IP logs merely because local images exist or external services are used.

## Owner confirmation, after the label interpretation is resolved

1. **Yes/No:** “Voluntary support correspondence is used only to reply/manage support, with no mailing list, advertising, analytics, sale or tracking.” This confirms a support policy fact, not an ASC label.
2. **Yes/No:** “Retained support mail includes sender names/signatures.” This informs the policy and any chosen conservative Name declaration; it does not automatically establish app-originated collection.

Then the owner selects the final label route using portal/Apple guidance. Neither route is approved or applied here. Any future age-assurance or support implementation needs a fresh assessment of its actual data flow. No App Privacy answer, account setting or public Privacy Policy was edited this round.
