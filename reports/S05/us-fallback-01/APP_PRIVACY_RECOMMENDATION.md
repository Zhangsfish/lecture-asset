# App Privacy — recommended owner answer

**Recommendation: disclose Email Address + Customer Support; App Functionality; Linked to User = Yes; Tracking = No. Do not select Data Not Collected for the assumed support workflow.**

The owner supplied the policy premise: after a user voluntarily sends support mail, the developer may retain the address and message to reply. This is a proposed declaration, not proof of the contents of an actual inbox or an ASC update.

## Paste / select these answers

| ASC item | Recommended answer | Reason |
|---|---|---|
| Do you or third-party partners collect data from this app? | Yes, conservatively for retained support correspondence | Optional external mail is deliberately offered by the app |
| Contact Info → Email Address | Selected | Needed to respond; retention allowed by owner premise |
| User Content → Customer Support | Selected | Support request body / voluntarily supplied support context |
| Purpose, for each selected type | App Functionality only | Replying to support; not marketing or analytics |
| Linked to user's identity, for each | Yes | Correspondence is linked through the sender address, even without an app account |
| Used for tracking, for each | No | No ad measurement, broker or cross-company tracking in this workflow |
| Other User Content | Not selected merely to duplicate the same support body | Customer Support is the more specific category |
| Emails or Text Messages | Not selected as a general mailbox/message-reader feature | The app does not read or upload a user's mail store; support request is classified above |
| Name | Select **if** sender display names / signatures are retained | Email-only/body-only premise does not prove named headers are stripped; see owner confirmation below |
| Photos/Videos, Audio, Location, identifiers, usage, diagnostics | Not selected for current local processing | No developer upload/collection code; no automatic mail attachment |

Apple defines collection as off-device transmission allowing access beyond immediate servicing, recognizes Customer Support as a data type, and includes support under App Functionality. Optional feedback may be omitted only when **all** exception conditions hold, including clear identity in an in-app submission interface. `mailto:` opens another app; this implementation does not prove that exception. Hence conservative disclosure. [Apple privacy definitions and optional-disclosure conditions](https://developer.apple.com/app-store/app-privacy-details/).

## Code / workflow evidence

- `App/AboutSupportView.swift`: user taps `mailto:zhangs.taq@gmail.com`; copy-email alternative; user-initiated external homepage. No attached photo, OCR, log or device information is prepared.
- `web/static/privacy.html`: support mail used only for replies; request deletion by email; no analytics/tracking scripts; separate GitHub hosting disclosure.
- Core photo/OCR/archive processing is local. The same local records being present on device does not mean the developer collects them. Photo Library permission and privacy manifests do not replace the ASC declaration.
- GitHub Pages and the external portfolio host may retain request IP logs. They are external website flows, with no embedded analytics/web SDK in this app. Do not mechanically add IP/coarse location, device ID or browsing history to the App Privacy label on that basis.
- System sharing goes to a user-chosen destination, not an automatic upload to the developer. Do not classify all shared lecture photos as developer collection.

## Owner final confirmation — two Yes/No items, no taxonomy research

1. **Yes/No:** “I will use and retain voluntary support correspondence only to reply/manage support; no mailing list, analytics, advertising, sale or tracking. I approve Email Address + Customer Support, App Functionality, linked, no tracking.”
2. **Yes/No:** “My retained support email includes sender names or signatures.” **Yes → also select Name with the same purpose/linkage/tracking answers. No → leave Name unselected only if names really are not retained.** This is an operational fact, not a reason to inspect or publish the inbox here.

No response was obtained this round. Do not turn the recommendation into an approved declaration. If optional attachments or diagnostic collection later becomes an actual support practice, review those data types rather than silently treating the two-category answer as permanent. A future age-assurance implementation also requires a fresh data-flow assessment; do not disclose nonexistent age collection today.

ASC path for later authorized action: My Apps → Lecture Asset → App Privacy → Edit. Owner selects the above types/uses; final preview must agree with the public privacy policy. [Apple ASC entry instructions](https://developer.apple.com/help/app-store-connect/manage-app-information/manage-app-privacy/).
