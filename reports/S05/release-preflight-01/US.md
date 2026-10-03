# United States fallback card — factual preparation only

Date: 2026-10-03. Status: UNRESOLVED; not an approved substitute for China.

## Actual platform evidence

USA exists in Apple's current territory catalog. This app's availability-v2 and legacy relationship returned 404 (not created or not visible); USA selection/availability is NOT_CHECKED. No storefront changes were made. Same incomplete 1.0 version, age questionnaire, privacy URL/localization and reviewer-contact gates as CHINA.md apply.

## Age / consent / significant updates

Apple's [June 3 Texas update](https://developer.apple.com/news/?id=sg176nne) reports the injunction change and June 4 rollout for new Texas accounts. The current [Age assurance Q&A](https://developer.apple.com/support/age-assurance) distinguishes App Store age rating from developer duties and describes Declared Age Range, PermissionKit, consent revocation and significant-update handling. Current runtime does not implement those frameworks. A free local utility or low age rating is not sufficient evidence of exemption.

Primary state sources rechecked:

- [Texas SB2420 history](https://capitol.texas.gov/billlookup/History.aspx?Bill=SB2420&LegSess=89R&Sort=A): enacted bill history. Apple rollout information above is distinct from the statute's original date; no independent live court-docket closure performed.
- [Louisiana RS51:1773](https://legis.la.gov/legis/Law.aspx?d=1428945): developer age-category and consent duties, displayed effective July 1, 2026. [Definitions](https://legis.la.gov/legis/Law.aspx?d=1428942) include significant change; not restricted to paid apps.
- [Utah HB498 2026](https://le.utah.gov/Session/2026/bills/static/HB0498.html): retrieved official landing page; dynamic status/text was not fully exposed. A substitute bill is not proof of the final operative law. Final codification, effective dates, subsequent amendments and litigation remain UNRESOLVED.

This card does not declare nationwide legal clearance. Before choosing USA, determine current binding obligations and this app's applicability (including free/offline/iOS18 behavior). If runtime is required: establish legal basis, minimal Apple-signal design, no ID collection/backend, iOS18 compatibility, targeted sandbox tests, then obtain a separate scoped authorization. No runtime added here, no US switching, no region-specific denial based on guessed IP/location.

## Privacy / contact

Use published Privacy and Support URLs, accurate Photos-permission review story and real support contact. Apple [App Privacy definition](https://developer.apple.com/app-store/app-privacy-details/) distinguishes local processing and off-device collection, and requires all optional-feedback criteria before omitting collected support data. Proposed conservative support label and owner confirmation in METADATA_EN.md. Reviewer name/phone are official-portal inputs only; never inferred from GitHub/contact nickname.

## Stop

US is a factual fallback proposal, not READY_TO_SUBMIT. Availability, final privacy/age/contact declarations, state-law applicability and exact distributable RC remain gates. No Review submission or public availability claim.
