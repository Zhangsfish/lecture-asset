# Owner decisions and remaining owner-only actions

## Already decided

| Item | Decision |
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

## Still requires owner/environment action when reached

| Item | Status |
|---|---|
| Mac/Xcode/simulator | Codex must probe S00 host; owner supplies/authorizes Mac environment if missing |
| Real iPhone | Required for S00 selection gesture evidence and later PhotoKit/WeChat tests |
| Developer Program | Owner enrolls/pays/accepts agreements when release stage requires it |
| App Store Connect/signing | Owner authorizes on secure machine; no secrets in repo/chat |
| Bundle ID registration/name availability | Verify in Apple systems before S05 |
| WeChat installed on test iPhone/desktop | Needed S03/S04 to validate actual transfer path |
| Real lecture sample | Owner may test privately on device; never upload private lecture images to public GitHub |
| Support/privacy public contact/URL | Prepare before S05 |

Do not block source work on late-stage account items. Do not infer they are complete until actually checked.
