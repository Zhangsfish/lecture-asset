# S05-D0 release preflight delivery

Status: **READY_FOR_AUDIT**. Preparation pack is ready for an owner release decision; **App Review submission is NOT ready**.
Task: tasks/S05_D0_RELEASE_PREFLIGHT.md.
Base main: 43e669b59f3a6135d21286bdecaa0444104b0575 (refetched before handoff, unchanged).
D0 implementation/source SHA: ec58f5b6cde84da9324232ce1ff63abe22bb413e.
Screenshot workflow/scope verification SHA: ff2850812bc4f168fb08db553b2a89a1462a7216; later implementation commit changed only the ASC diagnostic script.
Published page SHA: ab6d569f556c8bcf6c2b0a9eddbc25fb3384b4b4.
Accepted App SHA: **618cbb4fa25068f7d117c6da6007ad0e2aa96518**, Internal TestFlight **0.1.0 (30.1)** / VALID / INTERNAL_ONLY, rechecked by ASC API.
PR: https://github.com/Zhangsfish/lecture-asset/pull/10. Final reports-only head is pinned in the PR handoff body; reports committed after tested code do not change production/runtime/CI scripts.

## Scope

Implemented: public Privacy/Support deployment and verification; proposed zh-Hans/en store materials; Chinese synthetic lecture screenshots using accepted UI; read-only sanitized ASC queries; China/US primary-source preflight and explicit RC plan.

No App/Resources/package/schema/project/runtime changes. SOURCE_IDENTITY.json proves identical Git objects against accepted implementation and fetched main. No embedded README/lecture change, tutorial polish, signing/upload change, stress/WeChat/destructive retest, StoreKit, agreement, storefront switch, App Review or public App release. Public static pages alone were explicitly authorized.

Experimental ChatGPT code was reviewed and narrowed: changed branch dispatch, removed unnecessary raw Pages response artifact, limited ASC export fields, removed resource IDs, guarded API origin/refused redirects, replaced raw transport/error output, added build audience/metadata-presence-only evidence. Screenshot flow selects six safe lecture samples through actual UI. No experiment was treated as already audited.

## Acceptance mapping

| Criterion | Status | Evidence / limitations |
|---|---|---|
| Public HTTPS Privacy/Support | PASS | PRIVACY_SUPPORT.md / PUBLIC_URL_CHECK.json; anonymous200, source-matching hashes, links/contact/no script checks |
| China ISP reachability | NOT_CHECKED | Successful current host requests do not prove all mainland networks |
| Metadata bilingual pack | PASS (prepared) | METADATA_ZH/EN.md; lengths checked; legal copyright/age/privacy declarations owner pending; not applied to ASC |
| Native Chinese store screenshots | PASS (prepared) | SCREENSHOTS.md; five 6.9-inch RGB PNGs from real Release simulator UI, synthetic slides only |
| Accepted runtime frozen | PASS | SOURCE_IDENTITY.json; no protected production diff |
| Actual ASC API | PASS (read) | asc-preflight.json + run37120313730; no API mutation |
| ASC China UI warnings/identity/privacy label | NOT_CHECKED | Login/connection limits; no fabricated absence of warning |
| China filing applicability | UNRESOLVED | CHINA.md; current primary sources, targeted classification clarification required |
| US fallback | UNRESOLVED | US.md; current age-assurance rules, no automatic switch |
| Exact RC plan | PASS (plan) | RC_PLAN.md; 30.1 internal baseline is not submission-eligible; no upload |
| Final legal/account declarations | BLOCKED_OWNER_ACTION | Age/privacy/copyright/contact/account identity only through official portal |
| New signed distribution RC / App Review | NOT_RUN | Deliberately withheld pending gates and explicit authorization |
| Tips / commercial products | N/A | First release free, S05-C deferred |

## Actually executed

ENVIRONMENT.md records actual fetch/scope/content/Release UI/ASC commands. Public-content and protected-source checks exit0; metadata limits and existing 1024×1024 RGB icon checked; Git diff --check passed. New store-story UI test passes from fresh Release simulator build; no mock build/device substitution. Safe CI markers retained.

Pages deployment: https://github.com/Zhangsfish/lecture-asset/actions/runs/37120095070, attempt2 SUCCESS. Initial environment default allowed main only; first attempt rejected before steps. Exact D0 branch allowlist added under authorized static-site setup, preserving other protections. No unrestricted deploy policy.

ASC read-only final run: https://github.com/Zhangsfish/lecture-asset/actions/runs/37120313730, SUCCESS. Artifact11273007578 SHA256 e739664800a83b3767898919ea04f462b802b72359d1138d08adbca5bff59d51, expires2026-10-17; sanitized JSON committed so audit does not depend on retention.

## Owner gates, ordered

1. Review this PR, proposed text, screenshot set and published URLs. No owner broad QA needed.
2. Resolve China filing classification and inspect exact ASC China fields; inspect identity/810 obligations if official portal requires them. No identity/tax/banking data to chat or GitHub.
3. Confirm copyright wording and actual age/privacy/contact declarations. Current store version1.0, missing metadata/privacy URL, incomplete questionnaire and default automatic release need a later explicitly authorized portal-preparation action. D0 did not mutate ASC.
4. Approve exact initial storefront list. USA is not automatically cleared; unresolved state duties are a separate gate.
5. Once ready, authorize a distribution-eligible exact RC upload using the same runtime. INTERNAL_ONLY30.1 cannot be submitted; no needless internal rebuild performed.
6. Separately authorize App Review for the exact RC/storefronts. **Not authorized/performed here.**

## Safety and stop

No private photos/OCR/PHAsset IDs, raw Apple responses, JWTs, P8 contents or signing logs exported. Existing Secrets used only inside ephemeral Actions; private key cleanup trap. No deletion/share confirmation action, retained-owner job touched or test upload invoked. No falsely promised lossless backup/AI integration/storage release/legal exemption.

Await independent audit and owner release decision. Do not merge, write STATUS PASS, start another stage or submit Review.

Final screenshot run: https://github.com/Zhangsfish/lecture-asset/actions/runs/37120289721, SUCCESS; one Release simulator UI test, zero failures, 134.190 seconds. Artifact11273580611 SHA256 fbc4e06e9eb8770e73451cbc154db3b56969c3de7a864eb1aa61cbe7099c7518; exact five PNGs committed under screenshots/.
