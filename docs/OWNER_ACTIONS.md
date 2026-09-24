# Owner decisions and remaining owner-only actions

## Already decided

| Item | Decision / current state |
|---|---|
| Product | Lecture Asset, mainly self-use but public App Store distribution |
| Photo permission | Full Read & Write required |
| Max selection | 200 |
| Image | Full-resolution JPEG Q90, no crop/resize |
| Live Photo | Archive static still only; source deletion removes whole asset |
| Sharing | System Share Sheet; verify WeChat file transfer; no WeChat SDK |
| GitHub upload | Not in v0.1 |
| Local retention | Temporary recovery files only; purge after successful source cleanup |
| Languages | zh-Hans + English |
| Price | Free |
| First storefront | United States |
| Min OS | iOS 18 |
| Planned Bundle ID | com.zhangsfish.lectureasset |
| Repo license | MIT |
| Apple Developer Program | **Owner reports enrollment completed**; exact portal status still needs verification during TestFlight setup |
| Apple Account region | China-region account. This does not determine storefront availability; App Store Connect distribution region is configured separately |

## Still requires owner/environment action when reached

| Item | Status |
|---|---|
| Mac/Xcode/simulator | GitHub-hosted macOS CI is available for build/test; owner does not need to own a Mac |
| Real iPhone | Available to owner; TestFlight is the intended install/test path once signing/upload is configured |
| Developer Program portal status | Verify membership shows Active and latest agreements are accepted before signed upload |
| App Store Connect app record | Create/verify app record before first build upload |
| Bundle ID | Register/verify `com.zhangsfish.lectureasset` (or document collision adjustment) |
| Signing | Configure certificate/profile or approved automatic-signing path on GitHub-hosted macOS; secrets only in GitHub Actions Secrets |
| App Store Connect upload auth | Prefer API key/JWT if API access is approved; otherwise use an Apple-supported upload auth method. Never commit credentials |
| TestFlight internal testing | Add owner as internal tester after first processed build |
| WeChat installed on test iPhone/desktop | Needed S03/S04 to validate actual transfer path |
| Real lecture sample | Owner may test privately on device; never upload private lecture images to public GitHub |
| Support/privacy public contact/URL | Prepare before S05 |

Do not store Apple ID passwords, API private keys, certificates, provisioning profiles or app-specific passwords in this public repository or chat. Use GitHub Actions Secrets / secure local storage only.

The China-region Apple Account does **not** force China-mainland App Store distribution. v0.1 still targets the United States storefront first; China mainland can be added later if its regulatory requirements are satisfied.
